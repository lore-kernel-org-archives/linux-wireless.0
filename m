Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab1D0LlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:41:07 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so609306pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 04:41:07 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19896.364.834633.398595@gargle.gargle.HOWL> (sfid-20110427_134110_569052_6722B9AD)
Date: Wed, 27 Apr 2011 17:13:40 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 4/4] ath9k_htc: Add set_bitrate_mask() callback
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This callback is used to set the minimum rate for management
frames.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   50 +++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c8577d5..e9746e8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1659,6 +1659,55 @@ static void ath9k_htc_set_coverage_class(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 }
 
+/*
+ * Currently, this is used only for selecting the minimum rate
+ * for management frames, rate selection for data frames remain
+ * unaffected.
+ */
+static int ath9k_htc_set_bitrate_mask(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      const struct cfg80211_bitrate_mask *mask)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_rate_mask tmask;
+	struct ath9k_htc_vif *avp = (void *)vif->drv_priv;
+	int ret = 0;
+	u8 cmd_rsp;
+
+	memset(&tmask, 0, sizeof(struct ath9k_htc_target_rate_mask));
+
+	tmask.vif_index = avp->index;
+	tmask.band = IEEE80211_BAND_2GHZ;
+	tmask.mask = cpu_to_be32(mask->control[IEEE80211_BAND_2GHZ].legacy);
+
+	WMI_CMD_BUF(WMI_BITRATE_MASK_CMDID, &tmask);
+	if (ret) {
+		ath_err(common,
+			"Unable to set 2G rate mask for "
+			"interface at idx: %d\n", avp->index);
+		goto out;
+	}
+
+	tmask.band = IEEE80211_BAND_5GHZ;
+	tmask.mask = cpu_to_be32(mask->control[IEEE80211_BAND_5GHZ].legacy);
+
+	WMI_CMD_BUF(WMI_BITRATE_MASK_CMDID, &tmask);
+	if (ret) {
+		ath_err(common,
+			"Unable to set 5G rate mask for "
+			"interface at idx: %d\n", avp->index);
+		goto out;
+	}
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Set bitrate masks: 0x%x, 0x%x\n",
+		mask->control[IEEE80211_BAND_2GHZ].legacy,
+		mask->control[IEEE80211_BAND_5GHZ].legacy);
+out:
+	return ret;
+}
+
 struct ieee80211_ops ath9k_htc_ops = {
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
@@ -1681,4 +1730,5 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.set_rts_threshold  = ath9k_htc_set_rts_threshold,
 	.rfkill_poll        = ath9k_htc_rfkill_poll_state,
 	.set_coverage_class = ath9k_htc_set_coverage_class,
+	.set_bitrate_mask   = ath9k_htc_set_bitrate_mask,
 };
-- 
1.7.4.4

