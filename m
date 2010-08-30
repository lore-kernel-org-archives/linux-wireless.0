Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0H3OTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 10:19:13 -0400
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com
In-Reply-To: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 16:19:09 +0200
Message-ID: <1283177949.3691.72.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-28 at 03:13 -0400, Luis R. Rodriguez wrote:
> mac80211's sw scan doesn't play nice with buffered broadcast and
> multicast frames. Since drivers are required to keep track of the DTIM
> count 

I said they were required for powersave, not necessarily for scanning.

> this series provides some new basic functionality to let drivers
> help mac80211 make more prudent decisions for sw scan.

I'm not convinced of this. Why does this need to be so complicated?
Also, some of your comments seem like you're confused about being an AP
vs. being associated to one?

What are you actually trying to achieve? It seems mac80211 can, no
matter what the driver is
 - wait for DTIM beacons, and the end of mcast traffic, before going off
   channel (should be relevant for p2p as well)
 - attempt to do better wrt. scheduling between DTIM, by scheduling
   closer (but if DTIM period is 1, this may fail)
 - subject to the driver advertising guaranteed TX status, it can also
   wait for the nullfunc ACK -- you should also implement flush which
   will probably improve things by itself for ath9k

The other things in your patch set I don't understand, but those I think
should be done more generically?

johannes

