Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552Ab1FKOzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/18] iwlagn: add dumpit support for testmode trace function
Date: Sat, 11 Jun 2011 07:25:36 -0700
Message-Id: <1307802352-16398-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165548_015741_7586CC39)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For testmode trace function, huge amout of data need to pass to userspace.
Use the build-in nl80211 dumpt it function

Require nl80211 testmode dumpit support patch.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   10 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |  106 +++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    4 +-
 5 files changed, 96 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 099c279..6f1edb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3352,6 +3352,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.offchannel_tx = iwl_mac_offchannel_tx,
 	.offchannel_tx_cancel_wait = iwl_mac_offchannel_tx_cancel_wait,
 	CFG80211_TESTMODE_CMD(iwl_testmode_cmd)
+	CFG80211_TESTMODE_DUMP(iwl_testmode_dump)
 };
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d171684..d074e6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -343,6 +343,9 @@ extern int iwl_alive_start(struct iwl_priv *priv);
 /* svtool */
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 extern int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len);
+extern int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
+			     struct netlink_callback *cb,
+			     void *data, int len);
 extern void iwl_testmode_init(struct iwl_priv *priv);
 extern void iwl_testmode_cleanup(struct iwl_priv *priv);
 #else
@@ -352,6 +355,13 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	return -ENOSYS;
 }
 static inline
+int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
+		      struct netlink_callback *cb,
+		      void *data, int len)
+{
+	return -ENOSYS;
+}
+static inline
 void iwl_testmode_init(struct iwl_priv *priv)
 {
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a7d2159..d23430e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1172,6 +1172,7 @@ enum iwl_scan_type {
 struct iwl_testmode_trace {
 	u32 buff_size;
 	u32 total_size;
+	u32 num_chunks;
 	u8 *cpu_addr;
 	u8 *trace_addr;
 	dma_addr_t dma_addr;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 135c1b5..038c696 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -100,7 +100,7 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 	[IWL_TM_ATTR_EEPROM] = { .type = NLA_UNSPEC, },
 
 	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
-	[IWL_TM_ATTR_TRACE_DATA] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_TRACE_DUMP] = { .type = NLA_UNSPEC, },
 	[IWL_TM_ATTR_TRACE_SIZE] = { .type = NLA_U32, },
 
 	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
@@ -534,34 +534,14 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 				       "Error sending msg : %d\n",
 				       status);
 		}
+		priv->testmode_trace.num_chunks =
+			DIV_ROUND_UP(priv->testmode_trace.buff_size,
+				     TRACE_CHUNK_SIZE);
 		break;
 
 	case IWL_TM_CMD_APP2DEV_END_TRACE:
 		iwl_trace_cleanup(priv);
 		break;
-
-	case IWL_TM_CMD_APP2DEV_READ_TRACE:
-		if (priv->testmode_trace.trace_enabled &&
-		    priv->testmode_trace.trace_addr) {
-			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-				20 + priv->testmode_trace.buff_size);
-			if (skb == NULL) {
-				IWL_DEBUG_INFO(priv,
-					"Error allocating memory\n");
-				return -ENOMEM;
-			}
-			NLA_PUT(skb, IWL_TM_ATTR_TRACE_DATA,
-				priv->testmode_trace.buff_size,
-				priv->testmode_trace.trace_addr);
-			status = cfg80211_testmode_reply(skb);
-			if (status < 0) {
-				IWL_DEBUG_INFO(priv,
-				       "Error sending msg : %d\n", status);
-			}
-		} else
-			return -EFAULT;
-		break;
-
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode mem command ID\n");
 		return -ENOSYS;
@@ -576,6 +556,37 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+static int iwl_testmode_trace_dump(struct ieee80211_hw *hw, struct nlattr **tb,
+				   struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct iwl_priv *priv = hw->priv;
+	int idx, length;
+
+	if (priv->testmode_trace.trace_enabled &&
+	    priv->testmode_trace.trace_addr) {
+		idx = cb->args[4];
+		if (idx >= priv->testmode_trace.num_chunks)
+			return -ENOENT;
+		length = TRACE_CHUNK_SIZE;
+		if (((idx + 1) == priv->testmode_trace.num_chunks) &&
+		    (priv->testmode_trace.buff_size % TRACE_CHUNK_SIZE))
+			length = priv->testmode_trace.buff_size %
+				TRACE_CHUNK_SIZE;
+
+		NLA_PUT(skb, IWL_TM_ATTR_TRACE_DUMP, length,
+			priv->testmode_trace.trace_addr +
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
  * invoke the corresponding handlers.
@@ -654,3 +665,50 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 	mutex_unlock(&priv->mutex);
 	return result;
 }
+
+int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
+		      struct netlink_callback *cb,
+		      void *data, int len)
+{
+	struct nlattr *tb[IWL_TM_ATTR_MAX];
+	struct iwl_priv *priv = hw->priv;
+	int result;
+	u32 cmd;
+
+	if (cb->args[3]) {
+		/* offset by 1 since commands start at 0 */
+		cmd = cb->args[3] - 1;
+	} else {
+		result = nla_parse(tb, IWL_TM_ATTR_MAX - 1, data, len,
+				iwl_testmode_gnl_msg_policy);
+		if (result) {
+			IWL_DEBUG_INFO(priv,
+			       "Error parsing the gnl message : %d\n", result);
+			return result;
+		}
+
+		/* IWL_TM_ATTR_COMMAND is absolutely mandatory */
+		if (!tb[IWL_TM_ATTR_COMMAND]) {
+			IWL_DEBUG_INFO(priv,
+				"Error finding testmode command type\n");
+			return -ENOMSG;
+		}
+		cmd = nla_get_u32(tb[IWL_TM_ATTR_COMMAND]);
+		cb->args[3] = cmd + 1;
+	}
+
+	/* in case multiple accesses to the device happens */
+	mutex_lock(&priv->mutex);
+	switch (cmd) {
+	case IWL_TM_CMD_APP2DEV_READ_TRACE:
+		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
+		result = iwl_testmode_trace_dump(hw, tb, skb, cb);
+		break;
+	default:
+		result = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&priv->mutex);
+	return result;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index f3f406e..160911a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -166,8 +166,8 @@ enum iwl_tm_attr_t {
 	 * IWL_TM_ATTR_MEM_TRACE_ADDR for the trace address
 	 */
 	IWL_TM_ATTR_TRACE_ADDR,
-	IWL_TM_ATTR_TRACE_DATA,
 	IWL_TM_ATTR_TRACE_SIZE,
+	IWL_TM_ATTR_TRACE_DUMP,
 
 	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
 	 * The mandatory fields are:
@@ -182,7 +182,7 @@ enum iwl_tm_attr_t {
 #define TRACE_BUFF_SIZE_MAX	0x200000
 #define TRACE_BUFF_SIZE_MIN	0x20000
 #define TRACE_BUFF_SIZE_DEF	TRACE_BUFF_SIZE_MIN
-
 #define TRACE_BUFF_PADD		0x2000
+#define TRACE_CHUNK_SIZE	(PAGE_SIZE - 1024)
 
 #endif
-- 
1.7.0.4

