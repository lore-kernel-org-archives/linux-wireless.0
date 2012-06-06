Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:25069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab2FFKIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:21 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 28/29] NFC: Convert pn533 from semaphore to mutex
Date: Wed,  6 Jun 2012 12:16:45 +0200
Message-Id: <1338977806-30279-29-git-send-email-sameo@linux.intel.com> (sfid-20120606_120840_966521_5442C16E)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index b97e3c8..58c1641 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -329,7 +329,7 @@ struct pn533 {
 
 	pn533_cmd_complete_t cmd_complete;
 	void *cmd_complete_arg;
-	struct semaphore cmd_lock;
+	struct mutex cmd_lock;
 	u8 cmd;
 
 	struct pn533_poll_modulations *poll_mod_active[PN533_POLL_MOD_MAX + 1];
@@ -462,7 +462,7 @@ static void pn533_wq_cmd_complete(struct work_struct *work)
 					PN533_FRAME_CMD_PARAMS_LEN(in_frame));
 
 	if (rc != -EINPROGRESS)
-		up(&dev->cmd_lock);
+		mutex_unlock(&dev->cmd_lock);
 }
 
 static void pn533_recv_response(struct urb *urb)
@@ -640,7 +640,7 @@ static int pn533_send_cmd_frame_async(struct pn533 *dev,
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
-	if (down_trylock(&dev->cmd_lock))
+	if (!mutex_trylock(&dev->cmd_lock))
 		return -EBUSY;
 
 	rc = __pn533_send_cmd_frame_async(dev, out_frame, in_frame,
@@ -650,7 +650,7 @@ static int pn533_send_cmd_frame_async(struct pn533 *dev,
 
 	return 0;
 error:
-	up(&dev->cmd_lock);
+	mutex_unlock(&dev->cmd_lock);
 	return rc;
 }
 
@@ -1261,7 +1261,7 @@ static void pn533_listen_mode_timer(unsigned long data)
 
 	dev->cancel_listen = 1;
 
-	up(&dev->cmd_lock);
+	mutex_unlock(&dev->cmd_lock);
 
 	pn533_poll_next_mod(dev);
 
@@ -2054,7 +2054,7 @@ error_cmd:
 
 	kfree(arg);
 
-	up(&dev->cmd_lock);
+	mutex_unlock(&dev->cmd_lock);
 }
 
 static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
@@ -2114,7 +2114,7 @@ static int pn533_probe(struct usb_interface *interface,
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
 	dev->interface = interface;
-	sema_init(&dev->cmd_lock, 1);
+	mutex_init(&dev->cmd_lock);
 
 	iface_desc = interface->cur_altsetting;
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
-- 
1.7.9.1

