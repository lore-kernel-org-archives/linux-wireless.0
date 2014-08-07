Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iron1.routit.net ([89.146.30.18]:45891 "EHLO iron1.routit.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353AbaHGNQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 09:16:21 -0400
Message-ID: <53E37C09.8070108@raritan.com> (sfid-20140807_151625_015559_16CA332E)
Date: Thu, 07 Aug 2014 15:15:53 +0200
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix sending URBs with wrong type when using
 full-speed
References: <1407403442-27268-1-git-send-email-ronald.wahl@raritan.com> <9263316.qJ7UgtQDIG@blech> <53E36624.9060905@raritan.com> <7450698.ipAbWqfnUT@blech>
In-Reply-To: <7450698.ipAbWqfnUT@blech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.08.2014 15:04, Christian Lamparter wrote:
> On Thursday, August 07, 2014 01:42:28 PM Ronald Wahl wrote:
>>> What about this:
>>>
>>>                  if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
>>>                      usb_endpoint_is_bulk_out(ep))
>>>                          ar->usb_ep_cmd_is_bulk = true;
>>> (the driver context "ar" is zero'd out - It is not necessary to set
>>> usb_ep_cmd_is_bulk to false.)
>>
>> This is what my first patch has done but we need to check the endpoint
>> type if its bulk or not. Otherwise it will fail in the high-speed case.
>> Or did you mean:
>>
>> 		if (usb_endpoint_num(ep) == AR9170_USB_EP_CMD &&
>> 		    usb_endpoint_is_bulk_out(ep) &&
>> 		    usb_endpoint_type(ep) == USB_ENDPOINT_XFER_BULK)
>> 			ar->usb_ep_cmd_is_bulk = true;
> usb_endpoint_is_bulk_out [0] "checks if the endpoint is bulk OUT".
> This function should perform both checks (ie.: is bulk? is out?).

Oh, I overlooked the _bulk_ in the function name. :-)

Anyway, the v3 patch that I have send out in the meantime did not have 
this minor optimization but this shouldn't actually really matter I think.

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes
