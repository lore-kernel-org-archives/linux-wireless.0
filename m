Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:37781 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3A2OhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 09:37:05 -0500
Date: Tue, 29 Jan 2013 15:36:52 +0100
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
Message-ID: <20130129143652.GA23425@pandem0nium> (sfid-20130129_153712_130525_1F69238F)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <5107D345.7010101@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
In-Reply-To: <5107D345.7010101@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Tue, Jan 29, 2013 at 02:48:53PM +0100, Zefir Kurtisi wrote:
> On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
> > From: Victor Goldenshtein <victorg@ti.com>
> >=20
> > [...]
> > =20
> >  /**
> > + * enum ieee80211_dfs_state - DFS states for channels
> > + *
> > + * Channel states used by the DFS code.
> > + *
> > + * @IEEE80211_DFS_USABLE: The channel can be used, but channel availab=
ility
> > + *	check (CAC) must be performed before using it for AP or IBSS.
> > + * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this chann=
el, it
> > + *	is therefore marked as not available.
> > + * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is a=
vailable.
> > + */
> > +
> > +enum ieee80211_dfs_state {
> > +	IEEE80211_DFS_USABLE,
> > +	IEEE80211_DFS_UNAVAILABLE,
> > +	IEEE80211_DFS_AVAILABLE,
> > +};
> > +
> Not sure if IEEE80211_DFS_UNKNOWN is not missing here, i.e. whether a cha=
nnel that
> never passed a CAC (or the CAC has been aborted) is always USABLE. Once I=
 realized
> why ETSI defined an UNKNOWN state, but forgot meanwhile - so maybe only r=
elevant
> for managed operation (like an UNKNOWN state can be overridden by external
> information, whereas e.g. UNAVAILABLE can't).

I've seen the UNKNOWN state in your last mail and your last slides, but did=
n't see
a purpose for it. If you can remember what we need it for, please tell me. =
:) We could
reject changes for an UNAVAILABLE channel from outside access if this is re=
quired.
>=20
> Furthermore, is there a reason to define an additional wireless_dev.cac_s=
tarted
> flag vs. adding a IEEE80211_DFS_CAC state?

We have discussed that we want to move cac-information from channel into wd=
ev, so I
just did that.

The idea was that a CAC can always be started, and state transition is only=
 performed
after a succesful CAC. This simplifies the state machine and some corner ca=
ses. A
channel stays USABLE through the CAC, and is only changed to AVAILABLE afte=
r CAC is
completed. We also don't forbid checking the same channel on different WiFi=
 modules,
if any of them completes the channel is changed to AVAILABLE.

The same goes for the OPERATING state (defined in ETSI at least) - I don't =
have this
as dfs state, because it is just the same as AVAILABLE plus the information=
 that
we currently use it, and that we know in the driver. Adding the state would=
 just
add management overhead with no practical gain, IMHO.

Cheers,
	Simon

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEH3oQACgkQrzg/fFk7axbCUwCdHEjPq7YSjTH5s6Jd5ja4nWRr
IhYAoL1w1oDXkSFAGUuuMZFe7EXPWeD8
=mPK9
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
