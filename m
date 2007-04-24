Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993142AbXDZJik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 05:38:40 -0400
Subject: Re: [PATCH 01/13] mac80211: Add radiotap support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f5+iqN9gNnFIyiSfsSgp"
Date: Tue, 24 Apr 2007 18:16:04 +0200
Message-Id: <1177431364.3528.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f5+iqN9gNnFIyiSfsSgp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -#define RX_FLAG_MMIC_ERROR       0x1
> -#define RX_FLAG_DECRYPTED	0x2
> -
>  /* Receive status. The low-level driver should provide this information
>   * (the subset supported by hardware) to the 802.11 code with each recei=
ved
>   * frame. */
> @@ -232,6 +229,9 @@ struct ieee80211_rx_status {
>  	int noise;
>  	int antenna;
>  	int rate;
> +#define RX_FLAG_MMIC_ERROR	(1<<0)
> +#define RX_FLAG_DECRYPTED	(1<<1)
> +#define RX_FLAG_RADIOTAP	(1<<2)
>  	int flag;
>  };

Doesn't matter right now, but for the future: kernel-doc hates having
constants inlined into a struct like that.
=20
johannes

--=-f5+iqN9gNnFIyiSfsSgp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGLi1D/ETPhpq3jKURAv+AAJ9lFba+nfc+yaN/lUd0CnS1BAZU6QCfRx0g
F+1cBJBUDygIjiR4griEjKc=
=R+QP
-----END PGP SIGNATURE-----

--=-f5+iqN9gNnFIyiSfsSgp--

