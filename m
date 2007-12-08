Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbXLHL3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:29:39 -0500
Subject: Re: [PATCH 1/4] mac80211: Clean up rate selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197112909.7472.49.camel@localhost> (sfid-20071208_112222_400278_02DE29F9)
References: <1197112439.7472.34.camel@localhost>
	 <1197112909.7472.49.camel@localhost> (sfid-20071208_112222_400278_02DE29F9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wVG5wRO5ZYJfwrMUPRc6"
Date: Sat, 08 Dec 2007 12:29:35 +0100
Message-Id: <1197113375.4171.50.camel@johannes.berg> (sfid-20071208_112943_586565_D65555DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wVG5wRO5ZYJfwrMUPRc6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* Send management frames and broadcast/multicast data using lowest
> +	 * rate. */
> +	fc =3D le16_to_cpu(hdr->frame_control);
> +	if ((fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
> +	    (hdr->addr1[0] & 0x01))
> +		sel->rate =3D rate_lowest(local, mode, sta);

I'm not sure but I don't think we want this. And you should use
is_multicast_addr() or whatever it's called.

> +	/* If a forced rate is in effect, select it. */
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> +		sel->rate =3D &mode->rates[sdata->bss->force_unicast_rateidx];

That's good.

> +	/* If we haven't found the rate yet, ask the rate control algo. */
> +	if (!sel->rate)
> +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);

> +	/* Select a non-ERP backup rate. */
> +	if (!sel->nonerp) {
> +		for (i =3D 0; i < mode->num_rates - 1; i++) {
> +			struct ieee80211_rate *rate =3D &mode->rates[i];
> +			if (sel->rate->rate < rate->rate)
> +				break;
> +
> +			if (rate_supported(sta, mode, i) &&
> +			    !(rate->flags & IEEE80211_RATE_ERP))
> +				sel->nonerp =3D rate;
> +		}
> +	}

That I'm not sure about. This is the fallback rate?

johannes

--=-wVG5wRO5ZYJfwrMUPRc6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1qAHqVg1VMiehFYAQIctw/+PGhbIZeGFoMD0ci7FeUEkyIazNqr7bHr
sGqJzBQgkP4DPCXTm6hmVyVX166NfyVsYbqKC9RhSQSpSARhhyKSrudni2mBzcCP
bIR48HERHvRIPX3tylIDCtUcCfpzRBCXyjZuZNn8UzbBzyEy5jEOszrMisvYp2xa
o8+1XDIRNV++B0JyS1pYBE4kGIdKX+A0L1m6/EKrso2Lw987wnu7flZRlv+I44md
kzNcWxmmUGI0LTKSIkfiVCawlVsDbjFl96YGldorlYwYRvl8AI7FtqOfi3hZ0kqn
aGALSxdx0riAJKO+Eu77rwpTg747IBaQ1zOIA7Vp8LYvW1Fu9yoND7V0D/AvZR+h
/leHVDlPGcbLgafKP1mqmE6Q7vFDA9rx4eoEqGxiIyEzQ4uHRHP9KrXdqm1W+UmS
QpCNeYxvWGclGpIAkvR1Lkfxg8yqI9y6Glcil1wlkhFJRoUmW6rbvInA/w+sHASV
KGQMYWsfxlqb0VYN5iIEqp5oYWH5fMINi78+sdVoZam4227h+jTXuiHOoSdNY9b2
nAWFva4kDTi4QBdJ2MAbceAAXGPnkfeXRlplu9uNfJdmM6Wt2GvcrAjBjfzZ5vRq
B+vosUC7JlxxxbKRUidAVSW/8d9StAvu4ai+YDN5xggQw4YaNEMWIBHz+Q2Kf3i3
X8UzHumn6cg=
=Ngro
-----END PGP SIGNATURE-----

--=-wVG5wRO5ZYJfwrMUPRc6--

