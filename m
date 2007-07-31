Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:41845 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbXGaVmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:42:50 -0400
Message-ID: <46AFACD6.9020607@warmcat.com>
Date: Tue, 31 Jul 2007 22:42:46 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
References: <20070730023128.99E927B409F@zog.reactivated.net> <46AE7361.90406@warmcat.com> <20070731231249.121d55d4@logostar.upir.cz> <200707312330.48698.mb@bu3sch.de>
In-Reply-To: <200707312330.48698.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Tuesday 31 July 2007 23:12:49 Jiri Benc wrote:
>> On Tue, 31 Jul 2007 00:25:21 +0100, Andy Green wrote:
>>> The "soft" one is a faked up repeating of incoming (and outgoing!
>>> twice!) packets
>> You mean you see each outgoing packet twice on soft monitor interface? That
>> would be a bug.
>>
>>> It really would be much better if the device
>>> is kicked to hardware promisc if ANY virtual interface is in Monitor
>>> mode, therefore the results are consistent regardless of the number of
>>> virtual interfaces that happen to be around.
>> Of course. If the hardware supports that.
> 
> The device should _not_ be kicked to promisc, if we have a monitor
> interface. The promisc bit is a completely seperate setting
> and must be handled seperate from the monitor stuff.
> Userspace does take care of setting the promisc bit, if it's
> required.
> We recently fixed this bug in bcm43xx.

Well that's fine... tcpdump for example does IFF_PROMISC while it runs
so nobody who doesn't care will notice the difference, but I guess you
get the power saving while IFF_PROMISC is off and the Monitor mode
interface is up.

But anyone who tcpdumps on a Monitor mode interface still always sees
the whole picture, not the synthesized one.  Sounds like a good general
way to me.

-Andy
