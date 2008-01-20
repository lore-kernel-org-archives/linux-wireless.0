Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.hammerl-bau.at ([213.235.197.82]:52773 "EHLO
	ns2.hammerl-bau.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbYATGP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 01:15:27 -0500
Message-ID: <46274.61.115.136.26.1200807429.squirrel@webmail.einfach.org> (sfid-20080120_061536_875137_3F7005F7)
Date: Sun, 20 Jan 2008 15:37:09 +1000 (EST)
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: always extend rx timestamp
     with tsf
From: "bruno randolf" <br1@einfach.org>
To: "Derek Smithies" <derek@indranet.co.nz>
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	jirislaby@gmail.com, "Michael Wu" <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 January 2008 11:12:11 Derek Smithies wrote:
> On Sat, 19 Jan 2008, Luis R. Rodriguez wrote:
> > On Jan 18, 2008 7:50 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* always extend the mac timestam=
p, since this
> > > information is + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* also needed for=
 proper IBSS merging.
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* XXX: it might be too late to d=
o it here, since
> > > rs_tstamp is + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 15bit only. that =
means TSF extension
> > > has to be done within + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 32.768us=
ec =3D 32ms. it might be
> > > necessary to move this to the + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
interrupt handler,
> > > like it is done in madwifi. + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> >
> > I'm trying to understand this a bit more and am confused. The TSF
> > timer is based on 1MHz clock so it has a resolution of 1 microsecon=
d
> > (us). For 15 bits that would mean 32768 us so don't you mean it sho=
uld
> > be done within 32.768 ms instead of usec (or us)?
>
> Hi,
> =A0it is a typo.

it's just a different way to use a "." to denote 1000. americans might
write 32,768usec, im not sure, different styles worldwide... what i mea=
n
is 32768us equals about 32ms. i'll remove that dot to make it unambigou=
s.

> You are correct. It should be done within 32.768 ms. On a high end la=
ptop,
> it is almost guaranteed that the bottom half will process the packet
> within 32 ms. However, on an embedded box (low spec cpu) that has a
> temporarily high load, 32 ms is a short time, and the timestamp may h=
ave
> wrapped around. this is unfortunate.

i know that this might happen, and that's why i included this comment. =
i
was just too lazy to make the same act as is done in madwifi (lopping t=
hru
all rx descriptors in the interrupt handler). the current code is
sufficient for IBSS testing right now.

also even if we move TSF extension into the interrupt handler this will
not help in all cases. there are situations in IBSS mode - when a HW me=
rge
(=3D automatic HW TSF update upon receipt of a beacon with a higherr TS=
=46 and
the same BSSID) happens - where the rx timestamp is apparently based on
the old TSF, before the HW TSF is updated. in that case we cannot exten=
d
the timestamp in any meaningful way. i'm not sure how we should handle
this.

> On Sat, 19 Jan 2008, Luis R. Rodriguez wrote:
> Right now we only use mactime and even RX_FLAG_TSFT within mac80211 i=
n
> rx.c on ieee80211_rx_monitor() for IEEE80211_RADIOTAP_TSFT so right
> now these changes would seem to do nothing. Should we be using this
> for something else -- if so what is it?

see my "[PATCH] mac80211: enable IBSS merging". it is used there to dec=
ide
wether we have to merge IBSS on receipt of a beacon. strictly speaking =
it
would be sufficient to extend the rxstamp only for beacons and in monit=
or
mode, but i thought checking for these cases is more overhead, so why n=
ot
extend TSF all the time...

bruno

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
