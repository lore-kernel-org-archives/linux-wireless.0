Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40572 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2AEOqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 09:46:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath6kl: revert USB support
Date: Thu,  5 Jan 2012 09:45:38 -0500
Message-Id: <1325774738-12588-1-git-send-email-linville@tuxdriver.com> (sfid-20120105_154700_077974_27721E7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl is causing build failures when the ath6kl bits are not built
as modules.  A better fix is forthcoming in a future release, but for
now lets revert the problematic code.

This reverts the following commits:

	fde57764ef8751b9aca11b6f6221ac5555bda699.
	d70385a26ad9a122a5450d066550470107b6bc38.
	59d954dda4b9b3f3e61d4b87a2b26952b8c4c09d.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
These bits can come back in combination with the build fixes Kalle has
been creating.  I'll leave it to Kalle to keep track of reinstating
these bits...

 drivers/net/wireless/ath/ath6kl/Kconfig  |   25 +--
 drivers/net/wireless/ath/ath6kl/Makefile |   37 +--
 drivers/net/wireless/ath/ath6kl/bmi.c    |   10 +-
 drivers/net/wireless/ath/ath6kl/debug.h  |    1 -
 drivers/net/wireless/ath/ath6kl/hif.c    |    5 -
 drivers/net/wireless/ath/ath6kl/htc.c    |   10 +-
 drivers/net/wireless/ath/ath6kl/sdio.c   |    2 +-
 drivers/net/wireless/ath/ath6kl/usb.c    |  431 ------------------------------
 8 files changed, 20 insertions(+), 501 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/usb.c

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index d755a5e..3d5f8be 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -1,29 +1,12 @@
 config ATH6KL
-	tristate "Atheros mobile chipsets support"
-
-config ATH6KL_SDIO
-	tristate "Atheros ath6kl SDIO support"
-	depends on ATH6KL
+	tristate "Atheros ath6kl support"
 	depends on MMC
 	depends on CFG80211
 	---help---
 	  This module adds support for wireless adapters based on
-	  Atheros AR6003 and AR6004 chipsets running over SDIO. If you
-	  choose to build it as a module, it will be called ath6kl_sdio.
-	  Please note that AR6002 and AR6001 are not supported by this
-	  driver.
-
-config ATH6KL_USB
-	tristate "Atheros ath6kl USB support"
-	depends on ATH6KL
-	depends on USB
-	depends on CFG80211
-	depends on EXPERIMENTAL
-	---help---
-	  This module adds support for wireless adapters based on
-	  Atheros AR6004 chipset running over USB. This is still under
-	  implementation and it isn't functional. If you choose to
-	  build it as a module, it will be called ath6kl_usb.
+	  Atheros AR6003 chipset running over SDIO. If you choose to
+	  build it as a module, it will be called ath6kl. Pls note
+	  that AR6002 and AR6001 are not supported by this driver.
 
 config ATH6KL_DEBUG
 	bool "Atheros ath6kl debugging"
diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index e14cef9..7070693 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -21,30 +21,17 @@
 # Author(s): ="Atheros"
 #------------------------------------------------------------------------------
 
-obj-$(CONFIG_ATH6KL_SDIO) := ath6kl_sdio.o
-ath6kl_sdio-y += debug.o
-ath6kl_sdio-y += hif.o
-ath6kl_sdio-y += htc.o
-ath6kl_sdio-y += bmi.o
-ath6kl_sdio-y += cfg80211.o
-ath6kl_sdio-y += init.o
-ath6kl_sdio-y += main.o
-ath6kl_sdio-y += txrx.o
-ath6kl_sdio-y += wmi.o
-ath6kl_sdio-y += sdio.o
-ath6kl_sdio-$(CONFIG_NL80211_TESTMODE) += testmode.o
-
-obj-$(CONFIG_ATH6KL_USB) += ath6kl_usb.o
-ath6kl_usb-y += debug.o
-ath6kl_usb-y += hif.o
-ath6kl_usb-y += htc.o
-ath6kl_usb-y += bmi.o
-ath6kl_usb-y += cfg80211.o
-ath6kl_usb-y += init.o
-ath6kl_usb-y += main.o
-ath6kl_usb-y += txrx.o
-ath6kl_usb-y += wmi.o
-ath6kl_usb-y += usb.o
-ath6kl_usb-$(CONFIG_NL80211_TESTMODE) += testmode.o
+obj-$(CONFIG_ATH6KL) := ath6kl.o
+ath6kl-y += debug.o
+ath6kl-y += hif.o
+ath6kl-y += htc.o
+ath6kl-y += bmi.o
+ath6kl-y += cfg80211.o
+ath6kl-y += init.o
+ath6kl-y += main.o
+ath6kl-y += txrx.o
+ath6kl-y += wmi.o
+ath6kl-y += sdio.o
+ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index aef00d5..bce3575 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -57,14 +57,8 @@ int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 		return ret;
 	}
 
-	if (ar->hif_type == ATH6KL_HIF_TYPE_USB) {
-		ret = ath6kl_hif_bmi_read(ar, (u8 *)targ_info,
-					  sizeof(*targ_info));
-	} else {
-		ret = ath6kl_hif_bmi_read(ar, (u8 *)&targ_info->version,
-				sizeof(targ_info->version));
-	}
-
+	ret = ath6kl_hif_bmi_read(ar, (u8 *)&targ_info->version,
+				  sizeof(targ_info->version));
 	if (ret) {
 		ath6kl_err("Unable to recv target info: %d\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index e569c65..9853c9c 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -41,7 +41,6 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_BOOT		= BIT(18),    /* driver init and fw boot */
 	ATH6KL_DBG_WMI_DUMP	= BIT(19),
 	ATH6KL_DBG_SUSPEND	= BIT(20),
-	ATH6KL_DBG_USB		= BIT(21),
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 0772ef6..e57da35 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -689,11 +689,6 @@ int ath6kl_hif_setup(struct ath6kl_device *dev)
 	ath6kl_dbg(ATH6KL_DBG_HIF, "hif block size %d mbox addr 0x%x\n",
 		   dev->htc_cnxt->block_sz, dev->ar->mbox_info.htc_addr);
 
-	/* usb doesn't support enabling interrupts */
-	/* FIXME: remove check once USB support is implemented */
-	if (dev->ar->hif_type == ATH6KL_HIF_TYPE_USB)
-		return 0;
-
 	status = ath6kl_hif_disable_intrs(dev);
 
 fail_setup:
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index b017022..f3b63ca 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2543,12 +2543,6 @@ int ath6kl_htc_wait_target(struct htc_target *target)
 	struct htc_service_connect_resp resp;
 	int status;
 
-	/* FIXME: remove once USB support is implemented */
-	if (target->dev->ar->hif_type == ATH6KL_HIF_TYPE_USB) {
-		ath6kl_err("HTC doesn't support USB yet. Patience!\n");
-		return -EOPNOTSUPP;
-	}
-
 	/* we should be getting 1 control message that the target is ready */
 	packet = htc_wait_for_ctrl_msg(target);
 
@@ -2778,9 +2772,7 @@ void ath6kl_htc_cleanup(struct htc_target *target)
 {
 	struct htc_packet *packet, *tmp_packet;
 
-	/* FIXME: remove check once USB support is implemented */
-	if (target->dev->ar->hif_type != ATH6KL_HIF_TYPE_USB)
-		ath6kl_hif_cleanup_scatter(target->dev->ar);
+	ath6kl_hif_cleanup_scatter(target->dev->ar);
 
 	list_for_each_entry_safe(packet, tmp_packet,
 			&target->free_ctrl_txbuf, list) {
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 15c3f56..9475e2d 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1332,7 +1332,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
 MODULE_DEVICE_TABLE(sdio, ath6kl_sdio_devices);
 
 static struct sdio_driver ath6kl_sdio_driver = {
-	.name = "ath6kl_sdio",
+	.name = "ath6kl",
 	.id_table = ath6kl_sdio_devices,
 	.probe = ath6kl_sdio_probe,
 	.remove = ath6kl_sdio_remove,
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
deleted file mode 100644
index e3cf397..0000000
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ /dev/null
@@ -1,431 +0,0 @@
-/*
- * Copyright (c) 2007-2011 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/module.h>
-#include <linux/usb.h>
-
-#include "debug.h"
-#include "core.h"
-
-/* usb device object */
-struct ath6kl_usb {
-	struct usb_device *udev;
-	struct usb_interface *interface;
-	u8 *diag_cmd_buffer;
-	u8 *diag_resp_buffer;
-	struct ath6kl *ar;
-};
-
-/* diagnostic command defnitions */
-#define ATH6KL_USB_CONTROL_REQ_SEND_BMI_CMD        1
-#define ATH6KL_USB_CONTROL_REQ_RECV_BMI_RESP       2
-#define ATH6KL_USB_CONTROL_REQ_DIAG_CMD            3
-#define ATH6KL_USB_CONTROL_REQ_DIAG_RESP           4
-
-#define ATH6KL_USB_CTRL_DIAG_CC_READ               0
-#define ATH6KL_USB_CTRL_DIAG_CC_WRITE              1
-
-struct ath6kl_usb_ctrl_diag_cmd_write {
-	__le32 cmd;
-	__le32 address;
-	__le32 value;
-	__le32 _pad[1];
-} __packed;
-
-struct ath6kl_usb_ctrl_diag_cmd_read {
-	__le32 cmd;
-	__le32 address;
-} __packed;
-
-struct ath6kl_usb_ctrl_diag_resp_read {
-	__le32 value;
-} __packed;
-
-#define ATH6KL_USB_MAX_DIAG_CMD (sizeof(struct ath6kl_usb_ctrl_diag_cmd_write))
-#define ATH6KL_USB_MAX_DIAG_RESP (sizeof(struct ath6kl_usb_ctrl_diag_resp_read))
-
-static void ath6kl_usb_destroy(struct ath6kl_usb *ar_usb)
-{
-	usb_set_intfdata(ar_usb->interface, NULL);
-
-	kfree(ar_usb->diag_cmd_buffer);
-	kfree(ar_usb->diag_resp_buffer);
-
-	kfree(ar_usb);
-}
-
-static struct ath6kl_usb *ath6kl_usb_create(struct usb_interface *interface)
-{
-	struct ath6kl_usb *ar_usb = NULL;
-	struct usb_device *dev = interface_to_usbdev(interface);
-	int status = 0;
-
-	ar_usb = kzalloc(sizeof(struct ath6kl_usb), GFP_KERNEL);
-	if (ar_usb == NULL)
-		goto fail_ath6kl_usb_create;
-
-	memset(ar_usb, 0, sizeof(struct ath6kl_usb));
-	usb_set_intfdata(interface, ar_usb);
-	ar_usb->udev = dev;
-	ar_usb->interface = interface;
-
-	ar_usb->diag_cmd_buffer = kzalloc(ATH6KL_USB_MAX_DIAG_CMD, GFP_KERNEL);
-	if (ar_usb->diag_cmd_buffer == NULL) {
-		status = -ENOMEM;
-		goto fail_ath6kl_usb_create;
-	}
-
-	ar_usb->diag_resp_buffer = kzalloc(ATH6KL_USB_MAX_DIAG_RESP,
-					   GFP_KERNEL);
-	if (ar_usb->diag_resp_buffer == NULL) {
-		status = -ENOMEM;
-		goto fail_ath6kl_usb_create;
-	}
-
-fail_ath6kl_usb_create:
-	if (status != 0) {
-		ath6kl_usb_destroy(ar_usb);
-		ar_usb = NULL;
-	}
-	return ar_usb;
-}
-
-static void ath6kl_usb_device_detached(struct usb_interface *interface)
-{
-	struct ath6kl_usb *ar_usb;
-
-	ar_usb = usb_get_intfdata(interface);
-	if (ar_usb == NULL)
-		return;
-
-	ath6kl_stop_txrx(ar_usb->ar);
-
-	ath6kl_core_cleanup(ar_usb->ar);
-
-	ath6kl_usb_destroy(ar_usb);
-}
-
-static int ath6kl_usb_submit_ctrl_out(struct ath6kl_usb *ar_usb,
-				   u8 req, u16 value, u16 index, void *data,
-				   u32 size)
-{
-	u8 *buf = NULL;
-	int ret;
-
-	if (size > 0) {
-		buf = kmalloc(size, GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
-
-		memcpy(buf, data, size);
-	}
-
-	/* note: if successful returns number of bytes transfered */
-	ret = usb_control_msg(ar_usb->udev,
-			      usb_sndctrlpipe(ar_usb->udev, 0),
-			      req,
-			      USB_DIR_OUT | USB_TYPE_VENDOR |
-			      USB_RECIP_DEVICE, value, index, buf,
-			      size, 1000);
-
-	if (ret < 0) {
-		ath6kl_dbg(ATH6KL_DBG_USB, "%s failed,result = %d\n",
-			   __func__, ret);
-	}
-
-	kfree(buf);
-
-	return 0;
-}
-
-static int ath6kl_usb_submit_ctrl_in(struct ath6kl_usb *ar_usb,
-				  u8 req, u16 value, u16 index, void *data,
-				  u32 size)
-{
-	u8 *buf = NULL;
-	int ret;
-
-	if (size > 0) {
-		buf = kmalloc(size, GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
-	}
-
-	/* note: if successful returns number of bytes transfered */
-	ret = usb_control_msg(ar_usb->udev,
-				 usb_rcvctrlpipe(ar_usb->udev, 0),
-				 req,
-				 USB_DIR_IN | USB_TYPE_VENDOR |
-				 USB_RECIP_DEVICE, value, index, buf,
-				 size, 2 * HZ);
-
-	if (ret < 0) {
-		ath6kl_dbg(ATH6KL_DBG_USB, "%s failed,result = %d\n",
-			   __func__, ret);
-	}
-
-	memcpy((u8 *) data, buf, size);
-
-	kfree(buf);
-
-	return 0;
-}
-
-static int ath6kl_usb_ctrl_msg_exchange(struct ath6kl_usb *ar_usb,
-				     u8 req_val, u8 *req_buf, u32 req_len,
-				     u8 resp_val, u8 *resp_buf, u32 *resp_len)
-{
-	int ret;
-
-	/* send command */
-	ret = ath6kl_usb_submit_ctrl_out(ar_usb, req_val, 0, 0,
-					 req_buf, req_len);
-
-	if (ret != 0)
-		return ret;
-
-	if (resp_buf == NULL) {
-		/* no expected response */
-		return ret;
-	}
-
-	/* get response */
-	ret = ath6kl_usb_submit_ctrl_in(ar_usb, resp_val, 0, 0,
-					resp_buf, *resp_len);
-
-	return ret;
-}
-
-static int ath6kl_usb_diag_read32(struct ath6kl *ar, u32 address, u32 *data)
-{
-	struct ath6kl_usb *ar_usb = ar->hif_priv;
-	struct ath6kl_usb_ctrl_diag_resp_read *resp;
-	struct ath6kl_usb_ctrl_diag_cmd_read *cmd;
-	u32 resp_len;
-	int ret;
-
-	cmd = (struct ath6kl_usb_ctrl_diag_cmd_read *) ar_usb->diag_cmd_buffer;
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->cmd = ATH6KL_USB_CTRL_DIAG_CC_READ;
-	cmd->address = cpu_to_le32(address);
-	resp_len = sizeof(*resp);
-
-	ret = ath6kl_usb_ctrl_msg_exchange(ar_usb,
-				ATH6KL_USB_CONTROL_REQ_DIAG_CMD,
-				(u8 *) cmd,
-				sizeof(struct ath6kl_usb_ctrl_diag_cmd_write),
-				ATH6KL_USB_CONTROL_REQ_DIAG_RESP,
-				ar_usb->diag_resp_buffer, &resp_len);
-
-	if (ret)
-		return ret;
-
-	resp = (struct ath6kl_usb_ctrl_diag_resp_read *)
-		ar_usb->diag_resp_buffer;
-
-	*data = le32_to_cpu(resp->value);
-
-	return ret;
-}
-
-static int ath6kl_usb_diag_write32(struct ath6kl *ar, u32 address, __le32 data)
-{
-	struct ath6kl_usb *ar_usb = ar->hif_priv;
-	struct ath6kl_usb_ctrl_diag_cmd_write *cmd;
-
-	cmd = (struct ath6kl_usb_ctrl_diag_cmd_write *) ar_usb->diag_cmd_buffer;
-
-	memset(cmd, 0, sizeof(struct ath6kl_usb_ctrl_diag_cmd_write));
-	cmd->cmd = cpu_to_le32(ATH6KL_USB_CTRL_DIAG_CC_WRITE);
-	cmd->address = cpu_to_le32(address);
-	cmd->value = data;
-
-	return ath6kl_usb_ctrl_msg_exchange(ar_usb,
-					    ATH6KL_USB_CONTROL_REQ_DIAG_CMD,
-					    (u8 *) cmd,
-					    sizeof(*cmd),
-					    0, NULL, NULL);
-
-}
-
-static int ath6kl_usb_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
-{
-	struct ath6kl_usb *ar_usb = ar->hif_priv;
-	int ret;
-
-	/* get response */
-	ret = ath6kl_usb_submit_ctrl_in(ar_usb,
-					ATH6KL_USB_CONTROL_REQ_RECV_BMI_RESP,
-					0, 0, buf, len);
-	if (ret != 0) {
-		ath6kl_err("Unable to read the bmi data from the device: %d\n",
-			   ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int ath6kl_usb_bmi_write(struct ath6kl *ar, u8 *buf, u32 len)
-{
-	struct ath6kl_usb *ar_usb = ar->hif_priv;
-	int ret;
-
-	/* send command */
-	ret = ath6kl_usb_submit_ctrl_out(ar_usb,
-					 ATH6KL_USB_CONTROL_REQ_SEND_BMI_CMD,
-					 0, 0, buf, len);
-	if (ret != 0) {
-		ath6kl_err("unable to send the bmi data to the device: %d\n",
-			   ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int ath6kl_usb_power_on(struct ath6kl *ar)
-{
-	return 0;
-}
-
-static int ath6kl_usb_power_off(struct ath6kl *ar)
-{
-	return 0;
-}
-
-static const struct ath6kl_hif_ops ath6kl_usb_ops = {
-	.diag_read32 = ath6kl_usb_diag_read32,
-	.diag_write32 = ath6kl_usb_diag_write32,
-	.bmi_read = ath6kl_usb_bmi_read,
-	.bmi_write = ath6kl_usb_bmi_write,
-	.power_on = ath6kl_usb_power_on,
-	.power_off = ath6kl_usb_power_off,
-};
-
-/* ath6kl usb driver registered functions */
-static int ath6kl_usb_probe(struct usb_interface *interface,
-			    const struct usb_device_id *id)
-{
-	struct usb_device *dev = interface_to_usbdev(interface);
-	struct ath6kl *ar;
-	struct ath6kl_usb *ar_usb = NULL;
-	int vendor_id, product_id;
-	int ret = 0;
-
-	usb_get_dev(dev);
-
-	vendor_id = le16_to_cpu(dev->descriptor.idVendor);
-	product_id = le16_to_cpu(dev->descriptor.idProduct);
-
-	ath6kl_dbg(ATH6KL_DBG_USB, "vendor_id = %04x\n", vendor_id);
-	ath6kl_dbg(ATH6KL_DBG_USB, "product_id = %04x\n", product_id);
-
-	if (interface->cur_altsetting)
-		ath6kl_dbg(ATH6KL_DBG_USB, "USB Interface %d\n",
-			   interface->cur_altsetting->desc.bInterfaceNumber);
-
-
-	if (dev->speed == USB_SPEED_HIGH)
-		ath6kl_dbg(ATH6KL_DBG_USB, "USB 2.0 Host\n");
-	else
-		ath6kl_dbg(ATH6KL_DBG_USB, "USB 1.1 Host\n");
-
-	ar_usb = ath6kl_usb_create(interface);
-
-	if (ar_usb == NULL) {
-		ret = -ENOMEM;
-		goto err_usb_put;
-	}
-
-	ar = ath6kl_core_alloc(&ar_usb->udev->dev);
-	if (ar == NULL) {
-		ath6kl_err("Failed to alloc ath6kl core\n");
-		ret = -ENOMEM;
-		goto err_usb_destroy;
-	}
-
-	ar->hif_priv = ar_usb;
-	ar->hif_type = ATH6KL_HIF_TYPE_USB;
-	ar->hif_ops = &ath6kl_usb_ops;
-	ar->mbox_info.block_size = 16;
-	ar->bmi.max_data_size = 252;
-
-	ar_usb->ar = ar;
-
-	ret = ath6kl_core_init(ar);
-	if (ret) {
-		ath6kl_err("Failed to init ath6kl core: %d\n", ret);
-		goto err_core_free;
-	}
-
-	return ret;
-
-err_core_free:
-	ath6kl_core_free(ar);
-err_usb_destroy:
-	ath6kl_usb_destroy(ar_usb);
-err_usb_put:
-	usb_put_dev(dev);
-
-	return ret;
-}
-
-static void ath6kl_usb_remove(struct usb_interface *interface)
-{
-	usb_put_dev(interface_to_usbdev(interface));
-	ath6kl_usb_device_detached(interface);
-}
-
-/* table of devices that work with this driver */
-static struct usb_device_id ath6kl_usb_ids[] = {
-	{USB_DEVICE(0x0cf3, 0x9374)},
-	{ /* Terminating entry */ },
-};
-
-MODULE_DEVICE_TABLE(usb, ath6kl_usb_ids);
-
-static struct usb_driver ath6kl_usb_driver = {
-	.name = "ath6kl_usb",
-	.probe = ath6kl_usb_probe,
-	.disconnect = ath6kl_usb_remove,
-	.id_table = ath6kl_usb_ids,
-};
-
-static int ath6kl_usb_init(void)
-{
-	usb_register(&ath6kl_usb_driver);
-	return 0;
-}
-
-static void ath6kl_usb_exit(void)
-{
-	usb_deregister(&ath6kl_usb_driver);
-}
-
-module_init(ath6kl_usb_init);
-module_exit(ath6kl_usb_exit);
-
-MODULE_AUTHOR("Atheros Communications, Inc.");
-MODULE_DESCRIPTION("Driver support for Atheros AR600x USB devices");
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_FIRMWARE(AR6004_HW_1_0_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_0_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_1_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);
-- 
1.7.4.4

