Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56196 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbdBOHxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 02:53:41 -0500
Message-ID: <1487145218.4026.3.camel@sipsolutions.net> (sfid-20170215_085344_673141_6F756E40)
Subject: Re: [PATCH v3 1/2] cfg80211: Add support to set tx power for a
 station associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, arnagara@codeaurora.org
Date: Wed, 15 Feb 2017 08:53:38 +0100
In-Reply-To: <1486554984-25097-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1486554984-25097-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @txpwr: tx power (in mBm) to be used for sending data traffic. If
> tx power
> + *	is not provided, the default per-interface tx power
> setting will be
> + *	overriding. Driver should be picking up the lowest tx
> power, either tx
> + *	power per-interface or per-station.
>   */
>  struct station_parameters {
>  	const u8 *supported_rates;
> @@ -876,6 +881,7 @@ struct station_parameters {
>  	u8 opmode_notif;
>  	bool opmode_notif_used;
>  	int support_p2p_ps;
> +	u16 txpwr;
>  };

Wouldn't it be better to add the tx power type (limited/automatic) here
as well? That way, we don't have to play games with 0 meaning automatic
(which you didn't even document, but seems to be the case), when in
fact 0dBm could technically be a valid TX power as well.

> +	idx = NL80211_ATTR_STA_TX_POWER_SETTING;
> +	type = nla_get_u32(info->attrs[idx]);
> +
> +	if (!info->attrs[NL80211_ATTR_STA_TX_POWER] &&
> +	    (type != NL80211_TX_POWER_AUTOMATIC))
> +		return -EINVAL;
> +
> +	if (type != NL80211_TX_POWER_AUTOMATIC) {
> +		if (type == NL80211_TX_POWER_LIMITED) {
> +			idx = NL80211_ATTR_STA_TX_POWER;
> +			params->txpwr = nla_get_u32(info-
> >attrs[idx]);
> +		} else {
> +			return -EINVAL;
> +		}
> +	} else {
> +		params->txpwr = 0;
> +	}

This could be nicer using a switch on the type, perhaps?

> +	if (info->attrs[NL80211_ATTR_STA_TX_POWER_SETTING]) {
> +		err = nl80211_parse_sta_txpower_setting(info,
&params);
> +		if (err)
> +			return err;
> +	}

Why not move the check that the attribute exists into the function?

johannes
