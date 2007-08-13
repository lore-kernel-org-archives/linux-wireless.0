Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S972257AbXHMMmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 08:42:14 -0400
Subject: Re: [PATCH 2/4] Net: mac80211, remove bitfields from struct  ieee80211_txrx_data
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	jbenc@suse.cz, flamingice@sourmilk.net, jeff@garzik.org
In-Reply-To: <2653412025907217317@wsc.cz>
References: <2653412025907217317@wsc.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QDS0UPsfdZM3iz18bE18"
Date: Mon, 13 Aug 2007 14:44:38 +0200
Message-Id: <1187009078.27916.109.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QDS0UPsfdZM3iz18bE18
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 15:08 +0200, Jiri Slaby wrote:

> -	unsigned int fragmented:1; /* whether the MSDU was fragmented */
> +	/* whether the MSDU was fragmented */
> +#define IEEE80211_TXRXD_FRAGMENTED		BIT(0)
> +#define IEEE80211_TXRXD_TXUNICAST		BIT(1)
> +#define IEEE80211_TXRXD_TXPS_BUFFERED		BIT(2)
> +#define IEEE80211_TXRXD_TXPROBE_LAST_FRAG	BIT(3)
> +#define IEEE80211_TXRXD_RXIN_SCAN		BIT(4)

I know this isn't the style currently used, but could you put these
definitions before the struct declaration? That way, kerneldoc doesn't
totally screw up.

johannes

--=-QDS0UPsfdZM3iz18bE18
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwFI2/ETPhpq3jKURAqoiAJ9TudBaJ7/wz8RydKNs9NzyH0S0XgCgi3MF
2U/c9xHgn70Ysvo21XVdnnM=
=iHUh
-----END PGP SIGNATURE-----

--=-QDS0UPsfdZM3iz18bE18--

