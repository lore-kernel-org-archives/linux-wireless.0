Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57258 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1BDGYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 01:24:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 22:23:54 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: Fix a race on enabling power save.
Date: Fri, 4 Feb 2011 11:54:00 +0530
Message-ID: <1296800640-6381-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race of queuing a data frame before the tx completion
of nullfunc frame for enabling power save. This has caused a power
save state mismatch between the station and the AP. This patch
addresses this issue.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    8 ++++++--
 net/mac80211/tx.c          |    6 ++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 533fd32..6ad97f6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -346,6 +346,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_PS_PENDING	= BIT(10),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e059b3a..45f736e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -727,13 +727,17 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		return;
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
+	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
+		ifmgd->flags |= IEEE80211_STA_PS_PENDING;
 		ieee80211_send_nullfunc(local, sdata, 1);
+	}
 
 	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
-	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
+	    ((ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED) &&
+	      ifmgd->flags & IEEE80211_STA_PS_PENDING))  {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8fbbc7a..25f576a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1574,6 +1574,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_sub_if_data *tmp_sdata;
+	struct ieee80211_if_managed *ifmgd;
 	int headroom;
 	bool may_encrypt;
 
@@ -1648,6 +1649,11 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 				return;
 			}
 
+	ifmgd = &sdata->u.mgd;
+	if (!(ieee80211_is_nullfunc(hdr->frame_control)) &&
+	    (ifmgd->flags & IEEE80211_STA_PS_PENDING))
+		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
+
 	ieee80211_set_qos_hdr(local, skb);
 	ieee80211_tx(sdata, skb, false);
 	rcu_read_unlock();
-- 
1.6.3.3

