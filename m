Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42552 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbaCYH7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 03:59:35 -0400
Message-ID: <1395734367.28231.57.camel@dubbel> (sfid-20140325_085938_410519_39CE1A3B)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Tue, 25 Mar 2014 09:59:27 +0200
In-Reply-To: <1395409651-26120-4-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 03/13] mac80211: prevent chanctx overcommit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
> Do not allocate more channel contexts than a
> driver is capable for currently matching interface
> combination.
> 
> This allows the ieee80211_vif_reserve_chanctx() to
> act as a guard against breaking interface
> combinations.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

[...]
> @@ -745,13 +764,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>  			 * context, reserve our current context
>  			 */
>  			new_ctx = curr_ctx;
> -		} else {
> +		} else if (ieee80211_can_create_new_chanctx(local)) {
>  			/* create a new context and reserve it */
>  			new_ctx = ieee80211_new_chanctx(local, chandef, mode);
>  			if (IS_ERR(new_ctx)) {
>  				ret = PTR_ERR(new_ctx);
>  				goto out;
>  			}
> +		} else {
> +			ret = -EBUSY;
> +			goto out;

I'm not sure about this whole allowed channels counting thing.  Does it
really matter what is the total number of allowed channels? I think the
actual combinations is what should be checked here.

Let's say the driver supports these combinations:

1. num_different_channels = 2; limits max 2 APs;
2. num_different_channels = 1; limits 1 AP, 1 STA;

Then you're running on a single-channel with 1 AP and 1 STA.  The STA
gets a CSA to move to a new channel.  If you only consider the
max_num_channels you calculated, you will think that it is okay to
switch, but it is not, because you cannot have 1 AP and 1 STA on
different channels.

Or am I missing something?

--
Luca

