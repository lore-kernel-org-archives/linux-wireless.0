Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbXHUPrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:47:03 -0400
Subject: Re: [patch 6/6] b43: New firmware file format
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <20070818234836.401097000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
	 <20070818234836.401097000@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-86GiX3Pkv9Oe41QBnDHE"
Date: Tue, 21 Aug 2007 17:46:40 +0200
Message-Id: <1187711200.4218.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-86GiX3Pkv9Oe41QBnDHE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-19 at 01:48 +0200, Michael Buesch wrote:

> @@ -1598,8 +1601,29 @@ static int do_request_fw(struct b43_wlde
>  		b43err(dev->wl, "Firmware file \"%s\" not found "
>  		       "or load failed.\n", path);

+		return err;

>  	}
> +	if ((*fw)->size < sizeof(struct b43_fw_header))
> +		goto err_format;

otherwise it oopses when the file can't be loaded.

johannes

--=-86GiX3Pkv9Oe41QBnDHE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGywjg/ETPhpq3jKURAshWAJ9thf8SIAqsST3D36nvUqBsi0Fs/QCfRDkx
ddYw4i3W3auX3pT3/C7r3xI=
=GqEz
-----END PGP SIGNATURE-----

--=-86GiX3Pkv9Oe41QBnDHE--

