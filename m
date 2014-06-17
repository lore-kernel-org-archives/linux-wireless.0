Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:49176 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaFQJlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:41:24 -0400
Subject: [PATCH 6/6] ath6kl: properly null terminate the firmware string
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Jun 2014 12:41:21 +0300
Message-ID: <20140617094121.22040.35356.stgit@potku.adurom.net> (sfid-20140617_114127_043904_9C307033)
In-Reply-To: <20140617093836.22040.99081.stgit@potku.adurom.net>
References: <20140617093836.22040.99081.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware version read from the firmware image is not null terminated and
because of that there were few bytes of garbage after the firmware string:

[10420.164632] ath6kl: ar6004 hw 3.0 usb fw 3.5.0.300-1^A api 4

Add proper null termination to ath6kl_fetch_fw_apin() clean the firmware
version string.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 3dea97aa9b74..63c0cffd5634 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -942,7 +942,7 @@ static int ath6kl_fetch_fw_api1(struct ath6kl *ar)
 
 static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 {
-	size_t magic_len, len, ie_len;
+	size_t magic_len, len, ie_len, ver_len;
 	const struct firmware *fw;
 	struct ath6kl_fw_ie *hdr;
 	char filename[100];
@@ -993,8 +993,10 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 
 		switch (ie_id) {
 		case ATH6KL_FW_IE_FW_VERSION:
-			strlcpy(ar->wiphy->fw_version, data,
-				sizeof(ar->wiphy->fw_version));
+			/* the string is not null terminated */
+			ver_len = min(ie_len, sizeof(ar->wiphy->fw_version));
+			memcpy(ar->wiphy->fw_version, data, ver_len);
+			ar->wiphy->fw_version[ver_len] = '\0';
 
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
 				   "found fw version %s\n",

