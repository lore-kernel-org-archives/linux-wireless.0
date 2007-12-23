Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbXLWSPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 13:15:16 -0500
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712230938j7e84d43dx2a85911b54d1b062@mail.gmail.com> (sfid-20071223_173823_938345_7DEB3CB6)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
	 <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com>
	 <1198154463.16241.46.camel@johannes.berg>
	 <c85cb4470712230815u158cd19fjc1ff58a7e2c83fbc@mail.gmail.com>
	 <1198430920.4541.11.camel@johannes.berg>
	 <c85cb4470712230938j7e84d43dx2a85911b54d1b062@mail.gmail.com>
	 (sfid-20071223_173823_938345_7DEB3CB6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HjOxG9OgvqzHOFTmE8QP"
Date: Sun, 23 Dec 2007 19:15:01 +0100
Message-Id: <1198433701.4487.1.camel@johannes.berg> (sfid-20071223_181527_284613_F6310671)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HjOxG9OgvqzHOFTmE8QP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > tasklet/driver
> > __ieee80211_rx()
> >        __rx_pre_monitor()
> >        __rx_pre_load()
> >        __rx_pre_qos()
> >
> >        if (agg)
> >                __rx_handle_reorder()
> >        else
> >                __rx_handle_packet()
> >
> > and __rx_handle_reorder() calls __rx_handle_packet() which does all the
> > rest, I guess.
> >
>=20
> that's the general idea, but __rx_pre_qos() won't be able to be in
> __ieee80211_rx(), as it handles txrx_data. if it will be there i am
> back in the original problem - the need to restore txrx_data per
> frame. i will have to put it inside __rx_handle_packet().

Ah, ok, I see, sounds good. It can well be there but I guess it should
be before invoking the RX handlers though; then I'll go and see if
anything else only needs to be done once per interface.

johannes

--=-HjOxG9OgvqzHOFTmE8QP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR26lo6Vg1VMiehFYAQIULhAAoNI8yPtqrZb+/rYNyvpvpR39I21Tje1/
YNTGllO/r9X+Bg0Adou66oOBtJbyKURkpZ3aaav6XExYQbostAIquhmaE5SpPBw1
VQJPpIYyazeNZYjKdxQd/AYd+A7ylY7lyGELCrY+nuRVIck9eZyu1XPlyWErTtmW
scNkLF81XE5Q2T6+NkqCNgY7Aa37MLwixfCJNcRHXNhWAs+66ITHmBUNxGLd9JIL
Dx9xMqdQDhwbdt7pRpojm5KeESjnC7ispQZS685k+fgEcnELWl2oZuvSjUPWe7gC
P+Pdgnf9+fReVDzvIcoTUtFyHrVfC3P8NHBQIR2gGEXQ+ztrlSte0/QigjlSZIVK
fbkTJCNtKZ8VO/0upKS6iCs7r/SGD5iwHGx8e5kZwipKbqaNOiK/3Y91D9Sl+muW
bNU+DNABiw7k0qHiKCZkbRr0arTKBo7P+UZxTzqE+AsLLwVXd353T1h9/YWx37QR
0LpJK+pwl/IyhVBWYIPal9zg4v4I2kkbLZSt0Y43nQbGMkmCgr4DeBwGkV1GWLtE
IVtVsQ7NY3zmA8S2H6Z8AfIPLbYRe7onagEJc0AWRIwYi8jRMgFDF+ORwtCKyrQt
h0gtt1/h6vpFHpPw616u+aTDoi5oe2zj2zLsKYv1hXMLkankKlylsnYPVatYzT2q
T8irN1S0ZY4=
=zlWV
-----END PGP SIGNATURE-----

--=-HjOxG9OgvqzHOFTmE8QP--

