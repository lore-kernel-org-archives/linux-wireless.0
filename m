Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:47946 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbZCZSeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 14:34:01 -0400
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: p54spi - mesh mode summary
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@web.de>
Date: Thu, 26 Mar 2009 19:33:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903261933.53998.chunkeey@web.de> (sfid-20090326_193406_602947_A3F3D81F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rmgl... looks like the first mail got lost... so _resend_

On Thursday 26 March 2009 16:15:24 Max Filippov wrote:
> >> 3) Beaconing works, but not the way it should: like MPs don't hear=
 each other. Timestamps never get in sync
> >> and both MPs issue beacon during 0.1s beacon interval.
> >> I've seen it before, with stlc45xx. It shows when LMAC is set up w=
ith LMAC_SETUP_IBSS | LMAC_SETUP_TRANSPARENT flags.
> >> If there's no LMAC_SETUP_TRANSPARENT flag in LMAC setup then times=
tamps get in sync.
> >
> > FYI: The TSF will always reset when a new beacon is submitted to th=
e firmware.
> > The specs talks about that.
>=20
> I'd like to make it clear: there are timestamp field in the beacon an=
d
> timestamp associated with the received packet. These two do not
> correlate. First gets reset at beacon submission (and why firmware
> wouldn't pick up timestamp from the submitted beacon?). The second
> only gets reset on firmware reset. And it seems to me that there's no
> way to find out, what the current value of beacon timestamp is. TSF
> reported in p54_rx_data is the second.

because the hardware has at least 3 timers ;)
- One for the _mactime_ (as in rx_status.mactime)
  (of course, we can always drop RX_FLAG_TSFT flag.)
- the second one for beacon - (some firmware will fire a trap for every
  beacon they send P54_TRAP_BEACON_TX )
- and one is for the user. (which we don't need...)

> And if so, how timestamp syncing is expected to work in the following=
 case:
>=20
> <7>[  353.579189] RX beacon SA=3D00:1d:6e:9b:ee:6d
> BSSID=3D7e:2e:03:09:31:25 TSF=3D0x4aaa81 BCN=3D0x618f1f6 diff=3D-9740=
4789
> @1513
> <7>[  353.579250] wlan0: beacon TSF higher than local TSF - IBSS merg=
e
> with BSSID 7e:2e:03:09:31:25
>=20
> After which stack submit new beacon which we send to LMAC, effectivel=
y
> resetting timestamp in our beacon and not affecting TSF that we would
> report on the next received frame.
I know... p54 is does not really follow IBSS standard, but TSF sync is =
not a
"MUST" for IBSS.
http://wireless.kernel.org/en/developers/Documentation/mac80211/API

> I see constant beacon resubmission cycle. How does it work on pci/usb=
 p54?
firmware does it... all we need is to submit a beacon template. The fir=
mware
knows how to extract everything it needs (e.g intervals/dtim etc.)
out of the frame itself...

> >> - when LMAC was set up with LMAC_SETUP_TRANSPARENT flag firmware s=
eem to truncate last 2 bytes of the packet
> >> =A0 that it reports.
> > Heh, that's also a ISL3887 (USB 2nd gen) bug... But PCI devices are=
 not affected.
> > The reason "why" has probably to do with the firmware's frame align=
ment code.
> > Unfortunately the firmware for (ISL3887 and SPI) is rounding "down"=
 to 4 bytes instead of up...
> > So the FCS will be clipped... But fortunately the firmware set a bi=
t in the header that tells
> > us whenever the frames was corrupted or not (P54_HDR_FLAG_DATA_IN_F=
CS_GOOD).
> Thank you for the explanation, it made me feel much better (:
>=20
> > what happens if you change p54spi_rx the following way:?
> Actually, I did this kind of thing. And it works this way.
> But I considered it a major hack, as noone acknowledged that there's =
a
> firmware problem:
>=20
> https://garage.maemo.org/pipermail/stlc45xx-devel/2009-January/000126=
=2Ehtml
>=20
> But if there's real problem in firmware, I'd consider it mere
> workaround and put it back.
>=20
yes please do... And don't worry the frame which we'll pass to mac80211
will always have the correct length, even when the extra padding wasn't=
 used.

Regards,
	Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
