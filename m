Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46696
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbXHCULo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 16:11:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
Date: Fri, 3 Aug 2007 22:11:26 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707312037.33060.IvDoorn@gmail.com> <1186154435.4647.50.camel@johannes.berg> <200708031736.27782.IvDoorn@gmail.com>
In-Reply-To: <200708031736.27782.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708032211.26389.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, Ivo van Doorn wrote:
> On Friday 03 August 2007, Johannes Berg wrote:
> > On Fri, 2007-08-03 at 17:09 +0200, Ivo van Doorn wrote:
> > > On Friday 03 August 2007, Johannes Berg wrote:
> > > > On Tue, 2007-07-31 at 20:37 +0200, Ivo van Doorn wrote:
> > > > 
> > > > > +	if (is_monitor_present(intf)) {
> > > > > +		filter = IFF_PROMISC | IFF_MULTICAST | IFF_BROADCAST;
> > > > > +		if (intf->filter != filter)
> > > > > +			__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
> > > > > +	}
> > > > 
> > > > Don't do that. There's no requirement that monitor mode interfaces
> > > > always be promisc. Also, earlier in the code:
> > > 
> > > Note that this "Enable promisc" on monitor mode here will only be send to
> > > the device. It does not mean that the non-monitor mode will have promisc
> > > mode enabled. In fact, when the monitor interface goes down, the normal
> > > setting will be used again.
> > > If with monitor mode, IFF_PROMISC is not send to the device, monitor
> > > mode is useless since it will not catch anything except beacons
> > > (Especially true when you only have 1 interface which is in monitor mode)
> > 
> > But don't you allow monitoring during operation? In that case this would
> > make that monitor interface always promisc which isn't what you want
> > unless you set the promisc bit on any of the interfaces.
> 
> But that would mean that when a non-monitor and monitor interface are
> enabled at the same time, the montitor interface is quite pointless since
> all frames can be caught on the regular interface as well. 
> 
> A monitor interface is supposed to catch as many frames as possible,
> if a monitor interface does not catch frames not directly send to it, it won't
> catch anything except beacons.
> 
> Even when there is only 1 interface which is in monitor mode, the user shouldn't
> have to set the device into promisc mode right?

You are wrong.
The promisc attribute is a _different_ setting from the monitor
bits. If userspace wants promisc, it tells you (through set mcast_list stuff).
And tcpdump/wireshark and stuff _do_ this.
If userspace wants a nonpromisc monitor, it should be allowed to have one.
Don't put policy into the kernel and make bad assumptions like
"monitor interface wants to be promisc".

