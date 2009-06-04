Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZFDQ5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 12:57:22 -0400
Subject: Re: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A27FB8D.5000605@lwfinger.net>
References: <1244015729.7176.28.camel@johannes.local>
	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>
	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>
	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>
	 <4A27F649.9080203@lwfinger.net> <1244133087.22576.86.camel@johannes.local>
	 <4A27FB8D.5000605@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oYlVyOoJ0aaQXmeHM9Ge"
Date: Thu, 04 Jun 2009 18:57:15 +0200
Message-Id: <1244134635.22576.88.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oYlVyOoJ0aaQXmeHM9Ge
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 11:51 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >=20
> > Would you do the same test with the uevents w/o the patch? I suspect
> > that you won't get the event at the right spot.
>=20
> Yes. Without the patch and the interface UP or DOWN,
> /sys/class/rfkill/rfkill0/uevent always shows RFKILL_STATE=3D1, no
> matter what state the switch is in.

Right. So we already have the problem in the old code, we just don't
notice much... can we take the core up, check, and put it down again? Or
I think it's GPIOs, can we query those via chipcommon when the 802.11
core is down?

> FYI, my switch is a slider with off to the left and on to the right.

ok.

johannes

--=-oYlVyOoJ0aaQXmeHM9Ge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ/zoAAoJEODzc/N7+QmaapsQAJKHOqUHLEnyczGKMYq6z9hT
fgkJrNTzp7K4UvXfKIWHcdHYjp+9+GMpK0hNVSS05qC7km/+gp+puY7V9vs8phPE
8zg4caQxMi17pMh6bbOq3OY8vZcjBgkeIIG0vXml1cnPicoCmTPdIJzlo1kV0oBD
7an8ojoBfzve5c1m+Ci2b3CVbmqk2wevRXqfMpiAULRGhCu7M0NWkjv4U6kJ6Fa2
7l8+CYb3B1dXdIxsB6/EpVSKYwK788isSHPQOBckE+/rXDUSi5zPaaKuwkuyPIdY
fe+YaOm1ekkemaCYZ4JF4FZU76Cm/uVpnBk4I0BEqjlZiuuyQR//3Cr/IDA4Vdgs
gv/8QnWaMzRuf22YegeYiT7FVBabEQswaqg+AnV1tqT3XjmkFRmETo+/VOZ/dYo6
vjcMsN1h3FIzDmbpknpqkIvvtBwLflJynvgc/PyZ2e7ESHCldwn4NxNbxpsaesOZ
Ewyy6KanE7EOiQNp7/darIyFneBaEfaWO83J1hvBXzbH3wfKbNw6tzyi3S2D22Xj
SSxNqqc1MbsWEZqdNsJlnPgqCxz7krvQMw94Y/lwpkMHrH90N2WoaRkOOkytpfSP
1vMk8il9WWR75hIz89gYZF5nxlh437sERlxbmMvNnUpuLKo12UywSt3Gz23qcFPB
hhgO21BXdNS2yeuBerta
=uWOU
-----END PGP SIGNATURE-----

--=-oYlVyOoJ0aaQXmeHM9Ge--

