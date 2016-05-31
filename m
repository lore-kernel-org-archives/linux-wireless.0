Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42972 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbcEaSQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 14:16:30 -0400
Message-ID: <1464718586.3076.34.camel@sipsolutions.net> (sfid-20160531_201635_203480_F956DEE8)
Subject: Re: [PATCH V2 iw] add "channels" PHY command listing frequencies
 with more details
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 20:16:26 +0200
In-Reply-To: <1464712100-4489-1-git-send-email-zajec5@gmail.com> (sfid-20160531_182829_340312_AD90B111)
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
	 <1464712100-4489-1-git-send-email-zajec5@gmail.com>
	 (sfid-20160531_182829_340312_AD90B111)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-31 at 18:28 +0200, Rafał Miłecki wrote:
> 
> +static int print_channels_handler(struct nl_msg *msg, void *arg)
> +{
> +	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
> +

extra blank line

> +	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
> +	struct nlattr *tb_band[NL80211_BAND_ATTR_MAX + 1];
> +	struct nlattr *tb_freq[NL80211_FREQUENCY_ATTR_MAX + 1];
> +	struct nlattr *nl_band;
> +	struct nlattr *nl_freq;
> +	int rem_band, rem_freq;
> +	static int last_band = -1;
> +	static bool width_40, width_80, width_160;

You shouldn't make them static - make a little struct containing them,
and pass it as "arg"


> +static int handle_channels(struct nl80211_state *state, struct
> nl_msg *msg,
> +			   int argc, char **argv, enum id_input id)
> +{

struct ... xyz = {};

> +	nla_put_flag(msg, NL80211_ATTR_SPLIT_WIPHY_DUMP);
> +	nlmsg_hdr(msg)->nlmsg_flags |= NLM_F_DUMP;
> +
> +	register_handler(print_channels_handler, NULL);

register_handler(..., &xyz);

johannes

