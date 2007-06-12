Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13337 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbXFLIYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 04:24:45 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH Try#9 4/4] mac80211: Monitor mode radiotap-based packet injection
Date: Tue, 12 Jun 2007 01:23:48 -0700
Cc: linux-wireless@vger.kernel.org
References: <20070611152120.078733592@warmcat.com> <20070611152210.682543457@warmcat.com>
In-Reply-To: <20070611152210.682543457@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4063796.b1WGtbj0vY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706120123.53109.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4063796.b1WGtbj0vY
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 11 June 2007 08:21, andy@warmcat.com wrote:
> +__ieee80211_convert_radiotap_to_control_and_remove(
This is kinda long.. how about ieee80211_parse_radiotap instead? Function=20
names aren't a substitute for comments. ;)

> +	struct ieee80211_hw_mode *hw_mode=3Dtx->local->hw.conf.mode;
Add a space before and after the '=3D'. Also, mode is more common than hw_m=
ode=20
as a variable name for struct ieee80211_hw_mode.

> +
> +	/* this can fail some sanity checks, drop packet if it does so */
> +
> +	if (ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len) < 0)
> +		return TXRX_DROP;
> +
> +	/*
> +	 * default control situation for all injected packets
> +	 * FIXME: this does not suit all usage cases, expand to allow control
> +	 */
> +
> +	control->retry_limit =3D 1; /* no retry */
> +	control->key_idx =3D -1; /* no encryption key */
> +	control->flags &=3D ~(IEEE80211_TXCTL_USE_RTS_CTS |
> +			    IEEE80211_TXCTL_USE_CTS_PROTECT);
> +	control->flags |=3D IEEE80211_TXCTL_DO_NOT_ENCRYPT |
> +			  IEEE80211_TXCTL_NO_ACK;
> +	control->antenna_sel_tx =3D 0; /* default to default antenna */
> +
> +	/*
> +	 * for every radiotap entry that is present (returns -ve on end or
=2Dve?

> +	 * on error)
> +	 */
> +
> +	while (ieee80211_radiotap_iterator_next(&iterator) >=3D 0) {
> +		int i, target_rate;
> +
> +		/* see if this argument is something we can use */
> +
> +		switch (iterator.this_arg_index) {
> +
An empty line after a switch statement doesn't seem right.

I think the rest of the patch is okay. Just keep in mind the other style=20
comments I made in the other patch.

Thanks,
=2DMichael Wu

--nextPart4063796.b1WGtbj0vY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGblgZT3Oqt9AH4aERAp8OAJ41zHvsPDuLN7c+Qs/iHdoCsPQTsgCgqi0A
gJyFJ59bPrlVu27NKk47/VY=
=npeS
-----END PGP SIGNATURE-----

--nextPart4063796.b1WGtbj0vY--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
