Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:35491 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3BQIiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 03:38:08 -0500
Message-ID: <20130217103804.1927484whwl62fwg@www.dalek.fi> (sfid-20130217_093812_634447_C6E205A7)
Date: Sun, 17 Feb 2013 10:38:04 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: usb: allocate URB control message
 setup_packet and data buffer separately
References: <20130216230016.15041.99979.stgit@localhost6.localdomain6>
 <51201AB8.4060700@lwfinger.net> <512037A5.2010203@gmail.com>
In-Reply-To: <512037A5.2010203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dave Kilroy <kilroyd@googlemail.com>:

> On 16/02/2013 23:48, Larry Finger wrote:
>> On 02/16/2013 05:00 PM, Jussi Kivilinna wrote:
>>> rtlwifi allocates both setup_packet and data buffer of control message urb,
>>> using shared kmalloc in _usbctrl_vendorreq_async_write. Structure used for
>>> allocating is:
>>>    struct {
>>>        u8 data[254];
>>>        struct usb_ctrlrequest dr;
>>>    };
>>>
>>> Because 'struct usb_ctrlrequest' is __packed, setup packet is unaligned and
>>> DMA mapping of both 'data' and 'dr' confuses ARM/sunxi, leading to memory
>>> corruptions and freezes.
>>>
>>> Patch changes setup packet to be allocated separately.
>>
>> I am not crazy about the overhead in allocating two different  
>> blocks for each output packet, but if it is necessary, then it has  
>> to happen.
>>>  static int _usbctrl_vendorreq_async_write(struct usb_device  
>>> *udev, u8 request,
>>> @@ -55,39 +59,47 @@ static int  
>>> _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
>>>      u8 reqtype;
>>>      struct usb_ctrlrequest *dr;
>>>      struct urb *urb;
>>> -    struct rtl819x_async_write_data {
>>> -        u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
>>> -        struct usb_ctrlrequest dr;
>>> -    } *buf;
>>
>
> If dr isn't at the appropriate alignment, wouldn't padding out the  
> data buffer achieve the same thing? Something like:
>
> struct rtl819x_async_write_data {
> -        u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
> +        u8 data[ALIGN(REALTEK_USB_VENQT_MAX_BUF_SIZE, ALIGNMENT)];
>         struct usb_ctrlrequest dr;
>     } *buf;
>
> Where ALIGNMENT is whatever the required alignment is.

Either it needs to be ARCH_DMA_MINALIGN (need to use ifdefs) or  
KMALLOC_MIN_ALIGN, which appearently is defined only for SLUB, not  
SLAB or SLOB.

-Jussi

>
>
> Dave.
>
>



