Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47788 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbXFKQWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 12:22:07 -0400
Message-ID: <466D76AC.1090308@lwfinger.net>
Date: Mon, 11 Jun 2007 11:22:04 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] fix oversight in "mac80211: Set low initial rate in rc80211_simple"
References: <1181542241.3566.23.camel@johannes.berg>
In-Reply-To: <1181542241.3566.23.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This fixes a logic oversight in the patch "mac80211: Set low initial
> rate in rc80211_simple".
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
> --- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-06-11 08:08:55.301879260 +0200
> +++ wireless-dev/net/mac80211/rc80211_simple.c	2007-06-11 08:09:06.791879260 +0200
> @@ -289,9 +289,10 @@ static void rate_control_simple_rate_ini
>  	 * as a workaround, */
>  	for (i = 0; i < mode->num_rates; i++) {
>  		if ((sta->supp_rates & BIT(i)) &&
> -		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
> +		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED)) {
>  			sta->txrate = i;
>  			break;
> +		}
>  	}
>  }

Thanks for this one - it is what I intended all along as indicated by the indentation. Now I 
understand Michael Wu's comments regarding the loop.

Larry
