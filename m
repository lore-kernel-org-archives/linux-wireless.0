Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZCRNHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 09:07:12 -0400
Subject: Re: [PATCH v4] mac80211: don't drop nullfunc frames during
 software scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20090318120644.19664.28373.stgit@tikku>
References: <20090318120644.19664.28373.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wuEwMoDdXYKpRcLlsTWT"
Date: Wed, 18 Mar 2009 14:06:31 +0100
Message-Id: <1237381591.5100.16.camel@johannes.local> (sfid-20090318_140720_674195_7ADEB867)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wuEwMoDdXYKpRcLlsTWT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-18 at 14:06 +0200, Kalle Valo wrote:
> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> requests during software scan. So the nullfunc frame with the power save
> bit was dropped and AP never received it. This meant that AP never
> buffered any frames for the station during software scan.
>=20
> Fix this by allowing to transmit both probe request and nullfunc frames
> during software scan. Tested with stlc45xx.
>=20
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Thanks for your patience!

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/scan.c |   13 +++++++++++++
>  net/mac80211/tx.c   |   14 +++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 5030a3c..46f35dc 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -409,6 +409,19 @@ int ieee80211_start_scan(struct ieee80211_sub_if_dat=
a *scan_sdata,
>  		return 0;
>  	}
> =20
> +	/*
> +	 * Hardware/driver doesn't support hw_scan, so use software
> +	 * scanning instead. First send a nullfunc frame with power save
> +	 * bit on so that AP will buffer the frames for us while we are not
> +	 * listening, then send probe requests to each channel and wait for
> +	 * the responses. After all channels are scanned, tune back to the
> +	 * original channel and send a nullfunc frame with power save bit
> +	 * off to trigger the AP to send us all the buffered frames.
> +	 *
> +	 * Note that while local->sw_scanning is true everything else but
> +	 * nullfunc frames and probe requests will be dropped in
> +	 * ieee80211_tx_h_check_assoc().
> +	 */
>  	local->sw_scanning =3D true;
>  	if (local->ops->sw_scan_start)
>  		local->ops->sw_scan_start(local_to_hw(local));
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 457238a..af768fc 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -193,7 +193,19 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data =
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
> +		 * active scan) are allowed, all other frames should not be
> +		 * sent and we should not get here, but if we do
> +		 * nonetheless, drop them to avoid sending them
> +		 * off-channel. See the link below and
> +		 * ieee80211_start_scan() for more.
> +		 *
> +		 * http://article.gmane.org/gmane.linux.kernel.wireless.general/30089
> +		 */
>  		return TX_DROP;
> =20
>  	if (tx->sdata->vif.type =3D=3D NL80211_IFTYPE_MESH_POINT)
>=20
>=20

--=-wuEwMoDdXYKpRcLlsTWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwPHVAAoJEKVg1VMiehFY5NsP+gOAhkoDJiGFL5ZGASZiQDdo
HrT156m0m0TiTnkF0us8lN5HHuJ8MRf/dH3PVR56pC6NoWuOgZZRla45GHtpHzsM
w98nQIKysbMR7U3Ry/rHVfIIR35IXbZzvDHNfubi4EfH+dL89GcqqeMStPeywXqO
CdetlyOaDQIdIE1uW2sVKDETlINgsIhsnu82VSVpbkzPN2wayUqLcDlAzHWlq3VG
Pbv2zda6NQbbOJV6aP+4kEenT1wUJNhnyzcuP6FElP1DhA3DK+z2kBi4lGyJABKs
EpKao9yYNLH7AlM7QPUHbz1ldp5H0PPOZPaFthj3PUB90GD0h6VzufIeIzs/Twu8
fyW1FAZx81zgmoF28BwCVWHPOHodGdQL/jW/TMEPETcL9rHC4yq2NHOdhijHnaTI
aBwvVMGtTeDZwy2iVS+R4br3dHtRqzYM6x926xXmqjvAPIQ2p2SyXEcJ7xolaVRY
gsaVyi0w6K5fQ+QjjXBhad5Ra1PE4pbZ3BEx8vUHojvxYnlJ4QN81P1qT3xXmlNM
Da70IIzfVkQsP66+IHUtzyM8vYfgrN7MA/2KXuG1DcxWeoPA6j9Iii3CcTOYMYrL
GYjA0iTcD94q9rf7MpxiIz8Q7/l75kwDdjltfNuZN8gSxEtpyukOo8eUS+kWSFl2
9KIidOWRl8dMJm6I0n7K
=jNTP
-----END PGP SIGNATURE-----

--=-wuEwMoDdXYKpRcLlsTWT--

