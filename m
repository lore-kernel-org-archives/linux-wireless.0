Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbbLUUvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/45] iwlwifi: mvm: remove an extra tab
Date: Mon, 21 Dec 2015 22:50:09 +0200
Message-Id: <1450731046-2796-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215112_459110_CE78910F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

Smatch prints a static checker warning here:

    drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c:386 iwl_dump_prph()
    warn: curly braces intended?

Curly braces are NOT intended, the extra tab was added by mistake in
commit 1a616dd2f171 ('iwlwifi: dump prph registers in a common place
for all transports').

type=cleanup

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 9fcabc5..a6985da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -383,7 +383,7 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 			*val++ = cpu_to_le32(iwl_read_prph_no_grab(trans,
 								   reg));
 
-			*data = iwl_fw_error_next_data(*data);
+		*data = iwl_fw_error_next_data(*data);
 	}
 
 	iwl_trans_release_nic_access(trans, &flags);
-- 
2.5.0

