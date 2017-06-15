Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40793 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdFORqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:46:22 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 2/3] NFC: digital: NFC-DEP Target WT(nfcdep,max) is now 14
Date: Thu, 15 Jun 2017 10:46:16 -0700
Message-Id: <20170615174617.1817-3-mgreer@animalcreek.com> (sfid-20170615_194627_474805_B1F73DF6)
In-Reply-To: <20170615174617.1817-1-mgreer@animalcreek.com>
References: <20170615174617.1817-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Version 1.1 of the NFC Forum's NFC Digital Protocol Technical
Specification dated 2014-07-14 specifies that the NFC-DEP Protocol's
Target WT(nfcdep,max) value is 14.  In version 1.0 it was 8 so change
the value in the Linux NFC-DEP Protocol code accordingly.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 net/nfc/digital_dep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index f864ce19e13d..5bb241bb3490 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -151,7 +151,7 @@ static const u8 digital_payload_bits_map[4] = {
  *  0 <= wt <= 14 (given by the target by the TO field of ATR_RES response)
  */
 #define DIGITAL_NFC_DEP_IN_MAX_WT 14
-#define DIGITAL_NFC_DEP_TG_MAX_WT 8
+#define DIGITAL_NFC_DEP_TG_MAX_WT 14
 static const u16 digital_rwt_map[DIGITAL_NFC_DEP_IN_MAX_WT + 1] = {
 	100,  101,  101,  102,  105,
 	110,  119,  139,  177,  255,
-- 
2.13.0
