Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYHDIDs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/10] iwlwifi: HW bug fixes
Date: Mon,  4 Aug 2008 16:00:39 +0800
Message-Id: <1217836848-24288-2-git-send-email-yi.zhu@intel.com> (sfid-20080804_100351_890636_CA86D5E4)
In-Reply-To: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds few HW bug fixes.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-csr.h  |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-prph.h |   12 +++++++-----
 net/mac80211/mlme.c                     |    2 +-
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f7bbd12..1d793c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -93,6 +93,13 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
+	/* Set FH wait treshold to maximum (HW error during stress W/A) */
+	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+
+	/* enable HAP INTA to move device L1a -> L0s */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
+
 	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
 	/* set "initialization complete" bit to move adapter
@@ -230,6 +237,14 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
+	/* W/A : NIC is stuck in a reset state after Early PCIe power off
+	 * (PCIe power is lost before PERST# is asserted),
+	 * causing ME FW to lose ownership and not being able to obtain it back.
+	 */
+	 iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
+				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 545ed69..52629fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -104,6 +104,7 @@
  *  3-2:  0 = A, 1 = B, 2 = C, 3 = D step
  */
 #define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
+#define CSR_DBG_HPET_MEM_REG	(CSR_BASE+0x240)
 
 /* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR49_HW_IF_CONFIG_REG_BIT_4965_R	(0x00000010)
@@ -118,7 +119,12 @@
 #define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
 #define CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
 
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
+#define CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A		(0x00080000)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM		(0x00200000)
+#define CSR_HW_IF_CONFIG_REG_BIT_PCI_OWN_SEM		(0x00400000)
+#define CSR_HW_IF_CONFIG_REG_BIT_ME_OWN			(0x02000000)
+#define CSR_HW_IF_CONFIG_REG_BIT_WAKE_ME		(0x08000000)
+
 
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
@@ -236,6 +242,8 @@
 #define CSR39_ANA_PLL_CFG_VAL        (0x01000000)
 #define CSR50_ANA_PLL_CFG_VAL        (0x00880300)
 
+/* HPET MEM debug */
+#define CSR_DBG_HPET_MEM_REG_VAL	(0xFFFF0000)
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 70d9c75..ee5afd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -84,14 +84,16 @@
 #define APMG_CLK_VAL_DMA_CLK_RQT	(0x00000200)
 #define APMG_CLK_VAL_BSM_CLK_RQT	(0x00000800)
 
-#define APMG_PS_CTRL_VAL_RESET_REQ	(0x04000000)
 
-#define APMG_PCIDEV_STT_VAL_L1_ACT_DIS	(0x00000800)
+#define APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS	(0x00400000)
+#define APMG_PS_CTRL_VAL_RESET_REQ		(0x04000000)
+#define APMG_PS_CTRL_MSK_PWR_SRC		(0x03000000)
+#define APMG_PS_CTRL_VAL_PWR_SRC_VMAIN		(0x00000000)
+#define APMG_PS_CTRL_VAL_PWR_SRC_MAX		(0x01000000) /* 3945 only */
+#define APMG_PS_CTRL_VAL_PWR_SRC_VAUX		(0x02000000)
 
-#define APMG_PS_CTRL_MSK_PWR_SRC              (0x03000000)
-#define APMG_PS_CTRL_VAL_PWR_SRC_VMAIN        (0x00000000)
-#define APMG_PS_CTRL_VAL_PWR_SRC_VAUX         (0x01000000)
 
+#define APMG_PCIDEV_STT_VAL_L1_ACT_DIS		(0x00000800)
 
 /**
  * BSM (Bootstrap State Machine)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5358420..e1d11c9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3920,7 +3920,7 @@ done:
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
-		    (!ifsta->state == IEEE80211_IBSS_JOINED &&
+		    (!(ifsta->state == IEEE80211_IBSS_JOINED) &&
 		    !ieee80211_sta_active_ibss(dev)))
 			ieee80211_sta_find_ibss(dev, ifsta);
 	}
-- 
1.5.3.6

