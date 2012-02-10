Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37560 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658Ab2BJA1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 19:27:06 -0500
Received: by iacb35 with SMTP id b35so3243404iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2012 16:27:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328837032-26137-1-git-send-email-stas.yakovlev@gmail.com>
References: <1328837032-26137-1-git-send-email-stas.yakovlev@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Feb 2012 11:26:46 +1100
Message-ID: <CAGRGNgWVsGt08gxoyaoG7sG7NgubF+qqjk=LaCruRJiUe1fuig@mail.gmail.com> (sfid-20120210_012711_951925_9D3FA999)
Subject: Re: [PATCH] ipw2x00: remove ipw2100_rates_11b[]
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislav,

On Fri, Feb 10, 2012 at 12:23, Stanislav Yakovlev
<stas.yakovlev@gmail.com> wrote:
> It's just a duplicate of ipw2100_bg_rates[].

Looks sensible to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> ---
>  drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
> index a0e5c21..63567fb 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> @@ -309,13 +309,6 @@ static const long ipw2100_frequencies[] = {
>
>  #define FREQ_COUNT     ARRAY_SIZE(ipw2100_frequencies)
>
> -static const long ipw2100_rates_11b[] = {
> -       1000000,
> -       2000000,
> -       5500000,
> -       11000000
> -};
> -
>  static struct ieee80211_rate ipw2100_bg_rates[] = {
>        { .bitrate = 10 },
>        { .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
> @@ -323,7 +316,7 @@ static struct ieee80211_rate ipw2100_bg_rates[] = {
>        { .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
>  };
>
> -#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
> +#define RATE_COUNT ARRAY_SIZE(ipw2100_bg_rates)
>
>  /* Pre-decl until we get the code solid and then we can clean it up */
>  static void ipw2100_tx_send_commands(struct ipw2100_priv *priv);
> @@ -6896,7 +6889,7 @@ static int ipw2100_wx_get_range(struct net_device *dev,
>        range->num_bitrates = RATE_COUNT;
>
>        for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++) {
> -               range->bitrate[i] = ipw2100_rates_11b[i];
> +               range->bitrate[i] = ipw2100_bg_rates[i].bitrate * 100 * 1000;
>        }
>
>        range->min_rts = MIN_RTS_THRESHOLD;
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
