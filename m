Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37872 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbbK3XCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 18:02:03 -0500
From: greearb@candelatech.com
To: ath6kl@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath6kl:  add log messages for firmware failure cases.
Date: Mon, 30 Nov 2015 15:01:48 -0800
Message-Id: <1448924508-25672-2-git-send-email-greearb@candelatech.com> (sfid-20151201_000212_526459_24886921)
In-Reply-To: <1448924508-25672-1-git-send-email-greearb@candelatech.com>
References: <1448924508-25672-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This gives a user a chance to know why a firmware load
is failing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath6kl/init.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e3f3a6a..45210d0 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -953,8 +953,10 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 	snprintf(filename, sizeof(filename), "%s/%s", ar->hw.fw.dir, name);
 
 	ret = request_firmware(&fw, filename, ar->dev);
-	if (ret)
+	if (ret) {
+		ath6kl_err("Failed request firmware, rv: %d\n", ret);
 		return ret;
+	}
 
 	data = fw->data;
 	len = fw->size;
@@ -963,11 +965,15 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 	magic_len = strlen(ATH6KL_FIRMWARE_MAGIC) + 1;
 
 	if (len < magic_len) {
+		ath6kl_err("Magic length is invalid, len: %zd  magic_len: %zd\n",
+			   len, magic_len);
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (memcmp(data, ATH6KL_FIRMWARE_MAGIC, magic_len) != 0) {
+		ath6kl_err("Magic is invalid, magic_len: %zd\n",
+			   magic_len);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -986,7 +992,12 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 		len -= sizeof(*hdr);
 		data += sizeof(*hdr);
 
+		ath6kl_dbg(ATH6KL_DBG_BOOT, "ie-id: %d  len: %zd (0x%zx)\n",
+			   ie_id, ie_len, ie_len);
+
 		if (len < ie_len) {
+			ath6kl_err("IE len is invalid, len: %zd  ie_len: %zd  ie-id: %d\n",
+				   len, ie_len, ie_id);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1007,6 +1018,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			ar->fw_otp = kmemdup(data, ie_len, GFP_KERNEL);
 
 			if (ar->fw_otp == NULL) {
+				ath6kl_err("fw_otp cannot be allocated\n");
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -1024,6 +1036,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			ar->fw = vmalloc(ie_len);
 
 			if (ar->fw == NULL) {
+				ath6kl_err("fw storage cannot be allocated, len: %zd\n", ie_len);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -1038,6 +1051,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			ar->fw_patch = kmemdup(data, ie_len, GFP_KERNEL);
 
 			if (ar->fw_patch == NULL) {
+				ath6kl_err("fw_patch storage cannot be allocated, len: %zd\n", ie_len);
 				ret = -ENOMEM;
 				goto out;
 			}
-- 
2.4.3

