Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2JJJLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 05:11:15 -0400
Message-ID: <1349860308.4683.47.camel@jlt4.sipsolutions.net> (sfid-20121010_111121_833507_F1007A96)
Subject: Re: [RFC v2] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 10 Oct 2012 11:11:48 +0200
In-Reply-To: <5065DFAD.2070305@posedge.com>
References: <5046FB3D.6090803@posedge.com>
	  <1346852356.4364.9.camel@jlt4.sipsolutions.net>
	  <50481C2E.5040303@posedge.com>
	  <1346925298.5469.4.camel@jlt4.sipsolutions.net>
	  <50489165.1080902@posedge.com>
	  <1347019809.4256.21.camel@jlt4.sipsolutions.net>
	  <50655B36.5060500@posedge.com>
	  <1348828789.13298.5.camel@jlt4.sipsolutions.net>
	  (sfid-20120928_123917_337659_1AA6C9C6) <1348828963.13298.8.camel@jlt4.sipsolutions.net>
	 <5065DFAD.2070305@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-28 at 23:04 +0530, Mahesh Palivela wrote:

> >> I prefer MHz for center freqs, but offset for the primary channel, and
> >> this is exactly like table 22-22 in the 802.11ac draft, so only the "u16
> >> primary_channel_freq" becomes "u8 primary_channel_offset", not all of
> >> them change, no?
> >
> > Ohh, wait, it's called frequency in table 22-22 but actually says the
> > valid range is 1-200 ... wtf? Ok you're right, then it uses the equation
> > 22-99, but ... hmm that's a bit stupid since it needs the (non-constant)
> > "Channel starting frequency".
> >
> > Ok so maybe that wasn't such a good idea. How about we just change
> > prim_chan_freq to prim_chan_offset and leave the other two unchanged?
> 
> we need "channel starting frequency" anyways for calculating center 
> freq. so we can use same constant for computing primary chan freq as 
> well. why switch to prim_chan_offset?

I think it'd be easier for drivers, since they typically seem to use
that to specify the control channel. If we give the frequency, they'll
have to calculate back to offset. The offset is also used in IEs etc.,
so I think overall that would simplify things.

johannes

