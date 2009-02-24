Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZBXB6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 20:58:42 -0500
Subject: Re: [PATCH v3] mac80211: Give it some time to do the TSF sync
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090221231800.227280@gmx.net> (sfid-20090222_001831_559891_2537405E)
References: <20090221231800.227280@gmx.net>
	 (sfid-20090222_001831_559891_2537405E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ImSkBYh5xR4MxPW06X0S"
Date: Mon, 23 Feb 2009 17:40:33 -0800
Message-Id: <1235439633.4455.33.camel@johannes.local> (sfid-20090224_025845_691280_E5FA0FED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ImSkBYh5xR4MxPW06X0S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-22 at 00:18 +0100, Alina Friedrichsen wrote:
> Give slow hardware some time to do the TSF sync, to not run into an
> IBSS merging endless loop in some rarely situations.
>=20
> Version 2 adds a comment.
>=20
> Version 3: I had forgotten to change the bracket.
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 1bbfc70..ea737bf 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -332,6 +332,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_s=
ub_if_data *sdata,
>  	       jiffies);
>  #endif
> =20
> +	/* give slow hardware some time to do the TSF sync */
> +	if (rx_timestamp < 0x400000)
> +		goto put_bss;

Please elaborate on what this does. This uses the assumption that
reset_tsf() makes it start at 0, and that then the hardware won't sync
up until N seconds etc. I'd like that to be spelt out here, rather than
having to think about this when reading the comment.

johannes

--=-ImSkBYh5xR4MxPW06X0S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1APAAoJEKVg1VMiehFYmCgP/i/+Z0cwI0Wu8J0bO54Qkt1L
m74lKToRVeozh3Hb4ES4PLw1VoAdGsE7CqmYUpRwbUumaIBLQI4fxBkpaFU3SO5E
Tn0suG0tAJh+1HLMVbPFOW4FR2+EuD7Q6jmfly4Xnlh3H190ND4D6iw62gG9aMsk
1RjQ713qd9cby6Xk4JDTUs3k5XQl0ta835f1XvvEv12YSEs+P3dVfM5gXseLcYOA
PO2RqaiqZuvXhkUgYV7Qh3PF/Cs0Us7dOMngsFmEMSJxRDPfALuYkrvOKdsTcOsc
eqOkGdDKGwJjuXr9dCiKH6qxOdnBxdSFg0UJ+gI5gVJskZSR2+xQ4JM+DpAxrx4j
AJES2Vy2D0ftiLqB4na6XWRzXeLGo5ws9wTZUTtqysrVA6ZK/Ppbtmd4IzFKdp5s
rSoOKoKVi9/ZHzd05gSxhjX42X1CkzcGgUTL+NAAk4BG3Spre99wsuAvrpCRgscX
MBXLLIJ5Hl/B3XsUY6D3rBy4sCRRHiXwf6j/2Xo9D76PIgbj3OycuceTCEjX1m+B
ro9exFeJJCVqR7EZOPQZVYk6XbrykFy79W7JzZlf12DegTEIifSUqLDtfs3HMFmF
KnGryQtGYazRgeZ2P0LN3GRmTeY0/peYkk/KxN1iX5BWYtkFStRwMNpPScKqLjGv
veN3KEc0HE0zI7CCs5yp
=l3Ye
-----END PGP SIGNATURE-----

--=-ImSkBYh5xR4MxPW06X0S--

