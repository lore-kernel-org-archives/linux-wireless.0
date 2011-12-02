Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab1LBRqQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:16 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/16] iwlwifi: add tm commands for sram reading by dumpit
Date: Fri,  2 Dec 2011 08:48:26 -0800
Message-Id: <1322844520-21149-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184629_937413_765986E4)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

Create new testmode commands and attributes to suppot
sram data reading. Because the amount of sram data
may exceed single skb packet size. Using the nl80211
dump it funtion to deliver sram data to userspace.

- IWL_TM_CMD_APP2DEV_READ_SRAM
- IWL_TM_CMD_APP2DEV_DUMP_SRAM
- IWL_TM_ATTR_SRAM_ADDR
- IWL_TM_ATTR_SRAM_SIZE
- IWL_TM_ATTR_SRAM_DUMP

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 ++
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |  109 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   27 ++++++-
 3 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0c95ad3..cb24adb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -790,6 +790,12 @@ struct iwl_testmode_trace {
 	dma_addr_t dma_addr;
 	bool trace_enabled;
 };
+struct iwl_testmode_sram {
+	u32 buff_size;
+	u32 num_chunks;
+	u8 *buff_addr;
+	bool sram_readed;
+};
 #endif
 
 struct iwl_wipan_noa_data {
@@ -1070,6 +1076,7 @@ struct iwl_priv {
 	bool led_registered;
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 	struct iwl_testmode_trace testmode_trace;
+	struct iwl_testmode_sram testmode_sram;
 	u32 tm_fixed_rate;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index be16caf..593f42d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -106,6 +106,10 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
 
 	[IWL_TM_ATTR_UCODE_OWNER] = { .type = NLA_U8, },
+
+	[IWL_TM_ATTR_SRAM_ADDR] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_SRAM_SIZE] = { .type = NLA_U32, },
+	[IWL_TM_ATTR_SRAM_DUMP] = { .type = NLA_UNSPEC, },
 };
 
 /*
@@ -177,6 +181,18 @@ void iwl_testmode_init(struct iwl_priv *priv)
 {
 	priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
 	priv->testmode_trace.trace_enabled = false;
+	priv->testmode_sram.sram_readed = false;
+}
+
+void iwl_sram_cleanup(struct iwl_priv *priv)
+{
+	if (priv->testmode_sram.sram_readed) {
+		kfree(priv->testmode_sram.buff_addr);
+		priv->testmode_sram.buff_addr = NULL;
+		priv->testmode_sram.buff_size = 0;
+		priv->testmode_sram.num_chunks = 0;
+		priv->testmode_sram.sram_readed = false;
+	}
 }
 
 static void iwl_trace_cleanup(struct iwl_priv *priv)
@@ -201,6 +217,7 @@ static void iwl_trace_cleanup(struct iwl_priv *priv)
 void iwl_testmode_cleanup(struct iwl_priv *priv)
 {
 	iwl_trace_cleanup(priv);
+	iwl_sram_cleanup(priv);
 }
 
 /*
@@ -644,6 +661,89 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 	return 0;
 }
 
+/*
+ * This function handles the user application commands for SRAM data dump
+ *
+ * It retrieves the mandatory fields IWL_TM_ATTR_SRAM_ADDR and
+ * IWL_TM_ATTR_SRAM_SIZE to decide the memory area for SRAM data reading
+ *
+ * Several error will be retured, -EBUSY if the SRAM data retrieved by
+ * previous command has not been delivered to userspace, or -ENOMSG if
+ * the mandatory fields (IWL_TM_ATTR_SRAM_ADDR,IWL_TM_ATTR_SRAM_SIZE)
+ * are missing, or -ENOMEM if the buffer allocation fails.
+ *
+ * Otherwise 0 is replied indicating the success of the SRAM reading.
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @tb: gnl message fields from the user space
+ */
+static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
+{
+	struct iwl_priv *priv = hw->priv;
+	u32 base, ofs, size;
+
+	if (priv->testmode_sram.sram_readed)
+		return -EBUSY;
+
+	if (!tb[IWL_TM_ATTR_SRAM_ADDR]) {
+		IWL_DEBUG_INFO(priv, "Error finding SRAM offset address\n");
+		return -ENOMSG;
+	}
+	ofs = nla_get_u32(tb[IWL_TM_ATTR_SRAM_ADDR]);
+	if (!tb[IWL_TM_ATTR_SRAM_SIZE]) {
+		IWL_DEBUG_INFO(priv, "Error finding size for SRAM reading\n");
+		return -ENOMSG;
+	}
+	size = nla_get_u32(tb[IWL_TM_ATTR_SRAM_SIZE]);
+	priv->testmode_sram.buff_size = (size / 4) * 4;
+	priv->testmode_sram.buff_addr =
+		kmalloc(priv->testmode_sram.buff_size, GFP_KERNEL);
+	if (priv->testmode_sram.buff_addr == NULL) {
+		IWL_DEBUG_INFO(priv, "Error allocating memory\n");
+		return -ENOMEM;
+	}
+	base = 0x800000;
+	_iwl_read_targ_mem_words(bus(priv), base + ofs,
+					priv->testmode_sram.buff_addr,
+					priv->testmode_sram.buff_size / 4);
+	priv->testmode_sram.num_chunks =
+		DIV_ROUND_UP(priv->testmode_sram.buff_size, TRACE_CHUNK_SIZE);
+	priv->testmode_sram.sram_readed = true;
+	return 0;
+}
+
+static int iwl_testmode_sram_dump(struct ieee80211_hw *hw, struct nlattr **tb,
+				   struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct iwl_priv *priv = hw->priv;
+	int idx, length;
+
+	if (priv->testmode_sram.sram_readed) {
+		idx = cb->args[4];
+		if (idx >= priv->testmode_sram.num_chunks) {
+			iwl_sram_cleanup(priv);
+			return -ENOENT;
+		}
+		length = TRACE_CHUNK_SIZE;
+		if (((idx + 1) == priv->testmode_sram.num_chunks) &&
+		    (priv->testmode_sram.buff_size % TRACE_CHUNK_SIZE))
+			length = priv->testmode_sram.buff_size %
+				TRACE_CHUNK_SIZE;
+
+		NLA_PUT(skb, IWL_TM_ATTR_SRAM_DUMP, length,
+			priv->testmode_sram.buff_addr +
+			(TRACE_CHUNK_SIZE * idx));
+		idx++;
+		cb->args[4] = idx;
+		return 0;
+	} else
+		return -EFAULT;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
 
 /* The testmode gnl message handler that takes the gnl message from the
  * user space and parses it per the policy iwl_testmode_gnl_msg_policy, then
@@ -721,6 +821,11 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		result = iwl_testmode_ownership(hw, tb);
 		break;
 
+	case IWL_TM_CMD_APP2DEV_READ_SRAM:
+		IWL_DEBUG_INFO(priv, "testmode sram read cmd to driver\n");
+		result = iwl_testmode_sram(hw, tb);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode command\n");
 		result = -ENOSYS;
@@ -769,6 +874,10 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
 		result = iwl_testmode_trace_dump(hw, tb, skb, cb);
 		break;
+	case IWL_TM_CMD_APP2DEV_DUMP_SRAM:
+		IWL_DEBUG_INFO(priv, "testmode sram dump cmd to driver\n");
+		result = iwl_testmode_sram_dump(hw, tb, skb, cb);
+		break;
 	default:
 		result = -EINVAL;
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 1779648..95c8705 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -103,14 +103,20 @@
  * @IWL_TM_CMD_DEV2APP_EEPROM_RSP:
  *	commands from kernel space to carry the eeprom response
  *	to user application
+ *
  * @IWL_TM_CMD_APP2DEV_OWNERSHIP:
  *	commands from user application to own change the ownership of the uCode
  *	if application has the ownership, the only host command from
  *	testmode will deliver to uCode. Default owner is driver
+ *
  * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
  * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
  *	commands from user applicaiton to indirectly access peripheral register
  *
+ * @IWL_TM_CMD_APP2DEV_READ_SRAM:
+ * @IWL_TM_CMD_APP2DEV_DUMP_SRAM:
+ *	commands from user applicaiton to read data in sram
+ *
  */
 enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_UCODE		= 1,
@@ -132,7 +138,9 @@ enum iwl_tm_cmd_t {
 	IWL_TM_CMD_APP2DEV_OWNERSHIP		= 17,
 	IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32	= 18,
 	IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32	= 19,
-	IWL_TM_CMD_MAX				= 20,
+	IWL_TM_CMD_APP2DEV_READ_SRAM		= 20,
+	IWL_TM_CMD_APP2DEV_DUMP_SRAM		= 21,
+	IWL_TM_CMD_MAX				= 22,
 };
 
 /*
@@ -202,6 +210,18 @@ enum iwl_tm_cmd_t {
  *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_OWNERSHIP,
  *	The mandatory fields are:
  *	IWL_TM_ATTR_UCODE_OWNER for the new owner
+ *
+ * @IWL_TM_ATTR_SRAM_ADDR:
+ * @IWL_TM_ATTR_SRAM_SIZE:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_READ_SRAM,
+ *	The mandatory fields are:
+ *	IWL_TM_ATTR_SRAM_ADDR for the address in sram
+ *	IWL_TM_ATTR_SRAM_SIZE for the buffer size of data reading
+ *
+ * @IWL_TM_ATTR_SRAM_DUMP:
+ *	When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_DUMP_SRAM,
+ *	IWL_TM_ATTR_SRAM_DUMP for the data in sram
+ *
  */
 enum iwl_tm_attr_t {
 	IWL_TM_ATTR_NOT_APPLICABLE		= 0,
@@ -219,7 +239,10 @@ enum iwl_tm_attr_t {
 	IWL_TM_ATTR_TRACE_DUMP			= 12,
 	IWL_TM_ATTR_FIXRATE			= 13,
 	IWL_TM_ATTR_UCODE_OWNER			= 14,
-	IWL_TM_ATTR_MAX				= 15,
+	IWL_TM_ATTR_SRAM_ADDR			= 15,
+	IWL_TM_ATTR_SRAM_SIZE			= 16,
+	IWL_TM_ATTR_SRAM_DUMP			= 17,
+	IWL_TM_ATTR_MAX				= 18,
 };
 
 /* uCode trace buffer */
-- 
1.7.0.4

