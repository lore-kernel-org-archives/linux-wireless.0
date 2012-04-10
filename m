Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30044 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab2DJRgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:03 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 15/18] NFC: Convert pn533 from tasklet to workqueues
Date: Tue, 10 Apr 2012 19:43:17 +0200
Message-Id: <1334079800-10671-16-git-send-email-sameo@linux.intel.com> (sfid-20120410_193607_092891_7E634A51)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need for soft IRQ contexts, and workqueues are more flexible.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   86 ++++++++++++++++++++++++++++----------------------
 1 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index cb6204f..f2ee06f 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -266,9 +266,10 @@ struct pn533 {
 	int in_maxlen;
 	struct pn533_frame *in_frame;
 
-	struct tasklet_struct tasklet;
-	struct pn533_frame *tklt_in_frame;
-	int tklt_in_error;
+	struct workqueue_struct	*wq;
+	struct work_struct cmd_work;
+	struct pn533_frame *wq_in_frame;
+	int wq_in_error;
 
 	pn533_cmd_complete_t cmd_complete;
 	void *cmd_complete_arg;
@@ -383,15 +384,21 @@ static bool pn533_rx_frame_is_cmd_response(struct pn533_frame *frame, u8 cmd)
 	return (PN533_FRAME_CMD(frame) == PN533_CMD_RESPONSE(cmd));
 }
 
-static void pn533_tasklet_cmd_complete(unsigned long arg)
+
+static void pn533_wq_cmd_complete(struct work_struct *work)
 {
-	struct pn533 *dev = (struct pn533 *) arg;
-	struct pn533_frame *in_frame = dev->tklt_in_frame;
+	struct pn533 *dev = container_of(work, struct pn533, cmd_work);
+	struct pn533_frame *in_frame;
 	int rc;
 
-	if (dev->tklt_in_error)
+	if (dev == NULL)
+		return;
+
+	in_frame = dev->wq_in_frame;
+
+	if (dev->wq_in_error)
 		rc = dev->cmd_complete(dev, dev->cmd_complete_arg, NULL,
-							dev->tklt_in_error);
+							dev->wq_in_error);
 	else
 		rc = dev->cmd_complete(dev, dev->cmd_complete_arg,
 					PN533_FRAME_CMD_PARAMS_PTR(in_frame),
@@ -406,7 +413,7 @@ static void pn533_recv_response(struct urb *urb)
 	struct pn533 *dev = urb->context;
 	struct pn533_frame *in_frame;
 
-	dev->tklt_in_frame = NULL;
+	dev->wq_in_frame = NULL;
 
 	switch (urb->status) {
 	case 0:
@@ -417,36 +424,36 @@ static void pn533_recv_response(struct urb *urb)
 	case -ESHUTDOWN:
 		nfc_dev_dbg(&dev->interface->dev, "Urb shutting down with"
 						" status: %d", urb->status);
-		dev->tklt_in_error = urb->status;
-		goto sched_tasklet;
+		dev->wq_in_error = urb->status;
+		goto sched_wq;
 	default:
 		nfc_dev_err(&dev->interface->dev, "Nonzero urb status received:"
 							" %d", urb->status);
-		dev->tklt_in_error = urb->status;
-		goto sched_tasklet;
+		dev->wq_in_error = urb->status;
+		goto sched_wq;
 	}
 
 	in_frame = dev->in_urb->transfer_buffer;
 
 	if (!pn533_rx_frame_is_valid(in_frame)) {
 		nfc_dev_err(&dev->interface->dev, "Received an invalid frame");
-		dev->tklt_in_error = -EIO;
-		goto sched_tasklet;
+		dev->wq_in_error = -EIO;
+		goto sched_wq;
 	}
 
 	if (!pn533_rx_frame_is_cmd_response(in_frame, dev->cmd)) {
 		nfc_dev_err(&dev->interface->dev, "The received frame is not "
 						"response to the last command");
-		dev->tklt_in_error = -EIO;
-		goto sched_tasklet;
+		dev->wq_in_error = -EIO;
+		goto sched_wq;
 	}
 
 	nfc_dev_dbg(&dev->interface->dev, "Received a valid frame");
-	dev->tklt_in_error = 0;
-	dev->tklt_in_frame = in_frame;
+	dev->wq_in_error = 0;
+	dev->wq_in_frame = in_frame;
 
-sched_tasklet:
-	tasklet_schedule(&dev->tasklet);
+sched_wq:
+	queue_work(dev->wq, &dev->cmd_work);
 }
 
 static int pn533_submit_urb_for_response(struct pn533 *dev, gfp_t flags)
@@ -471,21 +478,21 @@ static void pn533_recv_ack(struct urb *urb)
 	case -ESHUTDOWN:
 		nfc_dev_dbg(&dev->interface->dev, "Urb shutting down with"
 						" status: %d", urb->status);
-		dev->tklt_in_error = urb->status;
-		goto sched_tasklet;
+		dev->wq_in_error = urb->status;
+		goto sched_wq;
 	default:
 		nfc_dev_err(&dev->interface->dev, "Nonzero urb status received:"
 							" %d", urb->status);
-		dev->tklt_in_error = urb->status;
-		goto sched_tasklet;
+		dev->wq_in_error = urb->status;
+		goto sched_wq;
 	}
 
 	in_frame = dev->in_urb->transfer_buffer;
 
 	if (!pn533_rx_frame_is_ack(in_frame)) {
 		nfc_dev_err(&dev->interface->dev, "Received an invalid ack");
-		dev->tklt_in_error = -EIO;
-		goto sched_tasklet;
+		dev->wq_in_error = -EIO;
+		goto sched_wq;
 	}
 
 	nfc_dev_dbg(&dev->interface->dev, "Received a valid ack");
@@ -494,15 +501,15 @@ static void pn533_recv_ack(struct urb *urb)
 	if (rc) {
 		nfc_dev_err(&dev->interface->dev, "usb_submit_urb failed with"
 							" result %d", rc);
-		dev->tklt_in_error = rc;
-		goto sched_tasklet;
+		dev->wq_in_error = rc;
+		goto sched_wq;
 	}
 
 	return;
 
-sched_tasklet:
-	dev->tklt_in_frame = NULL;
-	tasklet_schedule(&dev->tasklet);
+sched_wq:
+	dev->wq_in_frame = NULL;
+	queue_work(dev->wq, &dev->cmd_work);
 }
 
 static int pn533_submit_urb_for_ack(struct pn533 *dev, gfp_t flags)
@@ -1668,7 +1675,10 @@ static int pn533_probe(struct usb_interface *interface,
 			NULL, 0,
 			pn533_send_complete, dev);
 
-	tasklet_init(&dev->tasklet, pn533_tasklet_cmd_complete, (ulong)dev);
+	INIT_WORK(&dev->cmd_work, pn533_wq_cmd_complete);
+	dev->wq = create_singlethread_workqueue("pn533");
+	if (dev->wq == NULL)
+		goto error;
 
 	usb_set_intfdata(interface, dev);
 
@@ -1678,7 +1688,7 @@ static int pn533_probe(struct usb_interface *interface,
 	rc = pn533_send_cmd_frame_sync(dev, dev->out_frame, dev->in_frame,
 								dev->in_maxlen);
 	if (rc)
-		goto kill_tasklet;
+		goto destroy_wq;
 
 	fw_ver = (struct pn533_fw_version *)
 				PN533_FRAME_CMD_PARAMS_PTR(dev->in_frame);
@@ -1694,7 +1704,7 @@ static int pn533_probe(struct usb_interface *interface,
 					   PN533_CMD_DATAEXCH_HEAD_LEN,
 					   PN533_FRAME_TAIL_SIZE);
 	if (!dev->nfc_dev)
-		goto kill_tasklet;
+		goto destroy_wq;
 
 	nfc_set_parent_dev(dev->nfc_dev, &interface->dev);
 	nfc_set_drvdata(dev->nfc_dev, dev);
@@ -1720,8 +1730,8 @@ static int pn533_probe(struct usb_interface *interface,
 
 free_nfc_dev:
 	nfc_free_device(dev->nfc_dev);
-kill_tasklet:
-	tasklet_kill(&dev->tasklet);
+destroy_wq:
+	destroy_workqueue(dev->wq);
 error:
 	kfree(dev->in_frame);
 	usb_free_urb(dev->in_urb);
@@ -1744,7 +1754,7 @@ static void pn533_disconnect(struct usb_interface *interface)
 	usb_kill_urb(dev->in_urb);
 	usb_kill_urb(dev->out_urb);
 
-	tasklet_kill(&dev->tasklet);
+	destroy_workqueue(dev->wq);
 
 	kfree(dev->in_frame);
 	usb_free_urb(dev->in_urb);
-- 
1.7.9.1

