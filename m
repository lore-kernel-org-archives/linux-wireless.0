Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28200 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2FFKIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:46 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 29/29] NFC: Monitor pn533 target mode
Date: Wed,  6 Jun 2012 12:16:46 +0200
Message-Id: <1338977806-30279-30-git-send-email-sameo@linux.intel.com> (sfid-20120606_120849_691101_E87AB74C)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving a DEP link down event, we should cancel all pending URBs
if we're activated as a target or if we're an initiator.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 58c1641..9ac829e 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -343,6 +343,7 @@ struct pn533 {
 
 	u8 tgt_available_prots;
 	u8 tgt_active_prot;
+	u8 tgt_mode;
 };
 
 struct pn533_frame {
@@ -1158,6 +1159,8 @@ static int pn533_tm_get_data_complete(struct pn533 *dev, void *arg,
 	if (params_len > 0 && params[0] != 0) {
 		nfc_tm_deactivated(dev->nfc_dev);
 
+		dev->tgt_mode = 0;
+
 		kfree_skb(skb_resp);
 		return 0;
 	}
@@ -1245,6 +1248,8 @@ static int pn533_init_target_complete(struct pn533 *dev, void *arg,
 		return rc;
 	}
 
+	dev->tgt_mode = 1;
+
 	queue_work(dev->wq, &dev->tg_work);
 
 	return 0;
@@ -1397,6 +1402,12 @@ static int pn533_start_poll(struct nfc_dev *nfc_dev,
 		return -EBUSY;
 	}
 
+	if (dev->tgt_mode) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Cannot poll while already being activated");
+		return -EBUSY;
+	}
+
 	if (tm_protocols) {
 		dev->gb = nfc_get_local_general_bytes(nfc_dev, &dev->gb_len);
 		if (dev->gb == NULL)
@@ -1725,7 +1736,15 @@ static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
 
 	pn533_poll_reset_mod_list(dev);
 
-	pn533_deactivate_target(nfc_dev, 0);
+	if (dev->tgt_mode || dev->tgt_active_prot) {
+		pn533_send_ack(dev, GFP_KERNEL);
+		usb_kill_urb(dev->in_urb);
+	}
+
+	dev->tgt_active_prot = 0;
+	dev->tgt_mode = 0;
+
+	skb_queue_purge(&dev->resp_q);
 
 	return 0;
 }
@@ -1956,6 +1975,8 @@ static int pn533_tm_send_complete(struct pn533 *dev, void *arg,
 	if (params_len > 0 && params[0] != 0) {
 		nfc_tm_deactivated(dev->nfc_dev);
 
+		dev->tgt_mode = 0;
+
 		return 0;
 	}
 
-- 
1.7.9.1

