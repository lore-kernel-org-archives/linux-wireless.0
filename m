Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53124 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758979AbXLQVUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:20:49 -0500
Date: Mon, 17 Dec 2007 22:16:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
 default
Message-ID: <20071217221610.7906f3e2@morte> (sfid-20071217_212054_520225_03E52208)
In-Reply-To: <20071217204112.GE3121@tuxdriver.com>
References: <20071217012517.882216322@gmx.de>
	<20071217012550.213561122@gmx.de>
	<20071217150202.GC3121@tuxdriver.com>
	<20071217210649.370ba385@morte>
	<20071217204112.GE3121@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 17 Dec 2007 15:41:12 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Mon, Dec 17, 2007 at 09:06:49PM +0100, Stefano Brivio wrote:
> > On Mon, 17 Dec 2007 10:02:02 -0500
> > "John W. Linville" <linville@tuxdriver.com> wrote:
> > 
> > > On Mon, Dec 17, 2007 at 02:25:21AM +0100, Mattias Nissler wrote:
> > > 
> > > >  config MAC80211_RCPID
> > > > -	bool "'PID' rate control algorithm" if EMBEDDED
> > > > +	bool "'PID' rate control algorithm"
> > > 
> > > Shouldn't this keep the "if EMBEDDED"?  Especially if it is going to be the default?
> > 
> > How is EMBEDDED supposed to be related to this? Anyway, I'll go for the two
> > modules approach, forcing one module to be selected.
> 
> As I recall, the "if EMBEDDED" was there basically to say "it should
> always be built-in, but if you are trying to totally minimize your
> footprint you can turn it off".  Of course, that still would only
> work if you had another rate control algorithm available e.g. the
> iwlwifi drivers.

Ok, this would make sense. But think about users which doesn't want rate
control on non-embedded systems (laptop and AP always in the same room, or
AP which only acts as a bridge between one client and a dial-up modem).
Rate control is useless here.

I would take this approach: make them selectable (as two modules), and put
a huge warning in the help message (something like "you should need to
select at least one rate control algorithm unless you really don't want
it").


--
Ciao
Stefano
