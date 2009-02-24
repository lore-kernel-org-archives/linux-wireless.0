Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZBXCsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:48:14 -0500
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87prh9ht22.fsf@litku.valot.fi> (sfid-20090223_200648_913784_42B2518A)
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163738.20939.25890.stgit@tikku>
	 <43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com>
	 <87prh9ht22.fsf@litku.valot.fi> (sfid-20090223_200648_913784_42B2518A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XrIGGvQYvcIhHYjilB+U"
Date: Mon, 23 Feb 2009 18:18:39 -0800
Message-Id: <1235441919.4455.68.camel@johannes.local> (sfid-20090224_034815_917806_DF804EBD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XrIGGvQYvcIhHYjilB+U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 21:06 +0200, Kalle Valo wrote:

> Also my assumption here is that ieee80211_beacon_loss() should be
> called only after certain number of consecutive beacon misses. While
> testing these patches on stlc45xx I used number 10. Can ath9k handle
> anything like this? Or will it just report each beacon miss
> individually?

Should the number be configurable? The beacon interval might vary so it
might be useful to set it so that misses * interval is constant?

> I don't see a problem. Like you said, such hardware should have beacon
> checksumming support. Whenever the checksum has changed, the hardware
> should pass the beacon to the host and mac80211 would receive the
> beacon just like without beacon filtering.=20
>=20
> Beacon filtering can be thought like filtering unrelevant beacons, but
> passing through the beacons which have new information. For example,
> stlc45xx already has beacon checksum support even though it doesn't
> support 5 GHz band. Unfortunately I haven't managed to find the time
> to test it yet.
>=20
> If there is hardware using 5 GHz band and does not support beacon
> checksumming, then the driver should not even enable beacon filtering.

Should the flag be per-band in that case? Or do we need checksum support
anyway? (Actually, we shouldn't call that checksum support, but 'beacon
change notification' or something, I guess)

johannes

--=-XrIGGvQYvcIhHYjilB+U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1j8AAoJEKVg1VMiehFY42IP/A9ARqT8Zjua3DhGLLDiy+ye
/vwzTE1xQ1Goii48XGWVMyMYmbAeI4wYnaTDtpM5QXcY4ZvpnXr5ueIAIv2+h3iz
lbDMafa7I1aEr88aiTm+RNCbxraICGgH6+dTmVvoPjo8irI3c3imhswUlEI+KoFA
clYpQ6TSMQhK8c+FrTVFt4y0I8eU9+UmJqTfzng82DlHPaqZtxxor5NGy0ifuCyD
F+KNNZBr//3wsTDUDUVlsR6nxxogcffhvfRmh73uIwoblc6SuQBNtdjSN8Y64Q48
y/Litlkshjwo7Q6zp+6oJYtsjX2i63rymS6JH+RZfEOS5Av9RmvKbbgpVJzHcNQO
bh34kgShxirSK/2YsTPRuLizoZUJCYyWxPYoTCVJWPHCOFI4Ktk8PTWu0Q3A/GEw
sFgnDwV9xwVSAA3zUaBpb1ga2PZbu/oudhFB6uTiHggqMeyzeTquJ0nQRcwoVj2w
OU8mSDdSKIt5xxamaf11fiV7hZafditdJoIeBEC0OyZQTUpTqF8nMYBLBQr+6oB6
RUBq9WRQajUTY5KXKrRtXCgY5g5MZxMqYT17/aHpb8PPtbGE888UQFbJW1UACPdB
IGtBnn68T4j1O1ocfM++U/0dEVqLgXv/BlUjtofbokAJJG5lUZcGqqEGLsK+UlB7
mDuJCufIt5cEivst7+RG
=y70F
-----END PGP SIGNATURE-----

--=-XrIGGvQYvcIhHYjilB+U--

