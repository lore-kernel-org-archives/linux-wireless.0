Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55969 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:24 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so3927051eaj.25
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:23 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/62] iwlwifi: pcie: change CSR reset in family 8000
Date: Mon,  3 Feb 2014 22:57:11 +0200
Message-Id: <1391461088-8082-5-git-send-email-egrumbach@gmail.com> (sfid-20140203_215829_966217_E06D8F7E)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

This register is not present in 8000 family devices.
There is prph register instead.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   |    7 +++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c |    6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 100bd0d..fc3b6be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -105,6 +105,13 @@
 /* Device NMI register */
 #define DEVICE_SET_NMI_REG 0x00a01c30
 
+/*
+ * Device reset for family 8000
+ * write to bit 24 in order to reset the CPU
+*/
+#define RELEASE_CPU_RESET		(0x300C)
+#define RELEASE_CPU_RESET_BIT		BIT(24)
+
 /*****************************************************************************
  *                        7000/3000 series SHR DTS addresses                 *
  *****************************************************************************/
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f7e85d3..53a3457 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -573,6 +573,12 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 		}
 	}
 
+	/* release CPU reset */
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
+	else
+		iwl_write32(trans, CSR_RESET, 0);
+
 	return 0;
 }
 
-- 
1.7.9.5

