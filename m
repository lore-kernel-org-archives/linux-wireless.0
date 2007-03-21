Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933913AbXCVKEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:45 -0400
Subject: Re: [PATCH 4/4] mac80211: Monitor mode radiotap-based packet  injection
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070320104104.837354764@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.837354764@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-smhD+13qTe/hKKM4MNst"
Date: Wed, 21 Mar 2007 19:28:53 +0100
Message-Id: <1174501733.3944.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-smhD+13qTe/hKKM4MNst
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-20 at 10:39 +0000, andy@warmcat.com wrote:

> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -1054,7 +1054,180 @@ ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data =
*tx)
>  }
> =20
>=20
> -static void inline
> +/* deal with packet injection down monitor interface
> + * with Radiotap Header -- only called for monitor mode interface
> + */
> +
> +static ieee80211_txrx_result
> +__ieee80211_convert_radiotap_to_control_and_remove(
> +	struct ieee80211_txrx_data *tx,
> +	struct sk_buff *skb, struct ieee80211_tx_control *control)
> +{

The actual parsing should live in cfg80211 (preferably in a new file) so
that others can use it. If it's a lot of code then add a new invisible
Kconfig symbol for it that drivers/stacks can select.

> +	 * There is also some pervacious arg padding, so that args

perwhat?

> +	static const u8 radiotap_entry_sizes[] =3D {
> +		8, /* IEEE80211_RADIOTAP_TSFT */
> +		1, /* IEEE80211_RADIOTAP_FLAGS */
[...]

I'd prefer C99 style for this.

> +		return TXRX_DROP; /* version byte as magic */

Bad idea. At least the comment. If you mean "drop the packet if it has a
radiotap version we don't parse" then say so.

> +	if (le32_to_cpu(rthdr->it_present) & 0x80000000) {
> +		while (le32_to_cpu(*((u32 *)tap_arg)) & 0x80000000)

Use a constant for that, introduce one if necessary.

> +	control->key_idx =3D -1; /* no encryption key */

Is there any way to indicate encryption? I think there might need to be
for 802.11w.

> +	control->flags &=3D ~(IEEE80211_TXCTL_USE_RTS_CTS |
> +		IEEE80211_TXCTL_USE_CTS_PROTECT);

These really should be selectable as well.

> +	control->flags |=3D (IEEE80211_TXCTL_DO_NOT_ENCRYPT |
> +		IEEE80211_TXCTL_NO_ACK);

And NO_ACK is a really really totally bad idea for a userspace MLME.
Needs to be selectable for sure.

We also need to be able to assign some magic cookie to a packet that we
get back along with the packet so that we know when the injected packet
has been acked by the peer.

> +	/* remove the radiotap header */
> +	skb_pull(skb, le16_to_cpu(rthdr->it_len));

Shouldn't there be some sort of sanity check here so we don't pull too
much if userspace asks us to?

> +			/* radiotap version used as magic */

Same comment as above, there's nothing magic about the radiotap version.

johannes

--=-smhD+13qTe/hKKM4MNst
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAXll/ETPhpq3jKURAsKUAJwOH+oVqLmo99/M3RLcIqy89vjT9gCguAVj
Rfv6QNZ4Zp4u3GWc8uT4tjQ=
=fpMs
-----END PGP SIGNATURE-----

--=-smhD+13qTe/hKKM4MNst--

