Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbaAaQh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 11:37:56 -0500
Message-ID: <1391186306.7577.2.camel@dcbw.local> (sfid-20140131_173759_778407_A79F91D4)
Subject: Re: [PATCH 3.13.1 4/9] rsi: USB functionality
From: Dan Williams <dcbw@redhat.com>
To: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 31 Jan 2014 10:38:26 -0600
In-Reply-To: <52EB818C.1070007@redpinesignals.com>
References: <52EA75C9.5050005@redpinesignals.com>
	 <1391111311.698.60.camel@dcbw.local> <52EB818C.1070007@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-31 at 16:27 +0530, Jahnavi Meher wrote:
> Hi Dan,
> Thank you for your review comments. Patches 5 and 8 did
> not appear on patchwork.kernel.org, so I have sent them
> again. We will make relevant changes going by your comments.
> The driver maintains 5 queues, 4 for data and 1 for 
> mgmt. Depending on the type of packet, data or mgmt, the 
> packet is sent to the endpoint.
> Will make the reset card changes and read the f/w version
> from the device. The firmware used is the same for both 
> SDIO and USB, is not bus dependent.

Ok, good to know.  In that case, I guess the MODULE_FIRMWARE tag should
still go in both the USB and the SDIO module code though, even if it's
not loaded directly from those.

Dan

> Regards,
> Jahnavi
> 
> On 01/31/2014 01:18 AM, Dan Williams wrote:
> > On Thu, 2014-01-30 at 21:24 +0530, Jahnavi wrote:
> >> From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> >>
> >> This file adds the rsi_usb module, enabling the USB interface for
> >> the 91x chipsets.
> >>
> >> Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> >> ---
> > In general the code is very clean and mostly follows kernel style.  It's
> > also fairly easy to read.  That's great.
> >
> > However, I've got some architecture comments below...
> >
> >> rsi_usb.c |  642 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >> 1 file changed, 642 insertions(+)
> >>
> >> diff -uprN a/drivers/net/wireless/rsi/common/rsi_usb.c b/drivers/net/wireless/rsi/common/rsi_usb.c
> >> --- a/drivers/net/wireless/rsi/common/rsi_usb.c	1970-01-01 05:30:00.000000000 +0530
> >> +++ b/drivers/net/wireless/rsi/common/rsi_usb.c	2014-01-30 16:15:14.126308228 +0530
> >> @@ -0,0 +1,642 @@
> >> +/**
> >> + * @file rsi_usb.c
> >> + * @author
> >> + * @version 1.0
> >> + *
> >> + * @section LICENSE
> >> + * Copyright (c) 2013 Redpine Signals Inc.
> >> + *
> >> + * Permission to use, copy, modify, and/or distribute this software for any
> >> + * purpose with or without fee is hereby granted, provided that the above
> >> + * copyright notice and this permission notice appear in all copies.
> >> + *
> >> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> >> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> >> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> >> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> >> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> >> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> >> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> >> + *
> >> + * @section DESCRIPTION
> >> + *
> >> + * The file contains Generic HAL layer for USB.
> >> + */
> >> +
> >> +#include "../include/rsi_main.h"
> >> +#include "../include/rsi_hw_intf.h"
> >> +#include "../include/rsi_device_ops.h"
> >> +
> >> +static unsigned short fw;
> > Why does 'fw' need to be static?  It's only used in one function, and
> > it's read from the device every time.
> >
> >> +static unsigned char reset_card = 1;
> > See my notes below about reset_card; why is this a static global for the
> > file?  First, it prevents using multiple USB devices with the driver.
> > Second, what does it actually prevent and is that actually the best way
> > to do that?
> >
> >> +/**
> >> + * This function writes to the USB Card.
> >> + *
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @param  buf Pointer to the buffer from where the data has to be taken.
> >> + * @param  len Length to be written.
> >> + * @param  endpoint Type of endpoint.
> >> + * @return status: 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_usb_card_write(struct rsi_hw *adapter,
> >> +			      void *buf,
> >> +			      unsigned short len,
> >> +			      unsigned char endpoint)
> > Use types like u16, u8, and u32 where the types are not
> > endian-dependent.  Use types like __le32 or __be32 or __le16 or __be16
> > where you interface with firmware, which is endian-dependent.  That way
> > you can run 'sparse' and find out where your driver may have mismatching
> > endian problems between host and the device.
> >
> >> +{
> >> +	int status;
> >> +	int transfer;
> >> +
> >> +	status = usb_bulk_msg(adapter->usbdev,
> >> +			      usb_sndbulkpipe(adapter->usbdev,
> >> +			      adapter->bulkout_endpoint_addr[endpoint - 1]),
> >> +			      buf,
> >> +			      len,
> >> +			      &transfer,
> >> +			      HZ * 5);
> >> +
> >> +	if (status < 0) {
> >> +		rsi_dbg(ERR_ZONE,
> >> +			"Card write failed with error code :%10d\n", status);
> >> +		adapter->write_fail = 1;
> >> +	}
> >> +	return status;
> >> +}
> >> +
> >> +/**
> >> + * This function writes multiple bytes of information to the USB card.
> >> + *
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @param  addr Address of the register.
> >> + * @param  data Pointer to the data that has to be written.
> >> + * @param  count Number of multiple bytes to be written.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_write_multiple(struct rsi_hw *adapter,
> >> +			      unsigned int addr,
> >> +			      unsigned char *data,
> >> +			      unsigned int count)
> > Use u32, u8, etc.
> >> +{
> >> +	if ((adapter == NULL) || (adapter->write_fail) || (addr == 0)) {
> >> +		return 0;
> > Since this is returning, no need to put the rest of the code below into
> > an indented block.
> >
> >> +	} else {
> >> +		unsigned char *seg = adapter->tx_buffer;
> >> +
> >> +		if (addr == 1) {
> > Why is addr = 1 special?  I see later on that it's determined from the
> > queue that the packet is supposed to be in.  But rsi_write_multiple()
> > actually calls rsi_usb_card_write() and passes 'addr' as the USB
> > endpoint?
> >
> > So correct me if I'm wrong, but what really *is* happening here is that
> > the driver is doing WMM internally and keeps a management queue and a
> > data queue.  Then the USB bus layer inspects the host->device packet and
> > send that packet to a specific USB endpoint depending on whether it's a
> > mgmt frame or a data frame?
> >
> > This should really be more explicit.  Or maybe just add a new parameter
> > to host_intf_write_pkt like 'bool mgmt' or something?  Or, if Johannes
> > has a better suggestion for cleaning up the queue stuff, I'd defer to
> > that.
> >
> >> +			memset(seg, 0, RSI_USB_TX_HEAD_ROOM);
> >> +			memcpy(seg + RSI_USB_TX_HEAD_ROOM, data, count);
> >> +		} else {
> >> +			seg = ((unsigned char *)data - RSI_USB_TX_HEAD_ROOM);
> >> +		}
> >> +		return rsi_usb_card_write(adapter,
> >> +					  seg,
> >> +					  count + RSI_USB_TX_HEAD_ROOM,
> >> +					  addr);
> >> +	}
> >> +}
> >> +
> >> +/**
> >> + * This function initializes the bulk endpoints to the device.
> >> + *
> >> + * @param  interface Pointer to the USB interface structure.
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @return ret_val: 0 on success, -ENOMEM on failure.
> >> + */
> >> +static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
> >> +					      struct rsi_hw *adapter)
> >> +{
> >> +	struct usb_host_interface *iface_desc;
> >> +	struct usb_endpoint_descriptor *endpoint;
> >> +	int buffer_size;
> >> +	int ii, bep_found = 0;
> >> +
> >> +	if ((interface == NULL) || (adapter == NULL))
> >> +		return -1;
> >> +
> >> +	iface_desc = &(interface->altsetting[0]);
> >> +
> >> +	for (ii = 0; ii < iface_desc->desc.bNumEndpoints; ++ii) {
> >> +		endpoint = &(iface_desc->endpoint[ii].desc);
> >> +
> >> +		if ((!(adapter->bulkin_endpoint_addr)) &&
> >> +		    (endpoint->bEndpointAddress & USB_DIR_IN) &&
> >> +		    ((endpoint->bmAttributes &
> >> +		    USB_ENDPOINT_XFERTYPE_MASK) ==
> >> +		    USB_ENDPOINT_XFER_BULK)) {
> >> +			buffer_size = endpoint->wMaxPacketSize;
> >> +			adapter->bulkin_size = buffer_size;
> >> +			adapter->bulkin_endpoint_addr =
> >> +				endpoint->bEndpointAddress;
> >> +		}
> >> +
> >> +		if (!adapter->bulkout_endpoint_addr[bep_found] &&
> >> +		    !(endpoint->bEndpointAddress & USB_DIR_IN) &&
> >> +		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
> >> +		      USB_ENDPOINT_XFER_BULK)) {
> >> +			adapter->bulkout_endpoint_addr[bep_found] =
> >> +				endpoint->bEndpointAddress;
> >> +			buffer_size = endpoint->wMaxPacketSize;
> >> +			adapter->bulkout_size[bep_found] = buffer_size;
> >> +			bep_found++;
> >> +		}
> >> +
> >> +		if (bep_found >= MAX_BULK_EP)
> >> +			break;
> >> +	}
> >> +
> >> +	if (!(adapter->bulkin_endpoint_addr) &&
> >> +	    (adapter->bulkout_endpoint_addr[0]))
> >> +		return -1;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/* This function reads the data from given register address.
> >> + *
> >> + * @param  usbdev Pointer to the usb_device structure.
> >> + * @param  reg Address of the register to be read.
> >> + * @param  value Value to be read.
> >> + * @param  len length of data to be read.
> >> + * @return status: 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_usb_reg_read(struct usb_device *usbdev,
> >> +			    unsigned int reg,
> > u32 perhaps?
> >
> >> +			    unsigned short *value,
> >> +			    unsigned short len)
> > u16 instead of unsigned short.
> >
> >> +{
> >> +	unsigned char temp_buf[4];
> > Use 'u8' instead of unsigned char.
> >
> >> +	int status = 0;
> >> +
> >> +	len = 2;/* FIXME */
> > Every caller of rsi_usb_reg_read() already passed len = 2, so why is
> > this function overriding the length the callers want?
> >
> >> +
> >> +	status = usb_control_msg(usbdev,
> >> +				 usb_rcvctrlpipe(usbdev, 0),
> >> +				 USB_VENDOR_REGISTER_READ,
> >> +				 USB_TYPE_VENDOR,
> >> +				 ((reg & 0xffff0000) >> 16), (reg & 0xffff),
> >> +				 (void *)temp_buf,
> >> +				 len,
> >> +				 HZ * 5);
> >> +
> >> +	*value = (temp_buf[0] | (temp_buf[1] << 8));
> >> +	if (status < 0) {
> >> +		rsi_dbg(ERR_ZONE,
> >> +			"%s: Reg read failed with error code :%d\n",
> >> +			__func__, status);
> >> +	}
> >> +	return status;
> >> +}
> >> +
> >> +/**
> >> + * This function writes the given data into the given register address.
> >> + *
> >> + * @param  usbdev Pointer to the usb_device structure.
> >> + * @param  reg Address of the register.
> >> + * @param  value Value to write.
> >> + * @param  len Length of data to be written.
> >> + * @return status: 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_usb_reg_write(struct usb_device *usbdev,
> >> +			     unsigned int reg,
> >> +			     unsigned short value,
> >> +			     unsigned short len)
> >> +{
> >> +	unsigned char usb_reg_buf[4];
> > u8
> >
> >> +	int status = 0;
> >> +
> >> +	usb_reg_buf[0] = (value & 0x00ff);
> >> +	usb_reg_buf[1] = (value & 0xff00) >> 8;
> >> +	usb_reg_buf[2] = 0x0;
> >> +	usb_reg_buf[3] = 0x0;
> >> +
> >> +	status = usb_control_msg(usbdev,
> >> +				 usb_sndctrlpipe(usbdev, 0),
> >> +				 USB_VENDOR_REGISTER_WRITE,
> >> +				 USB_TYPE_VENDOR,
> >> +				 ((reg & 0xffff0000) >> 16),
> >> +				 (reg & 0xffff),
> >> +				 (void *)usb_reg_buf,
> >> +				 len,
> >> +				 HZ * 5);
> >> +	if (status < 0) {
> >> +		rsi_dbg(ERR_ZONE,
> >> +			"%s: Reg write failed with error code :%d\n",
> >> +			__func__, status);
> >> +	}
> >> +	return status;
> >> +}
> >> +
> >> +/**
> >> + * This function is called when a packet is received from USB
> >> + * the stack. This is a callback to recieve done.
> >> + *
> >> + * @param  urb Received URB.
> >> + * @return None.
> >> + */
> >> +static void rsi_rx_done_handler(struct urb *urb)
> >> +{
> >> +	struct rsi_hw *adapter = urb->context;
> >> +	struct rsi_common *common = adapter->priv;
> >> +
> >> +	if (urb->status)
> >> +		return;
> >> +
> >> +	adapter->total_usb_rx_urbs_done++;
> > I can't find where this is used, but for whatever reason I don't see
> > patches 5, 6, or 8 in my mailbox.  If it's not used, it should be
> > removed.
> >
> >> +	rsi_set_event(&common->rx_event);
> >> +	return;
> >> +}
> >> +
> >> +/**
> >> + * This function submits the given URB to the USB stack.
> >> + *
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +int rsi_rx_urb_submit(struct rsi_hw *adapter)
> >> +{
> >> +	struct urb *urb = adapter->rx_usb_urb[0];
> >> +
> >> +	adapter->total_usb_rx_urbs_submitted++;
> >> +	usb_fill_bulk_urb(urb,
> >> +			  adapter->usbdev,
> >> +			  usb_rcvbulkpipe(adapter->usbdev,
> >> +				adapter->bulkin_endpoint_addr),
> >> +			  urb->transfer_buffer,
> >> +			  3000,
> >> +			  rsi_rx_done_handler,
> >> +			  adapter);
> >> +	if (usb_submit_urb(urb, GFP_KERNEL)) {
> >> +		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission\n", __func__);
> >> +		return -1;
> >> +	} else {
> >> +		return 0;
> >> +	}
> > This would typically be written as:
> >
> > if (usb_submit_urb(..)) {
> >    rsi_dbg();
> >    return -1;
> > }
> >
> > return 0;
> >
> >> +}
> >> +
> >> +/**
> >> + * This function writes multiple bytes of information to multiple registers.
> >> + *
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @param  addr Address of the register.
> >> + * @param  data Pointer to the data that has to be written.
> >> + * @param  count Number of multiple bytes to be written on to the registers.
> >> + * @return status: 0 on success, -1 on failure.
> >> + */
> >> +int rsi_write_ta_register_multiple(struct rsi_hw *adapter,
> >> +				   unsigned int addr,
> >> +				   unsigned char *data,
> >> +				   unsigned int count)
> > u32, u8, etc, you get the point.
> >
> >> +{
> >> +	unsigned char *buf;
> >> +	unsigned char transfer;
> >> +	int status = 0;
> >> +
> >> +	buf = kzalloc(4096, GFP_KERNEL);
> >> +	if (!buf)
> >> +		return -ENOMEM;
> >> +
> >> +	while (count) {
> >> +		transfer = min_t(int, count, 4096);
> >> +		memcpy(buf, data, transfer);
> >> +		status = usb_control_msg(adapter->usbdev,
> >> +					 usb_sndctrlpipe(adapter->usbdev, 0),
> >> +					 USB_VENDOR_REGISTER_WRITE,
> >> +					 USB_TYPE_VENDOR,
> >> +					 ((addr & 0xffff0000) >> 16),
> >> +					 (addr & 0xffff),
> >> +					 (void *)buf,
> >> +					 transfer,
> >> +					 HZ * 5);
> >> +		if (status < 0) {
> >> +			rsi_dbg(ERR_ZONE,
> >> +				"Reg write failed with error code :%d\n",
> >> +				status);
> >> +		} else {
> >> +			count -= transfer;
> >> +			data += transfer;
> >> +			addr += transfer;
> >> +		}
> >> +	}
> >> +
> >> +	kfree(buf);
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * This function writes the packet to the USB card.
> >> + *
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @param  pkt Pointer to the data to be written on to the card.
> >> + * @param  len Length of the data to be written on to the card.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +int rsi_write_pkt(struct rsi_hw *adapter,
> >> +		  unsigned char *pkt,
> >> +		  unsigned int len)
> >> +{
> >> +	unsigned int block_size = adapter->tx_blk_size;
> >> +	unsigned int num_blocks, address;
> >> +	unsigned int queueno = ((pkt[1] >> 4) & 0xf);
> >> +
> >> +	if ((!len) && (queueno == RSI_WIFI_DATA_Q)) {
> >> +		rsi_dbg(ERR_ZONE, "%s: Wrong length\n", __func__);
> >> +		return -1;
> >> +	}
> > See comments about queues and endpoints above.  But really, if it's an
> > error to send a zero-length data packet, then perhaps it should be
> > BUG_ON() since the driver should never, ever do that?
> >
> >> +	num_blocks = (len / block_size);
> >> +
> >> +	if (len % block_size)
> >> +		num_blocks++;
> > num_blocks doesn't get used anywhere, should be removed.
> >
> >> +	if (((*(unsigned short *)pkt) < 14) && (queueno == RSI_WIFI_DATA_Q)) {
> >> +		rsi_dbg(ERR_ZONE, "%s: Too small pkt\n", __func__);
> >> +		return -1;
> >> +	}
> >> +
> >> +	address = ((queueno == RSI_WIFI_MGMT_Q) ? 1 : 2);
> >> +
> >> +	return rsi_write_multiple(adapter,
> >> +				  address,
> >> +				  (unsigned char *)pkt,
> >> +				  len);
> >> +}
> >> +
> >> +/**
> >> + * This function initializes the usb interface.
> >> + *
> >> + * @param  adapter Pointer to the adapter structure.
> >> + * @param  pfunction Pointer to USB interface structure.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_init_usb_interface(struct rsi_hw *adapter,
> >> +				  struct usb_interface *pfunction)
> >> +{
> >> +	adapter->usbdev = interface_to_usbdev(pfunction);
> >> +
> >> +	if (rsi_find_bulk_in_and_out_endpoints(pfunction, adapter))
> >> +		return -1;
> >> +
> >> +	adapter->device = &pfunction->dev;
> >> +	usb_set_intfdata(pfunction, adapter);
> >> +
> >> +	adapter->tx_buffer = kmalloc(2048, GFP_ATOMIC);
> >> +	adapter->rx_usb_urb[0] = usb_alloc_urb(0, GFP_KERNEL);
> >> +	adapter->rx_usb_urb[0]->transfer_buffer = adapter->priv->rx_data_pkt;
> >> +	adapter->tx_blk_size = 252;
> >> +
> >> +	rsi_dbg(INIT_ZONE, "%s: Enabled the interface\n", __func__);
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * This function writes into various registers to do USB reset.
> >> + *
> >> + * @param  usbdev Pointer to the usb_device structure.
> >> + * @param  addr Address to write to.
> >> + * @param  data Data to be written onto the address.
> >> + * @param  len_in_bits Length in bits.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_ulp_read_write(struct usb_device *usbdev,
> >> +			      unsigned short addr,
> >> +			      unsigned short *data,
> >> +			      unsigned short len_in_bits)
> >> +{
> >> +	unsigned short buffer = 0;
> >> +
> >> +	if (rsi_usb_reg_write(usbdev,
> >> +			      GSPI_DATA_REG2,
> >> +			      *(unsigned short *)&data[2], 2) < 0)
> >> +		return -1;
> >> +
> >> +	if (rsi_usb_reg_write(usbdev,
> >> +			      GSPI_DATA_REG1,
> >> +			      ((addr << 6) | (data[1] & 0x3f)),
> >> +			      2) < 0)
> >> +		return -1;
> >> +
> >> +	if (rsi_usb_reg_write(usbdev,
> >> +			      GSPI_DATA_REG0,
> >> +			      *(unsigned short *)&data[0],
> >> +			      2) < 0)
> >> +		return -1;
> >> +
> >> +	if (rsi_usb_reg_read(usbdev, GSPI_CTRL_REG0, &buffer, 2) < 0)
> >> +		return -1;
> >> +
> >> +	buffer  &= ~GSPI_2_ULP;
> >> +
> >> +	if (rsi_usb_reg_write(usbdev, GSPI_CTRL_REG0, buffer, 2) < 0)
> >> +		return -1;
> >> +
> >> +	if (rsi_usb_reg_write(usbdev,
> >> +			      GSPI_CTRL_REG1,
> >> +			      ((len_in_bits - 1) | GSPI_TRIG),
> >> +			      2) < 0)
> >> +		return -1;
> >> +
> >> +	if (rsi_usb_reg_read(usbdev, GSPI_CTRL_REG0, &buffer, 2) < 0)
> >> +		return -1;
> >> +
> >> +	buffer |= GSPI_2_ULP;
> >> +
> >> +	if (rsi_usb_reg_write(usbdev, GSPI_CTRL_REG0, buffer, 2) < 0)
> >> +		return -1;
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * This function resets the USB card.
> >> + *
> >> + * @param  pfunction Pointer to the USB interface structure.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_reset_card(struct usb_interface *pfunction)
> >> +{
> >> +	struct usb_device *usbdev = interface_to_usbdev(pfunction);
> >> +	unsigned short temp[4];
> >> +
> >> +	memset(temp, 0, sizeof(temp));
> >> +	*(unsigned int *)temp = 10;
> >> +	if (rsi_ulp_read_write(usbdev, WATCH_DOG_TIMER_1, &temp[0], 32) < 0)
> >> +		return -1;
> >> +
> >> +	*(unsigned int *)temp = 0;
> >> +	if (rsi_ulp_read_write(usbdev, WATCH_DOG_TIMER_2, temp, 32) < 0)
> >> +		return -1;
> >> +
> >> +	*(unsigned int *)temp = 1;
> >> +	if (rsi_ulp_read_write(usbdev, WATCH_DOG_DELAY_TIMER_1, temp, 32) < 0)
> >> +		return -1;
> >> +	*(unsigned int *)temp = 0;
> >> +	if (rsi_ulp_read_write(usbdev, WATCH_DOG_DELAY_TIMER_2, temp, 32) < 0)
> >> +		return -1;
> >> +
> >> +	*(unsigned int *)temp = ((0xaa000) | RESTART_WDT | BYPASS_ULP_ON_WDT);
> >> +	if (rsi_ulp_read_write(usbdev, WATCH_DOG_TIMER_ENABLE, temp, 32) < 0)
> >> +		return -1;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * This function is called by kernel when the driver provided
> >> + * Vendor and device IDs are matched. All the initialization
> >> + * work is done here.
> >> + *
> >> + * @param  pfunction Pointer to the USB interface structure.
> >> + * @param  id Pointer to the usb_device_id structure.
> >> + * @return 0 on success, -1 on failure.
> >> + */
> >> +static int rsi_probe(struct usb_interface *pfunction,
> >> +		     const struct usb_device_id *id)
> >> +{
> >> +	struct rsi_hw *adapter;
> >> +
> >> +	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
> >> +
> >> +	if (reset_card) {
> >> +		rsi_dbg(INIT_ZONE, "%s: Resetting card here\n", __func__);
> >> +		reset_card = 0;
> >> +		if (rsi_reset_card(pfunction) < 0) {
> >> +			rsi_dbg(ERR_ZONE, "%s: Card reset failed\n", __func__);
> >> +			return 1;
> >> +		} else {
> >> +			return 0;
> >> +		}
> >> +	}
> > Ok, reset_card... The first time a card is probed by the module, it
> > resets the device.  Then, if on any further probe or if the card fails
> > to initialize, reset_card is set to 1, and then the *next* time probe()
> > is called the card is reset?
> >
> > That's quite hacktastic.  If the driver always wants to ensure clean
> > firmware state when it loads, it should reset the device any time
> > firmware is loaded and alive to clear that firmware and get some new
> > firmware.
> >
> > If there are any errors, just reset the card.  Since any reset of the
> > card (presumably!) causes the device to drop off the bus, probe() will
> > simply get re-run when the firmware reboots.  No need to dance around
> > with reset_card across probe()s.
> >
> >> +	adapter = rsi_init_os_intf_ops();
> >> +	if (!adapter) {
> >> +		rsi_dbg(ERR_ZONE, "%s: Failed to init os intf ops\n",
> >> +			__func__);
> >> +		return 1;
> >> +	}
> >> +
> >> +	if (rsi_init_usb_interface(adapter, pfunction)) {
> >> +		rsi_dbg(ERR_ZONE, "%s: Failed to init usb interface\n",
> >> +			__func__);
> >> +		goto fail;
> >> +	}
> >> +
> >> +	rsi_dbg(ERR_ZONE, "%s: Initialized os intf ops\n", __func__);
> >> +
> >> +	if (rsi_usb_reg_read(adapter->usbdev, 0x41050012, &fw, 2) < 0)
> > There should really be a #define for this magic number.
> >
> >> +		goto fail;
> >> +	else
> >> +		fw &= 1;
> > There should be some comments about 'fw' here, what does the returned
> > value from rsi_usb_reg_read() mean?  Does it mean the firmware is alive?
> > If so, then it should be named something more descriptive.
> >
> >> +
> >> +	if (rsi_device_init(adapter->priv, fw)) {
> > And it was a bit unclear to track down this usage, where passing
> > anything > 0 to rsi_device_init() really just causes
> > rsi_load_ta_instructions() to fill in a common firmware version struct
> > from the on-disk firmware file (but not running firmware?), and at least
> > for USB, not to attempt to send more firmware to the device.
> >
> >> +		rsi_dbg(ERR_ZONE, "%s: Failed in device init\n",
> >> +			__func__);
> >> +		goto fail;
> >> +	}
> >> +
> >> +	if (!fw)  {
> >> +		if (rsi_usb_reg_write(adapter->usbdev, 0x25000, 0xab, 1) < 0)
> > More magic numbers, these should really have defines.
> >
> >> +			goto fail;
> >> +		rsi_dbg(INIT_ZONE, "%s: Performed device init\n", __func__);
> >> +	} else {
> >> +		reset_card = 1;
> >> +	}
> >> +
> >> +	if (rsi_rx_urb_submit(adapter))
> >> +		goto fail;
> >> +
> >> +	return 0;
> >> +fail:
> >> +	reset_card = 1;
> >> +	rsi_deinit_os_intf_ops(adapter);
> >> +	rsi_dbg(ERR_ZONE, "%s: Failed in probe...Exiting\n", __func__);
> >> +	return 1;
> >> +}
> >> +
> >> +/**
> >> + * This function performs the reverse of the probe function,
> >> + * it deintialize the driver structure.
> >> + *
> >> + * @param  pfunction Pointer to the USB interface structure.
> >> + * @return None.
> >> + */
> >> +static void rsi_disconnect(struct usb_interface *pfunction)
> >> +{
> >> +	struct rsi_hw *adapter = usb_get_intfdata(pfunction);
> >> +
> >> +	if (!adapter)
> >> +		return;
> >> +
> >> +	rsi_device_deinit(adapter);
> >> +	rsi_deinit_os_intf_ops(adapter);
> >> +
> >> +	rsi_dbg(INFO_ZONE, "%s: Deinitialization completed\n", __func__);
> >> +	return;
> >> +}
> >> +
> >> +#ifdef CONFIG_PM
> >> +static int rsi_suspend(struct usb_interface *intf, pm_message_t message)
> >> +{
> >> +	/* Not yet implemented */
> >> +	return -ENOSYS;
> >> +}
> >> +
> >> +static int rsi_resume(struct usb_interface *intf)
> >> +{
> >> +	/* Not yet implemented */
> >> +	return -ENOSYS;
> >> +}
> >> +#endif
> >> +
> >> +static const struct usb_device_id rsi_dev_table[] = {
> >> +	{ USB_DEVICE(0x0303, 0x0100) },
> >> +	{ USB_DEVICE(0x041B, 0x0301) },
> >> +	{ USB_DEVICE(0x041B, 0x0201) },
> >> +	{ USB_DEVICE(0x041B, 0x9330) },
> >> +	{ /* Blank */},
> >> +};
> >> +
> >> +static struct usb_driver rsi_driver = {
> >> +	.name       = "RSI-USB WLAN",
> >> +	.probe      = rsi_probe,
> >> +	.disconnect = rsi_disconnect,
> >> +	.id_table   = rsi_dev_table,
> >> +#ifdef CONFIG_PM
> >> +	.suspend    = rsi_suspend,
> >> +	.resume     = rsi_resume,
> >> +#endif
> >> +};
> >> +
> >> +/**
> >> + * This function registers the client driver.
> >> + *
> >> + * @param  Void.
> >> + * @return 0 on success.
> >> + */
> >> +static int rsi_module_init(void)
> >> +{
> >> +	usb_register(&rsi_driver);
> >> +	rsi_dbg(INIT_ZONE, "%s: Registering driver\n", __func__);
> >> +	return 0;
> >> +}
> >> +
> >> +/**
> >> + * This function unregisters the client driver.
> >> + *
> >> + * @param  Void.
> >> + * @return None.
> >> + */
> >> +static void rsi_module_exit(void)
> >> +{
> >> +	usb_deregister(&rsi_driver);
> >> +	rsi_dbg(INFO_ZONE, "%s: Unregistering driver\n", __func__);
> >> +	return;
> >> +}
> >> +
> >> +module_init(rsi_module_init);
> >> +module_exit(rsi_module_exit);
> >> +
> >> +MODULE_AUTHOR("Redpine Signals Inc");
> >> +MODULE_DESCRIPTION("Common layer for RSI drivers");
> >> +MODULE_SUPPORTED_DEVICE("RSI-91x");
> >> +MODULE_VERSION("0.1");
> >> +MODULE_LICENSE("GPL");
> > As mentioned in other patches, if the firmware that's being loaded by
> > rsi_load_ta_instructions() is really bus-type dependent (eg, USB or
> > SDIO) then each bus type module should have MODULE_FIRMWARE() tags too.
> >
> > Dan
> >
> >
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


