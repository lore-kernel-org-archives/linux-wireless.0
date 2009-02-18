Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZBRIgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 03:36:06 -0500
Subject: Re: NetworkManager and mac80211_hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	networkmanager-list@gnome.org
In-Reply-To: <20090218080636.GA25504@toronto053.server4you.de>
References: <20090216160016.GA29509@toronto053.server4you.de>
	 <1234800284.4219.136.camel@johannes.local>
	 <20090216172528.GB29509@toronto053.server4you.de>
	 <1234807251.1666.9.camel@localhost.localdomain>
	 <20090218080636.GA25504@toronto053.server4you.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OUVrBJdC13nnWoRQBwFE"
Date: Wed, 18 Feb 2009 09:35:59 +0100
Message-Id: <1234946159.4149.0.camel@johannes.local> (sfid-20090218_093611_904317_C90898B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OUVrBJdC13nnWoRQBwFE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 09:06 +0100, Daniel Wagner wrote:

> +	if (parent_dev !=3D NULL) {
> +		hal_device_property_set_string (d, "info.parent", hal_device_get_udi (=
parent_dev));
> +		hal_device_property_set_string (d, "net.originating_device", hal_devic=
e_get_udi (parent_dev));
> +	} else {
> +		hal_device_property_set_string (d, "info.parent", "/org/freedesktop/Ha=
l/devices/computer");
> +		hal_device_property_set_string (d, "net.originating_device", "/org/fre=
edesktop/Hal/devices/computer");
> +		hal_device_property_set_string (d, "info.linux.driver", "mac80211_hwsi=
m");
> +		parent_dev =3D hal_device_store_find (hald_get_gdl (), "/org/freedeskt=
op/Hal/devices/computer");
> +		hal_device_property_set_string (parent_dev, "info.linux.driver", "mac8=
0211");
> +	}

This is actually not _that_ bad an idea, because it makes sure everybody
else will properly link up their parent pointer in sysfs. An alternative
that doesn't guarantee that would be to check "is it in the ieee80211
class".

johannes

--=-OUVrBJdC13nnWoRQBwFE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJm8htAAoJEKVg1VMiehFYEe4P/0RobjJkmRdPdwQAuAsShzXP
tg4OEd2ib46Pd+ATo/3L+GP4PqLemBnbB7+A/bp/kIbAd/zhVyAQf3FiLy2N3ySh
bgx7+8zjBEWeCZsGzqlgUpiAn+7ljJyiLCBbfc1xmtroin0MY8Z626bxtZTrFj4Z
1/od9hQn1qDPPs0FY5I7QuL2CRRwfrHXRQmLeHcJ3TxRYV1kziQgkbd3o9AxBUG+
MwRG+ppJg3ZWwhkmPkVPdVuR3h3xCn+BtXltT2CTfF1B5+RMTUKWTPH6SlOQ/pZQ
wwlzg+MudHp2gAM6NnGYDV0PEyOu6sZF0XoknFH1uDwHUNM/FYkyGMmrw7RYhEw/
GQks1ZiLDsIAgElhF7nTv2IyWIyW89z9cz88le/ds+sCYkT5a/47GuAG+Ad8hS4K
RNIzzSXQ+DUPNBaZp+kZFsE2uoRf3aHon/6lR2iZUmhLMhV6RSCi/2NbbCR7hw2y
u+txeKeMu8y6z/OT1NMUtovTYuHSXbqZv0aOBgZ6zG0dZvWwldWYh2EKFFq0d9o9
KmhJoUO0jlK187WDGpUXltI+groMv7aXxD6mf4IoMZM6v9mUZJi81kLow1GYG/vv
8R/zcGI4YJtC4pE4jNvGfx/+rYvIgZqJfkuQw5Hjxup+XvVEkomou/kH+69x+7kt
gbiUWTwvfEfjk+vc7k5E
=z0vH
-----END PGP SIGNATURE-----

--=-OUVrBJdC13nnWoRQBwFE--

