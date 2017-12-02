Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48572 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752252AbdLBQ3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:49 +0200
Message-Id: <20171202162858.4167-7-luca@coelho.fi> (sfid-20171202_172916_030598_EA168E15)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 06/15] iwlwifi: mvm: rs: add ops for the new rate scaling in the FW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch introduces a new instance of rate_control_ops for
the new API (adding only empty stubs here and the subsequent
patches in the series will fill in the implementation).
The decision which API to use is done during the register
step according to FW TLV.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c    | 67 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 89 +++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h       | 14 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  7 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  8 +-
 8 files changed, 148 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index a47635c32c11..9ffd21918b5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_IWLMVM)   += iwlmvm.o
 iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o rxmq.o tx.o binding.o quota.o sta.o sf.o
-iwlmvm-y += scan.o time-event.o rs.o
+iwlmvm-y += scan.o time-event.o rs.o rs-fw.o
 iwlmvm-y += power.o coex.o
 iwlmvm-y += tt.o offloading.o tdls.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4ff099f462fb..e7abca2441a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -460,7 +460,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	/* this is the case for CCK frames, it's better (only 8) for OFDM */
 	hw->radiotap_timestamp.accuracy = 22;
 
-	hw->rate_control_algorithm = "iwl-mvm-rs";
+	if (!fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+		hw->rate_control_algorithm = RS_NAME;
+
 	hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
 	hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 7078b7e458be..a38a55327bcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -127,11 +127,8 @@ static int __init iwl_mvm_init(void)
 	}
 
 	ret = iwl_opmode_register("iwlmvm", &iwl_mvm_ops);
-
-	if (ret) {
+	if (ret)
 		pr_err("Unable to register MVM op_mode: %d\n", ret);
-		iwl_mvm_rate_control_unregister();
-	}
 
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
new file mode 100644
index 000000000000..1e4b6f1685d9
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -0,0 +1,67 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2017        Intel Deutschland GmbH
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
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <linuxwifi@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2017        Intel Deutschland GmbH
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
+ *
+ *****************************************************************************/
+#include "rs.h"
+#include "fw-api.h"
+#include "sta.h"
+#include "iwl-op-mode.h"
+#include "mvm.h"
+
+void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+		     enum nl80211_band band)
+{
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 739c47dbc6e8..3dd6535ed922 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -42,8 +42,6 @@
 #include "mvm.h"
 #include "debugfs.h"
 
-#define RS_NAME "iwl-mvm-rs"
-
 #define IWL_RATE_MAX_WINDOW		62	/* # tx in history window */
 
 /* Calculations of success ratio are done in fixed point where 12800 is 100%.
@@ -1416,13 +1414,13 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 /*
  * mac80211 sends us Tx status
  */
-static void rs_mac80211_tx_status(void *mvm_r,
-				  struct ieee80211_supported_band *sband,
-				  struct ieee80211_sta *sta, void *priv_sta,
-				  struct sk_buff *skb)
+static void rs_drv_mac80211_tx_status(void *mvm_r,
+				      struct ieee80211_supported_band *sband,
+				      struct ieee80211_sta *sta, void *priv_sta,
+				      struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_r;
+	struct iwl_op_mode *op_mode = mvm_r;
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
@@ -2857,8 +2855,9 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, init);
 }
 
-static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
-			struct ieee80211_tx_rate_control *txrc)
+static void rs_drv_get_rate(void *mvm_r, struct ieee80211_sta *sta,
+			    void *mvm_sta,
+			    struct ieee80211_tx_rate_control *txrc)
 {
 	struct iwl_op_mode *op_mode = mvm_r;
 	struct iwl_mvm *mvm __maybe_unused = IWL_OP_MODE_GET_MVM(op_mode);
@@ -2900,8 +2899,8 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 	}
 }
 
-static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
-			  gfp_t gfp)
+static void *rs_drv_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
+			      gfp_t gfp)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_op_mode *op_mode = (struct iwl_op_mode *)mvm_rate;
@@ -3037,7 +3036,7 @@ static void rs_vht_init(struct iwl_mvm *mvm,
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-static void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm)
+void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm)
 {
 	spin_lock_bh(&mvm->drv_stats_lock);
 	memset(&mvm->drv_rx_stats, 0, sizeof(mvm->drv_rx_stats));
@@ -3105,8 +3104,8 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
 /*
  * Called after adding a new station to initialize rate scaling
  */
-void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  enum nl80211_band band, bool init)
+static void rs_drv_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			     enum nl80211_band band, bool init)
 {
 	int i, j;
 	struct ieee80211_hw *hw = mvm->hw;
@@ -3188,16 +3187,15 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	rs_initialize_lq(mvm, sta, lq_sta, band, init);
 }
 
-static void rs_rate_update(void *mvm_r,
-			   struct ieee80211_supported_band *sband,
-			   struct cfg80211_chan_def *chandef,
-			   struct ieee80211_sta *sta, void *priv_sta,
-			   u32 changed)
+static void rs_drv_rate_update(void *mvm_r,
+			       struct ieee80211_supported_band *sband,
+			       struct cfg80211_chan_def *chandef,
+			       struct ieee80211_sta *sta,
+			       void *priv_sta, u32 changed)
 {
+	struct iwl_op_mode *op_mode = mvm_r;
+	struct iwl_mvm *mvm __maybe_unused = IWL_OP_MODE_GET_MVM(op_mode);
 	u8 tid;
-	struct iwl_op_mode *op_mode  =
-			(struct iwl_op_mode *)mvm_r;
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
 	if (!iwl_mvm_sta_from_mac80211(sta)->vif)
 		return;
@@ -3564,14 +3562,14 @@ static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
 	return hw->priv;
 }
+
 /* rate scale requires free function to be implemented */
 static void rs_free(void *mvm_rate)
 {
 	return;
 }
 
-static void rs_free_sta(void *mvm_r, struct ieee80211_sta *sta,
-			void *mvm_sta)
+static void rs_free_sta(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta)
 {
 	struct iwl_op_mode *op_mode __maybe_unused = mvm_r;
 	struct iwl_mvm *mvm __maybe_unused = IWL_OP_MODE_GET_MVM(op_mode);
@@ -3982,7 +3980,8 @@ static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
 
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(ss_force, 32);
 
-static void rs_add_debugfs(void *mvm, void *priv_sta, struct dentry *dir)
+static void rs_drv_add_sta_debugfs(void *mvm, void *priv_sta,
+				   struct dentry *dir)
 {
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_mvm_sta *mvmsta;
@@ -4009,7 +4008,7 @@ static void rs_add_debugfs(void *mvm, void *priv_sta, struct dentry *dir)
 	IWL_ERR((struct iwl_mvm *)mvm, "Can't create debugfs entity\n");
 }
 
-static void rs_remove_debugfs(void *mvm, void *mvm_sta)
+void rs_remove_sta_debugfs(void *mvm, void *mvm_sta)
 {
 }
 #endif
@@ -4019,37 +4018,47 @@ static void rs_remove_debugfs(void *mvm, void *mvm_sta)
  * the station is added. Since mac80211 calls this function before a
  * station is added we ignore it.
  */
-static void rs_rate_init_stub(void *mvm_r,
-			      struct ieee80211_supported_band *sband,
-			      struct cfg80211_chan_def *chandef,
-			      struct ieee80211_sta *sta, void *mvm_sta)
+static void rs_rate_init_ops(void *mvm_r,
+			     struct ieee80211_supported_band *sband,
+			     struct cfg80211_chan_def *chandef,
+			     struct ieee80211_sta *sta, void *mvm_sta)
 {
 }
 
-static const struct rate_control_ops rs_mvm_ops = {
+/* ops for rate scaling implemented in the driver */
+static const struct rate_control_ops rs_mvm_ops_drv = {
 	.name = RS_NAME,
-	.tx_status = rs_mac80211_tx_status,
-	.get_rate = rs_get_rate,
-	.rate_init = rs_rate_init_stub,
+	.tx_status = rs_drv_mac80211_tx_status,
+	.get_rate = rs_drv_get_rate,
+	.rate_init = rs_rate_init_ops,
 	.alloc = rs_alloc,
 	.free = rs_free,
-	.alloc_sta = rs_alloc_sta,
+	.alloc_sta = rs_drv_alloc_sta,
 	.free_sta = rs_free_sta,
-	.rate_update = rs_rate_update,
+	.rate_update = rs_drv_rate_update,
 #ifdef CONFIG_MAC80211_DEBUGFS
-	.add_sta_debugfs = rs_add_debugfs,
-	.remove_sta_debugfs = rs_remove_debugfs,
+	.add_sta_debugfs = rs_drv_add_sta_debugfs,
+	.remove_sta_debugfs = rs_remove_sta_debugfs,
 #endif
 };
 
+void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			  enum nl80211_band band, bool init)
+{
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+		rs_fw_rate_init(mvm, sta, band);
+	else
+		rs_drv_rate_init(mvm, sta, band, init);
+}
+
 int iwl_mvm_rate_control_register(void)
 {
-	return ieee80211_rate_control_register(&rs_mvm_ops);
+	return ieee80211_rate_control_register(&rs_mvm_ops_drv);
 }
 
 void iwl_mvm_rate_control_unregister(void)
 {
-	ieee80211_rate_control_unregister(&rs_mvm_ops);
+	ieee80211_rate_control_unregister(&rs_mvm_ops_drv);
 }
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 5075a8061c82..eb92ded8a4dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -36,6 +36,8 @@
 #include "fw-api.h"
 #include "iwl-trans.h"
 
+#define RS_NAME "iwl-mvm-rs"
+
 struct iwl_rs_rate_info {
 	u8 plcp;	  /* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_ht_siso;  /* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
@@ -438,4 +440,16 @@ struct iwl_mvm_sta;
 
 int iwl_mvm_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			  bool enable);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm);
+#endif
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+void rs_remove_sta_debugfs(void *mvm, void *mvm_sta);
+#endif
+
+void iwl_mvm_rs_add_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta);
+void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+		     enum nl80211_band band);
 #endif /* __rs__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 12875f773a86..6ed9a8eae107 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1439,6 +1439,13 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 			goto err;
 	}
 
+	/*
+	 * if rs is registered with mac80211, then "add station" will be handled
+	 * via the corresponding ops, otherwise need to notify rate scaling here
+	 */
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TLC_OFFLOAD))
+		iwl_mvm_rs_add_sta(mvm, mvm_sta);
+
 update_fw:
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, sta_update, sta_flags);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 9e7beecf043a..b65b4e8f8606 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1718,8 +1718,12 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 		ba_info->band = chanctx_conf->def.chan->band;
 		iwl_mvm_hwrate_to_tx_status(rate, ba_info);
 
-		IWL_DEBUG_TX_REPLY(mvm, "No reclaim. Update rs directly\n");
-		iwl_mvm_rs_tx_status(mvm, sta, tid, ba_info, false);
+		if (!fw_has_capa(&mvm->fw->ucode_capa,
+				 IWL_UCODE_TLV_CAPA_TLC_OFFLOAD)) {
+			IWL_DEBUG_TX_REPLY(mvm,
+					   "No reclaim. Update rs directly\n");
+			iwl_mvm_rs_tx_status(mvm, sta, tid, ba_info, false);
+		}
 	}
 
 out:
-- 
2.15.0
