Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38504 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbbG1OpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 10:45:14 -0400
Date: Tue, 28 Jul 2015 10:43:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kei Kishiro <kei@kishiro.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ipw2x00: Adding active 11a wireless band support for
 Intel 2915abg (ZZJ:Japan)
Message-ID: <20150728144334.GC17081@tuxdriver.com> (sfid-20150728_164525_801674_AE516B9D)
References: <55B77FC6.4040108@kishiro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55B77FC6.4040108@kishiro.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2015 at 10:12:38PM +0900, Kei Kishiro wrote:
> Hi all,
> 
> 
> Current ipw2200 driver cannot establish 11a wireless connection
> using 2915abg device with countrycode ZZJ(for Japan), because of
> mismatch of wireless band definition.
> 
> Current wireless band definition at section "ZZJ" in ipw2200.c
> (at /usr/src/linux-3.4/drivers/net/wireless/ipw2x00) is J52 and
> this wireless band was already discontinued in Japan.
> 
> Definition about J52 should be replaced to active W52 band.
> And new definition about W53 and W56 band should be added to
> this section.
> 
> 
> Because ipw2000 driver was already discontinued and Intel
> provides no support anymore, I propose this offer to
> this mailinglist.
> 
> 
> More detailed information about J52,W52,W53 and W56 is below:

I'm setting aside the patch posting niceties for now -- if we decide
that this patch is acceptable then we can provide further guidance
on that later...

Given the regulatory nature of this patch, I invited Intel to
comment (in bugzilla) as to the appropriateness.  Unfortunately,
Intel abandoned this driver long ago.  Hence, they refused to provide
any guidance on this patch.

My opinion is that at least the first four channel changes are minor
and they would seem to bring operators of these devices into compliance
with current regulations.  I would think that merging at least that
part of the patch is for the best.  If we are truly paranoid, perhaps
the 4th channel could be left out since it extends beyond the original
operating range.

The other 15 channels seem more problematic, since no certification
over that range would have been done with the devices in question
sold in Japan.

Thoughts?

John

> ========
> [J52]
> 
>  34ch: 5170MHz
>  38ch: 5190MHz
>  42ch: 5210MHz
>  46ch: 5230MHz
> 
> * Japanese local band for 11a wireless connection.
> * This band was defined by Soumushou (Ministry of Internal Affairs
>   and Communications) in Japan before WRC-03 and had been making us
>   irritated.
> * Each channel have 10MHz offset from worldwide standard channels.
> * This band was discontinued at 2008/05/31 and further use was
>   forbidden.
> 
> [W52]
> 
>  36ch: 5180MHz
>  40ch: 5200MHz
>  44ch: 5220MHz
>  48ch: 5240MHz
> 
> * Wireless band having compatibility with world wide standard 11a
>   channels.
> * This band was launched at 2005/05/16 in Japan.
> 
> [W53]
> 
>  52ch: 5260MHz
>  56ch: 5280MHz
>  60ch: 5300MHz
>  64ch: 5320MHz
> 
> * Wireless band having compatibility with world wide standard 11a
>   channels.
> * This band was launched at 2005/05/16 in Japan (same as W52).
> * This band needs DFS (Dynamic Frequency Selection) and TPC
>   (Transmission Power Control) function for AP, passive scan
>   function for client in Japan.
> 
> [W56]
> 
>  100ch: 5500MHz
>  104ch: 5520MHz
>  108ch: 5540MHz
>  112ch: 5560MHz
>  116ch: 5580MHz
>  120ch: 5600MHz
>  124ch: 5620MHz
>  128ch: 5640MHz
>  132ch: 5660MHz
>  136ch: 5680MHz
>  140ch: 5700MHz
> 
> * Wireless band having compatibility with world wide standard 11a
>   channels.
> * This band was launched at 2007/01 in Japan.
> * This band needs DFS (Dynamic Frequency Selection) and TPC
>   (Transmission Power Control) function for AP, passive scan
>   function for client in Japan.
> 
> ========
> 
> Thank you for your consideration.
> 
> 
> Signed-off-by: Kei Kishiro <linux@kishiro.com>
> ---
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 3dd80df..2d292a0 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -11157,7 +11157,7 @@ static const struct libipw_geo ipw_geos[] = {
>  	       {5700, 140, LIBIPW_CH_PASSIVE_ONLY}},
>  	 },
> 
> -	{			/* Custom Japan */
> +	{			/* Custom Japan Modified */
>  	 "ZZJ",
>  	 .bg_channels = 14,
>  	 .bg = {{2412, 1}, {2417, 2}, {2422, 3},
> @@ -11165,9 +11165,26 @@ static const struct libipw_geo ipw_geos[] = {
>  		{2442, 7}, {2447, 8}, {2452, 9},
>  		{2457, 10}, {2462, 11}, {2467, 12},
>  		{2472, 13}, {2484, 14, LIBIPW_CH_B_ONLY}},
> -	 .a_channels = 4,
> -	 .a = {{5170, 34}, {5190, 38},
> -	       {5210, 42}, {5230, 46}},
> +	 .a_channels = 19,
> +	 .a = {{5180, 36},
> +	       {5200, 40},
> +	       {5220, 44},
> +	       {5240, 48},
> +	       {5260, 52, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5280, 56, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5300, 60, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5320, 64, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5500, 100, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5520, 104, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5540, 108, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5560, 112, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5580, 116, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5600, 120, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5620, 124, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5640, 128, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5660, 132, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5680, 136, LIBIPW_CH_PASSIVE_ONLY},
> +	       {5700, 140, LIBIPW_CH_PASSIVE_ONLY}},
>  	 },
> 
>  	{			/* Rest of World */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
