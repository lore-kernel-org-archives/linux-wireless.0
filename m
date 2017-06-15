Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58573 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753011AbdFOSZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:25 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 15/23] nfctype5: Remove superfluous parentheses
Date: Thu, 15 Jun 2017 11:25:08 -0700
Message-Id: <20170615182516.4508-16-mgreer@animalcreek.com> (sfid-20170615_202634_978468_7FD3A64E)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the superfluous parentheses around calls to
t5_manufacturer_stmicro().

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index 29e1d0c..9d09bf8 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -456,7 +456,7 @@ static int t5_write_resp(uint8_t *resp, int length, void *data)
 		goto out_done;
 
 	/* CMD_FLAG_OPTION should be set for non ST tags */
-	if (!(t5_manufacturer_stmicro(tag)))
+	if (!t5_manufacturer_stmicro(tag))
 		t5_cmd->hdr.flags |= CMD_FLAG_OPTION;
 
 	t5_cmd->blk_no = cookie->blk;
@@ -515,7 +515,7 @@ static int t5_write(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 	 * does not work with ST Type5 tags.
 	 * So, implemeting OPTION flag set only for non ST tags.
 	 */
-	if (!(t5_manufacturer_stmicro(tag)))
+	if (!t5_manufacturer_stmicro(tag))
 		t5_cmd->hdr.flags |= CMD_FLAG_OPTION;
 
 	t5_cmd->blk_no = offset / blk_size;
@@ -1046,7 +1046,7 @@ static int t5_format_read_multiple_blocks_resp(uint8_t *resp, int length,
 	 * lying in different sectors. So, doing multi block read
 	 * support setting only for non ST tags.
 	 */
-	if (!(t5_manufacturer_stmicro(tag))) {
+	if (!t5_manufacturer_stmicro(tag)) {
 		if (read_multiple_supported)
 			t5_cc.cc3 |= TYPE5_CC3_MBREAD_FLAG;
 	}
-- 
2.13.0
