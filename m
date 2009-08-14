Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53304 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZHNUyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:54:02 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] ssb: Fix e typo in the rev8 SPROM extraction routine
Date: Fri, 14 Aug 2009 22:53:58 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A855489.6010102@gmail.com>
In-Reply-To: <4A855489.6010102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908142253.58702.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 14:11:53 Gábor Stefanik wrote:
> No comment. :-)
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Mark, this should fix your MAC address bug.
> Anyone else testing LP-PHY should also apply this.
> 
>  drivers/ssb/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 50811e4..335a43f 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -480,7 +480,7 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
>  
>  	/* extract the MAC address */
>  	for (i = 0; i < 3; i++) {
> -		v = in[SPOFF(SSB_SPROM1_IL0MAC) + i];
> +		v = in[SPOFF(SSB_SPROM8_IL0MAC) + i];
>  		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
>  	}
>  	SPEX(country_code, SSB_SPROM8_CCODE, 0xFFFF, 0);

ack

-- 
Greetings, Michael.
