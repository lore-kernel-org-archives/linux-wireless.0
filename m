Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab0JGXIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/22] iwlwifi: clean up declarations
Date: Thu,  7 Oct 2010 16:07:56 -0700
Message-Id: <1286492881-15743-18-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A number of declarations in iwl-core.h should
be in agn specific files, and also rename the
iwl-calib.h file to iwl-agn-calib.h to better
reflect that it belongs to agn.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h |   86 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |   23 +++++++
 drivers/net/wireless/iwlwifi/iwl-calib.h     |   82 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h      |   33 ----------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c        |    1 -
 11 files changed, 114 insertions(+), 121 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-calib.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-calib.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 28ba563..b207e3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -43,7 +43,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
-#include "iwl-calib.h"
+#include "iwl-agn-calib.h"
 #include "iwl-sta.h"
 #include "iwl-agn-led.h"
 #include "iwl-agn.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 4c5ab78..e2019e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -65,7 +65,7 @@
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
-#include "iwl-calib.h"
+#include "iwl-agn-calib.h"
 
 /*****************************************************************************
  * INIT calibrations framework
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
new file mode 100644
index 0000000..e37ae72
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -0,0 +1,86 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+#ifndef __iwl_calib_h__
+#define __iwl_calib_h__
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-commands.h"
+
+void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp);
+void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp);
+
+void iwl_init_sensitivity(struct iwl_priv *priv);
+void iwl_reset_run_time_calib(struct iwl_priv *priv);
+static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
+{
+
+	if (!priv->disable_chain_noise_cal &&
+	    priv->cfg->ops->utils->chain_noise_reset)
+		priv->cfg->ops->utils->chain_noise_reset(priv);
+}
+
+int iwl_send_calib_results(struct iwl_priv *priv);
+int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
+void iwl_calib_free_results(struct iwl_priv *priv);
+
+#endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 1e08eb4..bbd40b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -34,7 +34,7 @@
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
-#include "iwl-calib.h"
+#include "iwl-agn-calib.h"
 #include "iwl-sta.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index e1dd762..3a95379 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -38,6 +38,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
+#include "iwl-agn-calib.h"
 
 static const s8 iwlagn_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_VO,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b1af79e..763a93d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -57,7 +57,7 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-sta.h"
-#include "iwl-calib.h"
+#include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 1fca5af..b4deef4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -177,8 +177,15 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 		     struct iwl_rx_mem_buffer *rxb);
 void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 			 struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_handle(struct iwl_priv *priv);
 
 /* tx */
+void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+				 struct iwl_tx_queue *txq,
+				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
+int iwl_hw_tx_queue_init(struct iwl_priv *priv,
+			 struct iwl_tx_queue *txq);
 void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
@@ -289,4 +296,20 @@ void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 int iwl_update_bcast_stations(struct iwl_priv *priv);
 
+/* rate */
+static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
+{
+	return BIT(ant_idx) << RATE_MCS_ANT_POS;
+}
+
+static inline u8 iwl_hw_get_rate(__le32 rate_n_flags)
+{
+	return le32_to_cpu(rate_n_flags) & 0xFF;
+}
+
+static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
+{
+	return cpu_to_le32(flags|(u32)rate);
+}
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
deleted file mode 100644
index ba9523f..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *****************************************************************************/
-#ifndef __iwl_calib_h__
-#define __iwl_calib_h__
-
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-commands.h"
-
-void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp);
-void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp);
-
-void iwl_init_sensitivity(struct iwl_priv *priv);
-void iwl_reset_run_time_calib(struct iwl_priv *priv);
-static inline void iwl_chain_noise_reset(struct iwl_priv *priv)
-{
-
-	if (!priv->disable_chain_noise_cal &&
-	    priv->cfg->ops->utils->chain_noise_reset)
-		priv->cfg->ops->utils->chain_noise_reset(priv);
-}
-
-#endif /* __iwl_calib_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c01262c..a5e12b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -396,7 +396,6 @@ struct iwl_cfg {
 
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
-void iwl_activate_qos(struct iwl_priv *priv);
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
 int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
@@ -505,7 +504,6 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 ******************************************************/
 void iwl_cmd_queue_free(struct iwl_priv *priv);
 int iwl_rx_queue_alloc(struct iwl_priv *priv);
-void iwl_rx_handle(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
@@ -523,12 +521,6 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 /*****************************************************
 * TX
 ******************************************************/
-void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
-				 struct iwl_tx_queue *txq,
-				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
-int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-			 struct iwl_tx_queue *txq);
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
@@ -547,24 +539,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx);
 
-static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
-{
-	return BIT(ant_idx) << RATE_MCS_ANT_POS;
-}
-
-static inline u8 iwl_hw_get_rate(__le32 rate_n_flags)
-{
-	return le32_to_cpu(rate_n_flags) & 0xFF;
-}
-static inline u32 iwl_hw_get_rate_n_flags(__le32 rate_n_flags)
-{
-	return le32_to_cpu(rate_n_flags) & 0x1FFFF;
-}
-static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
-{
-	return cpu_to_le32(flags|(u32)rate);
-}
-
 /*******************************************************************************
  * Scanning
  ******************************************************************************/
@@ -600,13 +574,6 @@ void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
 
 #define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
 
-/*******************************************************************************
- * Calibrations - implemented in iwl-calib.c
- ******************************************************************************/
-int iwl_send_calib_results(struct iwl_priv *priv);
-int iwl_calib_set(struct iwl_calib_result *res, const u8 *buf, int len);
-void iwl_calib_free_results(struct iwl_priv *priv);
-
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index fc34031..96d9085 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -39,7 +39,6 @@
 #include "iwl-debug.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-calib.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 10be197..f436270 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -36,7 +36,6 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 #include "iwl-io.h"
-#include "iwl-calib.h"
 #include "iwl-helpers.h"
 /************************** RX-FUNCTIONS ****************************/
 /*
-- 
1.7.0.4

