Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38491 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752640AbdFOSZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:24 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 02/23] ndef: Fix use of uninitialized variable in property_get_type()
Date: Thu, 15 Jun 2017 11:24:55 -0700
Message-Id: <20170615182516.4508-3-mgreer@animalcreek.com> (sfid-20170615_202537_273548_4E6E7398)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'type' variable in property_get_type() is never set when the
record type is invalid.  This means that the check for NULL doesn't
work as it should and a bogus string can be appended.  Fix this by
adding a default case to the switch statement that checks the record
type ensuring that 'type' is set to NULL when the record type is
invalid.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/ndef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/ndef.c b/src/ndef.c
index b90205b..99f3bc3 100644
--- a/src/ndef.c
+++ b/src/ndef.c
@@ -342,6 +342,7 @@ static gboolean property_get_type(const GDBusPropertyTable *property,
 	case RECORD_TYPE_WKT_ERROR:
 	case RECORD_TYPE_UNKNOWN:
 	case RECORD_TYPE_ERROR:
+	default:
 		type = NULL;
 		break;
 
-- 
2.13.0
