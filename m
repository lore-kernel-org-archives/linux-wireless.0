Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1080 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab2KFAWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 23/24] brcmfmac: add dedicated USB log level.
Date: Mon, 5 Nov 2012 16:22:31 -0800
Message-ID: <1352161352-30405-24-git-send-email-frankyl@broadcom.com> (sfid-20121106_013118_790329_CBF3BFBE)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add USB log level and update and add log messages in usb module.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c     |   81 +++++++++++++--------
 2 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 55a4738..a0e18a1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -31,6 +31,7 @@
 #define BRCMF_EVENT_VAL	0x0400
 #define BRCMF_BTA_VAL	0x0800
 #define BRCMF_FIL_VAL	0x1000
+#define BRCMF_USB_VAL	0x2000
 
 #if defined(DEBUG)
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 484a6e4..15070b6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -170,6 +170,7 @@ static void brcmf_usb_ioctl_resp_wake(struct brcmf_usbdev_info *devinfo)
 static void
 brcmf_usb_ctl_complete(struct brcmf_usbdev_info *devinfo, int type, int status)
 {
+	brcmf_dbg(USB, "Enter, status=%d\n", status);
 
 	if (unlikely(devinfo == NULL))
 		return;
@@ -197,6 +198,7 @@ brcmf_usb_ctlread_complete(struct urb *urb)
 	struct brcmf_usbdev_info *devinfo =
 		(struct brcmf_usbdev_info *)urb->context;
 
+	brcmf_dbg(USB, "Enter\n");
 	devinfo->ctl_urb_actual_length = urb->actual_length;
 	brcmf_usb_ctl_complete(devinfo, BRCMF_USB_CBCTL_READ,
 		urb->status);
@@ -208,6 +210,7 @@ brcmf_usb_ctlwrite_complete(struct urb *urb)
 	struct brcmf_usbdev_info *devinfo =
 		(struct brcmf_usbdev_info *)urb->context;
 
+	brcmf_dbg(USB, "Enter\n");
 	brcmf_usb_ctl_complete(devinfo, BRCMF_USB_CBCTL_WRITE,
 		urb->status);
 }
@@ -223,6 +226,7 @@ brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 	int ret;
 	u16 size;
 
+	brcmf_dbg(USB, "Enter\n");
 	if (devinfo == NULL || buf == NULL ||
 	    len == 0 || devinfo->ctl_urb == NULL)
 		return -EINVAL;
@@ -262,6 +266,7 @@ brcmf_usb_recv_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 	int ret;
 	u16 size;
 
+	brcmf_dbg(USB, "Enter\n");
 	if ((devinfo == NULL) || (buf == NULL) || (len == 0)
 		|| (devinfo->ctl_urb == NULL))
 		return -EINVAL;
@@ -295,6 +300,7 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	int timeout = 0;
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
+	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
 		/* TODO: handle suspend/resume */
 		return -EIO;
@@ -325,6 +331,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	int timeout = 0;
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
+	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
 		/* TODO: handle suspend/resume */
 		return -EIO;
@@ -453,6 +460,8 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	struct brcmf_usbreq *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
 
+	brcmf_dbg(USB, "Enter, urb->status=%d, skb=%p\n", urb->status,
+		  req->skb);
 	brcmf_usb_del_fromq(devinfo, req);
 	if (urb->status == 0)
 		devinfo->bus_pub.bus->dstats.tx_packets++;
@@ -478,6 +487,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	struct sk_buff *skb;
 	int ifidx = 0;
 
+	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
 	brcmf_usb_del_fromq(devinfo, req);
 	skb = req->skb;
 	req->skb = NULL;
@@ -558,13 +568,13 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 	struct brcmf_bus *bcmf_bus = devinfo->bus_pub.bus;
 	int old_state;
 
+	brcmf_dbg(USB, "Enter, current state=%d, new state=%d\n",
+		  devinfo->bus_pub.state, state);
 
 	if (devinfo->bus_pub.state == state)
 		return;
 
 	old_state = devinfo->bus_pub.state;
-	brcmf_dbg(TRACE, "dbus state change from %d to to %d\n",
-		  old_state, state);
 
 	/* Don't update state if it's PnP firmware re-download */
 	if (state != BCMFMAC_USB_STATE_PNP_FWDL) /* TODO */
@@ -577,10 +587,10 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 
 	/* update state of upper layer */
 	if (state == BCMFMAC_USB_STATE_DOWN) {
-		brcmf_dbg(INFO, "DBUS is down\n");
+		brcmf_dbg(USB, "DBUS is down\n");
 		bcmf_bus->state = BRCMF_BUS_DOWN;
 	} else {
-		brcmf_dbg(INFO, "DBUS current state=%d\n", state);
+		brcmf_dbg(USB, "DBUS current state=%d\n", state);
 	}
 }
 
@@ -591,6 +601,8 @@ brcmf_usb_intr_complete(struct urb *urb)
 			(struct brcmf_usbdev_info *)urb->context;
 	bool killed;
 
+	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
+
 	if (devinfo == NULL)
 		return;
 
@@ -621,6 +633,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	struct brcmf_usbreq  *req;
 	int ret;
 
+	brcmf_dbg(USB, "Enter, skb=%p\n", skb);
 	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
 		/* TODO: handle suspend/resume */
 		return -EIO;
@@ -665,6 +678,7 @@ static int brcmf_usb_up(struct device *dev)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 	u16 ifnum;
 
+	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_UP)
 		return 0;
 
@@ -727,10 +741,10 @@ static void brcmf_usb_down(struct device *dev)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
+	brcmf_dbg(USB, "Enter\n");
 	if (devinfo == NULL)
 		return;
 
-	brcmf_dbg(TRACE, "enter\n");
 	if (devinfo->bus_pub.state == BCMFMAC_USB_STATE_DOWN)
 		return;
 
@@ -808,7 +822,7 @@ brcmf_usb_dlneeded(struct brcmf_usbdev_info *devinfo)
 	struct bootrom_id_le id;
 	u32 chipid, chiprev;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 
 	if (devinfo == NULL)
 		return false;
@@ -822,11 +836,11 @@ brcmf_usb_dlneeded(struct brcmf_usbdev_info *devinfo)
 	chiprev = le32_to_cpu(id.chiprev);
 
 	if ((chipid & 0x4300) == 0x4300)
-		brcmf_dbg(INFO, "chip %x rev 0x%x\n", chipid, chiprev);
+		brcmf_dbg(USB, "chip %x rev 0x%x\n", chipid, chiprev);
 	else
-		brcmf_dbg(INFO, "chip %d rev 0x%x\n", chipid, chiprev);
+		brcmf_dbg(USB, "chip %d rev 0x%x\n", chipid, chiprev);
 	if (chipid == BRCMF_POSTBOOT_ID) {
-		brcmf_dbg(INFO, "firmware already downloaded\n");
+		brcmf_dbg(USB, "firmware already downloaded\n");
 		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id,
 			sizeof(struct bootrom_id_le));
 		return false;
@@ -843,7 +857,7 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 	struct bootrom_id_le id;
 	u16 wait = 0, wait_time;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 
 	if (devinfo == NULL)
 		return -EINVAL;
@@ -861,7 +875,7 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 	}
 
 	if (id.chip == cpu_to_le32(BRCMF_POSTBOOT_ID)) {
-		brcmf_dbg(INFO, "download done %d ms postboot chip 0x%x/rev 0x%x\n",
+		brcmf_dbg(USB, "download done %d ms postboot chip 0x%x/rev 0x%x\n",
 			  wait, le32_to_cpu(id.chip), le32_to_cpu(id.chiprev));
 
 		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id,
@@ -911,7 +925,8 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 	struct rdl_state_le state;
 	u32 rdlstate, rdlbytes;
 	int err = 0;
-	brcmf_dbg(TRACE, "fw %p, len %d\n", fw, fwlen);
+
+	brcmf_dbg(USB, "Enter, fw %p, len %d\n", fw, fwlen);
 
 	bulkchunk = kmalloc(RDL_CHUNK, GFP_ATOMIC);
 	if (bulkchunk == NULL) {
@@ -986,7 +1001,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 
 fail:
 	kfree(bulkchunk);
-	brcmf_dbg(TRACE, "err=%d\n", err);
+	brcmf_dbg(USB, "Exit, err=%d\n", err);
 	return err;
 }
 
@@ -994,7 +1009,7 @@ static int brcmf_usb_dlstart(struct brcmf_usbdev_info *devinfo, u8 *fw, int len)
 {
 	int err;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 
 	if (devinfo == NULL)
 		return -EINVAL;
@@ -1007,7 +1022,7 @@ static int brcmf_usb_dlstart(struct brcmf_usbdev_info *devinfo, u8 *fw, int len)
 		devinfo->bus_pub.state = BCMFMAC_USB_STATE_DL_DONE;
 	else
 		devinfo->bus_pub.state = BCMFMAC_USB_STATE_DL_PENDING;
-	brcmf_dbg(TRACE, "exit: err=%d\n", err);
+	brcmf_dbg(USB, "Exit, err=%d\n", err);
 
 	return err;
 }
@@ -1016,7 +1031,7 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 {
 	struct rdl_state_le state;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 	if (!devinfo)
 		return -EINVAL;
 
@@ -1039,7 +1054,7 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 		brcmf_dbg(ERROR, "Dongle not runnable\n");
 		return -EINVAL;
 	}
-	brcmf_dbg(TRACE, "exit\n");
+	brcmf_dbg(USB, "Exit\n");
 	return 0;
 }
 
@@ -1066,7 +1081,7 @@ brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 	int devid, chiprev;
 	int err;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 	if (devinfo == NULL)
 		return -ENODEV;
 
@@ -1094,7 +1109,7 @@ brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 
 static void brcmf_usb_detach(struct brcmf_usbdev_info *devinfo)
 {
-	brcmf_dbg(TRACE, "devinfo %p\n", devinfo);
+	brcmf_dbg(USB, "Enter, devinfo %p\n", devinfo);
 
 	/* free the URBS */
 	brcmf_usb_free_q(&devinfo->rx_freeq, false);
@@ -1129,6 +1144,7 @@ static int check_file(const u8 *headers)
 	struct trx_header_le *trx;
 	int actual_len = -1;
 
+	brcmf_dbg(USB, "Enter\n");
 	/* Extract trx header */
 	trx = (struct trx_header_le *) headers;
 	if (trx->magic != cpu_to_le32(TRX_MAGIC))
@@ -1150,6 +1166,7 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 	struct brcmf_usb_image *fw_image;
 	int err;
 
+	brcmf_dbg(USB, "Enter\n");
 	switch (devinfo->bus_pub.devid) {
 	case 43143:
 		fwname = BRCMF_USB_43143_FW_NAME;
@@ -1166,7 +1183,7 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 		return -EINVAL;
 		break;
 	}
-
+	brcmf_dbg(USB, "Loading FW %s\n", fwname);
 	list_for_each_entry(fw_image, &fw_image_list, list) {
 		if (fw_image->fwname == fwname) {
 			devinfo->image = fw_image->image;
@@ -1211,6 +1228,8 @@ static
 struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 				      int nrxq, int ntxq)
 {
+	brcmf_dbg(USB, "Enter\n");
+
 	devinfo->bus_pub.nrxq = nrxq;
 	devinfo->rx_low_watermark = nrxq / 2;
 	devinfo->bus_pub.devinfo = devinfo;
@@ -1263,7 +1282,7 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 	if (!brcmf_usb_dlneeded(devinfo))
 		return &devinfo->bus_pub;
 
-	brcmf_dbg(TRACE, "start fw downloading\n");
+	brcmf_dbg(USB, "Start fw downloading\n");
 	if (brcmf_usb_get_fw(devinfo))
 		goto error;
 
@@ -1286,6 +1305,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
 	int ret;
 	struct device *dev = devinfo->dev;
 
+	brcmf_dbg(USB, "Enter\n");
 	bus_pub = brcmf_usb_attach(devinfo, BRCMF_USB_NRXQ, BRCMF_USB_NTXQ);
 	if (!bus_pub)
 		return -ENODEV;
@@ -1309,7 +1329,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(hdrlen, dev);
 	if (ret) {
-		brcmf_dbg(ERROR, "dhd_attach failed\n");
+		brcmf_dbg(ERROR, "brcmf_attach failed\n");
 		goto fail;
 	}
 
@@ -1333,7 +1353,7 @@ brcmf_usb_disconnect_cb(struct brcmf_usbdev_info *devinfo)
 {
 	if (!devinfo)
 		return;
-	brcmf_dbg(TRACE, "enter: bus_pub %p\n", devinfo);
+	brcmf_dbg(USB, "Enter, bus_pub %p\n", devinfo);
 
 	brcmf_detach(devinfo->dev);
 	kfree(devinfo->bus_pub.bus);
@@ -1351,7 +1371,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	u8 endpoint_num;
 	struct brcmf_usbdev_info *devinfo;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 
 	devinfo = kzalloc(sizeof(*devinfo), GFP_ATOMIC);
 	if (devinfo == NULL)
@@ -1452,9 +1472,9 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	devinfo->interval = IFEPDESC(usb, CONTROL_IF, 0).bInterval;
 
 	if (usb->speed == USB_SPEED_HIGH)
-		brcmf_dbg(INFO, "Broadcom high speed USB wireless device detected\n");
+		brcmf_dbg(USB, "Broadcom high speed USB wireless device detected\n");
 	else
-		brcmf_dbg(INFO, "Broadcom full speed USB wireless device detected\n");
+		brcmf_dbg(USB, "Broadcom full speed USB wireless device detected\n");
 
 	ret = brcmf_usb_probe_cb(devinfo, "", USB_BUS, 0);
 	if (ret)
@@ -1476,10 +1496,11 @@ brcmf_usb_disconnect(struct usb_interface *intf)
 {
 	struct brcmf_usbdev_info *devinfo;
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 	devinfo = (struct brcmf_usbdev_info *)usb_get_intfdata(intf);
 	brcmf_usb_disconnect_cb(devinfo);
 	kfree(devinfo);
+	brcmf_dbg(USB, "Exit\n");
 }
 
 /*
@@ -1490,7 +1511,7 @@ static int brcmf_usb_suspend(struct usb_interface *intf, pm_message_t state)
 	struct usb_device *usb = interface_to_usbdev(intf);
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 	devinfo->bus_pub.state = BCMFMAC_USB_STATE_DOWN;
 	devinfo->suspend_state = USBOS_SUSPEND_STATE_SUSPENDED;
 	return 0;
@@ -1504,7 +1525,7 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 	struct usb_device *usb = interface_to_usbdev(intf);
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
-	brcmf_dbg(TRACE, "enter\n");
+	brcmf_dbg(USB, "Enter\n");
 	devinfo->suspend_state = USBOS_SUSPEND_STATE_DEVICE_ACTIVE;
 	brcmf_bus_start(&usb->dev);
 	return 0;
@@ -1554,12 +1575,14 @@ static void brcmf_release_fw(struct list_head *q)
 
 void brcmf_usb_exit(void)
 {
+	brcmf_dbg(USB, "Enter\n");
 	usb_deregister(&brcmf_usbdrvr);
 	brcmf_release_fw(&fw_image_list);
 }
 
 void brcmf_usb_init(void)
 {
+	brcmf_dbg(USB, "Enter\n");
 	INIT_LIST_HEAD(&fw_image_list);
 	usb_register(&brcmf_usbdrvr);
 }
-- 
1.7.9.5


