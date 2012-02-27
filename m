Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:36941 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab2B0NqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 08:46:25 -0500
Date: Mon, 27 Feb 2012 15:46:10 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Stewart <pstew@chromium.org>, linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
Message-ID: <20120227134610.GA5070@w1.fi> (sfid-20120227_144633_251920_153DF443)
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
 <1330254954.4401.9.camel@jlt3.sipsolutions.net>
 <1330255537.4401.10.camel@jlt3.sipsolutions.net>
 <1330338898.3483.10.camel@jlt3.sipsolutions.net>
 <20120227113212.GA4576@w1.fi>
 <1330342730.3483.34.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330342730.3483.34.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 12:38:50PM +0100, Johannes Berg wrote:
> On Mon, 2012-02-27 at 13:32 +0200, Jouni Malinen wrote:
> > However, there
> > could be some hardware/firmware designs that would refuse HT+TKIP at
> > lower layer, so skipping the channel (re-)configuration could
> > potentially cause some problems.

> That's a good point, but I don't really think is likely to exist. I can
> see this in a full-MAC scenario, but there you get all the relevant
> parameters in the nl80211 connect() call so can do the right choices
> earlier than mac80211 can with auth/assoc calls.

Even full MAC designs may end up moving towards auth/assoc calls for
things like IEEE 802.11r.. (And maybe even more so with 802.11ai
eventually.)

> Of course, if this we actually happen to come across a device that needs
> this it could set a flag somehwere and mac80211 could re-configure the
> channel to non-HT on the assoc request, but right now I'd rather not
> worry about that since we're moving towards multi-channel and have no
> indication of such devices existing. Agree?

Yeah, that works for me.

-- 
Jouni Malinen                                            PGP id EFC895FA
