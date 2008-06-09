Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbYFII5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 04:57:47 -0400
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212774671.6340.75.camel@brick> (sfid-20080606_195944_782545_6A2B1449)
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-siAWduYOfliX7LmhEXnY"
Date: Mon, 09 Jun 2008 09:37:04 +0200
Message-Id: <1212997025.698.51.camel@johannes.berg> (sfid-20080609_105749_591546_826C3851)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-siAWduYOfliX7LmhEXnY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static inline u8 *ieee80211_get_qos_ctl(struct ieee80211_hdr *hdr,

I think this is wrong, the header len will probably at some point
include more things like HT headers where present or similar, so
subtracting 2 from the header len is going to be wrong as soon as that
happens because the QoS control will stay first. I think this should do
the relevant calculation itself, ie. check for A4.

> +static inline int ieee80211_has_protected(__le16 fc)

> +static inline int ieee80211_has_morefrags(__le16 fc)

> +static inline int ieee80211_has_tods(__le16 fc)

> +static inline int ieee80211_has_fromds(__le16 fc)

> +static inline int ieee80211_has_a4(__le16 fc)

> +static inline int ieee80211_is_mgmt(__le16 fc)

> +static inline int ieee80211_is_ctl(__le16 fc)

> +static inline int ieee80211_is_data(__le16 fc)

> +static inline int ieee80211_data_has_qos(__le16 fc)

Can you add kernel-doc comments for these?

johannes

--=-siAWduYOfliX7LmhEXnY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITN2cAAoJEKVg1VMiehFYuDAQAJsX2cLZZedq+IqduGps/0Gd
tq6eZxcuT/cUCA/leO3WnQU6Dk1ISbRkVCUL9rgcytkQlsQNw+sCpyBZ7IqIYHvn
oTqm/VETlK0EarHbmstcvn7r6FX4DUxZVNbxjcQGfJErB+vPpBW0U49HPSPRyabl
Q7FVgNWBd3uFoDxfsm7cPFIJ+DBFZHhZVCIWSEbhTTHsWVwtfJ/ZMqVjvfzWmVZZ
fyUpnX0HfdTf0z6PxPqrErem5eqZcKIVFweryU3qf3S46BiaeRV+Y3HqHvnDABYK
+Mc6rKYwxS0AT2s27JsQ/ZHBYw1u1Ex5q2R6GX1Rx6qhxSgjOuGbM8xY/+tPE8Cy
nylOD0f/PgGrIGZ7rMBvdFEtH989t/wpdbY3N9+hziGx7/+oz2LxMK6LBOVJPhoi
/PcTqz2ugDntWq/TdJzZND4ChsrCYnZh6rhICpjpdNz0uPTh0Vn5tEv0NDrdc/bS
Pcn7FNRPfmta4BzK6ooamFyajIjwkOV6jA+x21vL9+Khy4gTEyaTipCbDdHuafXZ
c8bRYm+2stDW1YlH9TZkbFeR99x4hptePGMSNnPAN5BDNp3mehFK+k+8qLzXEB4b
/DSY51R/us1I8R1etA6MvhULH8p93xudvmWRHC6HMeTZhPaumdGj6G/mTe48hXpU
r/vOK0EOVUazaCfXGxlv
=fvWC
-----END PGP SIGNATURE-----

--=-siAWduYOfliX7LmhEXnY--

