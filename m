Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19419 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932160AbcHIRVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 13:21:15 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: kernel-janitors@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: nfcmrvl: constify nfcmrvl_if_ops structures
Date: Tue,  9 Aug 2016 19:03:50 +0200
Message-Id: <1470762230-2520-1-git-send-email-Julia.Lawall@lip6.fr> (sfid-20160809_192137_873111_F7DE43DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nfcmrvl_if_ops structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/nfc/nfcmrvl/i2c.c     |    2 +-
 drivers/nfc/nfcmrvl/main.c    |    2 +-
 drivers/nfc/nfcmrvl/nfcmrvl.h |    4 ++--
 drivers/nfc/nfcmrvl/spi.c     |    2 +-
 drivers/nfc/nfcmrvl/uart.c    |    2 +-
 drivers/nfc/nfcmrvl/usb.c     |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 78b7aa8..91d1e67 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -162,7 +162,7 @@ static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,
 {
 }
 
-static struct nfcmrvl_if_ops i2c_ops = {
+static const struct nfcmrvl_if_ops i2c_ops = {
 	.nci_open = nfcmrvl_i2c_nci_open,
 	.nci_close = nfcmrvl_i2c_nci_close,
 	.nci_send = nfcmrvl_i2c_nci_send,
diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
index 51c8240..8e3f26a 100644
--- a/drivers/nfc/nfcmrvl/main.c
+++ b/drivers/nfc/nfcmrvl/main.c
@@ -102,7 +102,7 @@ static struct nci_ops nfcmrvl_nci_ops = {
 
 struct nfcmrvl_private *nfcmrvl_nci_register_dev(enum nfcmrvl_phy phy,
 				void *drv_data,
-				struct nfcmrvl_if_ops *ops,
+				const struct nfcmrvl_if_ops *ops,
 				struct device *dev,
 				struct nfcmrvl_platform_data *pdata)
 {
diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
index de68ff4..d9c2af3 100644
--- a/drivers/nfc/nfcmrvl/nfcmrvl.h
+++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
@@ -88,7 +88,7 @@ struct nfcmrvl_private {
 	/* PHY type */
 	enum nfcmrvl_phy phy;
 	/* Low level driver ops */
-	struct nfcmrvl_if_ops *if_ops;
+	const struct nfcmrvl_if_ops *if_ops;
 };
 
 struct nfcmrvl_if_ops {
@@ -103,7 +103,7 @@ void nfcmrvl_nci_unregister_dev(struct nfcmrvl_private *priv);
 int nfcmrvl_nci_recv_frame(struct nfcmrvl_private *priv, struct sk_buff *skb);
 struct nfcmrvl_private *nfcmrvl_nci_register_dev(enum nfcmrvl_phy phy,
 				void *drv_data,
-				struct nfcmrvl_if_ops *ops,
+				const struct nfcmrvl_if_ops *ops,
 				struct device *dev,
 				struct nfcmrvl_platform_data *pdata);
 
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index a7faa0b..f974b45 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -112,7 +112,7 @@ static void nfcmrvl_spi_nci_update_config(struct nfcmrvl_private *priv,
 	drv_data->nci_spi->xfer_speed_hz = config->clk;
 }
 
-static struct nfcmrvl_if_ops spi_ops = {
+static const struct nfcmrvl_if_ops spi_ops = {
 	.nci_open = nfcmrvl_spi_nci_open,
 	.nci_close = nfcmrvl_spi_nci_close,
 	.nci_send = nfcmrvl_spi_nci_send,
diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index 83a99e3..ad7540e 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -60,7 +60,7 @@ static void nfcmrvl_uart_nci_update_config(struct nfcmrvl_private *priv,
 			    config->flow_control);
 }
 
-static struct nfcmrvl_if_ops uart_ops = {
+static const struct nfcmrvl_if_ops uart_ops = {
 	.nci_open = nfcmrvl_uart_nci_open,
 	.nci_close = nfcmrvl_uart_nci_close,
 	.nci_send = nfcmrvl_uart_nci_send,
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 585a0f2..ac3796d 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -273,7 +273,7 @@ done:
 	return err;
 }
 
-static struct nfcmrvl_if_ops usb_ops = {
+static const struct nfcmrvl_if_ops usb_ops = {
 	.nci_open = nfcmrvl_usb_nci_open,
 	.nci_close = nfcmrvl_usb_nci_close,
 	.nci_send = nfcmrvl_usb_nci_send,

