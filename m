Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33645 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422791AbbEUTxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/10] iwlwifi: mvm: BT Coex - duplicate the command if sent ASYNC
Date: Thu, 21 May 2015 22:53:07 +0300
Message-Id: <1432237990-5890-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215348_009791_A06CE2ED)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are buses that can't handle ASYNC command without
copying them. Duplicate the host command instead.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index d954591..6ac6de2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -776,7 +776,7 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	struct iwl_host_cmd cmd = {
 		.id = BT_CONFIG,
 		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.dataflags = { IWL_HCMD_DFL_DUP, },
 		.flags = CMD_ASYNC,
 	};
 	struct iwl_mvm_sta *mvmsta;
-- 
2.1.4

