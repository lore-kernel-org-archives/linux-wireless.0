Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:1714 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbYGIP7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:59:31 -0400
Received: by ug-out-1314.google.com with SMTP id h2so89265ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 08:59:29 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 18:08:18 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091748.49796.IvDoorn@gmail.com> <1215618570.3246.30.camel@johannes.berg>
In-Reply-To: <1215618570.3246.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200807091808.18664.IvDoorn@gmail.com> (sfid-20080709_175933_560094_E18CCB09)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> On Wed, 2008-07-09 at 17:48 +0200, Ivo van Doorn wrote:
> > On Wednesday 09 July 2008, Johannes Berg wrote:
> > > On Wed, 2008-07-09 at 17:36 +0200, Ivo van Doorn wrote:
> > >=20
> > > > True, I have to double check it, but the legacy drivers use per=
-queue locking as well.
> > > > And it would still be possible for the driver to send out frame=
s with a higher
> > > > sequence number before one with a lower number.
> > >=20
> > > The legacy drivers hopefully also implement proper sequence numbe=
ring
> > > per TID. I'll send another mail on the topic.
> >=20
> > Heh, I seriously doubt that. As far as I know it is working using a=
 single
> > counter in the main interface structure. Just the same way it curre=
ntly
> > works in mac80211 (which isn't surprising, since I based the mac802=
11 patch
> > on the legacy driver implementation).
>=20
> Ok so the thing is this: 802.11-2007 7.1.3.4.1 requires that we keep
> sequence counters per TID (and one for "not QoS"), which we only assi=
gn
> rather late in the wme code. Because even b43 hardware only keeps tra=
ck
> of a single sequence counter, it requires not using that counter for =
QoS
> frames. =EF=BB=BFI suspect no driver except the overly smart iwlwifi =
gets this
> right.
>=20
> Do you have flags to turn off hwseq support for the other ralink
> devices?

rt2500usb: Not per-frame, it can only be disabled globally
rt61pci: Both per-frame as well as globally
rt73usb: Both per-frame as well as globally
rt2800pci: Not per-frame, not sure about globally
rt2800usb: Not per-frame, not sure about globally

Note that I don't know if these devices handle the TID and the not QOS =
sequence
counting in the hardware. I'll have to consult the specsheets for that.

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
