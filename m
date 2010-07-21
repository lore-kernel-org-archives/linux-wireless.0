Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25002 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab0GUHFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 03:05:06 -0400
Subject: Re: [PATCH] iw: Add support for setting transmit power level
From: Luciano Coelho <luciano.coelho@nokia.com>
To: johannes@sipsolutions.net
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
In-Reply-To: <1277284377-11048-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1277284377-11048-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 10:04:33 +0300
Message-ID: <1279695873.12747.1.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Just trying to make sure you have seen this patch (you haven't applied
it yet).  Juuso sent it to John instead of you, so you may have missed
it. ;)

On Wed, 2010-06-23 at 11:12 +0200, Oikarinen Juuso (Nokia-MS/Tampere)
wrote:
> Add a "set txpower" option to specify the current transmit power level. Modes
> supported are automatic, fixed and limited, and the limit may be specified
> in signed mBm units.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  nl80211.h |   22 ++++++++++++++++++++++
>  phy.c     |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 71 insertions(+), 1 deletions(-)
> 
> diff --git a/nl80211.h b/nl80211.h
> index 64fb32b..2c87016 100644
> --- a/nl80211.h
> +++ b/nl80211.h
> @@ -725,6 +725,12 @@ enum nl80211_commands {
>   * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
>   *	connected to this BSS.
>   *
> + * @NL80211_ATTR_WIPHY_TX_POWER_SETTING: Transmit power setting type. See
> + *      &enum nl80211_tx_power_setting for possible values.
> + * @NL80211_ATTR_WIPHY_TX_POWER_LEVEL: Transmit power level in signed mBm units.
> + *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
> + *      for non-automatic settings.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -882,6 +888,9 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_AP_ISOLATE,
>  
> +	NL80211_ATTR_WIPHY_TX_POWER_SETTING,
> +	NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -1659,4 +1668,17 @@ enum nl80211_cqm_rssi_threshold_event {
>  	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
>  };
>  
> +
> +/**
> + * enum nl80211_tx_power_setting - TX power adjustment
> + * @NL80211_TX_POWER_AUTOMATIC: automatically determine transmit power
> + * @NL80211_TX_POWER_LIMITED: limit TX power by the mBm parameter
> + * @NL80211_TX_POWER_FIXED: fix TX power to the mBm parameter
> + */
> +enum nl80211_tx_power_setting {
> +	NL80211_TX_POWER_AUTOMATIC,
> +	NL80211_TX_POWER_LIMITED,
> +	NL80211_TX_POWER_FIXED,
> +};
> +
>  #endif /* __LINUX_NL80211_H */
> diff --git a/phy.c b/phy.c
> index 8f8d757..f042dc2 100644
> --- a/phy.c
> +++ b/phy.c
> @@ -175,7 +175,7 @@ static int handle_netns(struct nl80211_state *state,
>  		return 1;
>  
>  	NLA_PUT_U32(msg, NL80211_ATTR_PID,
> -		    strtoul(argv[0], &end, 10)); 
> +		    strtoul(argv[0], &end, 10));
>  
>  	if (*end != '\0')
>  		return 1;
> @@ -258,3 +258,51 @@ COMMAND(set, distance, "<distance>",
>  	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_distance,
>  	"Set appropriate coverage class for given link distance in meters.\n"
>  	"Valid values: 0 - 114750");
> +
> +static int handle_txpower(struct nl80211_state *state,
> +			  struct nl_cb *cb,
> +			  struct nl_msg *msg,
> +			  int argc, char **argv)
> +{
> +	enum nl80211_tx_power_setting type;
> +	int ret = -ENOSPC;
> +	int mbm;
> +
> +	/* get the required args */
> +	if (argc != 1 && argc != 2)
> +		return 1;
> +
> +	if (!strcmp(argv[0], "auto"))
> +		type = NL80211_TX_POWER_AUTOMATIC;
> +	else if (!strcmp(argv[0], "fixed"))
> +		type = NL80211_TX_POWER_FIXED;
> +	else if (!strcmp(argv[0], "limit"))
> +		type = NL80211_TX_POWER_LIMITED;
> +	else {
> +		printf("Invalid parameter: %s\n", argv[0]);
> +		return 2;
> +	}
> +
> +	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_TX_POWER_SETTING, type);
> +
> +	if (type != NL80211_TX_POWER_AUTOMATIC) {
> +		if (argc != 2) {
> +			printf("Missing TX power level argument.\n");
> +			return 2;
> +		}
> +
> +		mbm = atoi(argv[1]);
> +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_TX_POWER_LEVEL, mbm);
> +	}
> +
> +	ret = 0;
> +
> + nla_put_failure:
> +	return ret;
> +}
> +COMMAND(set, txpower, "<auto|fixed|limit> [<tx power in mBm>]",
> +	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_txpower,
> +	"Specify transmit power level and setting type.");
> +COMMAND(set, txpower, "<auto|fixed|limit> [<tx power in mBm>]",
> +	NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_txpower,
> +	"Specify transmit power level and setting type.");


-- 
Cheers,
Luca.

