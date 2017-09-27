Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965519AbdI0BNs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 21:13:48 -0400
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH] ath9k: fix tx99 potential info leak
Date: Wed, 27 Sep 2017 09:13:34 +0800
Message-Id: <1506474814-18118-1-git-send-email-miaoqing@codeaurora.org> (sfid-20170927_031355_750081_57021D72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

When the user sets count to zero the string buffer would remain
completely uninitialized which causes the kernel to parse its
own stack data, potentially leading to an info leak. In addition
to that, the string might be not terminated properly when the
user data does not contain a 0-terminator.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 49ed1af..fe3a826 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -179,6 +179,9 @@ static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
 	ssize_t len;
 	int r;
 
+	if (count < 1)
+		return -EINVAL;
+
 	if (sc->cur_chan->nvifs > 1)
 		return -EOPNOTSUPP;
 
@@ -186,6 +189,8 @@ static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 
+	buf[len] = '\0';
+
 	if (strtobool(buf, &start))
 		return -EINVAL;
 
-- 
1.9.1
