Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1LHIQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 03:16:13 -0500
Subject: Re: [patch] mac80211: unlock on error path in ieee80211_ibss_join()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Simon <an.alexsimon@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20111208064903.GA16735@elgon.mountain>
References: <20111208064903.GA16735@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 09:16:05 +0100
Message-ID: <1323332165.3332.0.camel@jlt3.sipsolutions.net> (sfid-20111208_091643_286932_C750254B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 09:49 +0300, Dan Carpenter wrote:
> We recently introduced a new return here but it needs an unlock first.

Thanks Dan! Bad Alex :-)

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 3f830ac..0fc9752 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -993,8 +993,10 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
>  	if (params->channel_fixed) {
>  		sdata->local->oper_channel = params->channel;
>  		if (!ieee80211_set_channel_type(sdata->local, sdata,
> -					       params->channel_type))
> +					       params->channel_type)) {
> +			mutex_unlock(&sdata->u.ibss.mtx);
>  			return -EINVAL;
> +		}
>  	}
>  
>  	if (params->ie) {
> 


