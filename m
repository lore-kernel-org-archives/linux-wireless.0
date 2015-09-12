Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:40822 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754343AbbILH2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 03:28:41 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>
Subject: [[linux-nfc] PATCH v1.0 2/3] driver: nfc: st95hf: ST NFC Transceiver support
Date: Sat, 12 Sep 2015 03:21:34 -0400
Message-ID: <1442042495-2407-3-git-send-email-shikha.singh@st.com> (sfid-20150912_092845_195203_BAEE7827)
In-Reply-To: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
References: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Release of linux driver for STMicroelectronics NFC Transceiver
"ST95HF". This release of driver supports ST95HF in initiator
role to read/write ISO14443 Type A and ISO14443 Type B tags.

Signed-off-by: Shikha Singh <shikha.singh@st.com>
---
 drivers/nfc/Kconfig         |    1 +
 drivers/nfc/Makefile        |    1 +
 drivers/nfc/st95hf/Kconfig  |   11 +
 drivers/nfc/st95hf/Makefile |    6 +
 drivers/nfc/st95hf/spi.c    |  159 ++++++
 drivers/nfc/st95hf/spi.h    |   45 ++
 drivers/nfc/st95hf/st95hf.c | 1134 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1357 insertions(+)
 create mode 100644 drivers/nfc/st95hf/Kconfig
 create mode 100644 drivers/nfc/st95hf/Makefile
 create mode 100644 drivers/nfc/st95hf/spi.c
 create mode 100644 drivers/nfc/st95hf/spi.h
 create mode 100644 drivers/nfc/st95hf/st95hf.c

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 107714e..48e685b 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -74,4 +74,5 @@ source "drivers/nfc/nfcmrvl/Kconfig"
 source "drivers/nfc/st21nfca/Kconfig"
 source "drivers/nfc/st21nfcb/Kconfig"
 source "drivers/nfc/nxp-nci/Kconfig"
+source "drivers/nfc/st95hf/Kconfig"
 endmenu
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index a4292d79..1505c95 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_NFC_TRF7970A)	+= trf7970a.o
 obj-$(CONFIG_NFC_ST21NFCA)  	+= st21nfca/
 obj-$(CONFIG_NFC_ST21NFCB)	+= st21nfcb/
 obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
+obj-$(CONFIG_NFC_ST95HF)        += st95hf/
 
 ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/drivers/nfc/st95hf/Kconfig b/drivers/nfc/st95hf/Kconfig
new file mode 100644
index 0000000..745a2ce
--- /dev/null
+++ b/drivers/nfc/st95hf/Kconfig
@@ -0,0 +1,11 @@
+
+config NFC_ST95HF
+	tristate "ST95HF NFC Transceiver driver"
+	depends on SPI
+	help
+	This enables the ST NFC driver for ST95HF NFC transceiver.
+	This makes use of SPI framework to communicate with transceiver
+	and registered with NFC digital core to support Linux NFC framework.
+
+	Say Y here to compile support for ST NFC transceiver linux driver
+	into the kernel or say M to compile it as module.
diff --git a/drivers/nfc/st95hf/Makefile b/drivers/nfc/st95hf/Makefile
new file mode 100644
index 0000000..2d8f8f3
--- /dev/null
+++ b/drivers/nfc/st95hf/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for STMicroelectronics NFC transceiver ST95HF
+# #
+
+obj-$(CONFIG_NFC_ST95HF)	+= st_transceiver.o
+st_transceiver-objs		:= spi.o st95hf.o
diff --git a/drivers/nfc/st95hf/spi.c b/drivers/nfc/st95hf/spi.c
new file mode 100644
index 0000000..8e205e6
--- /dev/null
+++ b/drivers/nfc/st95hf/spi.c
@@ -0,0 +1,159 @@
+ /*
+  * ----------------------------------------------------------------------------
+  * drivers/nfc/st95hf/spi.c function definitions for  SPI communication
+  * ----------------------------------------------------------------------------
+  *
+  * Copyright (C) 2015 STMicroelectronics – All Rights Reserved
+  * Author: Shikha Singh <shikha.singh@st.com>
+  *
+  * May be copied or modified under the terms of the GNU General Public
+  * License Version 2.0 only. See linux/COPYING for more information.
+  *  ---------------------------------------------------------------------------
+  */
+
+#include <linux/of_gpio.h>
+#include "spi.h"
+
+/* Function to send user provided buffer to ST95HF through SPI */
+int spi_send_to_st95hf(struct spi_context *spicontext,
+		       unsigned char *buffertx, int datalen,
+		       enum req_type reqtype)
+{
+	struct spi_message m;
+	int result = 0;
+	struct spi_device *spidev = spicontext->spidev;
+	struct spi_transfer tx_transfer = {
+		.rx_buf = NULL,
+		.tx_buf = buffertx,
+		.len = datalen,
+		.cs_change = 0,
+		.bits_per_word = 0,
+		.delay_usecs = 0,
+		.speed_hz = 0,
+	};
+
+	spicontext->reply_from_st95 = 0;
+
+	if (reqtype == SYNC)
+		spicontext->req_issync = true;
+	else
+		spicontext->req_issync = false;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&tx_transfer, &m);
+
+	result = spi_sync(spidev, &m);
+	if (result) {
+		dev_err(&spidev->dev,
+			"error: sending cmd to st95hf using SPI\n");
+		return result;
+	}
+
+	if (reqtype == ASYNC) { /* return for asynchronous or no-wait case */
+		return 0;
+	}
+
+	do {
+		result = wait_event_interruptible_timeout(
+				spicontext->st95wait_queue,
+				spicontext->reply_from_st95 == 1,
+				1000);
+	} while (result < 0);
+
+	if (result == 0) {
+		dev_err(&spidev->dev, "error: response not ready timeout\n");
+		return -ETIMEDOUT;
+	}
+
+	if (result > 0)
+		result = 0;
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(spi_send_to_st95hf);
+
+/* Function to Receive command Response */
+int spi_receive_response(struct spi_context *spicontext,
+			 unsigned char *receivebuff,
+			 int *len)
+{
+	struct spi_transfer tx_takeresponse1;
+	struct spi_transfer tx_takeresponse2;
+	struct spi_transfer tx_takedata;
+	struct spi_message m;
+	unsigned char readdata_cmd = ST95HF_COMMAND_RECEIVE;
+	int ret = 0;
+
+	struct spi_device *spidev = spicontext->spidev;
+
+	*len = 0;
+
+	memset(&tx_takeresponse1, 0x0, sizeof(struct spi_transfer));
+	memset(&tx_takeresponse2, 0x0, sizeof(struct spi_transfer));
+	memset(&tx_takedata, 0x0, sizeof(struct spi_transfer));
+
+	tx_takeresponse1.tx_buf = &readdata_cmd;
+	tx_takeresponse1.len = 1;
+
+	tx_takeresponse2.rx_buf = receivebuff;
+	/* 1 byte  Response code + 1 byte  length of data */
+	tx_takeresponse2.len = 2;
+	/* Dont allow to make chipselect high */
+	tx_takeresponse2.cs_change = 1;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&tx_takeresponse1, &m);
+	spi_message_add_tail(&tx_takeresponse2, &m);
+
+	ret = spi_sync(spidev, &m);
+	if (ret)
+		return ret;
+
+	/* 2 bytes are already read */
+	*len = 2;
+
+	/*support of long frame*/
+	if (receivebuff[0] & 0x60)
+		*len += (((receivebuff[0] & 0x60) >> 5) << 8) | receivebuff[1];
+	else
+		*len += receivebuff[1];
+
+	/* Now make a transfer to take only relevant data */
+	tx_takedata.rx_buf = &receivebuff[2];
+	tx_takedata.len = (*len) - 2;
+	tx_takedata.cs_change = 0;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&tx_takedata, &m);
+
+	return spi_sync(spidev, &m);
+}
+EXPORT_SYMBOL_GPL(spi_receive_response);
+
+int spi_receive_echo_response(struct spi_context *spicontext,
+			      unsigned char *receivebuff)
+{
+	struct spi_transfer tx_takeresponse1;
+	struct spi_transfer tx_takedata;
+	struct spi_message m;
+	unsigned char readdata_cmd = ST95HF_COMMAND_RECEIVE;
+	struct spi_device *spidev = spicontext->spidev;
+
+	memset(&tx_takeresponse1, 0x0, sizeof(struct spi_transfer));
+	memset(&tx_takedata, 0x0, sizeof(struct spi_transfer));
+
+	tx_takeresponse1.tx_buf = &readdata_cmd;
+	tx_takeresponse1.len = 1;
+	tx_takeresponse1.rx_buf = NULL;
+
+	tx_takedata.rx_buf = receivebuff;
+	tx_takedata.tx_buf = NULL;
+	tx_takedata.len = 1;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&tx_takeresponse1, &m);
+	spi_message_add_tail(&tx_takedata, &m);
+
+	return spi_sync(spidev, &m);
+}
+EXPORT_SYMBOL_GPL(spi_receive_echo_response);
diff --git a/drivers/nfc/st95hf/spi.h b/drivers/nfc/st95hf/spi.h
new file mode 100644
index 0000000..aa3eea0d
--- /dev/null
+++ b/drivers/nfc/st95hf/spi.h
@@ -0,0 +1,45 @@
+ /*
+ * -----------------------------------------------------------------------------
+ * drivers/nfc/st95hf/spi.h functions declarations for SPI communication
+ * -----------------------------------------------------------------------------
+ *
+ * Copyright (C) 2015 STMicroelectronics – All Rights Reserved
+ * Author: Shikha Singh <shikha.singh@st.com>
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License Version 2.0 only. See linux/COPYING for more information.
+ *  ---------------------------------------------------------------------------
+ */
+
+#ifndef __LINUX_ST95HF_SPI_H
+#define __LINUX_ST95HF_SPI_H
+
+#include <linux/spi/spi.h>
+
+struct spi_context {
+	int reply_from_st95;
+	wait_queue_head_t st95wait_queue;
+	bool req_issync;
+	struct spi_device *spidev;
+};
+
+/* Flags to differentiate synchronous & asynchronous  request */
+enum req_type {
+	SYNC,
+	ASYNC,
+};
+
+#define	ST95HF_COMMAND_RECEIVE	0x02
+
+int spi_send_to_st95hf(struct spi_context *spicontext,
+		       unsigned char *buffertx, int datalen,
+		       enum req_type reqtype);
+
+int spi_receive_response(struct spi_context *spicontext,
+			 unsigned char *receivebuff,
+			 int *len);
+
+int spi_receive_echo_response(struct spi_context *spicontext,
+			      unsigned char *receivebuff);
+
+#endif
diff --git a/drivers/nfc/st95hf/st95hf.c b/drivers/nfc/st95hf/st95hf.c
new file mode 100644
index 0000000..1fa3cd5
--- /dev/null
+++ b/drivers/nfc/st95hf/st95hf.c
@@ -0,0 +1,1134 @@
+/*
+ * ----------------------------------------------------------------------------
+ * Driver for STNFC Transceiver (Role: 14443_A/B Tag Reader/Writer)
+ * ----------------------------------------------------------------------------
+ *
+ * Copyright (C) 2015 STMicroelectronics All Rights Reserved
+ * Author: Shikha Singh <shikha.singh@st.com>
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License Version 2.0 only. See linux/COPYING for more information.
+ *  ---------------------------------------------------------------------------
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/err.h>
+#include <linux/nfc.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
+#include <linux/netdevice.h>
+#include <linux/wait.h>
+#include <net/nfc/digital.h>
+#include <net/nfc/nfc.h>
+#include <linux/of.h>
+#include <linux/regulator/consumer.h>
+
+#include "spi.h"
+
+#define VERSION "0.1"
+
+/* Command Send Interface */
+/* Basic ST95HF SPI CMD Ids */
+#define	ST95HF_COMMAND_SEND 0x0
+#define	ST95HF_COMMAND_RESET 0x1
+
+/* ST95HF_COMMAND_SEND CMD Ids */
+#define ECHO_CMD 0x55
+#define WRITE_REGISTER_CMD 0x9
+#define PROTOCOL_SELECT_CMD 0x2
+#define SEND_RECEIVE_CMD 0x4
+
+/* High level cmd interface */
+#define MAX_CMD_PARAMS 4
+#define ISO14443A_PROTOCOL_CODE 0x2
+#define ISO14443B_PROTOCOL_CODE 0x3
+
+enum st95hf_cmd_list {
+	ECHO,
+	ISO14443A_CONFIG,
+	ISO14443A_DEMOGAIN,
+	ISO14443B_DEMOGAIN,
+	ISO14443A_PROTOCOL_SELECT,
+	ISO14443B_PROTOCOL_SELECT,
+	RESET,
+	WTX_RESPONSE,
+	FIELD_OFF,
+};
+
+struct cmd {
+	int cmd_len;
+	unsigned char cmd_id;
+	unsigned char no_cmd_params;
+	unsigned char cmd_params[MAX_CMD_PARAMS];
+	enum req_type req;
+};
+
+struct param_list {
+	int param_offset;
+	int new_param_val;
+};
+
+static const struct cmd cmd_array[] = {
+	{
+		.cmd_len = 0x2,
+		.cmd_id = ECHO_CMD,
+		.no_cmd_params = 0,
+		.req = SYNC,
+	},
+	{
+		.cmd_len = 0x7,
+		.cmd_id = WRITE_REGISTER_CMD,
+		.no_cmd_params = 0x4,
+		.cmd_params = {0x3A, 0x00, 0x5A, 0x04},
+		.req = SYNC,
+	},
+	{
+		.cmd_len = 0x7,
+		.cmd_id = WRITE_REGISTER_CMD,
+		.no_cmd_params = 0x4,
+		.cmd_params = {0x68, 0x01, 0x01, 0xDF},
+		.req = SYNC,
+	},
+	{
+		.cmd_len = 0x7,
+		.cmd_id = WRITE_REGISTER_CMD,
+		.no_cmd_params = 0x4,
+		.cmd_params = {0x68, 0x01, 0x01, 0x51},
+		.req = SYNC,
+	},
+	{
+		.cmd_len = 0x7,
+		.cmd_id = PROTOCOL_SELECT_CMD,
+		.no_cmd_params = 0x4,
+		.cmd_params = {ISO14443A_PROTOCOL_CODE, 0x00, 0x01, 0xA0},
+		.req = SYNC,
+	},
+	{
+		.cmd_len = 0x7,
+		.cmd_id = PROTOCOL_SELECT_CMD,
+		.no_cmd_params = 0x4,
+		.cmd_params = {ISO14443B_PROTOCOL_CODE, 0x01, 0x03, 0xFF},
+		.req = SYNC,
+	},
+	{
+		.cmd_len = 0x1,
+		.cmd_id = ST95HF_COMMAND_RESET,
+		.no_cmd_params = 0x0,
+		.req = ASYNC,
+	},
+	{
+		.cmd_len = 0x6,
+		.cmd_id = SEND_RECEIVE_CMD,
+		.no_cmd_params = 0x3,
+		.cmd_params = {0xF2, 0x00, 0x28},
+		.req = ASYNC,
+	},
+	{
+		.cmd_len = 0x5,
+		.cmd_id = PROTOCOL_SELECT_CMD,
+		.no_cmd_params = 0x2,
+		.cmd_params = {0x0, 0x0},
+		.req = SYNC,
+	},
+};
+
+#define MAX_CMD_LEN 0x7
+
+/*
+ * head room len is 3
+ * 1 byte for control byte
+ * 1 byte for cmd
+ * 1 byte for size
+ */
+#define	ST95HF_HEADROOM_LEN 3
+
+/*
+ * tailroom is 1 for ISO14443A
+ * and 0 for ISO14443B, hence the
+ * max value 1 should be taken
+ */
+#define	ST95HF_TAILROOM_LEN 1
+
+/* Command Response interface */
+#define	SELECT_PROTOCOL_RES_LEN 2
+#define	MAX_RESPONSE_BUFFER_SIZE 280
+#define	ECHORESPONSE 0x55
+#define WTX_REQ_FROM_TAG 0xF2
+
+/* ST95HF Driver defs */
+/* supported protocols */
+#define	ST95HF_SUPPORTED_PROT	(NFC_PROTO_ISO14443_MASK | \
+					NFC_PROTO_ISO14443_B_MASK)
+
+/* driver capabilities */
+#define ST95HF_CAPABILITIES	NFC_DIGITAL_DRV_CAPS_IN_CRC
+
+/* Misc defs */
+#define	HIGH 1
+#define	LOW 0
+#define ISO14443A_RATS_REQ 0xE0
+
+struct st95_digital_cmd_complete_arg {
+	struct sk_buff *skb_resp;
+	nfc_digital_cmd_complete_t complete_cb;
+	void *cb_usrarg;
+	bool rats;
+};
+
+/* Below structure contains driver specific data */
+struct st95hf_context {
+	struct spi_context spicontext;
+	struct nfc_digital_dev *ddev;
+	struct nfc_dev *nfcdev;
+	unsigned int st95hf_enable_gpio;
+	struct st95_digital_cmd_complete_arg *complete_cb_arg;
+	struct regulator *st95hf_supply;
+	unsigned char sendrcv_lastbyte;
+	u8 current_protocol;
+	u8 current_rf_tech;
+	int fwi;
+};
+
+/* Below helper functions to send command to ST95HF */
+static int st95hf_send_cmd(struct st95hf_context *stcontext,
+			   enum st95hf_cmd_list cmd,
+			   int no_modif,
+			   struct param_list *list_array)
+{
+	unsigned char spi_cmd_buffer[MAX_CMD_LEN];
+	int i;
+
+	if (cmd_array[cmd].cmd_len > MAX_CMD_LEN)
+		return -EINVAL;
+	if (cmd_array[cmd].no_cmd_params < no_modif)
+		return -EINVAL;
+	if (no_modif && !list_array)
+		return -EINVAL;
+
+	spi_cmd_buffer[0] = ST95HF_COMMAND_SEND;
+	spi_cmd_buffer[1] = cmd_array[cmd].cmd_id;
+	spi_cmd_buffer[2] = cmd_array[cmd].no_cmd_params;
+
+	memcpy(&spi_cmd_buffer[3], cmd_array[cmd].cmd_params,
+	       spi_cmd_buffer[2]);
+
+	for (i = 0; i < no_modif; i++) {
+		if (list_array[i].param_offset >= cmd_array[cmd].no_cmd_params)
+			return -EINVAL;
+		spi_cmd_buffer[3 + list_array[i].param_offset] =
+						list_array[i].new_param_val;
+	}
+
+	return spi_send_to_st95hf(&stcontext->spicontext,
+				  spi_cmd_buffer,
+				  cmd_array[cmd].cmd_len,
+				  cmd_array[cmd].req);
+}
+
+/*
+ * Below helper function to receive response from ST95HF when
+ * length of response is 2 bytes and 1st byte == 0x0 indicate success
+ */
+static int spi_receive_generic(struct st95hf_context *st95context)
+{
+	int result;
+	unsigned char st95hf_response_arr[2];
+	int response_length;
+	struct device *dev = &st95context->spicontext.spidev->dev;
+
+	result = spi_receive_response(&st95context->spicontext,
+				      st95hf_response_arr,
+				      &response_length);
+
+	if (result) {
+		dev_err(dev, "spi error spi_receive_generic(), err = 0x%x\n",
+			result);
+		return result;
+	}
+
+	if (st95hf_response_arr[0]) {
+		dev_err(dev, "st95hf error spi_receive_generic(), err = 0x%x\n",
+			st95hf_response_arr[0]);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int st95hf_echo_command(struct st95hf_context *st95context)
+{
+	int result = 0;
+	unsigned char echo_response;
+
+	result = st95hf_send_cmd(st95context, ECHO, 0, NULL);
+	if (result)
+		return result;
+
+	/* If control reached here, response can be taken */
+	result = spi_receive_echo_response(&st95context->spicontext,
+					   &echo_response);
+	if (result) {
+		dev_err(&st95context->spicontext.spidev->dev, "err: echo response receieve error\n");
+		return result;
+	}
+
+	if (echo_response == ECHORESPONSE)
+		return 0;
+
+	return -EIO;
+}
+
+static int st95hf_select_protocol(struct st95hf_context *stcontext, int type)
+{
+	int result = 0;
+	struct device *dev;
+
+	dev = &stcontext->nfcdev->dev;
+
+	switch (type) {
+	case NFC_DIGITAL_RF_TECH_106A:
+		stcontext->current_rf_tech = NFC_DIGITAL_RF_TECH_106A;
+		result = st95hf_send_cmd(stcontext,
+					 ISO14443A_PROTOCOL_SELECT,
+					 0,
+					 NULL);
+		if (result) {
+			dev_err(dev, "protocol sel send, err = 0x%x\n",
+				result);
+			return result;
+		}
+		break;
+	case NFC_DIGITAL_RF_TECH_106B:
+		stcontext->current_rf_tech = NFC_DIGITAL_RF_TECH_106B;
+		result = st95hf_send_cmd(stcontext,
+					 ISO14443B_PROTOCOL_SELECT,
+					 0,
+					 NULL);
+		if (result) {
+			dev_err(dev, "protocol sel send, err = 0x%x\n",
+				result);
+			return result;
+		}
+		break;
+	default:
+		/* This release supports only 14443 TypeA and TypeB */
+		return -EINVAL;
+	}
+
+	result = spi_receive_generic(stcontext);
+	if (result) {
+		dev_err(dev, "protocol sel response, err = 0x%x\n", result);
+		return result;
+	}
+	/* Check if 14443A/B then do some additional settings */
+	if (type == NFC_DIGITAL_RF_TECH_106A) {
+		/* 14443A config setting */
+		result = st95hf_send_cmd(stcontext, ISO14443A_CONFIG, 0, NULL);
+		if (result) {
+			dev_err(dev, "config cmd send, err = 0x%x\n", result);
+			return result;
+		}
+
+		result = spi_receive_generic(stcontext);
+		if (result) {
+			dev_err(dev, "config cmd response, err = 0x%x\n",
+				result);
+			return result;
+		}
+
+		/* Demo gain setting for type 4a */
+		result = st95hf_send_cmd(stcontext,
+					 ISO14443A_DEMOGAIN,
+					 0,
+					 NULL);
+		if (result) {
+			dev_err(dev, "demogain cmd send, err = 0x%x\n", result);
+			return result;
+		}
+
+		result = spi_receive_generic(stcontext);
+		if (result) {
+			dev_err(dev, "demogain cmd response, err = 0x%x\n",
+				result);
+			return result;
+		}
+	}
+
+	if (type == NFC_DIGITAL_RF_TECH_106B) {
+		/*
+		 * some delay is required after select protocol
+		 * command in case of ISO14443 Type B
+		 */
+		usleep_range(50000, 60000);
+
+		result = st95hf_send_cmd(stcontext,
+					 ISO14443B_DEMOGAIN,
+					 0,
+					 NULL);
+		if (result) {
+			dev_err(dev, "type b demogain cmd send, err = 0x%x\n",
+				result);
+			return result;
+		}
+
+		result = spi_receive_generic(stcontext);
+		if (result) {
+			dev_err(dev, "type b demogain cmd response, err = 0x%x\n",
+				result);
+			return result;
+		}
+	}
+
+	return 0;
+}
+
+static void st95hf_send_st95enable_negativepulse(struct st95hf_context *st95con)
+{
+	/* First make irq_in pin high */
+	gpio_set_value(st95con->st95hf_enable_gpio, HIGH);
+
+	/* wait for 1 milisecond */
+	usleep_range(1000, 2000);
+
+	/* Make irq_in pin low */
+	gpio_set_value(st95con->st95hf_enable_gpio, LOW);
+
+	/* wait for minimum interrupt pulse to make st95 active */
+	usleep_range(1000, 2000); /* wait for 1 milisecond */
+
+	/* At end make it high */
+	gpio_set_value(st95con->st95hf_enable_gpio, HIGH);
+}
+
+/*
+ * Send a reset sequence over SPI bus (Reset command + wait 3ms +
+ * negative pulse on st95hf enable gpio
+ */
+static int st95hf_send_spi_reset_sequence(struct st95hf_context *st95context)
+{
+	int result = 0;
+
+	result = st95hf_send_cmd(st95context, RESET, 0, NULL);
+	if (result) {
+		dev_err(&st95context->spicontext.spidev->dev,
+			"spi reset sequence cmd error = %d", result);
+		return result;
+	}
+
+	/* wait for 3 milisecond to complete the controller reset process */
+	usleep_range(3000, 4000);
+
+	/* send negative pulse to make st95hf active */
+	st95hf_send_st95enable_negativepulse(st95context);
+
+	/* wait for 10 milisecond : HFO setup time */
+	usleep_range(10000, 20000);
+
+	return result;
+}
+
+static int st95hf_por_sequence(struct st95hf_context *st95context)
+{
+	int nth_attempt = 1;
+	int result;
+
+	st95hf_send_st95enable_negativepulse(st95context);
+
+	usleep_range(5000, 6000);
+	do {
+		/* send an ECHO command and checks ST95HF response */
+		result = st95hf_echo_command(st95context);
+
+		dev_dbg(&st95context->spicontext.spidev->dev,
+			"response from echo function = 0x%x, attempt = %d\n",
+			result, nth_attempt);
+
+		if (!result)
+			return 0;
+
+		/* send an pulse on IRQ in case of the chip is on sleep state */
+		if (nth_attempt == 2)
+			st95hf_send_st95enable_negativepulse(st95context);
+		else
+			st95hf_send_spi_reset_sequence(st95context);
+
+		/* delay of 50 milisecond */
+		usleep_range(50000, 51000);
+	} while (nth_attempt++ < 3);
+
+	return -ETIMEDOUT;
+}
+
+static int iso14443_config_fdt(struct st95hf_context *st95context, int wtxm)
+{
+	int result = 0;
+	struct device *dev = &st95context->spicontext.spidev->dev;
+	struct nfc_digital_dev *nfcddev = st95context->ddev;
+	unsigned char pp_typeb;
+	struct param_list new_params[2];
+
+	pp_typeb = cmd_array[ISO14443B_PROTOCOL_SELECT].cmd_params[2];
+
+	if (nfcddev->curr_protocol == NFC_PROTO_ISO14443) {
+		if (st95context->fwi < 4)
+			st95context->fwi = 4;
+	}
+
+	new_params[0].param_offset = 2;
+	if (nfcddev->curr_protocol == NFC_PROTO_ISO14443)
+		new_params[0].new_param_val = st95context->fwi;
+	else if (nfcddev->curr_protocol == NFC_PROTO_ISO14443_B)
+		new_params[0].new_param_val = pp_typeb;
+
+	new_params[1].param_offset = 3;
+	new_params[1].new_param_val = wtxm;
+
+	if (nfcddev->curr_protocol == NFC_PROTO_ISO14443)
+		result = st95hf_send_cmd(st95context,
+					 ISO14443A_PROTOCOL_SELECT,
+					 2,
+					 new_params);
+	else if (nfcddev->curr_protocol == NFC_PROTO_ISO14443_B)
+		result = st95hf_send_cmd(st95context,
+					 ISO14443B_PROTOCOL_SELECT,
+					 2,
+					 new_params);
+	if (result) {
+		dev_err(dev, "WTX select protocol cmd send, err = 0x%x\n",
+			result);
+		return result;
+	}
+
+	result = spi_receive_generic(st95context);
+	if (result) {
+		dev_err(dev, "WTX select protocol response, err = 0x%x\n",
+			result);
+		return result;
+	}
+
+	if (nfcddev->curr_protocol == NFC_PROTO_ISO14443) {
+		result = st95hf_send_cmd(st95context,
+					 ISO14443A_CONFIG,
+					 0,
+					 NULL);
+		if (result) {
+			dev_err(dev, "WTX config cmd send, err = 0x%x\n",
+				result);
+			return result;
+		}
+		result = spi_receive_generic(st95context);
+		if (result) {
+			dev_err(dev, "WTX config cmd response, err = 0x%x\n",
+				result);
+			return result;
+		}
+	}
+
+	if (nfcddev->curr_protocol == NFC_PROTO_ISO14443)
+		result = st95hf_send_cmd(st95context,
+					 ISO14443A_DEMOGAIN,
+					 0,
+					 NULL);
+	else if (nfcddev->curr_protocol == NFC_PROTO_ISO14443_B)
+		result = st95hf_send_cmd(st95context,
+					 ISO14443B_DEMOGAIN,
+					 0,
+					 NULL);
+	if (result) {
+		dev_err(dev, "WTX demogain cmd send, err = 0x%x\n", result);
+		return result;
+	}
+
+	result = spi_receive_generic(st95context);
+	if (result) {
+		dev_err(dev, "WTX demogain cmd response, err = 0x%x\n", result);
+		return result;
+	}
+
+	return 0;
+}
+
+static irqreturn_t irq_handler(int irq, void  *st95hfcontext)
+{
+	struct st95hf_context *stcontext  =
+		(struct st95hf_context *)st95hfcontext;
+
+	if (stcontext->spicontext.req_issync) {
+		stcontext->spicontext.reply_from_st95 = 1;
+		wake_up_interruptible(&stcontext->spicontext.st95wait_queue);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t irq_thread_handler(int irq, void  *st95hfcontext)
+{
+	int result;
+	int res_len;
+	int skb_len;
+	static bool wtx;
+	struct param_list new_params[1];
+	struct st95hf_context *stcontext  =
+		(struct st95hf_context *)st95hfcontext;
+	unsigned char error_byte;
+	struct device *dev = &stcontext->nfcdev->dev;
+	struct nfc_digital_dev *nfcddev = stcontext->ddev;
+	unsigned char val_mm;
+
+	struct st95_digital_cmd_complete_arg *cb_arg =
+		stcontext->complete_cb_arg;
+
+	if (!cb_arg) {
+		dev_err(dev, "cb_arg is NULL in threaded ISR\n");
+		BUG();
+	}
+
+	result = spi_receive_response(&stcontext->spicontext,
+				      cb_arg->skb_resp->data,
+				      &res_len);
+	if (result) {
+		dev_err(dev, "res receive threaded ISR err = 0x%x\n", result);
+		goto end;
+	}
+
+	if (*((cb_arg->skb_resp->data) + 2) == WTX_REQ_FROM_TAG) {
+		/* Request for new FWT from tag */
+		result = iso14443_config_fdt(stcontext,
+					     (*((cb_arg->skb_resp->data) + 3)
+						& 0x3f));
+		if (result) {
+			dev_err(dev, "Config. setting error on WTX req, err = 0x%x\n",
+				result);
+			goto end;
+		}
+		wtx = true;
+
+		/* ASYNC req as no response expected */
+		new_params[0].param_offset = 1;
+		new_params[0].new_param_val =
+			*((cb_arg->skb_resp->data) + 3);
+
+		result = st95hf_send_cmd(stcontext,
+					 WTX_RESPONSE,
+					 1,
+					 new_params);
+		if (result) {
+			dev_err(dev, "WTX response send, err = 0x%x\n", result);
+			goto end;
+		}
+		return IRQ_HANDLED;
+	}
+
+	/* First check ST95HF specific error */
+	if ((*cb_arg->skb_resp->data) & 0xf) {
+		dev_err(dev, "st95hf, err code = 0x%x, len of data received = %d\n",
+			*cb_arg->skb_resp->data,
+			*(cb_arg->skb_resp->data + 1));
+
+		result = -EIO;
+		goto end;
+	}
+
+	/* Check for CRC err only if CRC is present in the tag response */
+	switch (stcontext->current_rf_tech) {
+	case NFC_DIGITAL_RF_TECH_106A:
+		if (stcontext->sendrcv_lastbyte == 0x28) {
+			error_byte = *(cb_arg->skb_resp->data + res_len - 3);
+			if (error_byte & 0x20) {
+				/* CRC error occurred */
+				dev_err(dev, "CRC byte rec frame = 0x%x\n",
+					error_byte);
+				result = -EIO;
+				goto end;
+			}
+		}
+		break;
+	case NFC_DIGITAL_RF_TECH_106B:
+		error_byte = *(cb_arg->skb_resp->data + res_len - 1);
+		if (error_byte & 0x01) {
+			/* CRC error occurred */
+			dev_err(dev, "CRC byte rec frame = 0x%x\n", error_byte);
+			result = -EIO;
+			goto end;
+		}
+		break;
+	}
+
+	/* Process the response */
+	skb_put(cb_arg->skb_resp, res_len);
+	/* Remove st95 header */
+	skb_pull(cb_arg->skb_resp, 2);
+
+	skb_len = cb_arg->skb_resp->len;
+
+	/* check if it is case of RATS request reply & FWI is present */
+	if (nfcddev->curr_protocol == NFC_PROTO_ISO14443 && cb_arg->rats) {
+		/* if FWI is present, check format byte */
+		if ((*(cb_arg->skb_resp->data + 1) & 0x20) == 0x20) {
+			if ((*(cb_arg->skb_resp->data + 1) & 0x10) == 0x10)
+				stcontext->fwi =
+					(*(cb_arg->skb_resp->data + 3) & 0xF0)
+					>> 4;
+			else
+				stcontext->fwi =
+					(*(cb_arg->skb_resp->data + 2) & 0xF0)
+					>> 4;
+		}
+
+		val_mm = cmd_array[ISO14443A_PROTOCOL_SELECT].cmd_params[3];
+
+		result = iso14443_config_fdt(stcontext, val_mm);
+		if (result) {
+			dev_err(dev, "error in config_fdt to handle fwi of ATS, error=%d\n",
+				result);
+			goto end;
+		}
+	}
+
+	/* Remove CRC bytes only if received frames data has an eod (CRC) */
+	switch (stcontext->current_rf_tech) {
+	case NFC_DIGITAL_RF_TECH_106A:
+		if (stcontext->sendrcv_lastbyte == 0x28)
+			skb_trim(cb_arg->skb_resp, (skb_len - 5));
+		else
+			skb_trim(cb_arg->skb_resp, (skb_len - 3));
+		break;
+	case NFC_DIGITAL_RF_TECH_106B:
+		skb_trim(cb_arg->skb_resp, (skb_len - 3));
+		break;
+	}
+
+	/*
+	 * If select protocol is done on wtx req. do select protocol
+	 * again with default values
+	 */
+	if (wtx) {
+		wtx = false;
+		if (nfcddev->curr_protocol == NFC_PROTO_ISO14443) {
+			val_mm = cmd_array[ISO14443A_PROTOCOL_SELECT].
+					cmd_params[3];
+			result = iso14443_config_fdt(stcontext, val_mm);
+		} else if (nfcddev->curr_protocol ==
+					NFC_PROTO_ISO14443_B) {
+			val_mm = cmd_array[ISO14443B_PROTOCOL_SELECT].
+					cmd_params[3];
+			result = iso14443_config_fdt(stcontext, val_mm);
+		}
+		if (result) {
+			dev_err(dev, "Default config. setting error after WTX processing, err = 0x%x\n",
+				result);
+			goto end;
+		}
+	}
+
+	/* Call of provided callback */
+	cb_arg->complete_cb(stcontext->ddev,
+			cb_arg->cb_usrarg,
+			cb_arg->skb_resp);
+
+	kfree(cb_arg);
+	stcontext->complete_cb_arg = NULL;
+
+	return IRQ_HANDLED;
+
+end:
+	kfree_skb(cb_arg->skb_resp);
+	cb_arg->skb_resp = ERR_PTR(result);
+	cb_arg->complete_cb(stcontext->ddev,
+			    cb_arg->cb_usrarg,
+			    cb_arg->skb_resp);
+	kfree(cb_arg);
+	stcontext->complete_cb_arg = NULL;
+	wtx = false;
+
+	return IRQ_HANDLED;
+}
+
+/* NFC ops functions definition */
+int st95hf_in_configure_hw(struct nfc_digital_dev *ddev, int type, int param)
+{
+	struct st95hf_context *stcontext = nfc_digital_get_drvdata(ddev);
+
+	if (type == NFC_DIGITAL_CONFIG_RF_TECH)
+		return st95hf_select_protocol(stcontext, param);
+
+	if (type == NFC_DIGITAL_CONFIG_FRAMING) {
+		switch (param) {
+		case NFC_DIGITAL_FRAMING_NFCA_SHORT:
+			stcontext->sendrcv_lastbyte = 0x07;
+			break;
+		case NFC_DIGITAL_FRAMING_NFCA_STANDARD:
+			stcontext->sendrcv_lastbyte = 0x08;
+			break;
+		case NFC_DIGITAL_FRAMING_NFCA_T4T:
+		case NFC_DIGITAL_FRAMING_NFCA_NFC_DEP:
+		case NFC_DIGITAL_FRAMING_NFCA_STANDARD_WITH_CRC_A:
+			stcontext->sendrcv_lastbyte = 0x28;
+			break;
+		case NFC_DIGITAL_FRAMING_NFCB:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int rf_off(struct st95hf_context *stcontext)
+{
+	int rc;
+	struct device *dev;
+
+	dev = &stcontext->nfcdev->dev;
+
+	rc = st95hf_send_cmd(stcontext, FIELD_OFF, 0, NULL);
+	if (rc) {
+		dev_err(dev, "protocol sel send fielf off, err = 0x%x\n",
+			rc);
+		return rc;
+	}
+
+	rc = spi_receive_generic(stcontext);
+	if (rc) {
+		dev_err(dev, "protocol sel response, err = 0x%x\n", rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
+		       struct sk_buff *skb,
+		       u16 timeout,
+		       nfc_digital_cmd_complete_t cb,
+		       void *arg)
+{
+	struct st95hf_context *stcontext = nfc_digital_get_drvdata(ddev);
+	int rc;
+	struct sk_buff *skb_resp;
+	struct st95_digital_cmd_complete_arg *cb_arg;
+	int len_data_to_tag = 0;
+	unsigned char *temp;
+
+	skb_resp = alloc_skb(MAX_RESPONSE_BUFFER_SIZE, GFP_KERNEL);
+	if (!skb_resp) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
+	switch (stcontext->current_rf_tech) {
+	case NFC_DIGITAL_RF_TECH_106A:
+		len_data_to_tag = skb->len + 1;
+		temp = skb_put(skb, 1);
+		*(temp) = stcontext->sendrcv_lastbyte;
+		break;
+	case NFC_DIGITAL_RF_TECH_106B:
+		len_data_to_tag = skb->len;
+		break;
+	default:
+		rc = -EINVAL;
+		goto free_skb_resp;
+	}
+
+	skb_push(skb, 3);
+	*((unsigned char *)(skb->data)) = ST95HF_COMMAND_SEND;
+	*((unsigned char *)(skb->data) + 1) = SEND_RECEIVE_CMD;
+	*((unsigned char *)(skb->data) + 2) = len_data_to_tag;
+
+	cb_arg = kzalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg) {
+		rc = -ENOMEM;
+		goto free_skb_resp;
+	}
+
+	cb_arg->skb_resp = skb_resp;
+	cb_arg->cb_usrarg = arg;
+	cb_arg->complete_cb = cb;
+	if ((*((skb->data) + 3) == ISO14443A_RATS_REQ) &&
+	    ddev->curr_protocol == NFC_PROTO_ISO14443)
+		cb_arg->rats = true;
+
+	/* save received arg in st95hf context */
+	stcontext->complete_cb_arg = cb_arg;
+
+	rc = spi_send_to_st95hf(&stcontext->spicontext, skb->data,
+				skb->len,
+				ASYNC);
+	if (rc) {
+		nfc_err(&stcontext->nfcdev->dev,
+			"Error %d trying to perform data_exchange", rc);
+		goto free_arg;
+	}
+
+	kfree_skb(skb);
+	return rc;
+
+free_arg:
+	kfree(cb_arg);
+	stcontext->complete_cb_arg = NULL;
+free_skb_resp:
+	kfree_skb(skb_resp);
+error:
+	kfree_skb(skb);
+
+	return rc;
+}
+
+/* p2p will be supported in a later release ! */
+int st95hf_tg_configure_hw(struct nfc_digital_dev *ddev, int type, int param)
+{
+	return 0;
+}
+
+int st95hf_tg_send_cmd(struct nfc_digital_dev *ddev,
+		       struct sk_buff *skb,
+		       u16 timeout,
+		       nfc_digital_cmd_complete_t cb,
+		       void *arg)
+{
+	return 0;
+}
+
+int st95hf_tg_listen(struct nfc_digital_dev *ddev,
+		     u16 timeout,
+		     nfc_digital_cmd_complete_t cb,
+		     void *arg)
+{
+	return 0;
+}
+
+int st95hf_tg_get_rf_tech(struct nfc_digital_dev *ddev, u8 *rf_tech)
+{
+	return 0;
+}
+
+int st95hf_switch_rf(struct nfc_digital_dev *ddev, bool on)
+{
+	u8 rf_tech;
+	struct st95hf_context *stcontext = nfc_digital_get_drvdata(ddev);
+
+	rf_tech = ddev->curr_rf_tech;
+
+	if (on)
+		/* switch on RF field */
+		return st95hf_select_protocol(stcontext, rf_tech);
+
+	/* switch OFF RF field */
+	return rf_off(stcontext);
+}
+
+/* TODO st95hf_abort_cmd */
+void st95hf_abort_cmd(struct nfc_digital_dev *ddev)
+{
+}
+
+static struct nfc_digital_ops st95hf_nfc_digital_ops = {
+	.in_configure_hw = st95hf_in_configure_hw,
+	.in_send_cmd = st95hf_in_send_cmd,
+
+	.tg_listen = st95hf_tg_listen,
+	.tg_configure_hw = st95hf_tg_configure_hw,
+	.tg_send_cmd = st95hf_tg_send_cmd,
+	.tg_get_rf_tech = st95hf_tg_get_rf_tech,
+
+	.switch_rf = st95hf_switch_rf,
+	.abort_cmd = st95hf_abort_cmd,
+};
+
+static const struct spi_device_id st95hf_id[] = {
+	{ "st95hf", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(spi, st95hf_id);
+
+void tag_deactivation(struct nfc_dev *nfcdev)
+{
+	struct nfc_digital_dev *digitaldev;
+
+	digitaldev = (struct nfc_digital_dev *)dev_get_drvdata(&nfcdev->dev);
+
+	nfcdev->active_target = NULL;
+
+	digitaldev->curr_protocol = 0x0;
+}
+
+static int st95hf_probe(struct spi_device *nfc_spi_dev)
+{
+	int ret;
+
+	struct st95hf_context *st95context;
+	struct spi_context *spicontext;
+	struct device_node *np = nfc_spi_dev->dev.of_node;
+
+	pr_info("ST SPI SLAVE DRIVER (ST95HF R/W 14443A/B) PROBE CALLED\n");
+
+	st95context = devm_kzalloc(&nfc_spi_dev->dev,
+				   sizeof(struct st95hf_context),
+				   GFP_KERNEL);
+	if (!st95context)
+		return -ENOMEM;
+
+	spicontext = &st95context->spicontext;
+
+	spicontext->spidev = nfc_spi_dev;
+
+	st95context->fwi = cmd_array[ISO14443A_PROTOCOL_SELECT].cmd_params[2];
+
+	if (of_get_property(np, "st95hfvin-supply", NULL)) {
+		st95context->st95hf_supply =
+			devm_regulator_get(&nfc_spi_dev->dev, "st95hfvin");
+		if (IS_ERR(st95context->st95hf_supply)) {
+			dev_err(&nfc_spi_dev->dev, "failed to acquire regulator\n");
+			return PTR_ERR(st95context->st95hf_supply);
+		}
+
+		ret = regulator_enable(st95context->st95hf_supply);
+		if (ret) {
+			dev_err(&nfc_spi_dev->dev, "failed to enable regulator\n");
+			return ret;
+		}
+	}
+
+	init_waitqueue_head(&spicontext->st95wait_queue);
+
+	/*
+	 * Store spicontext in spi device object for using it in
+	 * remove & resume function
+	 */
+	dev_set_drvdata(&nfc_spi_dev->dev, spicontext);
+
+	st95context->st95hf_enable_gpio =
+		of_get_named_gpio(nfc_spi_dev->dev.of_node,
+				  "st,st95hf-enable-gpio",
+				  0);
+	if (st95context->st95hf_enable_gpio < 0) {
+		ret = st95context->st95hf_enable_gpio;
+		goto regulator_clean;
+	}
+
+	ret = gpio_request(st95context->st95hf_enable_gpio,
+			   "st95hf_enable_gpio");
+	if (ret)
+		goto regulator_clean;
+
+	ret = gpio_direction_output(st95context->st95hf_enable_gpio, 1);
+	if (ret)
+		goto free_enable_gpio;
+
+	if (nfc_spi_dev->irq > 0) {
+		if (devm_request_threaded_irq(&nfc_spi_dev->dev,
+					      nfc_spi_dev->irq,
+					      irq_handler,
+					      irq_thread_handler,
+					      IRQF_SHARED,
+					      "st95hf",
+					      (void *)st95context) < 0) {
+			dev_err(&nfc_spi_dev->dev, "err: irq request for st95hf is failed\n");
+			ret =  -ENODEV;
+			goto free_enable_gpio;
+		}
+	}
+
+	/*
+	 * Send negative pulse to make st95hf active if last reset occur
+	 * while in Tag detection low power state
+	 */
+	st95hf_send_st95enable_negativepulse(st95context);
+
+	/*
+	 * First reset SPI to handle hot reset and recurrent make run command
+	 * It will put the device in Power ON state which make the state of
+	 * device identical to state at the time of cold reset
+	 */
+	ret = st95hf_send_spi_reset_sequence(st95context);
+	if (ret) {
+		dev_err(&nfc_spi_dev->dev, "err: spi_reset_sequence failed\n");
+		goto free_enable_gpio;
+	}
+
+	/*  call PowerOnReset sequence of ST95hf to activate it */
+	ret = st95hf_por_sequence(st95context);
+	if (ret) {
+		dev_err(&nfc_spi_dev->dev, "err: por seq failed for st95hf\n");
+		goto free_enable_gpio;
+	}
+
+	/* Create NFC dev object and register with NFC Subsystem */
+	st95context->ddev = nfc_digital_allocate_device(&st95hf_nfc_digital_ops,
+							ST95HF_SUPPORTED_PROT,
+							ST95HF_CAPABILITIES,
+							ST95HF_HEADROOM_LEN,
+							ST95HF_TAILROOM_LEN);
+	if (!st95context->ddev) {
+		ret = -ENOMEM;
+		goto free_enable_gpio;
+	}
+
+	st95context->nfcdev = st95context->ddev->nfc_dev;
+
+	ret =  nfc_digital_register_device(st95context->ddev);
+	if (ret) {
+		nfc_digital_free_device(st95context->ddev);
+		goto free_enable_gpio;
+	}
+
+	/* store st95context in nfc device object */
+	nfc_digital_set_drvdata(st95context->ddev, st95context);
+
+	return ret;
+
+free_enable_gpio:
+	gpio_free(st95context->st95hf_enable_gpio);
+regulator_clean:
+	if (st95context->st95hf_supply)
+		regulator_disable(st95context->st95hf_supply);
+	return ret;
+}
+
+static int st95hf_remove(struct spi_device *nfc_spi_dev)
+{
+	struct spi_context *spictx = dev_get_drvdata(&nfc_spi_dev->dev);
+
+	struct st95hf_context *stcontext = container_of(spictx,
+							struct st95hf_context,
+							spicontext);
+	if (stcontext) {
+		/* unregister nfc device */
+		nfc_digital_unregister_device(stcontext->ddev);
+
+		/* free the nfc device object */
+		nfc_digital_free_device(stcontext->ddev);
+
+		/* free GPIO pins */
+		gpio_free(stcontext->st95hf_enable_gpio);
+
+		/* disable regulator */
+		if (stcontext->st95hf_supply)
+			regulator_disable(stcontext->st95hf_supply);
+	}
+
+	return 0;
+}
+
+/* Register as SPI protocol driver */
+static struct spi_driver st95hf_driver = {
+	.driver = {
+		.name = "st95hf",
+		.owner = THIS_MODULE,
+	},
+	.id_table = st95hf_id,
+	.probe = st95hf_probe,
+	.remove = st95hf_remove,
+};
+
+/* module_spi_driver is helpler macro for registering a SPI driver */
+module_spi_driver(st95hf_driver);
+
+MODULE_AUTHOR("Shikha Singh <shikha.singh@st.com>");
+MODULE_DESCRIPTION("ST95HF SPI protocol driver ver " VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL v2");
-- 
1.8.2.1

