Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755860AbeFOIIO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 04:08:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w5F83wis021127
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2018 04:08:14 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2jm8kd2nrx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2018 04:08:14 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <freude@linux.ibm.com>;
        Fri, 15 Jun 2018 09:08:11 +0100
Subject: Re: [PATCH] hw_random: Always drop the RNG in hwrng_unregister()
To: =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Wirz <spam@lukas-wirz.de>, linux-crypto@vger.kernel.org,
        b43-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
References: <20180614200811.76401d95@wiggum>
From: Harald Freudenberger <freude@linux.ibm.com>
Date: Fri, 15 Jun 2018 10:08:12 +0200
MIME-Version: 1.0
In-Reply-To: <20180614200811.76401d95@wiggum>
Content-Type: text/plain; charset=utf-8
Message-Id: <8f1f5be1-979c-7601-1419-907b1980d974@linux.ibm.com> (sfid-20180615_100818_542313_0F2DD722)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14.06.2018 20:08, Michael Büsch wrote:
> enable_best_rng() is used in hwrng_unregister() to switch away from the
> currently active RNG, if that is the one currently being removed.
> However enable_best_rng() might fail, if the next RNG's init routine
> fails. In that case enable_best_rng() will return an error code and
> the currently active RNG will remain active.
> After unregistering this might lead to crashes due to use-after-free.
>
> Fix this by dropping the currently active RNG, if enable_best_rng()
> failed. This will result in no RNG to be active, if the next-best
> one failed to initialize.
>
> This problem was introduced by 142a27f0a731ddcf467546960a5585970ca98e21
>
>
> Reported-by: Wirz <spam@lukas-wirz.de>
> Tested-by: Wirz <spam@lukas-wirz.de>
> Signed-off-by: Michael Büsch <m@bues.ch>
> Cc: stable@vger.kernel.org
>
> ---
>
> See this discussion for a crash in b43's hwrng caused by this problem:
> https://www.spinics.net/lists/linux-wireless/msg173089.html
>
>
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 91bb98c42a1c..aaf9e5afaad4 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -516,11 +516,18 @@ EXPORT_SYMBOL_GPL(hwrng_register);
>  
>  void hwrng_unregister(struct hwrng *rng)
>  {
> +	int err;
> +
>  	mutex_lock(&rng_mutex);
>  
>  	list_del(&rng->list);
> -	if (current_rng == rng)
> -		enable_best_rng();
> +	if (current_rng == rng) {
> +		err = enable_best_rng();
> +		if (err) {
> +			drop_current_rng();
> +			cur_rng_set_by_user = 0;
> +		}
> +	}
>  
>  	if (list_empty(&rng_list)) {
>  		mutex_unlock(&rng_mutex);
>
>
>
Yes, if the hw_init() of the newly chosen rng fails, enable_best_rng() comes
back with an error and did not drop the current rng. The patch handles
this case. I did not test it, but the code looks fine.

reviewed-by Harald Freudenberger <freude@linux.ibm.com>
