Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49930 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751951AbdJCP0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 11:26:15 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/2] mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c
Date: Tue, 3 Oct 2017 20:49:44 +0530
Message-ID: <1507043984-9832-2-git-send-email-gbhat@marvell.com> (sfid-20171003_172619_902072_2C3C53EA)
In-Reply-To: <1507043984-9832-1-git-send-email-gbhat@marvell.com>
References: <1507043984-9832-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Douglas Anderson <dianders@chromium.org>

The sta_list_spinlock looks to be used to control locking of the
list. Specifically when someone has the lock they may be allowed
to modify or delete elements of the list.

That implies that we shouldn't access the fields of the elements
returned by mwifiex_get_sta_entry() after we've released the
spinlock. Let's make some small changes so this is true.

It's unlikely that this matters since it looks to be just error
handling, but it's nice to be clean.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 14 +++++++++-----
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  6 ++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index cc7d777..3638b613 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3794,9 +3794,8 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 
 	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 	sta_ptr = mwifiex_get_sta_entry(priv, addr);
-	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-
 	if (!sta_ptr) {
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		wiphy_err(wiphy, "%s: Invalid TDLS peer %pM\n",
 			  __func__, addr);
 		return -ENOENT;
@@ -3804,15 +3803,18 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 
 	if (!(sta_ptr->tdls_cap.extcap.ext_capab[3] &
 	      WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH)) {
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		wiphy_err(wiphy, "%pM do not support tdls cs\n", addr);
 		return -ENOENT;
 	}
 
 	if (sta_ptr->tdls_status == TDLS_CHAN_SWITCHING ||
 	    sta_ptr->tdls_status == TDLS_IN_OFF_CHAN) {
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		wiphy_err(wiphy, "channel switch is running, abort request\n");
 		return -EALREADY;
 	}
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 
 	chan = chandef->chan->hw_value;
 	second_chan_offset = mwifiex_get_sec_chan_offset(chan);
@@ -3833,18 +3835,20 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 
 	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 	sta_ptr = mwifiex_get_sta_entry(priv, addr);
-	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-
 	if (!sta_ptr) {
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		wiphy_err(wiphy, "%s: Invalid TDLS peer %pM\n",
 			  __func__, addr);
 	} else if (!(sta_ptr->tdls_status == TDLS_CHAN_SWITCHING ||
 		     sta_ptr->tdls_status == TDLS_IN_BASE_CHAN ||
 		     sta_ptr->tdls_status == TDLS_IN_OFF_CHAN)) {
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		wiphy_err(wiphy, "tdls chan switch not initialize by %pM\n",
 			  addr);
-	} else
+	} else {
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		mwifiex_stop_tdls_cs(priv, addr);
+	}
 }
 
 static int
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 839df8a..d8db412 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -359,13 +359,12 @@ static void mwifiex_process_uap_tx_pause(struct mwifiex_private *priv,
 	} else {
 		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 		sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
-		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-
 		if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
 			sta_ptr->tx_pause = tp->tx_pause;
 			mwifiex_update_ralist_tx_pause(priv, tp->peermac,
 						       tp->tx_pause);
 		}
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 	}
 }
 
@@ -396,14 +395,13 @@ static void mwifiex_process_sta_tx_pause(struct mwifiex_private *priv,
 		if (mwifiex_is_tdls_link_setup(status)) {
 			spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 			sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
-			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-
 			if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
 				sta_ptr->tx_pause = tp->tx_pause;
 				mwifiex_update_ralist_tx_pause(priv,
 							       tp->peermac,
 							       tp->tx_pause);
 			}
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 		}
 	}
 }
-- 
1.9.1
