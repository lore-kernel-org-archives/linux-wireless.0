Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52565 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3FQRp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:45:26 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so3540248obc.34
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 10:45:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BF498F.1010007@broadcom.com>
References: <20130612222123.GB31667@titan.lakedaemon.net>
	<20130617161903.GN31667@titan.lakedaemon.net>
	<51BF498F.1010007@broadcom.com>
Date: Mon, 17 Jun 2013 19:45:25 +0200
Message-ID: <CACna6ryw=QeD5OuMWYoZLYzt9CBo+PO-SwygDY+SUaVxCYu0jA@mail.gmail.com> (sfid-20130617_194702_322275_A6169970)
Subject: Re: [RFC PATCH] net: brcmfmac: add sdio chip id 0x4319
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: Jason Cooper <jason@lakedaemon.net>, rvossen@broadcom.com,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/17 Franky Lin <frankyl@broadcom.com>:
> On 06/17/2013 09:19 AM, Jason Cooper wrote:
>>
>> Added Franky...
>>
>> On Wed, Jun 12, 2013 at 06:21:23PM -0400, Jason Cooper wrote:
>>>
>>> All,
>>>
>>> I have a Seagate Wireless Plus I am trying to put a vanilla kernel on
>>> (currently v3.10-rc5 for various omap DT bits).
>>>
>>> I have the board booting and running a debian rootfs on the HD.  I just
>>> got mmc to come up and I've discovered that the wireless card is vendor
>>> 0x02d0, device 0x4319.
>>>
>>> My hope, once I got to this point, was that I would be able to use
>>> the mainline, open source driver.  Unfortunately, it looks like brcmfmac
>>> lost support for the 0x4319 while it was in staging.
>>>
>>> The commit in question is:
>>>
>>>    4dad253 staging: brcm80211: remove code for unsupported chip
>>>
>>> Is adding it back in a bridge too far?
>>
>> It looks like only two things are needed, adding the chip id and then
>> setting the addresses.  Here's a preliminary patch to do just that.
>> Note, the addresses I have used are a straight copy from the 4329.  It
>> causes this:
>>
>> [   12.346466] mmcblk mmc0:0001: no of_node; not parsing pinctrl DT
>> [   12.353149] brcmfmac_sdio mmc0:0001:1: no of_node; not parsing pinctrl
>> DT
>> [   12.360717] brcmfmac_sdio mmc0:0001:2: no of_node; not parsing pinctrl
>> DT
>> [   12.368804] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive
>> strength init done for chip 4319 rev 1 pmurev 7
>> [   12.380462] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>> F0:@0x00408=03, Err: -22
>> [   12.391906] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>> F0:@0x00408=03, Err: -22
>> [   12.403289] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>> F0:@0x00408=03, Err: -22
>> [   12.412261] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
>> [   12.418457] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>> F0:@0x00408=01, Err: -22
>> [   12.429718] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>> F0:@0x00408=01, Err: -22
>> [   12.441101] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
>> F0:@0x00408=01, Err: -22
>> [   12.450073] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
>>
>> I've taken a quick look at aosp, the provided GPL broadcom code, and I
>> haven't seen anything for the 4319 wrt to addresses.  How hard would it
>> be to get those addresses from you guys?
>
>
> Hi Jason,
>
> The major obstacle of adding 4319 support is the obsolete firmware. Since
> it's an EOL chip we are not planning to add the support to brcmfmac.

Does it mean, BCM4319 is a "new architecture" chipset, working
similarly to the already supported (in brcmfmac) chipsets?

When thinking about "old architecture" I mean BCM43236, which AFAIR
requires some different driver architecture with some extra memory
sharing or sth.

-- 
Rafał
