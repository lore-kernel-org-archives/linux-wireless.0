Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab2IENil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:38:41 -0400
Message-ID: <1346852356.4364.9.camel@jlt4.sipsolutions.net> (sfid-20120905_153848_977032_0D92C1BE)
Subject: Re: [RFC v2] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 05 Sep 2012 15:39:16 +0200
In-Reply-To: <5046FB3D.6090803@posedge.com>
References: <5046FB3D.6090803@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-05 at 12:41 +0530, Mahesh Palivela wrote:

>   /**
> + * struct ieee80211_channel_config - channel config definition
> + *
> + * This structure describes channel configuration
> + *
> + * @chan_width1: channel bandwidth
> + * @center_freq1: center frequency of 1 st frequency segment
> + * @center_freq2: center frequency of 2 nd frequency segment
> + * 	Used only for 80+80 MHz combination
> + * @prim_chan_freq: primary channel frequency

I still don't like this as a frequency, I think it makes a lot more
sense to stick to how the standard does it.

> +static bool reg_sec_chans_permitted(struct wiphy *wiphy,
> +				    u32 center_freq,
> +				    u32 bw_khz)
> +{
> +	struct ieee80211_channel *chan;
> +	u32 left_end_freq, right_end_freq;
> +
> +	if (center_freq == 0 || bw_khz == 0)
> +		return false;

Can that actually happen?

> +	// get chan BW from config

Please don't use C99-style comments.

> +	r = freq_reg_info_regd(wiphy,
> +			       chan_config->prim_chan_freq,
> +			       desired_bw_khz,

This is wrong, I think? We won't use 40/80/160 MHz around the primary
channel frequency, we use it around the center_freq1/2.

> +	ret = reg_sec_chans_permitted(wiphy,
> +				      chan_config->center_freq1,
> +				      desired_bw_khz);

This seems better, but is missing the bandwidth check?

johannes

