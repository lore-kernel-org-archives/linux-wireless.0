Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZCRJeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 05:34:11 -0400
Subject: Re: [PATCH v3] mac80211: don't drop null frames during software
 scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20090318092507.17198.83588.stgit@tikku>
References: <20090318092507.17198.83588.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6rX9WzbGH4datXFVZU0R"
Date: Wed, 18 Mar 2009 10:33:30 +0100
Message-Id: <1237368810.5100.15.camel@johannes.local> (sfid-20090318_103414_377657_707E5AC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6rX9WzbGH4datXFVZU0R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-18 at 11:25 +0200, Kalle Valo wrote:

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 457238a..525d261 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -193,7 +193,14 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data =
*tx)
>  		return TX_CONTINUE;
> =20
>  	if (unlikely(tx->local->sw_scanning) &&
> -	    !ieee80211_is_probe_req(hdr->frame_control))
> +	    !ieee80211_is_probe_req(hdr->frame_control) &&
> +	    !ieee80211_is_nullfunc(hdr->frame_control))
> +		/*
> +		 * When software scanning only nullfunc frames (to notify
> +		 * the sleep state to the AP) and probe requests (for the
> +		 * active scan) are allowed, everything else should be
> +		 * dropped. See ieee80211_start_scan() for more.
> +		 */
>  		return TX_DROP;

That makes it sounds "too correct" to drop frames it seems. Should we
say something like

	... and probe requests (...) are allowed, all other frames
	should not be sent and we should not get here, but if we do
	nonetheless,drop them to avoid sending them off-channel.

Or even add this link:
http://article.gmane.org/gmane.linux.kernel.wireless.general/30089

(you also forgot to s/null/nullfunc/ in the subject :) )

johannes

--=-6rX9WzbGH4datXFVZU0R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwL/nAAoJEKVg1VMiehFYjjoQAIfb19XUiIDc0mnpnt2iatF2
4YCyK26mEpzfgG9QgTqzfnWnsj7eik0dvFu21hK91kd4muJ0WkNtpaa7C/cH3CxP
DNqEXczKXKW14FN6n6IwkemhUz7xz08EKtde1otUrIQSy+lYALhYrdApt+qKQs1/
1w879gLouH6GiQejuGBn7+0R8Ebcl0fYUUNVs5WgnlHy2IZl+E/mq45oXBQ8eQ3x
gerohJuG84a2Lqz+VHwGJlDUD7eiC6kAKTVlr/oR/HrIi3Jr1+iscjL7EdV1RwrC
EHq5SVs5jJIWwS64w802pHK/XDnq+yFgDWSWnrgDP9OwjILt9VsPRMmfyfbqpl+6
u9l/sQ7IPpt3vJELq/BmNrykcACx3jYoHSNp+c+XHUuOsLoTnPjlE3cVzvbAyTel
4F2SIb+PjxYXM8GSR6PlM/Tf3dXia3kRhWRLT/4/P7SMcG8SCLSsuCJADJYpGe1e
OsFNvWaynTNWVAHWaCmGD80N7bmIcL/xbF2gVi9wz3kZ6m1Uj7EXAubUzHTq9jQY
7fjAykdmi55SlF5zwm7ZX9/rkUf2I86s4K9nnqy7AM9TWcFwWQUDtib28TC4RS4H
rYdzRaFW8RPHPTIb76D0XU83e8ILvrP+L6LH3XJpHEXVp3NmzH4iX42183dJA2Z/
Qk8yD9vbbxYG3OBVQh/G
=aq+p
-----END PGP SIGNATURE-----

--=-6rX9WzbGH4datXFVZU0R--

