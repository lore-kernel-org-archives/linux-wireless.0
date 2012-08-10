Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5925 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2HJLSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:18:44 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20516.60874.416293.305770@gargle.gargle.HOWL> (sfid-20120810_132551_561720_826B82B8)
Date: Fri, 10 Aug 2012 16:47:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/15] ath9k: tune rc_stats to display only valid rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

This could make rc_stats more simpler and ease the debugging.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4a04fff..4b12c34 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1355,7 +1355,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	struct ath_rate_priv *rc = file->private_data;
 	char *buf;
 	unsigned int len = 0, max;
-	int i = 0;
+	int rix;
 	ssize_t retval;
 
 	if (rc->rate_table == NULL)
@@ -1371,7 +1371,8 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 		       "HT", "MCS", "Rate",
 		       "Success", "Retries", "XRetries", "PER");
 
-	for (i = 0; i < rc->rate_table_size; i++) {
+	for (rix = 0; rix < rc->max_valid_rate; rix++) {
+		u8 i = rc->valid_rate_index[rix];
 		u32 ratekbps = rc->rate_table->info[i].ratekbps;
 		struct ath_rc_stats *stats = &rc->rcstats[i];
 		char mcs[5];
-- 
1.7.11.4

