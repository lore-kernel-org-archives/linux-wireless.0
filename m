Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41667 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752965AbdFOSZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:25 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 12/23] nfctype2: Don't read tags with bad magic number
Date: Thu, 15 Jun 2017 11:25:05 -0700
Message-Id: <20170615182516.4508-13-mgreer@animalcreek.com> (sfid-20170615_202646_691523_D5B7971C)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NFC Type 2 tags that have a bad magic number need to be reformatted
so do not try to read them.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/plugins/nfctype2.c b/plugins/nfctype2.c
index 559ecb0..f0f1158 100644
--- a/plugins/nfctype2.c
+++ b/plugins/nfctype2.c
@@ -275,6 +275,7 @@ static int meta_recv(uint8_t *resp, int length, void *data)
 	if (TAG_DATA_NFC(cc) != TYPE2_MAGIC) {
 		DBG("Mark as blank tag");
 		near_tag_set_blank(tag, TRUE);
+		goto out_tag;
 	} else {
 		near_tag_set_blank(tag, FALSE);
 	}
-- 
2.13.0
