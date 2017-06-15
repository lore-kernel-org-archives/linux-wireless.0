Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34255 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752884AbdFOSZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:24 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 03/23] ndef: Unrecognized WKTs should return RECORD_TYPE_UNKNOWN
Date: Thu, 15 Jun 2017 11:24:56 -0700
Message-Id: <20170615182516.4508-4-mgreer@animalcreek.com> (sfid-20170615_202634_409348_85A39736)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When get_record_type() doesn't recognize the record type in a record
with a Well Known Type TNF, it falls through to the next case clause
and returns RECORD_TYPE_MIME_TYPE.  This is incorrect so add a break
statement to the RECORD_TNF_WELLKNOWN case so that RECORD_TYPE_UNKNOWN
is returned.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/ndef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/ndef.c b/src/ndef.c
index 99f3bc3..03d6b13 100644
--- a/src/ndef.c
+++ b/src/ndef.c
@@ -928,6 +928,7 @@ static enum record_type get_record_type(enum record_tnf tnf,
 				return RECORD_TYPE_UNKNOWN;
 
 		}
+		break;
 
 	case RECORD_TNF_MIME:
 		return RECORD_TYPE_MIME_TYPE;
-- 
2.13.0
