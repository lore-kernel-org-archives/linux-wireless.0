Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:27662 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2HHV7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 17:59:08 -0400
Date: Wed, 8 Aug 2012 23:58:59 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: =?utf-8?B?Tmljb2zDoXMgRWNow6FuaXo=?= <nicoechaniz@codigosur.org>,
	Guido Iribarren <guidoiribarren@buenosaireslibre.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc 1mbps in IBSS mode
Message-ID: <20120808215858.GB6767@ritirata.org> (sfid-20120808_235913_168769_BFA902C7)
References: <4FD56DCA.1080200@codigosur.org>
 <CAJ-VmomzoXV8YBdiS_2nkzVagBupX3Be-Dmboxotwy9s3h3r7w@mail.gmail.com>
 <CAHD-aqKWdUBGyadCnVoSbkf4BysoSuvBBHrupXx-JbowqqNZPQ@mail.gmail.com>
 <CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com>
 <20474.20627.928963.262924@gargle.gargle.HOWL>
 <4FFF2B15.5070502@codigosur.org>
 <20482.22437.126251.847921@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
In-Reply-To: <20482.22437.126251.847921@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 15, 2012 at 11:09:49AM +0530, Sujith Manoharan wrote:
> Nicol=C3=A1s Ech=C3=A1niz wrote:
> > Sujith, does this mean that the problem is outside the scope of the
> > ath9k_htc driver itself or could it be fixed?
> >=20
> > we are doing some heavy use of hardware based on this driver for many
> > projects; any further debugging work you might need, we are more than
> > willing to help.
>=20
> This is a regression introduced by this commit:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
;h=3D6d810f10325522cfcf498dc6d64b9f96e1f5153f
>=20
> Fixing this requires either introducing a new mac80211 callback or
> revert to the older behavior which issued a station notification only
> after the supported rates have been setup.
>=20


Hello everybody,

sorry for the very late response on this topic.
I am performing some tests now using mac80211_hwsim.
I'm first letting wlan0 join the ibss and then I let wlan1 join the same ib=
ss.
In the log I clearly read that the basic rates get updated by means of a
beacon/probe response (actually this is what I expected).

Then I tried to send frames from wlan0 to wlan1 passing through the emulated
link and I can see with "iw dev wlan0 station dump" that the tx rate gets h=
igher
and higher up to 54mbps. Therefore I do not see any problem with the update=
 of
the basic rates.

Am I missing/overlooking something?
@Sujith, do you have a more clear idea of what the problem is?

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAi4SIACgkQpGgxIkP9cwdqSACfdO4l8tNAb2a+h1bJyWFNXXXb
UHkAn1SzhtJ4CpuSa7EsKNTSF4LVfoEe
=o052
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
