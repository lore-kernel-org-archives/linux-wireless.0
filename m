Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34744 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbcBBHOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 02:14:48 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ath10k: remove impossible code
Date: Tue,  2 Feb 2016 12:44:40 +0530
Message-Id: <1454397280-4758-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160202_081536_533415_05A42CB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sudip Mukherjee <sudip@vectorindia.org>

len has been initialized with a value of 0 and buf_len with 4096. There
is no way that this condition (len > buf_len) can be true now.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 2bdf540..8b187e0 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2176,9 +2176,6 @@ static ssize_t ath10k_debug_fw_checksums_read(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
-	if (len > buf_len)
-		len = buf_len;
-
 	len += scnprintf(buf + len, buf_len - len,
 			 "firmware-N.bin\t\t%08x\n",
 			 crc32_le(0, ar->firmware->data, ar->firmware->size));
-- 
1.9.1

