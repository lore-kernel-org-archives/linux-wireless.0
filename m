Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34884 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbEFBIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 21:08:30 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 10/12] ath9k_htc: use sysdata_file_request() and sysdata_file_request_async()
Date: Tue,  5 May 2015 17:44:28 -0700
Message-Id: <1430873070-7290-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_030847_693295_B1533B85)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 62 +++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8e7153b..bc7591c 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -15,6 +15,7 @@
  */
 
 #include <asm/unaligned.h>
+#include <linux/sysdata.h>
 #include "htc.h"
 
 /* identify firmware images */
@@ -1079,7 +1080,8 @@ static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
 		device_unlock(parent);
 }
 
-static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
+static void ath9k_hif_usb_firmware_cb(const struct sysdata_file *fw,
+				      void *context)
 {
 	struct hif_device_usb *hif_dev = context;
 	int ret;
@@ -1115,7 +1117,7 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 		goto err_htc_hw_init;
 	}
 
-	release_firmware(fw);
+	release_sysdata_file(fw);
 	hif_dev->flags |= HIF_USB_READY;
 	complete_all(&hif_dev->fw_done);
 
@@ -1126,7 +1128,7 @@ err_htc_hw_init:
 err_dev_init:
 	ath9k_htc_hw_free(hif_dev->htc_handle);
 err_dev_alloc:
-	release_firmware(fw);
+	release_sysdata_file(fw);
 err_fw:
 	ath9k_hif_usb_firmware_fail(hif_dev);
 }
@@ -1186,6 +1188,16 @@ static int send_eject_command(struct usb_interface *interface)
 	return 0;
 }
 
+int ath9k_hif_usb_probe_fw(struct hif_device_usb *hif_dev)
+{
+	const struct sysdata_file_desc fw_desc = {
+		SYSDATA_DEFAULT_ASYNC(ath9k_hif_usb_firmware_cb, hif_dev),
+	};
+
+	return sysdata_file_request_async(hif_dev->fw_name, &fw_desc,
+					  &hif_dev->udev->dev);
+}
+
 static int ath9k_hif_usb_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
@@ -1221,18 +1233,9 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	else
 		hif_dev->fw_name = FIRMWARE_AR9271;
 
-	ret = request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
-				      &hif_dev->udev->dev, GFP_KERNEL,
-				      hif_dev, ath9k_hif_usb_firmware_cb);
-	if (ret) {
-		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Async request for firmware %s failed\n",
-			hif_dev->fw_name);
+	ret = ath9k_hif_usb_probe_fw(hif_dev);
+	if (ret)
 		goto err_fw_req;
-	}
-
-	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
-		 hif_dev->fw_name);
 
 	return 0;
 
@@ -1312,12 +1315,30 @@ static int ath9k_hif_usb_suspend(struct usb_interface *interface,
 	return 0;
 }
 
+static int ath9k_hif_usb_resume_fw(void *context,
+				   const struct sysdata_file *fw)
+{
+	struct hif_device_usb *hif_dev = context;
+	int ret;
+
+	hif_dev->fw_data = fw->data;
+	hif_dev->fw_size = fw->size;
+
+	ret = ath9k_hif_usb_download_fw(hif_dev);
+
+	release_sysdata_file(fw);
+
+	return ret;
+}
+
 static int ath9k_hif_usb_resume(struct usb_interface *interface)
 {
 	struct hif_device_usb *hif_dev = usb_get_intfdata(interface);
 	struct htc_target *htc_handle = hif_dev->htc_handle;
 	int ret;
-	const struct firmware *fw;
+	const struct sysdata_file_desc fw_resume_desc = {
+		SYSDATA_DEFAULT_SYNC(ath9k_hif_usb_resume_fw, hif_dev),
+	};
 
 	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
 	if (ret)
@@ -1325,15 +1346,8 @@ static int ath9k_hif_usb_resume(struct usb_interface *interface)
 
 	if (hif_dev->flags & HIF_USB_READY) {
 		/* request cached firmware during suspend/resume cycle */
-		ret = request_firmware(&fw, hif_dev->fw_name,
-				       &hif_dev->udev->dev);
-		if (ret)
-			goto fail_resume;
-
-		hif_dev->fw_data = fw->data;
-		hif_dev->fw_size = fw->size;
-		ret = ath9k_hif_usb_download_fw(hif_dev);
-		release_firmware(fw);
+		ret = sysdata_file_request("3826.arm", &fw_resume_desc,
+					   &hif_dev->udev->dev);
 		if (ret)
 			goto fail_resume;
 	} else {
-- 
2.3.2.209.gd67f9d5.dirty

