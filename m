Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZH1VBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 17:01:43 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1251474321.3805.73.camel@rc-desk>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	 <1251445557.4189.14.camel@johannes.local>
	 <1251474321.3805.73.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ABrZ9h7QBOGsNuF5DvGM"
Date: Fri, 28 Aug 2009 23:01:37 +0200
Message-Id: <1251493298.3456.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ABrZ9h7QBOGsNuF5DvGM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> This work is motivated by an attempt to untangle the iwlwifi station
> management to be able to use mac80211's sta notify callback. From 4965
> and up the rate scaling in the device is done per station, so an entry
> in the station table is required for the rate scaling initialization to
> succeed.=20

Interesting. I've been thinking about making it go the other way --
remove rate scaling hooks completely. wl1271 apparently has rate scaling
completely in the firmware, so the RS algorithm on the host is just
overhead. I've been thinking putting 4965+ RS into the _driver_ makes
more sense since it really does a lot in the firmware and not on the
host.

Do you think we should try to go that route? I'd think it would probably
be a hardware flag ("no RS algo please") and then we'd skip all the
hooks and put things into the driver. The advantage is that we don't
care about the mac80211 API any more, things get cleaner and we can just
do all RS init from sta_notify().

I've also been thinking if there's a way to make sta_notify() able to
sleep but so far I don't see one unfortunately.

Thoughts?

Anyhow, thanks for the explanation.

> > > @@ -742,13 +740,17 @@ static int ieee80211_add_station(struct wiphy *=
wiphy, struct net_device *dev,
> > >  		if (err =3D=3D -EEXIST && layer2_update) {
> > >  			/* Need to update layer 2 devices on reassociation */
> > >  			sta =3D sta_info_get(local, mac);
> > > -			if (sta)
> > > +			if (sta) {
> > > +				rate_control_rate_init(sta);
> > >  				ieee80211_send_layer2_update(sta);
> > > +			}
> > >  		}
> >=20
> > Why is this necessary? It should already have been called for this
> > station earlier?
>=20
> maybe - I just tried to have the code behave exactly as before, just
> with the rate scale initialization called later. Even before this patch,
> rate scaling initialization would be called if the station already
> exists.=20
>=20
> If it is not necessary I can remove it.

No, right, I understand now.

> Right now iwlwifi is adding stations inside the rate scaling code in
> order to work around this issue. I'd like to clean this up and only use
> the sta notify callback.

Makes sense, thanks, I appreciate that -- should be a good cleanup to
the driver and reduce the number of places that try to add a station and
make the driver more streamlined.

> > Same in ibss.c (not quoting it here) where you're only moving it to
> > after sta_info_insert()
>=20
> This was my goal actually.

Yeah, I finally understood :)

> >  -- all that seems to do is add race conditions,
> > allowing other code to find not-yet-initialised stations.
>=20
> I did not realize that this can happen. Can you please elaborate?

As soon as sta_insert() got called, a packet transmitted to that station
can be processed, find the sta info, and it seems we could end up
calling rate_control_get_rate() before the init was done, through a race
condition.

johannes

--=-ABrZ9h7QBOGsNuF5DvGM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKmEWuAAoJEODzc/N7+QmaPC0P/3+9Yfn8LHdMAxgYeiKpNlNQ
YIzVpgUfo0I6zDQvAVCh6MPW2uDghwA7RfD0trdHXC0Apcq+cX/LBX+RKI8J4Mwf
mcy5Ckalrgy79T+tcDqCfGkcEbbALy+05/1n7vFH6S08avh6XTLjsEkEvPUFNFX5
fANIDxBSPXjbICCDlKf/rbANcvKBouknvmzYEvx0QLiiW0ry6LEerxn6PSS+2GGN
b42hOnEzvE7An8l5u0XgZBQ+E+tStvcWItfW4z6/O2QNwsMl2pwGrsJjAuxnaGGR
qLZLY5TGh/3Sy0V4D5S0m3/K/u445GdIytSWs3VTiA5KWS/jwV+18/2WKdA+Vjon
amZ5367bomevtKTD9M6N/fouxqs2UobBrig0wKFLyEvwiJizO3SExNmQs0o9/GZT
SpVbY06isQYBlnpmD8OqVGVVNAVFQB/qc7C7QMIKvvxLk51BBbovXrmXHlVYVlS7
7IfIEsi7Liej/2Q6WuoTGj+6Crunt+n5XtPBooAFCJOA2YZS1iSE641jtXGFwBuo
MyJw3ipUpDP/gD/1Rn5iMGw4wz61QxtQCPIcNLwEZ2fE1roUWYRgrdLly+pdHJ6Y
i2k0K8MnNzY4ZXz8uAV0IR2w3xLnoMOOPhqKS8C24RCZXI8TbTCSVYMsKYwchqMW
lU7AUM3W7AUFbnBWB/eL
=3kA/
-----END PGP SIGNATURE-----

--=-ABrZ9h7QBOGsNuF5DvGM--

