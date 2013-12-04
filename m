Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3LDIQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 03:16:10 -0500
Message-ID: <1386144962.4284.2.camel@jlt4.sipsolutions.net> (sfid-20131204_091636_236564_687665AD)
Subject: Re: [PATCH] mac80211: rx: Neaten ieee80211_deliver_skb, remove
 compare_ether_addr
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Date: Wed, 04 Dec 2013 09:16:02 +0100
In-Reply-To: <1386095360.15309.29.camel@joe-AO722>
References: <1386095360.15309.29.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 10:29 -0800, Joe Perches wrote:
> Remove the unnecessary duplicate test of "if (skb) {"
> when !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.
> 
> Remove now unnecessary __maybe_unused, neaten comment
> Remove unnecessary parenthesis around align cast.
> Substitute reference to deprecated compare_ether_addr
> with ether_addr_equal.

I already had a patch to remove the __maybe_unused, but this looks good,
applied.

johannes

