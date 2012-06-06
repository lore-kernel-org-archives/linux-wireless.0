Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36173 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab2FFKH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:59 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 22/29] NFC: Implement pn533 polling loop
Date: Wed,  6 Jun 2012 12:16:39 +0200
Message-Id: <1338977806-30279-23-git-send-email-sameo@linux.intel.com> (sfid-20120606_120813_779015_3C12FC65)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After going through all the modulations, the pn533 driver spends 2
seconds listening for targets.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |  287 ++++++++++++++++++++++++++++----------------------
 1 files changed, 161 insertions(+), 126 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 6e4b228..c9ba96c 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -45,6 +45,9 @@ static const struct usb_device_id pn533_table[] = {
 };
 MODULE_DEVICE_TABLE(usb, pn533_table);
 
+/* How much time we spend listening for initiators */
+#define PN533_LISTEN_TIME 2
+
 /* frame definitions */
 #define PN533_FRAME_TAIL_SIZE 2
 #define PN533_FRAME_SIZE(f) (sizeof(struct pn533_frame) + f->datalen + \
@@ -163,6 +166,7 @@ enum {
 	PN533_POLL_MOD_424KBPS_FELICA,
 	PN533_POLL_MOD_106KBPS_JEWEL,
 	PN533_POLL_MOD_847KBPS_B,
+	PN533_LISTEN_MOD,
 
 	__PN533_POLL_MOD_AFTER_LAST,
 };
@@ -230,6 +234,9 @@ const struct pn533_poll_modulations poll_mod[] = {
 		},
 		.len = 3,
 	},
+	[PN533_LISTEN_MOD] = {
+		.len = 0,
+	},
 };
 
 /* PN533_CMD_IN_ATR */
@@ -312,10 +319,13 @@ struct pn533 {
 
 	struct workqueue_struct	*wq;
 	struct work_struct cmd_work;
+	struct work_struct poll_work;
 	struct work_struct mi_work;
 	struct work_struct tg_work;
+	struct timer_list listen_timer;
 	struct pn533_frame *wq_in_frame;
 	int wq_in_error;
+	int cancel_listen;
 
 	pn533_cmd_complete_t cmd_complete;
 	void *cmd_complete_arg;
@@ -326,6 +336,10 @@ struct pn533 {
 	u8 poll_mod_count;
 	u8 poll_mod_curr;
 	u32 poll_protocols;
+	u32 listen_protocols;
+
+	u8 *gb;
+	size_t gb_len;
 
 	u8 tgt_available_prots;
 	u8 tgt_active_prot;
@@ -1006,6 +1020,11 @@ static int pn533_target_found(struct pn533 *dev,
 	return 0;
 }
 
+static inline void pn533_poll_next_mod(struct pn533 *dev)
+{
+	dev->poll_mod_curr = (dev->poll_mod_curr + 1) % dev->poll_mod_count;
+}
+
 static void pn533_poll_reset_mod_list(struct pn533 *dev)
 {
 	dev->poll_mod_count = 0;
@@ -1018,107 +1037,52 @@ static void pn533_poll_add_mod(struct pn533 *dev, u8 mod_index)
 	dev->poll_mod_count++;
 }
 
-static void pn533_poll_create_mod_list(struct pn533 *dev, u32 protocols)
+static void pn533_poll_create_mod_list(struct pn533 *dev,
+				       u32 im_protocols, u32 tm_protocols)
 {
 	pn533_poll_reset_mod_list(dev);
 
-	if (protocols & NFC_PROTO_MIFARE_MASK
-					|| protocols & NFC_PROTO_ISO14443_MASK
-					|| protocols & NFC_PROTO_NFC_DEP_MASK)
+	if (im_protocols & NFC_PROTO_MIFARE_MASK
+	    || im_protocols & NFC_PROTO_ISO14443_MASK
+	    || im_protocols & NFC_PROTO_NFC_DEP_MASK)
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_106KBPS_A);
 
-	if (protocols & NFC_PROTO_FELICA_MASK
-					|| protocols & NFC_PROTO_NFC_DEP_MASK) {
+	if (im_protocols & NFC_PROTO_FELICA_MASK
+	    || im_protocols & NFC_PROTO_NFC_DEP_MASK) {
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_212KBPS_FELICA);
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_424KBPS_FELICA);
 	}
 
-	if (protocols & NFC_PROTO_JEWEL_MASK)
+	if (im_protocols & NFC_PROTO_JEWEL_MASK)
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_106KBPS_JEWEL);
 
-	if (protocols & NFC_PROTO_ISO14443_MASK)
+	if (im_protocols & NFC_PROTO_ISO14443_MASK)
 		pn533_poll_add_mod(dev, PN533_POLL_MOD_847KBPS_B);
-}
-
-static void pn533_start_poll_frame(struct pn533_frame *frame,
-					struct pn533_poll_modulations *mod)
-{
-
-	pn533_tx_frame_init(frame, PN533_CMD_IN_LIST_PASSIVE_TARGET);
 
-	memcpy(PN533_FRAME_CMD_PARAMS_PTR(frame), &mod->data, mod->len);
-	frame->datalen += mod->len;
-
-	pn533_tx_frame_finish(frame);
+	if (tm_protocols)
+		pn533_poll_add_mod(dev, PN533_LISTEN_MOD);
 }
 
 static int pn533_start_poll_complete(struct pn533 *dev, void *arg,
-						u8 *params, int params_len)
+				     u8 *params, int params_len)
 {
 	struct pn533_poll_response *resp;
-	struct pn533_poll_modulations *next_mod;
 	int rc;
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
-	if (params_len == -ENOENT) {
-		nfc_dev_dbg(&dev->interface->dev, "Polling operation has been"
-								" stopped");
-		goto stop_poll;
-	}
-
-	if (params_len < 0) {
-		nfc_dev_err(&dev->interface->dev, "Error %d when running poll",
-								params_len);
-		goto stop_poll;
-	}
-
 	resp = (struct pn533_poll_response *) params;
 	if (resp->nbtg) {
 		rc = pn533_target_found(dev, resp, params_len);
 
 		/* We must stop the poll after a valid target found */
-		if (rc == 0)
-			goto stop_poll;
-
-		if (rc != -EAGAIN)
-			nfc_dev_err(&dev->interface->dev, "The target found is"
-					" not valid - continuing to poll");
-	}
-
-	dev->poll_mod_curr = (dev->poll_mod_curr + 1) % dev->poll_mod_count;
-
-	next_mod = dev->poll_mod_active[dev->poll_mod_curr];
-
-	nfc_dev_dbg(&dev->interface->dev, "Polling next modulation (0x%x)",
-							dev->poll_mod_curr);
-
-	pn533_start_poll_frame(dev->out_frame, next_mod);
-
-	/* Don't need to down the semaphore again */
-	rc = __pn533_send_cmd_frame_async(dev, dev->out_frame, dev->in_frame,
-				dev->in_maxlen, pn533_start_poll_complete,
-				NULL, GFP_ATOMIC);
-
-	if (rc == -EPERM) {
-		nfc_dev_dbg(&dev->interface->dev, "Cannot poll next modulation"
-					" because poll has been stopped");
-		goto stop_poll;
-	}
-
-	if (rc) {
-		nfc_dev_err(&dev->interface->dev, "Error %d when trying to poll"
-							" next modulation", rc);
-		goto stop_poll;
+		if (rc == 0) {
+			pn533_poll_reset_mod_list(dev);
+			return 0;
+		}
 	}
 
-	/* Inform caller function to do not up the semaphore */
-	return -EINPROGRESS;
-
-stop_poll:
-	pn533_poll_reset_mod_list(dev);
-	dev->poll_protocols = 0;
-	return 0;
+	return -EAGAIN;
 }
 
 static int pn533_init_target_frame(struct pn533_frame *frame,
@@ -1286,83 +1250,136 @@ static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 	return 0;
 }
 
-static int pn533_init_target(struct nfc_dev *nfc_dev, u32 protocols)
+static void pn533_listen_mode_timer(unsigned long data)
 {
-	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
-	u8 *gb;
-	size_t gb_len;
+	struct pn533 *dev = (struct pn533 *) data;
+
+	nfc_dev_dbg(&dev->interface->dev, "Listen mode timeout");
+
+	/* An ack will cancel the last issued command (poll) */
+	pn533_send_ack(dev, GFP_ATOMIC);
+
+	dev->cancel_listen = 1;
+
+	up(&dev->cmd_lock);
+
+	pn533_poll_next_mod(dev);
+
+	queue_work(dev->wq, &dev->poll_work);
+}
+
+static int pn533_poll_complete(struct pn533 *dev, void *arg,
+			       u8 *params, int params_len)
+{
+	struct pn533_poll_modulations *cur_mod;
 	int rc;
 
-	pn533_poll_reset_mod_list(dev);
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
-	gb = nfc_get_local_general_bytes(nfc_dev, &gb_len);
-	if (gb == NULL)
-		return -ENOMEM;
+	if (params_len == -ENOENT) {
+		if (dev->poll_mod_count != 0)
+			return 0;
 
-	rc = pn533_init_target_frame(dev->out_frame, gb, gb_len);
-	if (rc < 0)
-		return rc;
+		nfc_dev_err(&dev->interface->dev,
+			    "Polling operation has been stopped");
 
-	rc = pn533_send_cmd_frame_async(dev, dev->out_frame, dev->in_frame,
-					dev->in_maxlen,
-					pn533_init_target_complete,
-					NULL, GFP_KERNEL);
+		goto stop_poll;
+	}
 
-	if (rc)
+	if (params_len < 0) {
 		nfc_dev_err(&dev->interface->dev,
-			    "Error %d when trying to initiate as a target", rc);
+			    "Error %d when running poll", params_len);
 
-	dev->poll_mod_count++;
+		goto stop_poll;
+	}
 
-	return rc;
+	cur_mod = dev->poll_mod_active[dev->poll_mod_curr];
+
+	if (cur_mod->len == 0) {
+		del_timer(&dev->listen_timer);
+
+		return pn533_init_target_complete(dev, arg, params, params_len);
+	} else {
+		rc = pn533_start_poll_complete(dev, arg, params, params_len);
+		if (!rc)
+			return rc;
+	}
+
+	pn533_poll_next_mod(dev);
+
+	queue_work(dev->wq, &dev->poll_work);
+
+	return 0;
+
+stop_poll:
+	pn533_poll_reset_mod_list(dev);
+	dev->poll_protocols = 0;
+	return 0;
 }
 
-static int pn533_start_im_poll(struct nfc_dev *nfc_dev, u32 protocols)
+static void pn533_build_poll_frame(struct pn533 *dev,
+				   struct pn533_frame *frame,
+				   struct pn533_poll_modulations *mod)
 {
-	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
-	struct pn533_poll_modulations *start_mod;
-	int rc;
+	nfc_dev_dbg(&dev->interface->dev, "mod len %d\n", mod->len);
 
-	if (dev->poll_mod_count) {
-		nfc_dev_err(&dev->interface->dev, "Polling operation already"
-								" active");
-		return -EBUSY;
-	}
+	if (mod->len == 0) {
+		/* Listen mode */
+		pn533_init_target_frame(frame, dev->gb, dev->gb_len);
+	} else {
+		/* Polling mode */
+		pn533_tx_frame_init(frame, PN533_CMD_IN_LIST_PASSIVE_TARGET);
 
-	pn533_poll_create_mod_list(dev, protocols);
+		memcpy(PN533_FRAME_CMD_PARAMS_PTR(frame), &mod->data, mod->len);
+		frame->datalen += mod->len;
 
-	if (!dev->poll_mod_count) {
-		nfc_dev_err(&dev->interface->dev, "No valid protocols"
-								" specified");
-		rc = -EINVAL;
-		goto error;
+		pn533_tx_frame_finish(frame);
 	}
+}
 
-	nfc_dev_dbg(&dev->interface->dev, "It will poll %d modulations types",
-							dev->poll_mod_count);
+static int pn533_send_poll_frame(struct pn533 *dev)
+{
+	struct pn533_poll_modulations *cur_mod;
+	int rc;
 
-	dev->poll_mod_curr = 0;
-	start_mod = dev->poll_mod_active[dev->poll_mod_curr];
+	cur_mod = dev->poll_mod_active[dev->poll_mod_curr];
 
-	pn533_start_poll_frame(dev->out_frame, start_mod);
+	pn533_build_poll_frame(dev, dev->out_frame, cur_mod);
 
 	rc = pn533_send_cmd_frame_async(dev, dev->out_frame, dev->in_frame,
-				dev->in_maxlen,	pn533_start_poll_complete,
+				dev->in_maxlen,	pn533_poll_complete,
 				NULL, GFP_KERNEL);
+	if (rc)
+		nfc_dev_err(&dev->interface->dev, "Polling loop error %d", rc);
 
-	if (rc) {
-		nfc_dev_err(&dev->interface->dev, "Error %d when trying to"
-							" start poll", rc);
-		goto error;
+	return rc;
+}
+
+static void pn533_wq_poll(struct work_struct *work)
+{
+	struct pn533 *dev = container_of(work, struct pn533, poll_work);
+	struct pn533_poll_modulations *cur_mod;
+	int rc;
+
+	cur_mod = dev->poll_mod_active[dev->poll_mod_curr];
+
+	nfc_dev_dbg(&dev->interface->dev,
+		    "%s cancel_listen %d modulation len %d",
+		    __func__, dev->cancel_listen, cur_mod->len);
+
+	if (dev->cancel_listen == 1) {
+		dev->cancel_listen = 0;
+		usb_kill_urb(dev->in_urb);
 	}
 
-	dev->poll_protocols = protocols;
+	rc = pn533_send_poll_frame(dev);
+	if (rc)
+		return;
 
-	return 0;
+	if (cur_mod->len == 0 && dev->poll_mod_count > 1)
+		mod_timer(&dev->listen_timer, jiffies + PN533_LISTEN_TIME * HZ);
 
-error:
-	pn533_poll_reset_mod_list(dev);
-	return rc;
+	return;
 }
 
 static int pn533_start_poll(struct nfc_dev *nfc_dev,
@@ -1380,13 +1397,18 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 		return -EBUSY;
 	}
 
-	if (im_protocols)
-		return pn533_start_im_poll(nfc_dev, im_protocols);
+	if (tm_protocols) {
+		dev->gb = nfc_get_local_general_bytes(nfc_dev, &dev->gb_len);
+		if (dev->gb == NULL)
+			tm_protocols = 0;
+	}
 
-	if (tm_protocols)
-		return pn533_init_target(nfc_dev, tm_protocols);
+	dev->poll_mod_curr = 0;
+	pn533_poll_create_mod_list(dev, im_protocols, tm_protocols);
+	dev->poll_protocols = im_protocols;
+	dev->listen_protocols = tm_protocols;
 
-	return -EINVAL;
+	return pn533_send_poll_frame(dev);
 }
 
 static void pn533_stop_poll(struct nfc_dev *nfc_dev)
@@ -1395,6 +1417,8 @@ static void pn533_stop_poll(struct nfc_dev *nfc_dev)
 
 	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
 
+	del_timer(&dev->listen_timer);
+
 	if (!dev->poll_mod_count) {
 		nfc_dev_dbg(&dev->interface->dev, "Polling operation was not"
 								" running");
@@ -1676,6 +1700,10 @@ out:
 
 static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
 {
+	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
+
+	pn533_poll_reset_mod_list(dev);
+
 	pn533_deactivate_target(nfc_dev, 0);
 
 	return 0;
@@ -2110,12 +2138,17 @@ static int pn533_probe(struct usb_interface *interface,
 	INIT_WORK(&dev->cmd_work, pn533_wq_cmd_complete);
 	INIT_WORK(&dev->mi_work, pn533_wq_mi_recv);
 	INIT_WORK(&dev->tg_work, pn533_wq_tg_get_data);
+	INIT_WORK(&dev->poll_work, pn533_wq_poll);
 	dev->wq = alloc_workqueue("pn533",
 				  WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
 				  1);
 	if (dev->wq == NULL)
 		goto error;
 
+	init_timer(&dev->listen_timer);
+	dev->listen_timer.data = (unsigned long) dev;
+	dev->listen_timer.function = pn533_listen_mode_timer;
+
 	skb_queue_head_init(&dev->resp_q);
 
 	usb_set_intfdata(interface, dev);
@@ -2212,6 +2245,8 @@ static void pn533_disconnect(struct usb_interface *interface)
 
 	skb_queue_purge(&dev->resp_q);
 
+	del_timer(&dev->listen_timer);
+
 	kfree(dev->in_frame);
 	usb_free_urb(dev->in_urb);
 	kfree(dev->out_frame);
-- 
1.7.9.1

