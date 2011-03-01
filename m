Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1CAM2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 07:28:07 -0500
Subject: Re: [RFC 0/9 v2] DFS/radar state/userspace handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, dubowoj@neratec.com, zefir.kurtisi@neratec.com,
	simon.wunderlich@saxnet.de
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 13:28:06 +0100
Message-ID: <1298982486.6015.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 17:40 +0100, Bernhard Schmidt wrote:

> Implemented so far is the complete state machine, handling CAC and NOL
> as well as starting appropriate action in hostapd. Note, this is based
> on top of the 'dfs region support' work posted by Luis.

I'm not quite sure about all of this. First of all, you don't really
explain the global state vs. local state but you did say that you no
longer had global state, which clearly isn't true.

Also, what's the point in "struct radar" if there's only a single
instance of that, which is global? I'd rather have multiple global
variables I think -- but that might just be a matter of personal taste
or choice.

Finally, I think your code split is a little hard to understand. Is
there really any point in adding the code bit by bit into both cfg80211
and mac80211 at the same time? I'd rather see a few patches to make
cfg80211 complete and then implement it all in mac80211.

Which brings me to another point -- there's no way to detect from
userspace whether or not this is all available.

Finally, such details like not needing a timer -- a delayed work should
be sufficient, etc.

johannes

