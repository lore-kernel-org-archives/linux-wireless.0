Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYAQPqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:46:50 -0500
Subject: Re: led support in mac80211 and drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Tomas Carnecky <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20080116200126.GA3164@tuxdriver.com> (sfid-20080116_202428_768975_7B04F6BA)
References: <478DF297.9020904@dbservice.com>
	 <1ba2fa240801160832g611d5763gcb3d681353019d4f@mail.gmail.com>
	 <478E465A.2030003@dbservice.com>
	 <1ba2fa240801161038t235f9ae4m3b1f7e1963b592ef@mail.gmail.com>
	 <20080116200126.GA3164@tuxdriver.com>
	 (sfid-20080116_202428_768975_7B04F6BA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AJDnj0tpL2KnQN01mK6P"
Date: Thu, 17 Jan 2008 16:46:22 +0100
Message-Id: <1200584782.8007.59.camel@johannes.berg> (sfid-20080117_154654_325848_149BB2FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AJDnj0tpL2KnQN01mK6P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > > So what is needed for led implementation are 3 decision chain
> > > >  - Activity Trigger (RX, TX, Association, Radio State/RF Kill)

mac80211 exports multiple triggers already and could be amended to those
that are currently missing.

> > > >  - Behavior Decision -  What is done on each trigger
> > > >     - Behavior is easy to model - ON, OFF, BLINK(pattern)

BLINK(pattern) is currently not defined. Actually, especially since you
say later:

> > > > Actually the major problem I have currently with mac80211 trigger
> > > > implementation RX/TX trigger since Intel's led doesn't have to be
> > > > triggered ON/OFF on each packet, led is capable of blinking itself.=
,

I'm wondering if this shouldn't simply be a driver decision and mac80211
exports an RXon LED that is always "on" for as long as receive is
running (whatever that means, please specify!)

Or you need to define blink patterns with the core LED framework.

> > > >  - Mapping to what led is this behavior mapped

That's trivially specified in sysfs. b43 (since it was mentioned
already) has some special logic to set up defaults coming from EEPROM.

> > > >     - One behavior might be mapped to single led. Then we need to k=
now
> > > > what trigger take precedences.

That (multiple behaviours on a single LED) is impossible in the current
LED framework.

> > > I thought about having an 'ieee80211_activity_listener' that could
> > > subscribe to activity events of a ieee80211_hw device. One single
> > > callback that would be called when there's activity or if the state o=
f
> > > the device has changed. Maybe something like this:
> > >
> > > int (*callback)(... *hw, u8 state, u8 type);
> > >
> > > where 'state' would be a bitmap of scanning/associated/etc and type t=
he
> > > 'type' of activity (transmitting/receiving a frame). The callback the=
n
> > > would decide which leds to activate and how (blinking or not etc). Do=
es
> > > that sound better? At least it would be better than having to registe=
r
> > > three leds in each low-level driver ;)

No, that sounds like a bad idea. We actually want the flexibility here,
I could for example use the front LED on my powerbook as a wireless
association LED if I wanted. We want to use the LED framework and if
that means three LEDs in your driver then so be it.

johannes

--=-AJDnj0tpL2KnQN01mK6P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR494TKVg1VMiehFYAQJ/bg/8DRHAxvb5TwMT6RyJlGe1bEGBd3zhd2+7
KHPOcT384dBpnxihdTtKckX/YhGe3EQUgGCGayXQoiaJgXkCZoCEVEnQs59sFuPr
XTTUrLp1x+3P50D1F7yUmur/R7gL4asRCZX7IbGqzHJYyP7YG5c8HfzeeKozN6VL
8diEddw0tG+hIhWeqvTGsBwiErwALxD7ryfQpHKTBbq4Keeg25/SeiehgnsBXnEP
cUUbIyD43agT1x8eRe9KeNuLVSutTKkGQ3wnfh0iSni/sDDdpbKokrtI73UjN2L1
zPId+tUgwwVAP2J8cpTUD3Bsmpva52y9UCV3HnxSAjqV9y1Vh66zdNcUfB/v4VId
JzQEyDHHKVHJpJQetRfwHyzl2XqLJ/4+7M5AYxIpeOhD6AIlqsSdwqWcTnQQj5Vb
2l4/+x3jJ9Th5mnext2zh0a2HbkGNly56CNA2tAhUCtK23X8f34bSDHznrjeHLQC
i6OokQ5s7+rzKn80kBbYHRl2JYF4TXoYS1iyXpEhgxaaPt871+4fRb4ghm2emlzb
+9dFSJrLuyTUxrCqx3g28bHfMT3hEZrJcc1va9XZhLPyGD5nqWhXyF3PkjlUwchW
8xpoEhPK1RgIpaz0QI4PQGBLBasVMolyIc1acvf4MntThtm/8hJEvN+IKRLSrk9F
tHC/8ZbjacE=
=Mqde
-----END PGP SIGNATURE-----

--=-AJDnj0tpL2KnQN01mK6P--

