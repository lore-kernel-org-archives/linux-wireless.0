Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764F9C282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4576B2146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfA0KTf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:35 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51368 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726803AbfA0KTf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXG-0001vC-UR; Sun, 27 Jan 2019 12:19:31 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:58 +0200
Message-Id: <20190127101908.6428-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/21] iwlwifi: mvm: disable completely low latency mode with debugfs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

We introduce a new state for latency, force mode, in force mode
you can enable always to be in low latency or always to be in non
low latency.

This is required for test mode in max TpT test.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  | 53 +++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 58 +++++++++++++++++--
 2 files changed, 103 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 1c0f84049573..2453ceabf00d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -543,21 +543,64 @@ static ssize_t iwl_dbgfs_low_latency_write(struct ieee80211_vif *vif, char *buf,
 	return count;
 }
 
+static ssize_t
+iwl_dbgfs_low_latency_force_write(struct ieee80211_vif *vif, char *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = mvmvif->mvm;
+	u8 value;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &value);
+	if (ret)
+		return ret;
+
+	if (value > NUM_LOW_LATENCY_FORCE)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+	if (value == LOW_LATENCY_FORCE_UNSET) {
+		iwl_mvm_update_low_latency(mvm, vif, false,
+					   LOW_LATENCY_DEBUGFS_FORCE);
+		iwl_mvm_update_low_latency(mvm, vif, false,
+					   LOW_LATENCY_DEBUGFS_FORCE_ENABLE);
+	} else {
+		iwl_mvm_update_low_latency(mvm, vif,
+					   value == LOW_LATENCY_FORCE_ON,
+					   LOW_LATENCY_DEBUGFS_FORCE);
+		iwl_mvm_update_low_latency(mvm, vif, true,
+					   LOW_LATENCY_DEBUGFS_FORCE_ENABLE);
+	}
+	mutex_unlock(&mvm->mutex);
+	return count;
+}
+
 static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
 					  char __user *user_buf,
 					  size_t count, loff_t *ppos)
 {
 	struct ieee80211_vif *vif = file->private_data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	char buf[30] = {};
+	char format[] = "traffic=%d\ndbgfs=%d\nvcmd=%d\nvif_type=%d\n"
+			"dbgfs_force_enable=%d\ndbgfs_force=%d\nactual=%d\n";
+
+	/*
+	 * all values in format are boolean so the size of format is enough
+	 * for holding the result string
+	 */
+	char buf[sizeof(format) + 1] = {};
 	int len;
 
-	len = scnprintf(buf, sizeof(buf) - 1,
-			"traffic=%d\ndbgfs=%d\nvcmd=%d\nvif_type=%d\n",
+	len = scnprintf(buf, sizeof(buf) - 1, format,
 			!!(mvmvif->low_latency & LOW_LATENCY_TRAFFIC),
 			!!(mvmvif->low_latency & LOW_LATENCY_DEBUGFS),
 			!!(mvmvif->low_latency & LOW_LATENCY_VCMD),
-			!!(mvmvif->low_latency & LOW_LATENCY_VIF_TYPE));
+			!!(mvmvif->low_latency & LOW_LATENCY_VIF_TYPE),
+			!!(mvmvif->low_latency &
+			   LOW_LATENCY_DEBUGFS_FORCE_ENABLE),
+			!!(mvmvif->low_latency & LOW_LATENCY_DEBUGFS_FORCE),
+			!!(mvmvif->low_latency_actual));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -710,6 +753,7 @@ MVM_DEBUGFS_READ_FILE_OPS(tx_pwr_lmt);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(pm_params, 32);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bf_params, 256);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(low_latency, 10);
+MVM_DEBUGFS_WRITE_FILE_OPS(low_latency_force, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(uapsd_misbehaving, 20);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(rx_phyinfo, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(quota_min, 32);
@@ -745,6 +789,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	MVM_DEBUGFS_ADD_FILE_VIF(tx_pwr_lmt, mvmvif->dbgfs_dir, 0400);
 	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, 0400);
 	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE_VIF(low_latency_force, mvmvif->dbgfs_dir, 0600);
 	MVM_DEBUGFS_ADD_FILE_VIF(uapsd_misbehaving, mvmvif->dbgfs_dir, 0600);
 	MVM_DEBUGFS_ADD_FILE_VIF(rx_phyinfo, mvmvif->dbgfs_dir, 0600);
 	MVM_DEBUGFS_ADD_FILE_VIF(quota_min, mvmvif->dbgfs_dir, 0600);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 59d655436a8f..5c9adf72691f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -299,18 +299,39 @@ enum iwl_bt_force_ant_mode {
 	BT_FORCE_ANT_MAX,
 };
 
+/**
+ * struct iwl_mvm_low_latency_force - low latency force mode set by debugfs
+ * @LOW_LATENCY_FORCE_UNSET: unset force mode
+ * @LOW_LATENCY_FORCE_ON: for low latency on
+ * @LOW_LATENCY_FORCE_OFF: for low latency off
+ * @NUM_LOW_LATENCY_FORCE: max num of modes
+ */
+enum iwl_mvm_low_latency_force {
+	LOW_LATENCY_FORCE_UNSET,
+	LOW_LATENCY_FORCE_ON,
+	LOW_LATENCY_FORCE_OFF,
+	NUM_LOW_LATENCY_FORCE
+};
+
 /**
 * struct iwl_mvm_low_latency_cause - low latency set causes
 * @LOW_LATENCY_TRAFFIC: indicates low latency traffic was detected
 * @LOW_LATENCY_DEBUGFS: low latency mode set from debugfs
 * @LOW_LATENCY_VCMD: low latency mode set from vendor command
 * @LOW_LATENCY_VIF_TYPE: low latency mode set because of vif type (ap)
+* @LOW_LATENCY_DEBUGFS_FORCE_ENABLE: indicate that force mode is enabled
+*	the actual set/unset is done with LOW_LATENCY_DEBUGFS_FORCE
+* @LOW_LATENCY_DEBUGFS_FORCE: low latency force mode from debugfs
+*	set this with LOW_LATENCY_DEBUGFS_FORCE_ENABLE flag
+*	in low_latency.
 */
 enum iwl_mvm_low_latency_cause {
 	LOW_LATENCY_TRAFFIC = BIT(0),
 	LOW_LATENCY_DEBUGFS = BIT(1),
 	LOW_LATENCY_VCMD = BIT(2),
 	LOW_LATENCY_VIF_TYPE = BIT(3),
+	LOW_LATENCY_DEBUGFS_FORCE_ENABLE = BIT(4),
+	LOW_LATENCY_DEBUGFS_FORCE = BIT(5),
 };
 
 /**
@@ -361,8 +382,10 @@ struct iwl_probe_resp_data {
  * @pm_enabled - Indicate if MAC power management is allowed
  * @monitor_active: indicates that monitor context is configured, and that the
  *	interface should get quota etc.
- * @low_latency: indicates low latency is set, see
- *	enum &iwl_mvm_low_latency_cause for causes.
+ * @low_latency: bit flags for low latency
+ *	see enum &iwl_mvm_low_latency_cause for causes.
+ * @low_latency_actual: boolean, indicates low latency is set,
+ *	as a result from low_latency bit flags and takes force into account.
  * @ps_disabled: indicates that this interface requires PS to be disabled
  * @queue_params: QoS params for this MAC
  * @bcast_sta: station used for broadcast packets. Used by the following
@@ -394,7 +417,8 @@ struct iwl_mvm_vif {
 	bool ap_ibss_active;
 	bool pm_enabled;
 	bool monitor_active;
-	u8 low_latency;
+	u8 low_latency: 6;
+	u8 low_latency_actual: 1;
 	bool ps_disabled;
 	struct iwl_mvm_vif_bf_data bf_data;
 
@@ -1918,17 +1942,43 @@ static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
 	 * binding, so this has no real impact. For now, just return
 	 * the current desired low-latency state.
 	 */
-	return mvmvif->low_latency;
+	return mvmvif->low_latency_actual;
 }
 
 static inline
 void iwl_mvm_vif_set_low_latency(struct iwl_mvm_vif *mvmvif, bool set,
 				 enum iwl_mvm_low_latency_cause cause)
 {
+	u8 new_state;
+
 	if (set)
 		mvmvif->low_latency |= cause;
 	else
 		mvmvif->low_latency &= ~cause;
+
+	/*
+	 * if LOW_LATENCY_DEBUGFS_FORCE_ENABLE is enabled no changes are
+	 * allowed to actual mode.
+	 */
+	if (mvmvif->low_latency & LOW_LATENCY_DEBUGFS_FORCE_ENABLE &&
+	    cause != LOW_LATENCY_DEBUGFS_FORCE_ENABLE)
+		return;
+
+	if (cause == LOW_LATENCY_DEBUGFS_FORCE_ENABLE && set)
+		/*
+		 * We enter force state
+		 */
+		new_state = !!(mvmvif->low_latency &
+			       LOW_LATENCY_DEBUGFS_FORCE);
+	else
+		/*
+		 * Check if any other one set low latency
+		 */
+		new_state = !!(mvmvif->low_latency &
+				  ~(LOW_LATENCY_DEBUGFS_FORCE_ENABLE |
+				    LOW_LATENCY_DEBUGFS_FORCE));
+
+	mvmvif->low_latency_actual = new_state;
 }
 
 /* Return a bitmask with all the hw supported queues, except for the
-- 
2.20.1

