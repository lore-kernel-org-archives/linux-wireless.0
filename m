Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35150 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab2JEUa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 16:30:56 -0400
Date: Fri, 5 Oct 2012 16:22:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.7 2/2] cfg80211: fix initialization of
 chan->max_reg_power
Message-ID: <20121005202241.GB1929@tuxdriver.com> (sfid-20121005_223059_303398_C784470E)
References: <1349286707-64433-1-git-send-email-nbd@openwrt.org>
 <1349286707-64433-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349286707-64433-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same here -- anyone object?  I suspect that Johannes may be a little
more busy/distracted than usual for the next few days/weeks...

John

On Wed, Oct 03, 2012 at 07:51:47PM +0200, Felix Fietkau wrote:
> A few places touch chan->max_power based on updated tx power rules, but
> forget to do the same to chan->max_reg_power.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
> ---
>  net/wireless/reg.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 1a16f19..7062475 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -908,7 +908,7 @@ static void handle_channel(struct wiphy *wiphy,
>  			map_regdom_flags(reg_rule->flags) | bw_flags;
>  		chan->max_antenna_gain = chan->orig_mag =
>  			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
> -		chan->max_power = chan->orig_mpwr =
> +		chan->max_reg_power = chan->max_power = chan->orig_mpwr =
>  			(int) MBM_TO_DBM(power_rule->max_eirp);
>  		return;
>  	}
> @@ -1330,7 +1330,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
>  
>  	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
>  	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
> -	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
> +	chan->max_reg_power = chan->max_power =
> +		(int) MBM_TO_DBM(power_rule->max_eirp);
>  }
>  
>  static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
> -- 
> 1.7.9.6 (Apple Git-31.1)
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
