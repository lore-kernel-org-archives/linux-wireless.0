Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbYAYMPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 07:15:08 -0500
Subject: Re: mac80211 breakage on broadcom hardware.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Jory A. Pratt" <geekypenguin@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801250217.44164.mb@bu3sch.de>
References: <479935C3.7050403@gmail.com>  <200801250217.44164.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kTMeqMrnA9WsJDxREiS4"
Date: Fri, 25 Jan 2008 13:14:50 +0100
Message-Id: <1201263290.12870.6.camel@johannes.berg> (sfid-20080125_121514_299237_A7885E03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kTMeqMrnA9WsJDxREiS4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -3194,44 +3223,47 @@ void ieee80211_sta_scan_work(struct work_struct *=
work)
> =20
>  	switch (local->scan_state) {
>  	case SCAN_SET_CHANNEL:
> -		mode =3D local->scan_hw_mode;
> -		if (local->scan_hw_mode->list.next =3D=3D &local->modes_list &&
> -		    local->scan_channel_idx >=3D mode->num_channels) {
> +		/* get current scan band */
> +		if (local->scan_band < IEEE80211_NUM_BANDS)
> +			sband =3D local->hw.wiphy->bands[local->scan_band];
> +		else
> +			sband =3D NULL;
> +
> +		/* if we started at an unsupported one, advance */
> +		while (!sband && local->scan_band < IEEE80211_NUM_BANDS) {
> +			local->scan_band++;
> +			sband =3D local->hw.wiphy->bands[local->scan_band];
> +			local->scan_channel_idx =3D 0;
> +		}
>=20
> What are we doing here?
> b43 does only define one band (2.4GHz) currently. Is it possible that thi=
s code
> selects the uninitialized 5GHz band structure?

I thought about this a long time and I'm pretty sure that it cannot
select a NULL band structure as long as there is at least one band
structure which is guaranteed by cfg80211 core code.

scan_band always starts out at IEEE80211_BAND_2GHZ, and once it reaches
NUM_BANDS the scan is aborted, and it can't select NULL bands because
one band is guaranteed to be non-NULL (and after this loop we abort if
sband =3D=3D NULL)

johannes

--=-kTMeqMrnA9WsJDxREiS4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5nSuaVg1VMiehFYAQLoNQ//fbDNUpUuJm5jShb9VHwoQSwpWMZV4PrZ
YljyGc9tnrU/7NgmrsE+59XXhHyzBkFVxrv50Mf4sI/1DmNJjPMftryDIwGw7Rr+
M84w0+McduMrcE/Ns+BfvHpo+X89008KRxW9f08E3z3ZzbNgCUdYiBH5LAHxum3x
RqWXmWgYJdXbs6fbcWS/PnbDkog5q2DZfFv85DbtG1xu8lbjW7EuzcfJEA3gnpGh
C4ZzUO6JMXaTZEqq7X6HePCPQkWY0Mia0448bWqlNE6yiDXLJ1rkjpX6vpjY366m
ZDW4DymNhyXEEL+Wa11EVZZpY3QSUwAHzcnT5Z5Dw5c9py/AWZcGaLNthqB2FXaE
q6UrgRK29zYOWygK5REfJjJxAwlY5rl+O6V+p+T18ou7erqFyxG/YxAh8sE3rsWq
e94iVusARVr3x4ZIx987gTJ5TFUk85GTW6/1mzaKAcCwyImK/VZ/jAvEJqidb9m8
v/ygDoFhCrHsLF1z/cJ0Lwef9CL7iSGVcssAib7cSG0MnEXFOjeVqxtnsI8MCTEC
gIe6w3qpiqX8yeC8fLn2zNWGBusXd/+ans29e+6Knp6Qdcqj6e/Nqp2Uj4i81Mdf
/sVGA+mYECFWrrN0tNcXV5bnFbV1xJeYrBMY0DGJBsv5St2IHZs8ONhDjKlOSiRa
phQ0j9yiH1o=
=lOEV
-----END PGP SIGNATURE-----

--=-kTMeqMrnA9WsJDxREiS4--

