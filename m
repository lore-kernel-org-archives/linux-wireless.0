Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbZD3QJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 12:09:40 -0400
Subject: Re: [RFC v6] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20090430155316.GF28027@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1239745712.4205.17.camel@johannes.local>
	 <1239750483.4205.28.camel@johannes.local>
	 <20090430031903.GD18827@khazad-dum.debian.net>
	 <1241104014.29878.12.camel@johannes.local>
	 <20090430155316.GF28027@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tRgbRxxx/UT7ZoTwabhO"
Date: Thu, 30 Apr 2009 18:09:08 +0200
Message-Id: <1241107748.29878.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tRgbRxxx/UT7ZoTwabhO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 12:53 -0300, Henrique de Moraes Holschuh wrote:

> > Actually, I was going to clean this up, and then I noticed you're
> > wrong. :) Returning ERR_PTR(-ENODEV) is intentional, in the non-RFKILL
> > case. Imagine a driver like this:
>=20
> Well, that's confusing as all heck... document it, please? =20

Well, ok. I don't really think it's all that confusing since you don't
need to think about the non-RFKILL code, you can just write the code as
though rfkill was always enabled.

> I still think in
> that case, we'd be better off if rfkill_alloc always uses the ERR_PTR
> convention.

Umm, no, think again. If we do that, the driver won't do
	if (!rf)
but
	if (IS_ERR(rf))
and the advantage is lost.

This is exactly what debugfs does too.

johannes

--=-tRgbRxxx/UT7ZoTwabhO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+c0iAAoJEKVg1VMiehFYUNMP/2ykYS05wuSgWwKD5kiA1i98
1BHyjjkOLR43VJNPH3xAml5t9SsuFbYl/XsX5G6TGRUbikjJ9UKlJdUppV3DP78I
E9y9/jBqMtxwG1wk8NlQhMRDMr4gT4Rq3N/jbP67S+0BhCrM+3brr/5G8oumOD7e
oQG2bYrXG45XgLQwPyiRFgHF9J9R3fWTA1v/rzaWtcGxpTQGU/BS5XDRk63Htfvr
20+SieToNZRpG4iqCgN0LYgDve1aci1UZX1LbzMIP0RPozDMW9lNsDZYPsP3kHUu
c/TDVg2HDDFOawg0pHtDwpnj3VuEzGNxNWy5nPfBwxePzff23xNQcNTHDetjr3rm
/IClnT4Qu05wpjhtI/H6L5Enej37ToSvlEYOQ24Y5LAqlwNGoi3MC2b+OOjPfO/I
H82ebjrSiu+cpG4j0TQ8XaCtHYzpY9Eb8/N4FfgF4davmW6tjN1RQCm033OTWf6S
5sRNQfDumkp4o58ht3WkSL6KWWbjwT5gNqfdrJTiSesfRf7TI5sMs9LVfKbulL8h
qAgOWDAjZWQMtOxPStRskYGu9eFwp/tseWMWsyBRppWBsvXN0sleSUVc3KzLZJhg
X5e51ojNqbSvdzgScIhpEWmDWhQYXrJaaPAcXCwVS1oun8jPqifaFNBHyxfE3DCI
t8VnKLq0rKK/aXjrAKvW
=m6Mi
-----END PGP SIGNATURE-----

--=-tRgbRxxx/UT7ZoTwabhO--

