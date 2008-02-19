Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbYBSVlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 16:41:07 -0500
Subject: Re: [PATCH 00/13] o11s: mesh interface support for mac80211
From: Dan Williams <dcbw@redhat.com>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1203455604.31736.23.camel@localhost>
References: <47a78212.15588c0a.27b2.61d2@mx.google.com>
	 (sfid-20080204_212233_169667_739F231D)  <1202343188.9965.41.camel@johannes.berg>
	 <1203455604.31736.23.camel@localhost>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 16:39:30 -0500
Message-Id: <1203457170.12619.4.camel@localhost.localdomain> (sfid-20080219_214111_583572_5CA2B837)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-19 at 13:13 -0800, Luis Carlos Cobo wrote:
> On Thu, 2008-02-07 at 01:13 +0100, Johannes Berg wrote:
> > > - Scan support: we were waiting for scan to be moved to cfg80211 to avoid
> > >   messing unnecessarily with wext, is there any effort in this direction?
> > 
> > What specifically do you need? Scanning for mesh networks? Wouldn't a
> > regular scan find them as well? As far as I know nobody is currently
> > working on scan support in nl80211. Maybe you can simply report the
> > relevant mesh IEs in a custom element and sort it out in userspace (for
> > now)?
> 
> Currently, bss are sorted by ssid, bssid and frequency. In mesh beacons
> and (not yet implemented) mesh probes, the bssid is left zeroed and
> there is no ssid (actually there is a 0 length ssid IE), so all mesh
> networks in a single channel would collapse to one scan entry. I can add
> the mesh IE, but I also need a substitute for those.
> 
> One option would be to use mesh id as bssid and source address as bssid
> (with this we would get a different entry for every mesh peer in rage,
> not sure if that's what we want), maybe set the mode to IW_MODE_ADHOC
> and add the extra mesh IE. This way we would not need changes in the
> wireless extesions layer.
> 
> I am also curious about the interfaces life cycle. Looks like interfaces
> report any available network (infra or adhoc), regardless their type.

Yes.  Ideally the driver will report mesh networks too, perhaps with
IW_MODE_MESH or whatever nl80211 would use.

> Then a network-manager-like interface would have to bring up an
> interface to be able to scan, and the if the user chooses a different
> kind of network (if the interface where the scan is performed is infra
> but the user chooses an ad-hoc network), change the type of the
> interface and the proceed to connect. Am I right?

Yeah, if the stack knows about a mesh network, we've got to be able to
present all the available choices and let the user decide what to do (or
try to do something intelligent like connect to the last used network if
it's seen).

Dan


