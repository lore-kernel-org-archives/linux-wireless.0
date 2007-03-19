Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61530 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965638AbXCSF5C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 01:57:02 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Mon, 19 Mar 2007 01:55:54 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070318101535.251183750@warmcat.com> <20070318101549.331461113@warmcat.com>
In-Reply-To: <20070318101549.331461113@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2854416.f1BBlf97Qt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703190156.07984.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2854416.f1BBlf97Qt
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 18 March 2007 06:15, andy@warmcat.com wrote:
> From: Andy Green <andy@warmcat.com>
>
> Try #3
>  - moved to Michael Wu's method of tracking if we came in on a
>    monitor interface by using ifindex
>  - removed older proposed monitor interface tracking method and flags
>  - style fixes
>  - removed duped #include that is present in Michael Wu's patch already
>
> Try #2
>  - took Michael Wu's advice about better tools and basing on wireless-dev
>  - took Luis Rodriguez's advice about coding style makeover
>  - took Pavel Roskin's advice about little-endian radiotap
>
I've mostly made comments about style issues. There are only comments on th=
e=20
first instance of any style problem so please check the rest of the code fo=
r=20
the same problems.

> Index: linux-2.6.20.i386/include/net/mac80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index fb33b90..21e8990 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -1054,7 +1054,163 @@ ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data
> *tx) }
>
>
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
> +	/* this is the moment to interpret the radiotap header that
> +	 * must be at the start of the packet injected in Monitor
> +	 * mode into control and then discard the radiotap header
> +	 *
> +	 * Need to take some care with endian-ness since radiotap
> +	 * is apparently a little-endian struct, including the args
> +	*/
Line this up. :)

> +
> +	struct ieee80211_radiotap_header *rthdr =3D
> +		(struct ieee80211_radiotap_header *) skb->data;
> +
> +	/* small length lookup table for all radiotap types we heard of
> +	 * starting from b0 in the bitmap, so we can walk the payload
> +	 * area of the radiotap header
> +	 */
> +
> +	static const u8 radiotap_entry_sizes[] =3D {
> +		8, /* IEEE80211_RADIOTAP_TSFT */
> +		1, /* IEEE80211_RADIOTAP_FLAGS */
> +		1, /* IEEE80211_RADIOTAP_RATE */
> +		4, /* IEEE80211_RADIOTAP_CHANNEL */
> +		2, /* IEEE80211_RADIOTAP_FHSS */
> +		1, /* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
> +		1, /* IEEE80211_RADIOTAP_DBM_ANTNOISE */
> +		2, /* IEEE80211_RADIOTAP_LOCK_QUALITY */
> +		2, /* IEEE80211_RADIOTAP_TX_ATTENUATION */
> +		2, /* IEEE80211_RADIOTAP_DB_TX_ATTENUATION */
> +		1, /* IEEE80211_RADIOTAP_DBM_TX_POWER */
> +		1, /* IEEE80211_RADIOTAP_ANTENNA */
> +		1, /* IEEE80211_RADIOTAP_DB_ANTSIGNAL */
> +		1  /* IEEE80211_RADIOTAP_DB_ANTNOISE */
> +		/* add more here as they are defined */
> +	};
Hm, this could be integrated into the switch statement below, but it doesn'=
t=20
really matter much.

Have you looked into padding issues with radiotap headers? For example, if=
=20
there is a 1 byte field which is then followed by a 4 byte field, there nee=
ds=20
to be 3 bytes of padding after the first field, but if the field after were=
 2=20
bytes long, the padding would only be 1 byte (according to my understanding=
=20
of the radiotap specs).

> +	int tap_index =3D 0;
> +	u8 *tap_arg =3D skb->data + sizeof(struct ieee80211_radiotap_header);
> +	u32 *curr_arg_bitmap =3D &rthdr->it_present;
> +	u32 arg_bitmap =3D le32_to_cpu(*curr_arg_bitmap);
> +
> +	if (rthdr->it_version) return TXRX_DROP; /* version byte as magic */
Put the return on the next line.

> +
> +	/* sanity check for skb length and radiotap length field */
> +	if (skb->len < (le16_to_cpu(rthdr->it_len) +
> +	    sizeof(struct ieee80211_hdr)))
> +		return TXRX_DROP;
> +
> +	/* find payload start allowing for extended bitmap(s) */
> +
> +	if (le32_to_cpu(rthdr->it_present) & 0x80000000) {
> +		while( le32_to_cpu(*((u32 *)tap_arg)) & 0x80000000)
Space after while, remove the space before le32_to_cpu.

> +			tap_arg +=3D sizeof(u32);
> +		tap_arg +=3D sizeof(u32);
> +	}
> +
> +	/* default control situation for all injected packets */
> +
> +	control->retry_limit =3D 1; /* no retry */
> +	control->key_idx =3D -1; /* no encryption key */
> +	control->flags &=3D ~(IEEE80211_TXCTL_USE_RTS_CTS |
> +		IEEE80211_TXCTL_USE_CTS_PROTECT);
> +	control->flags |=3D (IEEE80211_TXCTL_DO_NOT_ENCRYPT |
> +		IEEE80211_TXCTL_NO_ACK);
> +	control->antenna_sel_tx =3D 0; /* default to default/diversity */
> +
> +	/* for every radiotap entry we can at
> +	 * least skip (by knowing the length)...
> +	 */
> +
> +	while (tap_index < sizeof(radiotap_entry_sizes)) {
> +		int i, target_rate;
> +
> +		if (!(arg_bitmap & 1)) goto next_entry;
> +
> +		/* arg is present */
> +
> +		switch(tap_index) { /* deal with if interested */
Space after switch.

> +
> +		case IEEE80211_RADIOTAP_RATE:
> +			/* radiotap "rate" u8 is in
> +			 * 500kbps units, eg, 0x02=3D1Mbps
> +			 * ieee80211 "rate" int is
> +			 * in 100kbps units, eg, 0x0a=3D1Mbps
> +			 */
> +			target_rate =3D (*tap_arg) * 5;
> +			for (i =3D 0; i < tx->local->num_curr_rates; i++) {
> +				struct ieee80211_rate *r =3D
> +					&tx->local->curr_rates[i];
> +
> +				if (r->rate <=3D target_rate) {
> +					if (r->flags &
> +					   IEEE80211_RATE_PREAMBLE2) {
> +						control->tx_rate =3D r->val2;
> +					} else {
> +						control->tx_rate =3D r->val;
> +					}
> +
> +
> +						/* end on exact match */
Too much indenting on comments again.

> +					if (r->rate =3D=3D target_rate)
> +						i =3D tx->local->num_curr_rates;
> +				}
> +			}
> +			break;
> +
> +		case IEEE80211_RADIOTAP_ANTENNA:
> +			/* radiotap uses 0 for 1st ant,
> +			 * mac80211 is 1 for 1st ant
> +			 * absence of IEEE80211_RADIOTAP_ANTENNA
> +			 * gives default/diversity
> +			*/
> +			control->antenna_sel_tx =3D (*tap_arg) + 1;
> +			break;
> +
> +		case IEEE80211_RADIOTAP_DBM_TX_POWER:
> +			control->power_level =3D *tap_arg;
> +			break;
> +
> +		default:
> +			break;
> +		}
> +
> +		tap_arg +=3D radiotap_entry_sizes[tap_index];
> +
> +		next_entry:
This label is indented too much.=20

> +
> +		tap_index++;
> +		if (unlikely((tap_index & 31) =3D=3D 0)) {
> +			/* completed current u32 bitmap */
> +			if (arg_bitmap & 1) { /* b31 was set, there is more */
> +				/* move to next u32 bitmap */
> +				curr_arg_bitmap++;
> +				arg_bitmap =3D le32_to_cpu(*curr_arg_bitmap);
> +			} else {
> +				/* he didn't give us any more bitmaps: end */
I suppose this is an accurate assumption 99% of the time, but I think being=
=20
gender neutral sounds better.

> @@ -1062,6 +1218,9 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data
> *tx, {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_sub_if_data *sdata;
> +	ieee80211_txrx_result res=3DTXRX_CONTINUE;
Space before and after the =3D.

> @@ -1071,7 +1230,32 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data
> *tx, tx->sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	tx->sta =3D sta_info_get(local, hdr->addr1);
>  	tx->fc =3D le16_to_cpu(hdr->frame_control);
> +
> +	/* set defaults for things that can be set by
> +	 * injected radiotap headers
> +	 */
> +
>  	control->power_level =3D local->hw.conf.power_level;
> +	control->antenna_sel_tx =3D local->hw.conf.antenna_sel_tx;
> +	if (local->sta_antenna_sel !=3D STA_ANTENNA_SEL_AUTO && tx->sta )
Kill the space before the parenthesis.

> @@ -1215,14 +1397,24 @@ static int ieee80211_tx(struct net_device *dev,
> struct sk_buff *skb, return 0;
>  	}
>
> -	__ieee80211_tx_prepare(&tx, skb, dev, control);
> +	res_prepare=3D__ieee80211_tx_prepare(&tx, skb, dev, control);
> +
> +	if (res_prepare=3D=3DTXRX_DROP) {
Space before and after the =3D=3D.

> +		dev_kfree_skb(skb);
> +		return 0;
> +	}
> +
>  	sta =3D tx.sta;
>  	tx.u.tx.mgmt_interface =3D mgmt;
>
> -	for (handler =3D local->tx_handlers; *handler !=3D NULL; handler++) {
> -		res =3D (*handler)(&tx);
> -		if (res !=3D TXRX_CONTINUE)
> -			break;
> +	if (res_prepare=3D=3DTXRX_QUEUED) { /* if it was an injected packet */
> +		res=3DTXRX_CONTINUE;
> +	} else {
> +		for (handler =3D local->tx_handlers; *handler !=3D NULL; handler++) {
> +			res =3D (*handler)(&tx);
> +			if (res !=3D TXRX_CONTINUE)
> +				break;
> +		}
>  	}
>
>  	skb =3D tx.skb; /* handlers are allowed to change skb */
> @@ -1456,6 +1648,52 @@ static int ieee80211_subif_start_xmit(struct sk_bu=
ff
> *skb, goto fail;
>  	}
>
> +	if (unlikely(sdata->type=3D=3DIEEE80211_IF_TYPE_MNTR)) {
> +		struct ieee80211_radiotap_header * prthdr=3D
Space after prthdr.

We could avoid this check altogether by spinning this code into a different=
=20
function and setting the xmit handler appropriately depending on if we're=20
initializing/switching to a monitor interface or not. Not entirely sure if=
=20
it's worth it, but I thought I'd mention it.

Thanks,
=2DMichael Wu

--nextPart2854416.f1BBlf97Qt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/iX3T3Oqt9AH4aERAmnfAKDUnqPVwDLosGVQm8QKcVFvEwDLsgCg3AZ+
/zTyIHtwMyfIiEH2rQUKcJw=
=mW09
-----END PGP SIGNATURE-----

--nextPart2854416.f1BBlf97Qt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
