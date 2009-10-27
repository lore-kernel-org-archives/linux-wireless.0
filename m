Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbZJ0QIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:08:36 -0400
Subject: Re: [PATCH v2 2/3] mac80211: fix dynamic power save for devices
 with nullfunc support in hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20091027153616.27827.46490.stgit@tikku>
References: <20091027153608.27827.70629.stgit@tikku>
	 <20091027153616.27827.46490.stgit@tikku>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 17:08:08 +0100
Message-ID: <1256659688.4237.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-10-27 at 17:36 +0200, Kalle Valo wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
> 
> In TX path it was assumed that dynamic power save works only if
> IEEE80211_HW_PS_NULLFUNC_STACK is set. But is not the case, there are
> devices which have nullfunc support in hardware but need mac80211
> to handle dynamic power save timers, TI's wl1251 is one of them.
> 
> The fix is to not check for IEEE80211_HW_PS_NULLFUNC_STACK in
> is_dynamic_ps_enabled(), instead check IEEE80211_HW_SUPPORTS_PS and
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS flags and act accordingly.
> 
> Tested with wl1251.
> 
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> 
>  net/mac80211/tx.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index c59ed84..66dab40 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1390,7 +1390,11 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
>  static bool need_dynamic_ps(struct ieee80211_local *local)
>  {
>  	/* driver doesn't support power save */
> -	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> +	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
> +		return false;
> +
> +	/* hardware does dynamic power save */
> +	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
>  		return false;
>  
>  	/* dynamic power save disabled */
> 
> 


