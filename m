Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40700 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2BNNe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 08:34:59 -0500
Received: by werb13 with SMTP id b13so4154272wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 05:34:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120214040120.GA2077@eris.garyseven.net>
References: <20120214040120.GA2077@eris.garyseven.net>
Date: Tue, 14 Feb 2012 14:34:58 +0100
Message-ID: <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com> (sfid-20120214_143502_855441_D905CAB1)
Subject: Re: [RFC] use alternate SPROM offset for 43224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Saul St. John" <saul.stjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 lutego 2012 05:01 użytkownik Saul St. John
<saul.stjohn@gmail.com> napisał:
> I don't know if this is correct in the general sense, but the wireless on my
> mid-2010 MacBook Pro doesn't work without it.
>
> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
> ---
>  drivers/bcma/sprom.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 6f230fb..06c87b5 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -228,8 +228,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
>        /* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
>         * According to brcm80211 this applies to cards with PCIe rev >= 6
>         * TODO: understand this condition and use it */
> -       offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
> -               BCMA_CC_SPROM_PCIE6;
> +       offset = (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43224) ?
> +                       BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;
>        bcma_sprom_read(bus, offset, sprom);
>
>        if (bus->chipinfo.id == 0x4331)

I'm quite sure it'll break my BCM43224. It's not chip-specific,
probably some status bit specific.

-- 
Rafał
