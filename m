Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab1AaLck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:32:40 -0500
Subject: Re: [RFC] mac80211: disable ps if an AP type vif is present
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296394571-3317-1-git-send-email-rmanoharan@atheros.com>
References: <1296394571-3317-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:32:38 +0100
Message-ID: <1296473558.3812.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-30 at 19:06 +0530, Rajkumar Manoharan wrote:
> PS should be disabled for AP type. So while recalculating
> PS, AP vif type should be taken into account.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  net/mac80211/mlme.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 3221069..1fd6023 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -601,6 +601,12 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
>  	list_for_each_entry(sdata, &local->interfaces, list) {
>  		if (!ieee80211_sdata_running(sdata))
>  			continue;
> +		if (((sdata->vif.type == NL80211_IFTYPE_AP) ||
> +		     (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) &&
> +		    !sdata->vif.p2p) {
> +			count = 0;
> +			break;

I'd leave out the P2P check for now -- as soon as you have more than one
interface we don't go to PS, and we don't have NoA things etc. yet.

Also, the VLAN check can go, since if there's a VLAN then there must
also be an AP.

Setting count to 0 is likely to be confusing to somebody trying to
implement multi-interface PS though, a comment would be good.

johannes

