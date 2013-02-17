Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38052 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3BQBvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 20:51:37 -0500
Message-ID: <512037A5.2010203@gmail.com> (sfid-20130217_025142_011029_F0F70DB1)
Date: Sun, 17 Feb 2013 01:51:33 +0000
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: usb: allocate URB control message setup_packet
 and data buffer separately
References: <20130216230016.15041.99979.stgit@localhost6.localdomain6> <51201AB8.4060700@lwfinger.net>
In-Reply-To: <51201AB8.4060700@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/02/2013 23:48, Larry Finger wrote:
> On 02/16/2013 05:00 PM, Jussi Kivilinna wrote:
>> rtlwifi allocates both setup_packet and data buffer of control 
>> message urb,
>> using shared kmalloc in _usbctrl_vendorreq_async_write. Structure 
>> used for
>> allocating is:
>>     struct {
>>         u8 data[254];
>>         struct usb_ctrlrequest dr;
>>     };
>>
>> Because 'struct usb_ctrlrequest' is __packed, setup packet is 
>> unaligned and
>> DMA mapping of both 'data' and 'dr' confuses ARM/sunxi, leading to 
>> memory
>> corruptions and freezes.
>>
>> Patch changes setup packet to be allocated separately.
>
> I am not crazy about the overhead in allocating two different blocks 
> for each output packet, but if it is necessary, then it has to happen.
>>   static int _usbctrl_vendorreq_async_write(struct usb_device *udev, 
>> u8 request,
>> @@ -55,39 +59,47 @@ static int _usbctrl_vendorreq_async_write(struct 
>> usb_device *udev, u8 request,
>>       u8 reqtype;
>>       struct usb_ctrlrequest *dr;
>>       struct urb *urb;
>> -    struct rtl819x_async_write_data {
>> -        u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
>> -        struct usb_ctrlrequest dr;
>> -    } *buf;
>

If dr isn't at the appropriate alignment, wouldn't padding out the data 
buffer achieve the same thing? Something like:

struct rtl819x_async_write_data {
-        u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
+        u8 data[ALIGN(REALTEK_USB_VENQT_MAX_BUF_SIZE, ALIGNMENT)];
         struct usb_ctrlrequest dr;
     } *buf;

Where ALIGNMENT is whatever the required alignment is.


Dave.
