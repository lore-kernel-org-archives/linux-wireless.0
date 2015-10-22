Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbbJVGY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 02:24:56 -0400
Date: Thu, 22 Oct 2015 08:24:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha Singh <shikha.singh@st.com>
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	raunaque.quaiser@st.com, manoj.kumar@st.com,
	sylvain.fidelis@st.com, patrick.sohn@st.com
Subject: Re: [[linux-nfc] PATCH v1.0 2/3] driver: nfc: st95hf: ST NFC
 Transceiver support
Message-ID: <20151022062452.GI11271@zurbaran.home> (sfid-20151022_082501_127210_6B818F30)
References: <1442042495-2407-1-git-send-email-shikha.singh@st.com>
 <1442042495-2407-3-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1442042495-2407-3-git-send-email-shikha.singh@st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shikha,

On Sat, Sep 12, 2015 at 03:21:34AM -0400, Shikha Singh wrote:
> diff --git a/drivers/nfc/st95hf/Makefile b/drivers/nfc/st95hf/Makefile
> new file mode 100644
> index 0000000..2d8f8f3
> --- /dev/null
> +++ b/drivers/nfc/st95hf/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for STMicroelectronics NFC transceiver ST95HF
> +# #
> +
> +obj-$(CONFIG_NFC_ST95HF)	+= st_transceiver.o
We should be more specific and call it st_nfc_transceiver for example.


> +/* Function to send user provided buffer to ST95HF through SPI */
> +int spi_send_to_st95hf(struct spi_context *spicontext,
> +		       unsigned char *buffertx, int datalen,
> +		       enum req_type reqtype)
To be consistent with the rest of your API, this one should be called
st95hf_spi_send(). It obviously implies that it is sending packets to
the transceiver.


> +{
> +	struct spi_message m;
> +	int result = 0;
> +	struct spi_device *spidev = spicontext->spidev;
> +	struct spi_transfer tx_transfer = {
> +		.rx_buf = NULL,
> +		.tx_buf = buffertx,
> +		.len = datalen,
> +		.cs_change = 0,
> +		.bits_per_word = 0,
> +		.delay_usecs = 0,
> +		.speed_hz = 0,
> +	};
You don't need to explicitely set those fields to NULL or 0, this one
could be simplified to:

struct spi_transfer t = { .tx_buf = buffertx, .len = datalen, };


> +	spicontext->reply_from_st95 = 0;
> +
> +	if (reqtype == SYNC)
> +		spicontext->req_issync = true;
> +	else
> +		spicontext->req_issync = false;
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&tx_transfer, &m);
> +
> +	result = spi_sync(spidev, &m);
> +	if (result) {
> +		dev_err(&spidev->dev,
> +			"error: sending cmd to st95hf using SPI\n");
> +		return result;
> +	}
> +
> +	if (reqtype == ASYNC) { /* return for asynchronous or no-wait case */
> +		return 0;
> +	}
> +
> +	do {
> +		result = wait_event_interruptible_timeout(
> +				spicontext->st95wait_queue,
> +				spicontext->reply_from_st95 == 1,
> +				1000);
> +	} while (result < 0);
If result is < 0 it means your transfer got interrupted by a signal,
there is no point in looping around result. You may just want to return
result in that case.

A couple more comments here:

- A completion is probably enough for what you're trying to achieve.
- This is racy: If you have 2 threads calling spi_send_to_st95hf() at
  the same time they may end up waiting on the waitqueue at the same
  time as well. The first interrupt that comes will wake both at the
  same time although it should not.
  In order to avoid that race, you need to synchronize the calls to
  spi_sync with e.g. a mutex so that you don't issue an spi_sync while
  someone is already on the waitqueue or sleeping for completion.

> +
> +	if (result == 0) {
> +		dev_err(&spidev->dev, "error: response not ready timeout\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	if (result > 0)
> +		result = 0;
> +
> +	return result;
> +}
> +EXPORT_SYMBOL_GPL(spi_send_to_st95hf);
> +
> +/* Function to Receive command Response */
> +int spi_receive_response(struct spi_context *spicontext,
> +			 unsigned char *receivebuff,
> +			 int *len)
2 things:

- Let's call that one st95hf_spi_recv_response()
- It typically should return the number of read bytes, instead of
  passing a len pointer to the argument list.


> +{
> +	struct spi_transfer tx_takeresponse1;
> +	struct spi_transfer tx_takeresponse2;
> +	struct spi_transfer tx_takedata;
> +	struct spi_message m;
> +	unsigned char readdata_cmd = ST95HF_COMMAND_RECEIVE;
> +	int ret = 0;
> +
> +	struct spi_device *spidev = spicontext->spidev;
> +
> +	*len = 0;
> +
> +	memset(&tx_takeresponse1, 0x0, sizeof(struct spi_transfer));
> +	memset(&tx_takeresponse2, 0x0, sizeof(struct spi_transfer));
> +	memset(&tx_takedata, 0x0, sizeof(struct spi_transfer));
> +
> +	tx_takeresponse1.tx_buf = &readdata_cmd;
> +	tx_takeresponse1.len = 1;
> +
> +	tx_takeresponse2.rx_buf = receivebuff;
> +	/* 1 byte  Response code + 1 byte  length of data */
> +	tx_takeresponse2.len = 2;
> +	/* Dont allow to make chipselect high */
> +	tx_takeresponse2.cs_change = 1;
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&tx_takeresponse1, &m);
> +	spi_message_add_tail(&tx_takeresponse2, &m);

So this whole block of code could be simplified to:

struct spi_transfer t[2] = { { .tx_buf = &readdata_cmd, .len = 1, },
                             { .rx_buf = receive_buff,  .len = 2 , .cs_change = 1, }, };

spi_message_init(&m);
spi_message_add_tail(&t[0], &m);
spi_message_add_tail(&t[1], &m);

> +	ret = spi_sync(spidev, &m);
> +	if (ret)
> +		return ret;
> +
> +	/* 2 bytes are already read */
> +	*len = 2;
> +
> +	/*support of long frame*/
Nitpick: Please add a space after /* and before */


> +	if (receivebuff[0] & 0x60)
> +		*len += (((receivebuff[0] & 0x60) >> 5) << 8) | receivebuff[1];
> +	else
> +		*len += receivebuff[1];
> +
> +	/* Now make a transfer to take only relevant data */
> +	tx_takedata.rx_buf = &receivebuff[2];
> +	tx_takedata.len = (*len) - 2;
> +	tx_takedata.cs_change = 0;
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&tx_takedata, &m);
> +
> +	return spi_sync(spidev, &m);
> +}
> +EXPORT_SYMBOL_GPL(spi_receive_response);
> +
> +int spi_receive_echo_response(struct spi_context *spicontext,
> +			      unsigned char *receivebuff)
Similar comment, please call it st95hf_recv_echo().


> +{
> +	struct spi_transfer tx_takeresponse1;
> +	struct spi_transfer tx_takedata;
> +	struct spi_message m;
> +	unsigned char readdata_cmd = ST95HF_COMMAND_RECEIVE;
> +	struct spi_device *spidev = spicontext->spidev;
> +
> +	memset(&tx_takeresponse1, 0x0, sizeof(struct spi_transfer));
> +	memset(&tx_takedata, 0x0, sizeof(struct spi_transfer));
> +
> +	tx_takeresponse1.tx_buf = &readdata_cmd;
> +	tx_takeresponse1.len = 1;
> +	tx_takeresponse1.rx_buf = NULL;
> +
> +	tx_takedata.rx_buf = receivebuff;
> +	tx_takedata.tx_buf = NULL;
> +	tx_takedata.len = 1;
> +
> +	spi_message_init(&m);
> +	spi_message_add_tail(&tx_takeresponse1, &m);
> +	spi_message_add_tail(&tx_takedata, &m);
Similar comment as well, this can be simplified as described above.

> +	return spi_sync(spidev, &m);
> +}
> +EXPORT_SYMBOL_GPL(spi_receive_echo_response);
> diff --git a/drivers/nfc/st95hf/spi.h b/drivers/nfc/st95hf/spi.h
> new file mode 100644
> index 0000000..aa3eea0d
> --- /dev/null
> +++ b/drivers/nfc/st95hf/spi.h
> @@ -0,0 +1,45 @@
> + /*
> + * -----------------------------------------------------------------------------
> + * drivers/nfc/st95hf/spi.h functions declarations for SPI communication
> + * -----------------------------------------------------------------------------
> + *
> + * Copyright (C) 2015 STMicroelectronics – All Rights Reserved
> + * Author: Shikha Singh <shikha.singh@st.com>
> + *
> + * May be copied or modified under the terms of the GNU General Public
> + * License Version 2.0 only. See linux/COPYING for more information.
> + *  ---------------------------------------------------------------------------
> + */
> +
> +#ifndef __LINUX_ST95HF_SPI_H
> +#define __LINUX_ST95HF_SPI_H
> +
> +#include <linux/spi/spi.h>
> +
> +struct spi_context {
struct st95hf_spi_context would be more apropriate.

> +	int reply_from_st95;
> +	wait_queue_head_t st95wait_queue;
I think those 2 can easily be replaced by a simple completion structure.


> +static irqreturn_t irq_handler(int irq, void  *st95hfcontext)
> +{
> +	struct st95hf_context *stcontext  =
> +		(struct st95hf_context *)st95hfcontext;
> +
> +	if (stcontext->spicontext.req_issync) {
> +		stcontext->spicontext.reply_from_st95 = 1;
> +		wake_up_interruptible(&stcontext->spicontext.st95wait_queue);
> +		return IRQ_HANDLED;
> +	}
> +
> +	return IRQ_WAKE_THREAD;
> +}
Do you really need a specific IRQ handler for that ? Can't you do it
from the threaded interrupt context ?


> +static irqreturn_t irq_thread_handler(int irq, void  *st95hfcontext)
> +{
> +	int result;
> +	int res_len;
> +	int skb_len;
> +	static bool wtx;
> +	struct param_list new_params[1];
> +	struct st95hf_context *stcontext  =
> +		(struct st95hf_context *)st95hfcontext;
> +	unsigned char error_byte;
> +	struct device *dev = &stcontext->nfcdev->dev;
> +	struct nfc_digital_dev *nfcddev = stcontext->ddev;
> +	unsigned char val_mm;
> +
> +	struct st95_digital_cmd_complete_arg *cb_arg =
> +		stcontext->complete_cb_arg;
> +
> +	if (!cb_arg) {
> +		dev_err(dev, "cb_arg is NULL in threaded ISR\n");
> +		BUG();
> +	}
> +
> +	result = spi_receive_response(&stcontext->spicontext,
> +				      cb_arg->skb_resp->data,
> +				      &res_len);
> +	if (result) {
> +		dev_err(dev, "res receive threaded ISR err = 0x%x\n", result);
> +		goto end;
> +	}
> +
> +	if (*((cb_arg->skb_resp->data) + 2) == WTX_REQ_FROM_TAG) {
> +		/* Request for new FWT from tag */
FWT ?


> +		result = iso14443_config_fdt(stcontext,
> +					     (*((cb_arg->skb_resp->data) + 3)
> +						& 0x3f));
> +		if (result) {
> +			dev_err(dev, "Config. setting error on WTX req, err = 0x%x\n",
> +				result);
> +			goto end;
> +		}
> +		wtx = true;
> +
> +		/* ASYNC req as no response expected */
> +		new_params[0].param_offset = 1;
> +		new_params[0].new_param_val =
> +			*((cb_arg->skb_resp->data) + 3);
> +
> +		result = st95hf_send_cmd(stcontext,
> +					 WTX_RESPONSE,
> +					 1,
> +					 new_params);
> +		if (result) {
> +			dev_err(dev, "WTX response send, err = 0x%x\n", result);
> +			goto end;
> +		}
> +		return IRQ_HANDLED;
> +	}
A few comments:

- You probably want to define a struct sk_buff *skb_resp =
  cb_arg->skb_resp
- *((cb_arg->skb_resp->data) + 2) becomes skb_resp->data[2]
- This handler is almost 200 lines of code long, it could be splitted in
  smaller routines:
	* One for handling FWT from tag
	* One for handling I/O errors
	* One for actually processing the response


> +static struct nfc_digital_ops st95hf_nfc_digital_ops = {
> +	.in_configure_hw = st95hf_in_configure_hw,
> +	.in_send_cmd = st95hf_in_send_cmd,
> +
> +	.tg_listen = st95hf_tg_listen,
> +	.tg_configure_hw = st95hf_tg_configure_hw,
> +	.tg_send_cmd = st95hf_tg_send_cmd,
> +	.tg_get_rf_tech = st95hf_tg_get_rf_tech,
> +
> +	.switch_rf = st95hf_switch_rf,
> +	.abort_cmd = st95hf_abort_cmd,
All the above ops can be static.


> +static int st95hf_probe(struct spi_device *nfc_spi_dev)
> +{
> +	int ret;
> +
> +	struct st95hf_context *st95context;
> +	struct spi_context *spicontext;
> +	struct device_node *np = nfc_spi_dev->dev.of_node;
> +
> +	pr_info("ST SPI SLAVE DRIVER (ST95HF R/W 14443A/B) PROBE CALLED\n");
> +
> +	st95context = devm_kzalloc(&nfc_spi_dev->dev,
> +				   sizeof(struct st95hf_context),
> +				   GFP_KERNEL);
> +	if (!st95context)
> +		return -ENOMEM;
> +
> +	spicontext = &st95context->spicontext;
> +
> +	spicontext->spidev = nfc_spi_dev;
> +
> +	st95context->fwi = cmd_array[ISO14443A_PROTOCOL_SELECT].cmd_params[2];
> +
> +	if (of_get_property(np, "st95hfvin-supply", NULL)) {
Please use device_property_present to be firmware API agnostic.

Cheers,
Samuel.
