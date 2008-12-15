Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYLOPYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 10:24:23 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
In-Reply-To: <1229336057.4471.9.camel@johannes.berg>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 10:22:12 -0500
Message-Id: <1229354532.12163.24.camel@localhost.localdomain> (sfid-20081215_162425_994978_CD683B80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 11:14 +0100, Johannes Berg wrote:
> Sorry, heh, was reading mail in the wrong order I guess.
> 
> >  - the call to ieee80211_sta_tear_down_BA_sessions was locking up so 
> >    I just dropped it for now in the interest of getting a stable base
> 
> Probably due to transmitting again? We'll have to look and add it, but I
> agree that we can work on that later.
> 
> > I also tracked down the disappearing interface problem.. turns out this 
> > was just gnome-power-manager or HAL.  (I do not have 'network_sleep' set 
> > in gconf, but I didn't bother pinning it down otherwise...)  Using 
> > 'echo mem > /sys/power/state' to suspend keeps the interface up across
> > suspend.
> 
> Oh ok, that explains things.

Could be udev event ordering?  We do need to track this down, otherwise
stuff simply won't work when we come back.  The best thing to do here is
run the udev monitoring tool (whatever that is, I forget) and see what
events get emitted from the kernel, then run 'lshal --monitor' and see
what HAL thinks is going on, which it gets from consuming udev events
and inspecting sysfs.  Stuff like this is sometimes caused by
mis-ordered kernel events or drivers/subsystems that don't create their
sysfs directories at the right times, leading to race conditions between
the kernel and HAL.  A possibility.

Dan


