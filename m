Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbZJHUHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 16:07:39 -0400
Subject: Re: [PATCH 15/20] wl1271: Multicast filtering configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1255028196-6565-16-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
	 <1255028196-6565-16-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ezKGuH76IUrAGbVAEM+U"
Date: Thu, 08 Oct 2009 22:01:43 +0200
Message-Id: <1255032103.3713.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ezKGuH76IUrAGbVAEM+U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-08 at 21:56 +0300, Luciano Coelho wrote:

> +	/* first, get the filter parameters */
> +	spin_lock_irqsave(&wl->wl_lock, flags);
> +	fp =3D wl->filter_params;
> +	wl->filter_params =3D NULL;
> +	spin_unlock_irqrestore(&wl->wl_lock, flags);
> +
> +	if (!fp)
> +		return;

> +	kfree(fp);

> +static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_c=
ount,
> +				       struct dev_addr_list *mc_list)
> +{
> +	struct wl1271 *wl =3D hw->priv;
> +	struct wl1271_filter_params *fp;
> +	unsigned long flags;
> +	int i;
> +
> +	/*
> +	 * FIXME: we should return a hash that will be passed to
> +	 * configure_filter() instead of saving everything in the context.
> +	 */
> +
> +	fp =3D kzalloc(sizeof(*fp), GFP_KERNEL);
> +	if (!fp) {
> +		wl1271_error("Out of memory setting filters.");
> +		return 0;
> +	}

It's a u64 on purpose, you can return the parameters struct to pass it
through to configure_filter.

johannes

--=-ezKGuH76IUrAGbVAEM+U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzkUjAAoJEODzc/N7+QmargcP/1/5EII7Di1e1hSTpsBazvhV
wSe7XRLuZZtrnj4eTcwFP8C7YHjRHrAUsNlQ1DCMquKCvgL7NW3EeDD5QLjppq58
8sLT0rQN5lYwN0BL2REESdTXRwJ23Ihq6q6uG39Bq7X8V7OXuozqoD7CNgw87x+I
kwInsLxrCqh3H8p28hP0IJFpA5antwbouzAsB9gzlZA27e0pGkf5SPK3mmhUczN1
E3gv2Nb+kx7joBE8xv0vsZe6ouKzZfqNwXWRLwOPn9QAiD3Ebn/M745ylML8BJjL
rDdHtGXk65zuQOvtv4QQwWR6H0mg7i2b3BIfjDyrTkV+ShTssltvKLTR4tVIeVaV
v90LNdRl41+JEur7QPUhPobVUtzo2jW80NK8YLZ2TUg7/tJVTKKycckWtFq1C+9o
DfWnn/naJVxCCb5FXYcoj728rTJoqqWqUdAsx1+KqNv1E8M5mEDNwpesEvw3JNJR
3oVwe4B8XCw2uYzNODZhSKw38Sb35dmaVIi9xmKVX0GJHwIqg1D8CYEf3xismTQK
WGXNJYzbx7tGR9UoWUQ52AAehtFrTny7xB2/kjm0qGNr4olsiiRlAHZTf0heBSs0
i//PEMTTuGa/fP/j4YHCZfONn9q7PncBOsN629DPlKAHYB1rC5RbvLzn0c9tSvGN
S7lVwUtj/uLA/D2sypNT
=+xxj
-----END PGP SIGNATURE-----

--=-ezKGuH76IUrAGbVAEM+U--

