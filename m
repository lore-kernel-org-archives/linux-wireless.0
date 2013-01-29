Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55407 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3A2On5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 09:43:57 -0500
Date: Tue, 29 Jan 2013 15:43:48 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
Message-ID: <20130129144348.GB23425@pandem0nium> (sfid-20130129_154406_145910_EED39A75)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <5107CE12.3090209@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
In-Reply-To: <5107CE12.3090209@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Tue, Jan 29, 2013 at 02:26:42PM +0100, Zefir Kurtisi wrote:
> On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
> > From: Victor Goldenshtein <victorg@ti.com>
> >=20
> > [...]
> > @@ -2080,7 +2087,7 @@ enum ieee80211_frame_release_type {
> >   * @IEEE80211_RC_SMPS_CHANGED: The SMPS state of the station changed.
> >   * @IEEE80211_RC_SUPP_RATES_CHANGED: The supported rate set of this pe=
er
> >   *	changed (in IBSS mode) due to discovering more information about
> > - *	the peer.
> > + *	the peern.
> >   */
> typo?

yup ... sorry about that.

> > [...]
> > +	/* TODO: some channels (e.g. ETSI weather channels between 5.600 and
> > +	 * 5.6500 require longer waiting time, if we want to support them at
> > +	 * all.
> > +	 */
> > +	timeout =3D msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
> > +	ieee80211_queue_delayed_work(&sdata->local->hw,
> > +				     &sdata->dfs_cac_timer_work, timeout);
> > +
> > +	return 0;
> > +}
> > +
> The required minimum detection probability for weather channels is purpos=
ely
> defined such that it can't be reached, so it is safe to assume they will =
never be
> supported. As for CAC and NOP timings, they are luckily same for ETSI and=
 FCC
> right now, and if they differ in the future, we have the countrycode's DFS
> regulatory domain available to differentiate.

Ah ok, good that they are the same :)

I agree about weather channels, 99.9% detection rate just appears not feasi=
ble.
Will remove the comment then.

Cheers,
	Simon

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEH4CQACgkQrzg/fFk7axYGUwCgrmiHDJI9gASPrGtt/Xl2u/Bl
318AnillUUtRQemL4jVvgvhoT4RO/1yE
=KJBu
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
