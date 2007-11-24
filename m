Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37797 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751705AbXKXJ1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 04:27:48 -0500
Subject: Re: [PATCH] mac80211: include MAC timestamp in radiotap header
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1195893283.4149.188.camel@johannes.berg>
References: <1195814754.4149.86.camel@johannes.berg>
	 <200711240021.12394.flamingice@sourmilk.net>
	 <1195893283.4149.188.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 24 Nov 2007 10:27:41 +0100
Message-Id: <1195896461.8231.3.camel@localhost> (sfid-20071124_092758_216800_B8C9FB05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-11-24 at 09:34 +0100, Johannes Berg wrote:
> On Sat, 2007-11-24 at 00:21 -0500, Michael Wu wrote:
> > On Friday 23 November 2007 05:45:54 Johannes Berg wrote:
> > > This makes mac80211 include the low-level MAC timestamp
> > > in the radiotap header.
> > >
> > No thanks. Not every driver supports reporting the timestamp and supporting 
> > timestamp/no timestamp in the default radiotap rx code makes it not so simple 
> > anymore.
> 
> Uh, so how am I supposed to get the timestamp? Copy all the code into
> b43 and make it generate the exact same radiotap header? That's pretty
> crappy too.

On rt2x00, we've just added a facility that dumps information about all
frames received and transmitted at a very low level. We dump general
information about the frame, the tx/rx descriptors and the packet. Maybe
something similar would also be useful for b43?

Mattias

