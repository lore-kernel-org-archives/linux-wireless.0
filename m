Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab0DODaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 57/97] ath9k_hw: add the config_pci_powersave AR9003 callback
Date: Wed, 14 Apr 2010 23:30:11 -0400
Message-Id: <1271302251-9075-58-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6c092ee..240ca4c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2595,6 +2595,37 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 }
 EXPORT_SYMBOL(ath9k_hw_set_interrupts);
 
+/*
+ * Helper for ASPM support.
+ *
+ * Disable PLL when in L0s as well as receiver clock when in L1.
+ * This power saving option must be enabled through the SerDes.
+ *
+ * Programming the SerDes must go through the same 288 bit serial shift
+ * register as the other analog registers.  Hence the 9 writes.
+ */
+static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
+					 int restore,
+					 int power_off)
+{
+	if (ah->is_pciexpress != true)
+		return;
+
+	/* Do not touch SerDes registers */
+	if (ah->config.pcie_powersave_enable == 2)
+		return;
+
+	/* Nothing to do on restore for 11N */
+	if (!restore) {
+		/* set bit 19 to allow forcing of pcie core into L1 state */
+		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+
+		/* Several PCIe massages to ensure proper behaviour */
+		if (ah->config.pcie_waen)
+			REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
+	}
+}
+
 /*******************/
 /* Beacon Handling */
 /*******************/
@@ -3629,10 +3660,13 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 static void ar9003_hw_attach_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	priv_ops->init_mode_regs = ar9003_hw_init_mode_regs;
 	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
 
+	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
+
 	ar9003_hw_attach_phy_ops(ah);
 	ar9003_hw_attach_calib_ops(ah);
 	ar9003_hw_attach_mac_ops(ah);
-- 
1.6.3.3

