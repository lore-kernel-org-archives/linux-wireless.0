Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49040 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748Ab1FVN05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:26:57 -0400
Date: Wed, 22 Jun 2011 15:27:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
Message-ID: <20110622132705.GE22420@sortiz-mobl> (sfid-20110622_152700_506991_ECCD1B34)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
 <1308728084.3883.9.camel@jlt3.sipsolutions.net>
 <20110622125710.GD22420@sortiz-mobl>
 <1308748086.29571.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308748086.29571.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 22, 2011 at 03:08:06PM +0200, Johannes Berg wrote:
> On Wed, 2011-06-22 at 14:57 +0200, Samuel Ortiz wrote:
> 
> > > And this looks like an array. Do you really want to do that? That means
> > > lots of reallocations.
> 
> > So NFC polling is a bit weird. Whenever you start polling for passive targets,
> > the polling results are minimal: You only know that there is _a_ target on a
> > particular frequency/modulation. It could be the same as the one you got 5
> > minutes ago, or not. To verify it, you'd need to select the target (and put
> > all other ones on standby) and start sending specific commands to it (Of
> > course, you have a different set of commands per target family...). Only then
> > you _may_ read some sort of UID that could help you matching targets from your
> > previous poll cycle.
> > My point is, when we start polling, we will invalidate all existing targets
> > anyway. So a linked list or an array won't make a big difference in that area.
> 
> So basically you're saying that you basically get everything at the same
> time so you really throw away the old list/array and re-create it.
Basically, yes. And trying to check which parts of the old list is still there
is quite expensive.

 
> But from a driver POV, does it really know the number of targets?
It does. From the NFC HW I got access to, it's either one single target, or
at most one per rf band. And in that case the driver can know if there is or
not a target on a specific band.

> Anyway, all this doesn't matter since it's purely internal, and the
> userspace APIs no longer have this limitation, so if this turns out an
> issue at some point internal refactoring can easily fix it :-)
That's certainly true.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
