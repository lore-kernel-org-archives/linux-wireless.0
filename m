Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53359 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753202AbdFOSZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 21/23] nfctype5: Fix formatting
Date: Thu, 15 Jun 2017 11:25:14 -0700
Message-Id: <20170615182516.4508-22-mgreer@animalcreek.com> (sfid-20170615_202542_016431_99236A6C)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the output of the Linux kernel's 'Lindent' script to format
the code in nfctype5.c.  Some of the formatting performed by
Lindent was overridden for various reasons. These include:
	- no space between '__attribute__' and '((packed))' to match
	  other tag files
	- struct members names are aligned when defined for readability
	- compile-time init of struct members are aligned for readability
	- call arguments not lined up when result would cause lines with
	  more than 80 characters
	- no spaces around ampersand when casting address of a variable
	- no space between '*' and name in declarations/definitions

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 plugins/nfctype5.c | 118 ++++++++++++++++++++++++++---------------------------
 1 file changed, 58 insertions(+), 60 deletions(-)

diff --git a/plugins/nfctype5.c b/plugins/nfctype5.c
index d6eec3c..3d2cdf0 100644
--- a/plugins/nfctype5.c
+++ b/plugins/nfctype5.c
@@ -262,14 +262,14 @@ static bool t5_tag_is_ti_pro(struct near_tag *tag)
 }
 
 static int t5_cmd_hdr_init(struct near_tag *tag, struct type5_cmd_hdr *cmd_hdr,
-		int cmd)
+			   int cmd)
 {
 	uint8_t *uid;
 
 	DBG("");
 
 	uid = near_tag_get_iso15693_uid(near_tag_get_adapter_idx(tag),
-						near_tag_get_target_idx(tag));
+					near_tag_get_target_idx(tag));
 	if (!uid) {
 		near_error("No type 5 UID");
 		return -EINVAL;
@@ -287,7 +287,7 @@ static int t5_cmd_hdr_init(struct near_tag *tag, struct type5_cmd_hdr *cmd_hdr,
 static int t5_check_resp(uint8_t *resp, int length)
 {
 	struct type5_err_resp *t5_err_resp =
-		(struct type5_err_resp *)(resp + NFC_HEADER_SIZE);
+	    (struct type5_err_resp *)(resp + NFC_HEADER_SIZE);
 	int err = 0;
 
 	DBG("");
@@ -304,7 +304,7 @@ static int t5_check_resp(uint8_t *resp, int length)
 		if (t5_err_resp->flags & RESP_FLAG_ERR) {
 			if (length == 2)
 				near_error("Tag failure: 0x%x",
-						t5_err_resp->err_code);
+					   t5_err_resp->err_code);
 			else
 				near_error("Tag failure: Cause unknown");
 
@@ -339,7 +339,7 @@ static int t5_cookie_release(int err, void *data)
 
 	else if (cookie->cb)
 		cookie->cb(near_tag_get_adapter_idx(cookie->tag),
-				near_tag_get_target_idx(cookie->tag), err);
+			   near_tag_get_target_idx(cookie->tag), err);
 
 	if (cookie->ndef) {
 		g_free(cookie->ndef->data);
@@ -375,7 +375,7 @@ static int t5_cookie_release_local(int err, void *data)
 static int t5_read_resp(uint8_t *resp, int length, void *data)
 {
 	struct type5_read_single_block_resp *t5_resp =
-		(struct type5_read_single_block_resp *)(resp + NFC_HEADER_SIZE);
+	    (struct type5_read_single_block_resp *)(resp + NFC_HEADER_SIZE);
 	struct type5_read_single_block_cmd t5_cmd;
 	struct t5_cookie *cookie = data;
 	struct near_tag *tag = cookie->tag;
@@ -400,7 +400,7 @@ static int t5_read_resp(uint8_t *resp, int length, void *data)
 	length = MIN(length, (int)cookie->bytes_left);
 
 	memcpy(&cookie->buf[cookie->dst_offset],
-			&t5_resp->data[cookie->src_offset], length);
+	       &t5_resp->data[cookie->src_offset], length);
 
 	if (cookie->bytes_left <= blk_size)
 		goto out_done;
@@ -417,8 +417,8 @@ static int t5_read_resp(uint8_t *resp, int length, void *data)
 	t5_cmd.blk_no = cookie->blk;
 
 	return near_adapter_send(near_tag_get_adapter_idx(tag),
-			(uint8_t *)&t5_cmd, sizeof(t5_cmd), t5_read_resp,
-			cookie, t5_cookie_release_local);
+				 (uint8_t *)&t5_cmd, sizeof(t5_cmd),
+				 t5_read_resp, cookie, t5_cookie_release_local);
 
 out_done:
 	DBG("Done reading: %d", err);
@@ -427,7 +427,7 @@ out_done:
 }
 
 static int t5_read(struct near_tag *tag, uint8_t offset, uint8_t *buf,
-		size_t len, t5_local_cb local_cb, void *local_data)
+		   size_t len, t5_local_cb local_cb, void *local_data)
 {
 	struct type5_read_single_block_cmd t5_cmd;
 	struct t5_cookie *cookie;
@@ -455,15 +455,15 @@ static int t5_read(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 	cookie->blk = t5_cmd.blk_no;
 
 	return near_adapter_send(near_tag_get_adapter_idx(tag),
-			(uint8_t *)&t5_cmd, sizeof(t5_cmd), t5_read_resp,
-			cookie, t5_cookie_release_local);
+				 (uint8_t *)&t5_cmd, sizeof(t5_cmd),
+				 t5_read_resp, cookie, t5_cookie_release_local);
 }
 
 static int t5_write_resp(uint8_t *resp, int length, void *data)
 {
 	struct type5_write_single_block_resp *t5_resp =
-		(struct type5_write_single_block_resp *)
-			(resp + NFC_HEADER_SIZE);
+	    (struct type5_write_single_block_resp *)
+	    (resp + NFC_HEADER_SIZE);
 	struct type5_write_single_block_cmd *t5_cmd = NULL;
 	struct t5_cookie *cookie = data;
 	struct near_tag *tag = cookie->tag;
@@ -497,8 +497,7 @@ static int t5_write_resp(uint8_t *resp, int length, void *data)
 		goto out_done;
 	}
 
-	err = t5_cmd_hdr_init(tag, &t5_cmd->hdr,
-				CMD_WRITE_SINGLE_BLOCK);
+	err = t5_cmd_hdr_init(tag, &t5_cmd->hdr, CMD_WRITE_SINGLE_BLOCK);
 	if (err)
 		goto out_done;
 
@@ -510,8 +509,8 @@ static int t5_write_resp(uint8_t *resp, int length, void *data)
 	memcpy(t5_cmd->data, &cookie->buf[cookie->src_offset], blk_size);
 
 	err = near_adapter_send(near_tag_get_adapter_idx(tag),
-			(uint8_t *)t5_cmd, sizeof(*t5_cmd) + blk_size,
-			t5_write_resp, cookie, t5_cookie_release_local);
+				(uint8_t *) t5_cmd, sizeof(*t5_cmd) + blk_size,
+				t5_write_resp, cookie, t5_cookie_release_local);
 
 	g_free(t5_cmd);
 	return err;
@@ -526,7 +525,7 @@ out_done:
 }
 
 static int t5_write(struct near_tag *tag, uint8_t offset, uint8_t *buf,
-		size_t len, t5_local_cb local_cb, void *local_data)
+		    size_t len, t5_local_cb local_cb, void *local_data)
 {
 	struct type5_write_single_block_cmd *t5_cmd;
 	struct t5_cookie *cookie;
@@ -537,7 +536,7 @@ static int t5_write(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 
 	if (offset % blk_size) {
 		near_error("Write - Invalid offset - offset: %d, blk_size: %d",
-				offset, blk_size);
+			   offset, blk_size);
 		return -EINVAL;
 	}
 
@@ -582,8 +581,8 @@ static int t5_write(struct near_tag *tag, uint8_t offset, uint8_t *buf,
 	cookie->blk = t5_cmd->blk_no;
 
 	err = near_adapter_send(near_tag_get_adapter_idx(tag),
-			(uint8_t *)t5_cmd, sizeof(*t5_cmd) + blk_size,
-			t5_write_resp, cookie, t5_cookie_release_local);
+				(uint8_t *) t5_cmd, sizeof(*t5_cmd) + blk_size,
+				t5_write_resp, cookie, t5_cookie_release_local);
 
 out_err:
 	g_free(t5_cmd);
@@ -624,10 +623,9 @@ static bool t5_cc_is_valid(struct type5_cc *t5_cc)
 	bool valid = false;
 
 	if ((t5_cc->cc0 == TYPE5_CC0_NDEF_MAGIC) &&
-			(TYPE5_CC1_VER_GET_MAJOR(t5_cc->cc1) ==
-				 TYPE5_VERSION_MAJOR) &&
-			(TYPE5_CC1_VER_GET_MINOR(t5_cc->cc1) ==
-				 TYPE5_VERSION_MINOR))
+	    (TYPE5_CC1_VER_GET_MAJOR(t5_cc->cc1) ==
+	     TYPE5_VERSION_MAJOR) &&
+	    (TYPE5_CC1_VER_GET_MINOR(t5_cc->cc1) == TYPE5_VERSION_MINOR))
 		valid = true;
 
 	return valid;
@@ -641,14 +639,14 @@ static size_t t5_cc_get_data_length(struct type5_cc *t5_cc)
 static bool t5_cc_is_read_only(struct type5_cc *t5_cc)
 {
 	return (t5_cc->cc1 & TYPE5_CC1_WRITE_ACCESS_MASK) !=
-		TYPE5_CC1_WRITE_ACCESS_ALWAYS;
+	    TYPE5_CC1_WRITE_ACCESS_ALWAYS;
 }
 
 static int t5_read_multiple_blocks_resp(uint8_t *resp, int length, void *data)
 {
 	struct type5_read_multiple_blocks_resp *t5_resp =
-		(struct type5_read_multiple_blocks_resp *)
-					(resp + NFC_HEADER_SIZE);
+	    (struct type5_read_multiple_blocks_resp *)
+	    (resp + NFC_HEADER_SIZE);
 	struct t5_cookie *cookie = data;
 	struct near_tag *tag = cookie->tag;
 	uint8_t blk_size = near_tag_get_blk_size(tag);
@@ -666,7 +664,7 @@ static int t5_read_multiple_blocks_resp(uint8_t *resp, int length, void *data)
 
 	length -= NFC_HEADER_SIZE;
 	expected_len = sizeof(*t5_resp) +
-		       cookie->nb_requested_blocks * blk_size;
+	    cookie->nb_requested_blocks * blk_size;
 
 	/*
 	 * Sometimes an extra byte is returned in RMB response data.
@@ -692,8 +690,7 @@ out_done:
 static int t5_read_multiple_blocks(struct near_tag *tag,
 				   uint8_t starting_block,
 				   uint8_t number_of_blocks,
-				   near_recv rx_cb,
-				   struct t5_cookie *cookie)
+				   near_recv rx_cb, struct t5_cookie *cookie)
 {
 	struct type5_read_multiple_blocks_cmd t5_cmd;
 	int err;
@@ -708,8 +705,8 @@ static int t5_read_multiple_blocks(struct near_tag *tag,
 	t5_cmd.num_blks = number_of_blocks - 1;
 
 	return near_adapter_send(near_tag_get_adapter_idx(tag),
-			(uint8_t *)&t5_cmd, sizeof(t5_cmd),
-                        rx_cb, cookie, t5_cookie_release);
+				 (uint8_t *)&t5_cmd, sizeof(t5_cmd),
+				 rx_cb, cookie, t5_cookie_release);
 }
 
 static int t5_read_meta_resp(struct near_tag *tag, int err, void *data)
@@ -730,11 +727,11 @@ static int t5_read_meta_resp(struct near_tag *tag, int err, void *data)
 
 	if (t5_cc_is_valid(t5_cc)) {
 		data_length = t5_cc_get_data_length(t5_cc) -
-			TYPE5_DATA_START_OFFSET(tag);
+		    TYPE5_DATA_START_OFFSET(tag);
 
 		err = near_tag_add_data(near_tag_get_adapter_idx(tag),
-				near_tag_get_target_idx(tag), NULL,
-				data_length);
+					near_tag_get_target_idx(tag), NULL,
+					data_length);
 		if (err)
 			goto out_err;
 
@@ -757,13 +754,13 @@ static int t5_read_meta_resp(struct near_tag *tag, int err, void *data)
 
 		if (rmb_supported) {
 			first_block = TYPE5_DATA_START_OFFSET(tag) /
-				near_tag_get_blk_size(tag);
+			    near_tag_get_blk_size(tag);
 			cookie->nb_requested_blocks =
-				near_tag_get_num_blks(tag) - first_block;
+			    near_tag_get_num_blks(tag) - first_block;
 			err = t5_read_multiple_blocks(tag, first_block,
-					cookie->nb_requested_blocks,
-					t5_read_multiple_blocks_resp,
-					cookie);
+						   cookie->nb_requested_blocks,
+						   t5_read_multiple_blocks_resp,
+						   cookie);
 		} else {
 			err = t5_read(tag, TYPE5_DATA_START_OFFSET(tag),
 				      tag_data, data_length, t5_read_data_resp,
@@ -798,7 +795,7 @@ static int t5_read_meta(struct near_tag *tag, struct t5_cookie *cookie)
 	cookie->buf = buf;
 
 	err = t5_read(tag, TYPE5_META_START_OFFSET, buf, TYPE5_LEN_CC_BYTES,
-			t5_read_meta_resp, cookie);
+		      t5_read_meta_resp, cookie);
 	if (err < 0)
 		g_free(buf);
 
@@ -808,7 +805,7 @@ static int t5_read_meta(struct near_tag *tag, struct t5_cookie *cookie)
 static int t5_get_sys_info_resp(uint8_t *resp, int length, void *data)
 {
 	struct type5_get_system_info_resp *t5_resp =
-		(struct type5_get_system_info_resp *)(resp + NFC_HEADER_SIZE);
+	    (struct type5_get_system_info_resp *)(resp + NFC_HEADER_SIZE);
 	struct t5_cookie *cookie = data;
 	struct near_tag *tag = cookie->tag;
 	uint8_t offset = 0;
@@ -824,7 +821,7 @@ static int t5_get_sys_info_resp(uint8_t *resp, int length, void *data)
 
 	if (length < (int)sizeof(*t5_resp)) {
 		near_error("Get System Info - Invalid response - length: %d",
-				length);
+			   length);
 		err = -EIO;
 		goto out_err;
 	}
@@ -838,13 +835,14 @@ static int t5_get_sys_info_resp(uint8_t *resp, int length, void *data)
 	if (t5_resp->info_flags & GET_SYS_INFO_FLAG_MEM_SIZE) {
 		if (t5_resp->info_flags & GET_SYS_INFO_FLAG_16B_NB_BLOCK) {
 			near_tag_set_num_blks(tag, (t5_resp->data[offset] |
-				(t5_resp->data[offset + 1] << 8)) + 1);
+						    (t5_resp->data[offset + 1]
+						     << 8)) + 1);
 			offset += 2;
 		} else
 			near_tag_set_num_blks(tag, t5_resp->data[offset++] + 1);
 		near_tag_set_blk_size(tag,
-			(t5_resp->data[offset++] & 0x1f) + 1);
-	} else { /* Tag must provide memory size info */
+				      (t5_resp->data[offset++] & 0x1f) + 1);
+	} else {		/* Tag must provide memory size info */
 		err = -EIO;
 		goto out_err;
 	}
@@ -870,12 +868,12 @@ static int t5_get_sys_info(struct near_tag *tag, struct t5_cookie *cookie)
 		return err;
 
 	return near_adapter_send(near_tag_get_adapter_idx(tag),
-			(uint8_t *)&t5_cmd, sizeof(t5_cmd),
-			t5_get_sys_info_resp, cookie, NULL);
+				 (uint8_t *)&t5_cmd, sizeof(t5_cmd),
+				 t5_get_sys_info_resp, cookie, NULL);
 }
 
 static int nfctype5_read(uint32_t adapter_idx, uint32_t target_idx,
-		near_tag_io_cb cb)
+			 near_tag_io_cb cb)
 {
 	struct t5_cookie *cookie;
 	struct near_tag *tag;
@@ -942,7 +940,7 @@ static int nfctype5_write_resp(struct near_tag *tag, int err, void *data)
 }
 
 static int nfctype5_write(uint32_t adapter_idx, uint32_t target_idx,
-		struct near_ndef_message *ndef, near_tag_io_cb cb)
+			  struct near_ndef_message *ndef, near_tag_io_cb cb)
 {
 	struct t5_cookie *cookie;
 	struct near_tag *tag;
@@ -966,8 +964,8 @@ static int nfctype5_write(uint32_t adapter_idx, uint32_t target_idx,
 	cookie->ndef = ndef;
 
 	err = t5_write(tag, TYPE5_DATA_START_OFFSET(tag),
-			ndef->data + ndef->offset, ndef->length,
-			nfctype5_write_resp, cookie);
+		       ndef->data + ndef->offset, ndef->length,
+		       nfctype5_write_resp, cookie);
 	if (err < 0)
 		err = t5_cookie_release(err, cookie);
 
@@ -981,7 +979,7 @@ out_err:
 }
 
 static int nfctype5_check_presence_resp(struct near_tag *tag, int err,
-		void *data)
+					void *data)
 {
 	struct t5_cookie *cookie = data;
 
@@ -993,7 +991,7 @@ static int nfctype5_check_presence_resp(struct near_tag *tag, int err,
 }
 
 static int nfctype5_check_presence(uint32_t adapter_idx, uint32_t target_idx,
-		near_tag_io_cb cb)
+				   near_tag_io_cb cb)
 {
 	struct t5_cookie *cookie;
 	struct near_tag *tag;
@@ -1056,7 +1054,7 @@ static int nfctype5_format_resp(struct near_tag *tag, int err, void *data)
 }
 
 static int nfctype5_format(uint32_t adapter_idx, uint32_t target_idx,
-		near_tag_io_cb cb)
+			   near_tag_io_cb cb)
 {
 	struct type5_cc t5_cc;
 	struct t5_cookie *cookie;
@@ -1118,7 +1116,7 @@ static int nfctype5_format(uint32_t adapter_idx, uint32_t target_idx,
 	t5_cc.cc3 = 0;
 
 	err = t5_write(tag, TYPE5_META_START_OFFSET, (uint8_t *)&t5_cc,
-			sizeof(t5_cc), nfctype5_format_resp, cookie);
+		       sizeof(t5_cc), nfctype5_format_resp, cookie);
 	if (err < 0)
 		err = t5_cookie_release(err, cookie);
 
@@ -1136,7 +1134,7 @@ static struct near_tag_driver type5_driver = {
 	.priority	= NEAR_TAG_PRIORITY_DEFAULT,
 	.read		= nfctype5_read,
 	.write		= nfctype5_write,
-	.check_presence = nfctype5_check_presence,
+	.check_presence	= nfctype5_check_presence,
 	.format		= nfctype5_format,
 };
 
@@ -1155,4 +1153,4 @@ static void nfctype5_exit(void)
 }
 
 NEAR_PLUGIN_DEFINE(nfctype5, "ISO 15693 (NFC Type 5) tags support", VERSION,
-			NEAR_PLUGIN_PRIORITY_HIGH, nfctype5_init, nfctype5_exit)
+		   NEAR_PLUGIN_PRIORITY_HIGH, nfctype5_init, nfctype5_exit)
-- 
2.13.0
