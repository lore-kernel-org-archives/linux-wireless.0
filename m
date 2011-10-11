Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1JKQZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 12:25:50 -0400
Subject: Re: [PATCH 1/2] mac80211: Build TX radiotap header dynamically
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111011_180959_179390_1D9713EA)
References: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111011_180959_179390_1D9713EA)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 18:25:45 +0200
Message-ID: <1318350345.3965.11.camel@jlt3.sipsolutions.net> (sfid-20111011_182553_464008_03E4DF13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 18:08 +0200, Helmut Schaa wrote:

> +	/* IEEE80211_RADIOTAP_RATE */
> +	if (info->status.rates[0].idx >= 0 &&
> +	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS)) {
> +		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
> +		*pos = sband->bitrates[info->status.rates[0].idx].bitrate / 5;
> +		/* padding for tx flags */
> +		pos += 2;

Since there's no over-all memset I think you need to clear the padding
explicitly now.

johannes


