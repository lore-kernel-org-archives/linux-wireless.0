Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:58286 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761969AbYBSV70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 16:59:26 -0500
Received: by py-out-1112.google.com with SMTP id u52so2822878pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2008 13:59:25 -0800 (PST)
Message-ID: <43e72e890802191359o5c6a869i559a4f6aeb686772@mail.gmail.com> (sfid-20080219_215939_521454_FE3E7CA8)
Date: Tue, 19 Feb 2008 16:59:24 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Luis Carlos Cobo" <luisca@cozybit.com>
Subject: Re: [PATCH 00/13] o11s: mesh interface support for mac80211
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1203455604.31736.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47a78212.15588c0a.27b2.61d2@mx.google.com>
	 <1202343188.9965.41.camel@johannes.berg>
	 <1203455604.31736.23.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 19, 2008 4:13 PM, Luis Carlos Cobo <luisca@cozybit.com> wrote:
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
> Currently, bss are sorted by ssid, bssid and frequency.

I wouldn't use "sort" here but instead "are made unique". As John has
mentioned in a recent thread this was done to account for "some
strange AP implementations that use the same BSSID either on different
frequencies or in different SSIDs". We actually don't currently sort
the list of BSSes by any specific value but the idea was to end up
sorting by signal strength measured, for which I have a base patch.
Userspace should then be sort by whatever key it wants to presents its
data to the user.

> In mesh beacons
> and (not yet implemented) mesh probes, the bssid is left zeroed and
> there is no ssid (actually there is a 0 length ssid IE), so all mesh
> networks in a single channel would collapse to one scan entry.

I can see how this can be an issue :)

> I can add
> the mesh IE, but I also need a substitute for those.
>
> One option would be to use mesh id as bssid and source address as bssid
> (with this we would get a different entry for every mesh peer in rage,
> not sure if that's what we want), maybe set the mode to IW_MODE_ADHOC
> and add the extra mesh IE. This way we would not need changes in the
> wireless extesions layer.

The key'ing of the BSSes based on BSSID/freq/SSID was just a to deal
with an issue, how about we just detect if a beacon is from a mesh and
if so add it to the list using another type of rule? Since we have no
BSSID/SSID strange issue we don't have to apply that rule there.

> I am also curious about the interfaces life cycle. Looks like interfaces
> report any available network (infra or adhoc), regardless their type.
> Then a network-manager-like interface would have to bring up an
> interface to be able to scan, and the if the user chooses a different
> kind of network (if the interface where the scan is performed is infra
> but the user chooses an ad-hoc network), change the type of the
> interface and the proceed to connect. Am I right?

Hopefully nothing will be added via wext, but instead nl80211/cfg80211.

  Luis
