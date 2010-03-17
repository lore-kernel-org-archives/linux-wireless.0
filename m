Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0CQJ2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 05:28:23 -0400
Date: Wed, 17 Mar 2010 10:26:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
Message-ID: <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com> <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net> <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com> <1268319960.4413.1.camel@jlt3.sipsolutions.net> <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com> <1268774282.4054.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268774282.4054.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 16, 2010 at 02:18:02PM -0700, Johannes Berg wrote:
> > > > I looked at this on the air. Everything is fine until device send QoS
> > > > NULL frame (even with default parameters: normal ACK, TXOP request). 
> > > > Then AP send two strange Probe Response frames and Disassociate frame
> > > > with "Micheal MIC failure" error.
> > > 
> > > So here's good information, why did you not mention that before? :)
> > > 
> > > Yeah I guess in some sense this code dates back in mac80211 to where it
> > > assumed that the driver wasn't sending frames. I'll give it a thought,
> > > but I'm at a conference right now.
> > 
> > May I proceed with my patches or do you have a better idea how to solve
> > issue?
> 
> Sorry ... I had given this some thought and then got distracted ...
> still had it unread but no time to reply. What I finally realised is
> that we set the information per queue, and even the userspace API is
> built that way, so we really need to have a separate configuration to
> enable/disable QoS. Maybe a BSS config flag would be appropriate?

Maybe in -next but not in -stable since drivers in ieee80211_ops->config 
and ieee80211_ops->bss_info_chnged do some additional work not looking at
changed variable. So my plan is put change I proposed in stable and
further optimize it in -next, ok?

Stanislaw
