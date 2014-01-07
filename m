Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAGPaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:30:13 -0500
Message-ID: <1389108609.4645.10.camel@jlt4.sipsolutions.net> (sfid-20140107_163028_275419_670CC6DD)
Subject: Re: [PATCH 2/2] [RFC] mac80211: Add all enabled channels to the
 supported channels element
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:30:09 +0100
In-Reply-To: <1388503946-25862-3-git-send-email-ilan.peer@intel.com> (sfid-20131231_163100_337930_7D3482AD)
References: <1388503946-25862-1-git-send-email-ilan.peer@intel.com>
	 <1388503946-25862-3-git-send-email-ilan.peer@intel.com>
	 (sfid-20131231_163100_337930_7D3482AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-31 at 17:32 +0200, Ilan Peer wrote:


> +                       chan =
> ieee80211_frequency_to_channel(center_freq);
> +
> +                       if (first_chan == 0) {
> +                               /* first subband */
> +                               first_chan = chan;
> +                               count = 1;
> +                       } else if (first_chan + count == chan) {
> +                               /* continue the subband.
> +                                * TODO: this is really only useful
> for 2.4,
> +                                * need to add spacing considerations for other
> +                                * bands as well (the definition of a
> subband
> +                                * in the 802.11 spec. is a bit
> vague).
> +                                */
> +                               count++;

I agree this is very vague - anyone have a good idea who to ask?

As it is now, I'm not sure it's correct at all, even in the version we
have today, since different operating classes could have different
requirements. Especially since we support 5/10 MHz now, I suspect even
ieee80211_frequency_to_channel() really should be taught about operating
classes in some form?

> +	/* Get the number of enabled channels for spectrum management */
> +	n_channels = ieee80211_get_num_enabled_channels(local->hw.wiphy);

I would prefer you did this with an upper bound rather than the number
of enabled channels - we don't need a good estimate, worst case we'll
allocate a few bytes too many, but if we get it completely wrong e.g.
because the channel flags are being changed, then we could overrun the
SKB allocation, I think?

It'd also be faster to iterate only the bands and add up n_channels
rather than checking each channel's enabled bit.

johannes

