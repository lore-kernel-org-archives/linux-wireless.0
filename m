Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:17585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbZHNMlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:41:18 -0400
Received: by fg-out-1718.google.com with SMTP id e21so334444fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 05:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A855489.6010102@gmail.com>
References: <4A855489.6010102@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 14:40:58 +0200
Message-ID: <69e28c910908140540p55904f27m1d3b609c7b317e12@mail.gmail.com>
Subject: Re: [PATCH] ssb: Fix e typo in the rev8 SPROM extraction routine
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, please fix the typo in the commit name... how ironic this is a
typo fix patch. :-)

2009/8/14 Gábor Stefanik <netrolller.3d@gmail.com>:
> No comment. :-)
>
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Mark, this should fix your MAC address bug.
> Anyone else testing LP-PHY should also apply this.
>
> drivers/ssb/pci.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 50811e4..335a43f 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -480,7 +480,7 @@ static void sprom_extract_r8(struct ssb_sprom *out,
> const u16 *in)
>
>        /* extract the MAC address */
>        for (i = 0; i < 3; i++) {
> -               v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
> +               v = in[SPOFF(SSB_SPROM8_IL0MAC) + i];
>                *(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
>        }
>        SPEX(country_code, SSB_SPROM8_CCODE, 0xFFFF, 0);
> --
> 1.6.2.4
>
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
