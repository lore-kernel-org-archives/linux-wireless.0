Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47236 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0DSSdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 14:33:14 -0400
Message-ID: <4BCCA1D9.30208@hauke-m.de>
Date: Mon, 19 Apr 2010 20:32:57 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 1/3] compat-wireless: backport convert multicast list
 to list_head.
References: <1271597784-4811-1-git-send-email-hauke@hauke-m.de>	<1271597784-4811-2-git-send-email-hauke@hauke-m.de> <20100418101514.q7rwgz9zwgk8sg0k-cebfxv@webmail.spamcop.net>
In-Reply-To: <20100418101514.q7rwgz9zwgk8sg0k-cebfxv@webmail.spamcop.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD4127E40D0DBDF05B510826F"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4127E40D0DBDF05B510826F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

thank you for your comments on this.
Pavel Roskin wrote:
> Hello, Hauke!
>=20
> Thank you for doing this effort!  I would prefer that we avoid patching=

> as much as possible.  Patches tend to break as the code changes.  I
> think there are several cases where patching can be eliminated.
>=20
>> ++#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,35))
>> +     struct netdev_hw_addr *ha;
>> ++#else
>> ++    struct dev_mc_list *ha;
>> ++#endif
>=20
> We could simply use this in some header:
>=20
> #define dev_mc_list netdev_hw_addr
This will be possible, but as I see, only in some easy parts where the
patch looks like the quote above.
I will change that and resend this patch.
>=20
>> +     /* comoute mc addresses' hash value ,and put it into hash table =
*/
>=20
> Someone had a bout of dyslexia, and it will be fixed, breaking the patc=
h
> :-)
>=20
>> +     netdev_for_each_mc_addr(ha, netdev) {
>> ++#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,35))
>> +         hash_value =3D atl1c_hash_mc_addr(hw, ha->addr);
>> ++#else
>> ++        hash_value =3D atl1c_hash_mc_addr(hw, ha->dmi_addr);
>> ++#endif
>=20
> #define addr dmi_addr
>=20
> OK, this is likely to break if done in a header, but maybe it could be
> done in the C code away from the rest of the code.
I think the if defs are better than a conditional define in every file
that needs it. It will result in strange compile errors if someone uses
addr for an other addresses.
>=20
>> ++#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,35))
>> +     __hw_addr_unsync(&local->mc_list, &dev->mc, dev->addr_len);
>> ++#else
>> ++    __dev_addr_unsync(&local->mc_list, &local->mc_count,
>> ++              &dev->mc_list, &dev->mc_count);
>> ++#endif
>=20
> Cannot we reimplement __hw_addr_unsync()?
This change depends on some changes structs in
net/mac80211/ieee80211_i.h I do not see a way to reimplement this.
>=20
>> ++#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,35))
>> +
>> +     __hw_addr_init(&local->mc_list);
>> +
>> ++#endif
>=20
> That could be an empty function.
Yes that could be done, but I think it is much more clear to use this
patch here, because we do not need __hw_addr_init, because
local->mc_list is of a completely different type.

Hauke


--------------enigD4127E40D0DBDF05B510826F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLzKHdAAoJEIZ0px9YPRMywVcQAJpiYKKxRzn3rMc+Ve0E/vQF
8aFpw6isPXtxgm0ogLgsL1G2+WlB5xW+oSboudpKTmqjy3Oi6YBKJZ6OYv5QKz2w
u3RHeW5oKp/+i7wzPfk2GQ5fY0VtggpY262YKVI1Bv2oJIhhWoubybdLY1GCzaI9
4kHH4FFvIgxm2SYWv2sdlAK/rGzCMXbpeP+mupkvlrAP/5tADX8qCMqLZXNWUspk
WDR8e9W26XmpXZAOIdfBnTEwp/J9l9Ztw/+EHQyJ5rXgjmzEbWDSy+t6eUlutAVr
BI85K592iONBAWYbbUgB4Q/nku5GiqsDR5F96PMtdQOW9MWxePm0E5CtywzV+J1b
w2m1g3vXsP/78Jb/KliPOwBzoGce0zl9bG6Ski4PF57McB0bMp2QS5MTJ5YekbAs
vfzpWVGFcfjJWonU7IQyrEy7W/Kf+GODnwlkL+el8nR1I1GZLNtgnF49OJbCtjJC
2Cq9VuImNIF4OONp6dnnSKGunPxy+bUt7X3yIwTR4tQdd+rs0z+DCpNBnGCUN6CD
aIKFOVGe31XoYy/6XE9trWK4UGoK7ZfT+2r9L7yGsIoNatM6qtUrrnRy0jJckGog
idNIaZc73cK7QDhMZA3IvBcmgIwYHbUJxQkcS/1ftN8EwhP22InMrV49sNsZDBY7
oQSLiQpdfnVsNA8dx9SS
=YS5a
-----END PGP SIGNATURE-----

--------------enigD4127E40D0DBDF05B510826F--
