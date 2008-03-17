Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYCQK5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 06:57:50 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com> (sfid-20080317_102007_550120_18DA2E66)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 (sfid-20080317_102007_550120_18DA2E66)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LEEtUnr4nVPfJhJoPLMr"
Date: Mon, 17 Mar 2008 11:57:35 +0100
Message-Id: <1205751455.1614.25.camel@johannes.berg> (sfid-20080317_105753_424461_A33AA168)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LEEtUnr4nVPfJhJoPLMr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > This is actually quite a bug in mac80211. There is substantial
> >  > difference between dynamic and static key.
> >  > While static key  is used for crypto of all stations in BSS. Dynamic
> >  > key is also called pairwise key and is generated for 'pair'
> >
> >  Gee, can you then please stick to terminology used in the spec so othe=
r
> >  people can understand it?
>=20
> What spec. ieee80211i. WPA, WPA2? .

Preferably one that is actually readable to mere mortals (unlike WPA...)

> >  Actually, you're making it look like a much larger problem than it is.
> >  If you assume anything WEP is a "static key" and everything else is a
> >  "dynamic key" (using your terminology), the only problem will be with
> >  dynamic WEP, and even then it's not really a problem because as far as=
 I
> >  understand even dynamic WEP doesn't distinguish between group and
> >  pairwise keys.
>=20
> This is incorrect.  WPA enable using WEP as dynamic key and this
> setting is very common.
> WEP key is enabled for legacy stations this force also broadcast to be
> WEP.  This setup is still quite common.

I have no idea about WPA's non-IEEE modes. I don't seem to be able to
find such a thing in the IEEE spec so you'll have to actually elaborate
on this.

> >  In any case, actual TX key selection is done by mac80211 anyway, so
> >  you're never interested in that. Only RX key selection is interesting =
to
> >  the driver, and as far as I can tell it ought to work if you simply
> >  always use the broadcast address key when it's WEP, and otherwise the
> >  pairwise keys and/or the broadcast key for bc/mc frames.
>=20
> Nothing to add to just that the assumption about WEP and broadcast is wro=
ng.

> >  Note that there's another case in AP mode where bc/mc keys are TX-only=
,
> >  those are added with a zeroed MAC address.
>=20
> I would prefer also in this case a clear flag rather then playing with
> ambiguity of destination address.

Yes, that would indeed help. Except that WEXT can't actually give you
the distinction so discussing these points right now is pretty moot when
we can't even do it properly as far as I can tell. Might be possible to
infer the information with the key management enabled flag thing...

johannes

--=-LEEtUnr4nVPfJhJoPLMr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR95OnaVg1VMiehFYAQJBWw//QpCT9brpTOxqfHA9t2OvhJc0QAZ8s18K
Hcr6vFFLA4nHrPb7pRzInkl98mDNGagB/GiRTR8WVHx16qBIWag6f7/QPfJfp7As
/aKqfSOI6Iw6+hcs/hc9+7Wa0INxebVoDr/hDpYjPIUxfwSAmsEmIJQutDSMzyqW
tIjMq5zgA/LrX4QYg2EXmyiMBXphBaWhJ7C+0FM0VeIYqVI4mI03CR36rHc8BjYN
KhbqUw7Litv5p4sq5KFSkfIujeR/KPWhOY/ftOR/qYedX9attb5wza+XFPCc/SFm
UPUITj/KuEKkTGPDNB/UTkt3A6adO38/aIAUqQRQzKYDG0zxZs2P+e2+PGW6CS/l
UwhEuWstsN4Z3ME/bzn8vP25RpW91K6ELjm9fNHXTJzjE5pg34q6uTnZ73AR98Bg
uyUPQPyjyDVEW+cWXjBTrRoaMfLsXcFB48JX9slCcVb+XHDU8Qt9sdqSoAny8i7J
/nYqZOIskuOtIr13/w+aFv9dwJQHEVU73HJedAhLR2D+8J7AGYs5a8rfwFufSRnM
E+/buoZvm64eaGa/i0h9Mw/RilomAESf1kqIPfSD37qF1MNRgSJAbpBOzVoVTtji
oB3JjPaV4Ml2TWiaZwRQZQcMy9bDDFKD8UXz66wB2pNMulYrzigw/Y1mE2l9TCLC
BXfWukhsLOk=
=MJi8
-----END PGP SIGNATURE-----

--=-LEEtUnr4nVPfJhJoPLMr--

