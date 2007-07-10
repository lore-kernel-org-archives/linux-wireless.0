Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3296 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbXGJPDT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 11:03:19 -0400
Date: Tue, 10 Jul 2007 10:54:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: monitor mode support for OLPC
Message-ID: <20070710145402.GA7927@tuxdriver.com>
References: <468c3f32.081b600a.3817.5051@mx.google.com> <200707050842.01533.hs4233@mail.mn-solutions.de> <8e8340660707051037p56e10ec7u3aa4d76893e0b1ed@mail.gmail.com> <200707060922.06110.hs4233@mail.mn-solutions.de> <1183720126.3818.122.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1183720126.3818.122.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 06, 2007 at 01:08:46PM +0200, Johannes Berg wrote:
> Javier, Holger,
> 
> > Why not do it this way:
> > 
> > "iwmode eth1 mode monitor" turn's the device into monitor mode. 
> > That's what by far the most drivers use. In this mode, the 
> > device will send all frames to the host, e.g. all beacon frames. 
> > After all, user space can filter:
> > 
> >   tshark -i rtap0 -R '!(wlan.fc.subtype == 8)'
> 
> I suppose you really should be using cfg80211 to create and change the
> mode of new interfaces (and allow only one monitor and/or one STA
> interface). Then you actually get a sysfs file for free, and as a bonus
> it's the same one mac80211 uses :)

ACK

-- 
John W. Linville
linville@tuxdriver.com
