Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3APN6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/6] iwlwifi: allow to zero SRAM
Date: Wed, 16 Jan 2013 14:58:36 +0100
Message-Id: <1358344719-26486-3-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145825_647880_AA6EDE7D)
In-Reply-To: <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
 <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Sending a NULL pointer to iwl_trans_write_mem allows now
to zero SRAM.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h  | 3 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b0d5c71..55a140a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -391,7 +391,8 @@ struct iwl_trans;
  * @read_prph: read a DWORD from a periphery register
  * @write_prph: write a DWORD to a periphery register
  * @read_mem: read device's SRAM in DWORD
- * @write_mem: write device's SRAM in DWORD
+ * @write_mem: write device's SRAM in DWORD. If %buf is %NULL, then the memory
+ *	will be zeroed.
  * @configure: configure parameters required by the transport layer from
  *	the op_mode. May be called several times before start_fw, can't be
  *	called after that.
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 2de5770..4028c03 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -815,7 +815,8 @@ static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
 	if (iwl_trans_grab_nic_access(trans, false)) {
 		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		for (offs = 0; offs < dwords; offs++)
-			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
+			iwl_write32(trans, HBUS_TARG_MEM_WDAT,
+				    vals ? vals[offs] : 0);
 		iwl_trans_release_nic_access(trans);
 	} else {
 		ret = -EBUSY;
-- 
1.8.0

