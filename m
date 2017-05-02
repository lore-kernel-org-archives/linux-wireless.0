Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:13619 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbdEBGE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 02:04:28 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <linux-wireless@vger.kernel.org>,
        <linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
        <sylvain.fidelis@st.com>, <raphael.collado@st.com>,
        <shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc][PATCH v1] 4/6] NFC: nfcst: Add ST NFC SPI Driver
Date: Tue, 2 May 2017 02:03:41 -0400
Message-ID: <1493705023-8710-5-git-send-email-shikha.singh@st.com> (sfid-20170502_080448_676304_54C27624)
In-Reply-To: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
References: <1493705023-8710-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support of ST NFC transceiver controlled over SPI.

This driver enables ST NFC transceiver to communicate
with host over SPI interface and as a phy driver it
registers with ST NFC transceiver core framework.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 drivers/nfc/nfcst/Kconfig  |  15 ++
 drivers/nfc/nfcst/Makefile |   3 +
 drivers/nfc/nfcst/spi.c    | 493 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 511 insertions(+)
 create mode 100644 drivers/nfc/nfcst/spi.c

diff --git a/drivers/nfc/nfcst/Kconfig b/drivers/nfc/nfcst/Kconfig
index 70fec4f..73549cd 100644
--- a/drivers/nfc/nfcst/Kconfig
+++ b/drivers/nfc/nfcst/Kconfig
@@ -32,3 +32,18 @@ config NFC_ST_UART
 
          Say Y here to compile support for ST NFC-over-UART driver
          into the kernel or say M to compile it as module.
+
+config NFC_ST_SPI
+       tristate "ST NFC-over-SPI driver"
+       depends on SPI && NFC_DIGITAL
+       select NFC_ST
+       help
+         ST NFC-over-SPI driver.
+
+         This SPI slave driver is an ST NFC transceiver driver that
+         communicates with host processor over SPI interface.
+
+         Say Y here to compile support for ST NFC-over-SPI driver
+         into the kernel or say M to compile it as module.
+
+
diff --git a/drivers/nfc/nfcst/Makefile b/drivers/nfc/nfcst/Makefile
index a90055a..adefcec 100644
--- a/drivers/nfc/nfcst/Makefile
+++ b/drivers/nfc/nfcst/Makefile
@@ -7,3 +7,6 @@ obj-$(CONFIG_NFC_ST) += nfcst.o
 
 nfcst_uart-y += uart.o
 obj-$(CONFIG_NFC_ST_UART) += nfcst_uart.o
+
+nfcst_spi-y += spi.o
+obj-$(CONFIG_NFC_ST_SPI) += nfcst_spi.o
diff --git a/drivers/nfc/nfcst/spi.c b/drivers/nfc/nfcst/spi.c
new file mode 100644
index 0000000..68317db
--- /dev/null
+++ b/drivers/nfc/nfcst/spi.c
@@ -0,0 +1,493 @@
+/*
+ * --------------------------------------------------------------------
+ * SPI Driver for ST NFC Transceiver
+ * --------------------------------------------------------------------
+ * Copyright (C) 2016 STMicroelectronics Pvt. Ltd. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/of.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/of_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/netdevice.h>
+#include <linux/module.h>
+#include <net/nfc/nfc.h>
+#include "stnfcdev.h"
+
+#define HIGH	1
+#define LOW	0
+
+#define NFCST_SPI_SEND_CTRLBYTE	0x0
+#define NFCST_SPI_RESET_CMD	0x1
+#define NFCST_SPI_RECV_CTRLBYTE	0x2
+
+#define NFCST_RESET_CMD_LEN	0x1
+
+/*
+ * structure to contain ST NFC spi communication specific information.
+ * @spidev: ST NFC spi device object.
+ * @spi_lock: mutex to allow only one spi transfer at a time.
+ * @nfc_ctx: nfcst core context.
+ * @nfcdev_free: flag to check if driver remove is called.
+ * @rm_lock: mutex for ensuring safe access of nfc digital object
+ *	from threaded ISR. Usage of this mutex avoids any race between
+ *	deletion of the object from nfcst_spi_remove() and its access from
+ *	the threaded ISR.
+ * @nfcdev_free: flag to have the state of nfc device object.
+ *	[alive | died]
+
+ */
+struct nfcst_spi_context {
+	struct spi_device *spidev;
+	struct mutex spi_lock;
+	void *nfc_ctx;
+	struct mutex rm_lock;
+	bool nfcdev_free;
+};
+
+/* Function to send user provided buffer to NFC transceiver through SPI */
+static int nfcst_spi_send(void *phy_ctx, struct sk_buff *skb)
+{
+	int result = 0;
+	struct spi_message m;
+
+	struct nfcst_spi_context *spictx = (struct nfcst_spi_context *)phy_ctx;
+	unsigned char ctrl_byte = NFCST_SPI_SEND_CTRLBYTE;
+	struct spi_device *spidev = spictx->spidev;
+	struct spi_transfer tx_spictrl;
+	struct spi_transfer tx_buffer;
+
+	memset(&tx_spictrl, 0x0, sizeof(struct spi_transfer));
+	memset(&tx_buffer, 0x0, sizeof(struct spi_transfer));
+
+	tx_spictrl.len = 1;
+	tx_spictrl.tx_buf = &ctrl_byte;
+	tx_spictrl.cs_change = 1;
+
+	tx_buffer.len = skb->len;
+	tx_buffer.tx_buf = skb->data;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&tx_spictrl, &m);
+
+	mutex_lock(&spictx->spi_lock);
+	result = spi_sync(spidev, &m);
+	if (result) {
+		dev_err(&spidev->dev, "spi_send ctrl err = %d\n", result);
+		goto end;
+	}
+
+	spi_message_init(&m);
+	spi_message_add_tail(&tx_buffer, &m);
+	result = spi_sync(spidev, &m);
+	if (result)
+		dev_err(&spidev->dev, "SPI sending data err = %d\n", result);
+
+end:
+	mutex_unlock(&spictx->spi_lock);
+	kfree_skb(skb);
+	return result;
+}
+
+static int nfcst_spi_reset_send(struct nfcst_spi_context *spictx)
+{
+	int result = 0;
+	struct spi_message m;
+	struct spi_device *spidev = spictx->spidev;
+	unsigned char reset_cmd = NFCST_SPI_RESET_CMD;
+	struct spi_transfer reset_transfer;
+
+	memset(&reset_transfer, 0x0, sizeof(struct spi_transfer));
+	reset_transfer.tx_buf = &reset_cmd;
+	reset_transfer.len = NFCST_RESET_CMD_LEN;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&reset_transfer, &m);
+
+	mutex_lock(&spictx->spi_lock);
+	result = spi_sync(spidev, &m);
+	if (result)
+		dev_err(&spidev->dev,
+			"error: spi reset send error = 0x%x\n", result);
+
+	mutex_unlock(&spictx->spi_lock);
+	return result;
+}
+
+/* Function to Receive Response from taransceiver
+ * On success, this function will return length of data read.
+ * In case of error it returns -EIO.
+ */
+static int nfcst_spi_recv_resp(void *phy_ctx,
+			       struct sk_buff *receivebuff)
+{
+	int ret = 0;
+	int header_len;
+	int payload_len;
+	int already_read = 0;
+	int total_expected_len = 0;
+	struct spi_transfer tx_takedata;
+	struct spi_transfer tx_takehdr;
+	struct spi_transfer tx_dummy;
+	struct spi_message m;
+	unsigned char readdata_cmd = NFCST_SPI_RECV_CTRLBYTE;
+	struct nfcst_spi_context *spictx = (struct nfcst_spi_context *)phy_ctx;
+	struct spi_device *spidev = spictx->spidev;
+	struct spi_transfer t[2];
+
+	memset(&tx_takedata, 0x0, sizeof(struct spi_transfer));
+	memset(&tx_takehdr, 0x0, sizeof(struct spi_transfer));
+	memset(&tx_dummy, 0x0, sizeof(struct spi_transfer));
+	memset(&t[0], 0x0, sizeof(struct spi_transfer));
+	memset(&t[1], 0x0, sizeof(struct spi_transfer));
+
+	t[0].tx_buf = &readdata_cmd;
+	t[0].len = 1;
+	t[1].rx_buf = receivebuff->data;
+	t[1].len = 1;
+	t[1].cs_change = 1;
+
+	/* First spi transfer to receive first byte */
+	spi_message_init(&m);
+	spi_message_add_tail(&t[0], &m);
+	spi_message_add_tail(&t[1], &m);
+
+	mutex_lock(&spictx->spi_lock);
+	ret = spi_sync(spidev, &m);
+	if (ret) {
+		dev_err(&spidev->dev, "spi_recv_resp, spi recv err = %d\n",
+			ret);
+		goto end;
+	}
+	already_read = 1;
+
+	/* Determine the header length with help of first byte */
+	header_len = nfcst_recv_hdr_len(spictx, receivebuff->data,
+					already_read);
+	if (header_len < 0) {
+		dev_err(&spidev->dev, "spi_recv_resp, invalid recv frame\n");
+		goto end;
+	}
+	/* Read header */
+	if (header_len > already_read) {
+		tx_takehdr.rx_buf = &receivebuff->data[already_read];
+		tx_takehdr.len = header_len - already_read;
+		tx_takehdr.cs_change = 1;
+		spi_message_init(&m);
+		spi_message_add_tail(&tx_takehdr, &m);
+		ret = spi_sync(spidev, &m);
+		if (ret) {
+			dev_err(&spidev->dev,
+				"spi_recv_resp, header read error = %d\n", ret);
+			goto end;
+		}
+		already_read = header_len;
+	}
+
+	payload_len = nfcst_recv_fr_len(spictx, receivebuff->data,
+					already_read);
+	total_expected_len = header_len + payload_len;
+	if (already_read == total_expected_len) {
+		/* transfer for cs_change */
+		spi_message_init(&m);
+		spi_message_add_tail(&tx_dummy, &m);
+		ret = spi_sync(spidev, &m);
+		if (ret) {
+			dev_err(&spidev->dev, "spi dummy transfer error\n");
+			goto end;
+		}
+	}
+
+	/* Now make transfer to read complete data */
+	if (total_expected_len > already_read) {
+		tx_takedata.rx_buf = &receivebuff->data[already_read];
+		tx_takedata.len = payload_len;
+		spi_message_init(&m);
+		spi_message_add_tail(&tx_takedata, &m);
+		ret = spi_sync(spidev, &m);
+		if (ret) {
+			dev_err(&spidev->dev, "spi_recv_resp, data read error = %d\n",
+				ret);
+			goto end;
+		}
+		already_read = total_expected_len;
+	}
+
+	skb_put(receivebuff, already_read);
+	mutex_unlock(&spictx->spi_lock);
+
+	return already_read;
+
+end:
+	mutex_unlock(&spictx->spi_lock);
+	return -EIO;
+}
+
+static irqreturn_t nfcst_spi_irq_thread_handler(int irq, void *phyctx)
+{
+	int result = 0;
+	int max_frame_sz;
+	struct sk_buff *skb_resp;
+	struct nfcst_spi_context *spictx = (struct nfcst_spi_context *)phyctx;
+
+	mutex_lock(&spictx->rm_lock);
+	if (spictx->nfcdev_free) {
+		dev_err(&spictx->spidev->dev,
+			"nfcst_spi_remove is already called\n");
+		mutex_unlock(&spictx->rm_lock);
+		return IRQ_HANDLED;
+	}
+
+	max_frame_sz = nfcst_recv_max_fr_sz(spictx->nfc_ctx);
+	skb_resp = nfc_alloc_recv_skb(max_frame_sz, GFP_KERNEL);
+	if (skb_resp) {
+		result = nfcst_spi_recv_resp(spictx, skb_resp);
+		if (result < 0)
+			kfree_skb(skb_resp);
+	} else {
+		result = -ENOMEM;
+	}
+	if (result < 0)
+		skb_resp = ERR_PTR(result);
+
+	/* nfcst_recv_frame will never return error */
+	nfcst_recv_frame(spictx->nfc_ctx, skb_resp);
+	mutex_unlock(&spictx->rm_lock);
+	return IRQ_HANDLED;
+}
+
+static struct nfcst_if_ops spi_ops = {
+	.phy_send = nfcst_spi_send,
+};
+
+static int nfcst_spi_parse_dt(struct spi_device *nfc_spi_dev,
+			      struct nfcst_pltf_data *pdata)
+{
+	int ret = 0;
+
+	if (device_property_present(&nfc_spi_dev->dev, "nfcstvin")) {
+		pdata->nfcst_supply =
+			devm_regulator_get(&nfc_spi_dev->dev,
+					   "nfcstvin");
+		if (IS_ERR(pdata->nfcst_supply)) {
+			dev_err(&nfc_spi_dev->dev, "failed to acquire regulator\n");
+			return PTR_ERR(pdata->nfcst_supply);
+		}
+
+		ret = regulator_enable(pdata->nfcst_supply);
+		if (ret) {
+			dev_err(&nfc_spi_dev->dev, "failed to enable regulator\n");
+			return ret;
+		}
+	}
+
+	pdata->enable_gpio =
+		of_get_named_gpio(nfc_spi_dev->dev.of_node,
+				  "enable-gpio",
+				  0);
+	if (!gpio_is_valid(pdata->enable_gpio)) {
+		dev_err(&nfc_spi_dev->dev, "No valid enable gpio\n");
+		ret = pdata->enable_gpio;
+		goto err_disable_regulator;
+	}
+
+	ret = devm_gpio_request_one(&nfc_spi_dev->dev, pdata->enable_gpio,
+				    GPIOF_DIR_OUT | GPIOF_INIT_HIGH,
+				    "enable_gpio");
+	if (ret)
+		goto err_disable_regulator;
+
+	return 0;
+
+err_disable_regulator:
+	if (pdata->nfcst_supply)
+		regulator_disable(pdata->nfcst_supply);
+	return ret;
+}
+
+static void nfcst_spi_enable_negativepulse(struct nfcst_spi_context *spictx)
+{
+	struct nfcst_pltf_data *pdata;
+
+	pdata = nfcst_pltf_data(spictx->nfc_ctx);
+
+	/* First make irq_in pin high */
+	gpio_set_value(pdata->enable_gpio, HIGH);
+
+	/* wait for 1 milisecond */
+	usleep_range(1000, 2000);
+
+	/* Make irq_in pin low */
+	gpio_set_value(pdata->enable_gpio, LOW);
+
+	/* wait for minimum interrupt pulse to make ST transceiver active */
+	usleep_range(1000, 2000);
+
+	/* At end make it high */
+	gpio_set_value(pdata->enable_gpio, HIGH);
+}
+
+/*
+ * Send a reset sequence over SPI bus (Reset command + wait 3ms +
+ * negative pulse on Transceiver's gpio)
+ */
+static int nfcst_spi_reset_sequence(struct nfcst_spi_context *spictx)
+{
+	int result = 0;
+
+	result = nfcst_spi_reset_send(spictx);
+	if (result) {
+		dev_err(&spictx->spidev->dev,
+			"spi reset sequence error\n");
+		return result;
+	}
+	/* wait for 3 milisecond to complete the controller reset process */
+	usleep_range(3000, 4000);
+
+	/* send negative pulse to make ST NFC transceiver active */
+	nfcst_spi_enable_negativepulse(spictx);
+
+	/* wait for 10 milisecond : HFO setup time */
+	usleep_range(10000, 20000);
+
+	return result;
+}
+
+static const struct spi_device_id nfc_st_spi_id[] = {
+	{ "stnfc", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(spi, nfc_st_spi_id);
+
+static int nfcst_spi_probe(struct spi_device *nfc_spi_dev)
+{
+	int ret;
+	void *priv;
+	struct nfcst_spi_context *spictx;
+	struct nfcst_pltf_data config;
+	struct nfcst_pltf_data *pdata = NULL;
+
+	nfc_info(&nfc_spi_dev->dev, "nfc_st_spi driver probe called\n");
+
+	spictx = devm_kzalloc(&nfc_spi_dev->dev,
+			      sizeof(struct nfcst_spi_context),
+			      GFP_KERNEL);
+	if (!spictx)
+		ret = -ENOMEM;
+
+	spictx->spidev = nfc_spi_dev;
+	mutex_init(&spictx->spi_lock);
+	mutex_init(&spictx->rm_lock);
+
+	dev_set_drvdata(&nfc_spi_dev->dev, spictx);
+
+	ret = nfcst_spi_parse_dt(nfc_spi_dev, &config);
+	if (ret) {
+		dev_err(&nfc_spi_dev->dev, "Error in getting st nfc spi platform data from DT\n");
+		return ret;
+	}
+	pdata = &config;
+
+	priv = nfcst_register_phy(PHY_SPI, (void *)spictx, &spi_ops,
+				  &nfc_spi_dev->dev, pdata);
+	if (IS_ERR(priv)) {
+		ret = PTR_ERR(priv);
+		goto error;
+	}
+	spictx->nfc_ctx = priv;
+
+	if (nfc_spi_dev->irq > 0) {
+		if (devm_request_threaded_irq(&nfc_spi_dev->dev,
+					      nfc_spi_dev->irq,
+					      NULL,
+					      nfcst_spi_irq_thread_handler,
+					      IRQF_TRIGGER_FALLING |
+					      IRQF_ONESHOT,
+					      "nfcst",
+					      (void *)spictx) < 0) {
+			dev_err(&nfc_spi_dev->dev, "err: irq request for nfc_st_spi is failed\n");
+			ret =  -EINVAL;
+			goto error;
+		}
+	} else {
+		dev_err(&nfc_spi_dev->dev, "not a valid IRQ associated with ST NFC\n");
+		ret = -EINVAL;
+		goto error;
+	}
+
+	/* Enable transceiver and do SPI reset to initialize HW */
+	nfcst_spi_enable_negativepulse(spictx);
+	usleep_range(5000, 6000);
+	ret = nfcst_spi_reset_sequence(spictx);
+	usleep_range(50000, 51000);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	if (pdata->nfcst_supply)
+		regulator_disable(pdata->nfcst_supply);
+	return ret;
+}
+
+static int nfcst_spi_remove(struct spi_device *nfc_spi_dev)
+{
+	int result = 0;
+	struct nfcst_spi_context *spictx = dev_get_drvdata(&nfc_spi_dev->dev);
+	struct nfcst_pltf_data *pdata;
+
+	mutex_lock(&spictx->rm_lock);
+	nfcst_unregister_phy(spictx->nfc_ctx);
+	spictx->nfcdev_free = true;
+	mutex_unlock(&spictx->rm_lock);
+
+	/* wait for completion of currently running interrupt handler
+	 * and disable upcoming interrupts
+	 */
+	disable_irq(nfc_spi_dev->irq);
+
+	/* Reset the ST NFC controller */
+	result = nfcst_spi_reset_send(spictx);
+	if (result) {
+		dev_err(&spictx->spidev->dev,
+			"stnfc reset failed from remove() err = %d\n", result);
+		return result;
+	}
+
+	/* disable regulator */
+	pdata = nfcst_pltf_data(spictx->nfc_ctx);
+	if (pdata->nfcst_supply)
+		regulator_disable(spictx->nfc_ctx);
+	return result;
+}
+
+/* Register as SPI protocol driver */
+static struct spi_driver stnfc_spi_driver = {
+	.driver = {
+		.name = "stnfc",
+		.owner = THIS_MODULE,
+	},
+	.id_table = nfc_st_spi_id,
+	.probe = nfcst_spi_probe,
+	.remove = nfcst_spi_remove,
+};
+
+module_spi_driver(stnfc_spi_driver);
+
+MODULE_AUTHOR("Shikha Singh <shikha.singh@st.com>");
+MODULE_DESCRIPTION("ST NFC-over-SPI");
+MODULE_LICENSE("GPL v2");
-- 
1.8.2.1
