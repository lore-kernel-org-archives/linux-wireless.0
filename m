Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYJ3Kmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:42:53 -0400
Subject: Re: [PATCH 1/4] mac80211_hwsim: Debug info for BSS config changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081029175220.543918201@localhost>
References: <20081029174934.817700763@localhost>
	 <20081029175220.543918201@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XepBnIeH/n6rXLxXiAZ7"
Date: Thu, 30 Oct 2008 11:42:47 +0100
Message-Id: <1225363367.3690.17.camel@johannes.berg> (sfid-20081030_114257_791093_84883B6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XepBnIeH/n6rXLxXiAZ7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	printk(KERN_DEBUG "%s:%s(changed=3D0x%x)\n",
> +	       wiphy_name(hw->wiphy), __func__, changed);

Should we print the wiphy name for each line below too so we can parse
this more easily with some validation tools?


> +	if (changed & BSS_CHANGED_BASIC_RATES) {
> +		printk(KERN_DEBUG "  BASIC_RATES: 0x%llx\n",
> +		       info->basic_rates);

That'll need an (unsigned long long) cast.

johannes

--=-XepBnIeH/n6rXLxXiAZ7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCY+kAAoJEKVg1VMiehFYJxkQAITVzAZujbhZGjwhRogsaItO
kC6kZD4y2aFIFfjj9/3tYGD2E1pghVCAHM1z69TC5o2U7dNtvDN+CNQcfZRt6Xhb
/js2kzBLtmN24iFhNDkZ0aX2EL6OW7Fmiy94E03NRyX1KgGiVq/NRDoOgmEWhpN7
hQsUmJAdmuGIZuAMxl74lg//MNT46Hc0vZ+ZDjiZR8pqZ5wp+jCa/SVFytTVHQHV
iEf+/vvry5hd4xnupRtMxg7qqDVCzlwzAO1NQKmMAc1D/YOqVwDLTue465lie2hw
K4kYVx9YYIHmPScEiNDdY9mqeNH7Cw5XKapuDmarDCgweYhNjxfgpQCnCIxUighK
Sk2LrBgjcQzh+Ghh0+VeBBMV971V/zMef15dqU+UgLIkiG4b7JN1gr048nIs6yOX
tW7quct28jYg1NrSMm4evWPzDn5lJ6Z8KLeK2LRzXtvRqy7tz9dB3mCKCYazkq3u
E8LvCUziIIucwl9RADUFCY5SNs9lAlFOIdSnTaJF9yJRQCIt3eaNS4MzlrZIJaUq
nwSepdPFu29URXbDy19cqp7W4bc/Ve6nghVQPt8/MxexQjSl0pfJQaU7Sj2DXHUG
XeoiNW1inoJhrMIGQdOCxjYuXuOgsLf9tEwbbmLfwm9aHROEziJVFk/io+6IKWFT
wKzJwSKKuWKyYmVNCQWx
=clQ5
-----END PGP SIGNATURE-----

--=-XepBnIeH/n6rXLxXiAZ7--

