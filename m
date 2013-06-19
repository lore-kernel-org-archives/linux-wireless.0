Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57081 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab3FSVCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 17:02:33 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH-WN 1/2] ath9k_htc: Support reporting tx and rx chain mask.
Date: Wed, 19 Jun 2013 14:02:14 -0700
Message-Id: <1371675735-28591-1-git-send-email-greearb@candelatech.com> (sfid-20130619_230237_944385_087ED789)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against wireless-next, and has been in my 3.9 tree for
some time.

 drivers/net/wireless/ath/ath9k/htc.h           |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   16 +---------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c  |    7 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |   38 ++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6958103..6bd556d 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -583,6 +583,8 @@ bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
 void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
 void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
 
+struct base_eep_header *ath9k_htc_get_eeprom_base(struct ath9k_htc_priv *priv);
+
 #ifdef CONFIG_MAC80211_LEDS
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 87110de5..632d13d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -496,21 +496,7 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 	ssize_t retval = 0;
 	char *buf;
 
-	/*
-	 * This can be done since all the 3 EEPROM families have the
-	 * same base header upto a certain point, and we are interested in
-	 * the data only upto that point.
-	 */
-
-	if (AR_SREV_9271(priv->ah))
-		pBase = (struct base_eep_header *)
-			&priv->ah->eeprom.map4k.baseEepHeader;
-	else if (priv->ah->hw_version.usbdev == AR9280_USB)
-		pBase = (struct base_eep_header *)
-			&priv->ah->eeprom.def.baseEepHeader;
-	else if (priv->ah->hw_version.usbdev == AR9287_USB)
-		pBase = (struct base_eep_header *)
-			&priv->ah->eeprom.map9287.baseEepHeader;
+	pBase = ath9k_htc_get_eeprom_base(priv);
 
 	if (pBase == NULL) {
 		ath_err(common, "Unknown EEPROM type\n");
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index bb0ba9e..925c5b0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -716,6 +716,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			       struct ieee80211_hw *hw)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct base_eep_header *pBase;
 
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_AMPDU_AGGREGATION |
@@ -771,6 +772,12 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 				     &priv->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
+	pBase = ath9k_htc_get_eeprom_base(priv);
+	if (pBase) {
+		hw->wiphy->available_antennas_rx = pBase->rxMask;
+		hw->wiphy->available_antennas_tx = pBase->txMask;
+	}
+
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index eaa94fe..ef68857 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1774,6 +1774,43 @@ static int ath9k_htc_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
+struct base_eep_header *ath9k_htc_get_eeprom_base(struct ath9k_htc_priv *priv)
+{
+	struct base_eep_header *pBase = NULL;
+	/*
+	 * This can be done since all the 3 EEPROM families have the
+	 * same base header upto a certain point, and we are interested in
+	 * the data only upto that point.
+	 */
+
+	if (AR_SREV_9271(priv->ah))
+		pBase = (struct base_eep_header *)
+			&priv->ah->eeprom.map4k.baseEepHeader;
+	else if (priv->ah->hw_version.usbdev == AR9280_USB)
+		pBase = (struct base_eep_header *)
+			&priv->ah->eeprom.def.baseEepHeader;
+	else if (priv->ah->hw_version.usbdev == AR9287_USB)
+		pBase = (struct base_eep_header *)
+			&priv->ah->eeprom.map9287.baseEepHeader;
+	return pBase;
+}
+
+
+static int ath9k_htc_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
+				 u32 *rx_ant)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	struct base_eep_header *pBase = ath9k_htc_get_eeprom_base(priv);
+	if (pBase) {
+		*tx_ant = pBase->txMask;
+		*rx_ant = pBase->rxMask;
+	} else {
+		*tx_ant = 0;
+		*rx_ant = 0;
+	}
+	return 0;
+}
+
 struct ieee80211_ops ath9k_htc_ops = {
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
@@ -1799,4 +1836,5 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.set_coverage_class = ath9k_htc_set_coverage_class,
 	.set_bitrate_mask   = ath9k_htc_set_bitrate_mask,
 	.get_stats	    = ath9k_htc_get_stats,
+	.get_antenna	    = ath9k_htc_get_antenna,
 };
-- 
1.7.3.4

