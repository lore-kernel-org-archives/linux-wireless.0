Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48967 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab3LNRD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:58 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 06/11] ath9k_hw: remove ah->config.pcie_clock_req
Date: Sat, 14 Dec 2013 18:03:40 +0100
Message-Id: <1387040625-38114-6-git-send-email-nbd@openwrt.org> (sfid-20131214_180415_613286_290C550C)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is unused

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c | 8 ++------
 drivers/net/wireless/ath/ath9k/hw.c        | 1 -
 drivers/net/wireless/ath/ath9k/hw.h        | 1 -
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 5c95fd9..149aba3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -32,12 +32,8 @@ static int ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		return 0;
 	}
 
-	if (ah->config.pcie_clock_req)
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			   ar9280PciePhy_clkreq_off_L1_9280);
-	else
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			   ar9280PciePhy_clkreq_always_on_L1_9280);
+	INIT_INI_ARRAY(&ah->iniPcieSerdes,
+		       ar9280PciePhy_clkreq_always_on_L1_9280);
 
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a403cfc..eeb0741 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -446,7 +446,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.additional_swba_backoff = 0;
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
-	ah->config.pcie_clock_req = 0;
 	ah->config.analog_shiftreg = 1;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3a70682..b8e2476 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -283,7 +283,6 @@ struct ath9k_ops_config {
 	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
-	u8 pcie_clock_req;
 	u32 pcie_waen;
 	u8 analog_shiftreg;
 	u32 ofdm_trig_low;
-- 
1.8.3.4 (Apple Git-47)

