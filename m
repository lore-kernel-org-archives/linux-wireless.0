Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2JSNLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 09:11:14 -0400
Message-ID: <1350652305.10678.0.camel@jlt4.sipsolutions.net> (sfid-20121019_151118_523761_20627A12)
Subject: Re: [RFC v2] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 19 Oct 2012 15:11:45 +0200
In-Reply-To: <507B8766.9010501@posedge.com>
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
	 <1349860308.4683.47.camel@jlt4.sipsolutions.net>
	 <507B8766.9010501@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-15 at 09:17 +0530, Mahesh Palivela wrote:
> On 10/10/2012 02:41 PM, Johannes Berg wrote:
> >>
> >> we need "channel starting frequency" anyways for calculating center
> >> freq. so we can use same constant for computing primary chan freq as
> >> well. why switch to prim_chan_offset?
> >
> > I think it'd be easier for drivers, since they typically seem to use
> > that to specify the control channel. If we give the frequency, they'll
> > have to calculate back to offset. The offset is also used in IEs etc.,
> > so I think overall that would simplify things.
> 
> Offset means we specify one of -70, -50, -30, -10, +10, +30, +50, +70 
> for 80/160 MHz BW from center freq.
> For ex. 80 MHz BW of channel 36, 40, 44 and 48 center freq is 42. If 
> control chan 36, then we specify offset -30. Is that what we want?
> 
> VHT IEs doesn't use offset anywhere. I am not sure why/where drivers use 
> offset values.

Ok, d'oh, our device uses an offset but I just reviewed the spec and
that just says the control channel is specified in the *HT* IE...

SO let's do what you suggested before and have all the three different
frequencies.

johannes

