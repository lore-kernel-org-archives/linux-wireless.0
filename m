Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37046 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbaJ2LvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:09 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so1434417wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:07 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/25] iwlwifi: mvm: add debugfs entry to configure netdetect SSIDs
Date: Wed, 29 Oct 2014 13:50:28 +0200
Message-Id: <1414583446-11032-7-git-send-email-egrumbach@gmail.com> (sfid-20141029_125120_732587_053FD630)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Before we get all the chain (ie. mac80211, cfg80211, nl80211 and
userspace) changed to support net-detect, we can use this debugfs
entry for easy testing and as a proof of concept.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c      |   9 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 122 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |   4 +
 drivers/net/wireless/iwlwifi/mvm/ops.c     |   7 ++
 4 files changed, 142 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 7a66a09..0b3295e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1061,6 +1061,15 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 					    vif, mvmvif, ap_sta);
 		if (ret)
 			goto out;
+	} else if (mvm->nd_config) {
+		ret = iwl_mvm_switch_to_d3(mvm);
+		if (ret)
+			goto out;
+
+		ret = iwl_mvm_scan_offload_start(mvm, vif, mvm->nd_config,
+						 mvm->nd_ies);
+		if (ret)
+			goto out;
 	} else {
 		ret = 1;
 		goto out_noreset;
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 50527a9..2a61bac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1250,6 +1250,126 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 
 	return ret;
 }
+
+#define MAX_NUM_ND_MATCHSETS 10
+
+static ssize_t iwl_dbgfs_netdetect_write(struct iwl_mvm *mvm, char *buf,
+					 size_t count, loff_t *ppos)
+{
+	const char *seps = ",\n";
+	char *buf_ptr = buf;
+	char *value_str = NULL;
+	int ret, i;
+
+	/* TODO: don't free if write is being called several times in one go */
+	if (mvm->nd_config) {
+		kfree(mvm->nd_config->match_sets);
+		kfree(mvm->nd_config);
+		mvm->nd_config = NULL;
+		kfree(mvm->nd_ies);
+		mvm->nd_ies = NULL;
+	}
+
+	mvm->nd_ies = kzalloc(sizeof(*mvm->nd_ies), GFP_KERNEL);
+	if (!mvm->nd_ies)
+		return -ENOMEM;
+
+	mvm->nd_config = kzalloc(sizeof(*mvm->nd_config) +
+				 (11 * sizeof(struct ieee80211_channel *)),
+				 GFP_KERNEL);
+	if (!mvm->nd_config) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	mvm->nd_config->n_channels = 11;
+	mvm->nd_config->scan_width = NL80211_BSS_CHAN_WIDTH_20;
+	mvm->nd_config->interval = 5;
+	mvm->nd_config->min_rssi_thold = -80;
+	for (i = 0; i < mvm->nd_config->n_channels; i++)
+		mvm->nd_config->channels[i] = &mvm->nvm_data->channels[i];
+
+	mvm->nd_config->match_sets =
+		kcalloc(MAX_NUM_ND_MATCHSETS,
+			sizeof(*mvm->nd_config->match_sets),
+			GFP_KERNEL);
+	if (!mvm->nd_config->match_sets) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	while ((value_str = strsep(&buf_ptr, seps)) &&
+	       strlen(value_str)) {
+		struct cfg80211_match_set *set;
+
+		if (mvm->nd_config->n_match_sets >= MAX_NUM_ND_MATCHSETS) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		set = &mvm->nd_config->match_sets[mvm->nd_config->n_match_sets];
+		set->ssid.ssid_len = strlen(value_str);
+
+		if (set->ssid.ssid_len > IEEE80211_MAX_SSID_LEN) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		memcpy(set->ssid.ssid, value_str, set->ssid.ssid_len);
+
+		mvm->nd_config->n_match_sets++;
+	}
+
+	ret = count;
+
+	if (mvm->nd_config->n_match_sets)
+		goto out;
+
+out_free:
+	if (mvm->nd_config)
+		kfree(mvm->nd_config->match_sets);
+	kfree(mvm->nd_config);
+	mvm->nd_config = NULL;
+	kfree(mvm->nd_ies);
+	mvm->nd_ies = NULL;
+out:
+	return ret;
+}
+
+static ssize_t
+iwl_dbgfs_netdetect_read(struct file *file, char __user *user_buf,
+			 size_t count, loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+	size_t bufsz, ret;
+	char *buf;
+	int i, n_match_sets, pos = 0;
+
+	n_match_sets = mvm->nd_config ? mvm->nd_config->n_match_sets : 0;
+
+	bufsz = n_match_sets * (IEEE80211_MAX_SSID_LEN + 1) + 1;
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < n_match_sets; i++) {
+		if (pos +
+		    mvm->nd_config->match_sets[i].ssid.ssid_len + 2 > bufsz) {
+			ret = -EIO;
+			goto out;
+		}
+
+		memcpy(buf + pos, mvm->nd_config->match_sets[i].ssid.ssid,
+		       mvm->nd_config->match_sets[i].ssid.ssid_len);
+		pos += mvm->nd_config->match_sets[i].ssid.ssid_len;
+		buf[pos++] = '\n';
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+out:
+	kfree(buf);
+	return ret;
+}
 #endif
 
 #define PRINT_MVM_REF(ref) do {						\
@@ -1428,6 +1548,7 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
 
 #ifdef CONFIG_PM_SLEEP
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
+MVM_DEBUGFS_READ_WRITE_FILE_OPS(netdetect, 384);
 #endif
 
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
@@ -1487,6 +1608,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	if (!debugfs_create_bool("d3_wake_sysassert", S_IRUSR | S_IWUSR,
 				 mvm->debugfs_dir, &mvm->d3_wake_sysassert))
 		goto err;
+	MVM_DEBUGFS_ADD_FILE(netdetect, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 #endif
 
 	if (!debugfs_create_u8("low_latency_agg_frame_limit", S_IRUSR | S_IWUSR,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 14ec678..60aee62 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -659,6 +659,10 @@ struct iwl_mvm {
 #ifdef CONFIG_PM_SLEEP
 	struct wiphy_wowlan_support wowlan;
 	int gtk_ivlen, gtk_icvlen, ptk_ivlen, ptk_icvlen;
+
+	/* sched scan settings for net detect */
+	struct cfg80211_sched_scan_request *nd_config;
+	struct ieee80211_scan_ies *nd_ies;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	u32 d3_wake_sysassert; /* must be u32 for debugfs_create_bool */
 	bool d3_test_active;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 48cb25a..047d83d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -594,6 +594,13 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_IWLWIFI_DEBUGFS)
 	kfree(mvm->d3_resume_sram);
+	if (mvm->nd_config) {
+		kfree(mvm->nd_config->match_sets);
+		kfree(mvm->nd_config);
+		mvm->nd_config = NULL;
+		kfree(mvm->nd_ies);
+		mvm->nd_ies = NULL;
+	}
 #endif
 
 	iwl_trans_op_mode_leave(mvm->trans);
-- 
1.9.1

