Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1FFJfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:35:03 -0400
Subject: Re: [PATCH v3] 802.11n frame injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Matteo Croce <matteo@openwrt.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTim_YzVXG5g+92AkvJhhQ4OkeW4wMw@mail.gmail.com> (sfid-20110604_194333_802760_1207A93C)
References: <BANLkTim_YzVXG5g+92AkvJhhQ4OkeW4wMw@mail.gmail.com>
	 (sfid-20110604_194333_802760_1207A93C)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 11:35:01 +0200
Message-ID: <1307352901.3894.2.camel@jlt3.sipsolutions.net> (sfid-20110606_113507_033122_74845754)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-06-04 at 19:42 +0200, Matteo Croce wrote:

> +		case IEEE80211_RADIOTAP_RATE: {
> +			struct ieee80211_supported_band *sband =
> +				tx->local->hw.wiphy->bands[tx->channel->band];
> +			info->control.rates[0].idx = 0;
> +			if (*iterator.this_arg) {
> +				int i;
> +				for (i = 0; i < sband->n_bitrates; i++)
> +					if (sband->bitrates[i].bitrate ==
> +						*iterator.this_arg * 5) {
> +						info->control.rates[0].idx = i;
> +						break;

I don't think you should set the index if the bitrate doesn't exist.

Also, have you actually _tested_ this patch? I see nothing that would
cause rate control to be skipped, so rate control should always override
the data you set up here.

johannes

