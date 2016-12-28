Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:54154 "EHLO
        mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbcL1RmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 12:42:08 -0500
From: Andrey Rusalin <arusalin@dev.rtsoft.ru>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, michael.thalmeier@hale.at,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andrey Rusalin <arusalin@dev.rtsoft.ru>
Subject: [PATCH 3/3] NFC: pn533: change order operations in dev registation
Date: Wed, 28 Dec 2016 20:10:59 +0300
Message-Id: <1482945059-12249-4-git-send-email-arusalin@dev.rtsoft.ru> (sfid-20161228_184216_441180_563D6EAF)
In-Reply-To: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
References: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes during probing and registration of pn533_i2c
NULL pointer dereference happens.
Reproduced in cycle of inserting and removing pn533_i2c
and pn533 modules.

Backtrace:
[<8004205c>] (__queue_work) from [<80042324>] (queue_work_on+0x50/0x5c)
r10:acdc7c80 r9:8006b330 r8:ac0dfb40 r7:ac50c600 r6:00000004 r5:acbbee40 r4:600f0113
[<800422d4>] (queue_work_on) from [<7f7d5b6c>] (pn533_recv_frame+0x158/0x1fc [pn533])
r7:ffffff87 r6:00000000 r5:acbbee40 r4:acbbee00
[<7f7d5a14>] (pn533_recv_frame [pn533]) from [<7f7df4b8>] (pn533_i2c_irq_thread_fn+0x184/0x)
r6:acb2a000 r5:00000000 r4:acdc7b90
[<7f7df334>] (pn533_i2c_irq_thread_fn [pn533_i2c]) from [<8006b354>] (irq_thread_fn+0x24/0x)
r7:00000000 r6:accde000 r5:ac0dfb40 r4:acdc7c80
...

Seems there is some race condition due registration of
irq handler until all data stuctures that could be needed
are ready. So I re-ordered some ops. After this, problem has gone.

Changes in USB part was not tested, but it should not break
anything.

Signed-off-by: Andrey Rusalin <arusalin@dev.rtsoft.ru>
---
 drivers/nfc/pn533/i2c.c   | 28 ++++++++++++++++++----------
 drivers/nfc/pn533/pn533.c | 42 +++++++++++++++++++++++++-----------------
 drivers/nfc/pn533/pn533.h |  1 +
 drivers/nfc/pn533/usb.c   |  4 ++++
 4 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index e2848e4..c1302de 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -206,14 +206,6 @@ static int pn533_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	r = request_threaded_irq(client->irq, NULL, pn533_i2c_irq_thread_fn,
-				 IRQF_TRIGGER_FALLING |
-				 IRQF_SHARED | IRQF_ONESHOT,
-				 PN533_I2C_DRIVER_NAME, phy);
-
-	if (r < 0)
-		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-
 	priv = pn533_register_device(PN533_DEVICE_PN532,
 				     PN533_NO_TYPE_B_PROTOCOLS,
 				     PN533_PROTO_REQ_ACK_RESP,
@@ -223,16 +215,32 @@ static int pn533_i2c_probe(struct i2c_client *client,
 
 	if (IS_ERR(priv)) {
 		r = PTR_ERR(priv);
-		goto err_register;
+		return r;
 	}
 
 	phy->priv = priv;
 
+	r = request_threaded_irq(client->irq, NULL, pn533_i2c_irq_thread_fn,
+				IRQF_TRIGGER_FALLING |
+				IRQF_SHARED | IRQF_ONESHOT,
+				PN533_I2C_DRIVER_NAME, phy);
+	if (r < 0) {
+		nfc_err(&client->dev, "Unable to register IRQ handler\n");
+		goto irq_rqst_err;
+	}
+
+	r = pn533_finalize_setup(priv);
+	if (r)
+		goto fn_setup_err;
+
 	return 0;
 
-err_register:
+fn_setup_err:
 	free_irq(client->irq, phy);
 
+irq_rqst_err:
+	pn533_unregister_device(phy->priv);
+
 	return r;
 }
 
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index c67150f..bbae44b 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2570,6 +2570,31 @@ static int pn533_setup(struct pn533 *dev)
 	return 0;
 }
 
+int pn533_finalize_setup(struct pn533 *dev)
+{
+
+	struct pn533_fw_version fw_ver;
+	int rc;
+
+	memset(&fw_ver, 0, sizeof(fw_ver));
+
+	rc = pn533_get_firmware_version(dev, &fw_ver);
+	if (rc) {
+		nfc_err(dev->dev, "Unable to get FW version\n");
+		return rc;
+	}
+
+	nfc_info(dev->dev, "NXP PN5%02X firmware ver %d.%d now attached\n",
+		fw_ver.ic, fw_ver.ver, fw_ver.rev);
+
+	rc = pn533_setup(dev);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pn533_finalize_setup);
+
 struct pn533 *pn533_register_device(u32 device_type,
 				u32 protocols,
 				enum pn533_protocol_type protocol_type,
@@ -2579,7 +2604,6 @@ struct pn533 *pn533_register_device(u32 device_type,
 				struct device *dev,
 				struct device *parent)
 {
-	struct pn533_fw_version fw_ver;
 	struct pn533 *priv;
 	int rc = -ENOMEM;
 
@@ -2622,15 +2646,6 @@ struct pn533 *pn533_register_device(u32 device_type,
 
 	INIT_LIST_HEAD(&priv->cmd_queue);
 
-	memset(&fw_ver, 0, sizeof(fw_ver));
-	rc = pn533_get_firmware_version(priv, &fw_ver);
-	if (rc < 0)
-		goto destroy_wq;
-
-	nfc_info(dev, "NXP PN5%02X firmware ver %d.%d now attached\n",
-		 fw_ver.ic, fw_ver.ver, fw_ver.rev);
-
-
 	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
 					   priv->ops->tx_header_len +
 					   PN533_CMD_DATAEXCH_HEAD_LEN,
@@ -2647,15 +2662,8 @@ struct pn533 *pn533_register_device(u32 device_type,
 	if (rc)
 		goto free_nfc_dev;
 
-	rc = pn533_setup(priv);
-	if (rc)
-		goto unregister_nfc_dev;
-
 	return priv;
 
-unregister_nfc_dev:
-	nfc_unregister_device(priv->nfc_dev);
-
 free_nfc_dev:
 	nfc_free_device(priv->nfc_dev);
 
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index e26d634..12ea04e 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -231,6 +231,7 @@ struct pn533 *pn533_register_device(u32 device_type,
 				struct device *dev,
 				struct device *parent);
 
+int pn533_finalize_setup(struct pn533 *dev);
 void pn533_unregister_device(struct pn533 *priv);
 void pn533_recv_frame(struct pn533 *dev, struct sk_buff *skb, int status);
 
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index bcf3f54..909806f 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -543,6 +543,10 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
 	phy->priv = priv;
 
+	rc = pn533_finalize_setup(priv);
+	if (rc)
+		goto error;
+
 	usb_set_intfdata(interface, phy);
 
 	return 0;
-- 
2.7.4
