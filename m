Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYCTNMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 09:12:39 -0400
Subject: Re: [PATCH 5/7 V2] mac80211: allows driver to request a Phase 1 RX
	key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1206018403-8308-3-git-send-email-tomas.winkler@intel.com>
References: <1206018403-8308-1-git-send-email-tomas.winkler@intel.com>
	 <1206018403-8308-2-git-send-email-tomas.winkler@intel.com>
	 <1206018403-8308-3-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UXxkv+6af6NkyukKZqo7"
Date: Thu, 20 Mar 2008 14:12:22 +0100
Message-Id: <1206018742.16475.109.camel@johannes.berg> (sfid-20080320_131241_414688_8A15A80A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UXxkv+6af6NkyukKZqo7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-20 at 15:06 +0200, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch makes mac80211 able to send a phase1 key for TKIP
> decryption.
> This is needed for drivers that don't do the rekeying by themselves
> (i.e. iwlwifi). Upon IV16 wrap around, the packet is decrypted in SW,
> if decryption is ok, mac80211 calls to update_tkip_key  with a new
> phase 1 RX key.
>=20
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Looks good, thanks

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/mac80211.h |   17 +++++++++++++++++
>  net/mac80211/tkip.c    |   15 ++++++++++++++-
>  net/mac80211/tkip.h    |    2 +-
>  net/mac80211/wpa.c     |    2 +-
>  4 files changed, 33 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2a13458..48428a6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -827,6 +827,16 @@ static inline void SET_IEEE80211_PERM_ADDR(struct ie=
ee80211_hw *hw, u8 *addr)
>   * parameter is guaranteed to be valid until another call to set_key()
>   * removes it, but it can only be used as a cookie to differentiate
>   * keys.
> + *
> + * In TKIP some HW need to be provided a phase 1 key, for RX decryption
> + * acceleration (i.e. iwlwifi). Those drivers should provide update_tkip=
_key
> + * handler.
> + * The update_tkip_key() call updates the driver with the new phase 1 ke=
y.
> + * This happens everytime the iv16 wraps around (every 65536 packets). T=
he
> + * set_key() call will happen only once for each key (unless the AP did
> + * rekeying), it will not include a valid phase 1 key. The valid phase 1=
 key is
> + * provided by udpate_tkip_key only. The trigger that makes mac80211 cal=
l this
> + * handler is software decryption with wrap around of iv16.
>   */
> =20
>  /**
> @@ -1003,6 +1013,10 @@ enum ieee80211_ampdu_mlme_action {
>   *	and remove_interface calls, i.e. while the interface with the
>   *	given local_address is enabled.
>   *
> + * @update_tkip_key: See the section "Hardware crypto acceleration"
> + * 	This callback will be called in the context of Rx. Called for driver=
s
> + * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
> + *
>   * @hw_scan: Ask the hardware to service the scan request, no need to st=
art
>   *	the scan state machine in stack. The scan must honour the channel
>   *	configuration done by the regulatory agent in the wiphy's registered
> @@ -1094,6 +1108,9 @@ struct ieee80211_ops {
>  	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  		       const u8 *local_address, const u8 *address,
>  		       struct ieee80211_key_conf *key);
> +	void (*update_tkip_key)(struct ieee80211_hw *hw,
> +			struct ieee80211_key_conf *conf, const u8 *address,
> +			u32 iv32, u16 *phase1key);
>  	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
>  	int (*get_stats)(struct ieee80211_hw *hw,
>  			 struct ieee80211_low_level_stats *stats);
> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
> index 5c36b2d..45d59f1 100644
> --- a/net/mac80211/tkip.c
> +++ b/net/mac80211/tkip.c
> @@ -291,7 +291,7 @@ void ieee80211_tkip_encrypt_data(struct crypto_blkcip=
her *tfm,
>  int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
>  				struct ieee80211_key *key,
>  				u8 *payload, size_t payload_len, u8 *ta,
> -				int only_iv, int queue,
> +				u8 *ra, int only_iv, int queue,
>  				u32 *out_iv32, u16 *out_iv16)
>  {
>  	u32 iv32;
> @@ -368,6 +368,19 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcip=
her *tfm,
>  			printk("\n");
>  		}
>  #endif /* CONFIG_TKIP_DEBUG */
> +		if (key->local->ops->update_tkip_key &&
> +			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> +			u8 bcast[ETH_ALEN] =3D
> +				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> +			u8 *sta_addr =3D key->sta->addr;
> +
> +			if (is_multicast_ether_addr(ra))
> +				sta_addr =3D bcast;
> +
> +			key->local->ops->update_tkip_key(
> +				local_to_hw(key->local), &key->conf,
> +				sta_addr, iv32, key->u.tkip.p1k_rx[queue]);
> +		}
>  	}
> =20
>  	tkip_mixing_phase2(key->u.tkip.p1k_rx[queue],
> diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
> index 73d8ef2..ffaee32 100644
> --- a/net/mac80211/tkip.h
> +++ b/net/mac80211/tkip.h
> @@ -31,7 +31,7 @@ enum {
>  int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
>  				struct ieee80211_key *key,
>  				u8 *payload, size_t payload_len, u8 *ta,
> -				int only_iv, int queue,
> +				u8 *ra, int only_iv, int queue,
>  				u32 *out_iv32, u16 *out_iv16);
> =20
>  #endif /* TKIP_H */
> diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
> index df0b734..45709ad 100644
> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -312,7 +312,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_dat=
a *rx)
>  	res =3D ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
>  					  key, skb->data + hdrlen,
>  					  skb->len - hdrlen, rx->sta->addr,
> -					  hwaccel, rx->queue,
> +					  hdr->addr1, hwaccel, rx->queue,
>  					  &rx->tkip_iv32,
>  					  &rx->tkip_iv16);
>  	if (res !=3D TKIP_DECRYPT_OK || wpa_test) {

--=-UXxkv+6af6NkyukKZqo7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+JitaVg1VMiehFYAQIzkw/+PENgC/1RdDTu3l/qVIfW8PN11knEDRHb
PeyL09SOFGD4A8wQlkYkpMQxwI4Q+wkMJFDIgsFP1frEJnGMH0Zhvn/9bGfnuxqE
/RKQ5kCf/RE9KINqDDRMGQtATyvkZ5FnWawzqa4leo+rOcRll9vU9Y+VVn3yow4F
H8CLC1qYks/6WreYZ+BVhWwshtOUS2nN6Iss8N3qNTMvBqJdmS1mEekZvQzidNMd
+ohm7jFHfF36JUd5071IctW4f9sMK9Wgy5ziovmxU5jrxI8D2yvXrTPLouv4hgAF
Q4nT6ikTdx35DhjMWtUCThZBv6+6YG8trXLg3vtkigdUEvCyqShSW3Xl4wEPkOzg
YifRE7UYFenGN6rog1lI6owlcKlcw1DVih1tknGmLjADy5CoGLAC4B/uDwT/koZx
QU9aGiGWJ8YPE1G7MkW8RLiqcFI0+hFiLOd44CLIRgXo7vM8Iqkkx+ECpsj8J7Rm
q2QV+SLuqgTekwR4aUWPVJQXayeTdi/Y9F2hDguR9LxEfnQNFtp24hGLmu2/FT0C
t3axs0hHcMt3v/cK2aY3eeIYUCgZ9ixxKReoV0VlVFHhWX+IrFCrIkKhLYo2YAF7
D5pqgVCcHCF2aBz8tKB1wo3rYEaOAQWv2b41By2nFoXJGP2wRZnU2dCgiTfS0E4a
D6/zwD84qug=
=3otf
-----END PGP SIGNATURE-----

--=-UXxkv+6af6NkyukKZqo7--

