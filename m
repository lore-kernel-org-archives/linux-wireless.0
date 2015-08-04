Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbbHDU7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/37] iwlwifi: pcie: provide a way to stop configuration if it is forbidden
Date: Tue,  4 Aug 2015 23:43:16 +0300
Message-Id: <1438721007-23283-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_477748_E175F7A7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

The firmware debug infrastructure allows the user to
provide a firmware that will toggle a few registers to
configure the debugging capabilities.
On certain devices, certain operations are forbidden.
Executing a forbidden operation will cause the hardware to
die in a way that only driver unload / load will bring it
back to life.
Fortunately, there is a way to know in advance if those
operations will be accepted by the device. This is where
the new PRPH_BLOCKBIT operation plays its role. If the bit
X from PRPH register Y is set, then we should prevent any
further register configuration. When that happens, drop a
line in the kernel log since this is really an error state:
the user won't have his device configured as he expected.
Add operations that will be used in the future:
INDIRECT_ASSIGN, INDIRECT_SETBIT, and INDIRECT_CLEARBIT.

Other debugging configurations (such as destination
configuration for the monitor) will take place in any case.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 6 ++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c  | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index f99ec4e..884825c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -412,6 +412,12 @@ enum iwl_fw_dbg_reg_operator {
 	PRPH_ASSIGN,
 	PRPH_SETBIT,
 	PRPH_CLEARBIT,
+
+	INDIRECT_ASSIGN,
+	INDIRECT_SETBIT,
+	INDIRECT_CLEARBIT,
+
+	PRPH_BLOCKBIT,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 88ab79f..46e900e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -881,6 +881,14 @@ static void iwl_pcie_apply_destination(struct iwl_trans *trans)
 		case PRPH_CLEARBIT:
 			iwl_clear_bits_prph(trans, addr, BIT(val));
 			break;
+		case PRPH_BLOCKBIT:
+			if (iwl_read_prph(trans, addr) & BIT(val)) {
+				IWL_ERR(trans,
+					"BIT(%u) in address 0x%x is 1, stopping FW configuration\n",
+					val, addr);
+				goto monitor;
+			}
+			break;
 		default:
 			IWL_ERR(trans, "FW debug - unknown OP %d\n",
 				dest->reg_ops[i].op);
@@ -888,6 +896,7 @@ static void iwl_pcie_apply_destination(struct iwl_trans *trans)
 		}
 	}
 
+monitor:
 	if (dest->monitor_mode == EXTERNAL_MODE && trans_pcie->fw_mon_size) {
 		iwl_write_prph(trans, le32_to_cpu(dest->base_reg),
 			       trans_pcie->fw_mon_phys >> dest->base_shift);
-- 
2.1.4

