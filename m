Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab2GXPmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 11:42:05 -0400
Message-ID: <1343144523.4415.44.camel@jlt3.sipsolutions.net> (sfid-20120724_174208_666126_F261F7A3)
Subject: Re: [PATCH] brcmsmac: use ieee80211_channel_to_frequency
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, brcm80211-dev-list@broadcom.com
Date: Tue, 24 Jul 2012 17:42:03 +0200
In-Reply-To: <1343144157-8349-1-git-send-email-johannes@sipsolutions.net> (sfid-20120724_173614_692844_D7D2D8B0)
References: <1343144157-8349-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120724_173614_692844_D7D2D8B0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-24 at 17:35 +0200, Johannes Berg wrote:

> -	if (channel > 14) {
> -		rx_status->band = IEEE80211_BAND_5GHZ;
> -		rx_status->freq = ieee80211_ofdm_chan_to_freq(
> -					WF_CHAN_FACTOR_5_G/2, channel);
> -
> -	} else {
> -		rx_status->band = IEEE80211_BAND_2GHZ;
> -		rx_status->freq = ieee80211_dsss_chan_to_freq(channel);
> -	}
> +	rx_status->band =
> +		channel > 14 ? IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;

In case somebody is wondering -- this was and remains an assumption due
to the hardware in question, it isn't true in general that channel
numbers > 14 are for 5 GHz channels and others are 2.4 GHz.

johannes

