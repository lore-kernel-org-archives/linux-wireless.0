Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaA3Tiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 14:38:46 -0500
Message-ID: <1391110756.698.51.camel@dcbw.local> (sfid-20140130_203856_551061_E6319352)
Subject: Re: [PATCH 3.13.1 6/9] rsi: Initialization and SDbus related files
From: Dan Williams <dcbw@redhat.com>
To: Jahnavi <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Jan 2014 13:39:16 -0600
In-Reply-To: <52EA75F4.60701@redpinesignals.com>
References: <52EA75F4.60701@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 21:25 +0530, Jahnavi wrote:
> From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> 
> This patch has the loading of firmware, SDbus related functions
> and the module initialization related functions.
> 
> Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> ---
> 
> Makefile          |    9 
> rsi_91x_dev_ops.c |  661 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> rsi_91x_main.c    |   94 +++++++
> 3 files changed, 764 insertions(+)
> 
> diff -uprN a/drivers/net/wireless/rsi/91x/Makefile b/drivers/net/wireless/rsi/91x/Makefile
> --- a/drivers/net/wireless/rsi/91x/Makefile	1970-01-01 05:30:00.000000000 +0530
> +++ b/drivers/net/wireless/rsi/91x/Makefile	2014-01-30 16:25:13.800523737 +0530
> @@ -0,0 +1,9 @@
> +ifeq ($(CONFIG_RSI_USB), y)
> +	ccflags-y =-DUSE_USB_INTF
> +else
> +	ccflags-y =-DUSE_SDIO_INTF
> +endif
> +ccflags-y += -Iinclude/
> +rsi_91x-y := rsi_91x_mac80211.o rsi_91x_mgmt.o rsi_91x_pkt.o \
> +	     rsi_91x_dev_ops.o rsi_91x_main.o
> +obj-$(CONFIG_RSI_91x) := rsi_91x.o
> diff -uprN a/drivers/net/wireless/rsi/91x/rsi_91x_dev_ops.c b/drivers/net/wireless/rsi/91x/rsi_91x_dev_ops.c
> --- a/drivers/net/wireless/rsi/91x/rsi_91x_dev_ops.c	1970-01-01 05:30:00.000000000 +0530
> +++ b/drivers/net/wireless/rsi/91x/rsi_91x_dev_ops.c	2014-01-30 16:25:13.803524118 +0530
> @@ -0,0 +1,661 @@
> +/**
> + * @file rsi_91x_dev_ops.c
> + * @author
> + * @version 1.0
> + *
> + * @section LICENSE
> + * Copyright (c) 2013 Redpine Signals Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + *
> + * @section DESCRIPTION
> + *
> + * The file contains the initialization part of the SDBus driver and Loading of
> + * the TA firmware.
> + */
> +
> +#include <linux/firmware.h>
> +#include "../include/rsi_main.h"
> +#include "../include/rsi_hw_intf.h"
> +#include "../include/rsi_device_ops.h"
> +
> +static struct ta_metadata {
> +	unsigned char *name;
> +	unsigned int address;
> +} metadata[] = {
> +	{"rsi_91x.fw", 0x00000000},
> +};

I have to believe the USB firmware is different than the SDIO firmware.
Give them different names (rsi_91x-usb.fw and rsi91x-sd.fw) and have
each bus type's code pass the name to the generic firmware loader.  Then
use MODULE_FIRMWARE in each of the bus code's files.

Unless this is something like calibration data or regulatory data, and
the devices don't actually need a firmware download to start doing
normal wifi things?

> +
> +/**
> + * This function prepares the skb.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @param  buffer Pointer to the packet data.
> + * @param  pkt_len Length of the packet.
> + * @param  extended_desc Extended descriptor.
> + * @return Successfully created netbuf control block.
> + */
> +static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
> +				       unsigned char *buffer,
> +				       unsigned int pkt_len,
> +				       unsigned char extended_desc)
> +{
> +	struct ieee80211_tx_info *info;
> +	struct skb_info *rx_params;
> +	struct sk_buff *skb = NULL;
> +	unsigned char payload_offset;
> +
> +	if (!pkt_len) {
> +		rsi_dbg(ERR_ZONE, "%s: Dummy pkt has come in\n", __func__);
> +		return NULL;
> +	}
> +
> +	if (pkt_len > (RSI_RCV_BUFFER_LEN * 4)) {
> +		rsi_dbg(ERR_ZONE, "%s: Toooo big packet %d\n", __func__,
> +			pkt_len);
> +		pkt_len = RSI_RCV_BUFFER_LEN * 4;
> +	}
> +
> +	if ((pkt_len < RSI_HEADER_SIZE) || (pkt_len < MIN_802_11_HDR_LEN)) {
> +		rsi_dbg(ERR_ZONE, "%s: Too small packet %d\n", __func__,
> +			pkt_len);
> +	}
> +
> +	pkt_len -= extended_desc;
> +	skb = dev_alloc_skb(pkt_len + FRAME_DESC_SZ);
> +	if (skb == NULL)
> +		return NULL;
> +
> +	payload_offset = (extended_desc + FRAME_DESC_SZ);
> +	skb_put(skb, pkt_len);
> +	memcpy((skb->data), (buffer + payload_offset), skb->len);
> +
> +	info = IEEE80211_SKB_CB(skb);
> +	rx_params = (struct skb_info *)info->driver_data;
> +	rx_params->rssi = rsi_get_rssi(buffer);
> +	rx_params->channel = rsi_get_connected_channel(common->priv);
> +
> +	return skb;
> +}
> +
> +/**
> + * This function read frames from the SD card.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @return 0 on success, -1 on failure.
> + */
> +static int rsi_read_pkt(struct rsi_common *common)
> +{
> +#ifdef USE_SDIO_INTF
> +	struct rsi_hw *adapter = common->priv;
> +	struct rsi_common_ops *common_ops = common->common_ops;
> +	unsigned char num_blks = 0;
> +	unsigned int rcv_pkt_len = 0;
> +	int status = 0;
> +#endif
> +	unsigned char *frame_desc = NULL;
> +	unsigned int index, length = 0;
> +	unsigned short actual_length = 0, offset;
> +	struct sk_buff *skb = NULL;
> +	unsigned int queueno;
> +	unsigned char extended_desc;
> +
> +#ifdef USE_SDIO_INTF
> +	status = common_ops->read_register(adapter,
> +					   SDIO_RX_NUM_BLOCKS_REG,
> +					   &num_blks);
> +
> +	if (status) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Failed to read pkt length from the card:\n",
> +			__func__);
> +		return status;
> +	}
> +	rcv_pkt_len = (num_blks * 256);
> +
> +	common->rx_data_pkt = kmalloc(rcv_pkt_len, GFP_KERNEL);
> +	if (!common->rx_data_pkt) {
> +		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
> +			__func__);
> +		return -1;
> +	}
> +
> +	status = common_ops->host_intf_read_pkt(adapter,
> +						common->rx_data_pkt,
> +						rcv_pkt_len);
> +	if (status) {
> +		rsi_dbg(ERR_ZONE, "%s: Failed to read packet from card\n",
> +			__func__);
> +		goto fail;
> +	}
> +#endif
> +	index = 0;
> +	do {
> +		frame_desc = &common->rx_data_pkt[index];
> +		actual_length = *(unsigned short *)&frame_desc[0];
> +		offset = *(unsigned short *)&frame_desc[2];
> +
> +		queueno = rsi_get_queueno(frame_desc, offset);
> +		length = rsi_get_length(frame_desc, offset);
> +		extended_desc = rsi_get_extended_desc(frame_desc, offset);
> +
> +		switch (queueno) {
> +		case RSI_WIFI_DATA_Q:
> +			skb = rsi_prepare_skb(common,
> +					      (frame_desc + offset),
> +					      length,
> +					      extended_desc);
> +			if (skb == NULL)
> +				goto fail;
> +
> +			rsi_indicate_pkt_to_os(common, skb);
> +			break;
> +
> +		case RSI_WIFI_MGMT_Q:
> +			rsi_mgmt_pkt_recv(common, (frame_desc + offset));
> +			break;
> +
> +		default:
> +			rsi_dbg(ERR_ZONE, "%s: pkt from invalid queue: %d\n",
> +				__func__,   queueno);
> +			common->common_ops->print(ERR_ZONE,
> +						  common->rx_data_pkt,
> +						  200);
> +			goto fail;
> +		}
> +
> +		index  += actual_length;
> +#ifdef USE_USB_INTF
> +	} while (0);
> +#else
> +		rcv_pkt_len -= actual_length;
> +	} while (rcv_pkt_len);
> +	kfree(common->rx_data_pkt);
> +#endif
> +	return 0;
> +fail:
> +	kfree(common->rx_data_pkt);
> +	return -1;
> +}
> +
> +
> +#ifdef USE_SDIO_INTF
> +/**
> + * This function read and process the SDIO interrupts.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @return None.
> + */
> +void rsi_interrupt_handler(struct rsi_common *common)
> +{
> +	int status;
> +	enum SDIO_INTERRUPT_TYPE isr_type;
> +	unsigned char isr_status = 0;
> +	unsigned char fw_status = 0;
> +	struct rsi_common_ops *common_ops = common->common_ops;
> +
> +	common->rx_info.sdio_int_counter++;
> +
> +	do {
> +		mutex_lock(&common->tx_rxlock);
> +		status = common_ops->read_register(common->priv,
> +						   RSI_FN1_INT_REGISTER,
> +						   &isr_status);
> +		if (status) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Failed to Read Intr Status Register\n",
> +				__func__);
> +			mutex_unlock(&common->tx_rxlock);
> +			return;
> +		}
> +
> +		if (isr_status == 0) {
> +			common_ops->set_event(&common->tx_event);
> +			common->rx_info.sdio_intr_status_zero++;
> +			mutex_unlock(&common->tx_rxlock);
> +			return;
> +		}
> +
> +		rsi_dbg(ISR_ZONE, "%s: Intr_status = %x %d %d\n",
> +			__func__, isr_status, (1 << MSDU_PKT_PENDING),
> +			(1 << FW_ASSERT_IND));
> +
> +		do {
> +			RSI_GET_SDIO_INTERRUPT_TYPE(isr_status, isr_type);
> +
> +			switch (isr_type) {
> +			case BUFFER_AVAILABLE:
> +				common->rx_info.watch_bufferfull_count = 0;
> +				common->rx_info.buffer_full = false;
> +				common->rx_info.mgmt_buffer_full = false;
> +				common_ops->ack_interrupt(common->priv,
> +						     (1 << PKT_BUFF_AVAILABLE));
> +				common_ops->set_event((&common->tx_event));
> +				rsi_dbg(ISR_ZONE,
> +					"%s: ==> BUFFER_AVILABLE <==\n",
> +					__func__);
> +				common->rx_info.buf_avilable_counter++;
> +				break;
> +
> +			case FIRMWARE_ASSERT_IND:
> +				rsi_dbg(ERR_ZONE,
> +					"%s: ==> FIRMWARE Assert <==\n",
> +					__func__);
> +				status = common_ops->read_register(common->priv,
> +							SDIO_FW_STATUS_REG,
> +							&fw_status);
> +				if (status) {
> +					rsi_dbg(ERR_ZONE,
> +						"%s: Failed to read f/w reg\n",
> +						__func__);
> +				} else {
> +					rsi_dbg(ERR_ZONE,
> +						"%s: Firmware Status is 0x%x\n",
> +						__func__ , fw_status);
> +					common_ops->ack_interrupt(common->priv,
> +							(1 << FW_ASSERT_IND));
> +				}
> +
> +				common->fsm_state = FSM_CARD_NOT_READY;
> +				break;
> +
> +			case MSDU_PACKET_PENDING:
> +				rsi_dbg(ISR_ZONE, "Pkt pending interrupt\n");
> +				common->rx_info.total_sdio_msdu_pending_intr++;
> +
> +				status = rsi_read_pkt(common);
> +				if (status) {
> +					rsi_dbg(ERR_ZONE,
> +						"%s: Failed to read pkt\n",
> +						__func__);
> +					mutex_unlock(&common->tx_rxlock);
> +					return;
> +				}
> +				break;
> +			default:
> +				common_ops->ack_interrupt(common->priv,
> +							  isr_status);
> +				common->rx_info.total_sdio_unknown_intr++;
> +				isr_status = 0;
> +				rsi_dbg(ISR_ZONE,
> +					"Unknown Interrupt %x\n",
> +					isr_status);
> +				break;
> +			}
> +			isr_status ^= BIT(isr_type - 1);
> +		} while (isr_status);
> +		mutex_unlock(&common->tx_rxlock);
> +	} while (1);
> +	return;
> +}
> +EXPORT_SYMBOL(rsi_interrupt_handler);
> +#endif
> +
> +
> +#ifdef USE_SDIO_INTF
> +/**
> + * This function sets the AHB master access MS word in the SDIO slave registers.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @param  ms_word ms word need to be initialized.
> + * @return status: 0 on success, -1 on failure.
> + */
> +static int rsi_sdio_master_access_msword(struct rsi_hw *adapter,
> +					 unsigned short ms_word)
> +{
> +	struct rsi_common *common = adapter->priv;
> +	struct rsi_common_ops *common_ops = common->common_ops;
> +	unsigned char byte;
> +	unsigned char reg_dmn = 0;
> +	int status = 0;
> +
> +	byte = (unsigned char)(ms_word & 0x00FF);
> +
> +	rsi_dbg(INIT_ZONE,
> +		"%s: MASTER_ACCESS_MSBYTE:0x%x\n", __func__, byte);
> +
> +	status = common_ops->write_register(adapter,
> +					    reg_dmn,
> +					    SDIO_MASTER_ACCESS_MSBYTE,
> +					    &byte);
> +	if (status) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: fail to access MASTER_ACCESS_MSBYTE\n",
> +			__func__);
> +		return -1;
> +	}
> +
> +	byte = (unsigned char)(ms_word >> 8);
> +
> +	rsi_dbg(INIT_ZONE, "%s:MASTER_ACCESS_LSBYTE:0x%x\n", __func__, byte);
> +	status = common_ops->write_register(adapter,
> +					    reg_dmn,
> +					    SDIO_MASTER_ACCESS_LSBYTE,
> +					    &byte);
> +	return status;
> +}
> +#endif
> +
> +/**
> + * This function includes the actual funtionality of copying the TA firmware to the card.
> + * Basically this function includes opening the TA file,reading the TA file and
> + * writing their values in blocks of data.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @param  fw Pointer to the firmware value to be written.
> + * @param  len length of firmware file.
> + * @param  num_blocks Number of blocks to be written to the card.
> + * @return 0 on success and -1 on failure.
> + */
> +static int rsi_copy_to_card(struct rsi_common *common,
> +			    const unsigned char *fw,
> +			    unsigned int len,
> +			    unsigned int num_blocks)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	unsigned int indx, ii;
> +	unsigned int block_size = adapter->tx_blk_size;
> +	struct rsi_common_ops *common_ops = common->common_ops;
> +	unsigned int lsb_address;
> +#ifdef USE_SDIO_INTF
> +	unsigned int data[] = { TA_HOLD_THREAD_VALUE, TA_SOFT_RST_CLR,
> +				TA_PC_ZERO, TA_RELEASE_THREAD_VALUE };
> +	unsigned int address[] = { TA_HOLD_THREAD_REG, TA_SOFT_RESET_REG,
> +				   TA_TH0_PC_REG, TA_RELEASE_THREAD_REG };
> +#endif
> +	unsigned int base_address;
> +	unsigned short msb_address;
> +
> +	base_address = metadata[0].address;
> +	msb_address = base_address >> 16;
> +
> +	for (indx = 0, ii = 0; ii < num_blocks; ii++, indx += block_size) {
> +		lsb_address = base_address;
> +#ifdef USE_SDIO_INTF
> +		lsb_address = ((unsigned short) base_address |
> +				RSI_SD_REQUEST_MASTER);
> +#endif
> +		if (common_ops->load_firmware(adapter,
> +					      lsb_address,
> +					      (unsigned char *)(fw + indx),
> +					      block_size)) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Unable to load %s blk\n", __func__,
> +				metadata[0].name);
> +			return -1;
> +		}
> +		rsi_dbg(INIT_ZONE, "%s: loading %s block: %d\n",
> +			__func__, metadata[0].name, ii);
> +		base_address += block_size;
> +#ifdef USE_SDIO_INTF
> +		if ((base_address >> 16) != msb_address) {
> +			msb_address += 1;
> +			if (rsi_sdio_master_access_msword(adapter,
> +							  msb_address)) {
> +				rsi_dbg(ERR_ZONE,
> +					"%s: Unable to set ms word reg\n",
> +					__func__);
> +				return -1;
> +			}
> +		}
> +#endif
> +	}
> +
> +	if (len % block_size) {
> +		lsb_address = base_address;
> +#ifdef USE_SDIO_INTF
> +		lsb_address |= ((unsigned short) base_address |
> +				RSI_SD_REQUEST_MASTER);
> +#endif
> +		if (common_ops->load_firmware(adapter,
> +					      lsb_address,
> +					      (unsigned char *)(fw + indx),
> +					      len % block_size)) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Unable to load %s blk\n", __func__,
> +				metadata[0].name);
> +			return -1;
> +		}
> +	}
> +	rsi_dbg(INIT_ZONE,
> +		"%s: Succesfully loaded %s instructions\n", __func__,
> +		metadata[0].name);
> +
> +#ifdef USE_SDIO_INTF
> +
> +	if (rsi_sdio_master_access_msword(adapter, 0x2200)) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Unable to set ms word to common reg\n",
> +			__func__);
> +		return -1;
> +	}
> +
> +	for (ii = 0; ii < ARRAY_SIZE(data); ii++) {
> +		/* Bringing TA out of reset */
> +		if (common_ops->write_reg_multiple(adapter,
> +						   (address[ii] |
> +						    RSI_SD_REQUEST_MASTER),
> +						   (unsigned char *)&data[ii],
> +						   4)) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Unable to hold TA threads\n", __func__);
> +			return -1;
> +		}
> +	}
> +#endif
> +	rsi_dbg(INIT_ZONE, "%s: loaded firmware\n", __func__);
> +	return 0;
> +}
> +
> +/**
> + * This function reads the firmware version from the firmware file.
> + *
> + * @param  fw Pointer to the firmware  data.
> + * @param  fw_ver Pointer to firmware version_info structure.
> + * @return None
> + */
> +static void rsi_fill_fw_ver(const unsigned char *fw,
> +			    struct version_info *fw_ver)
> +{
> +	fw_ver->major = (fw[LMAC_VER_OFFSET] & 0xFF);
> +	fw_ver->minor = (fw[LMAC_VER_OFFSET + 1] & 0xFF);
> +	fw_ver->release_num = (fw[LMAC_VER_OFFSET + 2] & 0xFF);
> +	fw_ver->patch_num = (fw[LMAC_VER_OFFSET + 3] & 0xFF);
> +	fw_ver->info.fw_ver[0] = (fw[LMAC_VER_OFFSET + 4] & 0xFF);
> +	return;
> +}
> +
> +/**
> + * This function includes the actual funtionality of loading the TA firmware.
> + * This function also includes opening the TA file,reading the TA file and
> + * writing their values in blocks of data.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @param  fw_status Firmware status.
> + * @return status: 0 on success, -1 on failure.
> + */
> +static int rsi_load_ta_instructions(struct rsi_common *common,
> +				    unsigned short fw_status)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	struct version_info *fw_ver = &common->fw_ver;
> +	unsigned int len;
> +	unsigned int num_blocks;
> +	const unsigned char *fw;
> +	const struct firmware *fw_entry = NULL;
> +	unsigned int block_size = adapter->tx_blk_size;
> +	int status = 0;
> +
> +#ifdef USE_SDIO_INTF
> +	unsigned int base_address;
> +	unsigned short msb_address;
> +
> +	if (rsi_sdio_master_access_msword(adapter, 0x2200)) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Unable to set ms word to common reg\n",
> +			__func__);
> +		return -1;
> +	}
> +	base_address = metadata[0].address;

Since metadata[0].address is always going to be 0x00 per above, why does
it exist?  The structure should only be extended to include the base
address if/when that functionality is actually used.  Plus, it's only
used for SDIO and it's not used for USB.

> +	msb_address = (base_address >> 16);
> +
> +	if (rsi_sdio_master_access_msword(adapter, msb_address)) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Unable to set ms word reg\n", __func__);
> +		return -1;
> +	}
> +#endif
> +
> +	status = request_firmware(&fw_entry, metadata[0].name, adapter->device);
> +	if (status < 0) {
> +		rsi_dbg(ERR_ZONE, "%s Firmware file %s not found\n",
> +			__func__, metadata[0].name);
> +		return status;
> +	}
> +
> +	fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
> +	len = fw_entry->size;
> +
> +#ifdef USE_USB_INTF
> +	if (fw_status) {
> +#endif

Instead of this being USB only, shouldn't the driver check if there's
already firmware loaded, and if so, read the version of the device?
Here, it looks like (at least for USB) if the firmware is already loaded
on the device, it just reads the version from the *file on disk*, not
what's loaded already, and then returns?

Dan

> +		rsi_fill_fw_ver(fw, fw_ver);
> +#ifdef USE_USB_INTF
> +		return 0;
> +	}
> +#endif
> +
> +	if (len % 4)
> +		len += (4 - (len % 4));
> +
> +	num_blocks = (len / block_size);
> +
> +	rsi_dbg(INIT_ZONE, "%s: Instruction size:%d\n", __func__, len);
> +	rsi_dbg(INIT_ZONE, "%s: num blocks: %d\n", __func__, num_blocks);
> +
> +	status = rsi_copy_to_card(common, fw, len, num_blocks);
> +	release_firmware(fw_entry);
> +	return status;
> +}
> +
> +/**
> + * This function is a kernel thread to send the packets to the device.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @return None.
> + */
> +void rsi_tx_scheduler_thread(struct rsi_common *common)
> +{
> +	struct rsi_common_ops *common_ops = common->common_ops;
> +
> +	do {
> +		if (common->rx_info.buffer_full) {
> +			common_ops->wait_queue_event(&common->tx_event, 2);
> +			rsi_dbg(INFO_ZONE,
> +				"%s: Event wait for 2ms\n", __func__);
> +		} else {
> +			common_ops->wait_queue_event(&common->tx_event,
> +						     EVENT_WAIT_FOREVER);
> +		}
> +		common_ops->reset_event(&common->tx_event);
> +
> +		if (common->init_done)
> +			common_ops->qos_processor(common);
> +	} while (atomic_read(&common->tx_thread_done) == 0);
> +	complete_and_exit(&common->tx_thread.completion, 0);
> +}
> +EXPORT_SYMBOL(rsi_tx_scheduler_thread);
> +
> +#ifdef USE_USB_INTF
> +/**
> + * This is a kernel thread to receive the packets from the USB device.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @return None.
> + */
> +void rsi_usb_rx_thread(struct rsi_common *common)
> +{
> +	struct rsi_common_ops *common_ops = common->common_ops;
> +	struct rsi_hw *adapter = common->priv;
> +
> +	while (1) {
> +		common_ops->wait_queue_event(&common->rx_event,
> +					     EVENT_WAIT_FOREVER);
> +
> +		if (atomic_read(&common->rx_thread_done))
> +			goto out;
> +
> +		mutex_lock(&common->tx_rxlock);
> +		if (rsi_read_pkt(common)) {
> +			rsi_dbg(ERR_ZONE, "%s: Failed to read pkt\n", __func__);
> +			mutex_unlock(&common->tx_rxlock);
> +			goto out;
> +		}
> +		mutex_unlock(&common->tx_rxlock);
> +		common_ops->reset_event(&common->rx_event);
> +		if (common_ops->rx_urb_submit(adapter)) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Failed in urb submission\n", __func__);
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	rsi_dbg(INFO_ZONE, "%s: Terminated thread\n", __func__);
> +	atomic_inc(&common->rx_thread_done);
> +	complete_and_exit(&common->rx_thread.completion, 0);
> +	return;
> +}
> +EXPORT_SYMBOL(rsi_usb_rx_thread);
> +#endif
> +
> +/**
> + * This Function Initializes The HAL.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @param  fw_status Firmware status.
> + * @return 0 on success, -1 on failure.
> + */
> +int rsi_device_init(struct rsi_common *common, unsigned short fw_status)
> +{
> +	rsi_set_default_parameters(common);
> +
> +	if (rsi_load_ta_instructions(common, fw_status))
> +		return -1;
> +
> +#ifdef USE_SDIO_INTF
> +	if (rsi_sdio_master_access_msword(common->priv, 0x4105)) {
> +		rsi_dbg(ERR_ZONE, "%s: Unable to set ms word reg\n",
> +			__func__);
> +		return -1;
> +	}
> +	rsi_dbg(INIT_ZONE,
> +		"%s: Setting ms word to 0x41050000\n", __func__);
> +#endif
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(rsi_device_init);
> +
> +/**
> + * This Function de-initializes The HAL.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @return 0 on success.
> + */
> +int rsi_device_deinit(struct rsi_hw *adapter)
> +{
> +	rsi_mac80211_detach(adapter);
> +	return 0;
> +}
> +EXPORT_SYMBOL(rsi_device_deinit);
> diff -uprN a/drivers/net/wireless/rsi/91x/rsi_91x_main.c b/drivers/net/wireless/rsi/91x/rsi_91x_main.c
> --- a/drivers/net/wireless/rsi/91x/rsi_91x_main.c	1970-01-01 05:30:00.000000000 +0530
> +++ b/drivers/net/wireless/rsi/91x/rsi_91x_main.c	2014-01-30 16:25:13.984547126 +0530
> @@ -0,0 +1,94 @@
> +/**
> + * @file rsi_91x_main.c
> + * @author
> + * @version 1.0
> + *
> + * @section LICENSE
> + * Copyright (c) 2013 Redpine Signals Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + *
> + * @section DESCRIPTION
> + *
> + * This file contians the code specific to file operations like creation, open,
> + * reading/ writing to the files
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include "../include/rsi_main.h"
> +#include "../include/rsi_device_ops.h"
> +
> +unsigned int rsi_zone_enabled = /*INFO_ZONE |
> +				INIT_ZONE |
> +				MGMT_TX_ZONE |
> +				MGMT_RX_ZONE |
> +				DATA_TX_ZONE |
> +				DATA_RX_ZONE |
> +				FSM_ZONE |
> +				ISR_ZONE | */
> +				ERR_ZONE |
> +				0;
> +EXPORT_SYMBOL(rsi_zone_enabled);
> +
> +/**
> + * This function reads parameters of module connected.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @return 0 on success, -1 on failure.
> + */
> +int rsi_set_default_parameters(struct rsi_common *common)
> +{
> +	common->rftype = RSI_RF_8111;
> +	common->band = IEEE80211_BAND_2GHZ;
> +	common->channel_width = BW_20MHZ;
> +	common->rts_threshold = MAX_RTS_THRESHOLD;
> +	common->channel = 1;
> +	common->min_rate = 0xffff;
> +	common->fsm_state = FSM_CARD_NOT_READY;
> +	return 0;
> +}
> +
> +/**
> + * This function is invoked when the module is loaded into the kernel.
> + * It registers the client driver.
> + *
> + * @param  Void.
> + * @return 0 on success, -1 on failure.
> + */
> +static int rsi_91x_hal_module_init(void)
> +{
> +	rsi_dbg(INIT_ZONE, "%s: Module init called\n", __func__);
> +	return 0;
> +}
> +
> +/**
> + * This function is called at the time of removing/unloading the module.
> + * It unregisters the client driver.
> + *
> + * @param  Void.
> + * @return None.
> + */
> +static void rsi_91x_hal_module_exit(void)
> +{
> +	rsi_dbg(INIT_ZONE, "%s: Module exit called\n", __func__);
> +	return;
> +}
> +
> +module_init(rsi_91x_hal_module_init);
> +module_exit(rsi_91x_hal_module_exit);
> +MODULE_AUTHOR("Redpine Signals Inc");
> +MODULE_DESCRIPTION("Station driver for RSI 91x driver");
> +MODULE_SUPPORTED_DEVICE("RSI-91x");
> +MODULE_VERSION("0.1");
> +MODULE_LICENSE("GPL");
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


