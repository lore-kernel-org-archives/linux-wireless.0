Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYCYP37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:29:59 -0400
Subject: adm8211 crypto bug?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UhZw90kKHVUlMPoEkh1U"
Date: Tue, 25 Mar 2008 14:42:38 +0100
Message-Id: <1206452558.16475.265.camel@johannes.berg> (sfid-20080325_153004_275919_6D1683D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UhZw90kKHVUlMPoEkh1U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
                      struct ieee80211_tx_control *control)

[...]
        fc =3D le16_to_cpu(hdr->frame_control) & ~IEEE80211_FCTL_PROTECTED;
[...]
        len =3D hdrlen + payload_len + FCS_LEN;
        if (fc & IEEE80211_FCTL_PROTECTED)
                len +=3D 8;
[...]

johannes

--=-UhZw90kKHVUlMPoEkh1U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+kBTaVg1VMiehFYAQI9hw/9Fgd68a/J3etYZSA84Lip9VHGh66gsZql
Xa69f7MyFctIlPrXHXpKO+0dvYyhpQ4D5TvQpI6T7d0bU+q5qKMobexTrdwPqbJF
b6u4evanvganKgN9btnlMwFv7BywjRWLWe/jHZUMCjLjxL+tJDePBGraCkGk5dJG
6g8Am5reIFmQK6V24q66g7j7wOKGL2wHQ4SHvZO3ZXtpP6BUqsglszjf6iNkRVNP
uKoS7U4zqO6XiWy8KAJSjetDpT6p3zOF98hdQt+idzfm+6klNRlgw1Uo+LgYV9+7
DPISqS/00RakAw3yLX9uUGACVP5l4QdiLPrZRyQNzjdcFpWWOs5wsymQ1UElUHAp
z8BH9cyxSsiUmhD+yscn2yEz2Ae3yvQDTJSp/7xYsGxwiZ2k1U75+t7EYP+3qPd+
H0voMFpZgnzKA6kMAL+B0+2S3AMlh15sugOZF2CapMN9lJlrmJAeBeetaL1xAtP4
Pba6Bj77aGd/sKYq82LRn+USPTcSA5fX0BtTmWixO+6hckqs8PC2RCmWGkDzZheD
0xu45KRdxyDVyv8bRPVAl57rrw+sOZTlbKOCo/np9CpnGmxK4tfwd5QLscXfSejY
Bq+fxXr6GDOzD3O5yYuC6w1DUJBUtr64999/W5ayIEp/JiYtGhCy23gFlell3rnN
uvU48c5U8fA=
=qtEx
-----END PGP SIGNATURE-----

--=-UhZw90kKHVUlMPoEkh1U--

