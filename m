Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35214 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbJPFLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 01:11:13 -0400
From: Brent Taylor <motobud@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath6kl@lists.infradead.org,
	motobud@gmail.com
Subject: [PATCH] ath6kl: Use vmalloc for loading firmware using api1 method
Date: Fri, 16 Oct 2015 00:10:59 -0500
Message-Id: <1444972259-24260-1-git-send-email-motobud@gmail.com> (sfid-20151016_071213_330246_7FABB968)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Brent Taylor <motobud@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/init.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6e473fa..2155739 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -673,10 +673,17 @@ static int ath6kl_get_fw(struct ath6kl *ar, const char *filename,
 		return ret;
 
 	*fw_len = fw_entry->size;
-	*fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-
-	if (*fw == NULL)
-		ret = -ENOMEM;
+	if (&ar->fw == fw) {
+		*fw = vmalloc(fw_entry->size);
+		if (*fw == NULL)
+			ret = -ENOMEM;
+		else
+			memcpy(*fw, fw_entry->data, fw_entry->size);
+	} else {
+		*fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+		if (*fw == NULL)
+			ret = -ENOMEM;
+	}
 
 	release_firmware(fw_entry);
 
-- 
2.6.1

