Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFF1C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1303218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfCVOAh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:37 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727630AbfCVOAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:36 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khj-0000bK-8a; Fri, 22 Mar 2019 15:59:27 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Date:   Fri, 22 Mar 2019 15:58:57 +0200
Message-Id: <20190322135903.10631-19-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 18/24] iwlwifi: mvm: no need to check return value of debugfs_create functions
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  | 17 +---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 89 +++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 12 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  8 +-
 5 files changed, 38 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 2453ceabf00d..9bf2407c9b4b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -743,9 +743,8 @@ static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct ieee80211_vif)
 #define MVM_DEBUGFS_ADD_FILE_VIF(name, parent, mode) do {		\
-		if (!debugfs_create_file(#name, mode, parent, vif,	\
-					 &iwl_dbgfs_##name##_ops))	\
-			goto err;					\
+		debugfs_create_file(#name, mode, parent, vif,		\
+				    &iwl_dbgfs_##name##_ops);		\
 	} while (0)
 
 MVM_DEBUGFS_READ_FILE_OPS(mac_params);
@@ -775,12 +774,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
 
-	if (!mvmvif->dbgfs_dir) {
-		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
-			dbgfs_dir);
-		return;
-	}
-
 	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
 	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p)))
@@ -812,12 +805,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	mvmvif->dbgfs_slink = debugfs_create_symlink(dbgfs_dir->d_name.name,
 						     mvm->debugfs_dir, buf);
-	if (!mvmvif->dbgfs_slink)
-		IWL_ERR(mvm, "Can't create debugfs symbolic link under %pd\n",
-			dbgfs_dir);
-	return;
-err:
-	IWL_ERR(mvm, "Can't create debugfs entity\n");
 }
 
 void iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 472d330661d3..d4ff6b44de2c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1696,9 +1696,8 @@ static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
 #define MVM_DEBUGFS_ADD_FILE_ALIAS(alias, name, parent, mode) do {	\
-		if (!debugfs_create_file(alias, mode, parent, mvm,	\
-					 &iwl_dbgfs_##name##_ops))	\
-			goto err;					\
+		debugfs_create_file(alias, mode, parent, mvm,		\
+				    &iwl_dbgfs_##name##_ops);		\
 	} while (0)
 #define MVM_DEBUGFS_ADD_FILE(name, parent, mode) \
 	MVM_DEBUGFS_ADD_FILE_ALIAS(#name, name, parent, mode)
@@ -1709,9 +1708,8 @@ static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
 	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct ieee80211_sta)
 
 #define MVM_DEBUGFS_ADD_STA_FILE_ALIAS(alias, name, parent, mode) do {	\
-		if (!debugfs_create_file(alias, mode, parent, sta,	\
-					 &iwl_dbgfs_##name##_ops))	\
-			goto err;					\
+		debugfs_create_file(alias, mode, parent, sta,		\
+				    &iwl_dbgfs_##name##_ops);		\
 	} while (0)
 #define MVM_DEBUGFS_ADD_STA_FILE(name, parent, mode) \
 	MVM_DEBUGFS_ADD_STA_FILE_ALIAS(#name, name, parent, mode)
@@ -2092,13 +2090,9 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	if (iwl_mvm_has_tlc_offload(mvm))
 		MVM_DEBUGFS_ADD_STA_FILE(rs_data, dir, 0400);
-
-	return;
-err:
-	IWL_ERR(mvm, "Can't create the mvm station debugfs entry\n");
 }
 
-int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
+void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 {
 	struct dentry *bcast_dir __maybe_unused;
 	char buf[100];
@@ -2142,14 +2136,10 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 #endif
 	MVM_DEBUGFS_ADD_FILE(he_sniffer_params, mvm->debugfs_dir, 0600);
 
-	if (!debugfs_create_bool("enable_scan_iteration_notif",
-				 0600,
-				 mvm->debugfs_dir,
-				 &mvm->scan_iter_notif_enabled))
-		goto err;
-	if (!debugfs_create_bool("drop_bcn_ap_mode", 0600,
-				 mvm->debugfs_dir, &mvm->drop_bcn_ap_mode))
-		goto err;
+	debugfs_create_bool("enable_scan_iteration_notif", 0600,
+			    mvm->debugfs_dir, &mvm->scan_iter_notif_enabled);
+	debugfs_create_bool("drop_bcn_ap_mode", 0600, mvm->debugfs_dir,
+			    &mvm->drop_bcn_ap_mode);
 
 	MVM_DEBUGFS_ADD_FILE(uapsd_noagg_bssids, mvm->debugfs_dir, S_IRUSR);
 
@@ -2157,13 +2147,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
 		bcast_dir = debugfs_create_dir("bcast_filtering",
 					       mvm->debugfs_dir);
-		if (!bcast_dir)
-			goto err;
 
-		if (!debugfs_create_bool("override", 0600,
-					 bcast_dir,
-					 &mvm->dbgfs_bcast_filtering.override))
-			goto err;
+		debugfs_create_bool("override", 0600, bcast_dir,
+				    &mvm->dbgfs_bcast_filtering.override);
 
 		MVM_DEBUGFS_ADD_FILE_ALIAS("filters", bcast_filters,
 					   bcast_dir, 0600);
@@ -2175,35 +2161,26 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 #ifdef CONFIG_PM_SLEEP
 	MVM_DEBUGFS_ADD_FILE(d3_sram, mvm->debugfs_dir, 0600);
 	MVM_DEBUGFS_ADD_FILE(d3_test, mvm->debugfs_dir, 0400);
-	if (!debugfs_create_bool("d3_wake_sysassert", 0600,
-				 mvm->debugfs_dir, &mvm->d3_wake_sysassert))
-		goto err;
-	if (!debugfs_create_u32("last_netdetect_scans", 0400,
-				mvm->debugfs_dir, &mvm->last_netdetect_scans))
-		goto err;
+	debugfs_create_bool("d3_wake_sysassert", 0600, mvm->debugfs_dir,
+			    &mvm->d3_wake_sysassert);
+	debugfs_create_u32("last_netdetect_scans", 0400, mvm->debugfs_dir,
+			   &mvm->last_netdetect_scans);
 #endif
 
-	if (!debugfs_create_u8("ps_disabled", 0400,
-			       mvm->debugfs_dir, &mvm->ps_disabled))
-		goto err;
-	if (!debugfs_create_blob("nvm_hw", 0400,
-				 mvm->debugfs_dir, &mvm->nvm_hw_blob))
-		goto err;
-	if (!debugfs_create_blob("nvm_sw", 0400,
-				 mvm->debugfs_dir, &mvm->nvm_sw_blob))
-		goto err;
-	if (!debugfs_create_blob("nvm_calib", 0400,
-				 mvm->debugfs_dir, &mvm->nvm_calib_blob))
-		goto err;
-	if (!debugfs_create_blob("nvm_prod", 0400,
-				 mvm->debugfs_dir, &mvm->nvm_prod_blob))
-		goto err;
-	if (!debugfs_create_blob("nvm_phy_sku", 0400,
-				 mvm->debugfs_dir, &mvm->nvm_phy_sku_blob))
-		goto err;
-	if (!debugfs_create_blob("nvm_reg", S_IRUSR,
-				 mvm->debugfs_dir, &mvm->nvm_reg_blob))
-		goto err;
+	debugfs_create_u8("ps_disabled", 0400, mvm->debugfs_dir,
+			  &mvm->ps_disabled);
+	debugfs_create_blob("nvm_hw", 0400, mvm->debugfs_dir,
+			    &mvm->nvm_hw_blob);
+	debugfs_create_blob("nvm_sw", 0400, mvm->debugfs_dir,
+			    &mvm->nvm_sw_blob);
+	debugfs_create_blob("nvm_calib", 0400, mvm->debugfs_dir,
+			    &mvm->nvm_calib_blob);
+	debugfs_create_blob("nvm_prod", 0400, mvm->debugfs_dir,
+			    &mvm->nvm_prod_blob);
+	debugfs_create_blob("nvm_phy_sku", 0400, mvm->debugfs_dir,
+			    &mvm->nvm_phy_sku_blob);
+	debugfs_create_blob("nvm_reg", S_IRUSR,
+			    mvm->debugfs_dir, &mvm->nvm_reg_blob);
 
 	debugfs_create_file("mem", 0600, dbgfs_dir, mvm, &iwl_dbgfs_mem_ops);
 
@@ -2212,11 +2189,5 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	 * exists (before the opmode exists which removes the target.)
 	 */
 	snprintf(buf, 100, "../../%pd2", dbgfs_dir->d_parent);
-	if (!debugfs_create_symlink("iwlwifi", mvm->hw->wiphy->debugfsdir, buf))
-		goto err;
-
-	return 0;
-err:
-	IWL_ERR(mvm, "Can't create the mvm debugfs directory\n");
-	return -ENOMEM;
+	debugfs_create_symlink("iwlwifi", mvm->hw->wiphy->debugfsdir, buf);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 61b6dbc83600..45d7a868e759 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1786,14 +1786,13 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 
 /* MVM debugfs */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir);
+void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir);
 void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 #else
-static inline int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm,
-					 struct dentry *dbgfs_dir)
+static inline void iwl_mvm_dbgfs_register(struct iwl_mvm *mvm,
+					  struct dentry *dbgfs_dir)
 {
-	return 0;
 }
 static inline void
 iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 8e2e4fa7914e..55d399899d1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -862,9 +862,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	min_backoff = iwl_mvm_min_backoff(mvm);
 	iwl_mvm_thermal_initialize(mvm, min_backoff);
 
-	err = iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
-	if (err)
-		goto out_unregister;
+	iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
 
 	if (!iwl_mvm_has_new_rx_stats_api(mvm))
 		memset(&mvm->rx_stats_v3, 0,
@@ -881,14 +879,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	return op_mode;
 
- out_unregister:
-	if (iwlmvm_mod_params.init_dbg)
-		return op_mode;
-
-	ieee80211_unregister_hw(mvm->hw);
-	mvm->hw_registered = false;
-	iwl_mvm_leds_exit(mvm);
-	iwl_mvm_thermal_exit(mvm);
  out_free:
 	iwl_fw_flush_dump(&mvm->fwrt);
 	iwl_fw_runtime_free(&mvm->fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index e231a44d2423..c182821ab22b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4078,9 +4078,8 @@ static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
 #define MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz) \
 	_MVM_DEBUGFS_READ_WRITE_FILE_OPS(name, bufsz, struct iwl_lq_sta)
 #define MVM_DEBUGFS_ADD_FILE_RS(name, parent, mode) do {		\
-		if (!debugfs_create_file(#name, mode, parent, lq_sta,	\
-					 &iwl_dbgfs_##name##_ops))	\
-			goto err;					\
+		debugfs_create_file(#name, mode, parent, lq_sta,	\
+				    &iwl_dbgfs_##name##_ops);		\
 	} while (0)
 
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(ss_force, 32);
@@ -4108,9 +4107,6 @@ static void rs_drv_add_sta_debugfs(void *mvm, void *priv_sta,
 			  &lq_sta->pers.dbg_fixed_txp_reduction);
 
 	MVM_DEBUGFS_ADD_FILE_RS(ss_force, dir, 0600);
-	return;
-err:
-	IWL_ERR((struct iwl_mvm *)mvm, "Can't create debugfs entity\n");
 }
 
 void rs_remove_sta_debugfs(void *mvm, void *mvm_sta)
-- 
2.20.1

