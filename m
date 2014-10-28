Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:33678 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaJ1N7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:59:09 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/16] brcmfmac: (clean) Remove usb_rdl.h as it is not needed.
Date: Tue, 28 Oct 2014 14:56:10 +0100
Message-ID: <1414504579-12562-8-git-send-email-arend@broadcom.com> (sfid-20141028_145912_935706_F554C94E)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c     | 88 ++++++++++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h | 75 -------------------
 2 files changed, 69 insertions(+), 94 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index e533000..3f12b60 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -27,9 +27,9 @@
 #include <dhd_dbg.h>
 
 #include "firmware.h"
-#include "usb_rdl.h"
 #include "usb.h"
 
+
 #define IOCTL_RESP_TIMEOUT		2000
 
 #define BRCMF_USB_RESET_GETVER_SPINWAIT	100	/* in unit of ms */
@@ -49,6 +49,71 @@
 #define BRCMF_USB_43242_FW_NAME		"brcm/brcmfmac43242a.bin"
 #define BRCMF_USB_43569_FW_NAME		"brcm/brcmfmac43569.bin"
 
+#define TRX_MAGIC		0x30524448	/* "HDR0" */
+#define TRX_MAX_OFFSET		3		/* Max number of file offsets */
+#define TRX_UNCOMP_IMAGE	0x20		/* Trx holds uncompressed img */
+#define TRX_RDL_CHUNK		1500		/* size of each dl transfer */
+#define TRX_OFFSETS_DLFWLEN_IDX	0
+
+/* Control messages: bRequest values */
+#define DL_GETSTATE	0	/* returns the rdl_state_t struct */
+#define DL_CHECK_CRC	1	/* currently unused */
+#define DL_GO		2	/* execute downloaded image */
+#define DL_START	3	/* initialize dl state */
+#define DL_REBOOT	4	/* reboot the device in 2 seconds */
+#define DL_GETVER	5	/* returns the bootrom_id_t struct */
+#define DL_GO_PROTECTED	6	/* execute the downloaded code and set reset
+				 * event to occur in 2 seconds.  It is the
+				 * responsibility of the downloaded code to
+				 * clear this event
+				 */
+#define DL_EXEC		7	/* jump to a supplied address */
+#define DL_RESETCFG	8	/* To support single enum on dongle
+				 * - Not used by bootloader
+				 */
+#define DL_DEFER_RESP_OK 9	/* Potentially defer the response to setup
+				 * if resp unavailable
+				 */
+
+/* states */
+#define DL_WAITING	0	/* waiting to rx first pkt */
+#define DL_READY	1	/* hdr was good, waiting for more of the
+				 * compressed image
+				 */
+#define DL_BAD_HDR	2	/* hdr was corrupted */
+#define DL_BAD_CRC	3	/* compressed image was corrupted */
+#define DL_RUNNABLE	4	/* download was successful,waiting for go cmd */
+#define DL_START_FAIL	5	/* failed to initialize correctly */
+#define DL_NVRAM_TOOBIG	6	/* host specified nvram data exceeds DL_NVRAM
+				 * value
+				 */
+#define DL_IMAGE_TOOBIG	7	/* firmware image too big */
+
+
+struct trx_header_le {
+	__le32 magic;		/* "HDR0" */
+	__le32 len;		/* Length of file including header */
+	__le32 crc32;		/* CRC from flag_version to end of file */
+	__le32 flag_version;	/* 0:15 flags, 16:31 version */
+	__le32 offsets[TRX_MAX_OFFSET];	/* Offsets of partitions from start of
+					 * header
+					 */
+};
+
+struct rdl_state_le {
+	__le32 state;
+	__le32 bytes;
+};
+
+struct bootrom_id_le {
+	__le32 chip;		/* Chip id */
+	__le32 chiprev;		/* Chip rev */
+	__le32 ramsize;		/* Size of  RAM */
+	__le32 remapbase;	/* Current remap base address */
+	__le32 boardtype;	/* Type of board */
+	__le32 boardrev;	/* Board revision */
+};
+
 struct brcmf_usb_image {
 	struct list_head list;
 	s8 *fwname;
@@ -788,7 +853,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 
 	brcmf_dbg(USB, "Enter, fw %p, len %d\n", fw, fwlen);
 
-	bulkchunk = kmalloc(RDL_CHUNK, GFP_ATOMIC);
+	bulkchunk = kmalloc(TRX_RDL_CHUNK, GFP_ATOMIC);
 	if (bulkchunk == NULL) {
 		err = -ENOMEM;
 		goto fail;
@@ -815,10 +880,10 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 		/* Wait until the usb device reports it received all
 		 * the bytes we sent */
 		if ((rdlbytes == sent) && (rdlbytes != dllen)) {
-			if ((dllen-sent) < RDL_CHUNK)
+			if ((dllen-sent) < TRX_RDL_CHUNK)
 				sendlen = dllen-sent;
 			else
-				sendlen = RDL_CHUNK;
+				sendlen = TRX_RDL_CHUNK;
 
 			/* simply avoid having to send a ZLP by ensuring we
 			 * never have an even
@@ -983,21 +1048,6 @@ static void brcmf_usb_detach(struct brcmf_usbdev_info *devinfo)
 	kfree(devinfo->rx_reqs);
 }
 
-#define TRX_MAGIC       0x30524448      /* "HDR0" */
-#define TRX_VERSION     1               /* Version 1 */
-#define TRX_MAX_LEN     0x3B0000        /* Max length */
-#define TRX_NO_HEADER   1               /* Do not write TRX header */
-#define TRX_MAX_OFFSET  3               /* Max number of individual files */
-#define TRX_UNCOMP_IMAGE        0x20    /* Trx contains uncompressed image */
-
-struct trx_header_le {
-	__le32 magic;		/* "HDR0" */
-	__le32 len;		/* Length of file including header */
-	__le32 crc32;		/* CRC from flag_version to end of file */
-	__le32 flag_version;	/* 0:15 flags, 16:31 version */
-	__le32 offsets[TRX_MAX_OFFSET]; /* Offsets of partitions from start of
-					 * header */
-};
 
 static int check_file(const u8 *headers)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h b/drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h
deleted file mode 100644
index 0a35c51..0000000
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Copyright (c) 2011 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _USB_RDL_H
-#define _USB_RDL_H
-
-/* Control messages: bRequest values */
-#define DL_GETSTATE	0	/* returns the rdl_state_t struct */
-#define DL_CHECK_CRC	1	/* currently unused */
-#define DL_GO		2	/* execute downloaded image */
-#define DL_START	3	/* initialize dl state */
-#define DL_REBOOT	4	/* reboot the device in 2 seconds */
-#define DL_GETVER	5	/* returns the bootrom_id_t struct */
-#define DL_GO_PROTECTED	6	/* execute the downloaded code and set reset
-				 * event to occur in 2 seconds.  It is the
-				 * responsibility of the downloaded code to
-				 * clear this event
-				 */
-#define DL_EXEC		7	/* jump to a supplied address */
-#define DL_RESETCFG	8	/* To support single enum on dongle
-				 * - Not used by bootloader
-				 */
-#define DL_DEFER_RESP_OK 9	/* Potentially defer the response to setup
-				 * if resp unavailable
-				 */
-
-/* states */
-#define DL_WAITING	0	/* waiting to rx first pkt */
-#define DL_READY	1	/* hdr was good, waiting for more of the
-				 * compressed image */
-#define DL_BAD_HDR	2	/* hdr was corrupted */
-#define DL_BAD_CRC	3	/* compressed image was corrupted */
-#define DL_RUNNABLE	4	/* download was successful,waiting for go cmd */
-#define DL_START_FAIL	5	/* failed to initialize correctly */
-#define DL_NVRAM_TOOBIG	6	/* host specified nvram data exceeds DL_NVRAM
-				 * value */
-#define DL_IMAGE_TOOBIG	7	/* download image too big (exceeds DATA_START
-				 *  for rdl) */
-
-struct rdl_state_le {
-	__le32 state;
-	__le32 bytes;
-};
-
-struct bootrom_id_le {
-	__le32 chip;	/* Chip id */
-	__le32 chiprev;	/* Chip rev */
-	__le32 ramsize;	/* Size of  RAM */
-	__le32 remapbase;	/* Current remap base address */
-	__le32 boardtype;	/* Type of board */
-	__le32 boardrev;	/* Board revision */
-};
-
-#define RDL_CHUNK	1500  /* size of each dl transfer */
-
-#define TRX_OFFSETS_DLFWLEN_IDX	0
-#define TRX_OFFSETS_JUMPTO_IDX	1
-#define TRX_OFFSETS_NVM_LEN_IDX	2
-
-#define TRX_OFFSETS_DLBASE_IDX  0
-
-#endif  /* _USB_RDL_H */
-- 
1.9.1

