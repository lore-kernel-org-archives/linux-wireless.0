Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33665 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3AaRsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:48:05 -0500
Date: Thu, 31 Jan 2013 18:47:58 +0100
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
Message-ID: <20130131174758.GC2018@pandem0nium> (sfid-20130131_184810_391191_C7D55F44)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
 <20130131163126.GB1387@pandem0nium>
 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
In-Reply-To: <1359650902.8415.93.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--rQ2U398070+RC21q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 05:48:22PM +0100, Johannes Berg wrote:
> > > > +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp)
> > > > +{
> > > > +	struct ieee80211_sub_if_data *sdata =3D vif_to_sdata(vif);
> > > > +
> > > > +	trace_api_radar_detected(sdata);
> > > > +
> > > > +	/* may happen to devices which have been added but are not up */
> > > > +	if (!cfg80211_chandef_valid(&sdata->vif.bss_conf.chandef))
> > > > +		return;
> > >=20
> > > Huh, what does device and up have to do with that?
> > >=20
> >=20
> > What I've tried:
> >  * configure 2 SSIDs in hostapd, start it
> >  * both wlan0 and wlan0-1 got created
> >  * only wlan0 comes up, wlan0-1 was rejected because of missing channel=
 combinations
> >  * now I've injected a radar - which should be sent to wlan0 and wlan0-1
> >  * wlan0 could send the event, but wlan0-1 had no bss configured and th=
erefore no chandef
> >=20
> > I can change this comment to "may happen to devices which have currentl=
y no BSS configured",
> > maybe that it is not so confusing ...
>=20
> Not sure I understand, how would the radar detected event come to an
> interface that doesn't really exist for the driver?

wlan0-1 exists and was created, but no AP was ever started - because hostap=
d tried
to start the AP on a DFS channel when wlan0 was already active, and thanks =
to our
interface combinations this is not allowed. Therefore, the vif.bss_conf.cha=
ndef is empty.

The interface does exist for the driver (interface add succeeded), but star=
t_ap failed,
so it is a virgin AP interface.

I think this behaviour is correct like that ...

Cheers,
	Simon

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEKrk4ACgkQrzg/fFk7axa7FwCg5w9K1nnp9i2rSYxN2qUJQWOB
fMEAnRXmjGrMSxVbaL6CqlSIrxLkBM1E
=xyrZ
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
