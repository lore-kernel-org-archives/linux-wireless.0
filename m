Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58742 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3KXUG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:56 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so3146531wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:55 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/29] iwlwifi: mvm: fix and improve printing of rate scale table
Date: Sun, 24 Nov 2013 22:06:21 +0200
Message-Id: <1385323606-3603-4-git-send-email-egrumbach@gmail.com> (sfid-20131124_210707_017609_5791AC50)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Info about VHT/HT rates wasn't printed properly when dumping
the rate scale table. Fix that and print more info. While at it
fix some other minor issues in the printing and prevent
overflowing the print buffer.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   91 ++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a0b4cc8..f7ac485 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2566,13 +2566,75 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 	return count;
 }
 
+static int rs_pretty_print_rate(char *buf, const u32 rate)
+{
+	static const char * const ant_name[] = {
+		[ANT_NONE] = "None",
+		[ANT_A]    = "A",
+		[ANT_B]    = "B",
+		[ANT_AB]   = "AB",
+		[ANT_C]    = "C",
+		[ANT_AC]   = "AC",
+		[ANT_BC]   = "BC",
+		[ANT_ABC]  = "ABC",
+	};
+
+	char *type, *bw;
+	u8 mcs = 0, nss = 0;
+	u8 ant = (rate & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS;
+
+	if (!(rate & RATE_MCS_HT_MSK) &&
+	    !(rate & RATE_MCS_VHT_MSK)) {
+		int index = iwl_hwrate_to_plcp_idx(rate);
+
+		return sprintf(buf, "Legacy | ANT: %s Rate: %s Mbps\n",
+			       ant_name[ant], iwl_rate_mcs[index].mbps);
+	}
+
+	if (rate & RATE_MCS_VHT_MSK) {
+		type = "VHT";
+		mcs = rate & RATE_VHT_MCS_RATE_CODE_MSK;
+		nss = ((rate & RATE_VHT_MCS_NSS_MSK)
+		       >> RATE_VHT_MCS_NSS_POS) + 1;
+	} else if (rate & RATE_MCS_HT_MSK) {
+		type = "HT";
+		mcs = rate & RATE_HT_MCS_INDEX_MSK;
+	} else {
+		type = "Unknown"; /* shouldn't happen */
+	}
+
+	switch (rate & RATE_MCS_CHAN_WIDTH_MSK) {
+	case RATE_MCS_CHAN_WIDTH_20:
+		bw = "20Mhz";
+		break;
+	case RATE_MCS_CHAN_WIDTH_40:
+		bw = "40Mhz";
+		break;
+	case RATE_MCS_CHAN_WIDTH_80:
+		bw = "80Mhz";
+		break;
+	case RATE_MCS_CHAN_WIDTH_160:
+		bw = "160Mhz";
+		break;
+	default:
+		bw = "BAD BW";
+	}
+
+	return sprintf(buf, "%s | ANT: %s BW: %s MCS: %d NSS: %d %s%s%s%s%s\n",
+		       type, ant_name[ant], bw, mcs, nss,
+		       (rate & RATE_MCS_SGI_MSK) ? "SGI " : "NGI ",
+		       (rate & RATE_MCS_STBC_MSK) ? "STBC " : "",
+		       (rate & RATE_MCS_LDPC_MSK) ? "LDPC " : "",
+		       (rate & RATE_MCS_BF_MSK) ? "BF " : "",
+		       (rate & RATE_MCS_ZLF_MSK) ? "ZLF " : "");
+}
+
 static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
 	char *buff;
 	int desc = 0;
 	int i = 0;
-	int index = 0;
 	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
@@ -2580,7 +2642,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 
 	mvm = lq_sta->drv;
-	buff = kmalloc(1024, GFP_KERNEL);
+	buff = kmalloc(2048, GFP_KERNEL);
 	if (!buff)
 		return -ENOMEM;
 
@@ -2597,7 +2659,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "lq type %s\n",
 			(is_legacy(tbl->lq_type)) ? "legacy" :
 			is_vht(tbl->lq_type) ? "VHT" : "HT");
-	if (is_ht(tbl->lq_type)) {
+	if (!is_legacy(tbl->lq_type)) {
 		desc += sprintf(buff+desc, " %s",
 		   (is_siso(tbl->lq_type)) ? "SISO" : "MIMO2");
 		   desc += sprintf(buff+desc, " %s",
@@ -2605,13 +2667,13 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 				   (is_ht40(tbl)) ? "40MHz" :
 				   (is_ht80(tbl)) ? "80Mhz" : "BAD BW");
 		   desc += sprintf(buff+desc, " %s %s\n",
-				   (tbl->is_SGI) ? "SGI" : "",
+				   (tbl->is_SGI) ? "SGI" : "NGI",
 				   (lq_sta->is_agg) ? "AGG on" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
 			lq_sta->last_rate_n_flags);
 	desc += sprintf(buff+desc,
-			"general: flags=0x%X mimo-d=%d s-ant0x%x d-ant=0x%x\n",
+			"general: flags=0x%X mimo-d=%d s-ant=0x%x d-ant=0x%x\n",
 			lq_sta->lq.flags,
 			lq_sta->lq.mimo_delim,
 			lq_sta->lq.single_stream_ant_msk,
@@ -2631,19 +2693,12 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->lq.initial_rate_index[3]);
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		index = iwl_hwrate_to_plcp_idx(
-			le32_to_cpu(lq_sta->lq.rs_table[i]));
-		if (is_legacy(tbl->lq_type)) {
-			desc += sprintf(buff+desc, " rate[%d] 0x%X %smbps\n",
-					i, le32_to_cpu(lq_sta->lq.rs_table[i]),
-					iwl_rate_mcs[index].mbps);
-		} else {
-			desc += sprintf(buff+desc,
-					" rate[%d] 0x%X %smbps (%s)\n",
-					i, le32_to_cpu(lq_sta->lq.rs_table[i]),
-					iwl_rate_mcs[index].mbps,
-					iwl_rate_mcs[index].mcs);
-		}
+		u32 rate = le32_to_cpu(lq_sta->lq.rs_table[i]);
+		desc += sprintf(buff+desc,
+				" rate[%d] 0x%X ",
+				i, rate);
+
+		desc += rs_pretty_print_rate(buff+desc, rate);
 	}
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
-- 
1.7.9.5

