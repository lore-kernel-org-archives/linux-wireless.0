Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab1JNUog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/6] iwlagn: remove unnecessary type for tracing operations
Date: Fri, 14 Oct 2011 12:54:44 -0700
Message-Id: <1318622088-14679-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224446_826790_A91793D4)
In-Reply-To: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The device tracing routines only use the priv pointer as an opaque
value.  Change from a typed iwl_priv pointer to a null pointer and
eliminate the need to include iwl_priv.h.  CMD_ASYNC is defined in
iwl_shared.h which is the only reason it is included.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   23 +++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index a635a7e..2a2c8de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -28,7 +28,7 @@
 
 /* sparse doesn't like tracepoint macros */
 #ifndef __CHECKER__
-#include "iwl-dev.h"
+#include "iwl-trans.h"
 
 #define CREATE_TRACE_POINTS
 #include "iwl-devtrace.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 8a51c5c..f9d3319 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -29,7 +29,6 @@
 
 #include <linux/tracepoint.h>
 
-struct iwl_priv;
 
 #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
 #undef TRACE_EVENT
@@ -37,14 +36,14 @@ struct iwl_priv;
 static inline void trace_ ## name(proto) {}
 #endif
 
-#define PRIV_ENTRY	__field(struct iwl_priv *, priv)
+#define PRIV_ENTRY	__field(void *, priv)
 #define PRIV_ASSIGN	__entry->priv = priv
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_io
 
 TRACE_EVENT(iwlwifi_dev_ioread32,
-	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
+	TP_PROTO(void *priv, u32 offs, u32 val),
 	TP_ARGS(priv, offs, val),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
@@ -60,7 +59,7 @@ TRACE_EVENT(iwlwifi_dev_ioread32,
 );
 
 TRACE_EVENT(iwlwifi_dev_iowrite8,
-	TP_PROTO(struct iwl_priv *priv, u32 offs, u8 val),
+	TP_PROTO(void *priv, u32 offs, u8 val),
 	TP_ARGS(priv, offs, val),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
@@ -76,7 +75,7 @@ TRACE_EVENT(iwlwifi_dev_iowrite8,
 );
 
 TRACE_EVENT(iwlwifi_dev_iowrite32,
-	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
+	TP_PROTO(void *priv, u32 offs, u32 val),
 	TP_ARGS(priv, offs, val),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
@@ -95,7 +94,7 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 #define TRACE_SYSTEM iwlwifi_ucode
 
 TRACE_EVENT(iwlwifi_dev_ucode_cont_event,
-	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
+	TP_PROTO(void *priv, u32 time, u32 data, u32 ev),
 	TP_ARGS(priv, time, data, ev),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
@@ -115,7 +114,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_cont_event,
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
-	TP_PROTO(struct iwl_priv *priv, u32 wraps, u32 n_entry, u32 p_entry),
+	TP_PROTO(void *priv, u32 wraps, u32 n_entry, u32 p_entry),
 	TP_ARGS(priv, wraps, n_entry, p_entry),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
@@ -139,7 +138,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
-	TP_PROTO(struct iwl_priv *priv, u32 flags,
+	TP_PROTO(void *priv, u32 flags,
 		 const void *hcmd0, size_t len0,
 		 const void *hcmd1, size_t len1,
 		 const void *hcmd2, size_t len2),
@@ -164,7 +163,7 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 );
 
 TRACE_EVENT(iwlwifi_dev_rx,
-	TP_PROTO(struct iwl_priv *priv, void *rxbuf, size_t len),
+	TP_PROTO(void *priv, void *rxbuf, size_t len),
 	TP_ARGS(priv, rxbuf, len),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
@@ -179,7 +178,7 @@ TRACE_EVENT(iwlwifi_dev_rx,
 );
 
 TRACE_EVENT(iwlwifi_dev_tx,
-	TP_PROTO(struct iwl_priv *priv, void *tfd, size_t tfdlen,
+	TP_PROTO(void *priv, void *tfd, size_t tfdlen,
 		 void *buf0, size_t buf0_len,
 		 void *buf1, size_t buf1_len),
 	TP_ARGS(priv, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
@@ -211,7 +210,7 @@ TRACE_EVENT(iwlwifi_dev_tx,
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_error,
-	TP_PROTO(struct iwl_priv *priv, u32 desc, u32 tsf_low,
+	TP_PROTO(void *priv, u32 desc, u32 tsf_low,
 		 u32 data1, u32 data2, u32 line, u32 blink1,
 		 u32 blink2, u32 ilink1, u32 ilink2, u32 bcon_time,
 		 u32 gp1, u32 gp2, u32 gp3, u32 ucode_ver, u32 hw_ver,
@@ -271,7 +270,7 @@ TRACE_EVENT(iwlwifi_dev_ucode_error,
 );
 
 TRACE_EVENT(iwlwifi_dev_ucode_event,
-	TP_PROTO(struct iwl_priv *priv, u32 time, u32 data, u32 ev),
+	TP_PROTO(void *priv, u32 time, u32 data, u32 ev),
 	TP_ARGS(priv, time, data, ev),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
-- 
1.7.0.4

