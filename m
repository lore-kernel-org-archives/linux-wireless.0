Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33315 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751403AbXKXNi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 08:38:57 -0500
Subject: Re: [PATCH] mac80211: include MAC timestamp in radiotap header
From: Mattias Nissler <mattias.nissler@gmx.de>
To: bruno randolf <bruno@thinktube.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200711241836.05159.bruno@thinktube.com>
References: <1195814754.4149.86.camel@johannes.berg>
	 <1195893283.4149.188.camel@johannes.berg>
	 <1195896461.8231.3.camel@localhost>
	 <200711241836.05159.bruno@thinktube.com>
Content-Type: text/plain
Date: Sat, 24 Nov 2007 14:38:51 +0100
Message-Id: <1195911531.8231.5.camel@localhost> (sfid-20071124_133905_353963_8BC84B93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-11-24 at 18:36 +0900, bruno randolf wrote:
> On Saturday 24 November 2007 18:27:41 Mattias Nissler wrote:
> > On Sat, 2007-11-24 at 09:34 +0100, Johannes Berg wrote:
> > > On Sat, 2007-11-24 at 00:21 -0500, Michael Wu wrote:
> > > > On Friday 23 November 2007 05:45:54 Johannes Berg wrote:
> > > > > This makes mac80211 include the low-level MAC timestamp
> > > > > in the radiotap header.
> > > >
> > > > No thanks. Not every driver supports reporting the timestamp and
> > > > supporting timestamp/no timestamp in the default radiotap rx code makes
> > > > it not so simple anymore.
> > >
> > > Uh, so how am I supposed to get the timestamp? Copy all the code into
> > > b43 and make it generate the exact same radiotap header? That's pretty
> > > crappy too.
> >
> > On rt2x00, we've just added a facility that dumps information about all
> > frames received and transmitted at a very low level. We dump general
> > information about the frame, the tx/rx descriptors and the packet. Maybe
> > something similar would also be useful for b43?
> 
> that's not a solution if you want them per packet in the radiotap header.
> kismet & wireshark use them as well as other applications.

We actually dump per packet data that is read via debugfs and then fed
into wireshark. Helps debugging a lot :-)

Mattias

