Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50451 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753176AbdFOSZa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:30 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 05/23] ndef: Discard records containing errors
Date: Thu, 15 Jun 2017 11:24:58 -0700
Message-Id: <20170615182516.4508-6-mgreer@animalcreek.com> (sfid-20170615_202638_314890_35889552)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, near_ndef_parse_msg() adds records even when they contain
erroneous record types.  This can later cause neard to exit when it
tries to signal dbus with incomplete record information.  Avoid this
by ignoring records that contain bad record types (and all of the
records that follow in the same NDEF message).

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/ndef.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/ndef.c b/src/ndef.c
index 7a3c76b..38dcf72 100644
--- a/src/ndef.c
+++ b/src/ndef.c
@@ -2845,7 +2845,6 @@ GList *near_ndef_parse_msg(uint8_t *ndef_data, size_t ndef_length,
 		case RECORD_TYPE_WKT_COLLISION_RESOLUTION:
 		case RECORD_TYPE_WKT_ERROR:
 		case RECORD_TYPE_UNKNOWN:
-		case RECORD_TYPE_ERROR:
 			break;
 
 		case RECORD_TYPE_WKT_HANDOVER_REQUEST:
@@ -2927,6 +2926,8 @@ GList *near_ndef_parse_msg(uint8_t *ndef_data, size_t ndef_length,
 				goto fail;
 
 			break;
+		case RECORD_TYPE_ERROR:
+			goto fail;
 		}
 
 		record->data_len = record->header->header_len +
-- 
2.13.0
