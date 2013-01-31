Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58774 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3AaRWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:22:05 -0500
Date: Thu, 31 Jan 2013 18:21:54 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 0/3] Add DFS master ability
Message-ID: <20130131172154.GA2018@pandem0nium> (sfid-20130131_182209_503106_F6104331)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359651044.8415.96.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
In-Reply-To: <1359651044.8415.96.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 05:50:44PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-29 at 13:21 +0100, Simon Wunderlich wrote:
>=20
> > Right now, channels at least on my machine have the NO IBSS and PASSIVE=
 SCAN
> > flags set, which prevents reg_can_beacon from returning true, even if w=
e do
> > have radar support. This is due to my reg database setting these flags =
for
> > country code 00, and this is still kept when changing the country code =
to
> > something else (DE in my case). How should we proceed with this? Should=
n't
> > these flags be removed when selecting a country code?
>=20
> I don't think any country sets that, you may be running into that whole
> "regdb intersect" thing ... FWIW the flags are set for 00 since for
> world roaming we don't know if we're in a country that even allows
> transmission on that AP.
>=20

Yes, that is certainly the regdb intersect thing - my atheros card is brand=
ed to "00", which
is the world country code - I would expect to do anything now, not nothing.=
 :D

I mean, I need to set some country code anyway (at least this will be a req=
uirement
in hostapd), so is this intersection thing really useful for the AP case?

reg_beacon() checks all these flags (NO_IBSS, PASSIVE_SCAN), but it actuall=
y should
just care about the radar flag I assume?
BTW, I have not a single country in my regdb list which sets either passive=
 scan or
NO_IBSS (according to regdbdump on my laptop). All non-00 countries only se=
t DFS or
NO_OUTDOOR (and NO-OFDM in japan for channel 14).

> > The channel states are now implemented in cfg80211. Shall we inform use=
rspace
> > about channel changes? If yes, how should we do that? We could add chan=
nel states
> > to the channel list, and give "channel list changed" events to userspac=
e as it
> > happens now, or define a new kind of event ("channel-available-again-ev=
ent").
> > Suggestions welcome. :)
>=20
> You already inform it of the changes by the radar event, but it would
> probably also be good to export the state as part of the channel list
> that you get with things like "iw list".

Well I do that when I finish/abort CAC or detect a radar. But I (currently)
don't send an event when changing from unvailable to usable (after non-occu=
pancy
period). I see the options:

 1) add channel-usable-again event to cfg80211_radar_event=20
 2) send a "channel list changed" (seems this also sent when the regdb is c=
hanged).

Any preferences? Maybe option 1 for completeness?

I wanted to export the state on the channel list anyway. Zefir asked to hav=
e the
timestamp there as well (though I don't know what the specific usecase is .=
=2E.).
Will include that in the next revision.

Cheers,
	Simon

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEKqDIACgkQrzg/fFk7axZh5wCePZnf4RS4twyh9lQut3odJZIq
wt8AoPJgxNpaOXTsbyhRI/6oPw7RgdEY
=Aa70
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
