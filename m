Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46731 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0CHObj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 09:31:39 -0500
Received: by bwz1 with SMTP id 1so2838425bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 06:31:37 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC v2] minstrel_ht: new rate control module for 802.11n
Date: Mon, 8 Mar 2010 15:31:31 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?iso-8859-1?q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Bob Copeland <me@bobcopeland.com>
References: <4B93D6D3.80702@openwrt.org> <201003071859.25848.chunkeey@googlemail.com> <4B93F109.2000607@openwrt.org>
In-Reply-To: <4B93F109.2000607@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003081531.31358.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 March 2010 19:31:37 Felix Fietkau wrote:
> On 2010-03-07 6:59 PM, Christian Lamparter wrote:
> > On Sunday 07 March 2010 17:39:47 Felix Fietkau wrote:
> >> here is an updated version of my minstrel_ht code. Since the last
> >> version, I've added the following improvements:
> >> 
> >> - Use accurate A-MPDU statistics from tx feedback
> >> - Rewrite the sampling algorithm to optimize for good A-MPDU lengths
> >>   and faster throughput recovery
> >> - Implement .rate_update to handle changes in HT capabilities or 
> >>   channel bandwidth
> >> - Remove the private tx flags hack
> >> 
> >> With the new version, performance has improved visibly for HT40 in all
> >> of my tests. I think it's getting closer to being ready for inclusion.
> >> ---
> > Just released carl9170 1.0.3.1 which now uses minstrel_ht.
> > 
> > I found a few things, not sure if they are bugs in the driver
> > or minstrel_ht code. (Patch attached, but added the comments
> > as a response to the code) 
> Thanks. How well does it perform in your tests compared to the old rc?
Hard to see any big difference under real life conditions.
But there are some "gains" with _synthetic_ benchmarks.

most notably: uni-directional UDP traffic now suffers much less from
package loss (old rc: ~ 3 - 7%, compared to minstrel: 0.0001% - 0.01%).
The throughput is not affected, It levels out at around ~130Mbits/s
in both tests.

> > on startup, carl9170 complains about non-aggregated
> > (CTL_AMPDU not set) MCS frames. I had to add an
> > alternative path for these _early_ frames. They are
> > now send with the "lowest" legacy rate and aren't
> > rejected by the driver/HW.
> Why does it complain - is that a driver thing or does the hardware
> really refuse it? I didn't see anything in the standard that mandates
> the use of A-MPDU with MCS rates.
WARN_ON in the driver. But yeah, on a second look:
It's just some old code from my own minstrel_ht (back in October 2009)
On a third look: The original vendor driver logic almost _forces_
the A-MPDU-bit upon HT frames. I can't tell for sure, if the
"other" mode actually works or just served as a testbed for development?!
So let's try: carl9170 1.0.3.2

Regards,
	Chr 
