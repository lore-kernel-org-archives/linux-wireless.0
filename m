Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYFYTeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 15:34:04 -0400
Subject: Re: [PATCH] rt2x00: Fix lock dependency errror
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200806252127.00971.IvDoorn@gmail.com> (sfid-20080625_212601_184149_3694A8DA)
References: <200806252127.00971.IvDoorn@gmail.com>
	 (sfid-20080625_212601_184149_3694A8DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WdE4ZwMeYXbEMor46czP"
Date: Wed, 25 Jun 2008 21:33:20 +0200
Message-Id: <1214422400.21847.54.camel@johannes.berg> (sfid-20080625_213410_986375_BE44EC73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WdE4ZwMeYXbEMor46czP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/=
rt2x00/rt2x00.h
> index 611d983..73dacbb 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -821,6 +822,7 @@ struct rt2x00_dev {
>  	/*
>  	 * Scheduled work.
>  	 */
> +	struct workqueue_struct *workqueue;

Do you really need a whole workqueue (kernel thread) per device? I would
think that using schedule_work / cancel_work_sync for this task and keep
using the mac80211 wq would be sufficient?

johannes

--=-WdE4ZwMeYXbEMor46czP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYp19AAoJEKVg1VMiehFYZdEQAKyP06IderN/i9vv+OtJ3QX2
r1ks0W1eM0pJyyDyJbmvjgIfqpqQ//yVZZfgsvkR4C433A9VaMlxzC51hVvhMEe+
qtvF5Vdzr0MLQd8iP16hNLlvRMOHZa9i+EbCvFMp/94Cp09lZXr9uTyxOdcdXAz7
hgkl72/JCoFNGNztmw+fS5YBwCWb3F/LuNEI0XqdBEuhvjYs+Z3l48s57YnPfMrK
UIjFRwwTsdumvpMUVNb0sDybRcMip3uld+2R3f+nJjKubD65Fe6sCzEPt2ntdy3J
sUgo4G7KWgVASF3lXciM3dkPl5gU/UGUlQZO1OX5ZBRZ+Rcu1QXDileAwjRBNFiN
IUrgWd50t8ldlNG7AEjmqGmE8XqdY7dVpAP83xtWf2kJvszkHj7WrP53qp/8R2nV
XXmXEWvjMl8GgeLA66Qhkzo+LWfeppyXdUAk6xQiC17T7x9SyLcqkCTPk00DnbRe
T2zFeceGfnaSVOZwx8aGiJTCILIXctrZ1YdCJ3gRbzcQtxnDtyO7wMfWQwns/bof
usO6U+svGs0Ky471i7Iu/xoDlqFhcgbT5el4DDPmKftRU5Iz++aE5bTObOuPeRYJ
iCAs4TAjsxNrneh89NJc/7t3zRv8Y/IkDDAoSoLpqIdbIUPSRcAYSggwrsrSIaRo
KIRUubV4gv6XQ5Z1NxTO
=HF5K
-----END PGP SIGNATURE-----

--=-WdE4ZwMeYXbEMor46czP--

