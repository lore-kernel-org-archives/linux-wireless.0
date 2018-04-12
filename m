Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbeDLEEv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 00:04:51 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH] ath10k:add support for multicast rate control
Date: Wed, 11 Apr 2018 21:04:46 -0700
Message-Id: <1523505886-14695-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180412_060455_943238_89FD7E4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Issues wmi command to firmware when multicast rate change is received
with the new BSS_CHANGED_MCAST_RATE flag.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bf05a36..63af46f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5419,8 +5419,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
-	int ret = 0;
+	struct ieee80211_supported_band *sband;
+	struct cfg80211_chan_def def;
 	u32 vdev_param, pdev_param, slottime, preamble;
+	int rate_index, ret = 0;
+	u8 rate;
+	enum nl80211_band band;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -5588,6 +5592,25 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 	}
 
+	if (changed & BSS_CHANGED_MCAST_RATE &&
+	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
+		band = def.chan->band;
+		sband = &ar->mac.sbands[band];
+		vdev_param = ar->wmi.vdev_param->mcast_data_rate;
+		rate_index = vif->bss_conf.mcast_rate[band] - 1;
+		rate = ATH10K_HW_MCS_RATE(sband->bitrates[rate_index].hw_value);
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac vdev %d mcast_rate %d\n",
+			   arvif->vdev_id, rate);
+
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+						vdev_param, rate);
+		if (ret)
+			ath10k_warn(ar,
+				    "failed to set mcast rate on vdev"
+				    " %i: %d\n", arvif->vdev_id,  ret);
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
1.9.1
