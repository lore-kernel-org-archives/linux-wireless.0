Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1HHP7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 11:59:06 -0400
Subject: Re: [PATCH] mac80211: clear sta.drv_priv on reconfiguration
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312811422-24911-1-git-send-email-eliad@wizery.com> (sfid-20110808_155032_855733_6A9FD1E3)
References: <1312811422-24911-1-git-send-email-eliad@wizery.com>
	 (sfid-20110808_155032_855733_6A9FD1E3)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:59:05 +0200
Message-ID: <1312819145.4372.38.camel@jlt3.sipsolutions.net> (sfid-20110808_175911_115446_2B0D2475)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 16:50 +0300, Eliad Peller wrote:
> drivers might assume sta.drv_priv is clear while
> the sta is added, so clear it on reconfinguration.


Seems fine,
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/util.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 652e569..23cea7d 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1196,6 +1196,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  					     struct ieee80211_sub_if_data,
>  					     u.ap);
>  
> +			memset(&sta->sta.drv_priv, 0, hw->sta_data_size);
>  			WARN_ON(drv_sta_add(local, sdata, &sta->sta));
>  		}
>  	}


