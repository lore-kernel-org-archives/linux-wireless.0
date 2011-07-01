Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62949 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1GAPxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/11] iwlagn: re-define the testmode cmd and attr enum
Date: Fri,  1 Jul 2011 08:19:56 -0700
Message-Id: <1309533605-25774-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175312_919777_3D2389CF)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make sure not having issues when adding new testmode commands or attributes
in the future, re-define the enum. no functional changes

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.h |  236 +++++++++++++++------------
 1 files changed, 132 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 160911a..d825188 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -66,116 +66,144 @@
 #include <linux/types.h>
 
 
-/* Commands from user space to kernel space(IWL_TM_CMD_ID_APP2DEV_XX) and
+/*
+ * Commands from user space to kernel space(IWL_TM_CMD_ID_APP2DEV_XX) and
  * from and kernel space to user space(IWL_TM_CMD_ID_DEV2APP_XX).
- * The command ID is carried with IWL_TM_ATTR_COMMAND. There are three types of
- * of command from user space and two types of command from kernel space.
- * See below.
+ * The command ID is carried with IWL_TM_ATTR_COMMAND.
+ *
+ * @IWL_TM_CMD_APP2DEV_UCODE:
+ *	commands from user application to the uCode,
+ *	the actual uCode host command ID is carried with
+ *	IWL_TM_ATTR_UCODE_CMD_ID
+ *
+ * @IWL_TM_CMD_APP2DEV_REG_READ32:
+ * @IWL_TM_CMD_APP2DEV_REG_WRITE32:
+ * @IWL_TM_CMD_APP2DEV_REG_WRITE8:
+ *	commands from user applicaiton to access register
+ *
+ * @IWL_TM_CMD_APP2DEV_GET_DEVICENAME: retrieve device name
+ * @IWL_TM_CMD_APP2DEV_LOAD_INIT_FW: load initial uCode image
+ * @IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB: perform calibration
+ * @IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW: load runtime uCode image
+ * @IWL_TM_CMD_APP2DEV_GET_EEPROM: request EEPROM data
+ * @IWL_TM_CMD_APP2DEV_FIXRATE_REQ: set fix MCS
+ *	commands fom user space for pure driver level operations
+ *
+ * @IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
+ * @IWL_TM_CMD_APP2DEV_END_TRACE:
+ * @IWL_TM_CMD_APP2DEV_READ_TRACE:
+ *	commands fom user space for uCode trace operations
+ *
+ * @IWL_TM_CMD_DEV2APP_SYNC_RSP:
+ *	commands from kernel space to carry the synchronous response
+ *	to user application
+ * @IWL_TM_CMD_DEV2APP_UCODE_RX_PKT:
+ *	commands from kernel space to multicast the spontaneous messages
+ *	to user application
+ * @IWL_TM_CMD_DEV2APP_EEPROM_RSP:
+ *	commands from kernel space to carry the eeprom response
+ *	to user application
  */
 enum iwl_tm_cmd_t {
-	/* commands from user application to the uCode,
-	 * the actual uCode host command ID is carried with
-	 * IWL_TM_ATTR_UCODE_CMD_ID */
-	IWL_TM_CMD_APP2DEV_UCODE = 1,
-
-	/* commands from user applicaiton to access register */
-	IWL_TM_CMD_APP2DEV_REG_READ32,
-	IWL_TM_CMD_APP2DEV_REG_WRITE32,
-	IWL_TM_CMD_APP2DEV_REG_WRITE8,
-
-	/* commands fom user space for pure driver level operations */
-	IWL_TM_CMD_APP2DEV_GET_DEVICENAME,
-	IWL_TM_CMD_APP2DEV_LOAD_INIT_FW,
-	IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB,
-	IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW,
-	IWL_TM_CMD_APP2DEV_GET_EEPROM,
-	IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
-	/* if there is other new command for the driver layer operation,
-	 * append them here */
-
-	/* commands fom user space for uCode trace operations */
-	IWL_TM_CMD_APP2DEV_BEGIN_TRACE,
-	IWL_TM_CMD_APP2DEV_END_TRACE,
-	IWL_TM_CMD_APP2DEV_READ_TRACE,
-
-	/* commands from kernel space to carry the synchronous response
-	 * to user application */
-	IWL_TM_CMD_DEV2APP_SYNC_RSP,
-
-	/* commands from kernel space to multicast the spontaneous messages
-	 * to user application */
-	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT,
-
-	/* commands from kernel space to carry the eeprom response
-	 * to user application */
-	IWL_TM_CMD_DEV2APP_EEPROM_RSP,
-
-	IWL_TM_CMD_MAX,
+	IWL_TM_CMD_APP2DEV_UCODE		= 1,
+	IWL_TM_CMD_APP2DEV_REG_READ32		= 2,
+	IWL_TM_CMD_APP2DEV_REG_WRITE32		= 3,
+	IWL_TM_CMD_APP2DEV_REG_WRITE8		= 4,
+	IWL_TM_CMD_APP2DEV_GET_DEVICENAME	= 5,
+	IWL_TM_CMD_APP2DEV_LOAD_INIT_FW		= 6,
+	IWL_TM_CMD_APP2DEV_CFG_INIT_CALIB	= 7,
+	IWL_TM_CMD_APP2DEV_LOAD_RUNTIME_FW	= 8,
+	IWL_TM_CMD_APP2DEV_GET_EEPROM		= 9,
+	IWL_TM_CMD_APP2DEV_FIXRATE_REQ		= 10,
+	IWL_TM_CMD_APP2DEV_BEGIN_TRACE		= 11,
+	IWL_TM_CMD_APP2DEV_END_TRACE		= 12,
+	IWL_TM_CMD_APP2DEV_READ_TRACE		= 13,
+	IWL_TM_CMD_DEV2APP_SYNC_RSP		= 14,
+	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT		= 15,
+	IWL_TM_CMD_DEV2APP_EEPROM_RSP		= 16,
+	IWL_TM_CMD_MAX				= 17,
 };
 
+/*
+ * Atrribute filed in testmode command
+ * See enum iwl_tm_cmd_t.
+ *
+ * @IWL_TM_ATTR_NOT_APPLICABLE:
+ *	The attribute is not applicable or invalid
+ * @IWL_TM_ATTR_COMMAND:
+ *	From user space to kernel space:
+ *	the command either destines to ucode, driver, or register;
+ *	From kernel space to user space:
+ *	the command either carries synchronous response,
+ *	or the spontaneous message multicast from the device;
+ *
+ * @IWL_TM_ATTR_UCODE_CMD_ID:
+ * @IWL_TM_ATTR_UCODE_CMD_DATA:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_UCODE,
+ *	The mandatory fields are :
+ *	IWL_TM_ATTR_UCODE_CMD_ID for recognizable command ID;
+ *	IWL_TM_ATTR_COMMAND_FLAG for the flags of the commands;
+ *	The optional fields are:
+ *	IWL_TM_ATTR_UCODE_CMD_DATA for the actual command payload
+ *	to the ucode
+ *
+ * @IWL_TM_ATTR_REG_OFFSET:
+ * @IWL_TM_ATTR_REG_VALUE8:
+ * @IWL_TM_ATTR_REG_VALUE32:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_REG_XXX,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_REG_OFFSET for the offset of the target register;
+ *	IWL_TM_ATTR_REG_VALUE8 or IWL_TM_ATTR_REG_VALUE32 for value
+ *
+ * @IWL_TM_ATTR_SYNC_RSP:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_SYNC_RSP,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_SYNC_RSP for the data content responding to the user
+ *	application command
+ *
+ * @IWL_TM_ATTR_UCODE_RX_PKT:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_UCODE_RX_PKT,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_UCODE_RX_PKT for the data content multicast to the user
+ *	application
+ *
+ * @IWL_TM_ATTR_EEPROM:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_EEPROM,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_EEPROM for the data content responging to the user
+ *	application
+ *
+ * @IWL_TM_ATTR_TRACE_ADDR:
+ * @IWL_TM_ATTR_TRACE_SIZE:
+ * @IWL_TM_ATTR_TRACE_DUMP:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_XXX_TRACE,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_MEM_TRACE_ADDR for the trace address
+ *	IWL_TM_ATTR_MEM_TRACE_SIZE for the trace buffer size
+ *	IWL_TM_ATTR_MEM_TRACE_DUMP for the trace dump
+ *
+ * @IWL_TM_ATTR_FIXRATE:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_FIXRATE for the fixed rate
+ *
+ */
 enum iwl_tm_attr_t {
-	IWL_TM_ATTR_NOT_APPLICABLE = 0,
-
-	/* From user space to kernel space:
-	 * the command either destines to ucode, driver, or register;
-	 * See enum iwl_tm_cmd_t.
-	 *
-	 * From kernel space to user space:
-	 * the command either carries synchronous response,
-	 * or the spontaneous message multicast from the device;
-	 * See enum iwl_tm_cmd_t. */
-	IWL_TM_ATTR_COMMAND,
-
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_UCODE,
-	 * The mandatory fields are :
-	 * IWL_TM_ATTR_UCODE_CMD_ID for recognizable command ID;
-	 * IWL_TM_ATTR_COMMAND_FLAG for the flags of the commands;
-	 * The optional fields are:
-	 * IWL_TM_ATTR_UCODE_CMD_DATA for the actual command payload
-	 * to the ucode */
-	IWL_TM_ATTR_UCODE_CMD_ID,
-	IWL_TM_ATTR_UCODE_CMD_DATA,
-
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_REG_XXX,
-	 * The mandatory fields are:
-	 * IWL_TM_ATTR_REG_OFFSET for the offset of the target register;
-	 * IWL_TM_ATTR_REG_VALUE8 or IWL_TM_ATTR_REG_VALUE32 for value */
-	IWL_TM_ATTR_REG_OFFSET,
-	IWL_TM_ATTR_REG_VALUE8,
-	IWL_TM_ATTR_REG_VALUE32,
-
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_SYNC_RSP,
-	 * The mandatory fields are:
-	 * IWL_TM_ATTR_SYNC_RSP for the data content responding to the user
-	 * application command */
-	IWL_TM_ATTR_SYNC_RSP,
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_UCODE_RX_PKT,
-	 * The mandatory fields are:
-	 * IWL_TM_ATTR_UCODE_RX_PKT for the data content multicast to the user
-	 * application */
-	IWL_TM_ATTR_UCODE_RX_PKT,
-
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_DEV2APP_EEPROM,
-	 * The mandatory fields are:
-	 * IWL_TM_ATTR_EEPROM for the data content responging to the user
-	 * application */
-	IWL_TM_ATTR_EEPROM,
-
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_XXX_TRACE,
-	 * The mandatory fields are:
-	 * IWL_TM_ATTR_MEM_TRACE_ADDR for the trace address
-	 */
-	IWL_TM_ATTR_TRACE_ADDR,
-	IWL_TM_ATTR_TRACE_SIZE,
-	IWL_TM_ATTR_TRACE_DUMP,
-
-	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
-	 * The mandatory fields are:
-	 * IWL_TM_ATTR_FIXRATE for the fixed rate
-	 */
-	IWL_TM_ATTR_FIXRATE,
-
-	IWL_TM_ATTR_MAX,
+	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
+	IWL_TM_ATTR_COMMAND			= 1,
+	IWL_TM_ATTR_UCODE_CMD_ID		= 2,
+	IWL_TM_ATTR_UCODE_CMD_DATA		= 3,
+	IWL_TM_ATTR_REG_OFFSET			= 4,
+	IWL_TM_ATTR_REG_VALUE8			= 5,
+	IWL_TM_ATTR_REG_VALUE32			= 6,
+	IWL_TM_ATTR_SYNC_RSP			= 7,
+	IWL_TM_ATTR_UCODE_RX_PKT		= 8,
+	IWL_TM_ATTR_EEPROM			= 9,
+	IWL_TM_ATTR_TRACE_ADDR			= 10,
+	IWL_TM_ATTR_TRACE_SIZE			= 11,
+	IWL_TM_ATTR_TRACE_DUMP			= 12,
+	IWL_TM_ATTR_FIXRATE			= 13,
+	IWL_TM_ATTR_MAX				= 14,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

