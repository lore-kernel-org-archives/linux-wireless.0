Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37762 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbLBESY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 23:18:24 -0500
From: Brent Taylor <motobud@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath6kl@lists.infradead.org,
	Brent Taylor <motobud@gmail.com>
Subject: [v2] ath6kl: Use vmalloc to allocate ar->fw for api1 method
Date: Tue,  1 Dec 2015 22:18:18 -0600
Message-Id: <1449029898-15209-1-git-send-email-motobud@gmail.com> (sfid-20151202_051918_379151_D2311B4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 8437754c8335 ("ath6kl: Use vmalloc instead of kmalloc for
fw") ar->fw is expected to be pointing to memory allocated by vmalloc.
If the api1 method (via ath6kl_fetch_fw_api1) is used to allocate memory
for ar->fw, then kmemdup is used.  This patch checks if the firmware being
loaded is the 'fw' image, then use vmalloc, otherwise use kmalloc.

Signed-off-by: Brent Taylor <motobud@gmail.com>
---
v2: Fix commit message and code formatting (use tab instaed of spaces)

 drivers/net/wireless/ath/ath6kl/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6ae0734..4f16bd8 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -673,10 +673,15 @@ static int ath6kl_get_fw(struct ath6kl *ar, const char *filename,
 		return ret;
 
 	*fw_len = fw_entry->size;
-	*fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	if (&ar->fw == fw)
+		*fw = vmalloc(fw_entry->size);
+	else
+		*fw = kmalloc(fw_entry->size, GFP_KERNEL);
 
 	if (*fw == NULL)
 		ret = -ENOMEM;
+	else
+		memcpy(*fw, fw_entry->data, fw_entry->size);
 
 	release_firmware(fw_entry);
 
-- 
2.6.3

