Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43769 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBWT5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:33 -0500
Received: by mail-we0-f170.google.com with SMTP id w62so4089428wes.15
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/17] iwlwifi: mvm: add Rx frames statistics via debugfs
Date: Sun, 23 Feb 2014 21:57:04 +0200
Message-Id: <1393185428-8524-13-git-send-email-egrumbach@gmail.com> (sfid-20140223_205738_682297_DD80F662)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Collect statistics regarding rates and aggregations in Rx
frames and export the data via debugfs.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c |   72 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |   29 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/rs.c      |   73 +++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/rx.c      |   13 +++++
 4 files changed, 185 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 3278b48..e0ff43e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -531,6 +531,76 @@ static ssize_t iwl_dbgfs_fw_rx_stats_read(struct file *file,
 }
 #undef PRINT_STAT_LE32
 
+static ssize_t iwl_dbgfs_frame_stats_read(struct iwl_mvm *mvm,
+					  char __user *user_buf, size_t count,
+					  loff_t *ppos,
+					  struct iwl_mvm_frame_stats *stats)
+{
+	char *buff;
+	int pos = 0, idx, i;
+	int ret;
+	size_t bufsz = 1024;
+
+	buff = kmalloc(bufsz, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	spin_lock_bh(&mvm->drv_stats_lock);
+	pos += scnprintf(buff + pos, bufsz - pos,
+			 "Legacy/HT/VHT\t:\t%d/%d/%d\n",
+			 stats->legacy_frames,
+			 stats->ht_frames,
+			 stats->vht_frames);
+	pos += scnprintf(buff + pos, bufsz - pos, "20/40/80\t:\t%d/%d/%d\n",
+			 stats->bw_20_frames,
+			 stats->bw_40_frames,
+			 stats->bw_80_frames);
+	pos += scnprintf(buff + pos, bufsz - pos, "NGI/SGI\t\t:\t%d/%d\n",
+			 stats->ngi_frames,
+			 stats->sgi_frames);
+	pos += scnprintf(buff + pos, bufsz - pos, "SISO/MIMO2\t:\t%d/%d\n",
+			 stats->siso_frames,
+			 stats->mimo2_frames);
+	pos += scnprintf(buff + pos, bufsz - pos, "FAIL/SCSS\t:\t%d/%d\n",
+			 stats->fail_frames,
+			 stats->success_frames);
+	pos += scnprintf(buff + pos, bufsz - pos, "MPDUs agg\t:\t%d\n",
+			 stats->agg_frames);
+	pos += scnprintf(buff + pos, bufsz - pos, "A-MPDUs\t\t:\t%d\n",
+			 stats->ampdu_count);
+	pos += scnprintf(buff + pos, bufsz - pos, "Avg MPDUs/A-MPDU:\t%d\n",
+			 stats->ampdu_count > 0 ?
+			 (stats->agg_frames / stats->ampdu_count) : 0);
+
+	pos += scnprintf(buff + pos, bufsz - pos, "Last Rates\n");
+
+	idx = stats->last_frame_idx - 1;
+	for (i = 0; i < ARRAY_SIZE(stats->last_rates); i++) {
+		idx = (idx + 1) % ARRAY_SIZE(stats->last_rates);
+		if (stats->last_rates[idx] == 0)
+			continue;
+		pos += scnprintf(buff + pos, bufsz - pos, "Rate[%d]: ",
+				 (int)(ARRAY_SIZE(stats->last_rates) - i));
+		pos += rs_pretty_print_rate(buff + pos, stats->last_rates[idx]);
+	}
+	spin_unlock_bh(&mvm->drv_stats_lock);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, pos);
+	kfree(buff);
+
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_drv_rx_stats_read(struct file *file,
+					   char __user *user_buf, size_t count,
+					   loff_t *ppos)
+{
+	struct iwl_mvm *mvm = file->private_data;
+
+	return iwl_dbgfs_frame_stats_read(mvm, user_buf, count, ppos,
+					  &mvm->drv_rx_stats);
+}
+
 static ssize_t iwl_dbgfs_fw_restart_write(struct iwl_mvm *mvm, char *buf,
 					  size_t count, loff_t *ppos)
 {
@@ -959,6 +1029,7 @@ MVM_DEBUGFS_READ_FILE_OPS(bt_notif);
 MVM_DEBUGFS_READ_FILE_OPS(bt_cmd);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(disable_power_off, 64);
 MVM_DEBUGFS_READ_FILE_OPS(fw_rx_stats);
+MVM_DEBUGFS_READ_FILE_OPS(drv_rx_stats);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_restart, 10);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_nmi, 10);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
@@ -990,6 +1061,7 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir,
 				     S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_rx_stats, mvm->debugfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(drv_rx_stats, mvm->debugfs_dir, S_IRUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 823765e..5fb5109 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -425,6 +425,28 @@ struct iwl_mvm_tt_mgmt {
 	bool throttle;
 };
 
+#define IWL_MVM_NUM_LAST_FRAMES_UCODE_RATES 8
+
+struct iwl_mvm_frame_stats {
+	u32 legacy_frames;
+	u32 ht_frames;
+	u32 vht_frames;
+	u32 bw_20_frames;
+	u32 bw_40_frames;
+	u32 bw_80_frames;
+	u32 bw_160_frames;
+	u32 sgi_frames;
+	u32 ngi_frames;
+	u32 siso_frames;
+	u32 mimo2_frames;
+	u32 agg_frames;
+	u32 ampdu_count;
+	u32 success_frames;
+	u32 fail_frames;
+	u32 last_rates[IWL_MVM_NUM_LAST_FRAMES_UCODE_RATES];
+	int last_frame_idx;
+};
+
 struct iwl_mvm {
 	/* for logger access */
 	struct device *dev;
@@ -526,6 +548,9 @@ struct iwl_mvm {
 	struct debugfs_blob_wrapper nvm_sw_blob;
 	struct debugfs_blob_wrapper nvm_calib_blob;
 	struct debugfs_blob_wrapper nvm_prod_blob;
+
+	struct iwl_mvm_frame_stats drv_rx_stats;
+	spinlock_t drv_stats_lock;
 #endif
 
 	struct iwl_mvm_phy_ctxt phy_ctxts[NUM_PHY_CTX];
@@ -810,6 +835,10 @@ iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 /* rate scaling */
 int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init);
+void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm,
+				struct iwl_mvm_frame_stats *stats,
+				u32 rate, bool agg);
+int rs_pretty_print_rate(char *buf, const u32 rate);
 
 /* power management */
 int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 77c6e36..399709f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2240,6 +2240,73 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 	}
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+static void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm,
+				      struct iwl_mvm_frame_stats *stats)
+{
+	spin_lock_bh(&mvm->drv_stats_lock);
+	memset(stats, 0, sizeof(*stats));
+	spin_unlock_bh(&mvm->drv_stats_lock);
+}
+
+void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm,
+				struct iwl_mvm_frame_stats *stats,
+				u32 rate, bool agg)
+{
+	u8 nss = 0, mcs = 0;
+
+	spin_lock(&mvm->drv_stats_lock);
+
+	if (agg)
+		stats->agg_frames++;
+
+	stats->success_frames++;
+
+	switch (rate & RATE_MCS_CHAN_WIDTH_MSK) {
+	case RATE_MCS_CHAN_WIDTH_20:
+		stats->bw_20_frames++;
+		break;
+	case RATE_MCS_CHAN_WIDTH_40:
+		stats->bw_40_frames++;
+		break;
+	case RATE_MCS_CHAN_WIDTH_80:
+		stats->bw_80_frames++;
+		break;
+	default:
+		WARN_ONCE(1, "bad BW. rate 0x%x", rate);
+	}
+
+	if (rate & RATE_MCS_HT_MSK) {
+		stats->ht_frames++;
+		mcs = rate & RATE_HT_MCS_RATE_CODE_MSK;
+		nss = ((rate & RATE_HT_MCS_NSS_MSK) >> RATE_HT_MCS_NSS_POS) + 1;
+	} else if (rate & RATE_MCS_VHT_MSK) {
+		stats->vht_frames++;
+		mcs = rate & RATE_VHT_MCS_RATE_CODE_MSK;
+		nss = ((rate & RATE_VHT_MCS_NSS_MSK) >>
+		       RATE_VHT_MCS_NSS_POS) + 1;
+	} else {
+		stats->legacy_frames++;
+	}
+
+	if (nss == 1)
+		stats->siso_frames++;
+	else if (nss == 2)
+		stats->mimo2_frames++;
+
+	if (rate & RATE_MCS_SGI_MSK)
+		stats->sgi_frames++;
+	else
+		stats->ngi_frames++;
+
+	stats->last_rates[stats->last_frame_idx] = rate;
+	stats->last_frame_idx = (stats->last_frame_idx + 1) %
+		ARRAY_SIZE(stats->last_rates);
+
+	spin_unlock(&mvm->drv_stats_lock);
+}
+#endif
+
 /*
  * Called after adding a new station to initialize rate scaling
  */
@@ -2334,7 +2401,9 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	lq_sta->dbg_fixed_rate = 0;
 #endif
-
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_mvm_reset_frame_stats(mvm, &mvm->drv_rx_stats);
+#endif
 	rs_initialize_lq(mvm, sta, lq_sta, band, init);
 }
 
@@ -2546,7 +2615,7 @@ static void rs_free_sta(void *mvm_r, struct ieee80211_sta *sta,
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static int rs_pretty_print_rate(char *buf, const u32 rate)
+int rs_pretty_print_rate(char *buf, const u32 rate)
 {
 
 	char *type, *bw;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 817d3e0..6061553 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -77,6 +77,15 @@ int iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 
 	memcpy(&mvm->last_phy_info, pkt->data, sizeof(mvm->last_phy_info));
 	mvm->ampdu_ref++;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (mvm->last_phy_info.phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_AGG)) {
+		spin_lock(&mvm->drv_stats_lock);
+		mvm->drv_rx_stats.ampdu_count++;
+		spin_unlock(&mvm->drv_stats_lock);
+	}
+#endif
+
 	return 0;
 }
 
@@ -391,6 +400,10 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 							    rx_status.band);
 	}
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_mvm_update_frame_stats(mvm, &mvm->drv_rx_stats, rate_n_flags,
+				   rx_status.flag & RX_FLAG_AMPDU_DETAILS);
+#endif
 	iwl_mvm_pass_packet_to_mac80211(mvm, hdr, len, ampdu_status,
 					rxb, &rx_status);
 	return 0;
-- 
1.7.9.5

