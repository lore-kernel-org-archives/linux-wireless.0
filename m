Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2HAJHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 05:07:23 -0400
Message-ID: <1343812040.4638.3.camel@jlt3.sipsolutions.net> (sfid-20120801_110727_142881_01F13F13)
Subject: Re: [PATCH] cfg80211: use correct (original) max power
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Hong Wu <Hong.Wu@dspg.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 01 Aug 2012 11:07:20 +0200
In-Reply-To: <1343811819-15582-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_110350_289489_AA41BA81)
References: <1343811819-15582-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120801_110350_289489_AA41BA81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 11:03 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When calculating the maximum TX power for a channel,
> the original maximum power should be restricted to
> the current regulatory TX power. Restricting the
> current maximum TX power has the effect that it'll
> never be possible to increase the power again when
> the regulatory requirement changes.


No ... this isn't right either. Hong Wu, can you please fix this mess?

I have a feeling your patch

commit eccc068e8e84c8fe997115629925e0422a98e4de
Author: Hong Wu <Hong.Wu@dspg.com>
Date:   Wed Jan 11 20:33:39 2012 +0200

    wireless: Save original maximum regulatory transmission power for
the calucation of the local maximum transmit power


should just be reverted?

johannes


> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/reg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 2303ee7..070b88c 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -901,7 +901,7 @@ static void handle_channel(struct wiphy *wiphy,
>  	chan->max_antenna_gain = min(chan->orig_mag,
>  		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
>  	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
> -	chan->max_power = min(chan->max_power, chan->max_reg_power);
> +	chan->max_power = min(chan->orig_mpwr, chan->max_reg_power);
>  }
>  
>  static void handle_band(struct wiphy *wiphy,


