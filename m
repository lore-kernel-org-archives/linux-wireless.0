Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0FUWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:38:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aeolus Yang <aeolus.yang@atheros.com>,
	Madhan Jaganathan <madhan.jaganathan@atheros.com>
Subject: [PATCH 3/5] ath9k_hw: add pcieSerDesWrite to disable SERDES ASPM tweaks
Date: Mon, 21 Jun 2010 18:38:49 -0400
Message-Id: <1277159931-7797-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
References: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful during testing of new ASPM tweaks which often
have to be done through the PCI Serializer-Deserializer (SERDES).

Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Madhan Jaganathan <madhan.jaganathan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c        |    1 +
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index efabab8..99bde5f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -303,7 +303,7 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 	 * Configire PCIE after Ini init. SERDES values now come from ini file
 	 * This enables PCIe low power mode.
 	 */
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
+	if (ah->config.pcieSerDesWrite) {
 		unsigned int i;
 
 		for (i = 0; i < ah->iniPcieSerdesLowPower.ia_rows; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3ee7d4e..e9764dc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -388,6 +388,7 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 		ah->config.ht_enable = 0;
 
 	ah->config.rx_intr_mitigation = true;
+	ah->config.pcieSerDesWrite = true;
 
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6c6d47b..e9578a4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -235,6 +235,7 @@ struct ath9k_ops_config {
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
 	u8 pcie_powersave_enable;
+	bool pcieSerDesWrite;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
 	u8 analog_shiftreg;
-- 
1.6.3.3

