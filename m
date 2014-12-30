Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaL3OUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/33] iwlwifi: mvm: call to pcie_apply_destination also on family 8000 B step
Date: Tue, 30 Dec 2014 16:19:06 +0200
Message-Id: <1419949148-24046-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154347_792579_828711DD)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

In order to config the FW and to allocate monitor buffer driver should
run the function iwl_pcie_apply_destination immediately after FW sections
are loaded.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index daec2f8..09696ca 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -908,6 +908,9 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	if (ret)
 		return ret;
 
+	if (trans->dbg_dest_tlv)
+		iwl_pcie_apply_destination(trans);
+
 	/* Notify FW loading is done */
 	iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFFFFFF);
 
-- 
1.9.1

