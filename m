Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55073 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752070AbdFOSZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 19/23] nfctype5: Don't issue RMB command when formatting
Date: Thu, 15 Jun 2017 11:25:12 -0700
Message-Id: <20170615182516.4508-20-mgreer@animalcreek.com> (sfid-20170615_202550_186503_EA4F1A0F)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, when neard is formatting a Type 5 tag, it issues the Read
Multiple Blocks (RMB) command to see if the tag supports it.  If the
command succeeds, the appropriate bit in the CC is set so the RMB
command can be used in the future.  The problem is that when the tag
doesn't support the command, a failure is returned by the kernel causing
the neard adapter code to disconnect from the tag.  This effectively
makes the tag unusable by neard.

To avoid this issue, don't bother checking to see if the RMB command
is supported and just assume that it isn't (and therefore, do not set
the MBREAD bit in the CC).  This has the benefit of formatting Type 5
tags that don't support RMB at the cost of forcing future readers to
use a series of Read Single Block commands for multi-block reads (i.e.,
slower than a single multi-block read).

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 77 +++++++++++++++++-------------------------------------
 1 file changed, 24 insertions(+), 53 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index 873ac79..a91d8f5 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -1048,30 +1048,31 @@ static int nfctype5_format_resp(struct near_tag *tag, int err, void *data)
 	return t5_cookie_release(err, cookie);
 }
 
-static int t5_format_read_multiple_blocks_resp(uint8_t *resp, int length,
-						void *data)
+static int nfctype5_format(uint32_t adapter_idx, uint32_t target_idx,
+		near_tag_io_cb cb)
 {
-	struct type5_read_multiple_blocks_resp *t5_resp =
-		(struct type5_read_multiple_blocks_resp *)
-					(resp + NFC_HEADER_SIZE);
-	struct t5_cookie *cookie = data;
 	struct type5_cc t5_cc;
-	struct near_tag *tag = cookie->tag;
-	uint8_t blk_size = near_tag_get_blk_size(tag);
+	struct t5_cookie *cookie;
+	struct near_tag *tag;
 	size_t mem_size;
-	bool read_multiple_supported = false;
 	int err;
 
 	DBG("");
 
-	err = t5_check_resp(resp, length);
-	if (!err) {
-		length -= NFC_HEADER_SIZE;
+	tag = near_tag_get_tag(adapter_idx, target_idx);
+	if (!tag) {
+		err = -EINVAL;
+		goto out_err;
+	}
 
-		if (length == (int)(sizeof(*t5_resp) + (2 * blk_size)))
-			read_multiple_supported = true;
+	cookie = t5_cookie_alloc(tag);
+	if (!cookie) {
+		err = -ENOMEM;
+		goto out_err;
 	}
 
+	cookie->cb = cb;
+
 	t5_cc.cc0 = TYPE5_CC0_NDEF_MAGIC;
 
 	t5_cc.cc1 = TYPE5_VERSION_MAJOR << TYPE5_CC1_VER_MAJOR_SHIFT;
@@ -1086,7 +1087,7 @@ static int t5_format_read_multiple_blocks_resp(uint8_t *resp, int length,
 	 */
 	t5_cc.cc1 |= TYPE5_CC1_WRITE_ACCESS_ALWAYS;
 
-	mem_size = blk_size * near_tag_get_num_blks(tag);
+	mem_size = near_tag_get_blk_size(tag) * near_tag_get_num_blks(tag);
 	mem_size = MIN(mem_size, TYPE5_MAX_MEM_SIZE);
 
 	t5_cc.cc2 = mem_size / 8;
@@ -1098,53 +1099,23 @@ static int t5_format_read_multiple_blocks_resp(uint8_t *resp, int length,
 	 * just say that its not supported.  We also don't know whether
 	 * the tag needs a special frame format so just say "no" for that
 	 * one too.  If it does, we probably can't write to the tag anyway.
+	 *
+	 * In order to know if the tag supports the Read Multiple Blocks
+	 * command, we would have to issue that command here to see if it
+	 * succeeds.  If it does succeed, then TYPE5_CC3_MBREAD_FLAG could
+	 * be set; however, if it fails, the adapter code will disconnect
+	 * from the tag and the format will fail making the tag unusable.
+	 * To avoid that possibility, indicate that Read Multiple Blocks
+	 * commands is not supported (i.e., do not set TYPE5_CC3_MBREAD_FLAG).
 	 */
 	t5_cc.cc3 = 0;
 
-	/*
-	 * ST Type5 tags does not support multiblock read for blocks
-	 * lying in different sectors. So, doing multi block read
-	 * support setting only for non ST tags.
-	 */
-	if (!t5_manufacturer_is_stmicro(tag)) {
-		if (read_multiple_supported)
-			t5_cc.cc3 |= TYPE5_CC3_MBREAD_FLAG;
-	}
-
 	err = t5_write(tag, TYPE5_META_START_OFFSET, (uint8_t *)&t5_cc,
 			sizeof(t5_cc), nfctype5_format_resp, cookie);
 	if (err < 0)
 		err = t5_cookie_release(err, cookie);
 
 	return err;
-}
-
-static int nfctype5_format(uint32_t adapter_idx, uint32_t target_idx,
-		near_tag_io_cb cb)
-{
-	struct t5_cookie *cookie;
-	struct near_tag *tag;
-	int err;
-
-	DBG("");
-
-	tag = near_tag_get_tag(adapter_idx, target_idx);
-	if (!tag) {
-		err = -EINVAL;
-		goto out_err;
-	}
-
-	cookie = t5_cookie_alloc(tag);
-	if (!cookie) {
-		err = -ENOMEM;
-		goto out_err;
-	}
-
-	cookie->cb = cb;
-
-	return t5_read_multiple_blocks(tag, 0, 2,
-				       t5_format_read_multiple_blocks_resp,
-				       cookie);
 
 out_err:
 	if (cb)
-- 
2.13.0
