Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35743 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbZCXKj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 06:39:57 -0400
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Mircea Gherzan <mgherzan@gmail.com>
In-Reply-To: <200903241115.29868.helmut.schaa@gmail.com>
References: <20090320215705.GE8120@tesla>
	 <200903211243.25380.helmut.schaa@gmail.com>
	 <200903241006.43512.hs4233@mail.mn-solutions.de>
	 <200903241115.29868.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 24 Mar 2009 06:37:44 -0400
Message-Id: <1237891064.25734.14.camel@localhost.localdomain> (sfid-20090324_114001_724423_EF84B076)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-24 at 11:15 +0100, Helmut Schaa wrote:
> Am Dienstag, 24. M=C3=A4rz 2009 schrieb Holger Schurig:
> > > Basically roaming can be divided into 3 steps:
> > > 1) detect if it is time to roam
> > > 2) scan for better APs
> > > 3) associate with the new AP
> > >
> > > Step 1 is the most difficult one here, 2 only needs some
> > > tweaking and 3 should work as it is currently.
> >=20
> > For one the disadvantage you mentioned I have some ideas:
> >=20
> > > - The signal strength values on different cards are not
> > > comparable. So the threshold value has to be different for all
> > > cards.
> >=20
> > First thing is to make the drivers report similar values in=20
> > similar situations. What would be helful for user-space as well,=20
> > so I think this should eventually be tackled independend of=20
> > roaming anyway.
>=20
> Yep, that would help a lot (if it is achievable).
>=20
> > But consider for now the case where two different cards provide=20
> > values that are (absolutely) quite different. If we look at=20
> > signal differences, this wouldn't harm us that much. Consider=20
> > this bss entries:
> >=20
> > bss 1: 45
> > bss 2: 42   <- also the current one
> > bss 3: 10
> >=20
> > In this case the difference from our BSS to the best matching one=20
> > is only 3. If we have some heuristic that says "Only roam if you=20
> > find an AP which is 6 points betters" we wouldn't roam. If=20
> > another card would report for the same situation
> >=20
> > bss 1: 54
> > bss 2: 50   <- also the current one
> > bss 3: 12
> >=20
> > (that's the same as above, but multiplied by 1.2) the outcome=20
> > would be the same.
>=20
> Got your point. My concern was not about the AP selection ;). More th=
at if
> the values are hardly comparable (like card A returns a value of 40 w=
hile
> card B returns a value of 50 for the same AP) it is difficult to find=
 a good
> threshold value when to trigger a scan.
>=20
> > > - Ping-pong effect if you sit between two APs both are in
> > > range but with a signal strength around the threshold.
> >=20
> > It's my understanding that a good threshold would also prevent=20
> > ping-pongs ?!?
>=20
> Hmm, quick example: AP1 - STA - AP2
>=20
> We cannot consider the signal strength as constant as it varies over =
time
> even when neither the STA nor the AP are moving. Assume a threshold v=
alue
> of t=3D40. Furthermore, the signal strength of AP1 and AP2 might alte=
r between
> 35-50 which means we have an average signal strength of 42,5 > t. Nev=
ertheless
> that would result in ping-pongs between AP1 and AP2 because the signa=
l might
> drop below t on both APs, while it would be better to stick to one AP=
 as the
> signal is already quite bad (but still good enough to do some communi=
cation).
>=20
> > > - Unnecessary scanning if the signal strength is below the
> > > threshold but no better AP is in range will further reduce the
> > > connection quality and increase power consumption.
> >=20
> > Either you know that your device is moving, than you want this=20
> > scanning, because soon the scanning is no longer unnecessary.=20
> > Even if at the current position (corner of the=20
> > street/warehouse/whatever) you "scan" in vein, some minutes=20
> > later the situation has changed.
> >=20
> > Or you know that you're in hot-spot mode and then you attach to=20
> > an AP and stay with it. Then you don't need the whole roaming=20
> > sermon at all --- this is BTW the reason why mac80211 is,=20
> > despite it's awful roaming, such a success so for.
> >=20
> > What I meant is that this is a policy decision (or trade-off=20
> > decision), that the user should be able to influence.
>=20
> Fully agreed. It would really make sense to turn on roaming on a per
> network base (maybe in wpa_supplicant's network blocks for example).
>=20
> > For one of my devices, I made lots of local changes:
> >=20
> > - I provide a list of channels for the driver to scan. In most
> >   warehouses only channels 1, 6, 11 are used. Then there's no
> >   reason for the driver to scan at channel 2,3,4 etc. If user-
> >   space didn't provide such a list, the driver has to scan on
> >   all frequencies, so this is merely an optimization. But an
> >   important one, helps tremenduously.
> >=20
> > - I let the driver scan one frequency every n time units, e.g.
> >   every second one channel. This makes the driver visit all
> >   three channels during 3 seconds.
> >=20
> > - If I would get all beacons of the current channel, AND if the
> >   ESSID is not hidden, I would only scan for the channels I'm
> >   not on. Because for my current channels I have the signal
> >   strengths of all channels anyway and know also ESSID an IEs
> >   to decide if I can roam or not, should the need arise.
> >=20
> >=20
> >=20
> > > b) Number of consecutivley missed beacons below threshold
> >=20
> > This tends to roam only when it is too late, e.g. when the=20
> > connection is nearly breaking. But you wrote this by=20
> > yourself :-)
> >=20
> > In my case, I'm doing a full scan if this happens, to protect=20
> > about bad channel list provisioning.
> >=20
> >=20
> >=20
> >=20
> > > c) Only scan for new APs if the environment changes (e.g. we
> > > are moving or the AP is moving etc.)
> >=20
> > You very seldom know about this, e.g. GPS is mostly useless=20
> > inside big buildings.
> >=20
> > You can however record "Okay, when I associated to the AP my=20
> > signal strength was 56. If it drops below 50, I'll look if I=20
> > find something better".
> >=20
> > > I already did some research on c) and it looks very promising
> > > but the topic is quite complex and needs more theoretical
> > > research first.
> >=20
> > If you're serious about that then mac80211 should only get the=20
> > infrastructure necessary so that we can write different roaming=20
> > implementations, like we now have different rate selection=20
> > implementations.
>=20
> Yes, that's a good idea. There are some more scenarios where differen=
t
> roaming algorithms might make sense. However, I'm still not sure wher=
e
> the roaming decision should be made (and thus where the algorithm sho=
uld
> be implemented). In user space (wpa_supplicant) or in mac80211. Havin=
g
> it in user space would allow non-mac80211-drivers to benefit too but =
the
> driver would have to provide the necessary information.
>=20
> > > Scanning for new APs should not be started from within the
> > > driver or mac80211. Instead wpa_supplicant should care about
> > > that. Why? Just because the supplicant might have more
> > > information (maybe provided by NM) about the used network. For
> > > example a typical multi-AP network won't use all channels from
> > > within the bg-band due to signal interferences. Instead, all
> > > APs will be located on non-overlapping channels. Let's say 1,6
> > > and 11. Hence, if the supplicant tiggers a scan it will just
> > > leave all channels !=3D 1,6,11 out of the scan request and the
> > > scan will take a shorter amount of time, which in turn speeds
> > > up the handoff delay.
> >=20
> > That's similar to my local, debugfs-based channel list hack, but=20
> > better :-)
> >=20
> > But please make this be able to run from wpa_supplicant alone,=20
> > don't force NM into the picture. Many embedded developers will=20
> > say "thank you" for this. :-)
>=20
> Also agreed. The solution should be usable without NM too but I thoug=
ht
> more about the degree of automatism here. If plain wpa_supplicant is =
used
> the wpa_supplicant config should simply contain the channel list stat=
ically
> configured while in the NM case the channel list could be created by =
NM
> based on historical data.

Most wifi-related stuff should be implemented in the supplicant anyway.
Shouldn't need NM for that.  Think of NM more of an overall network
policy manager and configuration storage manager instead of a wifi
control daemon.  NM pushes configuration to the supplicant, and tells
the supplicant "go!".  I don't have any particular objection to letting
the supplicant make the roaming decisions (or even pushing multiple
network blocks down to the supplicant from NM) as long as the desired
behavior is achieved.

Dan

> > > extend wpa_supplicant's network blocks to allow the
> > > specification of preferred channels ("channels=3D1,6,11"). This
> > > value could be provided by NM which gathered that information
> > > either from the user or through monitoring.
> >=20
> > Or the value should simply be recorded in wpa_supplicant's config=20
> > file. No need no stinkin' NM !  :-)
>=20
> Adding a network block through dbus or through the config file is pre=
tty
> much the same. So, yes, this should of course also work with a plain=20
> supplicant config.
>=20
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
