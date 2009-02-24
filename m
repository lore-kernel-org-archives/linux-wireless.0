Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbZBXCOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:14:00 -0500
Subject: Re: [RFC] nl80211: Authentication and association events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090220192557.GA17914@jm.kir.nu>
References: <20090218200210.GA13955@jm.kir.nu>
	 <1234988740.4023.51.camel@johannes.local>
	 <20090220192557.GA17914@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6LOASSxsWXBel+47SAyP"
Date: Mon, 23 Feb 2009 17:55:27 -0800
Message-Id: <1235440527.4455.45.camel@johannes.local> (sfid-20090224_031404_064497_CB535182)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6LOASSxsWXBel+47SAyP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-20 at 21:25 +0200, Jouni Malinen wrote:

> nl80211: Event notifications for MLME events

That looks good to me.

> +/**
> + * enum nl80211_auth_type - AuthenticationType
> + *
> + * @NL80211_AUTHTYPE_OPEN_SYSTEM
> + */
> +enum nl80211_auth_type {
> +	NL80211_AUTHTYPE_UNSPECIFIED,

This seems a little odd, is that really useful? And if it is, what do we
do? Try all?


> +struct cfg80211_auth_request {
> +	struct ieee80211_channel *chan;
> +	u8 *peer_addr;
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	enum nl80211_auth_type auth_type;
> +	const u8 *ie;
> +	size_t ie_len;
> +};
> +
> +struct cfg80211_assoc_request {
> +	struct ieee80211_channel *chan;
> +	u8 *peer_addr;
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	const u8 *ie;
> +	size_t ie_len;
> +};
> +
> +struct cfg80211_deauth_request {
> +	u8 *peer_addr;
> +	u16 reason_code;
> +	const u8 *ie;
> +	size_t ie_len;
> +};
> +
> +struct cfg80211_disassoc_request {
> +	u8 *peer_addr;
> +	u16 reason_code;
> +	const u8 *ie;
> +	size_t ie_len;
> +};

Seems sensible to me.

Should we have some more code in cfg80211 to keep track of the BSSes
we're authenticated/the one we're associated to, and have some commands
to query those from userspace?

johannes

--=-6LOASSxsWXBel+47SAyP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1ONAAoJEKVg1VMiehFYh1sQAIGTcKLXNre2vSBnXATzO0vP
p3e37sThNFHMmcKdiaZxjhFgGOe6ABOVtVo/tL1msiC6cPSZKcah/4sILF3gY01u
xQlrMf4gt62/lyrfmUvKeCYAn9TmxGeLJsDC2yyS0Ik9FDqhEXDkNgW/9Jg7ZCuR
KKhsKtEJ6xbYHTmdPvnwpYeZi9czMHTQEUjQbN9xi2eTfYPbq+Zj6DbyLwUvJ63J
4Kt0jyurkkjb7YWY0MeI49Qf916qa2VbVU4TVWSrzmxM5YYGJYSgNWccdXLMt6yB
UTHMGlAKIC0EZYbfJkWF0J8oXUSYZCczHdf5CvgeqVOMjryDLzinM8zZaK4jyuqo
0uEPJGMfTTY3hH4e1cW/LMWxbqYkAJKc3iqYz6NLl7/86burlO46B1ayR7v/xtua
KxEFmvC8Ief6dLtxF9D0pxND6gdhu439O8M6CIZJTzZyldaQ7cn1rskk8lIHSrtd
ndSYXUDFV0JsUhOegsE3xiBpI1imQrYc4LXcdG+0/vdAPrAS7gV7mllZfSd2j0Ye
o9W7q5lHjKLfsHcisk/J81WWCmiM6SbEn1wTKhawGmhnm30af3Zbq+X7o4a2C4eS
HuO7aaXvbpZj3qdUo2/0OXS98w7E/vqAj1OHhyq6Q0RGn11Vt/C7cOobdBJFgISB
jXN3KQbFEk2LilvVPSz+
=cK0g
-----END PGP SIGNATURE-----

--=-6LOASSxsWXBel+47SAyP--

