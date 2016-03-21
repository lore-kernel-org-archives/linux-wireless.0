Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbcCUUBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 16:01:19 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 1/2] wil6210: allow empty WMI commands in debugfs wmi_send
Date: Mon, 21 Mar 2016 22:01:11 +0200
Message-Id: <1458590472-677-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160321_210127_122243_300EA541)
In-Reply-To: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

There are many valid WMI commands with only header without any
additional payload. Such WMI commands could not be sent using
the debugfs wmi_send facility. Fix the code to allow sending
of such commands.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a4d3f70..b338a09 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -832,7 +832,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 	u16 cmdid;
 	int rc, rc1;
 
-	if (cmdlen <= 0)
+	if (cmdlen < 0)
 		return -EINVAL;
 
 	wmi = kmalloc(len, GFP_KERNEL);
@@ -845,7 +845,7 @@ static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
 		return rc;
 	}
 
-	cmd = &wmi[1];
+	cmd = (cmdlen > 0) ? &wmi[1] : NULL;
 	cmdid = le16_to_cpu(wmi->command_id);
 
 	rc1 = wmi_send(wil, cmdid, cmd, cmdlen);
-- 
1.8.5.2

