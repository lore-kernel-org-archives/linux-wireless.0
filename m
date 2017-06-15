Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41667 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753195AbdFOSZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 17/23] nfctype5: Add support for TI Standard and Pro Type 5 tag
Date: Thu, 15 Jun 2017 11:25:10 -0700
Message-Id: <20170615182516.4508-18-mgreer@animalcreek.com> (sfid-20170615_202550_354310_04850C34)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Standard and Pro Type 5 tags from Texas Instruments do not support
the Get System Information command which means they cannot be read
with the current neard code.  Fortunately, both types of tags have
eight, 4-byte blocks so that information can be filled in instead
of issuing the Get System Information command to get it.  With this
change, Standard and Pro tags can now be formatted, read, and written.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index 689dec3..f26d8fa 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -117,6 +117,7 @@
 
 #define TYPE5_UID_MANUFAC_IDX		0x06
 #define TYPE5_UID_MANUFAC_ID_STMICRO	0x02
+#define TYPE5_UID_MANUFAC_ID_TI		0x07
 
 struct type5_cmd_hdr {
 	uint8_t			flags;
@@ -217,6 +218,49 @@ static bool t5_manufacturer_is_stmicro(struct near_tag *tag)
 	return t5_manufacturer_is(tag, TYPE5_UID_MANUFAC_ID_STMICRO);
 }
 
+static bool t5_manufacturer_is_ti(struct near_tag *tag)
+{
+	return t5_manufacturer_is(tag, TYPE5_UID_MANUFAC_ID_TI);
+}
+
+static bool t5_tag_is_ti_std(struct near_tag *tag)
+{
+	uint8_t *uid;
+	bool ret = false;
+
+	uid = near_tag_get_iso15693_uid(near_tag_get_adapter_idx(tag),
+					near_tag_get_target_idx(tag));
+	if (!uid) {
+		near_error("No type 5 UID");
+		return false;
+	}
+
+	if ((uid[5] == 0xc0) || (uid[5] == 0xc1))
+		ret = true;
+
+	g_free(uid);
+	return ret;
+}
+
+static bool t5_tag_is_ti_pro(struct near_tag *tag)
+{
+	uint8_t *uid;
+	bool ret;
+
+	uid = near_tag_get_iso15693_uid(near_tag_get_adapter_idx(tag),
+					near_tag_get_target_idx(tag));
+	if (!uid) {
+		near_error("No type 5 UID");
+		return false;
+	}
+
+	if ((uid[5] == 0xc4) || (uid[5] == 0xc5))
+		ret = true;
+
+	g_free(uid);
+	return ret;
+}
+
 static int t5_cmd_hdr_init(struct near_tag *tag, struct type5_cmd_hdr *cmd_hdr,
 		int cmd)
 {
@@ -851,10 +895,23 @@ static int nfctype5_read(uint32_t adapter_idx, uint32_t target_idx,
 	 * num_blks once.  near_tag_get_blk_size() will return 0 if
 	 * t5_get_sys_info() hasn't been called yet.
 	 */
-	if (near_tag_get_blk_size(tag))
+	if (near_tag_get_blk_size(tag)) {
 		err = t5_read_meta(tag, cookie);
-	else
+	} else if (t5_manufacturer_is_ti(tag) &&
+		   (t5_tag_is_ti_std(tag) || t5_tag_is_ti_pro(tag))) {
+		/*
+		 * TI Standard and Pro tags do not support the Get System
+		 * Information command but are known to have eight, 4-byte
+		 * blocks so we can fill that info in and call t5_read_meta()
+		 * here.
+		 */
+		near_tag_set_blk_size(tag, 4);
+		near_tag_set_num_blks(tag, 8);
+
+		err = t5_read_meta(tag, cookie);
+	} else {
 		err = t5_get_sys_info(tag, cookie);
+	}
 
 	if (err < 0)
 		err = t5_cookie_release(err, cookie);
-- 
2.13.0
