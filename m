Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37845 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbLYJyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2015 04:54:51 -0500
Received: by mail-wm0-f54.google.com with SMTP id p187so202761186wmp.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Dec 2015 01:54:50 -0800 (PST)
Subject: Re: [BISECTED] brcmfmac issue since 4.3.0-rc3
To: Carlo Caione <carlo@caione.org>, meuleman@broadcom.com
References: <CAOQ7t2bEs2UhxfWUCs7TBwidw2JKCKLmeUzcYjng4f5p4Wr-Mw@mail.gmail.com>
Cc: arend@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <567D1268.70709@gmail.com> (sfid-20151225_105530_066648_69646280)
Date: Fri, 25 Dec 2015 10:54:48 +0100
MIME-Version: 1.0
In-Reply-To: <CAOQ7t2bEs2UhxfWUCs7TBwidw2JKCKLmeUzcYjng4f5p4Wr-Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-12-15 18:23, Carlo Caione wrote:
> Hi Hante,
> I'm having an issue with my BCM43340 SDIO WiFi card on the Asus X205TA
> laptop and the latest firmware taken from the linux-firmware git repo
> with the correct nvram file in place. I bisected the issue back to
> commit 2b76acd "brcmfmac: Rework p2p attach, use single method for p2p
> dev creation." (bad commit).
> 
> The problem is not always reproducible. I'd say it happens once every
> ten reboots. What I see is that the kernel panics at boot immediately
> after I see:
> 
> brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init
> done for chip 43340 rev 2 pmurev 20
> brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -52
> brcmfmac: brcmf_bus_start: failed: -52
> brcmfmac: brcmf_sdio_firmware_callback: dongle is not responding
> brcmfmac: brcmf_sdio_dpc: failed backplane access over SDIO, halting operation
> brcmfmac: brcmf_sdio_dpc: failed backplane access over SDIO, halting operation

Hi Carlo,

This smells like a firmware crash. Upon the brcmf_bus_start failure we
bail out on the probe. I suspect in the error path there is an issue
introduced (or exposed) by the mentioned patch. Did not look further
into it as the family is giving me the angry look during the holidays ;-)

Regards,
Arend

> With a messy trace similar to
> https://gist.github.com/carlocaione/06d17124a2589f3d4108
> 
> Any idea what's going on?
> 
> Thanks
> 
