Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40083 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZBJXgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 18:36:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 15:36:07 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: add comments for ath9k_hw_configpcipowersave()
Date: Tue, 10 Feb 2009 15:35:22 -0800
Message-ID: <1234308922-18365-1-git-send-email-lrodriguez@atheros.com> (sfid-20090211_003612_747864_5EB39303)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used for ASPM.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 72ca1c8..cfcaaf8 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2632,6 +2632,15 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	return status;
 }
 
+/*
+ * Helper for ASPM support.
+ *
+ * Disable PLL when in L0s as well as receiver clock when in L1.
+ * This power saving option must be enabled through the SerDes.
+ *
+ * Programming the SerDes must go through the same 288 bit serial shift
+ * register as the other analog registers.  Hence the 9 writes.
+ */
 void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 {
 	u8 i;
@@ -2639,13 +2648,20 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 	if (ah->is_pciexpress != true)
 		return;
 
+	/* Do not touch SerDes registers */
 	if (ah->config.pcie_powersave_enable == 2)
 		return;
 
+	/* Nothing to do on restore for 11N */
 	if (restore)
 		return;
 
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/*
+		 * AR9280 2.0 or later chips use SerDes values from the
+		 * initvals.h initialized depending on chipset during
+		 * ath9k_hw_do_attach()
+		 */
 		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
 			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
 				  INI_RA(&ah->iniPcieSerdes, i, 1));
@@ -2656,10 +2672,12 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
 
+		/* RX shut off when elecidle is asserted */
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
 
+		/* Shut off CLKREQ active in L1 */
 		if (ah->config.pcie_clock_req)
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
 		else
@@ -2669,29 +2687,46 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
 
+		/* Load the new settings */
 		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 
 		udelay(1000);
 	} else {
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+
+		/* RX shut off when elecidle is asserted */
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
+
+		/*
+		 * Ignore ah->ah_config.pcie_clock_req setting for
+		 * pre-AR9280 11n
+		 */
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
+
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
+
+		/* Load the new settings */
 		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 	}
 
+	/* set bit 19 to allow forcing of pcie core into L1 state */
 	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
+	/* Several PCIe massages to ensure proper behaviour */
 	if (ah->config.pcie_waen) {
 		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
 	} else {
 		if (AR_SREV_9285(ah))
 			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
+		/*
+		 * On AR9280 chips bit 22 of 0x4004 needs to be set to
+		 * otherwise card may disappear.
+		 */
 		else if (AR_SREV_9280(ah))
 			REG_WRITE(ah, AR_WA, AR9280_WA_DEFAULT);
 		else
-- 
1.5.6.3

