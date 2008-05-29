Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbYE2Vcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 17:32:48 -0400
Subject: Re: [PATCH 15/37] wireless: use get/put_endian helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1212092308.28403.117.camel@brick> (sfid-20080529_221900_617991_210BEC75)
References: <1212092308.28403.117.camel@brick>
	 (sfid-20080529_221900_617991_210BEC75)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R0dOR6wXDYRD9NAOjpO5"
Date: Thu, 29 May 2008 23:31:21 +0200
Message-Id: <1212096681.10109.0.camel@johannes.berg> (sfid-20080529_233252_043451_8D9F46B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R0dOR6wXDYRD9NAOjpO5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	ADM8211_CSR_WRITE(BSSID0, le32_to_cpu(*(__le32 *)bssid));
> +	ADM8211_CSR_WRITE(BSSID0, get_le32((__le32 *)bssid));

Maybe I'm stupid, but isn't this the same as le32_to_cpup? Or does
get_le32 handle unaligned values?

johannes

--=-R0dOR6wXDYRD9NAOjpO5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD8gqKVg1VMiehFYAQID7Q/+NnWTOF0a5hKOhPdFMn4Wtdmtf0PMQacm
oLqZX50zS3F0aopl4g5F8Vn4ZYNknJCyPIcWyCAk8mb1nqimxJxv6mGhYOyG6H5L
v2l/J+3KAG1okUG5nnHkx1Ewyg/1tQinft2o05bk6oLx/c5w9AsBesoZ3QG0v+3e
hGO3LH/JmmvDkkieKGN2LKPW9lsFQl7KNEoYzmcxKEOnWKe3prLy4IsmNBJboNZo
Rx/ucZF5ryWbN/QU/+/BszEqdiDzqgIhnPvPgGAnIhJvaeImwoqfNcGntCyBjv3S
H238siU7Ojocw8fwlfq15Bnj1AYoNWS3odjPc6kfPXQIVtEeA1O/q801TR3TXZmK
Clp9OamgC971ZgnWm0J+l6pvTmDmiZn8LBh9Z75Q3paqPAs3gn51+S8RbKTQfEoX
bbgAr/tb/9Ml+WnnJ2cHV2pI/m9BG0ApmwhE+Vo+uOVXf6ZkDwC//QuIV7amepXk
yedMi4Tgx2FcQNRRivrUJHbkURXdmzgQR+WZ372UYs+zpo116HJXAgrY8PjOHpwj
UwQJHZf9S/NuJlRbc4nZaUA7Q6qsC+njI2BI88GtNKaTjWPmOH50XAuUm5zvCBpz
0v2cvNwbqj/KoGqN/3fWLeyePP0Hugb8TIlM+frwa4LEdtYY2E64COhKzoy9wCrP
fnYPMIoQb8U=
=VE+m
-----END PGP SIGNATURE-----

--=-R0dOR6wXDYRD9NAOjpO5--

