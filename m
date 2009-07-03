Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbZGCI3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 04:29:10 -0400
Subject: Re: [PATCH v2] mac80211: minstrel: avoid accessing negative
 indices in rix_to_ndx()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	kalle.valo@nokia.com, vidhya.govindan@nokia.com, nbd@openwrt.org
In-Reply-To: <1246598708-5594-1-git-send-email-luciano.coelho@nokia.com>
References: <1246598708-5594-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IlQs2WUmhwqlToFUHeeA"
Date: Fri, 03 Jul 2009 10:29:02 +0200
Message-Id: <1246609742.16770.54.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IlQs2WUmhwqlToFUHeeA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-03 at 08:25 +0300, Luciano Coelho wrote:
> If rix is not found in mi->r[], i will become -1 after the loop.  This va=
lue
> is eventually used to access arrays, so we were accessing arrays with a
> negative index, which is obviously not what we want to do.  This patch fi=
xes
> this potential problem.

This seems odd -- are you or are you not saying that this can happen in
normal operation?

> @@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
>  	for (i =3D rix; i >=3D 0; i--)
>  		if (mi->r[i].rix =3D=3D rix)
>  			break;
> -	WARN_ON(mi->r[i].rix !=3D rix);
> +	WARN_ON(i < 0);
>  	return i;

If it can, this warning seems wrong.

johannes

--=-IlQs2WUmhwqlToFUHeeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTcFLAAoJEODzc/N7+QmaM+cQALFSUOfJxEHMKunlq186kRz+
VaEesvp+mCrLUyW90u6wac+mZ38q3q05DhL2+Gdc1M1XkFnbxUIERIR0lzBdjiGm
oSvUwDBY8lKKQU6b8F/omiHetnVkmUkAYi8kIF17FNpfqZJXl4joZbGwf2YkrXUv
88bc6h+kkQuH/I31HZuyzbFwVKGHN+cUVjgYAE/gbn80qG00vpmxqSGcQXWH/oPm
l/czaEqGQYMwJ0EJTfYwXgCJtpfhVKcoPFuYqu4msQAaTCQzHE+BVxHAlrF366MA
5hM6UX0RCIN9NzvC4xNHnlp9d86L3U6TqqBQGqWRxKmcBAQK7sSyxN5zjJi2c/76
tu5Qq028uJaV6PaLxNpk7UQUahRu6eFyAhJekK222XPCNzhZ1h4ZJ8XEDBxCvn+d
amfKFWFQOMvSDu5zYwy+mentdssnt3FQiEltM2IIa6k8AxiYAm9030bGWktWOeN7
47J+MvTT+/00xVgSSU+60/vvJixy7vMwgwi3PmL6BVHBoenL/1q6QUOaezofBDL1
Tp7308N45IhA+wBBTelAZdVj0QCCIWgyVC32/FaTVEdNKXO46N9Z2/0M7gu6ztL9
ih+AmYo+MmZUbR/swBynzeDfpVvXrmmjK7CoELLyfpvYlmMfm3opD6qR+KNODoir
ROtBeqFykL6wVhr7KLzo
=+yHl
-----END PGP SIGNATURE-----

--=-IlQs2WUmhwqlToFUHeeA--

