Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:50360 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbXGRGa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 02:30:26 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rtl8187: ensure priv->hwaddr is always valid
Date: Tue, 17 Jul 2007 23:29:14 -0700
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707151709.55429.flamingice@sourmilk.net> <1184578463.3773.1.camel@johannes.berg>
In-Reply-To: <1184578463.3773.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4704670.h3uPVh99L2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707172329.18516.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4704670.h3uPVh99L2
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 16 July 2007 02:34, Johannes Berg wrote:
> Do you allow monitor mode? If so, this isn't correct unless the hardware
> is explicitly told to not do anything (most hw doesn't and we use a zero
> mac addr for that). conf->mac_addr is NULL in monitor mode for a reason:
> we don't want to have any mac address so we don't ACK packets.
>
It eliminates a NULL pointer dereference, which is a bit more important tha=
n=20
accidentally ACKing frames. I do not have time right now to put together a=
=20
fix better than this.

=2DMichael Wu

--nextPart4704670.h3uPVh99L2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGnbM+T3Oqt9AH4aERAsx2AJ48FK+o3+/R9Ilr+GJsky4iHtPTaACfX+4i
Dbo/w5TeaBQ52sQ3/uiPCAg=
=pFLw
-----END PGP SIGNATURE-----

--nextPart4704670.h3uPVh99L2--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
