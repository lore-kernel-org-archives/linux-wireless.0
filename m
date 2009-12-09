Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37892 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZLIPPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 10:15:11 -0500
Date: Wed, 9 Dec 2009 10:05:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-hotplug@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless device and udev
Message-ID: <20091209150527.GA32058@tuxdriver.com>
References: <20091207172616.7470ed2b@nehalam> <1260300551.32227.1.camel@johannes.local> <20091208200504.GC16303@tuxdriver.com> <200912090654.28630.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200912090654.28630.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 09, 2009 at 06:54:27AM +0300, Andrey Borzenkov wrote:
> On Tuesday 08 of December 2009 23:05:04 John W. Linville wrote:
> > On Tue, Dec 08, 2009 at 08:29:11PM +0100, Johannes Berg wrote:
> > > On Tue, 2009-12-08 at 13:52 -0500, John W. Linville wrote:
> > > > So, probably we need to map from the wlanX name to the phyY name,
> > > > then determine whether or not this is the first wlanX for phyY.
> > > > If not, then the name should be left alone.
> > > >
> > > > Now, how do we figure out how many wlanX's belong to phyY?
> > >
> > > And what's the "first" one? :)
> > 
> > I suppose I was figuring that if there was only one, it was the
> > first. :-)  But you're right, I suppose that could be racy...
> > 
> > > ls /sys/class/net/wlan0/device/net/
> > >
> > > will give you the list of interface associated with this device.
> > 
> > Cool...
> > 
> 
> Is it possible to distinguish between automatic system enumeration when 
> new device is created and explicit name that user gives? Because in 
> example above (iw phy add interface) user already supplied specific 
> name; there is no reason for udev to (try to) mangle it.

That's why I wanted the "first" one...it is auto-generated. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
