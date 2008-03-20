Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbYCTNLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 09:11:25 -0400
Subject: Re: [PATCH 4/7 V2] mac80211: get a TKIP phase key from skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1206018403-8308-2-git-send-email-tomas.winkler@intel.com>
References: <1206018403-8308-1-git-send-email-tomas.winkler@intel.com>
	 <1206018403-8308-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6p9/AyZgNjOQko2IdWVF"
Date: Thu, 20 Mar 2008 14:11:07 +0100
Message-Id: <1206018667.16475.107.camel@johannes.berg> (sfid-20080320_131129_125602_7246D1E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6p9/AyZgNjOQko2IdWVF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-20 at 15:06 +0200, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch makes mac80211 able to compute a TKIP key from an skb.
> The requested key can be a phase 1 or a phase 2 key.
> This is useful for drivers who need to provide tkip key to their
> HW to enable HW encryption.
>=20
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Looks good, thanks

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/mac80211.h |   30 +++++++++++++++++++++++++++
>  net/mac80211/tkip.c    |   53 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 83 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5ab6a35..2a13458 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -644,6 +644,21 @@ enum sta_notify_cmd {
>  };
> =20
>  /**
> + * enum ieee80211_tkip_key_type - get tkip key
> + *
> + * Used by drivers which need to get a tkip key for skb. Some drivers ne=
ed a
> + * phase 1 key, others need a phase 2 key. A single function allows the =
driver
> + * to get the key, this enum indicates what type of key is required.
> + *
> + * @IEEE80211_TKIP_P1_KEY: the driver needs a phase 1 key
> + * @IEEE80211_TKIP_P2_KEY: the driver needs a phase 2 key
> + */
> +enum ieee80211_tkip_key_type {
> +	IEEE80211_TKIP_P1_KEY,
> +	IEEE80211_TKIP_P2_KEY,
> +};
> +
> +/**
>   * enum ieee80211_hw_flags - hardware flags
>   *
>   * These flags are used to indicate hardware capabilities to
> @@ -1472,6 +1487,21 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_=
buff *skb);
>  int ieee80211_get_hdrlen(u16 fc);
> =20
>  /**
> + * ieee80211_get_tkip_key - get a TKIP rc4 for skb
> + *
> + * This function computes a TKIP rc4 key for an skb. It computes
> + * a phase 1 key if needed (iv16 wraps around). This function is to
> + * be used by drivers which can do HW encryption but need to compute
> + * to phase 1/2 key in SW.
> + *
> + * @keyconf: the parameter passed with the set key
> + * @skb: the skb for which the key is needed
> + * @rc4key: a buffer to which the key will be written
> + */
> +void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
> +				struct sk_buff *skb,
> +				enum ieee80211_tkip_key_type type, u8 *key);
> +/**
>   * ieee80211_wake_queue - wake specific queue
>   * @hw: pointer as obtained from ieee80211_alloc_hw().
>   * @queue: queue number (counted from zero).
> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
> index 3abe194..5c36b2d 100644
> --- a/net/mac80211/tkip.c
> +++ b/net/mac80211/tkip.c
> @@ -214,6 +214,59 @@ void ieee80211_tkip_gen_rc4key(struct ieee80211_key =
*key, u8 *ta,
>  			   key->u.tkip.iv16, rc4key);
>  }
> =20
> +void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
> +			struct sk_buff *skb, enum ieee80211_tkip_key_type type,
> +			u8 *outkey)
> +{
> +	struct ieee80211_key *key =3D (struct ieee80211_key *)
> +			container_of(keyconf, struct ieee80211_key, conf);
> +	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> +	u8 *data =3D (u8 *) hdr;
> +	u16 fc =3D le16_to_cpu(hdr->frame_control);
> +	int hdr_len =3D ieee80211_get_hdrlen(fc);
> +	u8 *ta =3D hdr->addr2;
> +	u16 iv16;
> +	u32 iv32;
> +
> +	iv16 =3D data[hdr_len] << 8;
> +	iv16 +=3D data[hdr_len + 2];
> +	iv32 =3D data[hdr_len + 4] +
> +		(data[hdr_len + 5] >> 8) +
> +		(data[hdr_len + 6] >> 16) +
> +		(data[hdr_len + 7] >> 24);
> +
> +#ifdef CONFIG_TKIP_DEBUG
> +	printk(KERN_DEBUG "TKIP encrypt: iv16 =3D 0x%04x, iv32 =3D 0x%08x\n",
> +			iv16, iv32);
> +
> +	if (iv32 !=3D key->u.tkip.iv32) {
> +		printk(KERN_DEBUG "skb: iv32 =3D 0x%08x key: iv32 =3D 0x%08x\n",
> +			iv32, key->u.tkip.iv32);
> +		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
> +			"fragmented packet\n");
> +	}
> +#endif /* CONFIG_TKIP_DEBUG */
> +
> +	/* Update the p1k only when the iv16 in the packet wraps around, this
> +	 * might occur after the wrap around of iv16 in the key in case of
> +	 * fragmented packets. */
> +	if (iv16 =3D=3D 0 || !key->u.tkip.tx_initialized) {
> +		/* IV16 wrapped around - perform TKIP phase 1 */
> +		tkip_mixing_phase1(ta, &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],
> +			iv32, key->u.tkip.p1k);
> +		key->u.tkip.tx_initialized =3D 1;
> +	}
> +
> +	if (type =3D=3D IEEE80211_TKIP_P1_KEY) {
> +		memcpy(outkey, key->u.tkip.p1k, sizeof(u16) * 5);
> +		return;
> +	}
> +
> +	tkip_mixing_phase2(key->u.tkip.p1k,
> +		&key->conf.key[ALG_TKIP_TEMP_ENCR_KEY],	iv16, outkey);
> +}
> +EXPORT_SYMBOL(ieee80211_get_tkip_key);
> +
>  /* Encrypt packet payload with TKIP using @key. @pos is a pointer to the
>   * beginning of the buffer containing payload. This payload must include
>   * headroom of eight octets for IV and Ext. IV and taildroom of four oct=
ets

--=-6p9/AyZgNjOQko2IdWVF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+JiaqVg1VMiehFYAQLK3xAAunz5IPma1KHQQ7wJQwmp2cz7M/2A3qMj
RdtXwUFI/x27nFctmsex7Lpy8dEHSqRK+ArkQM/U/ABMTA8DM9FMBUMuSSSQjSu9
hryiqJ8OQJTyzpegmltK4oza7EovAgIDEk+pCTq7Pb089rzy4JCDbOADXvD3SoHE
vDWV78t+UOun5+bHYadWVbWALONai1HyfMgjn7rmpoRvo9QINGcjch9Q6g3o2nbM
1ErZchj6SKX24ySNfZoe2ZccZFJ/vANDFX7+OIEvAEydaQ9N0XBKU3nvXZysOrQh
l02ax6lBOSiCazGNcKp0JolJu6n1uPiT/eStjN1xvi8KUlcRlZKv0bXd3biH7mZQ
JmaAKYC6sleukBEdLSBWnj3iVQtnAjOlllG7sGipmqQuhuYawgNp6+TTJnNEq3qg
Tp3cGmq2l5YCSsxxmMylr+EcUnmICe2xMJICnVO1AAViLlsoNUVzVRUixMX3wT//
f7CbAQWml3RBxF1gG8HQ06SiKIzpUTdUdHT/ug8gHOc3Nb+PY+TJ5hObP7ZI7Uut
zjNRRg78YhFqWngwGjTLQCvQv5BFoLXHNjEH35P0BZTkaSRJIciapfm3/BuY8uox
67/pN7PlEoiALguf+RnqIRt3MkiC11dZyRJ9YBeu7r/R2gPLTI/F7JPgdlzxDmSy
y62wz72l4XU=
=hAl/
-----END PGP SIGNATURE-----

--=-6p9/AyZgNjOQko2IdWVF--

