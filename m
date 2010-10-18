Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0JRMKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 08:10:33 -0400
Date: Mon, 18 Oct 2010 14:12:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/9] iwlagn: need longer tx queue stuck timer for coex
 devices
Message-ID: <20101018121250.GA4005@redhat.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
 <1287079370-20587-2-git-send-email-wey-yi.w.guy@intel.com>
 <20101015164447.GB4286@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A35012EE46C3F@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A35012EE46C3F@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

> activity is too small time for device. Moreover we have unlikely but
> possible situation when device is fully functional, but read_ptr will
> wrap by accident to q->last_read_ptr on every check.
> 
> I think, better solution would be something like in rt2x00 or in
> net/sched/sch_generic.c (however rt2x00 is easier to understand). It is
> based on time stamp. When we get tx complete notification from hardware
> (and incise read_ptr) mark the time stamp. In watchdog, which tick
> periodically, check if queue is not empty and if current time is
> bigger than time_stamp + time_out, if it is - firmware hung. More
> smaller watchog tick give more precise hung detect (with disadvantage
> of more cpu usage).
> 
> 
> Me too not really like the current "monitor" approach, some thought about the design you propose.
> 
> 1. "time_out" is something need to be define and has the similar problem like what we have today since different devices has different behavior. For example, in WiFi/BT combo case, the queue might not move for a while if BT traffic load is high

Sure.

However new watchdog could be more precise. Currently if hung will
happen just after watchdog tick we are detecting it in time about 2
ticks i.e. 10s, or when happen just before the tick we detect the hang
in 1 tick i.e. 5s, what gives 100% inaccuracy. New design can be much
more precise.

> 2. I don't really see much of "cpu usage" impact if we have a reasonable watchdog timer. But it is all relative.

Ohh, I was talking about cpu usage in new design I described.

> 
> By saying that, I think using timestamp might give more cleaner design, but still has the similar issues.

Ok, if Intel have no plan to change the monitor recovery and have nothing
against my watchdog approach, I'm going to cook some patches.

Stanislaw
