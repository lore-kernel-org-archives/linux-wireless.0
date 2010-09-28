Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0I1JCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 05:02:52 -0400
Subject: Re: [RFC] mac80211: sets basic rate set parameter for IBSS creator
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285662586-31646-1-git-send-email-mshajakhan@atheros.com>
References: <1285662586-31646-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 11:02:49 +0200
Message-ID: <1285664569.3885.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 13:59 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> This fix sets the basic rate set parameter for IBSS creator when the
> basic rates are not explicitly specified in the user space.
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  net/mac80211/ibss.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 1a3aae5..e117155 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -541,6 +541,9 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
>  		capability |= WLAN_CAPABILITY_PRIVACY;
>  	else
>  		sdata->drop_unencrypted = 0;
> +	if (ifibss->basic_rates == 0)
> +		ifibss->basic_rates = ieee80211_mandatory_rates(local,
> +					local->hw.conf.channel->band);

Shouldn't cfg80211 do this?

johannes

