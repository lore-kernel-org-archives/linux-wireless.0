Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36921 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1JJOXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 10:23:31 -0400
Received: by wyg34 with SMTP id 34so5939532wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 07:23:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317575685-3156-5-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
	<1317575685-3156-5-git-send-email-frankyl@broadcom.com>
Date: Mon, 10 Oct 2011 16:23:28 +0200
Message-ID: <CACna6rzFQZqed3ZfRxcd_WCvOsjKgeDd=T8EgtgpJttmTO3+cg@mail.gmail.com> (sfid-20111010_162334_610639_EEC8404F)
Subject: Re: [PATCH 04/20] staging: brcm80211: various __iomem additions to softmac.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/10/2 Franky Lin <frankyl@broadcom.com>:
> From: Roland Vossen <rvossen@broadcom.com>
>
> So it is clear to the reader what memory is IO mapped
>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmsmac/aiutils.c |  107 ++++++++++++++------------
>  drivers/staging/brcm80211/brcmsmac/aiutils.h |   16 ++--
>  drivers/staging/brcm80211/brcmsmac/main.c    |    2 +-
>  drivers/staging/brcm80211/brcmsmac/nicpci.c  |   45 ++++++-----
>  drivers/staging/brcm80211/brcmsmac/nicpci.h  |    9 +-
>  drivers/staging/brcm80211/brcmsmac/otp.c     |    9 +-
>  drivers/staging/brcm80211/brcmsmac/pmu.c     |   16 ++--
>  drivers/staging/brcm80211/brcmsmac/srom.c    |   20 +++--
>  drivers/staging/brcm80211/brcmsmac/srom.h    |    2 +-
>  9 files changed, 123 insertions(+), 103 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
> index 790fdce..0b3ba6a 100644
> --- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
> +++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
> @@ -323,7 +323,8 @@
>                     (((si)->pub.buscoretype == PCI_CORE_ID) && \
>                      (si)->pub.buscorerev >= 13))
>
> -#define CCREGS_FAST(si) (((char *)((si)->curmap) + PCI_16KB0_CCREGS_OFFSET))
> +#define CCREGS_FAST(si) (((char __iomem *)((si)->curmap) + \
> +                         PCI_16KB0_CCREGS_OFFSET))

I've a question (not to just you), should we prefer u8/u16/u32 types in code?
If so, you could think to changing this since you already touch this code.

-- 
Rafał
