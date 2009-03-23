Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43395 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZCWQNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:13:34 -0400
Subject: Re: [PATCH1/2] Fix return value handling
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200903231659.48903.marek.vasut@gmail.com>
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903231313.10699.hs4233@mail.mn-solutions.de>
	 <200903231657.24399.marek.vasut@gmail.com>
	 <200903231659.48903.marek.vasut@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 12:11:09 -0400
Message-Id: <1237824669.14758.16.camel@localhost.localdomain> (sfid-20090323_171338_526696_55D87994)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-23 at 16:59 +0100, Marek Vasut wrote:
> On Monday 23 of March 2009 16:57:24 Marek Vasut wrote:
> > Hi,
> > here is a resend. One patch per mail.
> sorry, inlining
> 
> From fd2e610a87a8372cbc513e336fa71e3438742c9d Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Mon, 23 Mar 2009 15:57:11 +0100
> Subject: [PATCH 1/2] Firmware loading functions can return possitive values
>  This is not a bug, but take it into consideration and handle it properly.

This patch should no longer be required, since the patch "libertas: fix
CF firmware loading for some cards" was applied.  The firmware helpers
should only return an error (< 0) or 0 (success).

Dan

> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/net/wireless/libertas/if_cs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c 
> b/drivers/net/wireless/libertas/if_cs.c
> index 842a08d..3f02e6a 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -867,9 +867,9 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
>  
>  	/* Load the firmware early, before calling into libertas.ko */
>  	ret = if_cs_prog_helper(card);
> -	if (ret == 0)
> +	if (ret >= 0)
>  		ret = if_cs_prog_real(card);
> -	if (ret)
> +	if (ret < 0)
>  		goto out2;
>  
>  	/* Make this card known to the libertas driver */

