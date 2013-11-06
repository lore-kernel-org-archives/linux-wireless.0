Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45023 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3KFFYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 00:24:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21113.53593.471557.385898@gargle.gargle.HOWL> (sfid-20131106_062407_544518_3629F08E)
Date: Wed, 6 Nov 2013 10:49:21 +0530
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] ath9k: fix SC_OP_INVALID test in ath9k_tx99_init()
In-Reply-To: <20131105202034.GC3949@elgon.mountain>
References: <20131105202034.GC3949@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> SC_OP_INVALID is zero so the test is always false.  We're supposed to be
> testing the lowest bit instead.
> 
> Fixes: 89f927af7f33 ('ath9k: add TX99 support')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 74f452c..7ad4e11 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2456,7 +2456,7 @@ int ath9k_tx99_init(struct ath_softc *sc)
>  	struct ath_tx_control txctl;
>  	int r;
>  
> -	if (sc->sc_flags & SC_OP_INVALID) {
> +	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
>  		ath_err(common,
>  			"driver is in invalid state unable to use TX99");
>  		return -EINVAL;

Nice catch.

The tx99 code in ath9k has been moved to a separate file, is it okay if I adopt
this patch and update it ?

Sujith
