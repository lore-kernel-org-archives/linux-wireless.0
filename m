Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab1GHQUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/21] iwlagn: allow application own the uCode operation
Date: Fri,  8 Jul 2011 08:46:26 -0700
Message-Id: <1310139989-27661-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182055_559575_E91406E2)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we open the door to allow application control the device behavior through
testmode, add command to allow application request the ownership of the uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 +++++
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   42 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   14 +++++++-
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b7e9fd1..fa0827f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1263,6 +1263,10 @@ struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 };
 
+/* uCode ownership */
+#define IWL_OWNERSHIP_DRIVER	0
+#define IWL_OWNERSHIP_TM	1
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1351,6 +1355,10 @@ struct iwl_priv {
 	int fw_index;			/* firmware we're trying to load */
 	u32 ucode_ver;			/* version of ucode, copy of
 					   iwl_ucode.ver */
+
+	/* uCode owner: default: IWL_OWNERSHIP_DRIVER */
+	u8 ucode_owner;
+
 	struct fw_img ucode_rt;
 	struct fw_img ucode_init;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 653b787..ed9bd91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -105,6 +105,7 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 
 	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
 
+	[IWL_TM_ATTR_UCODE_OWNER] = { .type = NLA_U8, },
 };
 
 /*
@@ -587,6 +588,42 @@ static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 	return -ENOBUFS;
 }
 
+/*
+ * This function handles the user application switch ucode ownership.
+ *
+ * It retrieves the mandatory fields IWL_TM_ATTR_UCODE_OWNER and
+ * decide who the current owner of the uCode
+ *
+ * If the current owner is OWNERSHIP_TM, then the only host command
+ * can deliver to uCode is from testmode, all the other host commands
+ * will dropped.
+ *
+ * default driver is the owner of uCode in normal operational mode
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @tb: gnl message fields from the user space
+ */
+static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
+{
+	struct iwl_priv *priv = hw->priv;
+	u8 owner;
+
+	if (!tb[IWL_TM_ATTR_UCODE_OWNER]) {
+		IWL_DEBUG_INFO(priv, "Error finding ucode owner\n");
+		return -ENOMSG;
+	}
+
+	owner = nla_get_u8(tb[IWL_TM_ATTR_UCODE_OWNER]);
+	if ((owner == IWL_OWNERSHIP_DRIVER) || (owner == IWL_OWNERSHIP_TM))
+		priv->ucode_owner = owner;
+	else {
+		IWL_DEBUG_INFO(priv, "Invalid owner\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+
 /* The testmode gnl message handler that takes the gnl message from the
  * user space and parses it per the policy iwl_testmode_gnl_msg_policy, then
  * invoke the corresponding handlers.
@@ -656,6 +693,11 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		result = iwl_testmode_trace(hw, tb);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_OWNERSHIP:
+		IWL_DEBUG_INFO(priv, "testmode change uCode ownership\n");
+		result = iwl_testmode_ownership(hw, tb);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode command\n");
 		result = -ENOSYS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index d825188..b980bda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -103,6 +103,10 @@
  * @IWL_TM_CMD_DEV2APP_EEPROM_RSP:
  *	commands from kernel space to carry the eeprom response
  *	to user application
+ * @IWL_TM_CMD_APP2DEV_OWNERSHIP:
+ *	commands from user application to own change the ownership of the uCode
+ *	if application has the ownership, the only host command from
+ *	testmode will deliver to uCode. Default owner is driver
  */
 enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_UCODE		= 1,
@@ -121,7 +125,8 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_DEV2APP_SYNC_RSP		= 14,
 	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT		= 15,
 	IWL_TM_CMD_DEV2APP_EEPROM_RSP		= 16,
-	IWL_TM_CMD_MAX				= 17,
+	IWL_TM_CMD_APP2DEV_OWNERSHIP		= 17,
+	IWL_TM_CMD_MAX				= 18,
 };
 
 /*
@@ -187,6 +192,10 @@ enum iwl_tm_cmd_t {
  *	The mandatory fields are:
  *	IWL_TM_ATTR_FIXRATE for the fixed rate
  *
+ * @IWL_TM_ATTR_UCODE_OWNER:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_OWNERSHIP,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_UCODE_OWNER for the new owner
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -203,7 +212,8 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_TRACE_SIZE			= 11,
 	IWL_TM_ATTR_TRACE_DUMP			= 12,
 	IWL_TM_ATTR_FIXRATE			= 13,
-	IWL_TM_ATTR_MAX				= 14,
+	IWL_TM_ATTR_UCODE_OWNER			= 14,
+	IWL_TM_ATTR_MAX				= 15,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

