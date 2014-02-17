Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBQNt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 08:49:28 -0500
Message-ID: <1392644957.5202.7.camel@jlt4.sipsolutions.net> (sfid-20140217_144931_966553_CB12E8EA)
Subject: Re: [RFC 1/4] mac80211: Allow 5/10 MHz channel setting (for OCB)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de
Date: Mon, 17 Feb 2014 14:49:17 +0100
In-Reply-To: <1392643374-3545-2-git-send-email-lisovy@gmail.com> (sfid-20140217_142311_364138_9794E9CF)
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
	 <1392643374-3545-2-git-send-email-lisovy@gmail.com>
	 (sfid-20140217_142311_364138_9794E9CF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-17 at 14:22 +0100, Rostislav Lisovy wrote:
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>

Err, some text is definitely needed.

> ---
>  include/net/cfg80211.h       |  19 ++++++-
>  include/net/mac80211.h       |   4 +-
>  include/uapi/linux/nl80211.h |  17 ++++++-
>  net/wireless/chan.c          |   8 +++
>  net/wireless/core.c          |   3 --
>  net/wireless/nl80211.c       |  14 ++++++
>  net/wireless/reg.c           | 115 ++++++++++++++++++++++++++++++++++++++-----
>  7 files changed, 161 insertions(+), 19 deletions(-)

This is mostly a cfg80211 patch - please remove the non-cfg80211 parts
from this one and label it appropriately.

> + * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
> + *     on this channel.
> + * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
> + *     on this channel.
> + * @IEEE80211_CHAN_OCB_ONLY: only OCB is allowed on this channel.

That's not very clear - does no-20 also imply no-higher-than-20? Also,
why no flag for 5MHz? Maybe there should be flags for _5MHZ_ONLY,
_10MHZ_ONLY and _OCB_ONLY?

> +++ b/include/net/mac80211.h
> @@ -517,6 +517,8 @@ enum mac80211_tx_info_flags {
>   */
>  enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
> +	IEEE80211_TX_CTL_10MHZ			= BIT(1),
> +	IEEE80211_TX_CTL_5MHZ			= BIT(2),
>  };

This doesn't belong here.
 
> @@ -4516,7 +4518,7 @@ conf_is_ht40(struct ieee80211_conf *conf)
>  static inline bool
>  conf_is_ht(struct ieee80211_conf *conf)
>  {
> -	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
> +	return conf_is_ht20(conf) || conf_is_ht40(conf);
>  }

This also doesn't, but is also wrong - consider VHT.

> +++ b/net/wireless/core.c
> @@ -451,9 +451,6 @@ int wiphy_register(struct wiphy *wiphy)
>  	int i;
>  	u16 ifmodes = wiphy->interface_modes;
>  
> -	/* support for 5/10 MHz is broken due to nl80211 API mess - disable */
> -	wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_5_10_MHZ;

Err, what tree are you basing your code on? Consider updating it.

Besides, that wouldn't even belong into this patch anyway.

> +++ b/net/wireless/nl80211.c
> @@ -570,6 +570,16 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
>  	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
>  	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
>  		goto nla_put_failure;
> +	if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
> +	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
> +		goto nla_put_failure;
> +	if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
> +	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
> +		goto nla_put_failure;
> +
> +	if ((chan->flags & IEEE80211_CHAN_OCB_ONLY) &&
> +	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_OCB_ONLY))
> +		goto nla_put_failure;

This has to depend on the split format here, otherwise we overrun the
buffer used by older userspace tools. Also, such channels should be
removed from the nl80211 advertisement for userspace that can't cope
with non-split information.

> +		if (band_rule_found && bw_fits) {
> +			u32 allowed_bw = regd->reg_rules[i].freq_range.max_bandwidth_khz;
> +			if (desired_bw_khz > allowed_bw) {
> +				return ERR_PTR(-ENOENT);
> +			} else {
> +				return rr;
> +			}
> +		}

code style
 
>  const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
> -					       u32 center_freq)
> +					       u32 center_freq,
> +					       u32 desired_bw_khz)

>  EXPORT_SYMBOL(freq_reg_info);

This function is exported but you haven't updated any of its users ...

> +	do {
> +		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), desired_bw_khz);
> +		if ((IS_ERR(reg_rule)) && ((u32)reg_rule == -ENOENT)) {
> +			bw_flags |= IEEE80211_CHAN_NO_20MHZ;
> +		} else {
> +			break;
> +		}
> +
> +		/* check for 10 MHz BW */
> +		desired_bw_khz = MHZ_TO_KHZ(10);
> +		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), desired_bw_khz);
> +		if ((IS_ERR(reg_rule)) && ((u32)reg_rule == -ENOENT)) {
> +			bw_flags |= IEEE80211_CHAN_NO_10MHZ;
> +		} else {
> +			break;
> +		}
> +
> +		/* check for 5 MHz BW */
> +		desired_bw_khz = MHZ_TO_KHZ(5);
> +		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), desired_bw_khz);
> +		if ((IS_ERR(reg_rule)) && ((u32)reg_rule == -ENOENT)) {
> +
> +		} else {
> +			break;
> +		}
> +	} while (0);

That is one of the ugliest code constructs I've ever seen. You should
rewrite it.

> +#if 0

Umm.

Might have mentioned that in your 0/4 that you want help on specific
things :)

[I haven't even really reviewed the regulatory code]

johannes

