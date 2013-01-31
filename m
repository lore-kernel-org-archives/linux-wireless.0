Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45507 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3AaRyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:54:37 -0500
Date: Thu, 31 Jan 2013 18:54:29 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130131175429.GD2018@pandem0nium> (sfid-20130131_185441_271088_B498993D)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <5107D345.7010101@neratec.com>
 <20130129143652.GA23425@pandem0nium>
 <5109094C.8050703@neratec.com>
 <20130130162531.GA27532@pandem0nium>
 <510A30D1.2080604@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
In-Reply-To: <510A30D1.2080604@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Thu, Jan 31, 2013 at 09:52:33AM +0100, Zefir Kurtisi wrote:
> On 01/30/2013 05:25 PM, Simon Wunderlich wrote:
> Hey Simon,
>=20
> all my comments were based on a centralized frequency manager I implement=
ed for
> our system (in user-space) and my assumption that its functionality shoul=
d be
> portable to mac80211, i.e. channel states being managed by reg.c and wdev=
s being
> continuously notified on state changes.
>=20
> Take a setup where you have two cards running, one as master and the othe=
r as
> monitor doing off-channel-CAC. If the monitor detects radar on the master=
's
> operating channel (and the master doesn't), with the current implementati=
on the
> master can't be notified to switch. I understand that supporting this very
> specific use-case would add unjustifiable complexity, while at the same t=
ime, with
> the updates you made this can be achieved at higher layers - so it is goo=
d enough
> as it is.

OK ... yeah I guess there are some things which can be handled in userspace=
=2E Interaction
between userspace programs will be a topic later anyways, think of say wpa_=
supplicant and
hostapd to handle IBSS and AP interface, one of them (or both?) receive a r=
adar event and
now have to negotiate the next channel ... :)

>=20
>=20
> Looking forward your patches to get integrated soon, to allow people actu=
ally
> testing DFS. I'm eagerly waiting for more active testers to share some ug=
ly
> problems I am observing with ath9k's pulse detector. Therefore: full ACK.

Thanks a lot! I've got quite a few mails of people offering their help to c=
heck
and verify this implementation or test it in their country. :) If you want =
to
help in the integration for ath9k, I'd be glad ... the interface should be
rather simple so maybe we don't have too much hassle? I have a little patch=
 for
ath9k to add dummy radar support and simulate events etc as baseline, if you
(or anyone else) is interested ...

Cheers,
	Simon

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEKr9UACgkQrzg/fFk7axaaSQCeM4q4FebI0Rjpb4H8SHfsLryz
cWUAoIjH8fVykn8zVq+QOcK6Gmyz4xlJ
=tyaF
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
