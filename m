Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45713 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752600AbbIUU7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:41 +0300
Message-Id: <1442869141-31637-1-git-send-email-luca@coelho.fi> (sfid-20150921_225911_435956_E0AC391E)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 01/21] iwlwifi: mvm: remove netdetect debugfs entry
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This debugfs entry was implemented just as a proof-of-concept before
the full support for netdetect via cfg80211/mac80211 was implemented.
Now that we have a proper way to enable netdetect from userspace, this
entry is redundant and should be removed to avoid unnecessary
maintenance work.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 114 -----------------------------
 1 file changed, 114 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 7d69a55..08d2ae3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1214,118 +1214,6 @@ static ssize_t iwl_dbgfs_d3_sram_read(struct file *file, char __user *user_buf,
 
 	return ret;
 }
-
-#define MAX_NUM_ND_MATCHSETS 10
-
-static ssize_t iwl_dbgfs_netdetect_write(struct iwl_mvm *mvm, char *buf,
-					 size_t count, loff_t *ppos)
-{
-	const char *seps = ",\n";
-	char *buf_ptr = buf;
-	char *value_str = NULL;
-	int ret, i;
-
-	/* TODO: don't free if write is being called several times in one go */
-	if (mvm->nd_config) {
-		kfree(mvm->nd_config->match_sets);
-		kfree(mvm->nd_config);
-		mvm->nd_config = NULL;
-	}
-
-	mvm->nd_config = kzalloc(sizeof(*mvm->nd_config) +
-				 (11 * sizeof(struct ieee80211_channel *)),
-				 GFP_KERNEL);
-	if (!mvm->nd_config) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	mvm->nd_config->n_channels = 11;
-	mvm->nd_config->scan_width = NL80211_BSS_CHAN_WIDTH_20;
-	mvm->nd_config->interval = 5;
-	mvm->nd_config->min_rssi_thold = -80;
-	for (i = 0; i < mvm->nd_config->n_channels; i++)
-		mvm->nd_config->channels[i] = &mvm->nvm_data->channels[i];
-
-	mvm->nd_config->match_sets =
-		kcalloc(MAX_NUM_ND_MATCHSETS,
-			sizeof(*mvm->nd_config->match_sets),
-			GFP_KERNEL);
-	if (!mvm->nd_config->match_sets) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
-	while ((value_str = strsep(&buf_ptr, seps)) &&
-	       strlen(value_str)) {
-		struct cfg80211_match_set *set;
-
-		if (mvm->nd_config->n_match_sets >= MAX_NUM_ND_MATCHSETS) {
-			ret = -EINVAL;
-			goto out_free;
-		}
-
-		set = &mvm->nd_config->match_sets[mvm->nd_config->n_match_sets];
-		set->ssid.ssid_len = strlen(value_str);
-
-		if (set->ssid.ssid_len > IEEE80211_MAX_SSID_LEN) {
-			ret = -EINVAL;
-			goto out_free;
-		}
-
-		memcpy(set->ssid.ssid, value_str, set->ssid.ssid_len);
-
-		mvm->nd_config->n_match_sets++;
-	}
-
-	ret = count;
-
-	if (mvm->nd_config->n_match_sets)
-		goto out;
-
-out_free:
-	if (mvm->nd_config)
-		kfree(mvm->nd_config->match_sets);
-	kfree(mvm->nd_config);
-	mvm->nd_config = NULL;
-out:
-	return ret;
-}
-
-static ssize_t
-iwl_dbgfs_netdetect_read(struct file *file, char __user *user_buf,
-			 size_t count, loff_t *ppos)
-{
-	struct iwl_mvm *mvm = file->private_data;
-	size_t bufsz, ret;
-	char *buf;
-	int i, n_match_sets, pos = 0;
-
-	n_match_sets = mvm->nd_config ? mvm->nd_config->n_match_sets : 0;
-
-	bufsz = n_match_sets * (IEEE80211_MAX_SSID_LEN + 1) + 1;
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	for (i = 0; i < n_match_sets; i++) {
-		if (pos +
-		    mvm->nd_config->match_sets[i].ssid.ssid_len + 2 > bufsz) {
-			ret = -EIO;
-			goto out;
-		}
-
-		memcpy(buf + pos, mvm->nd_config->match_sets[i].ssid.ssid,
-		       mvm->nd_config->match_sets[i].ssid.ssid_len);
-		pos += mvm->nd_config->match_sets[i].ssid.ssid_len;
-		buf[pos++] = '\n';
-	}
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-out:
-	kfree(buf);
-	return ret;
-}
 #endif
 
 #define PRINT_MVM_REF(ref) do {						\
@@ -1503,7 +1391,6 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters_macs, 256);
 
 #ifdef CONFIG_PM_SLEEP
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d3_sram, 8);
-MVM_DEBUGFS_READ_WRITE_FILE_OPS(netdetect, 384);
 #endif
 
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
@@ -1572,7 +1459,6 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	if (!debugfs_create_u32("last_netdetect_scans", S_IRUSR,
 				mvm->debugfs_dir, &mvm->last_netdetect_scans))
 		goto err;
-	MVM_DEBUGFS_ADD_FILE(netdetect, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 #endif
 
 	if (!debugfs_create_u8("low_latency_agg_frame_limit", S_IRUSR | S_IWUSR,
-- 
2.5.1

