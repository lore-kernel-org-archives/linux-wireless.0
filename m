Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbXL2K0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 05:26:14 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200712291121.31120.IvDoorn@gmail.com> (sfid-20071229_102122_537113_95530FCD)
References: <200712290942.37396.chris2553@googlemail.com>
	 <1198922056.4172.25.camel@johannes.berg>
	 <200712291121.31120.IvDoorn@gmail.com>
	 (sfid-20071229_102122_537113_95530FCD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uGrFjlDNY7qRyUeB8ld/"
Date: Sat, 29 Dec 2007 11:26:00 +0100
Message-Id: <1198923960.4172.31.camel@johannes.berg> (sfid-20071229_102623_227884_531E83E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uGrFjlDNY7qRyUeB8ld/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If it helps as reference, rt2x00 allocates and initializes the data as fo=
llows:
>=20
> 		skb_reserve(skb, NET_IP_ALIGN);
> 		skb_put(skb, desc.size); /* Always a multiple of 4 bytes */
> 		memcpy(skb->data, entry->data_addr, desc.size);
>=20
> Should there have done more for the aligning of the data?

Well, typically, an RX buffer is comprised of the following elements:

 * device-specific RX header [typically fixed length]
(* sometimes padding)
 * 802.11 header
(* sometimes padding)
 * 802.11 payload

The problem is that the 802.11 header has variable length. I explained
that previously, please see
http://article.gmane.org/gmane.linux.network/78792

Maybe the reporter here has received WDS or QoS (but not combined)
frames for some reason in which case the hardware has to insert padding
somewhere to make it work.

johannes

--=-uGrFjlDNY7qRyUeB8ld/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3Ygt6Vg1VMiehFYAQJ8FBAAn4P7ghg4RNE5KTuIgMdm2GV9jRNzgeXd
sZZ3lSb/WkqGzKB7qtZwiOXFZscAveLGcQGjeWl2H8ndNzSBwxlcdLJs9edePJ4/
bCXN766vxTFGgqXMzw5UN297B/GdkF8qzxH7B7Ia49gc6wgKoQ6qf0SltziuHo6Q
/QxasM5UsoxZ/+apcrS6/0SZWyLaaPuPvre9x5OMsyncYzS1DrAnc9VLoLXsh82a
Wq0+Px8YR3fpMPwvP2m4e5MsM3bx9DtcWX7KkNbbif7NMyJrZpfY8k+orYxbAzRK
t3YPk/UeKOcJzM5XH8qlE7rmEUKyYfhJT01eECckbGXO6Owg2OTsch8Dyk1ZynwF
D6OF29IrpVk1RdqvLzlOggVMGW+pNMgGJTsN1XgbvlAG4Y5KLupUL9de8AD2Ed45
Hw3Jk7uk6qI+a8UlkMTyTwEsny3j3+MeuwDkwJFQJcd53gK40HgRrbYaj0iwp4L6
vZ0K8FUTsVrymMkivR/ItoHLcDY0bZS0w51ZkLoBRLKLwPboqla5RFCIb+1xSfLc
eEY6cIZuPBt4Ht/MOPJSA46PMNLG64J+mcRhbgqPIRmZTpZsDR7C/v9TkiFtlZ7T
C5UsPHIyk1Xw9NeeURWtK8/FTeySHCxa6qzNCsPEmouivgkh7b2ZwQoJCn7Wn7t4
/xqjOUE1KBc=
=/m1u
-----END PGP SIGNATURE-----

--=-uGrFjlDNY7qRyUeB8ld/--

