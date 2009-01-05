Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZAENll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 08:41:41 -0500
Subject: Re: [PATCH] mac80211: Handle power constraint level advertised in
	11d+h beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090105133738.GA21471@vasanth-laptop>
References: <1231148165-10529-1-git-send-email-vasanth@atheros.com>
	 <1231153954.3334.4.camel@johannes>  <20090105133738.GA21471@vasanth-laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OOoGpo+ZH2neS73ZYbQl"
Date: Mon, 05 Jan 2009 14:42:25 +0100
Message-Id: <1231162945.3334.22.camel@johannes> (sfid-20090105_144146_865298_B30B9BBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OOoGpo+ZH2neS73ZYbQl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 19:07 +0530, Vasanthakumar Thiagarajan wrote:

[an email that somehow was just an attachment?]

> > Also, I don't understand the subtraction? And why are you checking only
> > for sw scanning and not hw scanning?
>=20
> I think driver should handle in case of hw_scanning.

Yes, true, it's all per-channel too.

> > > +
> > > +	if ((*pwr_constr_elem <=3D conf->channel->max_power) &&
> > > +	    (*pwr_constr_elem !=3D conf->power_constr_level)) {
> > > +		conf->power_constr_level =3D *pwr_constr_elem;
> > > +		ieee80211_hw_config(sdata->local, 0);
> >=20
> > That needs a changed flag, no?=20
>=20
> No, ieee80211_hw_config() will take care.

Indeed, my mistake.

> > And how does the subtraction make sense
> > like this? The spec talks about the country element's max power, and
> > then subtracting this, to get the local power, but if the local power
> > was set lower than that then we shouldn't subtract even more, no?
>=20
>=20
> This is more concervative way of processing power constraint.  Yeah, you =
are correct
> that we might be setting lower tx power than the allowed one when we subt=
ract power
> constraint from already min power (of reg data base and 11d ie) instead o=
f only power=20
> limit advertised in 11d ie, but this situation is uncommon.=20

Ok, makes sense, let's not worry about it then.

That means the unmodified patch is fine, I guess.

johannes

--=-OOoGpo+ZH2neS73ZYbQl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYg4+AAoJEKVg1VMiehFYnMIP/jj7N03l7DWVNAqq4/f5eLwh
n4YSgaJPBZqrp2C2rhAqGAq96yNbCxQHAULUAnBeh9b2IZse+vZd2Nd2GO4u/Pne
7GaIU9rsFAYjfyHuPpSGAO5uOA4taTXNyfVy8dXqO5ugZnK61OgOxc84wR17Gg8R
U8bAb4UqPSuznXzxpSVWlBP5eSk4m/larTDxE9pOJ0B4zjnokIqkbfdnl85symzZ
g3hEubei8Yvs1wL6m/xLYuV4mxDITVr+kHSy3A4ZI8RmmHpnmTX/Pe7zlx2oVtwS
PI6CbtMEiBD1qHogY43kkwHWsmomHgjjYGgdT6nvz5TkP3FAcVihVh51GXgWwrkT
yGwRQatPVHwT4v562YQV0dFGIs07+iB+8Bg8/TEZkZH2voJceb+bI3j1Ot6jd8sP
G3OV5y+QWT0T74C4bWZussW4LfE9L5z8vObEwk5vna5Pv4f2iWZOi86rZm+dWU/Z
au4xJd94iXddPF2sUO6RvrA5PQ1Yj0fig2Okgo46KhxRHcmiEexpu30P6UDZ7uAx
1xRHjWjXHDQuNb6lwQ9otV3+hwqLDNLI6KT6D5/NR0WnhkrRgX7HmGLDtBvu2VPz
3oLTLC/xFH9bz14522Jl64UTPP5JQi4wajM5MYlvnQ7UvwyVLwrslw4/2HDCKxLh
DXzFkApFik2/2appjW7N
=C8vG
-----END PGP SIGNATURE-----

--=-OOoGpo+ZH2neS73ZYbQl--

