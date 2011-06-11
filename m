Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab1FKOzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/18] iwlagn: usersapce application decide the size of trace buffer
Date: Sat, 11 Jun 2011 07:25:35 -0700
Message-Id: <1307802352-16398-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165547_476196_E1FC1744)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For testmode trace function, allow userspace application to request the
size of trace buffer.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-sv-open.c  |   28 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    7 ++++-
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c8de236..a7d2159 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1170,6 +1170,8 @@ enum iwl_scan_type {
 
 #ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
 struct iwl_testmode_trace {
+	u32 buff_size;
+	u32 total_size;
 	u8 *cpu_addr;
 	u8 *trace_addr;
 	dma_addr_t dma_addr;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 69b7e6b..135c1b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -69,7 +69,6 @@
 #include <net/mac80211.h>
 #include <net/netlink.h>
 
-
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-debug.h"
@@ -102,8 +101,10 @@ struct nla_policy iwl_testmode_gnl_msg_policy[IWL_TM_ATTR_MAX] = {
 
 	[IWL_TM_ATTR_TRACE_ADDR] = { .type = NLA_UNSPEC, },
 	[IWL_TM_ATTR_TRACE_DATA] = { .type = NLA_UNSPEC, },
+	[IWL_TM_ATTR_TRACE_SIZE] = { .type = NLA_U32, },
 
 	[IWL_TM_ATTR_FIXRATE] = { .type = NLA_U32, },
+
 };
 
 /*
@@ -185,13 +186,15 @@ static void iwl_trace_cleanup(struct iwl_priv *priv)
 		if (priv->testmode_trace.cpu_addr &&
 		    priv->testmode_trace.dma_addr)
 			dma_free_coherent(dev,
-					TRACE_TOTAL_SIZE,
+					priv->testmode_trace.total_size,
 					priv->testmode_trace.cpu_addr,
 					priv->testmode_trace.dma_addr);
 		priv->testmode_trace.trace_enabled = false;
 		priv->testmode_trace.cpu_addr = NULL;
 		priv->testmode_trace.trace_addr = NULL;
 		priv->testmode_trace.dma_addr = 0;
+		priv->testmode_trace.buff_size = 0;
+		priv->testmode_trace.total_size = 0;
 	}
 }
 
@@ -489,9 +492,22 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 		if (priv->testmode_trace.trace_enabled)
 			return -EBUSY;
 
+		if (!tb[IWL_TM_ATTR_TRACE_SIZE])
+			priv->testmode_trace.buff_size = TRACE_BUFF_SIZE_DEF;
+		else
+			priv->testmode_trace.buff_size =
+				nla_get_u32(tb[IWL_TM_ATTR_TRACE_SIZE]);
+		if (!priv->testmode_trace.buff_size)
+			return -EINVAL;
+		if (priv->testmode_trace.buff_size < TRACE_BUFF_SIZE_MIN ||
+		    priv->testmode_trace.buff_size > TRACE_BUFF_SIZE_MAX)
+			return -EINVAL;
+
+		priv->testmode_trace.total_size =
+			priv->testmode_trace.buff_size + TRACE_BUFF_PADD;
 		priv->testmode_trace.cpu_addr =
 			dma_alloc_coherent(dev,
-					   TRACE_TOTAL_SIZE,
+					   priv->testmode_trace.total_size,
 					   &priv->testmode_trace.dma_addr,
 					   GFP_KERNEL);
 		if (!priv->testmode_trace.cpu_addr)
@@ -500,7 +516,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 		priv->testmode_trace.trace_addr = (u8 *)PTR_ALIGN(
 			priv->testmode_trace.cpu_addr, 0x100);
 		memset(priv->testmode_trace.trace_addr, 0x03B,
-			TRACE_BUFF_SIZE);
+			priv->testmode_trace.buff_size);
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
 			sizeof(priv->testmode_trace.dma_addr) + 20);
 		if (!skb) {
@@ -528,14 +544,14 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 		if (priv->testmode_trace.trace_enabled &&
 		    priv->testmode_trace.trace_addr) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-				20 + TRACE_BUFF_SIZE);
+				20 + priv->testmode_trace.buff_size);
 			if (skb == NULL) {
 				IWL_DEBUG_INFO(priv,
 					"Error allocating memory\n");
 				return -ENOMEM;
 			}
 			NLA_PUT(skb, IWL_TM_ATTR_TRACE_DATA,
-				TRACE_BUFF_SIZE,
+				priv->testmode_trace.buff_size,
 				priv->testmode_trace.trace_addr);
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index a88085e..f3f406e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -167,6 +167,7 @@ enum iwl_tm_attr_t {
 	 */
 	IWL_TM_ATTR_TRACE_ADDR,
 	IWL_TM_ATTR_TRACE_DATA,
+	IWL_TM_ATTR_TRACE_SIZE,
 
 	/* When IWL_TM_ATTR_COMMAND is IWL_TM_CMD_APP2DEV_FIXRATE_REQ,
 	 * The mandatory fields are:
@@ -178,8 +179,10 @@ enum iwl_tm_attr_t {
 };
 
 /* uCode trace buffer */
-#define TRACE_BUFF_SIZE		0x20000
+#define TRACE_BUFF_SIZE_MAX	0x200000
+#define TRACE_BUFF_SIZE_MIN	0x20000
+#define TRACE_BUFF_SIZE_DEF	TRACE_BUFF_SIZE_MIN
+
 #define TRACE_BUFF_PADD		0x2000
-#define TRACE_TOTAL_SIZE	(TRACE_BUFF_SIZE + TRACE_BUFF_PADD)
 
 #endif
-- 
1.7.0.4

