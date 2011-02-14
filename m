Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1BNMGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:06:32 -0500
Subject: Re: [PATCH 1/2] mac80211: add monitor interface into PS disable
 list
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1297253799-9688-1-git-send-email-rmanoharan@atheros.com>
References: <1297253799-9688-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:06:27 +0100
Message-ID: <1297685187.3785.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 17:46 +0530, Rajkumar Manoharan wrote:
> PS should be disabled in the presence of monitor interface.

I'm not really sure -- should it? You can have monitors with no flags to
do see what you're receiving locally, so I prefer the current behaviour.
If you really want to monitor everything you pretty much need to
disconnect anyway, I think?

johannes

> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  net/mac80211/mlme.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index f77adf1..8fc6d35 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -630,13 +630,13 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
>  	list_for_each_entry(sdata, &local->interfaces, list) {
>  		if (!ieee80211_sdata_running(sdata))
>  			continue;
> -		if (sdata->vif.type == NL80211_IFTYPE_AP) {
> -			/* If an AP vif is found, then disable PS
> -			 * by setting the count to zero thereby setting
> -			 * ps_sdata to NULL.
> +		if ((sdata->vif.type == NL80211_IFTYPE_AP) ||
> +		    (sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
> +			/* If an AP/monitor vif is found, then disable PS
> +			 * by setting ps_sdata to NULL.
>  			 */
> -			count = 0;
> -			break;
> +			local->ps_sdata = NULL;
> +			goto change;
>  		}
>  		if (sdata->vif.type != NL80211_IFTYPE_STATION)
>  			continue;


