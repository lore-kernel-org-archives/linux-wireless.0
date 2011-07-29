Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:51508 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305Ab1G2SSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 14:18:47 -0400
Date: Fri, 29 Jul 2011 18:00:42 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] pcmcia: add PCMCIA_DEVICE_MANF_CARD_PROD_ID3
Message-ID: <20110729160041.GB15474@comet.dominikbrodowski.net> (sfid-20110729_201851_412008_4CE06AC5)
References: <20110726225235.29951.70265.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110726225235.29951.70265.stgit@mj.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied all three patches to -pcmcia.

Thanks,
	Dominik

On Tue, Jul 26, 2011 at 06:52:35PM -0400, Pavel Roskin wrote:
> This is needed to match wireless cards with Intersil firmware that have
> ID 0x0156:0x0002 and the third ID "Version 01.02".  Such cards are
> currently matched by orinoco_cs, which doesn't support WPA.  They should
> be matched by hostap_cs.
> 
> The first and the second product ID vary widely, so there are few users
> with some particular IDs.  Of those, very few can submit a patch for
> hostap_cs or write a useful bugreport.  It's still important to support
> their hardware properly.
> 
> With PCMCIA_DEVICE_MANF_CARD_PROD_ID3, it should be possible to cover
> the remaining Intersil based designs that kept the numeric ID and the
> "version" of the reference design.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  include/pcmcia/device_id.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/pcmcia/device_id.h b/include/pcmcia/device_id.h
> index 63e5b8f..00dbfac 100644
> --- a/include/pcmcia/device_id.h
> +++ b/include/pcmcia/device_id.h
> @@ -95,6 +95,15 @@
>  	.prod_id = { (v1), NULL, NULL, NULL }, \
>  	.prod_id_hash = { (vh1), 0, 0, 0 }, }
>  
> +#define PCMCIA_DEVICE_MANF_CARD_PROD_ID3(manf, card, v3, vh3) { \
> +	.match_flags = PCMCIA_DEV_ID_MATCH_MANF_ID| \
> +			PCMCIA_DEV_ID_MATCH_CARD_ID| \
> +			PCMCIA_DEV_ID_MATCH_PROD_ID3, \
> +	.manf_id = (manf), \
> +	.card_id = (card), \
> +	.prod_id = { NULL, NULL, (v3), NULL }, \
> +	.prod_id_hash = { 0, 0, (vh3), 0 }, }
> +
>  
>  /* multi-function devices */
>  
> 
> _______________________________________________
> Linux PCMCIA reimplementation list
> http://lists.infradead.org/mailman/listinfo/linux-pcmcia
