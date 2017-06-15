Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58573 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751956AbdFOSZc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:32 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 16/23] nfctype5: Rework code that identifies ST Micro Type 5 tags
Date: Thu, 15 Jun 2017 11:25:09 -0700
Message-Id: <20170615182516.4508-17-mgreer@animalcreek.com> (sfid-20170615_202556_312508_7938CAA9)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the code that identifies ST Micro Type 5 tags to make it
conform better to established coding style in the file and to
make it easier to add check for tags from other manufacturers.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index 9d09bf8..689dec3 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -116,7 +116,7 @@
 #define GET_SYS_INFO_FLAG_16B_NB_BLOCK	0x10
 
 #define TYPE5_UID_MANUFAC_IDX		0x06
-#define TYPE5_UID_STMICRO_MANUFAC_ID	0x02
+#define TYPE5_UID_MANUFAC_ID_STMICRO	0x02
 
 struct type5_cmd_hdr {
 	uint8_t			flags;
@@ -194,6 +194,29 @@ struct t5_cookie {
 	uint8_t			nb_requested_blocks;
 };
 
+static bool t5_manufacturer_is(struct near_tag *tag, uint8_t manufacturer_id)
+{
+	uint8_t *uid;
+	bool match;
+
+	uid = near_tag_get_iso15693_uid(near_tag_get_adapter_idx(tag),
+					near_tag_get_target_idx(tag));
+	if (!uid) {
+		near_error("No type 5 UID");
+		return false;
+	}
+
+	match = (uid[TYPE5_UID_MANUFAC_IDX] == manufacturer_id);
+
+	g_free(uid);
+	return match;
+}
+
+static bool t5_manufacturer_is_stmicro(struct near_tag *tag)
+{
+	return t5_manufacturer_is(tag, TYPE5_UID_MANUFAC_ID_STMICRO);
+}
+
 static int t5_cmd_hdr_init(struct near_tag *tag, struct type5_cmd_hdr *cmd_hdr,
 		int cmd)
 {
@@ -392,26 +415,6 @@ static int t5_read(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 			cookie, t5_cookie_release_local);
 }
 
-static bool t5_manufacturer_stmicro(struct near_tag *tag)
-{
-        uint8_t *uid;
-
-        uid = near_tag_get_iso15693_uid(near_tag_get_adapter_idx(tag),
-                                        near_tag_get_target_idx(tag));
-        if (!uid) {
-                near_error("No type 5 UID");
-                return false;
-        }
-
-        if (uid[TYPE5_UID_MANUFAC_IDX] != TYPE5_UID_STMICRO_MANUFAC_ID) {
-                g_free(uid);
-                return false;
-        }
-
-        g_free(uid);
-        return true;
-}
-
 static int t5_write_resp(uint8_t *resp, int length, void *data)
 {
 	struct type5_write_single_block_resp *t5_resp =
@@ -456,7 +459,7 @@ static int t5_write_resp(uint8_t *resp, int length, void *data)
 		goto out_done;
 
 	/* CMD_FLAG_OPTION should be set for non ST tags */
-	if (!t5_manufacturer_stmicro(tag))
+	if (!t5_manufacturer_is_stmicro(tag))
 		t5_cmd->hdr.flags |= CMD_FLAG_OPTION;
 
 	t5_cmd->blk_no = cookie->blk;
@@ -515,7 +518,7 @@ static int t5_write(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 	 * does not work with ST Type5 tags.
 	 * So, implemeting OPTION flag set only for non ST tags.
 	 */
-	if (!t5_manufacturer_stmicro(tag))
+	if (!t5_manufacturer_is_stmicro(tag))
 		t5_cmd->hdr.flags |= CMD_FLAG_OPTION;
 
 	t5_cmd->blk_no = offset / blk_size;
@@ -1046,7 +1049,7 @@ static int t5_format_read_multiple_blocks_resp(uint8_t *resp, int length,
 	 * lying in different sectors. So, doing multi block read
 	 * support setting only for non ST tags.
 	 */
-	if (!t5_manufacturer_stmicro(tag)) {
+	if (!t5_manufacturer_is_stmicro(tag)) {
 		if (read_multiple_supported)
 			t5_cc.cc3 |= TYPE5_CC3_MBREAD_FLAG;
 	}
-- 
2.13.0
