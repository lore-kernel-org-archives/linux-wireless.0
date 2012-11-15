Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3380 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302Ab2KOCrF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:47:05 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 02/19] brcmfmac: cleanup of usb firmware download
 routines
Date: Wed, 14 Nov 2012 18:46:06 -0800
Message-ID: <1352947583-25341-3-git-send-email-frankyl@broadcom.com> (sfid-20121115_041528_384329_BE2D1EC4)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Clean code related to firmware download routines. Remove obsolete
delay and increase delay after reset command.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   43 +++++++++----------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 15070b6..395c49d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -42,13 +42,11 @@
 
 #define IOCTL_RESP_TIMEOUT  2000
 
-#define BRCMF_USB_DLIMAGE_SPINWAIT	100	/* in unit of ms */
-#define BRCMF_USB_DLIMAGE_LIMIT		500	/* spinwait limit (ms) */
+#define BRCMF_USB_RESET_GETVER_SPINWAIT	100	/* in unit of ms */
+#define BRCMF_USB_RESET_GETVER_LOOP_CNT	10
 
 #define BRCMF_POSTBOOT_ID		0xA123  /* ID to detect if dongle
 						   has boot up */
-#define BRCMF_USB_RESETCFG_SPINWAIT	1	/* wait after resetcfg (ms) */
-
 #define BRCMF_USB_NRXQ	50
 #define BRCMF_USB_NTXQ	50
 
@@ -829,8 +827,7 @@ brcmf_usb_dlneeded(struct brcmf_usbdev_info *devinfo)
 
 	/* Check if firmware downloaded already by querying runtime ID */
 	id.chip = cpu_to_le32(0xDEAD);
-	brcmf_usb_dl_cmd(devinfo, DL_GETVER, &id,
-		sizeof(struct bootrom_id_le));
+	brcmf_usb_dl_cmd(devinfo, DL_GETVER, &id, sizeof(id));
 
 	chipid = le32_to_cpu(id.chip);
 	chiprev = le32_to_cpu(id.chiprev);
@@ -841,8 +838,7 @@ brcmf_usb_dlneeded(struct brcmf_usbdev_info *devinfo)
 		brcmf_dbg(USB, "chip %d rev 0x%x\n", chipid, chiprev);
 	if (chipid == BRCMF_POSTBOOT_ID) {
 		brcmf_dbg(USB, "firmware already downloaded\n");
-		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id,
-			sizeof(struct bootrom_id_le));
+		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id, sizeof(id));
 		return false;
 	} else {
 		devinfo->bus_pub.devid = chipid;
@@ -855,38 +851,29 @@ static int
 brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 {
 	struct bootrom_id_le id;
-	u16 wait = 0, wait_time;
+	u32 loop_cnt;
 
 	brcmf_dbg(USB, "Enter\n");
 
-	if (devinfo == NULL)
-		return -EINVAL;
-
-	/* Give dongle chance to boot */
-	wait_time = BRCMF_USB_DLIMAGE_SPINWAIT;
-	while (wait < BRCMF_USB_DLIMAGE_LIMIT) {
-		mdelay(wait_time);
-		wait += wait_time;
+	loop_cnt = 0;
+	do {
+		mdelay(BRCMF_USB_RESET_GETVER_SPINWAIT);
+		loop_cnt++;
 		id.chip = cpu_to_le32(0xDEAD);       /* Get the ID */
-		brcmf_usb_dl_cmd(devinfo, DL_GETVER, &id,
-			sizeof(struct bootrom_id_le));
+		brcmf_usb_dl_cmd(devinfo, DL_GETVER, &id, sizeof(id));
 		if (id.chip == cpu_to_le32(BRCMF_POSTBOOT_ID))
 			break;
-	}
+	} while (loop_cnt < BRCMF_USB_RESET_GETVER_LOOP_CNT);
 
 	if (id.chip == cpu_to_le32(BRCMF_POSTBOOT_ID)) {
-		brcmf_dbg(USB, "download done %d ms postboot chip 0x%x/rev 0x%x\n",
-			  wait, le32_to_cpu(id.chip), le32_to_cpu(id.chiprev));
-
-		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id,
-			sizeof(struct bootrom_id_le));
+		brcmf_dbg(USB, "postboot chip 0x%x/rev 0x%x\n",
+			  le32_to_cpu(id.chip), le32_to_cpu(id.chiprev));
 
-		/* XXX this wait may not be necessary */
-		mdelay(BRCMF_USB_RESETCFG_SPINWAIT);
+		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id, sizeof(id));
 		return 0;
 	} else {
 		brcmf_dbg(ERROR, "Cannot talk to Dongle. Firmware is not UP, %d ms\n",
-			  wait);
+			  BRCMF_USB_RESET_GETVER_SPINWAIT * loop_cnt);
 		return -EINVAL;
 	}
 }
-- 
1.7.9.5


