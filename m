Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299AbYA1QpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:45:18 -0500
Subject: Re: [PATCH] libertas: make lbs_unset_basic_rate_flags() static
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200801281727.03358.hs4233@mail.mn-solutions.de>
References: <200801281727.03358.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 11:40:10 -0500
Message-Id: <1201538410.14441.9.camel@localhost.localdomain> (sfid-20080128_164522_476876_1B63C8F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-01-28 at 17:27 +0100, Holger Schurig wrote:
> ... by moving it into the file where it's sole user resides
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-2.6/drivers/net/wireless/libertas/join.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/join.c	2008-01-17 10:31:26.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/join.c	2008-01-17 10:32:01.000000000 +0100
> @@ -99,23 +99,6 @@ static void lbs_set_basic_rate_flags(u8 
>  }
>  
>  /**
> - *  @brief Unsets the MSB on basic rates
> - *
> - * Scan through an array and unset the MSB for basic data rates.
> - *
> - *  @param rates     buffer of data rates
> - *  @param len       size of buffer
> - */
> -void lbs_unset_basic_rate_flags(u8 *rates, size_t len)
> -{
> -	int i;
> -
> -	for (i = 0; i < len; i++)
> -		rates[i] &= 0x7f;
> -}
> -
> -
> -/**
>   *  @brief Associate to a specific BSS discovered in a scan
>   *
>   *  @param priv      A pointer to struct lbs_private structure
> Index: wireless-2.6/drivers/net/wireless/libertas/join.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/join.h	2008-01-17 10:32:17.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/join.h	2008-01-17 10:32:21.000000000 +0100
> @@ -48,6 +48,4 @@ int lbs_send_deauthentication(struct lbs
>  
>  int lbs_associate(struct lbs_private *priv, struct assoc_request *assoc_req);
>  
> -void lbs_unset_basic_rate_flags(u8 *rates, size_t len);
> -
>  #endif
> Index: wireless-2.6/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c	2008-01-17 10:31:26.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/scan.c	2008-01-17 10:31:53.000000000 +0100
> @@ -73,6 +73,23 @@ static const u8 bcastmac[ETH_ALEN] = { 0
>  /*                                                                   */
>  /*********************************************************************/
>  
> +/**
> + *  @brief Unsets the MSB on basic rates
> + *
> + * Scan through an array and unset the MSB for basic data rates.
> + *
> + *  @param rates     buffer of data rates
> + *  @param len       size of buffer
> + */
> +static void lbs_unset_basic_rate_flags(u8 *rates, size_t len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++)
> +		rates[i] &= 0x7f;
> +}
> +
> +
>  static inline void clear_bss_descriptor (struct bss_descriptor * bss)
>  {
>  	/* Don't blow away ->list, just BSS data */

