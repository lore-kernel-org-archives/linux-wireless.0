Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:24610 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYBSVLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 16:11:53 -0500
Received: by ug-out-1314.google.com with SMTP id z38so637107ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2008 13:11:52 -0800 (PST)
Subject: Re: [PATCH 00/13] o11s: mesh interface support for mac80211
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202343188.9965.41.camel@johannes.berg>
References: <47a78212.15588c0a.27b2.61d2@mx.google.com>
	 (sfid-20080204_212233_169667_739F231D)  <1202343188.9965.41.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 13:13:24 -0800
Message-Id: <1203455604.31736.23.camel@localhost> (sfid-20080219_211158_338281_60EFBE43)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-07 at 01:13 +0100, Johannes Berg wrote:
> > - Scan support: we were waiting for scan to be moved to cfg80211 to avoid
> >   messing unnecessarily with wext, is there any effort in this direction?
> 
> What specifically do you need? Scanning for mesh networks? Wouldn't a
> regular scan find them as well? As far as I know nobody is currently
> working on scan support in nl80211. Maybe you can simply report the
> relevant mesh IEs in a custom element and sort it out in userspace (for
> now)?

Currently, bss are sorted by ssid, bssid and frequency. In mesh beacons
and (not yet implemented) mesh probes, the bssid is left zeroed and
there is no ssid (actually there is a 0 length ssid IE), so all mesh
networks in a single channel would collapse to one scan entry. I can add
the mesh IE, but I also need a substitute for those.

One option would be to use mesh id as bssid and source address as bssid
(with this we would get a different entry for every mesh peer in rage,
not sure if that's what we want), maybe set the mode to IW_MODE_ADHOC
and add the extra mesh IE. This way we would not need changes in the
wireless extesions layer.

I am also curious about the interfaces life cycle. Looks like interfaces
report any available network (infra or adhoc), regardless their type.
Then a network-manager-like interface would have to bring up an
interface to be able to scan, and the if the user chooses a different
kind of network (if the interface where the scan is performed is infra
but the user chooses an ad-hoc network), change the type of the
interface and the proceed to connect. Am I right?

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


