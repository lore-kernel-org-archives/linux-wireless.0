Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZAINGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 08:06:54 -0500
Subject: RE: multicast traffic and ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4845A77DAF07@CHEXMB-01.global.atheros.com>
References: <1231346161.3545.52.camel@johannes>
	 <44EE5C37ADC36343B0625A05DD408C4845A77DAF07@CHEXMB-01.global.atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/JBQYAw9rqvwgM7+WyVp"
Date: Fri, 09 Jan 2009 14:07:26 +0100
Message-Id: <1231506446.3703.18.camel@johannes> (sfid-20090109_140659_184348_BEBC4A90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/JBQYAw9rqvwgM7+WyVp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 18:26 +0530, Vivek Natarajan wrote:
> Johannes Berg wrote:
>=20
> > I'm inclined to ask you to remove that multicast checking from mac80211
> > and do it closer to the hardware, and simply require from the
> > driver/hardware that mac80211 needs not do anything for multicast
> > traffic. Mostly because I'm thinking that once we start relying on the
> > software implementation in mac80211 the delay may be too large.
>=20
> I'm curious to know how this is implemented in other vendor drivers becau=
se
> beacon processing is shared between the hw and sw. mc bit is processed in
> the hw whereas tim bit and timestamp update need sw's help.

That seems to be the case at least for p54 (stlc45xx). Not really sure
about others.

> Is the mc bit
> checking done only on enabling power save? if set and mc packets are rece=
ived,
> how does it automatically go back to sleep and wouldn't there be any conf=
lict
> between mac80211 and the hw regarding power state since mac80211 is not a=
ware
> of the mc bit induced state change?

I don't think there would be a conflict. mac80211's CONF_PS is always
only "go to sleep if you can", so receiving multicast traffic would
obviously imply not being able to go to sleep. When mac80211 then unsets
the CONF_PS flag you'd just not go back to sleep after being awake for
MC traffic.

johannes

--=-/JBQYAw9rqvwgM7+WyVp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZ0wLAAoJEKVg1VMiehFY+/IQALnJCD3L5ON6UFKpTdotRfM4
XiahPm9ib40yUUcM5ZRU2ERRDhWvg4rhmsP8Ov5/TaUk1V18Ix2267uONNAqUwPx
n9B8YsBZvpDKSZNWgz/srOD48xqvZ2bqpdTZ+dL5dzAjF1eQhrD7TbU7idQCVFUS
yTzbq5pGBugQ06xyx8O/rbuH2T/4vIWwBGe71UZwckkw/54+9uU1iqym/2OQXof1
qq6KhpLgxCFOxNCTAfX6R9jnkNFJilQzp/WF7935TKGGMSBCaugZC/Xf8lVJ/M/F
tibfd7fCMKJsAJuxCp3Lm6t1/S6NeAulm8lBIj11K11cCmb1D68luXzVVYLzR6Fe
IC+CUPl/lKf6gfxzxittAsA59V4+st2WYsQkfHDmcBR9HKGZUfNcUQtP0kmgW1OT
7e7CNPdg5Wp3gFue2GKcqc3H8fMMndHFXSq6jkdFCFNdj/Bym7yDl81oJlCRto62
I91poCq4qcikbJ2PsNw0GYTrkLQcmcZLCwzJzsgH6qXT8HsYFb7Mm6z7I+MVstsJ
SqooauZP6VW5KYjEWps3rwBmTzTP3Ua/rFFMT4aKZs4JKGddC7a8R0jAV/FjMOq0
AsSYjcA7WzCArBiTt5NXSvx823F+hLOONTFxfzxLJJKTH3CSWL04MSNuAUhdIN6u
hsJ0kfKG0rxSeGC4xS/Q
=lVsZ
-----END PGP SIGNATURE-----

--=-/JBQYAw9rqvwgM7+WyVp--

