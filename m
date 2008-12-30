Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYL3KpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 05:45:22 -0500
Subject: Re: [RFC v2] mac80211: Add 802.11h CSA support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, jouni.malinen@atheros.com
In-Reply-To: <18777.64102.60878.194252@localhost.localdomain> (sfid-20081230_114208_708501_346345E9)
References: <18777.63336.140527.717269@localhost.localdomain>
	 <1230633305.3850.2.camel@johannes>
	 <18777.64102.60878.194252@localhost.localdomain>
	 (sfid-20081230_114208_708501_346345E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LWwfI1o/1HNeo9ckP7vQ"
Date: Tue, 30 Dec 2008 11:45:49 +0100
Message-Id: <1230633949.3850.11.camel@johannes> (sfid-20081230_114526_905459_0B67F52B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LWwfI1o/1HNeo9ckP7vQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-30 at 16:09 +0530, Sujith wrote:
> Johannes Berg wrote:
> > We already have a bss pointer here, would it be better to pass that in,
> > avoid the bss lookup, and do the bss lookup manually in the action fram=
e
> > case, to avoid a double lookup here?
> >=20
>=20
> We don't have a bss pointer in ieee80211_rx_h_action(), where CSA
> action frames are handled too.

Yeah I know, I'm just wondering if it's worth saving the lookup in the
other case by doing the lookup outside of ieee80211_process_chanswitch()
and in ieee80211_rx_h_action()

> > Didn't you want to put this into the workqueue?
>=20
> Calling ieee80211_hw_config() from the timer was problematic since
> drivers might use a mutex, this won't matter.
> But if it makes things clearer, I can add it to the workqueue here too.

But the RX stuff (rx_h_action) is from a tasklet or directly from the
driver, and in the tasklet we can't sleep either, and if we call back
from ieee80211_rx() into rx_h_action into the driver again via config()
the driver might not like it? Or am I totally off base right now?

johannes

--=-LWwfI1o/1HNeo9ckP7vQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWfvaAAoJEKVg1VMiehFYNPMP/1OWodcrKmqjxcKIJsaeBQqr
qPh2PIakxag2w14EGcylzqInerIMsGIiEDroVuyWka46/6NVFE238xzj1itYgyT+
u3uO5gtcjdLntc49XBU0FbCaQ8p/XXkNskyLmn3hjv5Xm1lWZurV+38xqk4V+xg6
QUqo9G2L94h48qggpy8KJCrEvcJ5NRy/VfC2mIj1eYwGEUhdg1KNmVBaIMClx1d7
pM+I+ySmhFdVh5OBYcMk9qgq/GSH7IGjdnaG1czXo7UqtU6VONWLz/81R6Fk+PSs
h+Ax/Reo9y/U2uQ4o4EcjOehX0hwiFXuaC9AxLgoQWmqJUOaiuxeYsSs7uCPRDKG
AxIG4nqhwY5L8PDwZc2gWlR1/AuqOnq3rAUHpfAMOBvAGDyqxop6t09GYPwdcy2t
ba1cHWmBeTOfX7aVmX4rj0blc6wAnywc/529JX8tlf03iad3BhY8jmrHTKBdiExn
IdAj4zdYaHyx5fsBFg0Ep+POFSLrH3Teqm4Ny+7b5cIAj3PSdcsVaGT+lPMQXxLt
+NqROR3r6M687DZUSmt6+0zSBHDAqS7IuAq292IMqiZbvUOJFudfjESOP83dnzIA
wtSf08r5mawdKs5isPvxu1uVzWMidHLxEQCStQPpIyYeDOSw7tyc671dkZkdnYcN
JVeyBbr5ksHA+hRjmH2y
=E6H5
-----END PGP SIGNATURE-----

--=-LWwfI1o/1HNeo9ckP7vQ--

