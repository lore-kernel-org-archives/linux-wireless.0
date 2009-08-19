Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZHSHbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 03:31:19 -0400
Subject: Re: [PATCH] cfg80211: allow cfg80211_connect_result with bssid ==
 NULL
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1250663378-9113-1-git-send-email-yi.zhu@intel.com>
References: <1250663378-9113-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CtagACjrrcI1FZlRAzWZ"
Date: Wed, 19 Aug 2009 09:30:45 +0200
Message-Id: <1250667045.16393.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CtagACjrrcI1FZlRAzWZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 14:29 +0800, Zhu Yi wrote:
> In case of connection failure, the bssid info is not a must have.

Good point, thanks. In fact, the original __cfg80211_connect_result()
did handle a NULL bssid, but the event stuff lost it. I think you should
also pass NULL in core.c when is_zero_ether_addr()?

johannes

--=-CtagACjrrcI1FZlRAzWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKi6oiAAoJEODzc/N7+Qma/kQQAMosJo4PHHsYSzh58ZboKeT8
8U3nks2VDsv+605pmvGwk2j1uHENwgMN4K9jlUTPvp/HzCDbNIq6Dwg6wI/ZoJWg
4tfaib+JJiI28CexlNCJAlE4LSiel5N7JYgdK+JOk4qMKy9Lub++lzBwwPkBCkt8
K96IWXHH0TRljyELwyHBy4MahYFQ3v4izfcn24ESmj5VxOtUVJgh+XIJ38byUKTN
RZAh0aJhnChJZoMaxaUUGQJNY3Xxgg7zySNFbHbyfWQeMFYOhHccU/FOnUIfG/5R
Szbb088+gNtaYH4ZQHWijRuiwOCMTSqQ3v4NUbjM9AZO0O8A+CjfGK3d32Tm5JHu
BnWPf9ED5AeQkNckuxOyhog91T5nsscf2AI49Fuu5/nKfNwxYlxEWQk/yekiTV0r
YDOkYz8ysld/yT9gXG8qP07kwh4lQcvS+MKlOyp999gCA5nNgsxom7VQNSPYqkgK
gI4JLbqTOPJSuD5t5Uw/1+3+LHHJiIgbG6FuqA3OfLrRvWbEHx0J/Ah1V48vHMfE
dHTif3rgtN+hvUZ8LkUGt9iBIka3DCX1N6m+icsJcydsAr46MvDUV0qJ/uYfTXTO
z6T20Ov8plBlOpa39vfFXnjTeOsY0dSgH20aQYwUesihglwnSvxEL32qwT2PfIZr
d6IiWLJH1HjWOAVJsJ6b
=gRtw
-----END PGP SIGNATURE-----

--=-CtagACjrrcI1FZlRAzWZ--

