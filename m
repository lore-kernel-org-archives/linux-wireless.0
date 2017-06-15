Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55597 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753184AbdFOSZa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:30 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 06/23] ndef: Validate text data in WKT Text records
Date: Thu, 15 Jun 2017 11:24:59 -0700
Message-Id: <20170615182516.4508-7-mgreer@animalcreek.com> (sfid-20170615_202636_694950_D09E6360)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that the text encodings in WKT Text records are valid.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/ndef.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/src/ndef.c b/src/ndef.c
index 38dcf72..fb17be9 100644
--- a/src/ndef.c
+++ b/src/ndef.c
@@ -1149,8 +1149,9 @@ static struct near_ndef_text_payload *
 parse_text_payload(uint8_t *payload, uint32_t length)
 {
 	struct near_ndef_text_payload *text_payload = NULL;
-	uint8_t status, lang_length;
+	uint8_t status, lang_length, len, *txt, *g_str;
 	uint32_t offset;
+	gboolean valid;
 
 	DBG("");
 
@@ -1185,9 +1186,26 @@ parse_text_payload(uint8_t *payload, uint32_t length)
 
 	offset += lang_length;
 
-	if ((length - lang_length - 1) > 0) {
-		text_payload->data = g_strndup((char *)(payload + offset),
-					length - lang_length - 1);
+	len = length - lang_length - 1;
+
+	if (len > 0) {
+		txt = payload + offset;
+
+		if (status)
+			g_str = g_utf16_to_utf8((gunichar2 *)txt, len, NULL,
+						NULL, NULL);
+		else
+			g_str = txt;
+
+		valid = g_utf8_validate(g_str, len, NULL);
+
+		if (status)
+			g_free(g_str);
+
+		if (!valid)
+			goto fail;
+
+		text_payload->data = g_strndup(txt, len);
 	} else {
 		text_payload->data = NULL;
 	}
-- 
2.13.0
