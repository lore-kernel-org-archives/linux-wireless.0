Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33989 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750749AbdFOSZ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:28 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 20/23] nfctype5: Discard extra byte in RMB response data
Date: Thu, 15 Jun 2017 11:25:13 -0700
Message-Id: <20170615182516.4508-21-mgreer@animalcreek.com> (sfid-20170615_202638_876213_8102BEC8)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes there can be an extra byte in the response data for Read
Multiple Blocks (RMB) commands so discard it whenever that happens.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index a91d8f5..d6eec3c 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -654,7 +654,7 @@ static int t5_read_multiple_blocks_resp(uint8_t *resp, int length, void *data)
 	uint8_t blk_size = near_tag_get_blk_size(tag);
 	size_t data_length;
 	GList *records;
-	int err;
+	int err, expected_len;
 
 	DBG("");
 
@@ -665,9 +665,16 @@ static int t5_read_multiple_blocks_resp(uint8_t *resp, int length, void *data)
 		goto out_done;
 
 	length -= NFC_HEADER_SIZE;
+	expected_len = sizeof(*t5_resp) +
+		       cookie->nb_requested_blocks * blk_size;
 
-	if (length != (int)(sizeof(*t5_resp) +
-			    (cookie->nb_requested_blocks * blk_size))) {
+	/*
+	 * Sometimes an extra byte is returned in RMB response data.
+	 * Discard the extra byte whenever that happens.
+	 */
+	if (length == (expected_len + 1)) {
+		length--;
+	} else if (length != expected_len) {
 		err = -EIO;
 		goto out_done;
 	}
-- 
2.13.0
