Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2KLUmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 15:42:08 -0500
Message-ID: <1352752959.12957.2.camel@jlt4.sipsolutions.net> (sfid-20121112_214214_480919_E972F86B)
Subject: Re: [PATCH] mac80211: support RX_FLAG_MACTIME_END
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Nov 2012 21:42:39 +0100
In-Reply-To: <1352745513-1265-1-git-send-email-thomas@cozybit.com> (sfid-20121112_193850_215866_5571BA38)
References: <1352745513-1265-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121112_193850_215866_5571BA38)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-12 at 10:38 -0800, Thomas Pedersen wrote:

> +	if (ieee80211_have_rx_timestamp(rx_status))
> +		/* time when timestamp field was received */
> +		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
> +						       24 + 12 +
> +						       elems->total_len + 4,
> +						       24);

This doesn't seem quite right, the FCS isn't accounted for correctly?

I think it might be wortwhile to pass the SKB to the function instead of
rx_status though, then it could get skb->len and check whether or not
FCS was before the timestamp (which, btw, you should mention in the
documentation for the new flag!)

And then I suspect the check for IEEE80211_HW_RX_INCLUDES_FCS is also
incorrect -- even if the driver didn't report the FCS maybe the
timestamping semantic was such that it was after the FCS?

This seems to need a little fixing up, but other than that looks good.

johannes

