Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab0CQPz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 11:55:29 -0400
Subject: Re: [RFC] mac80211,iwlwifi: disabling qos queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com>
	 <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com>
	 <1268265597.4192.3.camel@jlt3.sipsolutions.net>
	 <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com>
	 <1268319960.4413.1.camel@jlt3.sipsolutions.net>
	 <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com>
	 <1268774282.4054.1.camel@jlt3.sipsolutions.net>
	 <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 08:51:46 -0700
Message-ID: <1268841106.5989.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 10:26 +0100, Stanislaw Gruszka wrote:

> > Sorry ... I had given this some thought and then got distracted ...
> > still had it unread but no time to reply. What I finally realised is
> > that we set the information per queue, and even the userspace API is
> > built that way, so we really need to have a separate configuration to
> > enable/disable QoS. Maybe a BSS config flag would be appropriate?
> 
> Maybe in -next but not in -stable since drivers in ieee80211_ops->config 
> and ieee80211_ops->bss_info_chnged do some additional work not looking at
> changed variable. So my plan is put change I proposed in stable and
> further optimize it in -next, ok?

I really don't think it should work that way. I'd like to see the patch
for the current kernels including 2.6.34 first, and then we can decide
how to backport it. FWIW, I don't think drivers should be having trouble
with a new flag there.

johannes

