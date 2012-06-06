Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2223 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2FFLpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:45:44 -0400
Message-ID: <4FCF42DA.7080509@broadcom.com> (sfid-20120606_134547_588731_74955AE3)
Date: Wed, 6 Jun 2012 13:45:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Florian Fainelli" <florian@openwrt.org>, linville@tuxdriver.com,
	zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/8] bcma: Fix for 4329b0 bad LPOM is detection
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
 <1338933307-13446-4-git-send-email-hauke@hauke-m.de>
 <2043822.26J1ek8FFi@flexo> <4FCF17DA.4010100@hauke-m.de>
In-Reply-To: <4FCF17DA.4010100@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 10:42 AM, Hauke Mehrtens wrote:
> On 06/06/2012 10:08 AM, Florian Fainelli wrote:
>> Hi Hauke,
>>
>> On Tuesday 05 June 2012 23:55:02 Hauke Mehrtens wrote:
>>>  
>>> -	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
>>> +	if (bus->chipinfo.id == 0x4329 && bus->chipinfo.rev == 2)
>>>  		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
>>
>> Does not that deserve a new define to be in line with your previous patch?
>> --
>> Florian
> 
> Probably we can remove this completely. The BCM4329 is a fullmac chip
> mostly used in phones and this part is done in the firmware.

That is correct. PMU initialization is done in the firmware for a
fullmac device.

Gr. AvS

