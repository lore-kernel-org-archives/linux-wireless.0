Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44237 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaEGTyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:54:09 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1978394wib.7
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:54:08 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/23] iwlwifi: mvm: fix sparse warning when _DEBUGFS isn't set
Date: Wed,  7 May 2014 22:52:59 +0300
Message-Id: <1399492380-12050-22-git-send-email-egrumbach@gmail.com> (sfid-20140507_215426_313673_C3526E0A)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the declaration of iwl_mvm_fw_error_rxf_dump and
iwl_mvm_fw_error_sram_dump is under
ifdef CONFIG_IWLWIFI_DEBUGFS, do the same for their
implementation.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index c5f4532..4c3577e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -519,6 +519,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		iwl_mvm_dump_umac_error_log(mvm);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm)
 {
 	const struct fw_img *img;
@@ -581,6 +582,7 @@ void iwl_mvm_fw_error_rxf_dump(struct iwl_mvm *mvm)
 	}
 	iwl_trans_release_nic_access(mvm->trans, &flags);
 }
+#endif
 
 /**
  * iwl_mvm_send_lq_cmd() - Send link quality command
-- 
1.8.3.2

