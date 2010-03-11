Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab0CKPGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 10:06:45 -0500
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
	 <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
	 <1268265597.4192.3.camel@jlt3.sipsolutions.net>
	 <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 07:06:00 -0800
Message-ID: <1268319960.4413.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 10:56 +0100, Stanislaw Gruszka wrote:
> On Wed, Mar 10, 2010 at 03:59:57PM -0800, Johannes Berg wrote:
> > I have objections. Or maybe not, but I don't think this makes a whole
> > lot of sense since the BE queue should be programmed in the "qos turned
> > off" way normally. That may be broken right now, but to me your patches
> > seem like a workaround rather than a solution which would require an
> > analysis of what's really going on.
> 
> I looked at this on the air. Everything is fine until device send QoS
> NULL frame (even with default parameters: normal ACK, TXOP request). 
> Then AP send two strange Probe Response frames and Disassociate frame
> with "Micheal MIC failure" error.

So here's good information, why did you not mention that before? :)

Yeah I guess in some sense this code dates back in mac80211 to where it
assumed that the driver wasn't sending frames. I'll give it a thought,
but I'm at a conference right now.

johannes

