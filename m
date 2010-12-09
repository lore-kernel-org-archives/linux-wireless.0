Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:43527 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab0LINRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 08:17:24 -0500
Subject: Re: [PATCH] cfg80211: update information elements in cached BSS
 struct
From: Sven Neumann <s.neumann@raumfeld.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291898876.3540.4.camel@jlt3.sipsolutions.net>
References: <1291891690-26118-1-git-send-email-s.neumann@raumfeld.com>
	 <1291898876.3540.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 14:17:20 +0100
Message-ID: <1291900640.1924.33.camel@sven>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 2010-12-09 at 13:47 +0100, Johannes Berg wrote:
> On Thu, 2010-12-09 at 11:48 +0100, Sven Neumann wrote:
> > When a cached BSS struct is updated because a new beacon was received,
> > the code replaces the cached information elements by the IEs from the
> > new beacon. However it did not update the pub.information_elements
> > and pub.len_information_elements fields leaving them either pointing
> > to the old beacon IEs or in an inconsistent state where the data is
> > replaced by the new beacon IEs but len_information_elements still has
> > its value from the first beacon.
> > 
> > Fix this by updating the information elements fields if they are
> > pointing to beacon IEs.
> 
> Err, no, this is intentional -- we want data from probe responses to
> "win" and be displayed preferentially. If you look at the code that
> dumps them out, that's what will happen.

As far as I can see my patch does not break this behavior. The
information elements fields are only updated if they are currently
pointing to beacon IEs. If there's ever a probe response frame, then it
will win and the information elements fields won't be changed for
beacons arriving later.

> If you need the most up-to-date beacon IEs, use (the equivalent of) "iw
> wlan0 scan dump -b".

What my patch is fixing are the following situations (and yes, this
happened in real life, it is reproducable and it is reproducably fixed
by the patch that I've submitted):

 AP sends a beacon without RSN IE. This is the first beacon received
 and the station with IEs is added to the BSS cache.
 pub.information_elements now points to pub.beacon_ies and
 pub.len_information_elements has the value of pub.len_beacon_ies.

 AP sends another beacon, this time it includes RSN IE. As there's
 not enough place for the larger IEs, memory is allocated for it
 and the pub.beacon_ies pointer is changed to point to this newly
 allocated memory. Now pub.information_elements still points to
 the old value.

 User-space asks for scan results and will receive the IEs from the
 first beacon because even though the data from subsequent beacons
 has been added to the cache, pub.information_elements still points
 to the old data.

 As a result user-space looking for a WPA enabled access-point will
 skip the AP and never associate with it. This situation will only
 ever fix itself if you are lucky enough that so few beacons are
 arriving that the cached RSS expires at some point.

And there are even worse scenarios:

 If the second beacon is smaller than the first or only slightly larger
 (so that it fits into the allocated memory which has some padding),
 then no new memory will be allocated for the IEs. Instead the data
 in pub.beacon_ies will be changed and pub.len_beacon_ies will be
 updated. Now pub.information_elements points to the new data
 but pub.len_information_elements still holds the old value. Data
 and length have become inconsistent. As a result invalid IEs are
 returned to user-space when it asks for scan results.

As you can see this is all without any probe response frames. Our driver
(libertas) doesn't do any active scanning and thus there are no probe
response frames received. I still tried to write the patch in a way that
should not break things if probe response frames are received.

Please review this patch again. I am pretty sure that there's something
broken. Perhaps my fix is not totally correct, but it fixes a
reproducable association problem for us.


Regards,
Sven


-- 
Sven Neumann
Head of Software Development

RAUMFELD GmbH | Reichenberger Str. 124 | 10999 Berlin | Germany
Tel: +49.30.340.60.98.0 | Fax: +49.30.340.60.98.99 | s.neumann@raumfeld.com

