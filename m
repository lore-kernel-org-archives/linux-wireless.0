Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXGFEO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 00:14:58 -0400
Subject: Re: [PATCH 2/2] libertas: remove bss_descriptor->timestamp
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200707040859.49814.hs4233@mail.mn-solutions.de>
References: <200707040859.49814.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 00:19:38 -0400
Message-Id: <1183695578.24555.41.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-04 at 08:59 +0200, Holger Schurig wrote:
> Noone used this variable.

All the ones that I didn't say "holding off on ..." are committed,
thanks.

Dan

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> ---
>  drivers/net/wireless/libertas/scan.c |    1 -
>  drivers/net/wireless/libertas/scan.h |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index aea2e90..5c730b9 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -903,7 +903,6 @@ static int libertas_process_bss(struct bss_descriptor * bss,
>  	pos++;
>  
>  	/* time stamp is 8 bytes long */
> -	bss->timestamp = le64_to_cpup((void *) pos);
>  	pos += 8;
>  
>  	/* beacon interval is 2 bytes long */
> diff --git a/drivers/net/wireless/libertas/scan.h b/drivers/net/wireless/libertas/scan.h
> index 28decf3..9bb1a43 100644
> --- a/drivers/net/wireless/libertas/scan.h
> +++ b/drivers/net/wireless/libertas/scan.h
> @@ -157,7 +157,6 @@ struct bss_descriptor {
>  	/* zero-terminated array of supported data rates */
>  	u8 rates[MAX_RATES + 1];
>  
> -	__le64 timestamp;	//!< TSF value included in the beacon/probe response
>  	unsigned long last_scanned;
>  
>  	union ieeetypes_phyparamset phyparamset;

