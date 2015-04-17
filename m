Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38666 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbDQHpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 03:45:19 -0400
Received: by igbhj9 with SMTP id hj9so5752837igb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 00:45:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F51492713EF10846800D8C0ED37A7DCE019304D6@SJEXCHMB15.corp.ad.broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-11-git-send-email-arend@broadcom.com>
	<CACna6rwJn695OzCdHu9KWUczcXext5mrLHvfVSMXsLekBm2tUg@mail.gmail.com>
	<F51492713EF10846800D8C0ED37A7DCE019304D6@SJEXCHMB15.corp.ad.broadcom.com>
Date: Fri, 17 Apr 2015 09:45:18 +0200
Message-ID: <CACna6rzVfDqe_TBaLSoV704ZHU--d_JqrzDF2fM85pnTYUJMeg@mail.gmail.com> (sfid-20150417_094523_083029_A2F583D1)
Subject: Re: [PATCH 10/10] brcmfmac: Add support for multiple PCIE devices in nvram.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Arend Van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huh, why dropping linux-wireless (and top posting btw)? Please let
everyone follow the discussion :)

On 15 April 2015 at 21:20, Hante Meuleman <meuleman@broadcom.com> wrote:
> As I wrote to you in a mail and on the openwrt forum, this patch is indeed an attempt to support more complex nvram files. I also wrote, that in order to be able to use it, the nvram contents of the device (r8000) needs to be put a specific file. Now for your concerns, we can perhaps add something which will read the nvram contents directly from an nvram store. But that is irrelevant to this patch. The parsing is still needed, and all we would need to add is something which is reading the nvram contents from some other place

So it makes me wonder if we need this patch in its current form. I
think getting NVRAM directly from the platform is much user friendly.
It doesn't require user to install some extra tools for dumping NVRAM
and putting it in a specific file. One extra layer less.
With that said I think it's hard to review your code for parsing
NVRAM. We don't know how it's going to be fetched in the first place.


> though it would have to be put under some kernel config flag as this would not be supported in non-router systems. The contents of the nvram would however still need to be parsed in exactly the same way as the nvram files we read from disk.

Again, it's hard to say for me. Are you going to use
bcm47xx_nvram_getenv? Are you going to use MTD subsystem? Are you
going to develop different solution? When using e.g.
bcm47xx_nvram_getenv you won't want all this parsing stuff at all.

It seems this patch provides some end-support for NVRAM parsing while
we still miss something between. Something for getting NVRAM from
platform and providing it to the brcmfmac somehow.


> As to your concern regarding pci/ versus pcie/: pci/ is old type and will never be used/supported by brcmfmac. All new routers will use either the compressed format like the r8000 does or the pcie/ (uncompressed) format depending on the size of the nvram store.

Oh, I didn't notice that. OK, thanks for pointing this.
