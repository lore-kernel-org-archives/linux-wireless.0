Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KQLV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 06:21:58 -0500
Subject: Re: [PATCHv2 1/2] mac80211: Add NoAck per WMM Queue Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321446667-8348-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 12:21:54 +0100
Message-ID: <1321528914.3997.22.camel@jlt3.sipsolutions.net> (sfid-20111117_122201_589249_69319F00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 13:31 +0100, Simon Wunderlich wrote:
> This patch adds support for NoAck per WMM Queue. The Unicast QoS
> Header is adapted accordingly for each outgoing frame.
> The support is turned on and off through nl80211 by extending
> the WMM TX Queue Parameters, but can be triggered separately.
> 
> I have tested this feature on ath9k as well as ath5k devices. There is
> an iw patch as well to make use of this feature.

I think we should split this up to cfg80211/mac80211 changes.

> +	int	(*set_txq_noack)(struct wiphy *wiphy, struct net_device *dev,
> +				  struct ieee80211_txq_params *params);

I don't understand why you pass the whole txq params when in reality
this one will only ever change the noack bit, and the normal txq params
changes will never include it properly? Seems that it should be split up
completely?

> @@ -1161,6 +1164,11 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>  		 * explicitly unset IEEE80211_TX_CTL_NO_ACK since
>  		 * it might already be set for injected frames.
>  		 */
> +
> +		qc = ieee80211_get_qos_ctl(hdr);
> +		if (*qc & IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
> +			info->flags |= IEEE80211_TX_CTL_NO_ACK;

Err, how do you know the frame is a QoS frame to start with?

> @@ -1279,17 +1294,26 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  		nla_for_each_nested(nl_txq_params,
>  				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
>  				    rem_txq_params) {
> +			int result_noack, result_param;
>  			nla_parse(tb, NL80211_TXQ_ATTR_MAX,
>  				  nla_data(nl_txq_params),
>  				  nla_len(nl_txq_params),
>  				  txq_params_policy);

a blank line after variables is good form :)

> -			result = parse_txq_params(tb, &txq_params);
> -			if (result)
> +
> +			result_param = parse_txq_params(tb, &txq_params);
> +			result_noack = parse_txq_params_noack(tb, &txq_params);
> +
> +			if (!result_param)
> +				result = rdev->ops->set_txq_params(&rdev->wiphy,
> +							   netdev,
> +							   &txq_params);
> +			else if (!result_noack && rdev->ops->set_txq_noack)
> +				result = rdev->ops->set_txq_noack(&rdev->wiphy,
> +							   netdev,
> +							   &txq_params);
> +			else
>  				goto bad_res;
>  
> -			result = rdev->ops->set_txq_params(&rdev->wiphy,
> -							   netdev,
> -							   &txq_params);

I really don't like this. Why not just add an explicit operation here,
per netdev etc.? I recently made this code only be allowed for AP
interfaces too which is probably not what you want either.

johannes

