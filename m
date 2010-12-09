Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0LIOme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:42:34 -0500
Subject: Re: [PATCH] mac80211: Fix deadlock in ieee80211_do_stop.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4D00E8E2.1030201@kernel.org>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>
	 <4CDDAA3B.9090007@candelatech.com>
	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>
	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>
	 <4CE292F7.4090200@kernel.org>
	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>
	 <4CE396A9.1050908@kernel.org>
	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>
	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>
	 <4CE4D41F.1080005@kernel.org>
	 <1290099585.3801.1.camel@jlt3.sipsolutions.net>
	 <4CE68AF4.8060507@kernel.org>
	 <1290189452.3768.3.camel@jlt3.sipsolutions.net>
	 <4CE6E430.6080804@candelatech.com>
	 <AANLkTimf9D-HP8i99ReVrTqcDHrWchT=HSeTywe_=as0@mail.gmail.com>
	 <4CFFC214.6000608@candelatech.com> <4CFFCC31.1050408@candelatech.com>
	 <4CFFCE47.8040305@candelatech.com>  <4D00E8E2.1030201@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 15:42:30 +0100
Message-ID: <1291905750.3540.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 15:34 +0100, Tejun Heo wrote:

>    [<78447ce1>] flush_work+0x23/0x27
>    [<f91a2646>] ieee80211_do_stop+0x25c/0x403 [mac80211]

>    [<787001fe>] rtnetlink_rcv+0x1b/0x22		<- rtnl lock

Right, so we're flushing here under RTNL ... I believe this is the one
that Ben hacked up to not flush or so?

>    [<7878cdab>] _cond_resched+0x2b/0x44
>    [<7878d84f>] mutex_lock_nested+0x22/0x3b
>    [<f919fddc>] ieee80211_sta_rx_queued_mgmt+0x2d/0x3a6 [mac80211]
>    [<f91a2f53>] ieee80211_iface_work+0x1ff/0x282 [mac80211]

> But, sdata->work is busy running ieee80211_iface_work().  I _suspect_
> for some reason iee80211_iface_work() isn't finishing.

It's trying to acquire a mutex here, which must be &ifmgd->mtx or
&local->mtx, but neither of them ever nest around the RTNL.

> That, or, the
> new flush_work() implementation is broken and it's failing to flush
> when a work is being executed back to back.  I'll prep a debug patch
> to determine what's going on.

Thanks.

I wonder if Ben can attempt to reproduce this using compat-wireless
against a kernel that doesn't have the workqueue changes, was the last
one without those 2.6.34? 2.6.35?

> The rest of the system going down the toilet after this is mostly
> caused by the held rtnl_lock above.

Indeed, the rtnl is pretty important :-)

johannes

