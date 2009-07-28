Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43417 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZG1QKL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:10:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
Date: Tue, 28 Jul 2009 18:08:35 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
In-Reply-To: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907281808.35906.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 July 2009 22:49:17 gregor kowski wrote:
> Update : work with qos, implement dump key, fix an issue with setting
> random value on tkip key clear.
> PS : this depends on "b43 : remove old kidx API"
> 
> This add hardware tkip for b43.

First of all, I don't really want to support hw tkip on b43.
Broadcom removed the support for hw tkip from their drivers. I bet they
had a very good reason to do so.

So can we put hw tkip support under module parameter that defaults to OFF?

> Index: linux-2.6/drivers/net/wireless/b43/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-07-27
> 20:40:14.000000000 +0000
> +++ linux-2.6/drivers/net/wireless/b43/main.c	2009-07-27
> 20:46:05.000000000 +0000
> @@ -836,6 +836,64 @@
>  	}
>  }
> 
> +/* The ucode will use this with key to decrypt rx packets.
> + * It will first check if the iv32 match,
> + * - if they don't it returns the packet without decryption (and software
> + *   decryption can be done). That's what happen when iv16 wrap.
> + * - if they do, the rc4 key is computed with tkip phase2, and
> + *   the wep decryption is tried on the packet. Either it will
> + *   success and B43_RX_MAC_DEC is returned, either it fails
> + *   and B43_RX_MAC_DEC|B43_RX_MAC_DECERR is returned and the packet
> + *   is not usable (wrong key used on it).
> + * So in order to never have B43_RX_MAC_DECERR, we should provide
> + * a iv32 and phase1key that match. Because we drop packets in case of
> + * B43_RX_MAC_DECERR, if we have a correct iv32 but a wrong phase1key, all
> + * packets will be lost without higher layer knowing (ie no resync possible
> + * until next wrap).
> + *
> + * NOTE : this should support 50 key like RCMTA because
> + * (B43_SHM_SH_KEYIDXBLOCK - B43_SHM_SH_TKIPTSCTTAK)/14 = 50
> + */

It's rather hard for me to understand your comments. You should try to fix
a few spelling and grammar errors and such...

> +static void rx_tkip_phase1_write(struct b43_wldev *dev, u8 index, u32 iv32,
> +		u16 *phase1key)
> +{
> +	unsigned int i;
> +	u32 offset;
> +	const u8 per_sta_keys_start = 4;
> +
> +	B43_WARN_ON(index < per_sta_keys_start);
> +	/* We have two default TX keys and possibly two default RX keys.

That comment is wrong.
We have 4 default TX/RX keys.

> +	 * Physical mac 0 is mapped to physical key 4 or 8, depending

It's mapped to 4, because you removed the old API support.
(I'm not sure whether we want to remove that support, yet. Gimme some time on it...)

> +	 * on the firmware version.
> +	 * So we must adjust the index here.
> +	 */
> +	index -= per_sta_keys_start;
> +
> +	if (b43_debug(dev, B43_DBG_KEYS))
> +		b43dbg(dev->wl, "rx_tkip_phase1_write : idx 0x%x, iv32 0x%x\n",
> +				index, iv32);

Add curly brackets. (yes, the code is correct. But our coding style is to use brackets
on multiline-indents).

> +	/* Write the key to the  RX tkip shared mem */
> +	offset = B43_SHM_SH_TKIPTSCTTAK + index * (10 + 4);
> +	for (i = 0; i < 10; i += 2) {
> +		b43_shm_write16(dev, B43_SHM_SHARED, offset + i, phase1key[i/2]);
                                                                           ^^^
Coding style

> +	}

Remove curly brackets.

> +	b43_shm_write16(dev, B43_SHM_SHARED, offset + i, iv32);
> +	b43_shm_write16(dev, B43_SHM_SHARED, offset + i + 2, iv32>>16);
                                                             ^^^^^^^^

Coding style

> +}
> +
> +static void b43_mac_update_tkip_key(struct ieee80211_hw *hw,
> +			struct ieee80211_key_conf *keyconf, const u8 *addr,
> +			u32 iv32, u16 *phase1key)
> +{
> +	struct b43_wl *wl = hw_to_b43_wl(hw);
> +	struct b43_wldev *dev = wl->current_dev;
> +	int index = keyconf->hw_key_idx;
> +	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
> +
> +	rx_tkip_phase1_write(dev, index, iv32, phase1key);
> +	keymac_write(dev, index, addr);
> +}

Completely lacks locking. You need to hold the mutex and check for dev validity.
See other b43_op_* for examples.

>  static void do_key_write(struct b43_wldev *dev,
>  			 u8 index, u8 algorithm,
>  			 const u8 *key, size_t key_len, const u8 *mac_addr)
> @@ -848,6 +906,19 @@
> 
>  	if (index >= per_sta_keys_start)
>  		keymac_write(dev, index, NULL);	/* First zero out mac. */
> +	if (algorithm == B43_SEC_ALGO_TKIP) {
> +		/*
> +		 * We should provide an initial iv32, phase1key pair.
> +		 * We could start with iv32=0 and compute the corresponding
> +		 * phase1key, but this mean calling ieee80211_get_tkip_key
> +		 * with a fake skb (or export other tkip function).
> +		 * Because we are lazy we hope iv32 won't start with
> +		 * 0xffffffff and let's b43_mac_update_tkip_key provide a
> +		 * correct pair.
> +		 */
> +		rx_tkip_phase1_write(dev, index, 0xffffffff, (u16*)buf);
> +	} else if (index >= per_sta_keys_start) /* clear it */
> +		rx_tkip_phase1_write(dev, index, 0, (u16*)buf);

Why do you state /* clear it */, but yet you pass the key?
Shouldn't you pass a NULL pointer and modify rx_tkip_phase1_write() to cope with
NULL pointers? (write zeros if the key is NULL).

>  	if (key)
>  		memcpy(buf, key, key_len);
>  	key_write(dev, index, algorithm, buf);
> @@ -865,6 +936,8 @@
>  {
>  	int i;
> 
> +	if (algorithm == B43_SEC_ALGO_TKIP && key_len == 32)
> +		key_len = 16;

Can you add a comment to this? It doesn't make sense without explanation.

>  	if (key_len > B43_SEC_KEYSIZE)
>  		return -EINVAL;
>  	for (i = 0; i < dev->max_nr_keys; i++) {
> @@ -946,6 +1019,14 @@
>  		printk("   Algo: %04X/%02X", algo, key->algorithm);
> 
>  		if (index >= 4) {
> +			if (key->algorithm == B43_SEC_ALGO_TKIP) {
> +				printk("   TKIP: ");
> +				offset = B43_SHM_SH_TKIPTSCTTAK + (index - 4) * (10 + 4);
> +				for (i = 0; i < 14; i+=2) {
                                                    ^^^^
Coding style.

> +					u16 tmp = b43_shm_read16(dev, B43_SHM_SHARED, offset + i);
> +					printk("%02X%02X", (tmp & 0xFF), ((tmp >> 8) & 0xFF));
> +				}
> +			}
>  			rcmta0 = b43_shm_read32(dev, B43_SHM_RCMTA,
>  						((index - 4) * 2) + 0);
>  			rcmta1 = b43_shm_read16(dev, B43_SHM_RCMTA,
> @@ -1505,10 +1586,13 @@
>  	/* Looks like PLCP headers plus packet timings are stored for
>  	 * all possible basic rates
>  	 */
> +	/* FIXME this is the wrong offset : it goes in tkip rx phase1 shm */
> +#if 0
>  	b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
>  	b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
>  	b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
>  	b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
> +#endif
> 
>  	size = min((size_t) size, 0x200 - sizeof(struct b43_plcp_hdr6));
>  	b43_write_template_common(dev, probe_resp_data,

Please submit this hunk as separate patch.

> @@ -3667,8 +3751,9 @@
> 
>  	switch (cmd) {
>  	case SET_KEY:
> -		if (algorithm == B43_SEC_ALGO_TKIP) {
> -			/* FIXME: No TKIP hardware encryption for now. */
> +		if (algorithm == B43_SEC_ALGO_TKIP &&
> +		    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
> +			/* We support only pairwise key */
>  			err = -EOPNOTSUPP;
>  			goto out_unlock;
>  		}
> @@ -3698,6 +3783,8 @@
>  				     b43_hf_read(dev) & ~B43_HF_USEDEFKEYS);
>  		}
>  		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
> +		if (algorithm == B43_SEC_ALGO_TKIP)
> +			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
>  		break;
>  	case DISABLE_KEY: {
>  		err = b43_key_clear(dev, key->hw_key_idx);
> @@ -4425,6 +4512,7 @@
>  	.bss_info_changed	= b43_op_bss_info_changed,
>  	.configure_filter	= b43_op_configure_filter,
>  	.set_key		= b43_op_set_key,
> +	.update_tkip_key	= b43_mac_update_tkip_key,

Rename to
b43_op_update_tkip_key

>  	.get_stats		= b43_op_get_stats,
>  	.get_tx_stats		= b43_op_get_tx_stats,
>  	.get_tsf		= b43_op_get_tsf,

> @@ -257,9 +258,25 @@
>  		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
>  			   B43_TXH_MAC_KEYALG;
>  		wlhdr_len = ieee80211_hdrlen(fctl);
> -		iv_len = min((size_t) info->control.hw_key->iv_len,
> -			     ARRAY_SIZE(txhdr->iv));
> -		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
> +		if (key->algorithm == B43_SEC_ALGO_TKIP) {
> +			u16 phase1key[5];
> +			int i;
> +			/* we give the phase1key and iv16 here, the key is stored in
> +			 * shm. With that the hardware can do phase 2 and encryption.
> +			 */
> +			ieee80211_get_tkip_key(info->control.hw_key, skb_frag,
> IEEE80211_TKIP_P1_KEY, (u8*)phase1key);

Patch is linewrap damaged. Fix your mail agent.

> +			/* phase1key is in host endian */
> +			for (i = 0; i < 5; i++)
> +				phase1key[i] = cpu_to_le16(phase1key[i]);
> +
> +			memcpy(txhdr->iv, phase1key, 10);
> +			/* iv16 */
> +			memcpy(txhdr->iv+10, ((u8 *) wlhdr) + wlhdr_len, 3);
                                      ^^^^^
Coding style.


> +		} else {
> +			iv_len = min((size_t) info->control.hw_key->iv_len,
> +				     ARRAY_SIZE(txhdr->iv));
> +			memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
> +		}
>  	}
>  	if (b43_is_old_txhdr_format(dev)) {
>  		b43_generate_plcp_hdr((struct b43_plcp_hdr4 *)(&txhdr->old_format.plcp),


-- 
Greetings, Michael.
