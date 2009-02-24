Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZBXCv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:51:59 -0500
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090223163738.20939.25890.stgit@tikku>
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163738.20939.25890.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nJzgcNfz3seSs2P6h3qY"
Date: Mon, 23 Feb 2009 18:20:58 -0800
Message-Id: <1235442058.4455.71.camel@johannes.local> (sfid-20090224_035201_386088_91DEBBA1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nJzgcNfz3seSs2P6h3qY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 18:37 +0200, Kalle Valo wrote:

> +void ieee80211_beacon_loss_work(struct work_struct *work)
> +{
> +	struct ieee80211_sub_if_data *sdata =3D
> +		container_of(work, struct ieee80211_sub_if_data,
> +			     u.mgd.beacon_loss_work);
> +
> +	printk(KERN_DEBUG "%s: beacon loss from AP %pM "
> +	       "- disassociating\n", sdata->dev->name, sdata->u.mgd.bssid);
> +
> +	ieee80211_set_disassoc(sdata, true, true,
> +			       WLAN_REASON_PREV_AUTH_NOT_VALID);
> +}

We used to go through a probe request cycle once to make sure, but I'm
not sure there's a point in that. Just pointing out the change here.

The code looks pretty good, but this will lead to an interesting
situation where "iwlist wlan1 scan last" ("iw dev wlan1 scan dump") will
not show _any_ BSS, which will probably trip up NM; this happens because
the BSS will not be updated and expire after 10 seconds. I think we need
a way to "hold on" to the BSS.

johannes

--=-nJzgcNfz3seSs2P6h3qY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1mHAAoJEKVg1VMiehFYndkP/1nACm1V6qtwzxmFDuAXdV8p
THN4JYZUI6FyXx0KX1OjSc6qONvh1Pz85OD8vXD+H8RfXDJeIlozh7vU8K5gBAAR
h/eUUNLzebccn4zDnG4yc9y3Hni6GNchVO72xsJiF6MqowRLYqEShespkGFnZ8il
KIMQBaYV484ptkM6usAzPw8c2o+iU0oxp7UG9ObCK7uDUwn/bU74Yu1+hM6h2srx
8MAXSX0/EO3c7OloIvpNM3YMzeVkqnaqKwUwbOGyO5zm5D+ncxs7YyUmS1aQeCdF
/o7Mwjprt0OJQH1hT64orMg6sFWQBjqt9bdK9vliDKglVoUwxKU7Xzs0x85ryfHe
C95qYgvR8wpYkbsa7eojknCFAEBrNTJWla4KFj6cHgzJ0UyaKK4kzFbeUwTHOjN5
+1HfSR8xdeiaowa5Pu2Hxo+ZdfYmN/xA1qWuCpOWKzwZqsP5mVgLgKpCfN2toe6S
nkdIIw5pHt/PyXyqlWXvAhKFnLt1xb8K59ef8k+MqGzhdmuln18yNkDMKgi9W8BT
MPqPfiUUb12MVsm3NdxBaYs6W/CPmodoCDw6nkP+O3WhzFatv2DUjvbhVVOZI516
ToYcdFo4x0KJww3YhYjfQhHrF89Z0IsEq1gPRXtxewr80Ox2FWRVA2Hx+tlmZ/lS
TixhH2GWrhpR5bBEW/XS
=StcB
-----END PGP SIGNATURE-----

--=-nJzgcNfz3seSs2P6h3qY--

