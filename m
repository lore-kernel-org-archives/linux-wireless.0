Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbZKTUFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/19] iwlwifi: Add iwl_write8()
Date: Fri, 20 Nov 2009 12:04:52 -0800
Message-Id: <1258747510-21233-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

To support byte writes to CSR_INT_COALESCING and CSR_INT_PERIODIC registers,
add iwl_write8(), including debug/trace support.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h       |   20 ++++++++++++++++++++
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 4ef5aca..e7d88d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -5,6 +5,7 @@
 #define CREATE_TRACE_POINTS
 #include "iwl-devtrace.h"
 
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite8);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 8c71592..f2d4b01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -32,6 +32,22 @@ TRACE_EVENT(iwlwifi_dev_ioread32,
 	TP_printk("[%p] read io[%#x] = %#x", __entry->priv, __entry->offs, __entry->val)
 );
 
+TRACE_EVENT(iwlwifi_dev_iowrite8,
+	TP_PROTO(struct iwl_priv *priv, u32 offs, u8 val),
+	TP_ARGS(priv, offs, val),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(u32, offs)
+		__field(u8, val)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv, __entry->offs, __entry->val)
+);
+
 TRACE_EVENT(iwlwifi_dev_iowrite32,
 	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
 	TP_ARGS(priv, offs, val),
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index d0a358c..e552d4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -62,6 +62,26 @@
  *
  */
 
+static inline void _iwl_write8(struct iwl_priv *priv, u32 ofs, u8 val)
+{
+	trace_iwlwifi_dev_iowrite8(priv, ofs, val);
+	iowrite8(val, priv->hw_base + ofs);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write8(const char *f, u32 l, struct iwl_priv *priv,
+				 u32 ofs, u8 val)
+{
+	IWL_DEBUG_IO(priv, "write8(0x%08X, 0x%02X) - %s %d\n", ofs, val, f, l);
+	_iwl_write8(priv, ofs, val);
+}
+#define iwl_write8(priv, ofs, val) \
+	__iwl_write8(__FILE__, __LINE__, priv, ofs, val)
+#else
+#define iwl_write8(priv, ofs, val) _iwl_write8(priv, ofs, val)
+#endif
+
+
 static inline void _iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite32(priv, ofs, val);
-- 
1.5.6.3

