Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33955 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbaGETd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 15:33:59 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3/3] iwlwifi: mvm: disable CTS to Self
Date: Sat,  5 Jul 2014 22:33:49 +0300
Message-Id: <1404588829-14168-3-git-send-email-egrumbach@gmail.com> (sfid-20140705_213406_918518_DF29CA74)
In-Reply-To: <53B852D4.5060109@gmail.com>
References: <53B852D4.5060109@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Firmware folks seem say that this flag can make trouble.
Drop it. The advantage of CTS to self is that it slightly
reduces the cost of the protection, but make the protection
less reliable.

Cc: <stable@vger.kernel.org> [3.13+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 8b53027..725ba49 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -667,10 +667,9 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
-	if (vif->bss_conf.use_cts_prot) {
+	if (vif->bss_conf.use_cts_prot)
 		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT);
-		cmd->protection_flags |= cpu_to_le32(MAC_PROT_FLG_SELF_CTS_EN);
-	}
+
 	IWL_DEBUG_RATE(mvm, "use_cts_prot %d, ht_operation_mode %d\n",
 		       vif->bss_conf.use_cts_prot,
 		       vif->bss_conf.ht_operation_mode);
-- 
1.8.3.2

