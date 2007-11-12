Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXKLQoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:44:23 -0500
Subject: RE: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDU
	Rxcapability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	flamingice@sourmilk.net, Jouni Malinen <j@w1.fi>
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB04008798@hasmsx411.ger.corp.intel.com>
References: <1879838866982C46A9CB3D56BA49ADEB04008798@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mBtDFxEm2jQL6vIwcPTW"
Date: Mon, 12 Nov 2007 17:45:42 +0100
Message-Id: <1194885942.5229.62.camel@johannes.berg> (sfid-20071112_164426_775204_ADD4A070)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mBtDFxEm2jQL6vIwcPTW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > The one thing I'm not sure about here is the EAPOL frame handling. In
> > theory, such frames could be part of an aggregation and thus we'll not
> > get them to the right place. Then again, we haven't decided yet what
> the
> > right place is. Also, what happens with 802.1X port control?
>=20
> I agree. Good point and thanks for the catch.
> Would appreciate your opinion for next possible solution:
> I'll Move ieee80211_rx_h_data_agg before ieee80211_rx_h_802_1x_pae, and
> assuming I identify A-MSDU, I'll loop for each internal MSDU on:
>   ieee80211_rx_h_802_1x_pae=20
>   ieee80211_rx_h_drop_unencrypted
>   ieee80211_rx_h_data
> return value of ieee80211_rx_h_data_agg to
> __ieee80211_invoke_rx_handlers will be this small loop's return value=20

I'm not sure I'd like to see such a thing. One thing I'm generally
unhappy with here is how the handlers are in a list but there isn't a
point in adding/removing any. Also, I'm not convinced that what you're
saying will actually work because the handlers expect 802.11 frames so
you'd have to make 802.11 frames out of the 802.3 frames you get...

What I originally wanted to do for this was to add a new
"handle_data_frame" function that operates on 802.3 frames but has all
the info available, is called from the rx_h_data handler and
incorporates all the three callbacks you list above.That'd be similar to
what I did with the crypto code (where we now only have a single handler
doing it all rather than a bunch doing different pieces of the
functionality)

It'd basically look like this

handle_data_frame
{
	result =3D handle_pae()
	if (result =3D=3D ...)

	if (should_drop_unencrypted && is_unencrypted())
		return DROP

	...
}

and rx_h_data would simply reframe the frame and pass it to this
function, and your deaggregation handler would loop over this function.

You should be able to do this in the code right now because I removed
the management interface and hence EAPOL frames aren't handled
specially. Hostapd wants to have eapol frames on the management
interface and 802.11 framed, but I don't understand that and would
rather have it be done differently.

We may need more discussion, but I believe finding a good solution to
this is a crucial part of proper support for deaggregation.

johannes

--=-mBtDFxEm2jQL6vIwcPTW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARziDNaVg1VMiehFYAQLnrhAAtX+98n3zKmPhhCo1N7567S9nNCqKD0xb
lu+CL5ADe2sEzOyj5kQen2ghrxdFxcTQPorIp61EtTnPHLaAXQJgiE0mr4SgmZ9P
yIRonZpzAjnwtchXSpYblRNWFslYrl0IYsPd6iGOsoipzZuJVh93Pv3bm+FJEmxz
O9SlX1nRA+m+sKEQWsdJxhl8Ne4cr2DXhawIMuuycBEeftqoXF2kMoc8X7vK/5Qp
yCf33yuiuYbE/WYD5a5U2bSYcFLbn0ZWjMrp6H0TjQhmyWp9cDcQMBNuqp+yI2cB
VF/dLOGSRdysbDIx6iFntypv1IO5R9MRh09RtODplMDBk/I58kgnhqk5Tr922JYk
hZcW+vNraPD/ijpU2pqvw1+3/VVg3zkCl4Vwb/KzQh3e1naUJWXcGySQBkDqDV9o
BJmhtsrVYrRFYWjo1iaEIb5nlREpi3awzRmxo1lUkBJAj/zw7nQ9aLagSpyWYCFn
QGlo5G+Pc2oi6nJnOKZAD665eFmLYM1aMpwoGey19PdEQl+gV5bPxSoZdijvAR8X
Z/bmfZxVIXS2bJ9SdH/+1K/2N+AtWU86xjAJzgaaTkEuIkyKIFiDyvwznC3d8dEI
Y67xvOF6SUty+GCoXW1aBOd7nR7ZrTCCoC7l0cWf6/Hk7cponf58sae373NG32RX
xctgwDT22S8=
=R1De
-----END PGP SIGNATURE-----

--=-mBtDFxEm2jQL6vIwcPTW--

