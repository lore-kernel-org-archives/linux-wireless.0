Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:58986 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZBUQxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 11:53:06 -0500
Received: by ey-out-2122.google.com with SMTP id 25so243174eya.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2009 08:53:04 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 1/2] orinoco: validate firmware header
Date: Sat, 21 Feb 2009 16:52:53 +0000
Message-Id: <1235235174-8106-2-git-send-email-kilroyd@googlemail.com> (sfid-20090221_175316_167796_FC68A7A3)
In-Reply-To: <1235235174-8106-1-git-send-email-kilroyd@googlemail.com>
References: <1235235174-8106-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the Agere firmware headers for validity before attempting to
download it.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/fw.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/fw.c b/drivers/net/wireless/orinoco/fw.c
index 7d2292d..9f163fe 100644
--- a/drivers/net/wireless/orinoco/fw.c
+++ b/drivers/net/wireless/orinoco/fw.c
@@ -43,6 +43,33 @@ struct orinoco_fw_header {
 	char signature[0];      /* FW signature length headersize-20 */
 } __attribute__ ((packed));
 
+/* Check the range of various header entries. Return a pointer to a
+ * description of the problem, or NULL if everything checks out. */
+static const char *validate_fw(const struct orinoco_fw_header *hdr, size_t len)
+{
+	u16 hdrsize;
+
+	if (len < sizeof(*hdr))
+		return "image too small";
+	if (memcmp(hdr->hdr_vers, "HFW", 3) != 0)
+		return "format not recognised";
+
+	hdrsize = le16_to_cpu(hdr->headersize);
+	if (hdrsize > len)
+		return "bad headersize";
+	if ((hdrsize + le32_to_cpu(hdr->block_offset)) > len)
+		return "bad block offset";
+	if ((hdrsize + le32_to_cpu(hdr->pdr_offset)) > len)
+		return "bad PDR offset";
+	if ((hdrsize + le32_to_cpu(hdr->pri_offset)) > len)
+		return "bad PRI offset";
+	if ((hdrsize + le32_to_cpu(hdr->compat_offset)) > len)
+		return "bad compat offset";
+
+	/* TODO: consider adding a checksum or CRC to the firmware format */
+	return NULL;
+}
+
 /* Download either STA or AP firmware into the card. */
 static int
 orinoco_dl_firmware(struct orinoco_private *priv,
@@ -58,6 +85,7 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 	const unsigned char *first_block;
 	const unsigned char *end;
 	const char *firmware;
+	const char *fw_err;
 	struct net_device *dev = priv->ndev;
 	int err = 0;
 
@@ -93,6 +121,15 @@ orinoco_dl_firmware(struct orinoco_private *priv,
 
 	hdr = (const struct orinoco_fw_header *) fw_entry->data;
 
+	fw_err = validate_fw(hdr, fw_entry->size);
+	if (fw_err) {
+		printk(KERN_WARNING "%s: Invalid firmware image detected (%s). "
+		       "Aborting download\n",
+		       dev->name, fw_err);
+		err = -EINVAL;
+		goto abort;
+	}
+
 	/* Enable aux port to allow programming */
 	err = hermesi_program_init(hw, le32_to_cpu(hdr->entry_point));
 	printk(KERN_DEBUG "%s: Program init returned %d\n", dev->name, err);
-- 
1.6.0.6

