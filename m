Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4373 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2CBV4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:13 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/7] brcm80211: fmac: remove brcmf_usb_attrib structure
Date: Fri, 2 Mar 2012 22:55:46 +0100
Message-ID: <1330725351-3803-3-git-send-email-arend@broadcom.com> (sfid-20120302_225622_789801_617095AF)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several fields in this structure are only written once or not used
at all. Remaining two fields have been moved and brcmf_usb_attrib
definition has been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Kan Yan <kanyan@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   17 +++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/usb.h |   16 ++--------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 8616961..0418a40 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -897,8 +897,8 @@ brcmf_usb_dlneeded(struct brcmf_usbdev_info *devinfo)
 			sizeof(struct bootrom_id_le));
 		return false;
 	} else {
-		devinfo->bus_pub.attrib.devid = chipid;
-		devinfo->bus_pub.attrib.chiprev = chiprev;
+		devinfo->bus_pub.devid = chipid;
+		devinfo->bus_pub.chiprev = chiprev;
 	}
 	return true;
 }
@@ -1064,7 +1064,7 @@ static int brcmf_usb_dlstart(struct brcmf_usbdev_info *devinfo, u8 *fw, int len)
 	if (devinfo == NULL)
 		return -EINVAL;
 
-	if (devinfo->bus_pub.attrib.devid == 0xDEAD)
+	if (devinfo->bus_pub.devid == 0xDEAD)
 		return -EINVAL;
 
 	err = brcmf_usb_dl_writeimage(devinfo, fw, len);
@@ -1085,7 +1085,7 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 	if (!devinfo)
 		return -EINVAL;
 
-	if (devinfo->bus_pub.attrib.devid == 0xDEAD)
+	if (devinfo->bus_pub.devid == 0xDEAD)
 		return -EINVAL;
 
 	/* Check we are runnable */
@@ -1124,18 +1124,19 @@ static bool brcmf_usb_chip_support(int chipid, int chiprev)
 static int
 brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 {
-	struct brcmf_usb_attrib *attr;
+	int devid, chiprev;
 	int err;
 
 	brcmf_dbg(TRACE, "enter\n");
 	if (devinfo == NULL)
 		return -ENODEV;
 
-	attr = &devinfo->bus_pub.attrib;
+	devid = devinfo->bus_pub.devid;
+	chiprev = devinfo->bus_pub.chiprev;
 
-	if (!brcmf_usb_chip_support(attr->devid, attr->chiprev)) {
+	if (!brcmf_usb_chip_support(devid, chiprev)) {
 		brcmf_dbg(ERROR, "unsupported chip %d rev %d\n",
-			  attr->devid, attr->chiprev);
+			  devid, chiprev);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.h b/drivers/net/wireless/brcm80211/brcmfmac/usb.h
index b31da7b..3377d63 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.h
@@ -50,19 +50,6 @@ struct brcmf_stats {
 
 };
 
-struct brcmf_usb_attrib {
-	int bustype;
-	int vid;
-	int pid;
-	int devid;
-	int chiprev; /* chip revsion number */
-	int mtu;
-	int nchan; /* Data Channels */
-	int has_2nd_bulk_in_ep;
-};
-
-struct brcmf_usbdev_info;
-
 struct brcmf_usbdev {
 	struct brcmf_bus *bus;
 	struct brcmf_usbdev_info *devinfo;
@@ -70,7 +57,8 @@ struct brcmf_usbdev {
 	struct brcmf_stats stats;
 	int ntxq, nrxq, rxsize;
 	u32 bus_mtu;
-	struct brcmf_usb_attrib attrib;
+	int devid;
+	int chiprev; /* chip revsion number */
 };
 
 /* IO Request Block (IRB) */
-- 
1.7.5.4


