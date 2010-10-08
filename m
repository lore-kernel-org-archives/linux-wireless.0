Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from spaceboyz.net ([87.106.131.203]:43571 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758997Ab0JHSIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:08:00 -0400
Date: Fri, 8 Oct 2010 19:41:28 +0200
From: David Lamparter <equinox@diac24.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
Message-ID: <20101008174128.GC946034@jupiter.n2.diac24.net>
References: <SNT111-W2989DC6A52022428756E6FB500@phx.gbl>
 <20101008111221.5425.qmail@stuge.se>
 <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>
 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>
 <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>
 <4CAF4B70.9050001@candelatech.com>
 <20101008165232.GI10149@tux>
 <4CAF4FDA.8060908@candelatech.com>
 <1286557944.3612.5.camel@jlt3.sipsolutions.net>
 <4CAF53E2.8030306@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CAF53E2.8030306@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 08, 2010 at 10:24:50AM -0700, Ben Greear wrote:
> On 10/08/2010 10:12 AM, Johannes Berg wrote:
> > On Fri, 2010-10-08 at 10:07 -0700, Ben Greear wrote:
> >
> >> Well, the command fails because of this check (mbm is 20 in his case)
> >> cfg.c:
> >> 	case NL80211_TX_POWER_FIXED:
> >> 		if (mbm<  0 || (mbm % 100))
> >> 			return -EOPNOTSUPP;
> >>
> >> That mbm % 100 looks quite strange to me..any idea what that is supposed to
> >> accomplish?
> >
> > There's a later division by 100 to go from mBm to dBm ... I think you
> > want 2000, not 20.
> 
> Well, it's documented in iw to be 'mBm', though I surely wouldn't have known
> what that stood for (nothing useful shows up on google for 'mBm units').

d-B-m is deci-Bel-milliWatt, so a mBm ostensibly is a
milli-Bel-milliWatt...

(yes, the "m" really encodes "mW"...)


-David

