Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47608 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbaCROpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:47 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so5474358eek.11
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:46 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/35] iwlwifi: mvm: cleanups in iwl_dbgfs_frame_stats_read
Date: Tue, 18 Mar 2014 16:45:07 +0200
Message-Id: <1395153939-23897-3-git-send-email-egrumbach@gmail.com> (sfid-20140318_154552_160293_2D7F98EF)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Switch pos to char * which makes the code a bit shorter
as well as other minor cleanups suggested by Joe Perches.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 34 +++++++++++++++++-------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 41c6370..e3b42b4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -536,56 +536,60 @@ static ssize_t iwl_dbgfs_frame_stats_read(struct iwl_mvm *mvm,
 					  loff_t *ppos,
 					  struct iwl_mvm_frame_stats *stats)
 {
-	char *buff;
-	int pos = 0, idx, i;
+	char *buff, *pos, *endpos;
+	int idx, i;
 	int ret;
-	size_t bufsz = 1024;
+	static const size_t bufsz = 1024;
 
 	buff = kmalloc(bufsz, GFP_KERNEL);
 	if (!buff)
 		return -ENOMEM;
 
 	spin_lock_bh(&mvm->drv_stats_lock);
-	pos += scnprintf(buff + pos, bufsz - pos,
+
+	pos = buff;
+	endpos = pos + bufsz;
+
+	pos += scnprintf(pos, endpos - pos,
 			 "Legacy/HT/VHT\t:\t%d/%d/%d\n",
 			 stats->legacy_frames,
 			 stats->ht_frames,
 			 stats->vht_frames);
-	pos += scnprintf(buff + pos, bufsz - pos, "20/40/80\t:\t%d/%d/%d\n",
+	pos += scnprintf(pos, endpos - pos, "20/40/80\t:\t%d/%d/%d\n",
 			 stats->bw_20_frames,
 			 stats->bw_40_frames,
 			 stats->bw_80_frames);
-	pos += scnprintf(buff + pos, bufsz - pos, "NGI/SGI\t\t:\t%d/%d\n",
+	pos += scnprintf(pos, endpos - pos, "NGI/SGI\t\t:\t%d/%d\n",
 			 stats->ngi_frames,
 			 stats->sgi_frames);
-	pos += scnprintf(buff + pos, bufsz - pos, "SISO/MIMO2\t:\t%d/%d\n",
+	pos += scnprintf(pos, endpos - pos, "SISO/MIMO2\t:\t%d/%d\n",
 			 stats->siso_frames,
 			 stats->mimo2_frames);
-	pos += scnprintf(buff + pos, bufsz - pos, "FAIL/SCSS\t:\t%d/%d\n",
+	pos += scnprintf(pos, endpos - pos, "FAIL/SCSS\t:\t%d/%d\n",
 			 stats->fail_frames,
 			 stats->success_frames);
-	pos += scnprintf(buff + pos, bufsz - pos, "MPDUs agg\t:\t%d\n",
+	pos += scnprintf(pos, endpos - pos, "MPDUs agg\t:\t%d\n",
 			 stats->agg_frames);
-	pos += scnprintf(buff + pos, bufsz - pos, "A-MPDUs\t\t:\t%d\n",
+	pos += scnprintf(pos, endpos - pos, "A-MPDUs\t\t:\t%d\n",
 			 stats->ampdu_count);
-	pos += scnprintf(buff + pos, bufsz - pos, "Avg MPDUs/A-MPDU:\t%d\n",
+	pos += scnprintf(pos, endpos - pos, "Avg MPDUs/A-MPDU:\t%d\n",
 			 stats->ampdu_count > 0 ?
 			 (stats->agg_frames / stats->ampdu_count) : 0);
 
-	pos += scnprintf(buff + pos, bufsz - pos, "Last Rates\n");
+	pos += scnprintf(pos, endpos - pos, "Last Rates\n");
 
 	idx = stats->last_frame_idx - 1;
 	for (i = 0; i < ARRAY_SIZE(stats->last_rates); i++) {
 		idx = (idx + 1) % ARRAY_SIZE(stats->last_rates);
 		if (stats->last_rates[idx] == 0)
 			continue;
-		pos += scnprintf(buff + pos, bufsz - pos, "Rate[%d]: ",
+		pos += scnprintf(pos, endpos - pos, "Rate[%d]: ",
 				 (int)(ARRAY_SIZE(stats->last_rates) - i));
-		pos += rs_pretty_print_rate(buff + pos, stats->last_rates[idx]);
+		pos += rs_pretty_print_rate(pos, stats->last_rates[idx]);
 	}
 	spin_unlock_bh(&mvm->drv_stats_lock);
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buff, pos);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, pos - buff);
 	kfree(buff);
 
 	return ret;
-- 
1.8.3.2

