Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50455 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751888AbdFOSZT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:19 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 04/23] ndef: Verify RTD record type name encodings
Date: Thu, 15 Jun 2017 11:24:57 -0700
Message-Id: <20170615182516.4508-5-mgreer@animalcreek.com> (sfid-20170615_202536_141646_6C848E95)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NFC Forum's Record Type Definition (RTD) Technical Specification
version 1.0, section 3.4 (RTD Type Names Requirements) specifies that
RTD type name encodings MUST be done according to the ASCII chart in
Appendix A (Character Set for Record Types).  Enforce this by checking
that all of the RTD type name encodings are valid before determining
their type.  Conveniently, isprint() does the correct checking.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/ndef.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/ndef.c b/src/ndef.c
index 03d6b13..7a3c76b 100644
--- a/src/ndef.c
+++ b/src/ndef.c
@@ -27,6 +27,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <string.h>
+#include <ctype.h>
 
 #include <glib.h>
 
@@ -881,6 +882,8 @@ static enum record_type get_external_record_type(uint8_t *type,
 static enum record_type get_record_type(enum record_tnf tnf,
 				uint8_t *type, size_t type_length)
 {
+	unsigned int i;
+
 	DBG("");
 
 	switch (tnf) {
@@ -891,6 +894,10 @@ static enum record_type get_record_type(enum record_tnf tnf,
 		break;
 
 	case RECORD_TNF_WELLKNOWN:
+		for (i = 0; i < type_length; i++)
+			if (!isprint(type[i]))
+				return RECORD_TYPE_ERROR;
+
 		if (type_length == 1) {
 			if (type[0] == 'T')
 				return RECORD_TYPE_WKT_TEXT;
-- 
2.13.0
