Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52336 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0FGICQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 04:02:16 -0400
Subject: Re: [PATCH] mac80211: make ARP filtering depend on CONFIG_INET
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1275676087-20039-1-git-send-email-linville@tuxdriver.com>
References: <20100604153006.fa15c770.sfr@canb.auug.org.au>
	 <1275676087-20039-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 11:01:50 +0300
Message-ID: <1275897710.5277.29986.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2010-06-04 at 20:28 +0200, ext John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/main.c |    6 ++++++
>  net/mac80211/mlme.c |    2 ++
>  2 files changed, 8 insertions(+), 0 deletions(-)



> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7e72013..3623bb7 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2078,6 +2078,7 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
>  			cfg80211_send_assoc_timeout(wk->sdata->dev,
>  						    wk->filter_ta);
>  			return WORK_DONE_DESTROY;
> +#ifdef CONFIG_INET
>  		} else {
>  			mutex_unlock(&wk->sdata->u.mgd.mtx);
>  
> @@ -2088,6 +2089,7 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
>  			rtnl_lock();
>  			ieee80211_set_arp_filter(wk->sdata);
>  			rtnl_unlock();
> +#endif
>  		}

Here, if CONFIG_INET is not set, and the previous condition is not true,
the mutex will not be unlocked.

The arp-filter code here is causing some locking issues, so I'll need to
move it elsewhere anyway. I can also fix the unlocking while at it.

-Juuso

>  	}
>  


