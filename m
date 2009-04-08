Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9750 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbZDHSdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: Display decoded rate/mcs information
Date: Wed,  8 Apr 2009 11:39:27 -0700
Message-Id: <1239215972-1795-2-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203405_881838_978342C9)
In-Reply-To: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
References: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This patch adding MCS information in rate_scale_table, it help for
debugging rate scaling algorithm, easy to understand what is the current
rate scale table and matching modulation, plus the last mcs used for tx.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   40 ++++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    7 +++++
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index b1818a3..786b11d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -167,6 +167,8 @@ struct iwl_lq_sta {
 
 	/* used to be in sta_info */
 	int last_txrate_idx;
+	/* last tx rate_n_flags */
+	u32 last_rate_n_flags;
 };
 
 static void rs_rate_scale_perform(struct iwl_priv *priv,
@@ -249,6 +251,23 @@ static s32 expected_tpt_mimo3_40MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 160, 160, 219, 245, 261, 284, 294, 297, 300
 };
 
+/* mbps, mcs */
+const static struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
+  {"1", ""},
+  {"2", ""},
+  {"5.5", ""},
+  {"11", ""},
+  {"6", "BPSK 1/2"},
+  {"9", "BPSK 1/2"},
+  {"12", "QPSK 1/2"},
+  {"18", "QPSK 3/4"},
+  {"24", "16QAM 1/2"},
+  {"36", "16QAM 3/4"},
+  {"48", "64QAM 2/3"},
+  {"54", "64QAM 3/4"},
+  {"60", "64QAM 5/6"}
+};
+
 static inline u8 rs_extract_rate(u32 rate_n_flags)
 {
 	return (u8)(rate_n_flags & 0xFF);
@@ -919,6 +938,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	 * else look up the rate that was, finally, successful.
 	 */
 	tx_rate = le32_to_cpu(table->rs_table[index].rate_n_flags);
+	lq_sta->last_rate_n_flags = tx_rate;
 	rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type, &rs_index);
 
 	/* Update frame history window with "success" if Tx got ACKed ... */
@@ -2826,6 +2846,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	char *buff;
 	int desc = 0;
 	int i = 0;
+	int index = 0;
 	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
@@ -2857,6 +2878,8 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 		   (tbl->is_fat) ? "40MHz" : "20MHz");
 		desc += sprintf(buff+desc, " %s\n", (tbl->is_SGI) ? "SGI" : "");
 	}
+	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
+		lq_sta->last_rate_n_flags);
 	desc += sprintf(buff+desc, "general:"
 		"flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
 		lq_sta->lq.general_params.flags,
@@ -2877,10 +2900,19 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->lq.general_params.start_rate_index[2],
 			lq_sta->lq.general_params.start_rate_index[3]);
 
-
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		desc += sprintf(buff+desc, " rate[%d] 0x%X\n",
-			i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+		index = iwl_hwrate_to_plcp_idx(
+			le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
+		if (is_legacy(tbl->lq_type)) {
+			desc += sprintf(buff+desc, " rate[%d] 0x%X %smbps\n",
+				i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags),
+				iwl_rate_mcs[index].mbps);
+		} else {
+			desc += sprintf(buff+desc, " rate[%d] 0x%X %smbps (%s)\n",
+				i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags),
+				iwl_rate_mcs[index].mbps, iwl_rate_mcs[index].mcs);
+		}
+	}
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 	kfree(buff);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 9cd90ba..f875136 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -325,6 +325,13 @@ enum iwl_table_type {
 #define ANT_BC		(ANT_B | ANT_C)
 #define ANT_ABC		(ANT_AB | ANT_C)
 
+#define IWL_MAX_MCS_DISPLAY_SIZE	12
+
+struct iwl_rate_mcs_info {
+	char	mbps[IWL_MAX_MCS_DISPLAY_SIZE];
+	char	mcs[IWL_MAX_MCS_DISPLAY_SIZE];
+};
+
 static inline u8 num_of_ant(u8 mask)
 {
 	return  !!((mask) & ANT_A) +
-- 
1.5.6.3

