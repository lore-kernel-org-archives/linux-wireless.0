Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYJOQA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 12:00:28 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224085609.4764.18.camel@californication>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cD6YJVLeK72EiT6SzlNA"
Date: Wed, 15 Oct 2008 17:59:34 +0200
Message-Id: <1224086374.735.4.camel@johannes.berg> (sfid-20081015_180034_186130_95AE983A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cD6YJVLeK72EiT6SzlNA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> > The only reasonable solution I can come up with is have it make separat=
e
> > hints for 2.4 and 5 GHz and then a single-band card won't say anything
> > about 5 GHz so the dual-band gets to set that part. But OTOH I don't se=
e
> > a reasonable use-case for this whole thing so far---we really only adde=
d
> > this after discussions with Marcel at OLS so embedded systems can
> > function w/o crda, but who would build an embedded system with two
> > different cards like that?
>=20
> and we need to keep it this way. For example the first card can be a
> dual-band card, but the EEPROM value restricts it one band. That might
> be by choice.=20

Interesting point. I didn't think that was possible.

> Then attaching a second card, we can't just extend it and
> let this card go ahead and use the second band.

True. Well, not entirely true, because the first card would
 (1) register its eeprom channels as the regulatory domain for one band
 (2) register only the eeprom channels as the per-hw channels

so when the second card adds the regulatory domain for the second band
the first card still cannot use the extra channels because it doesn't
have those registered in its wiphy.

However, this really gets complicated. Do we need to go there?

johannes

--=-cD6YJVLeK72EiT6SzlNA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9hNjAAoJEKVg1VMiehFYPxEP/33/LwSdk38Ns33aOSADNTBd
yj7oumluQNrqMeQhNHovrkxJX2wAiamp3Z1zpQQNnmSa9jUibX+55nz7B+2hlJ+w
tiid1RVbHBqYtT9QlP8+ytcd5sxvlO2i+pR+Yc2/8kGn+6Xmdn5VYByPoWF7CYFr
jQQmJ9TH2Qz7S6n9NxFHzrJfu/pY4PNsh59RwIUPdiynxwAn7LyBpIBGkT603DnT
bdWyQYc8dZktpvUKnAt9KxNR6FuH0pGcsJZfoTIEmHwBRtxh8iVxcFLIiRBphfpF
PHwBQSeftgBoEElKBlKM91neLEysUSSnNzcUQcWEe3AQrBipMSDOKTbD3uKlpEkf
I/EZjmu+RqueO1VAo+mKuoFdxd6JUylKjnl4n8W2i4m3c3e1XM5Ffv9W+PR0lefF
DS4Ug5VWycA9LEIq5GRuBVlB1eO7bkwf+kboyK1AxhHzW/mnoQvk0EjFISPbdbZ9
8zd5uNDeSEH1eys1H/RzbvgOVRrhvdA91WcV8Spn92xAca4cWwpTMkP0uALnwexC
4ZL9fIhhcnGStfQUGudTggPn58vqbzYB1CKG+NKNqQ7gB6L/keepj9e841wee3AC
sGad4oQzp15Sp5IHawKKY/rgESRj+EVmgrMBJw6SfFGz6AdGd3S8SyjDDBfmQVxm
aQibg9NyeOwzSpewP1wE
=gg67
-----END PGP SIGNATURE-----

--=-cD6YJVLeK72EiT6SzlNA--

