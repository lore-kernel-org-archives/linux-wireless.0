Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61616 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3KVI6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 03:58:02 -0500
Received: by mail-wg0-f46.google.com with SMTP id m15so820811wgh.13
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 00:58:00 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH v2] mac80211_hwsim: claim CSA support for AP
Date: Fri, 22 Nov 2013 09:56:47 +0100
Message-Id: <1385110607-17962-1-git-send-email-karl.beldan@gmail.com> (sfid-20131122_095807_036777_D36648C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a11dc7c..3fa63bd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -168,6 +168,7 @@ struct hwsim_vif_priv {
 	u8 bssid[ETH_ALEN];
 	bool assoc;
 	bool bcn_en;
+	int csa_bcn_cnt;
 	u16 aid;
 };
 
@@ -1058,6 +1059,18 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
+
+	if (vif->csa_active) {
+		struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
+		vp->csa_bcn_cnt++;
+		if (ieee80211_csa_is_complete(vif)) {
+			wiphy_debug(hw->wiphy,
+				    "%s CSA complete after %d beacons\n",
+				    __func__, vp->csa_bcn_cnt);
+			ieee80211_csa_finish(vif);
+		}
+	}
 }
 
 static enum hrtimer_restart
@@ -1692,6 +1705,18 @@ static void mac80211_hwsim_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	hwsim_check_chanctx_magic(ctx);
 }
 
+static void mac80211_hwsim_channel_switch_beacon(struct ieee80211_hw *hw,
+						 struct ieee80211_vif *vif,
+						 struct cfg80211_chan_def *chandef)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
+	vp->csa_bcn_cnt = 0;
+	wiphy_debug(hw->wiphy, "%s (freq=%d(%d - %d)/%s)\n", __func__,
+		    chandef->chan->center_freq, chandef->center_freq1,
+		    chandef->center_freq2, hwsim_chanwidths[chandef->width]);
+}
+
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -1716,6 +1741,7 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.flush = mac80211_hwsim_flush,
 	.get_tsf = mac80211_hwsim_get_tsf,
 	.set_tsf = mac80211_hwsim_set_tsf,
+	.channel_switch_beacon = mac80211_hwsim_channel_switch_beacon,
 };
 
 
@@ -2359,7 +2385,9 @@ static int __init init_mac80211_hwsim(void)
 
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-				    WIPHY_FLAG_AP_UAPSD;
+				    WIPHY_FLAG_AP_UAPSD |
+				    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+
 		hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
 		/* ask mac80211 to reserve space for magic */
-- 
1.8.2

