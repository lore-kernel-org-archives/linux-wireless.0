Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35649 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaEGUBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:01:35 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so1490798wgh.15
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 13:01:34 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/5] iwlwifi: mvm: BT Coex - fix validity flags during init
Date: Wed,  7 May 2014 23:01:21 +0300
Message-Id: <1399492884-13508-2-git-send-email-egrumbach@gmail.com> (sfid-20140507_220139_132486_B2A3C619)
In-Reply-To: <536A90BD.8010204@gmail.com>
References: <536A90BD.8010204@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The commit below introduced a bug in the validity bits in
init. Due to that, all the Coex mechanism stopped sending
kills to the BT side. Fix that.

Fixes: b9fae2d54c9f ("iwlwifi: mvm: BT Coex add support for Co-running block")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index fa858d54..0489314 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -611,14 +611,14 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_SYNC2SCO);
 
 	if (IWL_MVM_BT_COEX_CORUNNING) {
-		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_CORUN_LUT_20 |
-						    BT_VALID_CORUN_LUT_40);
+		bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_CORUN_LUT_20 |
+						     BT_VALID_CORUN_LUT_40);
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_CORUNNING);
 	}
 
 	if (IWL_MVM_BT_COEX_MPLUT) {
 		bt_cmd->flags |= cpu_to_le32(BT_COEX_MPLUT);
-		bt_cmd->valid_bit_msk = cpu_to_le32(BT_VALID_MULTI_PRIO_LUT);
+		bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_MULTI_PRIO_LUT);
 	}
 
 	if (mvm->cfg->bt_shared_single_ant)
-- 
1.8.3.2

