Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZHSHtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 03:49:05 -0400
Subject: Re: [RFC 5/5] cfg80211: scan before connect if we don't have the
 bss
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1250640253-18434-6-git-send-email-kilroyd@googlemail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
	 <1250640253-18434-6-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lMu9YbHkSvq8W0WZMt1n"
Date: Wed, 19 Aug 2009 09:48:33 +0200
Message-Id: <1250668113.16393.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lMu9YbHkSvq8W0WZMt1n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 01:04 +0100, David Kilroy wrote:

> @@ -791,18 +824,55 @@ int __cfg80211_connect(struct cfg80211_registered_d=
evice *rdev,
> =20
>  		return err;
>  	} else {
> +		struct cfg80211_bss *bss;
> +
>  		wdev->sme_state =3D CFG80211_SME_CONNECTING;
>  		wdev->connect_keys =3D connkeys;
> +
> +		bss =3D cfg80211_get_bss(wdev->wiphy, NULL, connect->bssid,
> +				       connect->ssid, connect->ssid_len,
> +				       WLAN_CAPABILITY_ESS,
> +				       WLAN_CAPABILITY_ESS);

Hmm. What if the bssid isn't set? Then the card might select a different
BSS than the one we have on the scan list.


> +			/* Failed to clone (or scan), so we can't
> +			 * delay the connect. Free everything up and
> +			 * go ahead with the connect */
> +			if (wdev->conn)
> +				kfree(wdev->conn->ie);
> +			kfree(wdev->conn);
> +			wdev->conn =3D NULL;

and that would then run into the warning and the problem anyway? Better
to just reject with -ENOMEM I think? Also, I really don't think you
should use wdev->conn anywhere in this code path, because some code
looks at that to figure out whether or not the cfg80211 SME is used.

> +		} else {
> +			cfg80211_put_bss(bss);

>  		err =3D rdev->ops->connect(&rdev->wiphy, dev, connect);

And it's all racy too -- by the time the driver calls connect_result(),
the BSS might have expired after it was found here now.

I don't think this is really feasible to implement in cfg80211. Couldn't
the driver do a probe to the BSS that the device selected, and report
that before the connect result?

johannes

--=-lMu9YbHkSvq8W0WZMt1n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKi65OAAoJEODzc/N7+QmaiZQQAIICxf/2Dvax40pUuMN6IM+p
xFEWMx9bOGG4oVYG0kPcvYm5nFzRh/rhcz3hG/ZYBob1oY5RxWKts7SeN9IxJMxC
lV1zMNVvl0sc1+jJNvLkC1yb5pFfOusJzzT+KApD3kRbdhGH3YJCGv9teWUhMBpj
jBdtDAbCQFRSq3YKyKOX7AGm15NYkkGx+OqT+aKsRFrIo1xECgpaWO7BgZncLrka
yKRHc+vUYxUVBcQQ/b8PoaSm1I0rb+PZd2jxW4btFWdJ/lMteBw8jmnpYmsVoBjE
owlDr9vCKqn/483W6exRkWpETYvpxpdX/+Gm7+reMNX3iNPfpuufO1416dCIpUsc
mwDLzmXATNguvtNx2aaWy5Dku3j/bJAOJ3ajFu1H9lzSh/25IiDUpm/vQYpnBZZE
kxmVqwgF+CnTblEx8XdaSzsXV0KvQd6Y4mO+5DsAosXTWweg0zK2R+hdLWCnwQdc
NWPsrZcq9KDKweIMcBQExczpBfQvSLpRDhq2F1wTBWj8WJjqwMmusLzPRaeNggkv
G6koRHPg9ID4VGKRytbXSmmpfJfp5cL+WwCx0Kx4uup0mhbnMCcxbjJ9otnkXMFK
HtEdCTGLFwqRZRKhODBg5MEYY/Zx3p6eEWLaENLQ7tD79ZCpRs73k9NOjA+1wZ6Q
93XIMWbFUWYrx8AIXdwX
=eKFx
-----END PGP SIGNATURE-----

--=-lMu9YbHkSvq8W0WZMt1n--

