Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55569 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaKXOfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:22 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so5876658wiw.8
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/75] iwlwifi: pcie: newer platform needs a OS alive indication
Date: Mon, 24 Nov 2014 16:33:51 +0200
Message-Id: <1416839691-28533-15-git-send-email-egrumbach@gmail.com> (sfid-20141124_154346_925296_3F7B2AD3)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is fully backward compatible with older platforms.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    | 4 ++++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 3f6f015..9965717 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -129,6 +129,8 @@
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
 
+#define CSR_MBOX_SET_REG	(CSR_BASE + 0x88)
+
 #define CSR_LED_REG             (CSR_BASE+0x094)
 #define CSR_DRAM_INT_TBL_REG	(CSR_BASE+0x0A0)
 #define CSR_MAC_SHADOW_REG_CTRL	(CSR_BASE+0x0A8) /* 6000 and up */
@@ -184,6 +186,8 @@
 #define CSR_HW_IF_CONFIG_REG_PREPARE		  (0x08000000) /* WAKE_ME */
 #define CSR_HW_IF_CONFIG_REG_PERSIST_MODE	  (0x40000000) /* PERSISTENCE */
 
+#define CSR_MBOX_SET_REG_OS_ALIVE		BIT(5)
+
 #define CSR_INT_PERIODIC_DIS			(0x00) /* disable periodic int*/
 #define CSR_INT_PERIODIC_ENA			(0xFF) /* 255*32 usec ~ 8 msec*/
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d872749..12cb427 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -512,6 +512,9 @@ static int iwl_pcie_set_hw_ready(struct iwl_trans *trans)
 			   CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 			   HW_READY_TIMEOUT);
 
+	if (ret >= 0)
+		iwl_set_bit(trans, CSR_MBOX_SET_REG, CSR_MBOX_SET_REG_OS_ALIVE);
+
 	IWL_DEBUG_INFO(trans, "hardware%s ready\n", ret < 0 ? " not" : "");
 	return ret;
 }
-- 
1.9.1

