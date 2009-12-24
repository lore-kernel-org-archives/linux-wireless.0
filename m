Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZLXMic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 07:38:32 -0500
Subject: Re: [PATCH 2/5] mac80211: fix propagation of failed hardware
 reconfigurations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <1261616609-518-3-git-send-email-lrodriguez@atheros.com>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
	 <1261616609-518-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-L6LdEjemWw6tLPE25gau"
Date: Thu, 24 Dec 2009 13:38:23 +0100
Message-ID: <1261658303.28729.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L6LdEjemWw6tLPE25gau
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-23 at 20:03 -0500, Luis R. Rodriguez wrote:

>  	/* restart hardware */
>  	if (local->open_count) {
> +		/*
> +		 * Upon resume hardware can sometimes be goofy due to
> +		 * various platform / driver / bus issues, so restarting
> +		 * the device may at times not work immediately. Propagate
> +		 * the error.
> +		 */
>  		res =3D drv_start(local);
> +		if (res) {
> +			WARN(local->suspended, "Harware became unavailable "
> +			     "upon resume likely due to a bug on mac80211, "
> +			     "your driver or a bus issue\n");
> +			return res;
> +		}

I object to the wording -- how would this be a mac80211 bug? :)

johannes

--=-L6LdEjemWw6tLPE25gau
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLM2C8AAoJEODzc/N7+QmakJcP/2ivdn7lBUTjOE8/i5bLh/ST
ib2rdHL18bvI6x/ooj3Rv38dxsak2b3Q4AIgV55SsdsHmDJqlZpb+bdj0jiGifoz
gg9mBexFPtzE5hwgkhMga2ihjxi5ME3bo1fLqElk4ZnZNceNs+zB8JL5RmnU8H+3
DDj2vfvqTNhTgjbBxzetC4JZnF8hlxZ10Jnvmu6PeIxDk+hEQ/OT9wq4L6KrPATK
WfadPU7zzbOofTQVZ4pc+OPxjH2sr58BB8os4tf37KgB7UDijS31fN9s0PFeM7Jz
g7svKuZPpyDLhw/cWob6+ieqmKLa+lSS38sb4wwl+oAVL0bpBPW9FjHtf1DxXzRr
GK1sqJ6WBEK6j8Kq+YDtKkxpmUYCPeTa7vwrW0AHHNYCWCw4hVdL9XmDrd8GyEzY
oaGojKBtlH9OigAegW2lsngYKRyCujHs6K5S4dyBocn9NrYKWDbYG1615SWrPwzq
V8MYCHnbPlNL7HcsmLrfHLqvSFoqRIJgxa8p/7JdALWu6Ez1qawU9utgOZzKYqjw
6G/ORoHmL+w594g42202li8KfQ2SFZ/W1zPxAOXW0nCgDQv9GJIzRLpQdWnuvV/3
Jlwt2/4bRa0Vb/z8JSyIM5wWaX/54+x6pwE5a05zbE8s37r0d87pTBYN5nSwMRn1
mtJPHDdd+ZqRQMs/8LaM
=Rm7l
-----END PGP SIGNATURE-----

--=-L6LdEjemWw6tLPE25gau--

