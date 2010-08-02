Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0HBK6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 06:58:33 -0400
Subject: Re: iwlwifi connection problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87bp9l6f4k.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
	 <1280212629.19098.0.camel@jlt3.sipsolutions.net>
	 <87bp9l6f4k.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 12:58:25 +0200
Message-ID: <1280746705.3923.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-08-01 at 17:18 -0700, Alex Romosan wrote:

> > So is the issue maybe the channel the AP is no, not the fact that it's
> > hidden? or something like that?
> 
> it's still not working even with kernel 2.6.35 so i decided to play with
> it a little bit more. indeed, it has nothing to do with the access
> point being hidden or not. it doesn't work even when it's visible
> (previously i was able to connect to the wireless at work which is
> visible so i wrongly assumed that was the cause).

Ok, thanks for checking, that's good to know.

> so it looks like the problem is connecting to this particular access
> point which is a proxim ap-200 orinoco wireless ap i got in 2003. right
> now the ap is setup on channel 3 and the rate is set to 11 Mbps. should
> i try a different channel? which one?

Channel 3 should be fine, we just had reports about channel 13 failing.
2.6.35 includes the QoS fix, so I'm not sure what the issue could be
here.

Typically such ancient APs have issues with the supported rates bitmap,
could you maybe try to revert 76f273640134f3eb8257179cd5b3bc6ba5fe4a96?
This is the only relevant commit I can find between .34 and .35.

However, if that doesn't help this seems like an ideal candidate for
bisection, would you be willing to try that? I'd restrict to wireless
code, i.e.

git bisect start -- net/wireless net/mac80211 drivers/net/wireless/iwlwifi

johannes

