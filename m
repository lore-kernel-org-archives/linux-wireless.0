Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbbHDU65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/37] iwlwifi: pcie: Set scheduler to work on auto mode
Date: Tue,  4 Aug 2015 23:42:56 +0300
Message-Id: <1438721007-23283-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230049_054731_9ECBA7A5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

During NIC initialization shared HW is reset and this disables the
scheduler. Some HW platforms do not activate the scheduler after it.
Consequently all HCMD sent by the driver stay at the queues which cause
to queue stuck.
Set the scheduler to work on auto active mode so it would be activated upon
change over one of the queues' write pointer.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h | 1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 5af1c77..a846904 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -253,6 +253,7 @@
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
 #define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 #define SCD_GP_CTRL_ENABLE_31_QUEUES		BIT(0)
+#define SCD_GP_CTRL_AUTO_ACTIVE_MODE		BIT(18)
 
 /* Context Data */
 #define SCD_CONTEXT_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x600)
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 2b86c21..d711f0b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -915,6 +915,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		}
 	}
 
+	iwl_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
 	if (trans->cfg->base_params->num_of_queues > 20)
 		iwl_set_bits_prph(trans, SCD_GP_CTRL,
 				  SCD_GP_CTRL_ENABLE_31_QUEUES);
-- 
2.1.4

