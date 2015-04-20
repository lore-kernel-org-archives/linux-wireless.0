Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36869 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbbDTL0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 07:26:03 -0400
Received: by igblo3 with SMTP id lo3so57168169igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2015 04:26:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5530C940.6010407@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-11-git-send-email-arend@broadcom.com>
	<CACna6rwJn695OzCdHu9KWUczcXext5mrLHvfVSMXsLekBm2tUg@mail.gmail.com>
	<F51492713EF10846800D8C0ED37A7DCE019304D6@SJEXCHMB15.corp.ad.broadcom.com>
	<CACna6rzVfDqe_TBaLSoV704ZHU--d_JqrzDF2fM85pnTYUJMeg@mail.gmail.com>
	<5530C940.6010407@broadcom.com>
Date: Mon, 20 Apr 2015 13:26:02 +0200
Message-ID: <CACna6ryZYvVN_svcv3W+4F6yiJf2QYHxYD-VXhGcUUTAHZDYSg@mail.gmail.com> (sfid-20150420_132608_687229_EAF92708)
Subject: Re: [PATCH 10/10] brcmfmac: Add support for multiple PCIE devices in nvram.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	mailinglist <openwrt-devel@lists.openwrt.org>,
	Florian Fainelli <fainelli@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2015 at 10:50, Arend van Spriel <arend@broadcom.com> wrote:
> On 04/17/15 09:45, Rafał Miłecki wrote:
>>
>> Huh, why dropping linux-wireless (and top posting btw)? Please let
>> everyone follow the discussion :)
>>
>> On 15 April 2015 at 21:20, Hante Meuleman<meuleman@broadcom.com>  wrote:
>>>
>>> As I wrote to you in a mail and on the openwrt forum, this patch is
>>> indeed an attempt to support more complex nvram files. I also wrote, that in
>>> order to be able to use it, the nvram contents of the device (r8000) needs
>>> to be put a specific file. Now for your concerns, we can perhaps add
>>> something which will read the nvram contents directly from an nvram store.
>>> But that is irrelevant to this patch. The parsing is still needed, and all
>>> we would need to add is something which is reading the nvram contents from
>>> some other place
>>
>>
>> So it makes me wonder if we need this patch in its current form. I
>> think getting NVRAM directly from the platform is much user friendly.
>> It doesn't require user to install some extra tools for dumping NVRAM
>> and putting it in a specific file. One extra layer less.
>> With that said I think it's hard to review your code for parsing
>> NVRAM. We don't know how it's going to be fetched in the first place.
>
> You already made that point and we agreed to look for a solution.

OK, it wasn't supposed to be rude or anything :) Thanks.


>>> though it would have to be put under some kernel config flag as this
>>> would not be supported in non-router systems. The contents of the nvram
>>> would however still need to be parsed in exactly the same way as the nvram
>>> files we read from disk.
>>
>>
>> Again, it's hard to say for me. Are you going to use
>> bcm47xx_nvram_getenv? Are you going to use MTD subsystem? Are you
>> going to develop different solution? When using e.g.
>> bcm47xx_nvram_getenv you won't want all this parsing stuff at all.
>
>
> Please look at the usage scenario here. The brcmfmac driver is not needing a
> few key,value pairs. It needs a portion of NVRAM to download to the device.
> The patch provides the functionality to do just that. Get the appropriate
> portion, strip comments and whitespace, and send it to the device. Using
> bcm47xx_nvram_getenv is not a useful api as it would mean we need brcmfmac
> to know which key ids to ask for, reassemble it to key=value string and send
> it to the fullmac device.
>
> In bcm47xx_nvram_getenv() it does have the whole nvram content available in
> nvram_buf which is filled by nvram_init(). So if something similar is made
> available on r8000 (or ARM routers in general) build target all we need is
> an api to get the nvram_buf.
>
> Another option is to add the parsing stuff in that nvram code and have an
> api to get the appropriate portion based on pcie domain and bus number as
> used in brcmf_fw_get_firmwares_pcie(). However, I would prefer to have this
> in the driver and not in arch specific code as there may be other platforms
> like our set-top boxes needing this.

This is some plan for the future I was lacking from the beginning. It
makes things more clear now, thanks.

-- 
Rafał
