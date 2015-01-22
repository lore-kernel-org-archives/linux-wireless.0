Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbbAVUey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/38] iwlwifi: pcie: support secured boot flow for family 8000 B step
Date: Thu, 22 Jan 2015 22:33:28 +0200
Message-Id: <1421958809-3371-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214448_548584_A422CC6A)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The driver loads the 2 CPU sections, then it needs to let
the firmware know to start the authentication of the
sections. This is done by writing the relevants bits to
FH_UCODE_LOAD_STATUS.

For CPU1, the driver sets the lower 16 bits. For both CPUs,
the driver sets all the 32 bits.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 49e3206..1ff8767 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -722,6 +722,11 @@ static int iwl_pcie_load_cpu_sections_8000b(struct iwl_trans *trans,
 
 	*first_ucode_section = last_read_idx;
 
+	if (cpu == 1)
+		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFF);
+	else
+		iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFFFFFF);
+
 	return 0;
 }
 
@@ -911,9 +916,6 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	if (trans->dbg_dest_tlv)
 		iwl_pcie_apply_destination(trans);
 
-	/* Notify FW loading is done */
-	iwl_write_direct32(trans, FH_UCODE_LOAD_STATUS, 0xFFFFFFFF);
-
 	/* wait for image verification to complete  */
 	ret = iwl_poll_prph_bit(trans, LMPM_SECURE_BOOT_CPU1_STATUS_ADDR_B0,
 				LMPM_SECURE_BOOT_STATUS_SUCCESS,
-- 
1.9.1

