Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:58399 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936AbXLCMJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 07:09:49 -0500
Date: Mon, 3 Dec 2007 13:06:02 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071203130602.49ab7234@morte> (sfid-20071203_120951_337718_4F30CD63)
In-Reply-To: <1196683144.7470.14.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<20071203125402.76562f26@morte>
	<1196683144.7470.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 03 Dec 2007 12:59:04 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> On Mon, 2007-12-03 at 12:54 +0100, Stefano Brivio wrote:
> > On Mon, 03 Dec 2007 12:03:00 +0100
> > Mattias Nissler <mattias.nissler@gmx.de> wrote:
> > 
> > > Wait a sec. Rate control is per station, so each AP will have it's own
> > > rate control state.
> > 
> > Ah, right. So fixing the related TODO may make sense.
> 
> What TODO excactly are you talking about?

In rate_control_simple_rate_init():
	/* TODO: This routine should consider using RSSI from previous packets
	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
	 * Until that method is implemented, we will use the lowest supported rate
	 * as a workaround, */

> > > I also thought about your rate <-> failed frames table. I'm not
> > > convinced this works, because I cannot see a way to obtain consistent
> > > values for the table. Clearly, measuring table entries should be done
> > > with equal interference conditions for all entries, and they must also
> > > be adjusted over time. However, if we only collect data during normal
> > > operation, we'll likely have good data only for the few recent rates
> > > we were operating at.
> > 
> > Yes, that's exactly what I meant.
> 
> So? How to do it right?

I'd say we need a keep an array with one element for each rate. The
elements would get updated after that we used that rate. Only the most
recent value would be kept in the array. The issue here is how to deal with
uninitialized values. We may need some preset coefficient or such.


--
Ciao
Stefano
