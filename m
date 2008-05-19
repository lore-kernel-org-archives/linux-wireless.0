Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbYESOLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 10:11:12 -0400
Subject: Re: [PATCHv3] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200805191541.49313.hschaa@suse.de>
References: <200805191541.49313.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uga4l+Aui02nhGGjPnTF"
Date: Mon, 19 May 2008 16:09:54 +0200
Message-Id: <1211206194.6252.43.camel@johannes.berg> (sfid-20080519_161115_486682_A38BB267)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uga4l+Aui02nhGGjPnTF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +		rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);
> +	} else {
> +		rates =3D ~0;
> +		rates_len =3D sband->n_bitrates;
>  	}
> =20
>  	mgmt =3D (struct ieee80211_mgmt *) skb_put(skb, 24);
> @@ -755,7 +759,6 @@ static void ieee80211_send_assoc(struct net_device *d=
ev,
>  	/* all supported rates should be added here but some APs
>  	 * (e.g. D-Link DAP 1353 in b-only mode) don't like that
>  	 * Therefore only add rates the AP supports */
> -	rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);

Mind moving/rewriting the comment to indicate that at the place below
the rates are added, but putting the comment about the compatibility
thing to where the function is called?

johannes

--=-uga4l+Aui02nhGGjPnTF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDGKMKVg1VMiehFYAQLhWg/9GUjX/XYddgqo6Tthir8W3l5PJvpNvqNk
5HS1rGmfX/FRBNpoiXyICesLF4ZPL06GsQ3I3QjClFmeK0dHFRTgVhLspv9bvPch
Q/bdEjStvgTb7wXvj/YaEHv+PcKHjLAjH5qaHVY30T0crbsCM/LABFSCOmK+Dt/l
im0sM/l8OoYvKfVJbBZaT1ijF0qTSDunpAwOuAPfEf2s5zd4DLmBTcQrt0Gt3TCk
HzIT2+bc+OJq/6SITZpygsnYS34vU1xIOhMDu2inEr3OCA5ekD+vIVwe2MC4B/bX
6sIjDUn3a+5jt1flB/LAs2bK9u4Ywxsd9fDMneFJlwq299if3kxnG6t/B1DnqfDW
oPkFV2AtpOgH0k6II8C5FCM8OretVjD4jkj5T0q+3PDLnpKI4d3if/eG1z85OChw
QaDK2q0h2ZgUr0nXSKTfPdzmgVTn08JLlwCQXXj9ltjC9sfWQs9YCAuCj0aN3JvU
/UXSR9JJFT951b+ZEEcO5cFaenmo6Z/EPtCscrJYHMLzhFwZfdlw7EKa0vJy8w2k
GmxIx93TIu90nhwVF0JcJ6VWHMD7W3KH6nugCi7Y0GeInxy2zxhrPDxZS/LS3bwA
CpvyrWy6dpI4u+hyxjPqEI5mLzHiuw6w5XbJya+QvMnUq2aTRj7vAJYovTyMRkFw
cOUEHBDwg6Y=
=Lq9P
-----END PGP SIGNATURE-----

--=-uga4l+Aui02nhGGjPnTF--

