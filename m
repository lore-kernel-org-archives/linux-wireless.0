Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3FROsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:48:19 -0400
Message-ID: <1371566890.8318.32.camel@jlt4.sipsolutions.net> (sfid-20130618_164822_500723_428D00EB)
Subject: Re: [PATCHv2 2/5] nl80211/cfg80211: add channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 16:48:10 +0200
In-Reply-To: <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +/* struct cfg80211_csa_settings - channel switch settings
> + *

/**
 * struct ...
 * ...

> + * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number of TBTT's
> + *	until the channel switch event.
> + * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that transmission
> + *	must be blocked on the current channel (before the channel switch
> + *	operation).
> + * @NL80211_ATTR_CSA_IES: Nested set of attributes containing the IE information
> + *	for the time while performing a channel switch.
> + * @NL80211_ATTR_CSA_C_OFF_BEACON: Offset of the channel switch counter
> + *	field in the beacons tail (%NL80211_ATTR_BEACON_TAIL).
> + * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
> + *	field in the probe response (%NL80211_ATTR_PROBE_RESP).

Shouldn't the offset be into the CSA_IES?

> +	struct nlattr *csa_ies[NL80211_ATTR_MAX+1];

Hmm, this doesn't seem right.

> +	err = nla_parse_nested(csa_ies, NL80211_ATTR_MAX,
> +				   info->attrs[NL80211_ATTR_CSA_IES],
> +				   nl80211_policy);

(Indentation)

If you're going to use nested IEs, shouldn't you define a separate
namespace to be used within the nesting?

johannes

