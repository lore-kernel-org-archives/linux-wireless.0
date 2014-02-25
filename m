Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbaBYSNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 13:13:34 -0500
Message-ID: <1393352102.23770.30.camel@dcbw.local> (sfid-20140225_191339_664184_2C484403)
Subject: Re: [PATCH 3.14.0-rc4 v2 8/10] rsi: USB functionality
From: Dan Williams <dcbw@redhat.com>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Feb 2014 12:15:02 -0600
In-Reply-To: <530CC531.8070206@redpinesignals.com>
References: <530CC531.8070206@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 22:00 +0530, Fariya Fatima wrote:
> From: Fariya Fatima
> 
> This patch has the rsi_usb module, enabling the USB interface for
> the 91x chipsets.
> 
> Signed-off-by: Fariya Fatima <fariya.f@redpinesignals.com>
> ---
> 
> rsi_91x_usb.c     |  532 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> rsi_91x_usb_ops.c |  166 ++++++++++++++++
> 2 files changed, 698 insertions(+)
> 
> diff -rupN linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_usb.c linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_usb.c
> --- linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_usb.c	1970-01-01 05:30:00.000000000 +0530
> +++ linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_usb.c	2014-02-25 14:51:23.582520109 +0530
> @@ -0,0 +1,532 @@
> +/**
> + * Copyright (c) 2014 Redpine Signals Inc.
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
> + */
> +
> +#include <linux/module.h>
> +#include "rsi_usb.h"
> +#include "rsi_device_ops.h"
> +
> +/**
> + * This function writes to the USB Card.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @param  buf Pointer to the buffer from where the data has to be taken.
> + * @param  len Length to be written.
> + * @param  endpoint Type of endpoint.
> + * @return status: 0 on success, -1 on failure.
> + */
> +static int rsi_usb_card_write(struct rsi_hw *adapter,
> +			      void *buf,
> +			      u16 len,
> +			      u8 endpoint)
> +{
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	int status;
> +	s32 transfer;
> +
> +	status = usb_bulk_msg(dev->usbdev,
> +			      usb_sndbulkpipe(dev->usbdev,
> +			      dev->bulkout_endpoint_addr[endpoint - 1]),
> +			      buf,
> +			      len,
> +			      &transfer,
> +			      HZ * 5);
> +
> +	if (status < 0) {
> +		rsi_dbg(ERR_ZONE,
> +			"Card write failed with error code :%10d\n", status);
> +		dev->write_fail = 1;
> +	}
> +	return status;
> +}
> +
> +/**
> + * This function writes multiple bytes of information to the USB card.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @param  addr Address of the register.
> + * @param  data Pointer to the data that has to be written.
> + * @param  count Number of multiple bytes to be written.
> + * @return 0 on success, -1 on failure.
> + */
> +static int rsi_write_multiple(struct rsi_hw *adapter,
> +			      u8 endpoint,
> +			      u8 *data,
> +			      u32 count)
> +{
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	u8 *seg = dev->tx_buffer;
> +
> +	if (dev->write_fail)
> +		return 0;
> +
> +	if (endpoint == MGMT_EP) {
> +		memset(seg, 0, RSI_USB_TX_HEAD_ROOM);
> +		memcpy(seg + RSI_USB_TX_HEAD_ROOM, data, count);
> +	} else {
> +		seg = ((u8 *)data - RSI_USB_TX_HEAD_ROOM);
> +	}
> +
> +	return rsi_usb_card_write(adapter,
> +				  seg,
> +				  count + RSI_USB_TX_HEAD_ROOM,
> +				  endpoint);
> +}
> +
> +/**
> + * This function initializes the bulk endpoints to the device.
> + *
> + * @param  interface Pointer to the USB interface structure.
> + * @param  adapter Pointer to the adapter structure.
> + * @return ret_val: 0 on success, -ENOMEM on failure.
> + */
> +static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
> +					      struct rsi_hw *adapter)
> +{
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	struct usb_host_interface *iface_desc;
> +	struct usb_endpoint_descriptor *endpoint;
> +	u32 buffer_size;
> +	int ii, bep_found = 0;
> +
> +	iface_desc = &(interface->altsetting[0]);
> +
> +	for (ii = 0; ii < iface_desc->desc.bNumEndpoints; ++ii) {
> +		endpoint = &(iface_desc->endpoint[ii].desc);
> +
> +		if ((!(dev->bulkin_endpoint_addr)) &&
> +		    (endpoint->bEndpointAddress & USB_DIR_IN) &&
> +		    ((endpoint->bmAttributes &
> +		    USB_ENDPOINT_XFERTYPE_MASK) ==
> +		    USB_ENDPOINT_XFER_BULK)) {
> +			buffer_size = endpoint->wMaxPacketSize;
> +			dev->bulkin_size = buffer_size;
> +			dev->bulkin_endpoint_addr =
> +				endpoint->bEndpointAddress;
> +		}
> +
> +		if (!dev->bulkout_endpoint_addr[bep_found] &&
> +		    !(endpoint->bEndpointAddress & USB_DIR_IN) &&
> +		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> +		      USB_ENDPOINT_XFER_BULK)) {
> +			dev->bulkout_endpoint_addr[bep_found] =
> +				endpoint->bEndpointAddress;
> +			buffer_size = endpoint->wMaxPacketSize;
> +			dev->bulkout_size[bep_found] = buffer_size;
> +			bep_found++;
> +		}
> +
> +		if (bep_found >= MAX_BULK_EP)
> +			break;
> +	}
> +
> +	if (!(dev->bulkin_endpoint_addr) &&
> +	    (dev->bulkout_endpoint_addr[0]))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +/* This function reads the data from given register address.
> + *
> + * @param  usbdev Pointer to the usb_device structure.
> + * @param  reg Address of the register to be read.
> + * @param  value Value to be read.
> + * @param  len length of data to be read.
> + * @return status: 0 on success, -1 on failure.
> + */
> +static int rsi_usb_reg_read(struct usb_device *usbdev,
> +			    u32 reg,
> +			    u16 *value,
> +			    u16 len)
> +{
> +	u8 temp_buf[4];
> +	int status = 0;
> +
> +	status = usb_control_msg(usbdev,
> +				 usb_rcvctrlpipe(usbdev, 0),
> +				 USB_VENDOR_REGISTER_READ,
> +				 USB_TYPE_VENDOR,
> +				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
> +				 (void *)temp_buf,
> +				 len,
> +				 HZ * 5);
> +
> +	*value = (temp_buf[0] | (temp_buf[1] << 8));
> +	if (status < 0) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Reg read failed with error code :%d\n",
> +			__func__, status);
> +	}
> +	return status;
> +}
> +
> +/**
> + * This function writes the given data into the given register address.
> + *
> + * @param  usbdev Pointer to the usb_device structure.
> + * @param  reg Address of the register.
> + * @param  value Value to write.
> + * @param  len Length of data to be written.
> + * @return status: 0 on success, -1 on failure.
> + */
> +static int rsi_usb_reg_write(struct usb_device *usbdev,
> +			     u32 reg,
> +			     u16 value,
> +			     u16 len)
> +{
> +	u8 usb_reg_buf[4];
> +	int status = 0;
> +
> +	usb_reg_buf[0] = (value & 0x00ff);
> +	usb_reg_buf[1] = (value & 0xff00) >> 8;
> +	usb_reg_buf[2] = 0x0;
> +	usb_reg_buf[3] = 0x0;
> +
> +	status = usb_control_msg(usbdev,
> +				 usb_sndctrlpipe(usbdev, 0),
> +				 USB_VENDOR_REGISTER_WRITE,
> +				 USB_TYPE_VENDOR,
> +				 ((reg & 0xffff0000) >> 16),
> +				 (reg & 0xffff),
> +				 (void *)usb_reg_buf,
> +				 len,
> +				 HZ * 5);
> +	if (status < 0) {
> +		rsi_dbg(ERR_ZONE,
> +			"%s: Reg write failed with error code :%d\n",
> +			__func__, status);
> +	}
> +	return status;
> +}
> +
> +/**
> + * This function is called when a packet is received from USB
> + * the stack. This is a callback to recieve done.
> + *
> + * @param  urb Received URB.
> + * @return None.
> + */
> +static void rsi_rx_done_handler(struct urb *urb)
> +{
> +	struct rsi_hw *adapter = urb->context;
> +	struct rsi_common *common = adapter->priv;
> +
> +	if (urb->status)
> +		return;
> +
> +	rsi_set_event(&common->rx_event);
> +	return;
> +}
> +
> +/**
> + * This function submits the given URB to the USB stack.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @return 0 on success, -1 on failure.
> + */
> +int rsi_rx_urb_submit(struct rsi_hw *adapter)
> +{
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	struct urb *urb = dev->rx_usb_urb[0];
> +
> +	usb_fill_bulk_urb(urb,
> +			  dev->usbdev,
> +			  usb_rcvbulkpipe(dev->usbdev,
> +				dev->bulkin_endpoint_addr),
> +			  urb->transfer_buffer,
> +			  3000,
> +			  rsi_rx_done_handler,
> +			  adapter);
> +	if (usb_submit_urb(urb, GFP_KERNEL)) {
> +		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission\n", __func__);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * This function writes multiple bytes of information to multiple registers.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @param  addr Address of the register.
> + * @param  data Pointer to the data that has to be written.
> + * @param  count Number of multiple bytes to be written on to the registers.
> + * @return status: 0 on success, -1 on failure.
> + */
> +int rsi_write_ta_register_multiple(struct rsi_hw *adapter,
> +				   u32 addr,
> +				   u8 *data,
> +				   u32 count)
> +{
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	u8 *buf;
> +	u8 transfer;
> +	int status = 0;
> +
> +	buf = kzalloc(4096, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	while (count) {
> +		transfer = min_t(int, count, 4096);
> +		memcpy(buf, data, transfer);
> +		status = usb_control_msg(dev->usbdev,
> +					 usb_sndctrlpipe(dev->usbdev, 0),
> +					 USB_VENDOR_REGISTER_WRITE,
> +					 USB_TYPE_VENDOR,
> +					 ((addr & 0xffff0000) >> 16),
> +					 (addr & 0xffff),
> +					 (void *)buf,
> +					 transfer,
> +					 HZ * 5);
> +		if (status < 0) {
> +			rsi_dbg(ERR_ZONE,
> +				"Reg write failed with error code :%d\n",
> +				status);
> +		} else {
> +			count -= transfer;
> +			data += transfer;
> +			addr += transfer;
> +		}
> +	}
> +
> +	kfree(buf);
> +	return 0;
> +}
> +
> +/**
> + * This function writes the packet to the USB card.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @param  pkt Pointer to the data to be written on to the card.
> + * @param  len Length of the data to be written on to the card.
> + * @return 0 on success, -1 on failure.
> + */
> +int rsi_host_intf_write_pkt(struct rsi_hw *adapter,
> +			    u8 *pkt,
> +			    u32 len)
> +{
> +	u32 queueno = ((pkt[1] >> 4) & 0xf);
> +	u8 endpoint;
> +
> +	endpoint = ((queueno == RSI_WIFI_MGMT_Q) ? MGMT_EP : DATA_EP);
> +
> +	return rsi_write_multiple(adapter,
> +				  endpoint,
> +				  (u8 *)pkt,
> +				  len);
> +}
> +
> +/**
> + * This function initializes the usb interface.
> + *
> + * @param  adapter Pointer to the adapter structure.
> + * @param  pfunction Pointer to USB interface structure.
> + * @return 0 on success, -1 on failure.
> + */
> +static int rsi_init_usb_interface(struct rsi_hw *adapter,
> +				  struct usb_interface *pfunction)
> +{
> +	struct rsi_91xdev *rsi_91x_dev, *dev;
> +
> +	rsi_91x_dev = kzalloc(sizeof(*rsi_91x_dev), GFP_KERNEL);
> +	if (!rsi_91x_dev)
> +		return -1;
> +
> +	adapter->rsi_device = rsi_91x_dev;
> +	dev = rsi_91x_dev;
> +	dev->usbdev = interface_to_usbdev(pfunction);
> +
> +	if (rsi_find_bulk_in_and_out_endpoints(pfunction, adapter))
> +		return -1;
> +
> +	adapter->device = &pfunction->dev;
> +	usb_set_intfdata(pfunction, adapter);
> +
> +	dev->tx_buffer = kmalloc(2048, GFP_ATOMIC);
> +	dev->rx_usb_urb[0] = usb_alloc_urb(0, GFP_KERNEL);
> +	dev->rx_usb_urb[0]->transfer_buffer = adapter->priv->rx_data_pkt;
> +	dev->tx_blk_size = 252;
> +
> +	adapter->hw_intf_ops = rsi_get_hw_intf_ops();
> +
> +	rsi_dbg(INIT_ZONE, "%s: Enabled the interface\n", __func__);
> +	return 0;
> +}
> +
> +/**
> + * This function is called by kernel when the driver provided
> + * Vendor and device IDs are matched. All the initialization
> + * work is done here.
> + *
> + * @param  pfunction Pointer to the USB interface structure.
> + * @param  id Pointer to the usb_device_id structure.
> + * @return 0 on success, -1 on failure.
> + */
> +static int rsi_probe(struct usb_interface *pfunction,
> +		     const struct usb_device_id *id)
> +{
> +	struct rsi_hw *adapter;
> +	struct rsi_91xdev *dev;
> +	u16 fw_status;
> +
> +	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
> +
> +	adapter = rsi_init_os_intf_ops(RSI_91X_INTF_USB);

Hello again!

The abstraction now is a lot better, but the core code still knows too
much about the specific bus types; with a bit of reorganization and
abstraction, you could get rid of the RSI_91X_INTF_* enum entirely.

The INTF_USB bits of rsi_init_os_intf_ops() should really be in the USB
code itself, probably in rsi_init_usb_interface().

rsi_usb_rx_thread() should also really be in the USB bus code, and
common->rx_event should only be in the private USB specific struct since
only the USB code seems to use it.

Also, it's worth renaming rsi_91xdev in both the USB and SDIO code; it's
really confusing to have different structures with the exact same name.
rsi_91x_usbdev and rsi_91x_sdiodev would be fine.

Anything that *is* bus-specific that the generic layer needs to call can
be done with function pointers (that the bus code fills in during init)
in struct rsi_hw.  Any particular reason for the split between
rsi_hw_intf_ops and rsi_hw?  Why not just collapse rsi_hw_intf_ops into
rsi_hw and have the bus-specific code fill those pointers in directly in
their probe() functions?  Having the rsi_get_hw_intf_ops() functions
seems overly complicated.

In any case, great cleanups since last time around, IMO the driver
review process for 'rsi' is going much better than other cases I've been
involved in.  I'll leave most of the mac80211 specific stuff to Johannes
or others.

Dan

> +	if (!adapter) {
> +		rsi_dbg(ERR_ZONE, "%s: Failed to init os intf ops\n",
> +			__func__);
> +		return 1;
> +	}
> +
> +	if (rsi_init_usb_interface(adapter, pfunction)) {
> +		rsi_dbg(ERR_ZONE, "%s: Failed to init usb interface\n",
> +			__func__);
> +		goto fail;
> +	}
> +
> +	if (rsi_init_thread_ops(adapter->priv, RSI_91X_INTF_USB)) {
> +		rsi_dbg(ERR_ZONE, "%s: Failed to init threads\n", __func__);
> +		kfree(adapter->priv);
> +		kfree(adapter->rsi_device);
> +		kfree(adapter);
> +		goto fail;
> +	}
> +
> +	rsi_dbg(ERR_ZONE, "%s: Initialized os intf ops\n", __func__);
> +
> +	dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	if (rsi_usb_reg_read(dev->usbdev, FW_STATUS_REG, &fw_status, 2) < 0)
> +		goto fail;
> +	else
> +		fw_status &= 1;
> +
> +	if (!fw_status) {
> +		if (rsi_device_init(adapter->priv)) {
> +			rsi_dbg(ERR_ZONE, "%s: Failed in device init\n",
> +				__func__);
> +			goto fail;
> +		}
> +
> +		if (rsi_usb_reg_write(dev->usbdev,
> +				      USB_INTERNAL_REG_1,
> +				      RSI_USB_READY_MAGIC_NUM, 1) < 0)
> +			goto fail;
> +		rsi_dbg(INIT_ZONE, "%s: Performed device init\n", __func__);
> +	}
> +
> +	if (rsi_rx_urb_submit(adapter))
> +		goto fail;
> +
> +	return 0;
> +fail:
> +	rsi_deinit_os_intf_ops(adapter);
> +	rsi_dbg(ERR_ZONE, "%s: Failed in probe...Exiting\n", __func__);
> +	return 1;
> +}
> +
> +/**
> + * This function performs the reverse of the probe function,
> + * it deintialize the driver structure.
> + *
> + * @param  pfunction Pointer to the USB interface structure.
> + * @return None.
> + */
> +static void rsi_disconnect(struct usb_interface *pfunction)
> +{
> +	struct rsi_hw *adapter = usb_get_intfdata(pfunction);
> +
> +	if (!adapter)
> +		return;
> +
> +	rsi_device_deinit(adapter);
> +	rsi_deinit_os_intf_ops(adapter);
> +
> +	rsi_dbg(INFO_ZONE, "%s: Deinitialization completed\n", __func__);
> +	return;
> +}
> +
> +#ifdef CONFIG_PM
> +static int rsi_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	/* Not yet implemented */
> +	return -ENOSYS;
> +}
> +
> +static int rsi_resume(struct usb_interface *intf)
> +{
> +	/* Not yet implemented */
> +	return -ENOSYS;
> +}
> +#endif
> +
> +static const struct usb_device_id rsi_dev_table[] = {
> +	{ USB_DEVICE(0x0303, 0x0100) },
> +	{ USB_DEVICE(0x041B, 0x0301) },
> +	{ USB_DEVICE(0x041B, 0x0201) },
> +	{ USB_DEVICE(0x041B, 0x9330) },
> +	{ /* Blank */},
> +};
> +
> +static struct usb_driver rsi_driver = {
> +	.name       = "RSI-USB WLAN",
> +	.probe      = rsi_probe,
> +	.disconnect = rsi_disconnect,
> +	.id_table   = rsi_dev_table,
> +#ifdef CONFIG_PM
> +	.suspend    = rsi_suspend,
> +	.resume     = rsi_resume,
> +#endif
> +};
> +
> +/**
> + * This function registers the client driver.
> + *
> + * @param  Void.
> + * @return 0 on success.
> + */
> +static int rsi_module_init(void)
> +{
> +	usb_register(&rsi_driver);
> +	rsi_dbg(INIT_ZONE, "%s: Registering driver\n", __func__);
> +	return 0;
> +}
> +
> +/**
> + * This function unregisters the client driver.
> + *
> + * @param  Void.
> + * @return None.
> + */
> +static void rsi_module_exit(void)
> +{
> +	usb_deregister(&rsi_driver);
> +	rsi_dbg(INFO_ZONE, "%s: Unregistering driver\n", __func__);
> +	return;
> +}
> +
> +module_init(rsi_module_init);
> +module_exit(rsi_module_exit);
> +
> +MODULE_AUTHOR("Redpine Signals Inc");
> +MODULE_DESCRIPTION("Common USB layer for RSI drivers");
> +MODULE_SUPPORTED_DEVICE("RSI-91x");
> +MODULE_DEVICE_TABLE(usb, rsi_dev_table);
> +MODULE_FIRMWARE(FIRMWARE_RSI9113);
> +MODULE_VERSION("0.1");
> +MODULE_LICENSE("GPL");
> diff -rupN linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_usb_ops.c linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
> --- linux-3.14-rc4/drivers/net/wireless/rsi/rsi_91x_usb_ops.c	1970-01-01 05:30:00.000000000 +0530
> +++ linux-3.14-rc4_new/drivers/net/wireless/rsi/rsi_91x_usb_ops.c	2014-02-25 14:51:23.582520109 +0530
> @@ -0,0 +1,166 @@
> +/**
> + * Copyright (c) 2014 Redpine Signals Inc.
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
> + */
> +
> +#include <linux/firmware.h>
> +#include "rsi_usb.h"
> +#include "rsi_device_ops.h"
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
> +			    const u8 *fw,
> +			    u32 len,
> +			    u32 num_blocks)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	u32 indx, ii;
> +	u32 block_size = dev->tx_blk_size;
> +	u32 lsb_address;
> +	u32 base_address;
> +
> +	base_address = TA_LOAD_ADDRESS;
> +
> +	for (indx = 0, ii = 0; ii < num_blocks; ii++, indx += block_size) {
> +		lsb_address = base_address;
> +		if (rsi_write_ta_register_multiple(adapter,
> +						   lsb_address,
> +						   (u8 *)(fw + indx),
> +						   block_size)) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Unable to load %s blk\n", __func__,
> +				FIRMWARE_RSI9113);
> +			return -1;
> +		}
> +		rsi_dbg(INIT_ZONE, "%s: loading block: %d\n", __func__, ii);
> +		base_address += block_size;
> +	}
> +
> +	if (len % block_size) {
> +		lsb_address = base_address;
> +		if (rsi_write_ta_register_multiple(adapter,
> +						   lsb_address,
> +						   (u8 *)(fw + indx),
> +						   len % block_size)) {
> +			rsi_dbg(ERR_ZONE,
> +				"%s: Unable to load %s blk\n", __func__,
> +				FIRMWARE_RSI9113);
> +			return -1;
> +		}
> +	}
> +	rsi_dbg(INIT_ZONE,
> +		"%s: Succesfully loaded %s instructions\n", __func__,
> +		FIRMWARE_RSI9113);
> +
> +	rsi_dbg(INIT_ZONE, "%s: loaded firmware\n", __func__);
> +	return 0;
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
> +static int rsi_load_ta_instructions(struct rsi_common *common)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	struct rsi_91xdev *dev = (struct rsi_91xdev *)adapter->rsi_device;
> +	const struct firmware *fw_entry = NULL;
> +	u32 block_size = dev->tx_blk_size;
> +	const u8 *fw;
> +	u32 num_blocks, len;
> +	int status = 0;
> +
> +	status = request_firmware(&fw_entry, FIRMWARE_RSI9113, adapter->device);
> +	if (status < 0) {
> +		rsi_dbg(ERR_ZONE, "%s Firmware file %s not found\n",
> +			__func__, FIRMWARE_RSI9113);
> +		return status;
> +	}
> +
> +	fw = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
> +	len = fw_entry->size;
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
> + * This Function Initializes The HAL.
> + *
> + * @param  common Pointer to the driver private structure.
> + * @param  fw_status Firmware status.
> + * @return 0 on success, -1 on failure.
> + */
> +int rsi_device_init(struct rsi_common *common)
> +{
> +	if (rsi_load_ta_instructions(common))
> +		return -1;
> +
> +	return 0;
> +}
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
> +
> +static struct rsi_hw_intf_ops rsi_usb_ops = {
> +	.rx_urb_submit = rsi_rx_urb_submit,
> +	.host_intf_write_pkt = rsi_host_intf_write_pkt,
> +};
> +
> +/**
> + *This function returns the pointer to the device ops structure.
> + *
> + *@param   none.
> + *@return  common_operations Pointer to the driver common operations success.
> + *
> + */
> +struct rsi_hw_intf_ops *rsi_get_hw_intf_ops(void)
> +{
> +	return &rsi_usb_ops;
> +}
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


