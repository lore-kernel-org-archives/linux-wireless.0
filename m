Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZGOOof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 10:44:35 -0400
Subject: Re: [PATCH v3] cfg80211: rework key operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247650666.14973.0.camel@johannes.local>
References: <1247051586.4755.81.camel@johannes.local>
	 <1247052613.12857.0.camel@johannes.local>
	 <1247055774.24749.0.camel@johannes.local> <1247647086.3695.48.camel@debian>
	 <1247650666.14973.0.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QZQtuJgcRo+Ub74QjIta"
Date: Wed, 15 Jul 2009 16:43:50 +0200
Message-Id: <1247669030.10754.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QZQtuJgcRo+Ub74QjIta
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 11:37 +0200, Johannes Berg wrote:
> On Wed, 2009-07-15 at 16:38 +0800, Zhu Yi wrote:
>=20
> > This breaks wireless-tools for WEP with fullmac cards because "iwconfig
> > key" doesn't send the AUTH command. Is it expected?
>=20
> I did expect it to break iwm because I couldn't make sense of the iwm
> code, unfortunately, sorry about that. But the key needed for
> authentication should be being passed to the connect() call too.

I should also note that you can now get rid of the stuff in iwm that
caches the keys etc -- key callbacks will only be called after
connecting.

As discussed with Samuel, there's a possibility to pass _all_ WEP keys
directly to connect(), if desirable, instead of adding them with the key
hooks later.

johannes

--=-QZQtuJgcRo+Ub74QjIta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXesdAAoJEODzc/N7+QmaUb8QAIGNj18UQtY7KK/MM6W9wT6/
fJD4vl4BDQ5o5SjkxMipNuBsqxTm9OKCVbhFnWLC2p4NQZ7KjFI+21PhM2BzIeTx
3jUkgdlf7IfP5+mW4KvevrNCX71Pv5kZDfuGxPRLF8vnHISBJHp2xXGzR43vZesz
Ky6FVNuCdnU0UAtztC1sp9WogKNLCSfUm0zH3xOrZ89gN4is9pCLlknslP/4ekwb
5Be4VWTT/lCxvOgCcx0KWZQhs8rFp4wXB8yYWE949pRNsxJQkwz1+LXzL6jRgxeR
5jYogDZ4UMbrFf94RFNYJWPZKFHr4pi5UKnSbKWjRrBZcPsuePC124Si9h0hYjbL
sg/wgKWEi8UF9sGqyqK/zq/WFDHtbu9dgrqvoIK8558U+1jpTHtya5QsTUIpPhg+
r864Vop2RmCrKb+FEdVLKMmIGNV4qs+gJiBlb2miX4KZ/35QXETSHN1HCBLW0InB
eWtXGhRLQJ6mzSLX/UdbhIB630W1xuPYBOMwwJcvpSbtYv9rYuQq4zuSu/GLDEFl
FwkjJ/yxiRAixVbgXNfBJtR4SLQdeA1eDQV8r6/+Yn1xIy4X2fQeGzGvxq5j4qwE
1maz8q6mul1bPzFBgunP01D31DBd8AhsOxVbcgjxOiVK5bxtF+g957qg4H74oNgR
IH/2HZApxwecLQdhDXZq
=fyYH
-----END PGP SIGNATURE-----

--=-QZQtuJgcRo+Ub74QjIta--

