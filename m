Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40325C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F118F21019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170863;
	bh=xFMq2tY+Ga0EfLlCZz+elCGPkuiDPTesS25xZPCwzIk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=qzcGr5ds+yj8Lho8r4DTJgiMdTcWSJwzMpCswCwTXZFd8W6ar7H01dLbMWb4+t2fF
	 GXyhmNOZFrF0PwOMfWcFuq+wvu9jQeYAfDYBlKMUuN5AyMRd9qv0MvtoJHikDFdVdz
	 NAA8DSOUb/YTF5khxUcEzVFogkb/sW+EHJj2AU9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfAVPWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbfAVPWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:22:45 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ED54217D4;
        Tue, 22 Jan 2019 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170564;
        bh=xFMq2tY+Ga0EfLlCZz+elCGPkuiDPTesS25xZPCwzIk=;
        h=From:To:Cc:Subject:Date:From;
        b=rXE91PcZJ155L2U1icsIABhW/yyjdeeLljfKMHWAgjG6GWjkdyT9Jxk9kHF9oty/a
         1t5URtzYJLbNGBRejpSDqp9sVBrcvUh5eBf40fazAokvG9ApYacUVXDTHU3AAPr/64
         2+tQdYzYIJ8f3rVw2n5tENq1xEoeUPewGF0p11/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:21:23 +0100
Message-Id: <20190122152151.16139-24-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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
---
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  | 17 +---
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 84 +++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 12 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  8 +-
 5 files changed, 36 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 33b0af24a537..c52cdc538678 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1446,9 +1446,8 @@ static ssize_t iwl_dbgfs_quota_min_read(struct file *file,
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
@@ -1483,12 +1482,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
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
@@ -1537,12 +1530,6 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
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
index 52c361a6124c..adecd6d78d6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1631,9 +1631,8 @@ static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
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
@@ -1644,9 +1643,8 @@ static ssize_t iwl_dbgfs_d0i3_refs_write(struct iwl_mvm *mvm, char *buf,
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
@@ -1963,13 +1961,9 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 
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
@@ -2012,14 +2006,10 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 #endif
 	MVM_DEBUGFS_ADD_FILE(he_sniffer_params, mvm->debugfs_dir, 0200);
 
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
 
@@ -2027,13 +2017,9 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
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
@@ -2045,32 +2031,24 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
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
 
 	debugfs_create_file("mem", 0600, dbgfs_dir, mvm, &iwl_dbgfs_mem_ops);
 
@@ -2079,11 +2057,5 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
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
index 1aa690e081ff..565a6158634a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1682,14 +1682,13 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 
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
index 30c5127034a0..c16edcd17470 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -827,9 +827,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	min_backoff = iwl_mvm_min_backoff(mvm);
 	iwl_mvm_thermal_initialize(mvm, min_backoff);
 
-	err = iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
-	if (err)
-		goto out_unregister;
+	iwl_mvm_dbgfs_register(mvm, dbgfs_dir);
 
 	if (!iwl_mvm_has_new_rx_stats_api(mvm))
 		memset(&mvm->rx_stats_v3, 0,
@@ -848,14 +846,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
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
index 089972280daa..0402e235160e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4041,9 +4041,8 @@ static ssize_t iwl_dbgfs_ss_force_write(struct iwl_lq_sta *lq_sta, char *buf,
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
@@ -4071,9 +4070,6 @@ static void rs_drv_add_sta_debugfs(void *mvm, void *priv_sta,
 			  &lq_sta->pers.dbg_fixed_txp_reduction);
 
 	MVM_DEBUGFS_ADD_FILE_RS(ss_force, dir, 0600);
-	return;
-err:
-	IWL_ERR((struct iwl_mvm *)mvm, "Can't create debugfs entity\n");
 }
 
 void rs_remove_sta_debugfs(void *mvm, void *mvm_sta)
-- 
2.20.1

