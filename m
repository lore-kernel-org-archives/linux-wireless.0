Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126Ab1KRIX1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 76/77] iwlegacy: 4965-rs: cleanup il4965_rs_sta_dbgfs_rate_scale_data_read
Date: Fri, 18 Nov 2011 09:22:38 +0100
Message-Id: <1321604559-10707-76-git-send-email-sgruszka@redhat.com> (sfid-20111118_092341_958535_3C755183)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

1) remove ret local var and return the result directly
2) remove il since it is not used

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 162c778..467d0cb 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2769,14 +2769,9 @@ il4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 {
 	char buff[120];
 	int desc = 0;
-	ssize_t ret;
-
 	struct il_lq_sta *lq_sta = file->private_data;
-	struct il_priv *il;
 	struct il_scale_tbl_info *tbl = &lq_sta->lq_info[lq_sta->active_tbl];
 
-	il = lq_sta->drv;
-
 	if (is_Ht(tbl->lq_type))
 		desc +=
 		    sprintf(buff + desc, "Bit Rate= %d Mb/s\n",
@@ -2786,8 +2781,7 @@ il4965_rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 		    sprintf(buff + desc, "Bit Rate= %d Mb/s\n",
 			    il_rates[lq_sta->last_txrate_idx].ieee >> 1);
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 }
 
 static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
-- 
1.7.1

