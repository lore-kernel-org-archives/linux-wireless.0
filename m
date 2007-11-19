Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbXKTMgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 07:36:22 -0500
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11954792971872-git-send-email-ron.rindjunsky@intel.com>
References: <11954792971872-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jnsithkmGX0D2NQzbktQ"
Date: Mon, 19 Nov 2007 21:21:10 +0100
Message-Id: <1195503670.19479.20.camel@johannes.berg> (sfid-20071120_123644_873335_E5778A92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jnsithkmGX0D2NQzbktQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-19 at 15:34 +0200, Ron Rindjunsky wrote:
> This patch restructures the Rx handlers chain by incorporating previously
> handlers ieee80211_rx_h_802_1x_pae and ieee80211_rx_h_drop_unencrypted
> into ieee80211_rx_h_data, already in 802.3 form. this scheme follows more
> precisely after the IEEE802.11 data plane archituecture, and will prevent
> code duplication to IEEE8021.11n A-MSDU handler.

Nice, thanks for doing this. Few comments and questions below.


> -int ieee80211_is_eapol(const struct sk_buff *skb);
> +int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);

That's just an optimisation, right?

>  #ifdef CONFIG_MAC80211_DEBUG
> -		struct ieee80211_hdr *hdr =3D
> -			(struct ieee80211_hdr *) rx->skb->data;
> -		DECLARE_MAC_BUF(mac);
> -		printk(KERN_DEBUG "%s: dropped frame from %s"
> -		       " (unauthorized port)\n", rx->dev->name,
> -		       print_mac(mac, hdr->addr2));
> +		printk(KERN_DEBUG "%s: dropped frame "
> +		       "(unauthorized port)\n", rx->dev->name);

Any reason you're getting rid of the MAC printk? It's a debug-only
message so whatever, just curious really.

> -		     (rx->sdata->eapol =3D=3D 0 || !ieee80211_is_eapol(rx->skb)))) {
> +		     (rx->sdata->eapol =3D=3D 0 ||
> +		      !ieee80211_is_eapol(rx->skb, hdrlen)))) {

I guess you could make it look nicer by doing !rx->sdata->eapol || ...

> +	if (ieee80211_data_to_8023(rx) =3D=3D TXRX_DROP)
> +		return TXRX_DROP;
> +	if (ieee80211_802_1x_pae(rx, sizeof(struct ethhdr)) =3D=3D TXRX_DROP)
> +		return TXRX_DROP;
> +	if (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr)) =3D=3D TXRX_D=
ROP)
> +		return TXRX_DROP;

The sizeof() doesn't look right, shouldn't that get the hdrlen from the
frame control? Ah, no, I see now, it's already converted at this point.
Do we need to pass the hdrlen at all then? I think it would make sense
to specify (in comments) that those functions get a converted (to 802.3
framing) skb instead. And then hardcode the frame offsets/header length.

Also, I think the return value of those functions shouldn't be the
txrx_result but rather just a bool.

>  static ieee80211_txrx_result
>  ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
>  {
>  	struct ieee80211_key *key;
> +	const struct ieee80211_hdr *hdr;
> +	u16 fc;
> +	int hdrlen;
> +
> +	hdr =3D (const struct ieee80211_hdr *) tx->skb->data;
> +	fc =3D le16_to_cpu(hdr->frame_control);
> +	hdrlen =3D ieee80211_get_hdrlen(fc);
> =20
>  	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
>  		tx->key =3D NULL;
> @@ -448,7 +451,7 @@ ieee80211_tx_h_select_key(struct ieee80211_txrx_data =
*tx)
>  	else if ((key =3D rcu_dereference(tx->sdata->default_key)))
>  		tx->key =3D key;
>  	else if (tx->sdata->drop_unencrypted &&
> -		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb))) {
> +		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb, hdrlen))) {

I think it would make sense to have another function
ieee80211_is_eapol_checked(tx->skb) that does the hdrlen calculation to
save doing it unconditionally here for the (common) case where we're
using a sta or default key.

Overall, nice patch.

johannes

--=-jnsithkmGX0D2NQzbktQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0HwNaVg1VMiehFYAQKxdQ//X0UYupuuprjRsfiSnEMeFjjgKJkmn/wJ
/JkS0Un3/MF2XLbbyibjFSvIbnbwpqvgXtNeMIFMU+1ge0eNSatvU0nzEXzVadE/
QXg26DeXDWRWOkX2HeKMfYSE2BrFX89mRynzBqoik+Etj3FEoWnClhMVr501AD0Y
MBn46hZ27Qz9+oYZj6UvOjJUfpKicuLncUrh6oul+TyPkSxZqiZHv8D6O6x8M1X9
lGQEEckRS1REfeA/oUwOl5r/NDIl7RVOz/nubl7uItAK0cxxGi4JdvMW67u3Bnto
vyiWnmepy/i0AICdyVM5SNj0I5EDSwBrsbv9BSXEnj10Y+llkq4ij9aNcEo3Bu/6
gnwzFDhUZ+2V1XZTvznZ9IxqY0gfN4LY/PyXRrjEeJe1BrlhHUMXSCissUtLyQqU
q7gVqtaLzFNl+jLqSiMURuNOOlDaeSt72huiJjSnkPH+f0m5r77IKB2MRndapWHP
Vdt9i+f48yWwE3n3pjawOfQcYRkTMie+3Ht5O0SG5k5cz+jc+mWvUtt+2tKEiyX1
ArRi4/YQ7l4FtweMbabq6e7t/I1p5mntHNJcSEAB27YhLreqrrqN0TVUBGdLRMgj
qaQLmJdtgIPGPaL6Se8LcJQ472L6PNX1EMPPTTY8V3DHvKapEiKa7DmlYj1pwUfi
0xDL277Zcy0=
=7ZxO
-----END PGP SIGNATURE-----

--=-jnsithkmGX0D2NQzbktQ--

