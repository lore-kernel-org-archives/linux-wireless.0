Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:14924 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZBTAAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:00:07 -0500
Received: by ey-out-2122.google.com with SMTP id 25so78853eya.37
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 16:00:05 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/2] orinoco: validate firmware header
Date: Thu, 19 Feb 2009 23:46:26 +0000
Message-Id: <1235087187-23425-2-git-send-email-kilroyd@googlemail.com> (sfid-20090220_010013_196797_117A5059)
In-Reply-To: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com>
References: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the Agere firmware headers for validity before attempting to
download it.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/fw.c |   45 +++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 7d2292d..b2ad24f 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -28,6 +28,16 @@ static const struct fw_info orinoco_fw[] = {
 	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", NULL, 0x00003100, 512 }
 };
 
+static const char *fw_err[] = {
+	"image too small",
+	"format not recognised",
+	"bad headersize",
+	"bad block offset",
+	"bad PDR offset",
+	"bad PRI offset",
+	"bad compat offset"
+};
+
 /* Structure used to access fields in FW
  * Make sure LE decoding macros are used
  */
@@ -43,6 +53,32 @@ struct orinoco_fw_header {
 	char signature[0];      /* FW signature length headersize-20 */
 } __attribute__ ((packed));
 
+/* Check the range of various header entries */
+static int validate_fw(const struct orinoco_fw_header *hdr, size_t len)
+{
+	u16 hdrsize;
+
+	if (len < sizeof(*hdr))
+		return 1;
+	if (memcmp(hdr->hdr_vers, "HFW", 3) != 0)
+		return 2;
+
+	hdrsize = le16_to_cpu(hdr->headersize);
+	if (hdrsize > len)
+		return 3;
+	if ((hdrsize + le32_to_cpu(hdr->block_offset)) > len)
+		return 4;
+	if ((hdrsize + le32_to_cpu(hdr->pdr_offset)) > len)
+		return 5;
+	if ((hdrsize + le32_to_cpu(hdr->pri_offset)) > len)
+		return 6;
+	if ((hdrsize + le32_to_cpu(hdr->compat_offset)) > len)
+		return 7;
+
+	/* TODO: consider adding a checksum or CRC to the firmware format */
+	return 0;
+}
+
 /* Download either STA or AP firmware into the card. */
 static int
 orinoco_dl_firmware(struct orinoco_private *priv,
@@ -93,6 +129,15 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
 
+	err = validate_fw(hdr, fw_entry->size);
+	if (err) {
+		printk(KERN_WARNING "%s: Invalid firmware image detected (%s). "
+		       "Aborting download\n",
+		       dev->name, fw_err[err - 1]);
+		err = -EINVAL;
+		goto abort;
+	}
+
 	/* Enable aux port to allow programming */
 	err = hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
 	printk(KERN_DEBUG "%s: Program init returned %d\n", dev->name, err);
-- 
1.6.0.6

