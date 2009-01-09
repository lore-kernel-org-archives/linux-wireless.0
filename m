Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZAIL5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 06:57:07 -0500
Subject: RE: multicast traffic and ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4845A77DAF05@CHEXMB-01.global.atheros.com>
References: <1231346161.3545.52.camel@johannes>
	 <44EE5C37ADC36343B0625A05DD408C4845A77DAF05@CHEXMB-01.global.atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uEmIcBks0Mkxx19BK/J3"
Date: Fri, 09 Jan 2009 12:57:37 +0100
Message-Id: <1231502257.3703.9.camel@johannes> (sfid-20090109_125712_125458_1E49E9AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uEmIcBks0Mkxx19BK/J3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 17:20 +0530, Vivek Natarajan wrote:

> There are two options in atheros drivers. One is hardware beacon processi=
ng
> and the other is sw beacon processing. For some reason, sw beacon process=
ing
> is enabled by default, the performance is as expected and it has been wor=
king fine
> for Windows implementation.
>=20
> Some functions related to power save and beacon are beacon timestamp upda=
te,
> verify tim bit and verify mc bit. The beacon timers have to be programmed=
 correctly
> to wake up for every beacon and process it for tim.  If the timer is slig=
htly
> out of sync, we my fail to receive the beacon.
>=20
> The alternative is sw beacon processing using TIM_TIMER interrupt. This i=
s a timer
> which runs in the hw while majority of the hw is asleep. This generates a=
n interrupt
> for every beacon listen interval to wake up the chip and listen to beacon=
. We do not
> go back to sleep unless we receive a beacon. Since there is no dependency=
 on the
> higher layers to update the beacon/sleep timers,  this implementation wor=
ks fine in any
> corner case. Hence, there is a need to process multicast bit in the softw=
are itself.

But will the software actually be fast enough? I'm looking at the code,
and it'll defer processing the beacon to a workqueue, and only then wake
up the hardware. That means there's some latency, wouldn't we miss some
multicast frames then?

I'm inclined to ask you to remove that multicast checking from mac80211
and do it closer to the hardware, and simply require from the
driver/hardware that mac80211 needs not do anything for multicast
traffic. Mostly because I'm thinking that once we start relying on the
software implementation in mac80211 the delay may be too large.

Thoughts?

johannes

--=-uEmIcBks0Mkxx19BK/J3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZzuuAAoJEKVg1VMiehFYRl0QAK+QmWUO3JbLdH48WnoSFIZA
O6qpOmR8A4Cj+4okSRmKkEP0dlFQ2XG5WUsskY/Xr1ZxvdAqCabue+29r6k0xXIW
N9cgCrBq8Biu5JSo/+JPyCQtTJ/Fd5Q9ae/kfLF57ZaMo4yYsKZ4BCPpwtt8NRLd
d/mm1iRSj3TbfGfQArfBGNjOFgOR92R8bwDHcrnY/JtO6urp/+CjwFuI036xAcyZ
pFnavJ4I+xmG1eW7c0ybp1pnYApr31K+iLwm8CwDxJbU7F8xzbgT7JvDX0V2nrbq
A4K/U6jeaVEUznY8SYey7az+XqGXBtL+yu/n9o5/XQb1ibnVmSUotmb2Hf0tHmx+
tVKLK8M0UV7Azxzw1LQmvh7ZrSqzhuZyXjc5edfUwnr7nnxLXSYYqfv6UmN1p0j/
De8MSHjgnYAG1oSxE3X8mJHEIbnlxvOfWeuLMe+XpUMQ+TI5cUPlDQWxb/Pj6abO
Jyvt+yFClh+2pgBJvlqsxoWJNhHZYuxM2jbr7aXkMHjtqrEdRK8CENg8FblJkbT6
IJ/oRq0NYzCEtn2ANQ0i7o6tkR93VNoH9sesnczCvSYgPm7UxUX1mWBaUvNHjd/A
NkVGmpR8CXd6zGZJLSW7N0APznNRKZMb0rwaW/XdltnLsr2UaAgxUP5ng5ci60Hd
dJIbS2oTyDrgBagFIl/Y
=tdMj
-----END PGP SIGNATURE-----

--=-uEmIcBks0Mkxx19BK/J3--

