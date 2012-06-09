Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2FIIzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:55:48 -0400
Message-ID: <1339232144.4539.38.camel@jlt3.sipsolutions.net> (sfid-20120609_105551_410866_300560D7)
Subject: Re: [PATCH 2/2] mac80211: Use signal strength as a proxy for
 expected datarate.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Abele <jason@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 09 Jun 2012 10:55:44 +0200
In-Reply-To: <1339187469-12778-3-git-send-email-jason@cozybit.com> (sfid-20120608_223122_594961_27A0F58B)
References: <1339187469-12778-1-git-send-email-jason@cozybit.com>
	 <1339187469-12778-3-git-send-email-jason@cozybit.com>
	 (sfid-20120608_223122_594961_27A0F58B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 13:31 -0700, Jason Abele wrote:

> +	if (sta->tx_packets > 100)
> +		rate = max(ewma_read(&sta->avg_rate), 10UL);
> +	else
> +		/* Not enough traffic sent, use rx signal strengh as proxy */
> +		rate = rssi_get_rate(sta);

This just seems completely wrong to me. There's very little correlation
between bitrates and RSSI, in fact, we once had 0 dBm power by accident
and got better performance than with 15 dBm power (due to another bug,
but still)...

Looking at the code that uses this, I also note:

> 	/* This should be adjusted for each device */
>         int device_constant = 1 << ARITH_SHIFT;

which seems *totally* wrong. Maybe it's time to rethink this code?

johannes

