Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYGHV3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 17:29:40 -0400
Subject: Re: [PATCH 5/6] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215550044.476.43.camel@brick> (sfid-20080708_224734_565441_65F98FD9)
References: <1215550044.476.43.camel@brick>
	 (sfid-20080708_224734_565441_65F98FD9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nTmZrAeCDymbTKSGs72j"
Date: Tue, 08 Jul 2008 23:28:54 +0200
Message-Id: <1215552534.3670.20.camel@johannes.berg> (sfid-20080708_232943_192232_684A4021)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nTmZrAeCDymbTKSGs72j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> =20
> -	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> -	case IEEE80211_FCTL_TODS:

> +	if (ieee80211_has_a4(hdr->frame_control)) {
> +		if (unlikely(sdata->vif.type !=3D IEEE80211_IF_TYPE_WDS &&
> +			     sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT))
> +			return -1;
> +	} else if (ieee80211_has_tods(hdr->frame_control)) {

I don't particularly like converting a switch statement to chained ifs
in this path, you even put the most unlikely one first. With the switch,
the compiler should be able to generate just two compares for each path
(binary tree), while with this the common STA path already needs three.

We could instead open-code the binary tree that the compiler should
create for the switch, I guess, i.e.

if (has_tods()) {
	if (has_fromds()) {
		// a4 code
	} else {
		// tods code
	}
} else {
	if (has_fromds()) {
		// fromds code
	} else {
		// none
	}
}

but I think the switch is more readable.

johannes

--=-nTmZrAeCDymbTKSGs72j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc9wSAAoJEKVg1VMiehFYCrcQAMHtkBDheOTRy6fvcNHu+7nt
jqpT3rU/c9pGm6TgVTrPzKoxh14w891DxJ1AdC+uGZ78b8Oyojc+kEnYJSFu737h
uAj0mWzAsdVvHeVqe6WX23Rzr07c34sywHOyuh0bblrsevOaAeVbczrm84k8wSGn
NVlfrGJAX7eHugPMA7aWdy6KdyK0DTOkFT+hIRx92VqBHtcp71D03xrHx15FOdgw
VG+jxRmPwm/PVMtvd7CTty3YHQ6n6IZNJMcUABV1dhwCE27suaLj7CuvMmLQSp/G
aYaxsAhqywvtYm1ry2szXaCkbjfVJrCG5FxE4Nv/ioor4cX2Zzz0gF5Ke5XMKV7a
uuT/74fYidbot31HY2BCcI+PJHEQy5JZ8jbkvJ6UaSy6j7kIO2fJo96JUF6mp51P
xrl/SzJpw+Yu9xmk8mQbtxZ4q8ys/VVcArEOw4ntkI5TDS8899DhRgl3pjGkAiMf
SEaAeLWvb5aFW2Tl1cxS6R5fEuGtNQ4rKa/udOa80m7agrlVuD0+prZ6p2W5UIz6
/PY87/FqPj0aMNgP1RWgzApAf2xT8/PtHsynyGsiO35xQbs6ULAFSBB9+jKBKOkf
2dsFi/MxsuJiIkwFYy8Oz69DfZUCKU8GSA96zIHMaODCl8EQ6DEjpFVQJQae1goe
f32M2H9jkyHqv2w71YCs
=6KL8
-----END PGP SIGNATURE-----

--=-nTmZrAeCDymbTKSGs72j--

