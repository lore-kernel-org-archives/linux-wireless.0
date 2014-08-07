Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iron3.routit.net ([89.146.30.1]:5993 "EHLO iron3.routit.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbaHGLnV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 07:43:21 -0400
Message-ID: <53E36624.9060905@raritan.com> (sfid-20140807_134329_810403_DFC62600)
Date: Thu, 07 Aug 2014 13:42:28 +0200
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix sending URBs with wrong type when using
 full-speed
References: <1407403442-27268-1-git-send-email-ronald.wahl@raritan.com> <53E347D2.6050108@raritan.com> <9263316.qJ7UgtQDIG@blech>
In-Reply-To: <9263316.qJ7UgtQDIG@blech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.08.2014 12:51, Christian Lamparter wrote:
> my comments:
>   - Patch needs a "signed-off-by: <Your Name> <Your Mail> tag"
>     (see Section 12 - Sign your work [0]) for details.
>
>   - Do you see any improvement on a fullspeed port now?
>     (If so, this should be a stable- patch)

Yes, it actually works now. Before this change you could crash the 
system because of the constant logging of the warnings it was almost 
dead. My embedded device just rebooted after a while (maybe the watchdog 
triggered).

>> @@ -1050,6 +1056,21 @@ static int carl9170_usb_probe(struct usb_interface *intf,
>>         ar->intf = intf;
>>         ar->features = id->driver_info;
>>
>> +       /* We need to remember the type of endpoint 4 because it differs
>> +        * between high- and full-speed configuration. The high-speed
>> +        * configuration specifies it as interrupt and the full-speed
>> +        * configuration as bulk endpoint. This information is required
>> +        * later when sending urbs to that endpoint.
>> +        */
>> +       for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
>> +               ep = &intf->cur_altsetting->endpoint[i].desc;
>> +
>> +               if (usb_endpoint_dir_out(ep) &&
>> +                   usb_endpoint_num(ep) == AR9170_USB_EP_CMD)
>> +                       ar->usb_ep_cmd_is_bulk =
>> +                               usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK;
> What about this:
>
>                 if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
>                     usb_endpoint_is_bulk_out(ep))
>                         ar->usb_ep_cmd_is_bulk = true;
> (the driver context "ar" is zero'd out - It is not necessary to set
> usb_ep_cmd_is_bulk to false.)

This is what my first patch has done but we need to check the endpoint 
type if its bulk or not. Otherwise it will fail in the high-speed case.
Or did you mean:

		if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
		    usb_endpoint_is_bulk_out(ep) &&
		    usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK)
			ar->usb_ep_cmd_is_bulk = true;
?

> BTW: I'll make a patch to carl9170 firmware too.

great!

I will fix the remaining things you mentioned.

thx,
ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes
