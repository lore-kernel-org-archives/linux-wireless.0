Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3J1Nrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 09:47:47 -0400
Message-ID: <1382968061.17956.10.camel@jlt4.sipsolutions.net> (sfid-20131028_144809_213779_4C437069)
Subject: Re: [PATCH 01/16] mac80211: fix TX device statistics for monitor
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
	joni.lapilainen@gmail.com, David Gnedt <david.gnedt@davizone.at>
Date: Mon, 28 Oct 2013 14:47:41 +0100
In-Reply-To: <1382819655-30430-2-git-send-email-pali.rohar@gmail.com> (sfid-20131026_224024_753066_57DA03E7)
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-2-git-send-email-pali.rohar@gmail.com>
	 (sfid-20131026_224024_753066_57DA03E7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:

> +	dev->stats.tx_packets++;
> +	dev->stats.tx_bytes += skb->len;

We can still easily drop the packet after this - we can't guarantee
it'll go out but maybe we shouldn't do it here?

johannes

