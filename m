Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56720 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3BDKJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 05:09:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k: Print the negotiated HT capabilities
Date: Mon,  4 Feb 2013 15:38:22 +0530
Message-Id: <1359972504-8900-1-git-send-email-sujith@msujith.org> (sfid-20130204_110943_690799_B85A0EBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Also, reduce the memory allocated for each row.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 12 +++++++++++-
 drivers/net/wireless/ath/ath9k/rc.h |  6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 714558d..62abd70 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1364,7 +1364,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	if (rc->rate_table == NULL)
 		return 0;
 
-	max = 80 + rc->rate_table_size * 1024 + 1;
+	max = 80 + rc->rate_table_size * 256 + 1;
 	buf = kmalloc(max, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
@@ -1410,6 +1410,16 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 			stats->per);
 	}
 
+	if (rc->ht_cap & WLAN_RC_HT_FLAG) {
+		len += snprintf(buf + len, max - len, "\nNegotiated HT caps: ");
+		PR_HT_CAP((rc->ht_cap & WLAN_RC_HT_FLAG), "[HT20]");
+		PR_HT_CAP((rc->ht_cap & WLAN_RC_40_FLAG), "[HT40]");
+		PR_HT_CAP((rc->ht_cap & WLAN_RC_DS_FLAG), "[2-Stream]");
+		PR_HT_CAP((rc->ht_cap & WLAN_RC_TS_FLAG), "[3-Stream]");
+		PR_HT_CAP((rc->ht_cap & WLAN_RC_SGI_FLAG), "[SGI]");
+		len += snprintf(buf + len, max - len, "\n");
+	}
+
 	if (len > max)
 		len = max;
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 267dbfc..d9089b9 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -131,6 +131,12 @@ enum {
 #define WLAN_RC_SGI_FLAG        (0x08)
 #define WLAN_RC_HT_FLAG         (0x10)
 
+#define PR_HT_CAP(_cond, _str)						\
+	do {								\
+		if (_cond)						\
+			len += snprintf(buf + len, max - len, _str);	\
+	} while (0)
+
 /**
  * struct ath_rate_table - Rate Control table
  * @rate_cnt: total number of rates for the given wireless mode
-- 
1.8.1.2

