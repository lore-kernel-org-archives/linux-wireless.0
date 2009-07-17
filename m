Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934734AbZGQQa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/14] iwlagn: modify digital SVR for 1000
Date: Fri, 17 Jul 2009 09:30:14 -0700
Message-Id: <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

On 1000, there are two Switching Voltage Regulators (SVR). The first one
apply digital voltage level (1.32V) for PCIe block and core. We need to
use this regulator to solve a stability issue related to noisy DC2DC
line in the silicon.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-prph.h |    5 ++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 85e8bac..3f9da6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -239,6 +239,13 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_1000) {
+		/* Setting digital SVR for 1000 card to 1.32V */
+		iwl_set_bits_mask_prph(priv, APMG_DIGITAL_SVR_REG,
+					APMG_SVR_DIGITAL_VOLTAGE_1_32,
+					~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
+	}
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 3b9cac3..d393e8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -80,6 +80,8 @@
 #define APMG_RFKILL_REG			(APMG_BASE + 0x0014)
 #define APMG_RTC_INT_STT_REG		(APMG_BASE + 0x001c)
 #define APMG_RTC_INT_MSK_REG		(APMG_BASE + 0x0020)
+#define APMG_DIGITAL_SVR_REG		(APMG_BASE + 0x0058)
+#define APMG_ANALOG_SVR_REG		(APMG_BASE + 0x006C)
 
 #define APMG_CLK_VAL_DMA_CLK_RQT	(0x00000200)
 #define APMG_CLK_VAL_BSM_CLK_RQT	(0x00000800)
@@ -91,7 +93,8 @@
 #define APMG_PS_CTRL_VAL_PWR_SRC_VMAIN		(0x00000000)
 #define APMG_PS_CTRL_VAL_PWR_SRC_MAX		(0x01000000) /* 3945 only */
 #define APMG_PS_CTRL_VAL_PWR_SRC_VAUX		(0x02000000)
-
+#define APMG_SVR_VOLTAGE_CONFIG_BIT_MSK	(0x000001E0) /* bit 8:5 */
+#define APMG_SVR_DIGITAL_VOLTAGE_1_32		(0x00000060)
 
 #define APMG_PCIDEV_STT_VAL_L1_ACT_DIS		(0x00000800)
 
-- 
1.5.6.3

