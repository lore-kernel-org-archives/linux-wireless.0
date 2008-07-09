Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:3223 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbYGIQEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 12:04:06 -0400
Received: by ug-out-1314.google.com with SMTP id h2so89820ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 09:04:05 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 18:12:55 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <1215618570.3246.30.camel@johannes.berg> <1215618957.3246.35.camel@johannes.berg>
In-Reply-To: <1215618957.3246.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200807091812.55271.IvDoorn@gmail.com> (sfid-20080709_180411_211560_705828AB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> On Wed, 2008-07-09 at 17:49 +0200, Johannes Berg wrote:
>=20
> > Ok so the thing is this: 802.11-2007 7.1.3.4.1 requires that we kee=
p
> > sequence counters per TID (and one for "not QoS"), which we only as=
sign
> > rather late in the wme code. Because even b43 hardware only keeps t=
rack
> > of a single sequence counter, it requires not using that counter fo=
r QoS
> > frames. =EF=BB=BFI suspect no driver except the overly smart iwlwif=
i gets this
> > right.
>=20
> Even if we fix this, we still haven't solved the problem of the beaco=
n
> sequence number. I'm currently favouring putting the burden on the
> driver since only =EF=BB=BFrt2400pci and rt2500pci seem to require it=
 and it's
> fairly simple to keep a race-free per-VIF counter for non-QoS frames =
in
> the driver (you can just do it under the queue lock), but doing it
> race-free in mac80211 will need a bunch of extra locking.
>=20
> I'll put off the fix until after davem's TX MQ rework though.

Ok, that would allow some time for rt2x00 to come up with the
implementation for the rt2400pci and rt2500pci drivers.

And this is extra motivation for a volunteer to look into this,
because when mac80211 removes the seq counting, it is not
just adhoc and master mode that are broken. ;)

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
