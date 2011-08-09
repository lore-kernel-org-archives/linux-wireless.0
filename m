Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58193 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1HIQDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 12:03:51 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH] ath9k: optimize rate control statistics
Date: Tue, 9 Aug 2011 21:33:43 +0530
Message-ID: <1312905823-2878-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110809_180404_378205_3781BF46)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

for the ease of debugging, we display only the rate control statistics
for currently operating mode and bandwidth

Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: "Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index c04a6c3..9e3649a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1484,7 +1484,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	if (rc->rate_table == NULL)
 		return 0;
 
-	max = 80 + rc->rate_table->rate_cnt * 1024 + 1;
+	max = 80 + rc->rate_table_size * 1024 + 1;
 	buf = kmalloc(max, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
@@ -1494,7 +1494,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 		       "HT", "MCS", "Rate",
 		       "Success", "Retries", "XRetries", "PER");
 
-	for (i = 0; i < rc->rate_table->rate_cnt; i++) {
+	for (i = 0; i < rc->rate_table_size; i++) {
 		u32 ratekbps = rc->rate_table->info[i].ratekbps;
 		struct ath_rc_stats *stats = &rc->rcstats[i];
 		char mcs[5];
-- 
1.7.0.4

