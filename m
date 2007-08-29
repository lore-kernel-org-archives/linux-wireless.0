Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXH2Ihs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 04:37:48 -0400
Subject: Re: [PATCH] Fix breakage on WEP for cards that rely on software  decoding
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <adam@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708282345.53016.adam@baker-net.org.uk>
References: <200708282345.53016.adam@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MfkuovwS095I74CUk4jk"
Date: Wed, 29 Aug 2007 10:39:24 +0200
Message-Id: <1188376764.7837.152.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MfkuovwS095I74CUk4jk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 23:45 +0100, Adam Baker wrote:
> The test to drop out of ieee80211_rx_h_load_key if we don't know the IV s=
hould
> check if the packet has already been decrypted, otherwise we need to load
> the key to be able to decrypt it


> -		if (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV))
> +		if ((rx->u.rx.status->flag & RX_FLAG_DECRYPTED) &&
> +		    (!(rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)))
>  			return TXRX_CONTINUE;

Huh, yes, this patch is correct, I just never noticed because my later
patch changes it again when introducing the per-frame INCLUDE_IV flag.

johannes

--=-MfkuovwS095I74CUk4jk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1TC8/ETPhpq3jKURAkG3AJ9wNBV++27Wqpg4PeqlUv+vm1xtUACffCES
29YdPRYDl5md7LoEhOeOZa8=
=zNl2
-----END PGP SIGNATURE-----

--=-MfkuovwS095I74CUk4jk--

