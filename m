Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36561 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2IHNYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2012 09:24:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.6] ath9k: make PA linearization optional, disabled by default and fix checks
Date: Sat,  8 Sep 2012 15:24:17 +0200
Message-Id: <1347110657-27100-1-git-send-email-nbd@openwrt.org> (sfid-20120908_152436_741194_1A9BD11D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some checks for PA linearization support checked ATH9K_HW_CAP_PAPRD and some
used the EEPROM ops, leading to issues in tx power handling, since those
two can be out of sync.

Disable the feature by default, since it has been reported that it can
cause damage to the rx path under some circumstances. It can now be enabled
for testing via debugfs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    4 ++++
 drivers/net/wireless/ath/ath9k/debug.c         |    2 ++
 drivers/net/wireless/ath/ath9k/hw.c            |    4 ----
 drivers/net/wireless/ath/ath9k/hw.h            |    3 +--
 drivers/net/wireless/ath/ath9k/link.c          |    2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 2588848..d066f25 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2982,6 +2982,10 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_RX_MASK:
 		return pBase->txrxMask & 0xf;
 	case EEP_PAPRD:
+		if (AR_SREV_9462(ah))
+			return false;
+		if (!ah->config.enable_paprd);
+			return false;
 		return !!(pBase->featureEnable & BIT(5));
 	case EEP_CHAIN_MASK_REDUCE:
 		return (pBase->miscConfiguration >> 0x3) & 0x1;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 68b643c..c8ef301 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1577,6 +1577,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    sc->debug.debugfs_phy, sc, &fops_tx_chainmask);
 	debugfs_create_file("disable_ani", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_disable_ani);
+	debugfs_create_bool("paprd", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			    &sc->sc_ah->config.enable_paprd);
 	debugfs_create_file("regidx", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			    sc, &fops_regidx);
 	debugfs_create_file("regval", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 48af401..4faf0a3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2497,10 +2497,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
 		pCap->txs_len = sizeof(struct ar9003_txs);
-		if (!ah->config.paprd_disable &&
-		    ah->eep_ops->get_eeprom(ah, EEP_PAPRD) &&
-		    !AR_SREV_9462(ah))
-			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
 		if (AR_SREV_9280_20(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6599a75..de6968f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -236,7 +236,6 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_LDPC			= BIT(6),
 	ATH9K_HW_CAP_FASTCLOCK			= BIT(7),
 	ATH9K_HW_CAP_SGI_20			= BIT(8),
-	ATH9K_HW_CAP_PAPRD			= BIT(9),
 	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(10),
 	ATH9K_HW_CAP_2GHZ			= BIT(11),
 	ATH9K_HW_CAP_5GHZ			= BIT(12),
@@ -287,12 +286,12 @@ struct ath9k_ops_config {
 	u8 pcie_clock_req;
 	u32 pcie_waen;
 	u8 analog_shiftreg;
-	u8 paprd_disable;
 	u32 ofdm_trig_low;
 	u32 ofdm_trig_high;
 	u32 cck_trig_high;
 	u32 cck_trig_low;
 	u32 enable_ani;
+	u32 enable_paprd;
 	int serialize_regmode;
 	bool rx_intr_mitigation;
 	bool tx_intr_mitigation;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 825a29c..7b88b9c 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -423,7 +423,7 @@ set_timer:
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) && ah->caldata) {
+	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD) && ah->caldata) {
 		if (!ah->caldata->paprd_done)
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
 		else if (!ah->paprd_table_write_done)
-- 
1.7.9.6 (Apple Git-31.1)

