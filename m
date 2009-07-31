Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35453 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZGaVUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:20:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [RESEND] [PATCHv3] b43 add harware tkip
Date: Fri, 31 Jul 2009 23:20:00 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com> <83a869cd0907311400g2e94f217g3f4aefc64681e0b5@mail.gmail.com>
In-Reply-To: <83a869cd0907311400g2e94f217g3f4aefc64681e0b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907312320.02171.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 July 2009 23:00:01 gregor kowski wrote:
> Update v3 : add a module parameter to enable hw tkip, Coding style
> fix, locking fix
> Update v2 : work with qos, implement dump key, fix an issue with setting
> random value on tkip key clear.
> PS : this depends on "b43 : remove old kidx API" and "remove wrong
> probe_resp_plcp write"
> 
> This add hardware tkip for b43.
> 
> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
> 
> Index: linux-2.6/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/b43/dma.c	2009-07-31
> 20:51:10.000000000 +0000
> +++ linux-2.6/drivers/net/wireless/b43/dma.c	2009-07-31 20:54:06.000000000 +0000
> @@ -1188,7 +1188,7 @@
>  	header = &(ring->txhdr_cache[(slot / TX_SLOTS_PER_FRAME) * hdrsize]);
>  	cookie = generate_cookie(ring, slot);
>  	err = b43_generate_txhdr(ring->dev, header,
> -				 skb->data, skb->len, info, cookie);
> +				 skb, info, cookie);
>  	if (unlikely(err)) {
>  		ring->current_slot = old_top_slot;
>  		ring->used_slots = old_used_slots;
> Index: linux-2.6/drivers/net/wireless/b43/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-07-31
> 20:51:10.000000000 +0000
> +++ linux-2.6/drivers/net/wireless/b43/main.c	2009-07-31
> 20:56:10.000000000 +0000
> @@ -80,6 +80,10 @@
>  module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
>  MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> 
> +static int modparam_hwtkip;
> +module_param_named(hwtkip, modparam_hwtkip, int, 0444);
> +MODULE_PARM_DESC(hwtkip, "Enable hardware tkip.");
> +
>  static int modparam_qos = 1;
>  module_param_named(qos, modparam_qos, int, 0444);
>  MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
> @@ -836,6 +840,76 @@
>  	}
>  }
> 
> +/* The ucode will use phase1 key with TEK key to decrypt rx packets.
> + * When a packet is received, the iv32 is checked.
> + * - if it doesn't the packet is returned without modification (and software
> + *   decryption can be done). That's what happen when iv16 wrap.
> + * - if it does, the rc4 key is computed, and decryption is tried.
> + *   Either it will success and B43_RX_MAC_DEC is returned,
> + *   either it fails and B43_RX_MAC_DEC|B43_RX_MAC_DECERR is returned
> + *   and the packet is not usable (it got modified by the ucode).
> + * So in order to never have B43_RX_MAC_DECERR, we should provide
> + * a iv32 and phase1key that match. Because we drop packets in case of
> + * B43_RX_MAC_DECERR, if we have a correct iv32 but a wrong phase1key, all
> + * packets will be lost without higher layer knowing (ie no resync possible
> + * until next wrap).
> + *
> + * NOTE : this should support 50 key like RCMTA because
> + * (B43_SHM_SH_KEYIDXBLOCK - B43_SHM_SH_TKIPTSCTTAK)/14 = 50
> + */
> +static void rx_tkip_phase1_write(struct b43_wldev *dev, u8 index, u32 iv32,
> +		u16 *phase1key)
> +{
> +	unsigned int i;
> +	u32 offset;
> +	const u8 per_sta_keys_start = 4;

Can we add an empty line here before the code begins?

> +	if (!modparam_hwtkip)
> +		return;
> +
> +	B43_WARN_ON(index < per_sta_keys_start);
> +	/* We have four default TX/ RX keys.
> +	 * Physical mac 0 is mapped to physical key 4.
> +	 * So we must adjust the index here.
> +	 */
> +	index -= per_sta_keys_start;
> +
> +	if (b43_debug(dev, B43_DBG_KEYS)) {
> +		b43dbg(dev->wl, "rx_tkip_phase1_write : idx 0x%x, iv32 0x%x\n",
> +				index, iv32);
> +	}
> +	/* Write the key to the  RX tkip shared mem */
> +	offset = B43_SHM_SH_TKIPTSCTTAK + index * (10 + 4);
> +	for (i = 0; i < 10; i += 2) {
> +		b43_shm_write16(dev, B43_SHM_SHARED, offset + i,
> +				phase1key ? phase1key[i / 2] : 0);
> +	}
> +	b43_shm_write16(dev, B43_SHM_SHARED, offset + i, iv32);
> +	b43_shm_write16(dev, B43_SHM_SHARED, offset + i + 2, iv32 >> 16);
> +}
> +
> +static void b43_op_update_tkip_key(struct ieee80211_hw *hw,
> +			struct ieee80211_key_conf *keyconf, const u8 *addr,
> +			u32 iv32, u16 *phase1key)
> +{
> +	struct b43_wl *wl = hw_to_b43_wl(hw);
> +	struct b43_wldev *dev;
> +	int index = keyconf->hw_key_idx;
> +

I'd add

	if (B43_WARN_ON(!modparam_hwtkip))
		return;

here, because it's a cheap way to detect possible mac80211 bugs.
Mac80211 should not ever call this function, if we reject all tkip keys. But if
it does (due to a bug), this cheap check will prevent keymac trashing and keep the
device working.

> +	mutex_lock(&wl->mutex);
> +
> +	dev = wl->current_dev;
> +	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
> +		goto out_unlock;
> +
> +	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
> +
> +	rx_tkip_phase1_write(dev, index, iv32, phase1key);
> +	keymac_write(dev, index, addr);
> +
> +out_unlock:
> +	mutex_unlock(&wl->mutex);
> +}
> +


The rest of the patch looks very good.


-- 
Greetings, Michael.
