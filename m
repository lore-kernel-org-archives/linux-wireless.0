Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41483 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYLOR2i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:28:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 09:28:38 -0800
Date: Mon, 15 Dec 2008 01:28:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dan Williams <dcbw@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mabbaswireless@gmail.com" <mabbaswireless@gmail.com>
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Message-ID: <20081215092857.GE6162@tesla> (sfid-20081215_182843_192759_B1D82BEA)
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com> <1229336057.4471.9.camel@johannes.berg> <1229354532.12163.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1229354532.12163.24.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 07:22:12AM -0800, Dan Williams wrote:
> On Mon, 2008-12-15 at 11:14 +0100, Johannes Berg wrote:
> > Sorry, heh, was reading mail in the wrong order I guess.
> >
> > >  - the call to ieee80211_sta_tear_down_BA_sessions was locking up so
> > >    I just dropped it for now in the interest of getting a stable base
> >
> > Probably due to transmitting again? We'll have to look and add it, but I
> > agree that we can work on that later.
> >
> > > I also tracked down the disappearing interface problem.. turns out this
> > > was just gnome-power-manager or HAL.  (I do not have 'network_sleep' set
> > > in gconf, but I didn't bother pinning it down otherwise...)  Using
> > > 'echo mem > /sys/power/state' to suspend keeps the interface up across
> > > suspend.
> >
> > Oh ok, that explains things.
> 
> Could be udev event ordering?  We do need to track this down, otherwise
> stuff simply won't work when we come back.  The best thing to do here is
> run the udev monitoring tool (whatever that is, I forget) 

That would be:

udevadm monitor --environment kernel

> and see what
> events get emitted from the kernel, then run 'lshal --monitor' and see
> what HAL thinks is going on, which it gets from consuming udev events
> and inspecting sysfs.  Stuff like this is sometimes caused by
> mis-ordered kernel events or drivers/subsystems that don't create their
> sysfs directories at the right times, leading to race conditions between
> the kernel and HAL.  A possibility.

  Luis
