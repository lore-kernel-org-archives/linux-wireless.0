Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59082 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYDCUJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 16:09:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: default to regulatory max power for channel
Date: Thu, 3 Apr 2008 22:08:37 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Larry.Finger@lwfinger.net, mcgrof@gmail.com
References: <47F5242D.80404@lwfinger.net> <1207251174-23860-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1207251174-23860-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804032208.37588.mb@bu3sch.de> (sfid-20080403_210909_327250_45D0BC07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 April 2008 21:32:54 John W. Linville wrote:
> If the driver does not specify a maximum power output, default to the
> regulatory max.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Is this a worth alternative to Larry's b43legacy patch?  It looked like

Yeah, I like this one much better.
The b43 devices can all be configured up to regulatory limits.
So it doesn't really make sense to define a hardware limit.
And I think we currently don't even know the real HW limit. One might
try to calculate it, but that seems difficult.

> ath5k wasn't setting max_power either -- how does it work?
> 
>  net/wireless/reg.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 8cc6037..185488d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -136,7 +136,10 @@ static void handle_channel(struct ieee80211_channel *chan,
>  	chan->flags = flags;
>  	chan->max_antenna_gain = min(chan->orig_mag,
>  					 rg->max_antenna_gain);
> -	chan->max_power = min(chan->orig_mpwr, rg->max_power);
> +	if (chan->orig_mpwr)
> +		chan->max_power = min(chan->orig_mpwr, rg->max_power);
> +	else
> +		chan->max_power = rg->max_power;
>  }
>  
>  static void handle_band(struct ieee80211_supported_band *sband,



-- 
Greetings Michael.
