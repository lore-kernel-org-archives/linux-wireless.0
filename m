Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2CWIyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 04:54:22 -0400
Message-ID: <1332492860.3506.8.camel@jlt3.sipsolutions.net> (sfid-20120323_095436_229294_E92813FD)
Subject: Re: [RFC 12/12] mac80211: return NULL from get_channel in
 multi-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2012 09:54:20 +0100
In-Reply-To: <892b9fb4-fb69-486f-b619-85d6336e5a31@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155530_182045_07E4AF64)
References: <892b9fb4-fb69-486f-b619-85d6336e5a31@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_155530_182045_07E4AF64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 13:57 +0100, Michal Kazior wrote:
> According to comment on cfg80211_ops/get_channel we should return NULL
> in case of concurrent multi-channel.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/cfg.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 88cc128..05f7022 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2680,6 +2680,9 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy)
>  	struct ieee80211_local *local = wiphy_priv(wiphy);
>  	struct ieee80211_channel_state *chan_state = &local->chan_state;
>  
> +	if (local->hw.flags & IEEE80211_HW_SUPPORTS_MULTI_CHANNEL)
> +		return NULL;
> +

We should return NULL if we're actually using multiple channels :-)

So clearly we need mac80211 do more work in tracking which channels are
used, compatible, etc.

johannes

