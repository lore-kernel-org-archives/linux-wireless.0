Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:49242 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZBWVAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 16:00:34 -0500
Received: by bwz5 with SMTP id 5so5199168bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 13:00:31 -0800 (PST)
Message-ID: <49A30E6C.9010701@gmail.com> (sfid-20090223_220055_284483_F3610C1C)
Date: Mon, 23 Feb 2009 22:00:28 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH] Fix transmit LED on Acer Aspire One
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:

> On Mon, Feb 23, 2009 at 2:37 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Wed, Feb 18, 2009 at 02:07:05PM +1100, Peter Chubb wrote:
>>> +     /* Enable softled on Acer Aspire One */
>>> +     else if (pdev->subsystem_vendor == 0x105b && pdev->subsystem_device == 0xe008) {
>>> +             __set_bit(ATH_STAT_LEDSOFT, sc->status);
>>> +             sc->led_pin = 3;
>>> +             sc->led_on = 0;
>>> +     }
>>>       if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
>>>               goto out;
>>
>> Any comment on this from the ath5k guys?  That 0x105b subvendor ID
>> would seem to correspond to "Foxconn International, Inc.", which
>> doesn't sound much like "Acer"...
 >
> It's already in wireless-testing with similar values.
> 
> Not quite apropos to this patch, someone with the ambit chipset said
> the values didn't match up with his laptop, so we do need to add a
> subsystem_device test I think, but it should have a #define in pci.h.
> In any case there's usually no harm in enabling the wrong gpio pin,
> unless rfkill happens to sit there.

from windows drivers:

%ATHER.DeviceDesc.3067%  = ATHER_DEV_04281468.ndi,    PCI\VEN_168C&DEV_001C&SUBSYS_E008105B

ATHER.DeviceDesc.3067        = "Atheros AR5007EG Wireless Network Adapter"


regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
