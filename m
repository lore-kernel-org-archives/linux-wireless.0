Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4897 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab2BXKPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 05:15:38 -0500
Message-ID: <4F47633F.6020804@broadcom.com> (sfid-20120224_111541_724152_EB0307F8)
Date: Fri, 24 Feb 2012 11:15:27 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <CACna6rwk8xbjbX7uisqAv_y_JYn636orR-VLgNQ908yOYS+i1A@mail.gmail.com>
In-Reply-To: <CACna6rwk8xbjbX7uisqAv_y_JYn636orR-VLgNQ908yOYS+i1A@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2012 08:52 AM, Rafał Miłecki wrote:
> 2012/2/23 Arend van Spriel<arend@broadcom.com>:
>> Wireless Broadcom chips can have either their SPROM data stored
>> on either external SPROM or on-chip OTP memory. Both are accessed
>> through the same register space. This patch adds support for the
>> on-chip OTP memory.
>>
>> Tested with:
>> BCM43224 OTP and SPROM
>> BCM4331 SPROM
>> BCM4313 OTP
>>
>> This patch is in response so gmane article [1].
>>
>> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
>
> Great, thanks a lot for your work! I'll give it a try with my cards.
>
> May I ask how did you test this with BCM4331? What card (slot) /
> machine did you use for your test?

It is a half mini PCIe card used in my test laptop, ie. Dell Latitude E6410.

>> +       if (bus->drv_cc.core->id.rev>= 31) {
>> +               if (!(bus->drv_cc.capabilities&  BCMA_CC_CAP_SPROM))
>> +                               return false;
>
> One less indent will be fine ;)
>

Let's blame my editor :-p. Will fix it.

>> +               srom_control = bcma_read32(bus->drv_cc.core,
>> +                                          BCMA_CC_SROM_CONTROL);
>> +               return !!(srom_control&  BCMA_CC_SROM_CONTROL_PRESENT);
>
> Does any compiler complain on returning sth like 0xF as a bool?
>

Probably not. Just being overly correct, I guess.

>> +       return (chip_status&  present_mask) == present_mask;
>
> Same :)
>

Same.

>
>> +       u16 offset = BCMA_CC_SPROM;
>
> I guess we can drop second define offset now?
>

Yes. Will do that?

Gr. AvS

