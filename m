Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbXLYKyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 05:54:40 -0500
Subject: Re: ath5k oops (recent regression, I think)
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: Andrew Lutomirski <luto@myrealbox.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200712251804.13693.bruno@thinktube.com>
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
	 <200712251804.13693.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NGTQMeYGODRgtYeaMDWn"
Date: Tue, 25 Dec 2007 11:54:24 +0100
Message-Id: <1198580064.4103.63.camel@johannes.berg> (sfid-20071225_105448_459405_4E0A5390)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NGTQMeYGODRgtYeaMDWn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm absolutely unable to read the stack trace you pasted, I just don't
know how to read x86 stack traces as they're usually badly mangled.

> seems ath5k likes to write some rate registers before vif is set up. i us=
ed=20
> the following as a stopgap fix. johannes, do you have any advice how to=20
> properly fix that?

> +       if (sc->vif =3D=3D NULL) {
> +               printk("*** sc->vif NULL\n");
> +               return;
> +       }
> +

Superficially, this fix looks correct if this function
(ath5k_hw_write_rate_duration) is called before a virtual interface is
brought up or down. I didn't think that would happen so I didn't protect
in mac80211 against it, ieee80211_generic_frame_duration() would have
returned 0 with the original behaviour.

Hence, if you want to restore the original behaviour, do something like

tx_time =3D 0;
if (sc->vif)
	tx_time =3D ieee80211_generic_frame_duration(....)

instead at the spot where ieee80211_generic_frame_duration() is used.

I don't think that's correct though and I have no idea why ath5k needs a
frame duration before it has an interface assigned (since it will then
never send a frame), but that's something for the ath5k people to figure
out.

johannes

--=-NGTQMeYGODRgtYeaMDWn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3DhX6Vg1VMiehFYAQJjWg//WQ5Ryqa0MfVZ+XSD13wybn0wWRdoqCn7
DNe0nQ8SDfe8YWbHdziJwhf5rY7n7SSSZHDzYrOTnHQeBhDi/SNiPMz6FKrpQXch
3p4vNUFWvt+PJdz8tyowXImzAceWOUuW2FJxSuen+iCFJLZenL60Ge80OttHATiM
mbtkxhGyQ/daXMyLvlEPs6ZORtl5QR6GFn719/4otGCiz4V8/fvIK4V4zkGWOIyK
n+S5C6hXmRPu9tMrnOUAJNiMIU6pgN6wONtGmkB9H9I2aLH2pSGt+lyTzkryiar4
88NVqJvNAa9S9akejfq4yilzLPEsi4cwgtxSYKhnjb8UvJ2PwK/2tMxHEJzVvQAU
HLPTfDZ5vF/i3TVn0TMAh02eVAioVjZ9Ib54Ul236+Uy1szkP9RpmhRDQwVQ6ASM
yXdKH8F/cn0ImcON90AuWUiwjdm4/8th+/UdBYz7b9SI0OM80I4zLaypp6KYYsfq
61OjEdM8mnGE1GIEFSUxIvvcuAKKJLrNP6SJNW2MEBddtK1Ppx9BfH96pCHOK9iQ
BWqKQN8o2AfWyGO12MFAPITSfj1DzYqqRWdWKQOIw316cgAjk1vTjo99+3X4fHz5
W4vmPNSbhoZXXePyMCuN380+pTsexWTfAyyFr15kl+Ywlo4tRHzlE8udVVKQ62pu
VM8jcIP3Jpw=
=zHWU
-----END PGP SIGNATURE-----

--=-NGTQMeYGODRgtYeaMDWn--

