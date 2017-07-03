Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43948 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752198AbdGCFch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 01:32:37 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH] ath10k: Increase buffer len to print all wmi services.
Date: Mon, 3 Jul 2017 11:02:36 +0530
Message-ID: <1499059956-30051-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20170703_073249_975962_942A1C64)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

All wmi_services are not printing when we give below command.

cat /sys/kernel/debug/ieee80211/phyX/ath10k/wmi_services

This patch increases the buffer_len to 8192 to print all the wmi_services.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 389fcb7..56404fe 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -237,7 +237,7 @@ static ssize_t ath10k_read_wmi_services(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	char *buf;
-	size_t len = 0, buf_len = 4096;
+	size_t len = 0, buf_len = 8192;
 	const char *name;
 	ssize_t ret_cnt;
 	bool enabled;
-- 
1.7.9.5
