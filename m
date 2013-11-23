Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54985 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3KWQjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Nov 2013 11:39:03 -0500
Received: by mail-we0-f169.google.com with SMTP id t60so2358123wes.0
        for <linux-wireless@vger.kernel.org>; Sat, 23 Nov 2013 08:39:01 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH v4] mac80211_hwsim: claim CSA support for AP
Date: Sat, 23 Nov 2013 17:38:18 +0100
Message-Id: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com> (sfid-20131123_173908_668501_266BDDDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

This assigns the channel_switch_beacon op.
For hwsim, it comes down to calling ieee80211_csa_finish once
ieee80211_csa_is_complete is true.
Since channel_switch_beacon is not called if CSA count starts @ 0 or 1,
the check for ieee80211_csa_is_complete can be done after getting the
beacon (and this way it might trigger helpful warnings).

This adds a per vif bool csa_finished that is set after a call to
ieee80211_csa_finish() and used to skip beaconing while csa_active is
set in case a beacon is scheduled prior to csa_finalize_work completion.
This bool and the number of beacons transmitted during the CSA up to the
call to ieee80211_csa_finish() are reset in channel_switch_beacon op.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 39 ++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a11dc7c..0fb6bb4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -169,6 +169,8 @@ struct hwsim_vif_priv {
 	bool assoc;
 	bool bcn_en;
 	u16 aid;
+	int csa_bcn_cnt;
+	bool csa_finished;
 };
 
 #define HWSIM_VIF_MAGIC	0x69537748
@@ -1024,6 +1026,7 @@ static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct mac80211_hwsim_data *data = arg;
 	struct ieee80211_hw *hw = data->hw;
 	struct ieee80211_tx_info *info;
@@ -1038,6 +1041,12 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	    vif->type != NL80211_IFTYPE_ADHOC)
 		return;
 
+	if (vif->csa_active && vp->csa_finished) {
+		wiphy_debug(hw->wiphy, "%s skip (CSA is active & finished)\n",
+			    __func__);
+		return;
+	}
+
 	skb = ieee80211_beacon_get(hw, vif);
 	if (skb == NULL)
 		return;
@@ -1058,6 +1067,17 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	mac80211_hwsim_tx_frame(hw, skb,
 				rcu_dereference(vif->chanctx_conf)->def.chan);
+
+	if (vif->csa_active) {
+		vp->csa_bcn_cnt++;
+		if (ieee80211_csa_is_complete(vif)) {
+			wiphy_debug(hw->wiphy,
+				    "%s CSA complete after %d beacons\n",
+				    __func__, vp->csa_bcn_cnt);
+			ieee80211_csa_finish(vif);
+			vp->csa_finished = 1;
+		}
+	}
 }
 
 static enum hrtimer_restart
@@ -1692,6 +1712,20 @@ static void mac80211_hwsim_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	hwsim_check_chanctx_magic(ctx);
 }
 
+static void mac80211_hwsim_channel_switch_beacon(struct ieee80211_hw *hw,
+						 struct ieee80211_vif *vif,
+						 struct cfg80211_chan_def *chandef)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
+	hwsim_check_magic(vif);
+	vp->csa_finished = 0;
+	vp->csa_bcn_cnt = 0;
+	wiphy_debug(hw->wiphy, "%s (freq=%d(%d - %d)/%s)\n", __func__,
+		    chandef->chan->center_freq, chandef->center_freq1,
+		    chandef->center_freq2, hwsim_chanwidths[chandef->width]);
+}
+
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -1716,6 +1750,7 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.flush = mac80211_hwsim_flush,
 	.get_tsf = mac80211_hwsim_get_tsf,
 	.set_tsf = mac80211_hwsim_set_tsf,
+	.channel_switch_beacon = mac80211_hwsim_channel_switch_beacon,
 };
 
 
@@ -2359,7 +2394,9 @@ static int __init init_mac80211_hwsim(void)
 
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

