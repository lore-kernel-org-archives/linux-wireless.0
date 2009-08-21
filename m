Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZHUNXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 09:23:52 -0400
Subject: Re: [PATCH] libertas: don't use dynamic-sized array
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1250701760.5351.42.camel@localhost.localdomain>
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
	 <1250210080-21960-1-git-send-email-andrey@cozybit.com>
	 <1250701760.5351.42.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 08:24:00 -0500
Message-Id: <1250861040.2876.22.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-19 at 12:09 -0500, Dan Williams wrote:
> On Thu, 2009-08-13 at 17:34 -0700, Andrey Yurovsky wrote:
> > sparse complains about a bad constant expression due to the use of a
> > dynamic-sized array in get_common_rates().  Allocate and free the array
> > instead.
> 
> Mind testing this patch from libertas-dev?  It should fix this but also
> clears up some of the confustion:

FWIW this patch now tested with sd8686.

Dan

>                            Subject: 
> Re: Libertas: Association request to
> the driver failed
>                               Date: 
> Wed, 12 Aug 2009 12:34:17 -0500
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index 1902b6f..8c05388 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -35,7 +35,8 @@ static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
>   *
>   *  @param priv     A pointer to struct lbs_private structure
>   *  @param rates       the buffer which keeps input and output
> - *  @param rates_size  the size of rate1 buffer; new size of buffer on return
> + *  @param rates_size  the size of rates buffer; new size of buffer on return,
> + *                     which will be less than or equal to original rates_size
>   *
>   *  @return            0 on success, or -1 on error
>   */
> @@ -43,39 +44,42 @@ static int get_common_rates(struct lbs_private *priv,
>         u8 *rates,
>         u16 *rates_size)
>  {
> -       u8 *card_rates = lbs_bg_rates;
> -       int ret = 0, i, j;
> -       u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
> -       size_t tmp_size = 0;
> -
> -       /* For each rate in card_rates that exists in rate1, copy to tmp */
> -       for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
> -               for (j = 0; j < *rates_size && rates[j]; j++) {
> -                       if (rates[j] == card_rates[i])
> -                               tmp[tmp_size++] = card_rates[i];
> +       int i, j;
> +       u8 intersection[MAX_RATES];
> +       u16 intersection_size;
> +       u16 num_rates = 0;
> +
> +       intersection_size = min_t(u16, *rates_size, ARRAY_SIZE(intersection));
> +
> +       /* Allow each rate from 'rates' that is supported by the hardware */
> +       for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && lbs_bg_rates[i]; i++) {
> +               for (j = 0; j < intersection_size && rates[j]; j++) {
> +                       if (rates[j] == lbs_bg_rates[i])
> +                               intersection[num_rates++] = rates[j];
>                 }
>         }
>  
>         lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
> -       lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
> +       lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", lbs_bg_rates,
>                         ARRAY_SIZE(lbs_bg_rates));
> -       lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
> +       lbs_deb_hex(LBS_DEB_JOIN, "common rates", intersection, num_rates);
>         lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
>  
>         if (!priv->enablehwauto) {
> -               for (i = 0; i < tmp_size; i++) {
> -                       if (tmp[i] == priv->cur_rate)
> +               for (i = 0; i < num_rates; i++) {
> +                       if (intersection[i] == priv->cur_rate)
>                                 goto done;
>                 }
>                 lbs_pr_alert("Previously set fixed data rate %#x isn't "
>                        "compatible with the network.\n", priv->cur_rate);
> -               ret = -1;
> +               return -1;
>         }
> +
>  done:
>         memset(rates, 0, *rates_size);
> -       *rates_size = min_t(int, tmp_size, *rates_size);
> -       memcpy(rates, tmp, *rates_size);
> -       return ret;
> +       *rates_size = num_rates;
> +       memcpy(rates, intersection, num_rates);
> +       return 0;
>  }
>  
> 
> @@ -317,8 +321,8 @@ static int lbs_associate(struct lbs_private *priv,
>  
>         rates = (struct mrvl_ie_rates_param_set *) pos;
>         rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
> -       memcpy(&rates->rates, &bss->rates, MAX_RATES);
> -       tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
> +       tmplen = min_t(u16, ARRAY_SIZE(bss->rates), MAX_RATES);
> +       memcpy(&rates->rates, &bss->rates, tmplen);
>         if (get_common_rates(priv, rates->rates, &tmplen)) {
>                 ret = -1;
>                 goto done;
> @@ -592,7 +596,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
>  
>         /* Copy Data rates from the rates recorded in scan response */
>         memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
> -       ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
> +       ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), ARRAY_SIZE (bss->rates));
>         memcpy(cmd.bss.rates, bss->rates, ratesize);
>         if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
>                 lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

