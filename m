Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYHDQhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 12:37:36 -0400
Subject: Re: [RFC] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <6064CD72-8B4A-4F23-BCFA-4D656729E60D@holtmann.org>
References: <1217853236.4721.32.camel@johannes.berg>
	 <99AFB2EC-AECE-419A-B014-8391E45DF6C4@holtmann.org>
	 <1217866765.1299.9.camel@johannes.berg>
	 <6064CD72-8B4A-4F23-BCFA-4D656729E60D@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NLlH4AYJfYl0OfKjDV0U"
Date: Mon, 04 Aug 2008 18:36:55 +0200
Message-Id: <1217867815.1299.13.camel@johannes.berg> (sfid-20080804_183740_875620_7179922F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NLlH4AYJfYl0OfKjDV0U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 18:27 +0200, Marcel Holtmann wrote:

> >>> +	.suspend =3D wiphy_suspend,
> >>> +	.resume =3D wiphy_resume,
> >>> };
> >>
> >> this needs to be wrapped into CONFIG_PM, because otherwise the build
> >> will fail when CONFIG_PM is not enabled.
> >
> > I thought so too, but then I looked at include/linux/device.h
>=20
> when did this got changed?=20

No idea.

> And more to the point, why nobody bothered =20
> to remove all the CONFIG_PM and CONFIG_HOTPLUG ifdefs splattered =20
> around the kernel.=20

Most of them are for struct device_driver and not struct class though,
so I haven't checked.

> It must be part of Greg's changes to remove class =20
> devices. I am not sure this is all the right approach since =20
> potentially it blots the kernel.

I suppose drivers still have a choice. I just decided that this was so
little code it didn't matter.

The more interesting question I guess is: are we now required to have
these callbacks even if CONFIG_PM(_SLEEP) is not defined? I'm not all
that interested in trying to find answers right now though.

> This would also means that the CONFIG_HOTPLUG for dev_uevent can go =20
> away.

Indeed, it could.

johannes

--=-NLlH4AYJfYl0OfKjDV0U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlzAjAAoJEKVg1VMiehFYEj4P/jnwelj4KqINIScxfFwWUqox
+xqixjiHjl/JAEZvK87uXzVKDXDGvkzSyeDXmwZElrWIFND8otSSFonoqYLfW3OX
ZL0weYgh+0yyQS0aYs+CSQi9xCBK40xVNrwQQFHlN7irzEwLGolekH08uO64lXPe
GsTMNXXJreho0zqKj8tcoHS9IznLQvSg/IGKR+hgAFzdG50uP70zY36QFpRxeUX5
voeFCIQby3l0C4cce/c0+9PfTsYpabq+Rmt1qMqgOWWjMpdx5Bq/xNg5tmIR9yPM
116SNdPF3ERXXi5cAW4h9vTudw/R6X9LoRl6exI/vZX6d5pOuzWxCEAP3V+B8o5g
t++aMFcwfwqp3fKpyfrw1eicUV2uxRIC9sqZZpTnprbM5WHfD3KjAs1jrqwQJjEi
+iBGSY1aZRMKk55pkqjr3bcSEaNn1ApnQ3Sj6GuONkKVvg7/LS0cwWH3g7dvgjNA
yq4FM5hugO3t/43l1K+zjHVbwVHisDjZnbMP3i7aboCtpRrbaEVZ6D75F5UwZKBP
4axPHqVPReu+069tZd/NA5ssfra7ckJnRV93CkLJUclTJvlfKLQRxLasPDzSme7N
DdsTVjeXn4A9w9HRjzsKBcNU40+Se7XiqKr6tr+F3z4lNyRoiRFvV+X+F4jh1EyH
oukxpTCCTez5ijkUDEvk
=l8VJ
-----END PGP SIGNATURE-----

--=-NLlH4AYJfYl0OfKjDV0U--

