Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50449 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750749AbdFOSZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:24 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 01/23] ndef: Add default language ("en") for Text records
Date: Thu, 15 Jun 2017 11:24:54 -0700
Message-Id: <20170615182516.4508-2-mgreer@animalcreek.com> (sfid-20170615_202633_865633_44D9EC1E)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Despite section 3.3 of the NFC Forum RTD-Text 1.0 Technical
Specification stating in part, "The language code MAY NOT be
omitted", some tags have a 0-length language field.  A 0-length
language field currently causes neard to exit which isn't ideal
so choose a default language (generic English) which will be
used in these situations.

There is no particular reason to choose English other than it
is the native language of the patch author and it is the
language neard is coded in.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
This is identical to an earlier patch submitted to the linux-nfc
mail list in October (link below) so that patch can be discarded.

https://lists.01.org/pipermail/linux-nfc/2016-October/004292.html
---
 src/ndef.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/ndef.c b/src/ndef.c
index 5656baf..b90205b 100644
--- a/src/ndef.c
+++ b/src/ndef.c
@@ -409,7 +409,10 @@ static const char *get_text_payload(const GDBusPropertyTable *property,
 	if (!strcmp(property->name, "Encoding"))
 		return text->encoding;
 	else if (!strcmp(property->name, "Language"))
-		return text->language_code;
+		if (!text->language_code)
+			return "en";
+		else
+			return text->language_code;
 	else if (!strcmp(property->name, "Representation"))
 		return text->data;
 	else
-- 
2.13.0
