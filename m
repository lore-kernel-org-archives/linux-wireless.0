Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33521 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753199AbdFOSZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 13/23] nfctype5: Reduce noise when tag is moved out of range
Date: Thu, 15 Jun 2017 11:25:06 -0700
Message-Id: <20170615182516.4508-14-mgreer@animalcreek.com> (sfid-20170615_202555_232302_15CA5950)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NFC Type 5 tag code prints a message whenever it receives an
error.  This makes it extra noisy compared to the other tag types
whenever a tag is moved out of range.  Instead, reduce that noise
by turning the error message into a debug message.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index 1beb3a8..2fccec5 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -226,7 +226,7 @@ static int t5_check_resp(uint8_t *resp, int length)
 	DBG("");
 
 	if (length < 0) {
-		near_error("Cmd failure: %d", length);
+		DBG("Cmd failure: %d", length);
 		err = length;
 	} else if (resp[0]) {
 		near_error("NFC Failure: 0x%x", resp[0]);
-- 
2.13.0
