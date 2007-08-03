Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:37950 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXHCPFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:05:13 -0400
Received: by ug-out-1314.google.com with SMTP id j3so473541ugf
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2007 08:05:11 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
Date: Fri, 3 Aug 2007 17:09:39 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707312037.33060.IvDoorn@gmail.com> <1186149676.4647.42.camel@johannes.berg>
In-Reply-To: <1186149676.4647.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708031709.39208.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, Johannes Berg wrote:
> On Tue, 2007-07-31 at 20:37 +0200, Ivo van Doorn wrote:
> 
> > +	if (is_monitor_present(intf)) {
> > +		filter = IFF_PROMISC | IFF_MULTICAST | IFF_BROADCAST;
> > +		if (intf->filter != filter)
> > +			__set_bit(PACKET_FILTER_PENDING, &rt2x00dev->flags);
> > +	}
> 
> Don't do that. There's no requirement that monitor mode interfaces
> always be promisc. Also, earlier in the code:

Note that this "Enable promisc" on monitor mode here will only be send to
the device. It does not mean that the non-monitor mode will have promisc
mode enabled. In fact, when the monitor interface goes down, the normal
setting will be used again.
If with monitor mode, IFF_PROMISC is not send to the device, monitor
mode is useless since it will not catch anything except beacons
(Especially true when you only have 1 interface which is in monitor mode)

> > +       int promisc = !!(filter & IFF_PROMISC);
> > +       int multicast = !!(filter & IFF_MULTICAST);
> > +       int broadcast = !!(filter & IFF_BROADCAST);
> >         u32 reg;
> >  
> >         rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
> >         rt2x00_set_field32(&reg, RXCSR0_DROP_NOT_TO_ME, !promisc);
> > +       rt2x00_set_field32(&reg, RXCSR0_DROP_MCAST, !multicast);
> > +       rt2x00_set_field32(&reg, RXCSR0_DROP_BCAST, !broadcast);
> >         rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
> 
> Depending on how the hardware behaves I think promisc should imply the
> other two, it seems likely that even with DROP_NOT_TO_ME turned off you
> won't be getting multicast traffic and promisc should see that too.

Setting those 2 registers is having them at least configurable instead of having
them always to 0. At least now the user has some control over them. ;)

Ivo
