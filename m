Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2BWJ12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 04:27:28 -0500
Subject: Re: [PATCH] mac80211: use proper sub_if_data on suspend path
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1329959868-10989-1-git-send-email-kubakici@wp.pl>
References: <1329959868-10989-1-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 10:27:22 +0100
Message-ID: <1329989242.3448.0.camel@jlt3.sipsolutions.net> (sfid-20120223_102738_252839_E712041F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 02:17 +0100, Jakub Kicinski wrote:
> Use interface data from sta instead of invalid pointer
> to list head in calls to drv_sta_state.

Good catch, thanks

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> ---
>  net/mac80211/pm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index 2b53a53..ef8eba1 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -102,7 +102,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>  
>  			state = sta->sta_state;
>  			for (; state > IEEE80211_STA_NOTEXIST; state--)
> -				WARN_ON(drv_sta_state(local, sdata, sta,
> +				WARN_ON(drv_sta_state(local, sta->sdata, sta,
>  						      state, state - 1));
>  		}
>  


