Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab2BQUXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:50 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/26] iwlwifi: testmode new indirect RW API
Date: Fri, 17 Feb 2012 11:13:30 -0800
Message-Id: <1329506034-1394-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212442_263853_EB00866A)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

Replaced the old SRAM and periphery indirect access functions
with a unified indirect memory access functions. These include
new IWL_TM_CMDs for buffer read/write/dump which replace the
SRAM read/dump commands, but the API for IWL_TM_CMD_INDIRECT_REG
read/write will now not be supported (returns error).

This also handles writing to periphery registers in 1-3 bytes.

Requires the corresponding patch in the library for the API change.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c |  226 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   53 ++++---
 3 files changed, 163 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index aa99457..0e8f137 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -696,11 +696,11 @@ struct iwl_testmode_trace {
 	dma_addr_t dma_addr;
 	bool trace_enabled;
 };
-struct iwl_testmode_sram {
+struct iwl_testmode_mem {
 	u32 buff_size;
 	u32 num_chunks;
 	u8 *buff_addr;
-	bool sram_readed;
+	bool read_in_progress;
 };
 #endif
 
@@ -964,7 +964,7 @@ struct iwl_priv {
 	bool led_registered;
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 	struct iwl_testmode_trace testmode_trace;
-	struct iwl_testmode_sram testmode_sram;
+	struct iwl_testmode_mem testmode_mem;
 	u32 tm_fixed_rate;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index e42e076..debc9ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -81,6 +81,13 @@
 #include "iwl-bus.h"
 #include "iwl-fh.h"
 
+
+/* Periphery registers absolute lower bound. This is used in order to
+ * differentiate registery access through HBUS_TARG_PRPH_* and
+ * HBUS_TARG_MEM_* accesses.
+ */
+#define IWL_TM_ABS_PRPH_START (0xA00000)
+
 /* The TLVs used in the gnl message policy between the kernel module and
  * user space application. iwl_testmode_gnl_msg_policy is to be carried
  * through the NL80211_CMD_TESTMODE channel regulated by nl80211.
@@ -110,9 +117,9 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 
 	[IWL_TM_ATTR_UCODE_OWNER] = { .type = NLA_U8, },
 
-	[IWL_TM_ATTR_SRAM_ADDR] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_SRAM_SIZE] = { .type = NLA_U32, },
-	[IWL_TM_ATTR_SRAM_DUMP] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_MEM_ADDR] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_BUFFER_SIZE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_BUFFER_DUMP] = { .type = NLA_UNSPEC, },
 
 	[IWL_TM_ATTR_FW_VERSION] = { .type = NLA_U32, },
 	[IWL_TM_ATTR_DEVICE_ID] = { .type = NLA_U32, },
@@ -190,17 +197,17 @@ void iwl_testmode_init(struct iwl_priv *priv)
 {
 	priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
 	priv->testmode_trace.trace_enabled = false;
-	priv->testmode_sram.sram_readed = false;
+	priv->testmode_mem.read_in_progress = false;
 }
 
-static void iwl_sram_cleanup(struct iwl_priv *priv)
+static void iwl_mem_cleanup(struct iwl_priv *priv)
 {
-	if (priv->testmode_sram.sram_readed) {
-		kfree(priv->testmode_sram.buff_addr);
-		priv->testmode_sram.buff_addr = NULL;
-		priv->testmode_sram.buff_size = 0;
-		priv->testmode_sram.num_chunks = 0;
-		priv->testmode_sram.sram_readed = false;
+	if (priv->testmode_mem.read_in_progress) {
+		kfree(priv->testmode_mem.buff_addr);
+		priv->testmode_mem.buff_addr = NULL;
+		priv->testmode_mem.buff_size = 0;
+		priv->testmode_mem.num_chunks = 0;
+		priv->testmode_mem.read_in_progress = false;
 	}
 }
 
@@ -226,7 +233,7 @@ static void iwl_trace_cleanup(struct iwl_priv *priv)
 void iwl_testmode_cleanup(struct iwl_priv *priv)
 {
 	iwl_trace_cleanup(priv);
-	iwl_sram_cleanup(priv);
+	iwl_mem_cleanup(priv);
 }
 
 /*
@@ -348,30 +355,6 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 			iwl_write8(trans(priv), ofs, val8);
 		}
 		break;
-	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
-		val32 = iwl_read_prph(trans(priv), ofs);
-		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
-
-		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
-		if (!skb) {
-			IWL_ERR(priv, "Memory allocation fail\n");
-			return -ENOMEM;
-		}
-		NLA_PUT_U32(skb, IWL_TM_ATTR_REG_VALUE32, val32);
-		status = cfg80211_testmode_reply(skb);
-		if (status < 0)
-			IWL_ERR(priv, "Error sending msg : %d\n", status);
-		break;
-	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
-		if (!tb[IWL_TM_ATTR_REG_VALUE32]) {
-			IWL_ERR(priv, "Missing value to write\n");
-			return -ENOMSG;
-		} else {
-			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
-			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write_prph(trans(priv), ofs, val32);
-		}
-		break;
 	default:
 		IWL_ERR(priv, "Unknown testmode register command ID\n");
 		return -ENOSYS;
@@ -748,6 +731,81 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	return 0;
 }
 
+static int iwl_testmode_indirect_read(struct iwl_priv *priv, u32 addr, u32 size)
+{
+	struct iwl_trans *trans = trans(priv);
+	unsigned long flags;
+	int i;
+
+	if (size & 0x3)
+		return -EINVAL;
+	priv->testmode_mem.buff_size = size;
+	priv->testmode_mem.buff_addr =
+		kmalloc(priv->testmode_mem.buff_size, GFP_KERNEL);
+	if (priv->testmode_mem.buff_addr == NULL)
+		return -ENOMEM;
+
+	/* Hard-coded periphery absolute address */
+	if (IWL_TM_ABS_PRPH_START <= addr &&
+		addr < IWL_TM_ABS_PRPH_START + PRPH_END) {
+			spin_lock_irqsave(&trans->reg_lock, flags);
+			iwl_grab_nic_access(trans);
+			iwl_write32(trans, HBUS_TARG_PRPH_RADDR, addr);
+			for (i = 0; i < size; i += 4)
+				priv->testmode_mem.buff_addr[i] =
+					iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
+			iwl_release_nic_access(trans);
+			spin_unlock_irqrestore(&trans->reg_lock, flags);
+	} else { /* target memory (SRAM) */
+		_iwl_read_targ_mem_words(trans, addr,
+			priv->testmode_mem.buff_addr,
+			priv->testmode_mem.buff_size / 4);
+	}
+
+	priv->testmode_mem.num_chunks =
+		DIV_ROUND_UP(priv->testmode_mem.buff_size, DUMP_CHUNK_SIZE);
+	priv->testmode_mem.read_in_progress = true;
+	return 0;
+
+}
+
+static int iwl_testmode_indirect_write(struct iwl_priv *priv, u32 addr,
+	u32 size, unsigned char *buf)
+{
+	struct iwl_trans *trans = trans(priv);
+	u32 val, i;
+	unsigned long flags;
+
+	if (IWL_TM_ABS_PRPH_START <= addr &&
+		addr < IWL_TM_ABS_PRPH_START + PRPH_END) {
+			/* Periphery writes can be 1-3 bytes long, or DWORDs */
+			if (size < 4) {
+				memcpy(&val, buf, size);
+				spin_lock_irqsave(&trans->reg_lock, flags);
+				iwl_grab_nic_access(trans);
+				iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
+					    (addr & 0x0000FFFF) | (size << 24));
+				iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
+				iwl_release_nic_access(trans);
+				/* needed after consecutive writes w/o read */
+				mmiowb();
+				spin_unlock_irqrestore(&trans->reg_lock, flags);
+			} else {
+				if (size % 4)
+					return -EINVAL;
+				for (i = 0; i < size; i += 4)
+					iwl_write_prph(trans, addr+i,
+						*(u32 *)buf+i);
+			}
+	} else if (iwlagn_hw_valid_rtc_data_addr(addr) ||
+		(IWLAGN_RTC_INST_LOWER_BOUND <= addr &&
+		addr < IWLAGN_RTC_INST_UPPER_BOUND)) {
+			_iwl_write_targ_mem_words(trans, addr, buf, size/4);
+	} else
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * This function handles the user application commands for SRAM data dump
  *
@@ -764,82 +822,60 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
  * @hw: ieee80211_hw object that represents the device
  * @tb: gnl message fields from the user space
  */
-static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
+static int iwl_testmode_indirect_mem(struct ieee80211_hw *hw,
+	struct nlattr **tb)
 {
 	struct iwl_priv *priv = hw->priv;
-	u32 ofs, size, maxsize;
+	u32 addr, size, cmd;
+	unsigned char *buf;
 
-	if (priv->testmode_sram.sram_readed)
+	/* Both read and write should be blocked, for atomicity */
+	if (priv->testmode_mem.read_in_progress)
 		return -EBUSY;
 
-	if (!tb[IWL_TM_ATTR_SRAM_ADDR]) {
-		IWL_ERR(priv, "Missing SRAM offset address\n");
+	cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
+	if (!tb[IWL_TM_ATTR_MEM_ADDR]) {
+		IWL_ERR(priv, "Error finding memory offset address\n");
 		return -ENOMSG;
 	}
-	ofs = nla_get_u32(tb[IWL_TM_ATTR_SRAM_ADDR]);
-	if (!tb[IWL_TM_ATTR_SRAM_SIZE]) {
-		IWL_ERR(priv, "Missing size for SRAM reading\n");
+	addr = nla_get_u32(tb[IWL_TM_ATTR_MEM_ADDR]);
+	if (!tb[IWL_TM_ATTR_BUFFER_SIZE]) {
+		IWL_ERR(priv, "Error finding size for memory reading\n");
 		return -ENOMSG;
 	}
-	size = nla_get_u32(tb[IWL_TM_ATTR_SRAM_SIZE]);
-	switch (priv->shrd->ucode_type) {
-	case IWL_UCODE_REGULAR:
-		maxsize = trans(priv)->ucode_rt.data.len;
-		break;
-	case IWL_UCODE_INIT:
-		maxsize = trans(priv)->ucode_init.data.len;
-		break;
-	case IWL_UCODE_WOWLAN:
-		maxsize = trans(priv)->ucode_wowlan.data.len;
-		break;
-	case IWL_UCODE_NONE:
-		IWL_ERR(priv, "uCode does not been loaded\n");
-		return -ENOSYS;
-	default:
-		IWL_ERR(priv, "unsupported uCode type\n");
-		return -ENOSYS;
-	}
-	if ((ofs + size) > (maxsize + SRAM_DATA_SEG_OFFSET)) {
-		IWL_ERR(priv, "Invalid offset/size: out of range\n");
-		return -EINVAL;
-	}
-	priv->testmode_sram.buff_size = (size / 4) * 4;
-	priv->testmode_sram.buff_addr =
-		kmalloc(priv->testmode_sram.buff_size, GFP_KERNEL);
-	if (priv->testmode_sram.buff_addr == NULL) {
-		IWL_ERR(priv, "Memory allocation fail\n");
-		return -ENOMEM;
+	size = nla_get_u32(tb[IWL_TM_ATTR_BUFFER_SIZE]);
+
+	if (cmd == IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ)
+		return iwl_testmode_indirect_read(priv, addr,  size);
+	else {
+		if (!tb[IWL_TM_ATTR_BUFFER_DUMP])
+			return -EINVAL;
+		buf = (unsigned char *) nla_data(tb[IWL_TM_ATTR_BUFFER_DUMP]);
+		return iwl_testmode_indirect_write(priv, addr, size, buf);
 	}
-	_iwl_read_targ_mem_words(trans(priv), ofs,
-					priv->testmode_sram.buff_addr,
-					priv->testmode_sram.buff_size / 4);
-	priv->testmode_sram.num_chunks =
-		DIV_ROUND_UP(priv->testmode_sram.buff_size, DUMP_CHUNK_SIZE);
-	priv->testmode_sram.sram_readed = true;
-	return 0;
 }
 
-static int iwl_testmode_sram_dump(struct ieee80211_hw *hw, struct nlattr **tb,
+static int iwl_testmode_buffer_dump(struct ieee80211_hw *hw, struct nlattr **tb,
 				   struct sk_buff *skb,
 				   struct netlink_callback *cb)
 {
 	struct iwl_priv *priv = hw->priv;
 	int idx, length;
 
-	if (priv->testmode_sram.sram_readed) {
+	if (priv->testmode_mem.read_in_progress) {
 		idx = cb->args[4];
-		if (idx >= priv->testmode_sram.num_chunks) {
-			iwl_sram_cleanup(priv);
+		if (idx >= priv->testmode_mem.num_chunks) {
+			iwl_mem_cleanup(priv);
 			return -ENOENT;
 		}
 		length = DUMP_CHUNK_SIZE;
-		if (((idx + 1) == priv->testmode_sram.num_chunks) &&
-		    (priv->testmode_sram.buff_size % DUMP_CHUNK_SIZE))
-			length = priv->testmode_sram.buff_size %
+		if (((idx + 1) == priv->testmode_mem.num_chunks) &&
+		    (priv->testmode_mem.buff_size % DUMP_CHUNK_SIZE))
+			length = priv->testmode_mem.buff_size %
 				DUMP_CHUNK_SIZE;
 
-		NLA_PUT(skb, IWL_TM_ATTR_SRAM_DUMP, length,
-			priv->testmode_sram.buff_addr +
+		NLA_PUT(skb, IWL_TM_ATTR_BUFFER_DUMP, length,
+			priv->testmode_mem.buff_addr +
 			(DUMP_CHUNK_SIZE * idx));
 		idx++;
 		cb->args[4] = idx;
@@ -900,8 +936,6 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE32:
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
-	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
-	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
 		IWL_DEBUG_INFO(priv, "testmode cmd to register\n");
 		result = iwl_testmode_reg(hw, tb);
 		break;
@@ -931,9 +965,11 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		result = iwl_testmode_ownership(hw, tb);
 		break;
 
-	case IWL_TM_CMD_APP2DEV_READ_SRAM:
-		IWL_DEBUG_INFO(priv, "testmode sram read cmd to driver\n");
-		result = iwl_testmode_sram(hw, tb);
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE:
+		IWL_DEBUG_INFO(priv, "testmode indirect memory cmd "
+			"to driver\n");
+		result = iwl_testmode_indirect_mem(hw, tb);
 		break;
 
 	default:
@@ -983,9 +1019,9 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
 		result = iwl_testmode_trace_dump(hw, tb, skb, cb);
 		break;
-	case IWL_TM_CMD_APP2DEV_DUMP_SRAM:
+	case IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP:
 		IWL_DEBUG_INFO(priv, "testmode sram dump cmd to driver\n");
-		result = iwl_testmode_sram_dump(hw, tb, skb, cb);
+		result = iwl_testmode_buffer_dump(hw, tb, skb, cb);
 		break;
 	default:
 		result = -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index f97d061..3815cf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -109,20 +109,19 @@
  *	if application has the ownership, the only host command from
  *	testmode will deliver to uCode. Default owner is driver
  *
- * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
- * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
- *	commands from user application to indirectly access peripheral register
- *
- * @IWL_TM_CMD_APP2DEV_READ_SRAM:
- * @IWL_TM_CMD_APP2DEV_DUMP_SRAM:
- *	commands from user application to read data in sram
- *
  * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Wake On Wireless LAN uCode image
  * @IWL_TM_CMD_APP2DEV_GET_FW_VERSION: retrieve uCode version
  * @IWL_TM_CMD_APP2DEV_GET_DEVICE_ID: retrieve ID information in device
  * @IWL_TM_CMD_APP2DEV_GET_FW_INFO:
  *	retrieve information of existing loaded uCode image
  *
+ * @IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ:
+ * @IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP:
+ * @IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE:
+ *	Commands to read/write data from periphery or SRAM memory ranges.
+ *	Fore reading, a READ command is sent from the userspace and the data
+ *	is returned when the user calls a DUMP command.
+ *	For writing, only a WRITE command is used.
  */
 enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_UCODE		= 1,
@@ -142,15 +141,18 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_DEV2APP_UCODE_RX_PKT		= 15,
 	IWL_TM_CMD_DEV2APP_EEPROM_RSP		= 16,
 	IWL_TM_CMD_APP2DEV_OWNERSHIP		= 17,
-	IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32	= 18,
-	IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32	= 19,
-	IWL_TM_CMD_APP2DEV_READ_SRAM		= 20,
-	IWL_TM_CMD_APP2DEV_DUMP_SRAM		= 21,
+	RESERVED_18				= 18,
+	RESERVED_19				= 19,
+	RESERVED_20				= 20,
+	RESERVED_21				= 21,
 	IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW	= 22,
 	IWL_TM_CMD_APP2DEV_GET_FW_VERSION	= 23,
 	IWL_TM_CMD_APP2DEV_GET_DEVICE_ID	= 24,
 	IWL_TM_CMD_APP2DEV_GET_FW_INFO		= 25,
-	IWL_TM_CMD_MAX				= 26,
+	IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ = 26,
+	IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP = 27,
+	IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE = 28,
+	IWL_TM_CMD_MAX				= 29,
 };
 
 /*
@@ -221,16 +223,19 @@ enum iwl_tm_cmd_t {
  *	The mandatory fields are:
  *	IWL_TM_ATTR_UCODE_OWNER for the new owner
  *
- * @IWL_TM_ATTR_SRAM_ADDR:
- * @IWL_TM_ATTR_SRAM_SIZE:
- *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_READ_SRAM,
+ * @IWL_TM_ATTR_MEM_ADDR:
+ * @IWL_TM_ATTR_BUFFER_SIZE:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_READ
+ *	or IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE.
  *	The mandatory fields are:
- *	IWL_TM_ATTR_SRAM_ADDR for the address in sram
- *	IWL_TM_ATTR_SRAM_SIZE for the buffer size of data reading
+ *	IWL_TM_ATTR_MEM_ADDR for the address in SRAM/periphery to read/write
+ *	IWL_TM_ATTR_BUFFER_SIZE for the buffer size of data to read/write.
  *
- * @IWL_TM_ATTR_SRAM_DUMP:
- *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_DUMP_SRAM,
- *	IWL_TM_ATTR_SRAM_DUMP for the data in sram
+ * @IWL_TM_ATTR_BUFFER_DUMP:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_DUMP,
+ *	IWL_TM_ATTR_BUFFER_DUMP is used for the data that was read.
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_INDIRECT_BUFFER_WRITE,
+ *	this attribute contains the data to write.
  *
  * @IWL_TM_ATTR_FW_VERSION:
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_GET_FW_VERSION,
@@ -266,9 +271,9 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_TRACE_DUMP			= 12,
 	IWL_TM_ATTR_FIXRATE			= 13,
 	IWL_TM_ATTR_UCODE_OWNER			= 14,
-	IWL_TM_ATTR_SRAM_ADDR			= 15,
-	IWL_TM_ATTR_SRAM_SIZE			= 16,
-	IWL_TM_ATTR_SRAM_DUMP			= 17,
+	IWL_TM_ATTR_MEM_ADDR			= 15,
+	IWL_TM_ATTR_BUFFER_SIZE			= 16,
+	IWL_TM_ATTR_BUFFER_DUMP			= 17,
 	IWL_TM_ATTR_FW_VERSION			= 18,
 	IWL_TM_ATTR_DEVICE_ID			= 19,
 	IWL_TM_ATTR_FW_TYPE			= 20,
-- 
1.7.0.4

