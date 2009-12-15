Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240AbZLOSH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 13:07:29 -0500
Subject: Re: [PATCH 2/5] mac80211: Add new callback set_coverage_class
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Turek <8an@praha12.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1260899813-17585-3-git-send-email-8an@praha12.net>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
	 <1260899813-17585-3-git-send-email-8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-krd/pGzQTwRvBRX9gtJG"
Date: Tue, 15 Dec 2009 19:07:20 +0100
Message-ID: <1260900440.10356.56.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-krd/pGzQTwRvBRX9gtJG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


> +	if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
> +		if (!local->ops->set_coverage_class)
> +			return -EOPNOTSUPP;
> +		local->ops->set_coverage_class(&local->hw,
> +					       wiphy->coverage_class);
> +	}

You should have a drv_ inline wrapper, tracer and a might_sleep() in
that.

johannes

--=-krd/pGzQTwRvBRX9gtJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJ9BUAAoJEODzc/N7+QmadP0QAKaYWxzxUsgBmmjqFjVNivpV
DpqN6qBsdJXJBlz7q9SlgtzY+RtLekMye3QktejKgrSYTau0dOEyYRaV5U/TYjyI
4bXfO7BGDOOl8MQLEOKJh5SADdaLH6wyafwV31ptz2i/1Vgtps5hUoTD9IY6T5vV
/RyMHePPBjzcFXU8ujuG63fHcTjqoQLhTakhDkvtzmp2udJSwXrrKb94uOrjt8u6
SXrvF93rQMd2Ec+QJ61puzFe+KXlpudjGPlLlT8WSbWIgt9WhMRTDTa4I8B+rCTn
nBuk9FhQWviSCSaDOSoZayL2Cs/Wx1PAIaLlhMj9BOatymAKPwcOCYLiiB0BbofA
aS0EnyM2Nl/LuMGgMVco+TU5l/U0hiuNDTIRLwtYOCc9qSUu8sBmYsMUu4iA1mIA
amDZltd+3BV+IOp02uAhabuAivA1OwTMBez7g6a4RRmQex7Muy8hIffcJ8V3KqOl
OHsInBxnIk7oOHNSSaJb+AZdqHuxR9vgsXwG93y5BskCfHZBNlQA7txm4/1xfmX1
n3uaN3R3I9/fhmmoDTk3YCEybUuV628WyfwGOENzo9Ql4lNJM1NagL9HAh87m90s
usNZW0LjKWy6275OULmoumBHnHw2rYAqs7hLKxFhLBDtwEodQIbmKkYD0V8YpLuS
70HGv9a/McmlOOgwsugt
=poH0
-----END PGP SIGNATURE-----

--=-krd/pGzQTwRvBRX9gtJG--

