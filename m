Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43932 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3HTQUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 12:20:17 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so585263pdj.22
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 09:20:17 -0700 (PDT)
Date: Tue, 20 Aug 2013 09:20:13 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Ben Hutchings <bhutchings@solarflare.com>,
	netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: changing dev->needed_headroom/needed_tailroom?
Message-ID: <20130820092013.6ca909e2@nehalam.linuxnetplumber.net> (sfid-20130820_182022_726947_40D5390B)
In-Reply-To: <CAGVrzcaGV6AqLTAxpM6zMv7_C-LNxp-WNg+J47d7a9S+Ca1bDw@mail.gmail.com>
References: <1374850210.8248.59.camel@jlt4.sipsolutions.net>
	<1375433758.24371.20.camel@deadeye.wl.decadent.org.uk>
	<1375449082.3927.5.camel@edumazet-glaptop>
	<1375711240.8120.11.camel@jlt4.sipsolutions.net>
	<CAGVrzcaGV6AqLTAxpM6zMv7_C-LNxp-WNg+J47d7a9S+Ca1bDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Aug 2013 11:00:18 +0100
Florian Fainelli <f.fainelli@gmail.com> wrote:

> 2013/8/5 Johannes Berg <johannes@sipsolutions.net>:
> > On Fri, 2013-08-02 at 06:11 -0700, Eric Dumazet wrote:
> >> On Fri, 2013-08-02 at 10:55 +0200, Ben Hutchings wrote:
> >>
> >> > I don't think this is safe when the interface is running (even if
> >> > carrier is off).  Some functions may read dev->needed_headroom twice and
> >> > rely on getting the same value each time.
> >>
> >> It should be no problem. Remaining unsafe places should be fixed.
> >
> > Most interesting would be stack devs, which I hadn't even considered. In
> > any case, since I can't completely _rely_ on it, it's an optimisation,
> > the only bugs would be around the double-access and then running
> > over/under the SKB or so?
> 
> As far as I could test this with an Ethernet driver which adjusted its
> needed_headroom by 64 bytes whenever some hardware feature was
> enabled/disabled, this expectedly broke bridge and vlans at least.
> Bridge code does not use the slave ports needed_headroom values, and
> VLAN devices get the parent device needed_headroom only when creating
> the vlan device. The good thing is since the needed_headroom space you
> need is most likely fixed for a given configuration type, you should
> see a pretty "stable" corruption of your SKB head.

All code must check for needed headroom first, and copy packet
if space is not available. Since excess headroom is always safe,
most devices just always use the same worst case headroom.

Even with your changes this will still be necessary since packets will
be still in flight while features change.

