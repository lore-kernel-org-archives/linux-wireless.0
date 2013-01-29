Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:41212 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3A2Owg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 09:52:36 -0500
Date: Tue, 29 Jan 2013 15:52:28 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 0/3] Add DFS master ability
Message-ID: <20130129145228.GC23425@pandem0nium> (sfid-20130129_155240_598568_ADC4CED5)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <5107CB32.2070908@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
In-Reply-To: <5107CB32.2070908@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Tue, Jan 29, 2013 at 02:14:26PM +0100, Zefir Kurtisi wrote:
> On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
> > [...]
> >=20
> > The channel states are now implemented in cfg80211. Shall we inform use=
rspace
> > about channel changes? If yes, how should we do that? We could add chan=
nel states
> > to the channel list, and give "channel list changed" events to userspac=
e as it
> > happens now, or define a new kind of event ("channel-available-again-ev=
ent").
> > Suggestions welcome. :)
> >=20
> An event whenever a channel state changes is perfect, ideally provided wi=
th the
> time-stamp when this change happened.

Yeah. "channel list changed" events are already available (at least I get t=
hem in
hostapd). If we put the current state + timestamp when entered into the cha=
nnel list,
we would have what you want, too.

>=20
> With the centralized channel state handling proposed here, the required
> modification to allow managed DFS operation can be minimized to a proprie=
tary (or
> even upstreamed but CONFIG_CFG80211_CERTIFICATION_ONUS guarded) function =
to modify
> channel states.

Yes, the idea is that one can have a small proprietary patch or default-off=
 command
(CONFIG_CFG80211_CERTIFICATION_ONUS sounds good) or something like that to =
change a
DFS state with the new cfg80211 function. I also thought about having a nl8=
0211-command
without implementing an iw counter part or keeping a special "state change"=
 program
somewhere with appropriate warnings. But this might still be too "liberal" =
for the
regulatory statement. :)
>=20
> Can't contribute much to code review, but full ACK for the updated concep=
t.
>=20

Cool, also thanks for the code comments!

Cheers,
	Simon

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEH4iwACgkQrzg/fFk7axbhqwCg8jyR2CzPBAZG6WUQRChMsGZI
LS0An3elaD5pw39ZEH0u9AjXpWPbQTiS
=bUFt
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
