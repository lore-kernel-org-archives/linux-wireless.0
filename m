Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0EZMxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 08:53:14 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 14:53:11 +0200
Message-ID: <1274878391.3658.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 15:48 +0300, Juuso Oikarinen wrote:
> Currently the mac80211 marks rates 1 and 2 mbps as basic rates for created
> ad-hoc networks. To be certifiable, rates 1, 2, 5.5 and 11 need to be marked
> basic.
> 
> Change this.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  net/mac80211/ibss.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index b2cc1fd..0b8360c 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -529,7 +529,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
>  		sdata->drop_unencrypted = 0;
>  
>  	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
> -				  ifibss->channel, 3, /* first two are basic */
> +				  ifibss->channel,
> +				  15, /* 1, 2, 5.5 and 11 are basic */

It's still wrong for 5 GHz.

We've had this discussion before. Making more rates required will break
compatibility with 11b devices.

What should be done here is add a basic rates parameter to the IBSS join
nl80211 command so that you can decide at runtime which rates to use as
basic.

johannes

