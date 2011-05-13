Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:20087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab1EMTio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/13] iwlagn: add testmode trace command
Date: Fri, 13 May 2011 12:13:23 -0700
Message-Id: <1305314010-18073-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213906_940279_1C360482)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding testmode trace/debug capability

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    5 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   11 ++
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |  133 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-testmode.h |   15 +++
 5 files changed, 165 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a7054a5..e027f99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3659,6 +3659,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	 */
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 
+	iwl_testmode_cleanup(priv);
 	iwl_leds_exit(priv);
 
 	if (priv->mac80211_registered) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index fc7dc06..2495fe7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -343,6 +343,7 @@ extern int iwl_alive_start(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 extern int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len);
 extern void iwl_testmode_init(struct iwl_priv *priv);
+extern void iwl_testmode_cleanup(struct iwl_priv *priv);
 #else
 static inline
 int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
@@ -353,6 +354,10 @@ static inline
 void iwl_testmode_init(struct iwl_priv *priv)
 {
 }
+static inline
+void iwl_testmode_cleanup(struct iwl_priv *priv)
+{
+}
 #endif
 
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3e3b8b8..12fb2f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1179,6 +1179,14 @@ enum iwl_scan_type {
 	IWL_SCAN_OFFCH_TX,
 };
 
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+struct iwl_testmode_trace {
+	u8 *cpu_addr;
+	u8 *trace_addr;
+	dma_addr_t dma_addr;
+	bool trace_enabled;
+};
+#endif
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1510,6 +1518,9 @@ struct iwl_priv {
 	struct led_classdev led;
 	unsigned long blink_on, blink_off;
 	bool led_registered;
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+	struct iwl_testmode_trace testmode_trace;
+#endif
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index dd2904a..b778c3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -97,6 +97,10 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 
 	[IWL_TM_ATTR_SYNC_RSP] = { .type = NLA_UNSPEC, },
 	[IWL_TM_ATTR_UCODE_RX_PKT] = { .type = NLA_UNSPEC, },
+
+	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_TRACE_DATA] = { .type = NLA_UNSPEC, },
+
 };
 
 /*
@@ -167,6 +171,31 @@ nla_put_failure:
 void iwl_testmode_init(struct iwl_priv *priv)
 {
 	priv->pre_rx_handler = iwl_testmode_ucode_rx_pkt;
+	priv->testmode_trace.trace_enabled = false;
+}
+
+static void iwl_trace_cleanup(struct iwl_priv *priv)
+{
+	struct device *dev = &priv->pci_dev->dev;
+
+	if (priv->testmode_trace.trace_enabled) {
+		if (priv->testmode_trace.cpu_addr &&
+		    priv->testmode_trace.dma_addr)
+			dma_free_coherent(dev,
+					TRACE_TOTAL_SIZE,
+					priv->testmode_trace.cpu_addr,
+					priv->testmode_trace.dma_addr);
+		priv->testmode_trace.trace_enabled = false;
+		priv->testmode_trace.cpu_addr = NULL;
+		priv->testmode_trace.trace_addr = NULL;
+		priv->testmode_trace.dma_addr = 0;
+	}
+}
+
+
+void iwl_testmode_cleanup(struct iwl_priv *priv)
+{
+	iwl_trace_cleanup(priv);
 }
 
 /*
@@ -400,6 +429,102 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
+
+/*
+ * This function handles the user application commands for uCode trace
+ *
+ * It retrieves command ID carried with IWL_TM_ATTR_COMMAND and calls to the
+ * handlers respectively.
+ *
+ * If it's an unknown commdn ID, -ENOSYS is replied; otherwise, the returned
+ * value of the actual command execution is replied to the user application.
+ *
+ * @hw: ieee80211_hw object that represents the device
+ * @tb: gnl message fields from the user space
+ */
+static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct sk_buff *skb;
+	int status = 0;
+	struct device *dev = &priv->pci_dev->dev;
+
+	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
+	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
+		if (priv->testmode_trace.trace_enabled)
+			return -EBUSY;
+
+		priv->testmode_trace.cpu_addr =
+			dma_alloc_coherent(dev,
+					   TRACE_TOTAL_SIZE,
+					   &priv->testmode_trace.dma_addr,
+					   GFP_KERNEL);
+		if (!priv->testmode_trace.cpu_addr)
+			return -ENOMEM;
+		priv->testmode_trace.trace_enabled = true;
+		priv->testmode_trace.trace_addr = (u8 *)PTR_ALIGN(
+			priv->testmode_trace.cpu_addr, 0x100);
+		memset(priv->testmode_trace.trace_addr, 0x03B,
+			TRACE_BUFF_SIZE);
+		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
+			sizeof(priv->testmode_trace.dma_addr) + 20);
+		if (!skb) {
+			IWL_DEBUG_INFO(priv,
+				"Error allocating memory\n");
+			iwl_trace_cleanup(priv);
+			return -ENOMEM;
+		}
+		NLA_PUT(skb, IWL_TM_ATTR_TRACE_ADDR,
+			sizeof(priv->testmode_trace.dma_addr),
+			(u64 *)&priv->testmode_trace.dma_addr);
+		status = cfg80211_testmode_reply(skb);
+		if (status < 0) {
+			IWL_DEBUG_INFO(priv,
+				       "Error sending msg : %d\n",
+				       status);
+		}
+		break;
+
+	case IWL_TM_CMD_APP2DEV_END_TRACE:
+		iwl_trace_cleanup(priv);
+		break;
+
+	case IWL_TM_CMD_APP2DEV_READ_TRACE:
+		if (priv->testmode_trace.trace_enabled &&
+		    priv->testmode_trace.trace_addr) {
+			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
+				20 + TRACE_BUFF_SIZE);
+			if (skb == NULL) {
+				IWL_DEBUG_INFO(priv,
+					"Error allocating memory\n");
+				return -ENOMEM;
+			}
+			NLA_PUT(skb, IWL_TM_ATTR_TRACE_DATA,
+				TRACE_BUFF_SIZE,
+				priv->testmode_trace.trace_addr);
+			status = cfg80211_testmode_reply(skb);
+			if (status < 0) {
+				IWL_DEBUG_INFO(priv,
+				       "Error sending msg : %d\n", status);
+			}
+		} else
+			return -EFAULT;
+		break;
+
+	default:
+		IWL_DEBUG_INFO(priv, "Unknown testmode mem command ID\n");
+		return -ENOSYS;
+	}
+	return status;
+
+nla_put_failure:
+	kfree_skb(skb);
+	if (nla_get_u32(tb[IWL_TM_ATTR_COMMAND]) ==
+	    IWL_TM_CMD_APP2DEV_BEGIN_TRACE)
+		iwl_trace_cleanup(priv);
+	return -EMSGSIZE;
+}
+
 /* The testmode gnl message handler that takes the gnl message from the
  * user space and parses it per the policy iwl_testmode_gnl_msg_policy, then
  * invoke the corresponding handlers.
@@ -459,6 +584,14 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		IWL_DEBUG_INFO(priv, "testmode cmd to driver\n");
 		result = iwl_testmode_driver(hw, tb);
 		break;
+
+	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
+	case IWL_TM_CMD_APP2DEV_END_TRACE:
+	case IWL_TM_CMD_APP2DEV_READ_TRACE:
+		IWL_DEBUG_INFO(priv, "testmode uCode trace cmd to driver\n");
+		result = iwl_testmode_trace(hw, tb);
+		break;
+
 	default:
 		IWL_DEBUG_INFO(priv, "Unknown testmode command\n");
 		result = -ENOSYS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 31f8949..34634ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -91,6 +91,10 @@ enum iwl_tm_cmd_t {
 	/* if there is other new command for the driver layer operation,
 	 * append them here */
 
+	/* commands fom user space for uCode trace operations */
+	IWL_TM_CMD_APP2DEV_BEGIN_TRACE,
+	IWL_TM_CMD_APP2DEV_END_TRACE,
+	IWL_TM_CMD_APP2DEV_READ_TRACE,
 
 	/* commands from kernel space to carry the synchronous response
 	 * to user application */
@@ -144,8 +148,19 @@ enum iwl_tm_attr_t {
 	 * application */
 	IWL_TM_ATTR_UCODE_RX_PKT,
 
+	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_XXX_TRACE,
+	 * The mandatory fields are:
+	 * IWL_TM_ATTR_MEM_TRACE_ADDR for the trace address
+	 */
+	IWL_TM_ATTR_TRACE_ADDR,
+	IWL_TM_ATTR_TRACE_DATA,
+
 	IWL_TM_ATTR_MAX,
 };
 
+/* uCode trace buffer */
+#define TRACE_BUFF_SIZE		0x20000
+#define TRACE_BUFF_PADD		0x2000
+#define TRACE_TOTAL_SIZE	(TRACE_BUFF_SIZE + TRACE_BUFF_PADD)
 
 #endif
-- 
1.7.0.4

