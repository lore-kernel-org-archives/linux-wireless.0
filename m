Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRTfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 14:35:53 -0500
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081216025542.GO18056@xi.wantstofly.org> (sfid-20081216_041438_420262_E83C7397)
References: <20081216025542.GO18056@xi.wantstofly.org>
	 (sfid-20081216_041438_420262_E83C7397)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4e0rg+2OVG9r/PQ1jCZZ"
Date: Thu, 18 Dec 2008 20:35:50 +0100
Message-Id: <1229628950.3601.43.camel@johannes.berg> (sfid-20081218_203558_636924_FA668A4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4e0rg+2OVG9r/PQ1jCZZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-16 at 03:55 +0100, Lennert Buytenhek wrote:

> +static DEFINE_PCI_DEVICE_TABLE(mwl8k_table) =3D {
> +	{ PCI_VDEVICE(MARVELL, 0x2a2b) },		/* 88w8687 */
> +	{ PCI_VDEVICE(MARVELL, 0x2a30) },		/* 88w8687 */
> +	{ }
> +};


> +/* Translate PCI device ID to device number */
> +static u32 mwl8k_get_partnum(u16 pci_id)
> +{
> +	switch (pci_id) {
> +	case 0x2a2b:
> +	case 0x2a30:
> +		return 8687;
> +	default:
> +		return 0;
> +	}
> +}

It might make sense to do this with pci driver data in the device table
instead?


> +/* HT control fields for firmware */
> +struct ewc_ht_info {
> +	__u16	control1;
> +	__u16	control2;
> +	__u16	control3;
> +} __attribute__((packed));

Does the firmware support endian swapping? Or should this be annotated?

> +struct peer_capability_info {
> +	/* Peer type - AP vs. STA.  */
> +	__u8	peer_type;
> +
> +	/* Basic 802.11 capabilities from assoc resp.  */
> +	__u16	basic_caps;
> +
> +	/* Set if peer supports 802.11n high throughput (HT).  */
> +	__u8	ht_support;
> +
> +	/* Valid if HT is supported.  */
> +	__u16	ht_caps;
> +	__u8	extended_ht_caps;
> +	struct ewc_ht_info	ewc_info;
> +
> +	/* Legacy rate table. Intersection of our rates and peer rates.  */
> +	__u8	legacy_rates[MWL8K_IEEE_LEGACY_DATA_RATES];
> +
> +	/* HT rate table. Intersection of our rates and peer rates.  */
> +	__u8	ht_rates[MWL8K_MCS_BITMAP_SIZE];
> +	__u8	pad[pad_size];
> +
> +	/* If set, interoperability mode, no proprietary extensions.  */
> +	__u8	interop;
> +	__u8	pad2;
> +	__u8	station_id;
> +	__u16	amsdu_enabled;
> +} __attribute__((packed));

Same here, packed but no endian annotations?

> +static inline int mwl8k_get_frametype(__le16 fc)
> +{
> +	if (ieee80211_is_data(fc))
> +		return IEEE80211_FTYPE_DATA;
> +
> +	if (ieee80211_is_mgmt(fc))
> +		return IEEE80211_FTYPE_MGMT;
> +
> +	if (ieee80211_is_ctl(fc))
> +		return IEEE80211_FTYPE_CTL;
> +
> +	return 0;
> +}

That seems a little odd?

> +/* Inline functions to manipulate QoS field in data descriptor.  */
> +static inline u16 mwl8k_qos_setbit_tid(u16 qos, u8 tid)

> +static inline u16 mwl8k_qos_setbit_eosp(u16 qos)

> +static inline u16 mwl8k_qos_setbit_ack(u16 qos, u8 ack_policy)

> +static inline u16 mwl8k_qos_setbit_amsdu(u16 qos)

> +static inline u16 mwl8k_qos_setbit_qlen(u16 qos, u8 len)

Why do you need to work with the QoS header?

> +/* DMA header used by firmware and hardware.  */
> +struct mwl8k_dma_data {
> +	__u16 fwlen;
> +	struct ieee80211_hdr wh;
> +} __attribute__((packed));

endianness? Ok, I'm starting to suspect you program the endianness into
the firmware. Is that really a good idea? Firmware bugs might lurk that
way, and are harder to fix this way?

> +	/*
> +	 * Skb data is changed when DMA header is added.
> +	 * Unshare/Unclone skb.
> +	 */
> +	if (skb_cloned(skb))
> +		skb =3D skb_unshare(skb, GFP_ATOMIC);
> +	else if (skb_shared(skb))
> +		skb =3D skb_share_check(skb, GFP_ATOMIC);

That won't ever happen with mac80211 since it has modified the header
already anyway.

> +	/*
> +	 * Copy up/down the 802.11 header; the firmware requires
> +	 * we present a 2-byte payload length followed by a
> +	 * 4-address header (w/o QoS), followed (optionally) by
> +	 * any WEP/ExtIV header (but only filled in for CCMP).
> +	 */
> +	if (hdrlen < sizeof(struct mwl8k_dma_data)) {

That comparison seems slightly odd to me

> +		const int space =3D sizeof(struct mwl8k_dma_data) - hdrlen;
> +		u32 headroom =3D skb_headroom(skb);
> +
> +		if (headroom < space) {
> +			/* NB: should never happen */
> +			printk(KERN_ERR "Not enough headroom, need %d, "
> +					"found %d, len %d\n", space,
> +					headroom, skb->len);
> +			return NULL;
> +		}
> +		skb_push(skb, space);

maybe just remove the check then, it'll be done in skb_push and panic()

> +	/* Clear addr4 */
> +	memset(tr->wh.addr4, 0, IEEE80211_ADDR_LEN);

?

> +/*
> + * Scan a list of BSSIDs to process for finalize join.
> + * Allows for extension to process multiple BSSIDs.
> + */

Can you explain why you need to do this much BSSID stuff? Maybe we can
extend mac80211 a little instead?

> +		if (rx_desc->rx_status &
> +			MWL8K_RX_CTRL_DECRYPT_ERROR)
> +				status.flag |=3D RX_FLAG_MMIC_ERROR;

This seems inappropriate for, say, ccmp. Unless the hw flag is misnamed?

> +/* Function sleeps, cannot be called from atomic context.  */
> +static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
> +{

just stick in might_sleep() instead?

> +			printk(KERN_ERR
> +			"%s: Error removing DMA header from tx skb 0x%p.\n",
> +			priv->name, skb);

That looks a bit odd, and I think you're allowed to go > 80 cols for
printks now.

> +		/* Convert firmware status stuff into tx_status */
> +		if (MWL8K_TXD_SUCCESS(status)) {
> +			/* Transmit OK */
> +			info->flags |=3D IEEE80211_TX_STAT_ACK;
> +		} else if (MWL8K_TXD_FAIL_RETRY(status)) {
> +			info->status.excessive_retries =3D 1;
> +		}

Against which kernel is this? :)

> +		if (force)
> +			ieee80211_tx_status(hw, skb);
> +		else
> +			ieee80211_tx_status_irqsafe(hw, skb);

That's a little odd. You should only ever use one of them to avoid
ordering issues.

> +		/*
> +		 * Tell firmware to not send EAPOL pkts in an
> +		 * aggregate.  Verify against mac80211 tx path.  If
> +		 * stack turns off AMPDU for an EAPOL frame this
> +		 * check will be removed.
> +		 */

Can you elaborate how aggregation will work? Not relevant for this
patch, but for mac80211 ampdu work I am going to do.

> +	struct mwl8k_priv *priv =3D hw->priv;
> +
> +	if (hw =3D=3D NULL || hw->priv =3D=3D NULL)
> +		return -EINVAL;

That'll give coverity some fodder ;)

> +#define MWL8K_SUPPORTED_IF_FLAGS	FIF_BCN_PRBRESP_PROMISC

Not more? That's not very nice as a monitor then :)

> +mwl8k_configure_filter_exit:
> +	return rc;

Generally, I think your labels are a tad too verbose. But I can't say I
care much.

> +static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
> +{
> +	int rc;
> +	struct mwl8k_set_rts_threshold_worker *worker;
> +	struct mwl8k_priv *priv =3D hw->priv;
> +
> +	worker =3D kzalloc(sizeof(*worker), GFP_KERNEL);
> +	if (worker =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	worker->value =3D value;
> +
> +	rc =3D mwl8k_queue_work(hw, &worker->header,
> +			      priv->config_wq,
> +			      mwl8k_set_rts_threshold_wt);
> +	kfree(worker);
> +
> +	if (rc =3D=3D -ETIMEDOUT) {
> +		printk(KERN_ERR "%s() timed out\n", __func__);
> +		rc =3D -EINVAL;
> +	}
> +
> +	return rc;
> +}

Does that really need to be atomic? That seems odd and easy to change.

> +static void
> +mwl8k_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +		 enum sta_notify_cmd cmd, const u8 *addr)
> +{
> +}

No need to, just leave the function pointer NULL.

> +static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
> +			 const struct ieee80211_tx_queue_params *params)
> +{
> +	int rc;
> +	struct mwl8k_conf_tx_worker *worker;
> +	struct mwl8k_priv *priv =3D hw->priv;
> +
> +	worker =3D kzalloc(sizeof(*worker), GFP_KERNEL);
> +	if (worker =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	worker->queue =3D queue;
> +	worker->params =3D params;
> +	rc =3D mwl8k_queue_work(hw, &worker->header,
> +			      priv->config_wq, mwl8k_conf_tx_wt);
> +	kfree(worker);
> +	if (rc =3D=3D -ETIMEDOUT) {
> +		printk(KERN_ERR "%s() timed out\n", __func__);
> +		rc =3D -EINVAL;
> +	}
> +	return rc;
> +}

Are you sure this needs to be deferred to the wq? I'm not exactly sure
but I thought conf_tx wasn't under a spinlock?

> +static int mwl8k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> +			 const u8 *local_address, const u8 *address,
> +			 struct ieee80211_key_conf *key)
> +{
> +	int rc;
> +	struct mwl8k_set_key_worker *worker;
> +	struct mwl8k_priv *priv =3D hw->priv;
> +
> +	worker =3D kzalloc(sizeof(*worker), GFP_KERNEL);
> +	if (worker =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	worker->cmd =3D cmd;
> +	worker->local_address =3D local_address;
> +	worker->address =3D address;
> +	worker->key =3D key;
> +	rc =3D mwl8k_queue_work(hw, &worker->header,
> +			      priv->config_wq, mwl8k_set_key_wt);
> +	kfree(worker);
> +	if (rc =3D=3D -ETIMEDOUT) {
> +		printk(KERN_ERR "%s() timed out\n", __func__);
> +		rc =3D -EINVAL;
> +	}
> +	return rc;
> +}

set_key can sleep for sure, no need to queue it off to the wq.

Can you rebase onto wireless-testing with the API changes there?

johannes

--=-4e0rg+2OVG9r/PQ1jCZZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSqYTAAoJEKVg1VMiehFYxU8QAJ/SLB8VyL8Fq+r2t57xUoh+
1XKCwavlrQr97i6foTJCZYiRX7uNyNrFxkwuZyGGQxloz5FvEPPjKwrdSLD/ey28
JeKWG1QF1HpuO/jPj2XoZJxx3dD337tyafFqt0RlPDjy9HWck81Jf26xWbOxTLl9
61RT/UPh0LnhnMcgXAURZI4N3I9TuEYsZoFUu9GZOBc+5M+qarazgKdLao4e3rLx
hYV0mdvFBTY/+rxCDu5HGjzzbFt/TtgEzVvpfTwfuDdr//7pMnoDs+nLWit10ljH
ADDeNNSyR2Tntvjh8rN0VbWBowkYLekXQBAV8lfG+6+Q5NjAtN+wVkAj7m2dG32X
J/z8Q152DcAXE5Hej8EfO4GTfpfMGgr9jfcvGKRUQVXG3enSfcs9Y259BnpbHXfP
IAy2e1z9D8JASir6cWE1yC5HNezQUYbHv8p2XcebrixVLz7g1Ydzkrf4noIKMuRh
Z9eszEM8CYh6jCvxdlxq1XPk9E+3nVP0uTjXoJ3QIjCkdWpeT+larmkRbSBRgftR
nYjHHLdAt+Yl3poEZRfweZUtNvJo/778cyMpRlfBNe6DZ41zg9KtHOKkbueKWBzC
OW4boJonfS7dzuq7Sav88hu7vTNIASkJBORNY6u22eE5GwfSdlGKFXWKzUo7Xjyn
oEsqfms/nIDy5Nf3i7gH
=sgmp
-----END PGP SIGNATURE-----

--=-4e0rg+2OVG9r/PQ1jCZZ--

