Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A873C43444
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE93920870
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392023AbfAKPMi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:12:38 -0500
Received: from smtp3.goneo.de ([85.220.129.37]:49268 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392014AbfAKPMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 10:12:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 6A34223FFE5;
        Fri, 11 Jan 2019 16:12:33 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WApagUEdLxdf; Fri, 11 Jan 2019 16:12:27 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPA id 26CBA23FB7C;
        Fri, 11 Jan 2019 16:12:27 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "GitAuthor: Lars Poeschel" <poeschel@lemonage.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org (open list:NFC SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 4/7] nfc: pn533: Split pn533 init & nfc_register
Date:   Fri, 11 Jan 2019 17:18:07 +0100
Message-Id: <20190111161812.26325-4-poeschel@lemonage.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190111161812.26325-1-poeschel@lemonage.de>
References: <20190111161812.26325-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is a problem in the initialisation and setup of the pn533: It
registers with nfc too early. It could happen, that it finished
registering with nfc and someone starts using it. But setup of the pn533
is not yet finished. Bad or at least unintended things could happen.
So I split out nfc registering (and unregistering) to seperate functions
that have to be called late in probe then.

Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
Changes in v5:
- This patch is new in v5

 drivers/nfc/pn533/i2c.c   | 17 +++++-----
 drivers/nfc/pn533/pn533.c | 66 ++++++++++++++++++++-------------------
 drivers/nfc/pn533/pn533.h | 11 ++++---
 drivers/nfc/pn533/usb.c   | 12 +++++--
 4 files changed, 59 insertions(+), 47 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index f4eae9dd5305..9907fc3525f2 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -206,12 +206,10 @@ static int pn533_i2c_probe(struct i2c_client *client,
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
-	priv = pn533_register_device(PN533_DEVICE_PN532,
-				     PN533_NO_TYPE_B_PROTOCOLS,
+	priv = pn53x_common_init(PN533_DEVICE_PN532,
 				     PN533_PROTO_REQ_ACK_RESP,
 				     phy, &i2c_phy_ops, NULL,
-				     &phy->i2c_dev->dev,
-				     &client->dev);
+				     &phy->i2c_dev->dev);
 
 	if (IS_ERR(priv)) {
 		r = PTR_ERR(priv);
@@ -233,13 +231,17 @@ static int pn533_i2c_probe(struct i2c_client *client,
 	if (r)
 		goto fn_setup_err;
 
-	return 0;
+	r = pn53x_register_nfc(priv, PN533_NO_TYPE_B_PROTOCOLS, &client->dev);
+	if (r)
+		goto fn_setup_err;
+
+	return r;
 
 fn_setup_err:
 	free_irq(client->irq, phy);
 
 irq_rqst_err:
-	pn533_unregister_device(phy->priv);
+	pn53x_common_clean(phy->priv);
 
 	return r;
 }
@@ -252,7 +254,8 @@ static int pn533_i2c_remove(struct i2c_client *client)
 
 	free_irq(client->irq, phy);
 
-	pn533_unregister_device(phy->priv);
+	pn53x_unregister_nfc(phy->priv);
+	pn53x_common_clean(phy->priv);
 
 	return 0;
 }
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 1bc097d03789..3689f0502f6a 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2600,14 +2600,12 @@ int pn533_finalize_setup(struct pn533 *dev)
 }
 EXPORT_SYMBOL_GPL(pn533_finalize_setup);
 
-struct pn533 *pn533_register_device(u32 device_type,
-				u32 protocols,
+struct pn533 *pn53x_common_init(u32 device_type,
 				enum pn533_protocol_type protocol_type,
 				void *phy,
 				struct pn533_phy_ops *phy_ops,
 				struct pn533_frame_ops *fops,
-				struct device *dev,
-				struct device *parent)
+				struct device *dev)
 {
 	struct pn533 *priv;
 	int rc = -ENOMEM;
@@ -2648,43 +2646,18 @@ struct pn533 *pn533_register_device(u32 device_type,
 	skb_queue_head_init(&priv->fragment_skb);
 
 	INIT_LIST_HEAD(&priv->cmd_queue);
-
-	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
-					   priv->ops->tx_header_len +
-					   PN533_CMD_DATAEXCH_HEAD_LEN,
-					   priv->ops->tx_tail_len);
-	if (!priv->nfc_dev) {
-		rc = -ENOMEM;
-		goto destroy_wq;
-	}
-
-	nfc_set_parent_dev(priv->nfc_dev, parent);
-	nfc_set_drvdata(priv->nfc_dev, priv);
-
-	rc = nfc_register_device(priv->nfc_dev);
-	if (rc)
-		goto free_nfc_dev;
-
 	return priv;
 
-free_nfc_dev:
-	nfc_free_device(priv->nfc_dev);
-
-destroy_wq:
-	destroy_workqueue(priv->wq);
 error:
 	kfree(priv);
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(pn533_register_device);
+EXPORT_SYMBOL_GPL(pn53x_common_init);
 
-void pn533_unregister_device(struct pn533 *priv)
+void pn53x_common_clean(struct pn533 *priv)
 {
 	struct pn533_cmd *cmd, *n;
 
-	nfc_unregister_device(priv->nfc_dev);
-	nfc_free_device(priv->nfc_dev);
-
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
 
@@ -2699,8 +2672,37 @@ void pn533_unregister_device(struct pn533 *priv)
 
 	kfree(priv);
 }
-EXPORT_SYMBOL_GPL(pn533_unregister_device);
+EXPORT_SYMBOL_GPL(pn53x_common_clean);
+
+int pn53x_register_nfc(struct pn533 *priv, u32 protocols,
+			struct device *parent)
+{
+	int rc = -ENOMEM;
+
+	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
+					   priv->ops->tx_header_len +
+					   PN533_CMD_DATAEXCH_HEAD_LEN,
+					   priv->ops->tx_tail_len);
+	if (!priv->nfc_dev)
+		return -ENOMEM;
+
+	nfc_set_parent_dev(priv->nfc_dev, parent);
+	nfc_set_drvdata(priv->nfc_dev, priv);
+
+	rc = nfc_register_device(priv->nfc_dev);
+	if (rc)
+		nfc_free_device(priv->nfc_dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(pn53x_register_nfc);
 
+void pn53x_unregister_nfc(struct pn533 *priv)
+{
+	nfc_unregister_device(priv->nfc_dev);
+	nfc_free_device(priv->nfc_dev);
+}
+EXPORT_SYMBOL_GPL(pn53x_unregister_nfc);
 
 MODULE_AUTHOR("Lauro Ramos Venancio <lauro.venancio@openbossa.org>");
 MODULE_AUTHOR("Aloisio Almeida Jr <aloisio.almeida@openbossa.org>");
diff --git a/drivers/nfc/pn533/pn533.h b/drivers/nfc/pn533/pn533.h
index eb5ccefc32e5..39909d099309 100644
--- a/drivers/nfc/pn533/pn533.h
+++ b/drivers/nfc/pn533/pn533.h
@@ -231,18 +231,19 @@ struct pn533_phy_ops {
 };
 
 
-struct pn533 *pn533_register_device(u32 device_type,
-				u32 protocols,
+struct pn533 *pn53x_common_init(u32 device_type,
 				enum pn533_protocol_type protocol_type,
 				void *phy,
 				struct pn533_phy_ops *phy_ops,
 				struct pn533_frame_ops *fops,
-				struct device *dev,
-				struct device *parent);
+				struct device *dev);
 
 int pn533_finalize_setup(struct pn533 *dev);
-void pn533_unregister_device(struct pn533 *priv);
+void pn53x_common_clean(struct pn533 *priv);
 void pn533_recv_frame(struct pn533 *dev, struct sk_buff *skb, int status);
+int pn53x_register_nfc(struct pn533 *priv, u32 protocols,
+			struct device *parent);
+void pn53x_unregister_nfc(struct pn533 *priv);
 
 bool pn533_rx_frame_is_cmd_response(struct pn533 *dev, void *frame);
 bool pn533_rx_frame_is_ack(void *_frame);
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 5d823e965883..0f8e1dc3fbf1 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -546,9 +546,9 @@ static int pn533_usb_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	priv = pn533_register_device(id->driver_info, protocols, protocol_type,
+	priv = pn53x_common_init(id->driver_info, protocol_type,
 					phy, &usb_phy_ops, fops,
-					&phy->udev->dev, &interface->dev);
+					&phy->udev->dev);
 
 	if (IS_ERR(priv)) {
 		rc = PTR_ERR(priv);
@@ -562,9 +562,14 @@ static int pn533_usb_probe(struct usb_interface *interface,
 		goto error;
 
 	usb_set_intfdata(interface, phy);
+	rc = pn53x_register_nfc(priv, protocols, &interface->dev);
+	if (rc)
+		goto err_clean;
 
 	return 0;
 
+err_clean:
+	pn53x_common_clean(priv);
 error:
 	usb_free_urb(phy->in_urb);
 	usb_free_urb(phy->out_urb);
@@ -582,7 +587,8 @@ static void pn533_usb_disconnect(struct usb_interface *interface)
 	if (!phy)
 		return;
 
-	pn533_unregister_device(phy->priv);
+	pn53x_unregister_nfc(phy->priv);
+	pn53x_common_clean(phy->priv);
 
 	usb_set_intfdata(interface, NULL);
 
-- 
2.20.1

