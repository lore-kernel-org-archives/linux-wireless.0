Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab0JOQmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 12:42:33 -0400
Date: Fri, 15 Oct 2010 18:44:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/9] iwlagn: need longer tx queue stuck timer for coex
 devices
Message-ID: <20101015164447.GB4286@redhat.com>
References: <1287079370-20587-1-git-send-email-wey-yi.w.guy@intel.com>
 <1287079370-20587-2-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1287079370-20587-2-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Stanislaw
