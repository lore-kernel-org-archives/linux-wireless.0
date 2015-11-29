Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35357 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbK2Fvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2015 00:51:33 -0500
From: Brent Taylor <motobud@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath6kl@lists.infradead.org,
	Brent Taylor <motobud@gmail.com>
Subject: [PATCH v3] ath6kl: Use vmalloc for loading firmware using api1 method and use kvfree
Date: Sat, 28 Nov 2015 23:51:23 -0600
Message-Id: <1448776283-28383-1-git-send-email-motobud@gmail.com> (sfid-20151129_065226_786677_EC7ED60B)
In-Reply-To: <1448774038-26984-1-git-send-email-motobud@gmail.com>
References: <1448774038-26984-1-git-send-email-motobud@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Brent Taylor <motobud@gmail.com>

ath6kl: Use vmalloc for loading firmware using api1 method and free using kvfree

ath6kl: fix kmalloc build error
---
Changes v2 -> v3:
   - fix kmalloc build error

Changes v1 -> v2:
   - simplify memory allocation
   - use kvfree

 drivers/net/wireless/ath/ath6kl/core.c | 2 +-
 drivers/net/wireless/ath/ath6kl/init.c | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 4ec02ce..052e58b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -343,7 +343,7 @@ void ath6kl_core_cleanup(struct ath6kl *ar)
 
 	kfree(ar->fw_board);
 	kfree(ar->fw_otp);
-	vfree(ar->fw);
+	kvfree(ar->fw);
 	kfree(ar->fw_patch);
 	kfree(ar->fw_testscript);
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 6e473fa..19535dc 100644
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

