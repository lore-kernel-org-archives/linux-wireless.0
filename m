Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:32133 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752122AbXKXJft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 04:35:49 -0500
From: bruno randolf <bruno@thinktube.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH] mac80211: include MAC timestamp in radiotap header
Date: Sat, 24 Nov 2007 18:36:04 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1195814754.4149.86.camel@johannes.berg> <1195893283.4149.188.camel@johannes.berg> <1195896461.8231.3.camel@localhost>
In-Reply-To: <1195896461.8231.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711241836.05159.bruno@thinktube.com> (sfid-20071124_093553_843309_C17FF799)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 24 November 2007 18:27:41 Mattias Nissler wrote:
> On Sat, 2007-11-24 at 09:34 +0100, Johannes Berg wrote:
> > On Sat, 2007-11-24 at 00:21 -0500, Michael Wu wrote:
> > > On Friday 23 November 2007 05:45:54 Johannes Berg wrote:
> > > > This makes mac80211 include the low-level MAC timestamp
> > > > in the radiotap header.
> > >
> > > No thanks. Not every driver supports reporting the timestamp and
> > > supporting timestamp/no timestamp in the default radiotap rx code makes
> > > it not so simple anymore.
> >
> > Uh, so how am I supposed to get the timestamp? Copy all the code into
> > b43 and make it generate the exact same radiotap header? That's pretty
> > crappy too.
>
> On rt2x00, we've just added a facility that dumps information about all
> frames received and transmitted at a very low level. We dump general
> information about the frame, the tx/rx descriptors and the packet. Maybe
> something similar would also be useful for b43?

that's not a solution if you want them per packet in the radiotap header.
kismet & wireshark use them as well as other applications.

bruno
