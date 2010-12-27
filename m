Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0L0K5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 05:57:42 -0500
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for
 802.11j
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 11:57:39 +0100
Message-ID: <1293447459.3544.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-24 at 16:44 +0900, Bruno Randolf wrote:

>  static bool freq_is_chan_12_13_14(u16 freq)
>  {
> -	if (freq == ieee80211_channel_to_frequency(12) ||
> -	    freq == ieee80211_channel_to_frequency(13) ||
> -	    freq == ieee80211_channel_to_frequency(14))
> +	if (freq == ieee80211_channel_to_frequency(12, IEEE80211_BAND_2GHZ) ||
> +	    freq == ieee80211_channel_to_frequency(13, IEEE80211_BAND_2GHZ) ||
> +	    freq == ieee80211_channel_to_frequency(14, IEEE80211_BAND_2GHZ))
>  		return true;

This seems strange ... why not just hardcode the values??

>  	if (freq->e == 0) {
> +		int band = IEEE80211_BAND_2GHZ;

enum?

johannes

