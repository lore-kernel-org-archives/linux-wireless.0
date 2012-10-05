Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35145 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab2JEUaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 16:30:46 -0400
Date: Fri, 5 Oct 2012 16:22:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.7 1/2] cfg80211: fix antenna gain handling
Message-ID: <20121005202220.GA1929@tuxdriver.com> (sfid-20121005_223049_973373_2F0BA2A8)
References: <1349286707-64433-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349286707-64433-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone object?  I suspect that Johannes may be a little more
busy/distracted than usual for the next few days/weeks...

John

On Wed, Oct 03, 2012 at 07:51:46PM +0200, Felix Fietkau wrote:
> When not intersecting, orig->chan_mag is initialized to zero. Because of
> that, the regulatory antenna gain limit never gets set.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
> ---
>  net/wireless/reg.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 3b8cbbc..1a16f19 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -915,8 +915,7 @@ static void handle_channel(struct wiphy *wiphy,
>  
>  	chan->beacon_found = false;
>  	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
> -	chan->max_antenna_gain = min(chan->orig_mag,
> -		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
> +	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
>  	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
>  	if (chan->orig_mpwr) {
>  		/*
> -- 
> 1.7.9.6 (Apple Git-31.1)
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
