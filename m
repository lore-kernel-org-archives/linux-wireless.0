Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbYBVP56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:57:58 -0500
Subject: Re: [PATCH 01/13 v2] o11s: (nl80211/cfg80211) support for mesh
	interfaces and mesh paths
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be7703.20f8720a.1044.6474@mx.google.com> (sfid-20080222_071730_424685_4330467A)
References: <47be7703.20f8720a.1044.6474@mx.google.com>
	 (sfid-20080222_071730_424685_4330467A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HYXZU86GUuKqNJg0BzFV"
Date: Fri, 22 Feb 2008 16:57:46 +0100
Message-Id: <1203695866.7082.49.camel@johannes.berg> (sfid-20080222_155831_933711_8528D283)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HYXZU86GUuKqNJg0BzFV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-02-21 at 20:06 -0800, Luis Carlos Cobo wrote:
> Added support for mesh id and mesh path operation.

Looks great, a few minor comments.

> +/**
> + * struct vif_params - describes virtual interface parameters
> + * @mesh_id: mesh ID to use
> + * @mesh_id_len: length of the mesh ID
> + */
> +struct vif_params {
> +       u8 *mesh_id;
> +       int mesh_id_len;
> +};

>	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
> -				    enum nl80211_iftype type, u32 *flags);
> +				    enum nl80211_iftype type, u32 *flags,
> +				    struct vif_params *params);

I think we should move flags into the params struct, but we can do that
in a follow-up patch.

> +	int	(*dump_station)(struct wiphy *wiphy, struct net_device *dev,
> +			       int idx, u8 *mac, struct station_info *sinfo);

How do you use this? I can see that the "idx" is used to iterate, but
this cannot possibly provide race-free access because the implementation
in mac80211's cfg.c needs to give up the lock. I think we need to change
this to

int (*dump_stations)(wiphy, dev,
		     void (*callback)(wiphy, dev, data, mac, sinfo),
		     void *data);

The same seems to apply to nl80211_dump_mpath() and the corresponding
callback.

An alternative would be to provide start_station_dump() and
stop_station_dump() callbacks for the locking, or, something I wouldn't
really like to see, document the interface to lock when idx =3D=3D 0 and
unlock when the return value is -ENOENT or something...

The rest looks fine.

johannes

--=-HYXZU86GUuKqNJg0BzFV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77w+aVg1VMiehFYAQKW4A//SCIQdp2t93s49edOr/zBU3T5BsDdqVMq
gqT0HLo6o+IlhWoo3OXHePP4pR0AFVvg1CqhXPGQy8JgrRpZh7MJwDpM43xCz5oE
DH9Ufdqh0E6e8XNztE5JRIxF3B8h3Q+pSjXFM+I6XpNM7ja97f4e4zxyr+fBsLlR
jYGvdssANSyHWyBtwzngCYILyBzQ+DPQ73mO6IzSAfgiNatoyE5omlTgqeZ5XU3O
qNJoUb3T+MZqrvyj+LbVdCepkG8RWDgneJZVWfTIrgwPqQJg6oyBn1Vyw6dx5dYF
ELsEGRAafrYw8LRbjg6G5c9U9w8QgmC++j9zP/3sLvoU01H/7rNZCKHrXk90OtGD
OMKRdGSdN0g9NOJ2RYAf/AeNl5LYonVr2Q7ikE2crIbQI7nhu/YzhGIkHpMwlbtf
ezdhmNb3c8N0CvNB6EzeGmA/P1/SO/7IyYI9W6AkUetVNQR3pl2TYZQwxqugPHO/
ySVP6aq20bwjRbJhy+t1V2iEbv3HBtG3bWli+of6e1E2FtTA6GjxfJGIMTehVDG8
+tAA4o+m5h75ILV5rbiU0W7Naidbp+SsA5S4iLFemvwqGLzEANqinJhQo75JjIki
4EiNF6+9JNimkAGSPVf+3oeiJHwfYMMyrF/IGuYZi/mwKGlLxheAWOiEkUl/ZSD/
/VLVM43WuqI=
=hC2m
-----END PGP SIGNATURE-----

--=-HYXZU86GUuKqNJg0BzFV--

