Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbXKMQb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 11:31:26 -0500
Subject: RE: [PATCH 06/14] mac80211: adding 802.11n essential
	A-MSDURxcapability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	flamingice@sourmilk.net, Jouni Malinen <j@w1.fi>
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB0403BC4E@hasmsx411.ger.corp.intel.com> (sfid-20071113_162343_516650_F1375C8F)
References: <1879838866982C46A9CB3D56BA49ADEB0403BC4E@hasmsx411.ger.corp.intel.com>
	 (sfid-20071113_162343_516650_F1375C8F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3WSFwt01zRfQlv7M0Uux"
Date: Tue, 13 Nov 2007 17:32:43 +0100
Message-Id: <1194971563.9116.72.camel@johannes.berg> (sfid-20071113_163129_856943_A731EDC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3WSFwt01zRfQlv7M0Uux
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I'm not sure I'd like to see such a thing. One thing I'm generally
> > unhappy with here is how the handlers are in a list but there isn't a
> > point in adding/removing any. Also, I'm not convinced that what you're
> > saying will actually work because the handlers expect 802.11 frames so
> > you'd have to make 802.11 frames out of the 802.3 frames you get...
>=20
> True, it is a drawback, as I'll have to create 802.11 frames instead of
> 802.3 (with important data duplicated into all of them), but then I'll
> just call  ieee80211_invoke_rx_handlers with ieee80211_rx_handler
> pointed to
> local->rx_handlers[ieee80211_rx_h_802_1x_pae]. Then I won't have to
> change any existing handler except of my new ieee80211_rx_h_amsdu
> Do you think this approach makes sense?

I'm not convinced. That seems fairly ad-hoc and likely to break in the
future because only parts of the 802.11 header can be reconstructed.

> Do you mean ieee80211_rx_h_decrypt?=20
> If yes, I see it uses 3 different decrypt schemes. Here I have one
> scheme reaping it self over and over.

Yeah, this used to have four or five different RX handlers.

johannes

--=-3WSFwt01zRfQlv7M0Uux
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARznRqqVg1VMiehFYAQIH6g/+NcC2fjSJ8O1429DS4sMsIY/jlCrwJKwN
snQPgop3Omuqj18c6yjHo2G3xomnCMyEsK7JLWeiWyD7iFRT7YyQRWX3fMC8GS6x
msIaRF7c7VDwWb12sqK1BkgZGoOb50bqVr+B8K4khyu6O4CKgPUPJD6Anq6SOHJn
yietSMkjt7pvTSMHbWfoSVxr8Oi3hveM8e5jhMG3/Zia5BL8+LkS7c2Oy8uzKnPD
9QfuYLN0lavK5+k17QD/5EhslfJd7mMqOAltZhuTjfC2pn1rmFYk+JE5WRLCXwBY
9YgaxVCR6cN8cKc1fz9bKc2RxC1WYFKiOwbEh/IsTIX5uqmGJdskO9e0LVW3l/Xd
Z4MPXxUz9iIVgU5GkwM73CEOt0FnafDHUAyN2wtY8tHfaQ/4DtU+0vVsLISkhHKj
USMPiS9ofDG7226jeZOl8awnIRqu+nHU0akwHgBbuY3w+cUxOUC58jlgwEglKR9G
RnK8HEa/oUDMHQCKhqP+enc1Cr98TycAn/WzLWWS8mFUkGBpdGUpuaXeRC8TM/nV
S4WTXhSUr3GTw/xjEB3Uf9z3cR9e1N5N3R9b2nMGW00B38QTjLI+hCAEByZh9k/x
ATcvYJE4qxq4iqSEC3TLbKFnQWI0z0H7lfgn8Z97aBkAGues3QY2KLQqRdYCztkp
26KTrLrLv2I=
=wKQ9
-----END PGP SIGNATURE-----

--=-3WSFwt01zRfQlv7M0Uux--

