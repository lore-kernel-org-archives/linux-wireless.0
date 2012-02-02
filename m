Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7687 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab2BCARA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:17:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 28/28] iwlwifi: range check to testmode direct reg access
Date: Thu,  2 Feb 2012 15:09:19 -0800
Message-Id: <1328224159-18134-29-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011722_301170_4A098B5C)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

Added a check on the direct register access.
Checks that the address is in the lower ragnge (0x0-0x2000),
which belongs to CSR, HBUS and FH registers.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 7c17b9d..df7ab33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -79,6 +79,7 @@
 #include "iwl-testmode.h"
 #include "iwl-trans.h"
 #include "iwl-bus.h"
+#include "iwl-fh.h"
 
 /* The TLVs used in the gnl message policy between the kernel module and
  * user space application. iwl_testmode_gnl_msg_policy is to be carried
@@ -288,7 +289,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 {
 	struct iwl_priv *priv = hw->priv;
-	u32 ofs, val32;
+	u32 ofs, val32, cmd;
 	u8 val8;
 	struct sk_buff *skb;
 	int status = 0;
@@ -300,7 +301,20 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 	ofs = nla_get_u32(tb[IWL_TM_ATTR_REG_OFFSET]);
 	IWL_INFO(priv, "testmode register access command offset 0x%x\n", ofs);
 
-	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
+	/* Allow access only to FH/CSR/HBUS in direct mode.
+	Since we don't have the upper bounds for the CSR and HBUS segments,
+	we will use only the upper bound of FH for sanity check. */
+	cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
+	if ((cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32 ||
+		cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32 ||
+		cmd == IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8) &&
+		(ofs >= FH_MEM_UPPER_BOUND)) {
+		IWL_DEBUG_INFO(priv, "offset out of segment (0x0 - 0x%x)\n",
+			FH_MEM_UPPER_BOUND);
+		return -EINVAL;
+	}
+
+	switch (cmd) {
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
 		val32 = iwl_read_direct32(trans(priv), ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
-- 
1.7.0.4

