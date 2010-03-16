Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966352Ab0CPOx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 10:53:27 -0400
Date: Tue, 16 Mar 2010 15:51:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
Message-ID: <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com> <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net> <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com> <1268319960.4413.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268319960.4413.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes

On Thu, Mar 11, 2010 at 07:06:00AM -0800, Johannes Berg wrote:
> > > I have objections. Or maybe not, but I don't think this makes a whole
> > > lot of sense since the BE queue should be programmed in the "qos turned
> > > off" way normally. That may be broken right now, but to me your patches
> > > seem like a workaround rather than a solution which would require an
> > > analysis of what's really going on.
> > 
> > I looked at this on the air. Everything is fine until device send QoS
> > NULL frame (even with default parameters: normal ACK, TXOP request). 
> > Then AP send two strange Probe Response frames and Disassociate frame
> > with "Micheal MIC failure" error.
> 
> So here's good information, why did you not mention that before? :)
> 
> Yeah I guess in some sense this code dates back in mac80211 to where it
> assumed that the driver wasn't sending frames. I'll give it a thought,
> but I'm at a conference right now.

May I proceed with my patches or do you have a better idea how to solve
issue?

Thanks
Stanislaw
