Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33446 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab0JOSBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 14:01:37 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Date: Fri, 15 Oct 2010 11:01:36 -0700
Subject: RE: [PATCH 1/9] iwlagn: need longer tx queue stuck timer for coex
 devices
Message-ID: <E9954878DD1FB34FAE5187FB88C58A35012EE46C3F@orsmsx506.amr.corp.intel.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
 <1287079370-20587-2-git-send-email-wey-yi.w.guy@intel.com>
 <20101015164447.GB4286@redhat.com>
In-Reply-To: <20101015164447.GB4286@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

-----Original Message-----
From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
Sent: Friday, October 15, 2010 9:45 AM
To: Guy, Wey-Yi W
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/9] iwlagn: need longer tx queue stuck timer for coex devices

Wey,

On Thu, Oct 14, 2010 at 11:02:42AM -0700, Wey-Yi Guy wrote:
> For BT/WiFi combo devices, need longer tx stuck queue
> timer, so those devices won't reload firmware too often.

Seeing how many tweaking queue hung monitoring we need, I started
to think that the watchdog design is not so good. Currently we compare
q->read_ptr with q->last_read_ptr, and if they match 3 times in a row
during 200ms, we assume firmware hung. But maybe 200ms of no read_ptr
activity is too small time for device. Moreover we have unlikely but
possible situation when device is fully functional, but read_ptr will
wrap by accident to q->last_read_ptr on every check.

I think, better solution would be something like in rt2x00 or in
net/sched/sch_generic.c (however rt2x00 is easier to understand). It is
based on time stamp. When we get tx complete notification from hardware
(and incise read_ptr) mark the time stamp. In watchdog, which tick
periodically, check if queue is not empty and if current time is
bigger than time_stamp + time_out, if it is - firmware hung. More
smaller watchog tick give more precise hung detect (with disadvantage
of more cpu usage).


Me too not really like the current "monitor" approach, some thought about the design you propose.

1. "time_out" is something need to be define and has the similar problem like what we have today since different devices has different behavior. For example, in WiFi/BT combo case, the queue might not move for a while if BT traffic load is high
2. I don't really see much of "cpu usage" impact if we have a reasonable watchdog timer. But it is all relative.

By saying that, I think using timestamp might give more cleaner design, but still has the similar issues.

Thanks
Wey

