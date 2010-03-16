Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0CQAxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 20:53:38 -0400
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
	 <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
	 <1268265597.4192.3.camel@jlt3.sipsolutions.net>
	 <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com>
	 <1268319960.4413.1.camel@jlt3.sipsolutions.net>
	 <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 14:18:02 -0700
Message-ID: <1268774282.4054.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > I looked at this on the air. Everything is fine until device send QoS
> > > NULL frame (even with default parameters: normal ACK, TXOP request). 
> > > Then AP send two strange Probe Response frames and Disassociate frame
> > > with "Micheal MIC failure" error.
> > 
> > So here's good information, why did you not mention that before? :)
> > 
> > Yeah I guess in some sense this code dates back in mac80211 to where it
> > assumed that the driver wasn't sending frames. I'll give it a thought,
> > but I'm at a conference right now.
> 
> May I proceed with my patches or do you have a better idea how to solve
> issue?

Sorry ... I had given this some thought and then got distracted ...
still had it unread but no time to reply. What I finally realised is
that we set the information per queue, and even the userspace API is
built that way, so we really need to have a separate configuration to
enable/disable QoS. Maybe a BSS config flag would be appropriate?

johannes

