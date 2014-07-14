Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42050 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaGNGvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:13 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 4/7] wil6210: fix memory leak on error path in wil_write_file_rxon()
Date: Mon, 14 Jul 2014 09:49:40 +0300
Message-ID: <1405320583-5775-5-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085119_846585_81A9F726)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

If copy_from_user() fails, buffer allocated for parameters would leak

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 7435b5a..b640068 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -448,8 +448,10 @@ static ssize_t wil_write_file_rxon(struct file *file, const char __user *buf,
 	char *kbuf = kmalloc(len + 1, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
-	if (copy_from_user(kbuf, buf, len))
+	if (copy_from_user(kbuf, buf, len)) {
+		kfree(kbuf);
 		return -EIO;
+	}
 
 	kbuf[len] = '\0';
 	rc = kstrtol(kbuf, 0, &channel);
-- 
1.7.6

