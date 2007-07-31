Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:37998 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759387AbXGaVuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:50:32 -0400
Message-ID: <46AFAEA5.2010104@warmcat.com>
Date: Tue, 31 Jul 2007 22:50:29 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
References: <20070730023128.99E927B409F@zog.reactivated.net>	<20070730145125.GC6586@tuxdriver.com>	<20070730225205.GA17252@deine-taler.de>	<200707310105.55863.mb@bu3sch.de>	<46AE7361.90406@warmcat.com> <20070731231249.121d55d4@logostar.upir.cz>
In-Reply-To: <20070731231249.121d55d4@logostar.upir.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Tue, 31 Jul 2007 00:25:21 +0100, Andy Green wrote:
>> The "soft" one is a faked up repeating of incoming (and outgoing!
>> twice!) packets
> 
> You mean you see each outgoing packet twice on soft monitor interface? That
> would be a bug.

It's not all outgoing packets, just the injected ones.  I described it here

http://marc.info/?l=linux-wireless&m=118544939901024&w=2

>> It really would be much better if the device
>> is kicked to hardware promisc if ANY virtual interface is in Monitor
>> mode, therefore the results are consistent regardless of the number of
>> virtual interfaces that happen to be around.
> 
> Of course. If the hardware supports that.

Is there any hardware that can't do hardware promisc and let the stack
decide what to throw away?  I would imagine the problem of having too
many kinds of packet should be okay to solve by examining MAC addresses
and so on.

-Andy
