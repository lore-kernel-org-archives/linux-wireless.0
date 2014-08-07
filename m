Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iron100.routit.net ([89.146.30.22]:60707 "EHLO
	iron100.routit.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaHGKJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 06:09:18 -0400
Message-ID: <53E3504B.4070901@raritan.com> (sfid-20140807_120921_560987_CDE5AF76)
Date: Thu, 07 Aug 2014 12:09:15 +0200
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] carl9170: fix sending URBs with wrong type when using
 full-speed
References: <1407403442-27268-1-git-send-email-ronald.wahl@raritan.com> <53E347D2.6050108@raritan.com>
In-Reply-To: <53E347D2.6050108@raritan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07.08.2014 11:33, Ronald Wahl wrote:
> On 07.08.2014 11:24, Ronald Wahl wrote:
>> +    /* We need to remember the type of endpoint 4 because it differs
>> +     * between high- and full-speed configuration. The high-speed
>> +     * configuration specifies it as interrupt and the full-speed
>> +     * configuration as bulk endpoint. This information is required
>> +     * later when sending urbs to that endpoint.
>> +     */
>> +    for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; ++i) {
>> +        ep = &intf->cur_altsetting->endpoint[i].desc;
>> +
>> +        if (usb_endpoint_dir_out(ep) && usb_endpoint_num(ep) == 4)
>> +            ar->usb_ep4_is_bulk = true;
>> +    }
>
> Hi,
>
> just after sending out that patch I have seen that I should better use
> AR9170_USB_EP_CMD instead of 4 when checking for the endpoint and maybe
> rename the flag into usb_ep_cmd_is_bulk. But before creating v2 of the
> patch I want to hear your comments...

A fellow just pointed out that a central part of my patch was wrong as I 
actually forgot to check the endpoint type and instead hardcoded the 
result. So I had to create v2 of the patch now.

Mea culpa,
ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Ralf Ploenes
