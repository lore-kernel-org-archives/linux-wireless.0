Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbYBYTJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:09:49 -0500
Subject: Re: [PATCH 17/18] mac80211: mesh hwmp locking fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203966549.6929.4.camel@localhost> (sfid-20080225_190733_174041_A31E50BE)
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142017.846789000@sipsolutions.net>
	 <1203966549.6929.4.camel@localhost> (sfid-20080225_190733_174041_A31E50BE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WoXSkF3b7qrzhqHfpCn/"
Date: Mon, 25 Feb 2008 20:09:41 +0100
Message-Id: <1203966581.13162.129.camel@johannes.berg> (sfid-20080225_190953_376111_176B82D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WoXSkF3b7qrzhqHfpCn/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 11:09 -0800, Luis Carlos Cobo wrote:
> On Sat, 2008-02-23 at 15:17 +0100, Johannes Berg wrote:
> > This fixes missing unlocks noticed by sparse.
>=20
> Thanks for the fix. It would be easier though to just acquire the lock
> later, since rcu_read_lock() is no longer needed to look for mesh peer
> links, like in this patch (applied to the original version of the file
> without the patch included in the mail I'm replying to).

>  	u8 action =3D mgmt->u.action.u.mesh_action.action_code;
> =20
> -	rcu_read_lock();
>  	sta =3D sta_info_get(local, mgmt->sa);
>  	if (!sta)
>  		return 0;

Ah, but sta_info_get will require rcu locking after a few more patches
so I now that I posted both sets this is easier (otherwise the sta info
rcu-ification would have to add all the code and revert this patch)

johannes

--=-WoXSkF3b7qrzhqHfpCn/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MSdKVg1VMiehFYAQJJOQ//TY3p+p1X7h2w3OsbvhL5mhUk5R6OLrR7
ER4CFhbmsTDvf/bMm70/iNgd6C/K38zqYFADoYFB+/Eph5OV/SqiqiOsE0TVnjrn
WbhFTWkfV0C9igjTbx+hIS1iHrZDVUhpxg1WAqtPkbN5TLh4mZndW7hwzXb7U9P+
pVdCz8+YXuhknzRm+H+5WI8atAh8MtxWAVL+jBx13EFrO3q/xcoKV0Nox+GsR8+V
+7cWw4qVyXzgSBguE723RhextPVhkH3smJwxUNNTfy0c8lkQ0HupsjMVX8P9KLuZ
QXa4DTq33HVPk1rMIWJHwJnuG41YoL/j8rkVlUF+x3lep4vl+Ojx7OC/XULEiilj
Ah1xt7Tu3zpvYDNNM8HRdl0adzJoHXOf+SosSZ9f0i81/O6o4opQIz9/sa+yfOsf
+wyBVNVD74K1zron/tr5b20ueQQ/Wpr4Z1Zu5RxDo6udKpNpMQM8xPxV2nXzchtm
jrbNSVE6N8qDHuDAW2AzbOU0de72Gm2s6vvb8D0I0lA34BDqYCVd0Hawlqhy20Yq
D+7xInv/lF9pHvRx8w9X2D1Asvi7MUh6Va3SHuK//AuVusYJOcXpjtSAR5JO5+sf
Q1/91qGtyRmlVnAV4gmmi/Umsk9JVJB9Mjtlv4I5PaFFVshRbz/lVIruNZkcwMqu
KjOX6CP3gLA=
=cMA1
-----END PGP SIGNATURE-----

--=-WoXSkF3b7qrzhqHfpCn/--

