Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54905 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965179AbcA1MNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 07:13:10 -0500
Message-ID: <1453983185.2217.12.camel@sipsolutions.net> (sfid-20160128_131318_962643_8246A477)
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates
 [mac80211]
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Date: Thu, 28 Jan 2016 13:13:05 +0100
In-Reply-To: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com> (sfid-20160128_063527_929413_6B184FD5)
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
	 (sfid-20160128_063527_929413_6B184FD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 21:34 -0800, Linus Torvalds wrote:

> .. except now I upgraded the nearest access point, and now wireless
> on that machine no longer works.

Can you describe the upgrade a bit more, just for background?

> Or rather, it actually *does* work in the sense that it
> authenticates, it associates, and it actually gets a DHCP lease etc.
> So the darn thing has an IP address and everything, but then nothing
> else seems to go through after that. Very odd. My guess is that the
> auth/assoc/dhcp thign happens at low rates, then it starts trying to
> up the rates, and things go to hell.

That's usually the case, yes. Auth/assoc/etc. management frames use low
rates anyway, and the first few data frames usually also do until it
scales up.

The code involved is drivers/net/wireless/realtek/rtlwifi/rc.c

> I do note that that rate_fixup_ratelist() function is a bit odd wrt
> those rate indexes: it has code to make sure that there are no valid
> rates following an invalid one:
> 
>                 /*
>                  * make sure there's no valid rate following
>                  * an invalid one, just in case drivers don't
>                  * take the API seriously to stop at -1.
>                  */
>                 if (inval) {
>                         rates[i].idx = -1;
>                         continue;
>                 }
>                 if (rates[i].idx < 0) {
>                         inval = true;
>                         continue;
>                 }
> 
> but then that "RC is busted" case that generates a warning will add
> one of those invalid rates in the middle anyway. So I get the feeling
> that if that warning ever triggers, it will basically be screwing up
> that whole rate table. I dunno.

This should be OK, it's more of a sanity check. The driver is supposed
to stop transmission attempts at the first -1 it seems, but the rate
control algorithm shouldn't generate useless attempts that will never
really get used, since that indicates a bug in the rate scaling.

> Is there anything sane I can do to help debug this case?

Could you print out the entire table there when the warning happens? Or
at least, it'd help to figure out at which index the invalid actually
happens. It seems that if that perhaps happens on the very first index,
the driver might get completely confused and perhaps not even send the
frame, which would lead to symptoms like the one you describe.

It seems plausible that there's a path somewhere in the rate scaling
code that forgets to set IEEE80211_TX_RC_MCS or so.

johannes
