Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33083 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab0JUISd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 04:18:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 01:18:22 -0700
Date: Thu, 21 Oct 2010 13:48:28 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Easwar Krishnan <Easwar.Krishnan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 6/7] cfg80211: add debug print when processing a channel
Message-ID: <20101021081828.GA1840@senthil-lnx.users.atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
 <1287595139-10761-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1287595139-10761-7-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 20, 2010 at 10:48:58PM +0530, Luis R. Rodriguez wrote:
> In the worst case you are seeing really odd things you want
> more information than what is provided right now, for those
> that insist and want debug info through CONFIG_CFG80211_REG_DEBUG
> provide a print of when we are processing a channel and with what
> regulatory rule.
> 
> Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 62396b2..f0ff146 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -728,6 +728,42 @@ static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
>  	}
>  }
>  
> +#ifdef CONFIG_CFG80211_REG_DEBUG
> +
> +static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
> +				    u32 desired_bw_khz,
> +				    const struct ieee80211_reg_rule *reg_rule)
> +{
> +	const struct ieee80211_power_rule *power_rule;
> +	const struct ieee80211_freq_range *freq_range;
> +	char max_antenna_gain[32];
> +
> +	power_rule = &reg_rule->power_rule;
> +	freq_range = &reg_rule->freq_range;
> +
> +	if (!power_rule->max_antenna_gain)
> +		snprintf(max_antenna_gain, 32, "N/A");
> +	else
> +		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
> +
> +	REG_DBG_PRINT("cfg80211: Updating information on frequency %d MHz "
> +		      "for %d a MHz width channel with regulatory rule:\n",
> +		      chan->center_freq,
> +		      KHZ_TO_MHZ(desired_bw_khz));
> +
> +	REG_DBG_PRINT("cfg80211: %d KHz - %d KHz @  KHz), (%s mBi, %d mBm)\n",
> +		      freq_range->start_freq_khz,
> +		      freq_range->end_freq_khz,
> +		      max_antenna_gain,
> +		      power_rule->max_eirp);
> +}
> +#else
> +static void reg_reg_rule_print_dbg(const struct ieee80211_reg_rule *reg_rule)
This will break compilation. Function name and arguments needs to be fixed here.
> +{
> +	return;
> +}
> +#endif
> +
>  /*
>   * Note that right now we assume the desired channel bandwidth
>   * is always 20 MHz for each individual channel (HT40 uses 20 MHz
> @@ -788,6 +824,8 @@ static void handle_channel(struct wiphy *wiphy,
>  		return;
>  	}
>  
> +	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
> +
>  	power_rule = &reg_rule->power_rule;
>  	freq_range = &reg_rule->freq_range;
>  
> @@ -1132,6 +1170,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
>  		return;
>  	}
>  
> +	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
> +
>  	power_rule = &reg_rule->power_rule;
>  	freq_range = &reg_rule->freq_range;
>  
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
