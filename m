Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1ACQyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 11:54:00 -0500
Subject: Re: Fwd: mac80211+iwlwifi bug with HT rates?
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTind_8HzraBGxyA90ymQ_e3uJV+iykMNKzekRLA9@mail.gmail.com>
References: <AANLkTi=w+EEdROx5NCBEe2fLv6RM-7fGSoNEpQ-tBZYo@mail.gmail.com>
	 <AANLkTind_8HzraBGxyA90ymQ_e3uJV+iykMNKzekRLA9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 17:53:52 +0100
Message-ID: <1294073632.3436.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-02 at 23:15 -0800, Daniel Halperin wrote:

> I'm trying to track down an anomaly with a 3-stream 802.11n AP.
> iwlwifi is saying that a single antenna should be sufficient even when
> the AP supports 3 streams.  Here's what I've tracked down:
> Code in iwl-agn-rxon.c uses the ht_cap TX MCS parameters to determine
> how many streams the other side supports:
> <http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=drivers/net/wireless/iwlwifi/iwl-agn-rxon.c;h=d33e4db7e56cab88abc3281d04adf32162b8020e;hb=HEAD#l470>
> Yet, it looks like mac80211 doesn't actually set those variables at
> all!  In net/mac80211/ht.c, when converting the IE to the Station HT
> cap:
> <http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=blob;f=net/mac80211/ht.c;h=75d679d75e63e92143d55a47601a1dfc1377ba03;hb=HEAD#l21>
> we first zero out the HT CAP (line 30) and then never actually set the
> ht_cap->mcs.tx_params variables at all.  Grep says that's the only use
> of mcs.tx_params in that directory, so I'm pretty confident mac80211
> just never does that.  Thus iwlwifi thinks it only needs to have 1 RX
> antenna enabled (though it defaults to a minimum of 2 when possible)
> and basically fails to receive 3 stream packets.
> Is this a bug in iwlwifi or mac80211?

It sure looks like a bug. mac80211 should fill the info I guess, but
iwlwifi also shouldn't use this weird calculation anyhow ... I've been
meaning to move the # of chains calculation to mac80211 for a while
now... maybe this is the time to do that.

johannes

