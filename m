Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbZHNFuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 01:50:54 -0400
Subject: Re: [PATCH] nl80211 connect API support
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1250223474.4972.47.camel@debian>
References: <1250153731-17208-1-git-send-email-yi.zhu@intel.com>
	 <1250153731-17208-2-git-send-email-yi.zhu@intel.com>
	 <20090813091103.GA1826@jm.kir.nu> <1250155777.4972.9.camel@debian>
	 <20090813104635.GA7330@jm.kir.nu>  <1250223474.4972.47.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3dA5dhX7XVZRJIEZKPNK"
Date: Fri, 14 Aug 2009 07:50:46 +0200
Message-Id: <1250229046.7696.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3dA5dhX7XVZRJIEZKPNK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 12:17 +0800, Zhu Yi wrote:

> Johannes, I think we need a way in cfg80211 to tell connect vs.
> auth/assoc. The current capability method (nl80211_send_wiphy) cannot do
> this. For example,
>=20
> 	if (dev->ops->connect || dev->ops->auth)
> 		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);
>=20
> We need to either make NL80211_CMD_CONNECT only depends on ops->connect
> or make NL80211_CMD_AUTH depends on ops->auth. Johannes, which one do
> you prefer?

The latter is already there as far as I can see?

        CMD(auth, AUTHENTICATE);
        CMD(assoc, ASSOCIATE);
        CMD(deauth, DEAUTHENTICATE);
        CMD(disassoc, DISASSOCIATE);

so you should be able to check for these.

johannes

--=-3dA5dhX7XVZRJIEZKPNK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhPsxAAoJEODzc/N7+QmaRxoP/0L80U7BhlOLZmrbbS1gZatI
kfNxOjIx7XG/J4SWFhTLZKEXa3GwxY/H2+mIJx7V1u+fyl911v6QbjUY5tdo3EA/
GlMhMsTYzBUN6A8dw9GRzki6TnG4uUmBEj7wbcBwEE0H4Lch46HNWfgKXHXiMil2
1SRxnf5zEbOW2xvlYMMdwUHTd97GcxhqOrOrBsIenvsZrgrUd2PZqaz/qmWu9S8d
LiiLT70IwIP3MOfo9kleNeZ1uIrBi4jsOtsfloaViFuGMOkZF8+Tn91in0f272Ay
0eye91r2qKiGMode9PIgDoCgqkj2eYkZaxb5apuZUNYL88ifmuFnIgio7RX12OGw
Gr71kbR2zI0QoUrn9ksMsPsusqxQKIkBd1a4dItjHWjlfS/xLowIUrX3iS8HpdUK
AzDQcj1n8Vxy6HpbvV69EQSMER+7nrxgjV3RB1n57xh9+0ft0MZw1sUgzvg5AOmn
Rf4ebgELnyHqLrgYW/bdIWapZTW+1LOiem616EIrPjbfVex5yC7V2O3OcilORCTZ
U9SHxYK6uUgGazBvSfCxIiR04o6P/Q3E+Jv+1B0ibDxop2IzEu2joYjSVb0qi7ds
LM3U/jSDw+/e3SPiodoDPbKB6rzjwcwfv30EqHQTu1wNFEdF4je6kw4WK/G3OVk4
aTiwG0UBLhAwbTbPm7En
=KHdy
-----END PGP SIGNATURE-----

--=-3dA5dhX7XVZRJIEZKPNK--

