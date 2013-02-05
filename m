Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52331 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab3BEIoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 03:44:15 -0500
Date: Tue, 5 Feb 2013 09:44:05 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
Message-ID: <20130205084405.GA7865@pandem0nium> (sfid-20130205_094422_768774_A696E845)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
 <20130131163126.GB1387@pandem0nium>
 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
 <20130131174758.GC2018@pandem0nium>
 <1359712620.8528.5.camel@jlt4.sipsolutions.net>
 <20130202221544.GA22363@pandem0nium>
 <1359999125.17993.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
In-Reply-To: <1359999125.17993.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 06:32:05PM +0100, Johannes Berg wrote:
> On Sat, 2013-02-02 at 23:15 +0100, Simon Wunderlich wrote:
> > On Fri, Feb 01, 2013 at 10:57:00AM +0100, Johannes Berg wrote:
> > > On Thu, 2013-01-31 at 18:47 +0100, Simon Wunderlich wrote:
> > >=20
>=20
> That sounds strange -- how does ath9k even know about an interface
> that's not UP? Maybe you mean it didn't start an AP?

Yeah, that is what I meant - the AP wasn't started on this on that interfac=
e.
>=20
> Why does the driver even report it by interface? It seems it should do
> it on a channel context, or even on the hw since it can only be a single
> channel in that case anyway?

Well, yeah the reporting is currently done per interface. Reporting radars
for the hw is certainly possible as well - channel contexts are currently
not implemented in ath9k (where I test). The latest patchset works the same
way, although we can change that if you prefer. For the current implementat=
ion
(single channel, single vif) it makes no difference, maybe for future imple=
mentations.
I don't know if there are any weird corner cases though, and we probably ne=
ed to
adjust the mac80211 interface too when to report radars on certain channels=
 only
(e.g. extension channel radar).

Cheers,
	Simon

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEQxlUACgkQrzg/fFk7axZFHACg0oCFnQvRnVivqAXR0e/Lvvcj
MqsAnR94fxybzDt8ftRQclQdOHo/JVwn
=uABd
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
