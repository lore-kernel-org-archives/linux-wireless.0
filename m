Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764446AbXHQKK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:10:57 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1187151162.3253.18.camel@thinkpad>
References: <1187151162.3253.18.camel@thinkpad>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0hEAwYV9/kXYRYGKxAe6"
Date: Fri, 17 Aug 2007 01:50:21 +0200
Message-Id: <1187308221.23489.91.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0hEAwYV9/kXYRYGKxAe6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 00:12 -0400, Volker Braun wrote:
> 1) Instead of hacking around ieee80211_privacy_mismatch, remove it
> completely. It serves no useful purpose.

The purpose seems to be to avoid associating to BSSes that have privacy
enabled when we don't have any keys nor a tool told us that it's ok.
This again raises the question of why wpa_supplicant doesn't set the
IW_AUTH_KEY_MGMT_802_1X flag that should get you around the mismatch
check.

> @@ -3488,7 +3488,6 @@ static ieee80211_txrx_result
>  ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
>  {
>  	struct ieee80211_hdr *hdr;
> -	int always_sta_key;
>  	hdr =3D (struct ieee80211_hdr *) rx->skb->data;
> =20
>  	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
> @@ -3556,29 +3555,19 @@ ieee80211_rx_h_check(struct ieee80211_tx
>  		return TXRX_QUEUED;
>  	}
> =20
> -	if (rx->sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
> -		always_sta_key =3D 0;
> -	else
> -		always_sta_key =3D 1;
> -
> -	if (rx->sta && rx->sta->key && always_sta_key) {
> -		rx->key =3D rx->sta->key;
> -	} else {
> -		if (rx->sta && rx->sta->key)
> +	if (rx->fc & IEEE80211_FCTL_PROTECTED) {	=09
> +		if (rx->skb->pkt_type =3D=3D PACKET_HOST &&=20
> +		    rx->sta && rx->sta->key)
>  			rx->key =3D rx->sta->key;
> -		else
> -			rx->key =3D rx->sdata->default_key;
> -
> -		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
> -		    rx->fc & IEEE80211_FCTL_PROTECTED) {
> +		else {=20
>  			int keyidx =3D ieee80211_wep_get_keyidx(rx->skb);
> +			if (keyidx < 0 || keyidx >=3D NUM_DEFAULT_KEYS)
> +				return TXRX_DROP;
> +	=09
> +			rx->key =3D rx->sdata->keys[keyidx];
> =20
> -			if (keyidx >=3D 0 && keyidx < NUM_DEFAULT_KEYS &&
> -			    (!rx->sta || !rx->sta->key || keyidx > 0))
> -				rx->key =3D rx->sdata->keys[keyidx];
> -
> -			if (!rx->key) {
> -				if (!rx->u.rx.ra_match)
> +			if (unlikely(!rx->key)) {
> +				if (!rx->u.rx.ra_match)=20
>  					return TXRX_DROP;
>  				printk(KERN_DEBUG "%s: RX WEP frame with "
>  				       "unknown keyidx %d (A1=3D" MAC_FMT " A2=3D"
> @@ -3587,8 +3576,10 @@ ieee80211_rx_h_check(struct ieee80211_tx
>  				       MAC_ARG(hdr->addr1),
>  				       MAC_ARG(hdr->addr2),
>  				       MAC_ARG(hdr->addr3));
> -				if (!rx->local->apdev)
> +				if (!rx->local->apdev) {
> +					rx->local->dot11WEPUndecryptableCount++;
>  					return TXRX_DROP;
> +				}
>  				ieee80211_rx_mgmt(
>  					rx->local, rx->skb, rx->u.rx.status,
>  					ieee80211_msg_wep_frame_unknown_key);

All those key selection changes and the VLAN group key thing have me
wondering now. Also see Larry's mail (meaningless messages), these
things are related.

> @@ -3597,7 +3588,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
>  		}
>  	}
> =20
> -	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) =
{
> +	if (rx->key && rx->u.rx.ra_match) {

That's just an optimisation, right? (If we have a key, the frame was
encrypted)
=20
> -	if (is_broadcast_ether_addr(sta_addr)) {
> +	if (idx < 0 || idx >=3D NUM_DEFAULT_KEYS) {
> +		printk(KERN_DEBUG "%s: set_encrypt - invalid idx =3D %d\n",
> +		       dev->name, idx);
> +		return -EINVAL;
> +	}
> +
> +	if (is_multicast_ether_addr(sta_addr)) {

I still haven't understood why you changed from broadcast to multicast
here. Nor why you moved the key index check outside the check, if it's a
not a group key then the key index is irrelevant.

>  		set_tx_key =3D 0;
> -		if (idx !=3D 0) {
> +		if (idx !=3D 0 && alg !=3D ALG_WEP) {
>  			printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
>  			       "individual key\n", dev->name);
>  			return -EINVAL;

So wpa_supplicant is actually trying to set a pairwise key with a key
index that isn't zero? That's really weird and definitely against the
rules. Is that somehow required? Shouldn't the AP be able to live with
you setting the key index to zero? Could you try that by forcing the
index to zero in this case?

Actually, maybe this is some weird Cisco rule-bending as you said, but
then I'd rather suspect that it's because of interaction with pre-shared
WEP keys rather than TKIP. In any case, it seems acceptable to remove
this restriction even if we then violate the standard.

johannes

--=-0hEAwYV9/kXYRYGKxAe6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxOK8/ETPhpq3jKURAu48AJ9lRFblffOBaAOTK2XTZF4b0SIYNQCgnVVJ
dEFpe0xxY1gg6fhPxbpzlis=
=Z9J7
-----END PGP SIGNATURE-----

--=-0hEAwYV9/kXYRYGKxAe6--

