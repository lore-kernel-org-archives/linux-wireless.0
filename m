Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbCISfp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 14:35:45 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com>
	<1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
	<1425923186.28819.32.camel@sipsolutions.net>
Date: Mon, 09 Mar 2015 14:35:38 -0400
In-Reply-To: <1425923186.28819.32.camel@sipsolutions.net> (Johannes Berg's
	message of "Mon, 09 Mar 2015 18:46:26 +0100")
Message-ID: <wrfjbnk2qarp.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150309_193548_995995_3B0242AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> Hi Jes,
>
>> Many thanks to Johannes Berg for 802.11 insights and help and Larry
>> Finger for help with the vendor driver.
>
> :-)
>
> Just a few comments since this is really the first time I'm looking
> closely at the code.

Thanks!

>> +	h2c.ramask.cmd = H2C_SET_RATE_MASK;
>> +	put_unaligned_le16(ramask & 0xffff, &h2c.ramask.mask_lo);
>> +	put_unaligned_le16(ramask >> 16, &h2c.ramask.mask_hi);
>
> you marked that __packed, so the put_unaligned_le16() isn't really
> needed, you can use regular assignments (= cpu_to_le16(...))

I see, I wasn't aware of this, so figured better safe than sorry.

>> +static void
>> +rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>> +			  struct ieee80211_bss_conf *bss_conf, u32 changed)
>> +{
>> +	struct rtl8xxxu_priv *priv = hw->priv;
>> +	struct device *dev = &priv->udev->dev;
>> +	struct ieee80211_sta *sta;
>> +	u32 val32;
>> +#if 0
>> +	u16 val16;
>> +#endif
>> +	u8 val8;
>> +
>> +	if (changed & BSS_CHANGED_ASSOC) {
>> +		struct h2c_cmd h2c;
>> +
>> +		memset(&h2c, 0, sizeof(struct h2c_cmd));
>> +		rtl8xxxu_set_linktype(priv, vif->type);
>> +
>> +		if (bss_conf->assoc) {
>> +			rcu_read_lock();
>> +			sta = ieee80211_find_sta(vif, bss_conf->bssid);
>> +			if (!sta) {
>> +				dev_info(dev, "%s: ASSOC no sta found\n",
>> +					 __func__);
>> +				rcu_read_unlock();
>> +				goto error;
>> +			}
>> +
>> +			if (sta->ht_cap.ht_supported)
>> +				dev_info(dev, "%s: HT supported\n", __func__);
>> +			if (sta->vht_cap.vht_supported)
>> +				dev_info(dev, "%s: VHT supported\n", __func__);
>> +			rtl8xxxu_update_rate_table(priv, sta);
>> +			rcu_read_unlock();
>
> You could perhaps consider doing this in the sta_state() callback, when
> the station becomes associated, which is just before (or just after?)
> this gets called. Then you don't need to do the find_sta() here. Not
> that it's really a problem, but might look a bit nicer/cleaner.

I'll have a look. I wasn't sure which cases were only valid as a
sub-case of others, as I didn't find any documentation on it (but
admittedly I didn't look too hard).

>> +	if (changed & BSS_CHANGED_HT) {
>> +		u8 ampdu_factor, ampdu_density;
>> +		u8 sifs;
>> +
>> +		rcu_read_lock();
>> +		sta = ieee80211_find_sta(vif, bss_conf->bssid);
>> +		if (!sta) {
>> +			dev_info(dev, "BSS_CHANGED_HT: No HT sta found!\n");
>> +			rcu_read_unlock();
>> +			goto error;
>> +		}
>> +		if (sta->ht_cap.ht_supported) {
>> +			ampdu_factor = sta->ht_cap.ampdu_factor;
>> +			ampdu_density = sta->ht_cap.ampdu_density;
>> +			sifs = 0x0e;
>> +		} else {
>> +			ampdu_factor = 0;
>> +			ampdu_density = 0;
>> +			sifs = 0x0a;
>> +		}
>> +		rcu_read_unlock();
>
> This doesn't really make much sense - BSS_CHANGED_HT only says we
> changed bss_conf.ht_operation_mode which you don't use here.

In this case, is there another flag that would be more appropriate to
handle this under?

>> +	if (changed & BSS_CHANGED_BSSID) {
>> +		dev_info(dev, "Changed BSSID!\n");
>> +		rtl8xxxu_set_bssid(priv, bss_conf->bssid);
>> +
>> +		rcu_read_lock();
>> +		sta = ieee80211_find_sta(vif, bss_conf->bssid);
>> +		if (!sta) {
>> +			dev_info(dev, "No bssid sta found!\n");
>> +			rcu_read_unlock();
>> +			goto error;
>> +		}
>> +		rcu_read_unlock();
>> +	}
>
> You probably want to roll this up into CHANGED_ASSOC, since
> CHANGED_BSSID always really comes together with that for station mode.
> For IBSS things would be different but you don't seem to do that.

OK, sounds reasonable.

>> +	if (changed & BSS_CHANGED_BASIC_RATES) {
>> +		dev_info(dev, "Changed BASIC_RATES!\n");
>> +		rcu_read_lock();
>> +		sta = ieee80211_find_sta(vif, bss_conf->bssid);
>> +		if (sta)
>> +			rtl8xxxu_set_basic_rates(priv, sta);
>> +		else
>> +			dev_info(dev,
>> +				 "BSS_CHANGED_BASIC_RATES: No sta found!\n");
>> +
>> +		rcu_read_unlock();
>> +	}
>
> Ditto, this ever change during the lifetime of a BSS either, i.e. it
> cannot change while you're associated, and you don't care while you're
> not. Again, IBSS could be different, not quite sure off the top of my
> head.

Ditto

>> +static u32 rtl8xxxu_queue_select(struct ieee80211_hw *hw, struct
>> sk_buff *skb)
>> +{
>> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>> +	u32 queue;
>> +
>> +	if (unlikely(ieee80211_is_beacon(hdr->frame_control)))
>> +		queue = TXDESC_QUEUE_BEACON;
>> +	if (ieee80211_is_mgmt(hdr->frame_control))
>
> I think you mean else if?
>
> Anyway beacons cannot happen here except perhaps for injection, in which
> case you probably wouldn't want to use the beacon queue anyway. I'd
> remove the beacon case here entirely.

This is probably suffer from being derived from vendor driver. They have
a special beacon queue in the hardware which doesn't seem to map
directly to anything the Linux stack does.

Until I or someone else eventually implements AP support in this driver,
it probably doesn't matter.

>> +		queue = TXDESC_QUEUE_MGNT;
>> +	else
>> +		queue = rtl8xxxu_80211_to_rtl_queue(skb_get_queue_mapping(skb));
>> +
>> +	return queue;
>> +}
>> +
>> +static void rtl8xxxu_calc_tx_desc_csum(struct rtl8xxxu_tx_desc *tx_desc)
>> +{
>> +	u16 *ptr = (u16 *)tx_desc;
>> +	u16 csum = 0;
>> +	int i;
>> +
>> +	tx_desc->csum = cpu_to_le32(0);
>> +
>> +	for (i = 0; i < (sizeof(struct rtl8xxxu_tx_desc) / sizeof(u16)); i++)
>> +		csum = csum ^ le16_to_cpu(ptr[i]);
>> +
>> +	tx_desc->csum |= cpu_to_le32(csum);
>
> This seems kinda pointless - you can remove the = 0 above and just use =
> below?

Good point!

>> +static void rtl8xxxu_tx_complete(struct urb *urb)
>> +{
>> +	struct sk_buff *skb = (struct sk_buff *)urb->context;
>> +	struct ieee80211_tx_info *tx_info;
>> +	struct ieee80211_hw *hw;
>> +
>> +	tx_info = IEEE80211_SKB_CB(skb);
>> +	hw = tx_info->rate_driver_data[0];
>
> Seems a bit odd to do one initialisation in the declarations, and the
> other two not, but hey, that really doesn't matter :)
>
>> +	skb_pull(skb, sizeof(struct rtl8xxxu_tx_desc));
>> +
>> +	ieee80211_tx_info_clear_status(tx_info);
>> +	tx_info->status.rates[0].idx = -1;
>> +	tx_info->status.rates[0].count = 0;
>
> This is ... suboptimal. If you have any idea what the rates were it'd be
> good to report at least the one that went through.

I have been trying to find a way to get the actual rate used from the
hardware/firmware, but so far I haven't figured out how to get it. This
is the fun about having no specs.

>> +	tx_info->flags |= IEEE80211_TX_STAT_ACK;
>
> This shouldn't be done I think, if you can't report ACK status then I
> think you shouldn't do it at all, you aren't setting the
> IEEE80211_HW_REPORTS_TX_ACK_STATUS flag (though if you could have the
> ack status it would certainly be better to report it properly)

I think I was inspired by rtlwifi on this one. I can remove it.

> [snip code]
>
> Something about the TX is a bit fishy, you're using some software rate
> control data but aren't reporting any data back for rate control which
> seems to imply the device does it. You're also setting
> IEEE80211_HW_HAS_RATE_CONTROL which means you can't be using rates etc.
> here? I'll probably have to look into this more, it's an area that I'm
> not intimately familiar with.

The reason for this is that I can do either way and I have been playing
around with both. The vendor driver explicitly uses sw rate control for
management packets, whether this is necessary or legacy I cannot tell,
but I was trying to map to what they were doing.

>> +	for (i = 0; i < (sizeof(struct rtl8xxxu_rx_desc) / sizeof(u32)); i++)
>> +		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
>
> This is ... interesting. Wouldn't it make more sense to declare with
> little endian and without bitfields instead? bitfields are a bit of a
> minefield anyway as far as the C standard is concerned, so since you
> need to rely here on exact memory layout to satisfy the firmware API,
> I'd really avoid them.

Why declare things if you can blow your foot off with a machine gun?
It's something I was planning to look at eventually.

>> +		ieee80211_rx_irqsafe(hw, skb);
>
> Here you give up ownership of the skb
>
>> +		skb_size = sizeof(struct rtl8xxxu_rx_desc) +
>> +			RTL_RX_BUFFER_SIZE;
>> +		skb = dev_alloc_skb(skb_size);
>
> And then you allocate a new one into the same variable. From a
> maintenance POV that seems a bit ugly, perhaps you should avoid that.

I have always done this, kinda like it, but I am not really objecting to
it.

>> +		if (!skb) {
>> +			dev_warn(dev, "%s: Unable to allocate skb\n", __func__);
>> +			goto cleanup;
>> +		}
>> +
>> +		memset(skb->data, 0, sizeof(struct rtl8xxxu_rx_desc));
>> +		usb_fill_bulk_urb(&rx_urb->urb, priv->udev, priv->pipe_in,
>> +				  skb->data, skb_size, rtl8xxxu_rx_complete,
>
> This is also very strange, you're sending essentially random data, from
> an skb pointer that's not even a proper skb len? I think you just want
> to use kmalloc() here instead of having an skb? Or at least use
> skb_put() to reserve that memory area - it doesn't make a big difference
> to you but using the skb API in this way is likely to confuse people in
> the future.

I wanted to avoid having to allocate and then copy on arrival. It's been
quite common for drivers to do this, but I guess I ought to set the skb
len as well at this point to keep it clean.

> In fact you could even allocate a page instead, and then add it to the
> skb as a frag like iwlwifi does for example, and potentially not have to
> copy the data around later when it goes somewhere. Not sure that's worth
> it for this device though :)

I think the device can handle fragments, problem is I have zero
documentation on how it does so.

> Or perhaps just refactor the resubmission code into a small new
> function ... would also help with the error path here :)
>
> Also, what happens if you cannot allocate an skb here a few times? do
> your outstanding URBs get fewer every time? Or do you just have one?

Most likely I roll over and die, I'll make sure to sign the life
insurance over to you first though :)

>> +static int rtl8xxxu_submit_rx_urb(struct ieee80211_hw *hw)
>> +{
>> +	struct rtl8xxxu_priv *priv = hw->priv;
>> +	struct sk_buff *skb;
>> +	struct rtl8xxxu_rx_urb *rx_urb;
>> +	int skb_size;
>> +	int ret;
>> +
>> +	skb_size = sizeof(struct rtl8xxxu_rx_desc) + RTL_RX_BUFFER_SIZE;
>> +	skb = dev_alloc_skb(skb_size);
>> +	if (!skb)
>> +		return -ENOMEM;
>> +
>> +	memset(skb->data, 0, sizeof(struct rtl8xxxu_rx_desc));
>> +
>> +	rx_urb = kmalloc(sizeof(struct rtl8xxxu_rx_urb), GFP_ATOMIC);
>> +	if (!rx_urb) {
>> +		dev_kfree_skb(skb);
>> +		return -ENOMEM;
>> +	}
>> +	usb_init_urb(&rx_urb->urb);
>> +	rx_urb->hw = hw;
>> +
>> +	usb_fill_bulk_urb(&rx_urb->urb, priv->udev, priv->pipe_in, skb->data,
>> +			  skb_size, rtl8xxxu_rx_complete, skb);
>> +	usb_anchor_urb(&rx_urb->urb, &priv->rx_anchor);
>> +	ret = usb_submit_urb(&rx_urb->urb, GFP_ATOMIC);
>> +	if (ret)
>> +		usb_unanchor_urb(&rx_urb->urb);
>> +	return ret;
>> +}
>
> Perhaps some part of this could also be refactored with the above
> resubmission? It looks essentially the same, perhaps the above code
> could even just call this.

I'll have to look into this.
>
>> +static int rtl8xxxu_set_rts_threshold(struct ieee80211_hw *hw, u32 rts)
>> +{
>> +	if (rts > 2347)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>
> You should either use the value here, or not implement this callback if
> you want to rely on mac80211 setting the flags, IIRC.

I'll just remove it for now then - another one of these cases where I
looked at other code to see what it was doing, but didn't get to
figuring out what to do with it in this case.

>> +	switch (cmd) {
>> +	case SET_KEY:
>> +		/*
>> +		 * This is a bit of a hack - the lower bits of the cipher
>> +		 * suite selector happens to match the cipher index in the
>> +		 * CAM
>> +		 */
>
> It's probably not really a hack - the cipher suite selectors are defined
> in the spec, and we prefix them with the OUI to get the 32-bit
> identifier. If you assume standard-only ciphers then the lower 8 bits
> are just the number given to the suite in the spec.

Well yes and no, the hardware happens to match to those values too,
which is a bit of good luck. I think when it uses some of the strange
encryptions it no longer matches up.

>> +	if (priv->rf_paths > 1) {
>> +		sband->ht_cap.mcs.rx_mask[1] = 0xff;
>> +		sband->ht_cap.mcs.rx_highest = cpu_to_le16(300);
>> +		sband->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
>> +	} else {
>> +		sband->ht_cap.mcs.rx_mask[1] = 0x00;
>> +		sband->ht_cap.mcs.rx_highest = cpu_to_le16(150);
>> +	}
>
> You don't really need to set rx_highest, and you already cleared
> rx_mask[1], so you don't need the else branch and can remove the
> rx_highest from the if branch.

I wanted to prepare the code for adding support for 2r2t devices, but
I'll remove the rx_highest bits.

>> +	sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
>
> That doesn't seem true?

I may misunderstand the meaning of this parameter.

>> +	hw->wiphy->max_remain_on_channel_duration = 65535; /* ms */
>
> That's a bit excessive, but you don't implement ROC in hw anyway? so I'd
> remove this part I think.

OK

>> +	hw->wiphy->cipher_suites = rtl8xxxu_cipher_suites;
>> +	hw->wiphy->n_cipher_suites = ARRAY_SIZE(rtl8xxxu_cipher_suites);
>
> If you can deal with software crypto (which I believe you can) then you
> should just remove this and get all the ciphers, just making the ones
> you can do in software faster. You'll get all the new GCM ones, and
> CCM-256 too, in SW.

I'll try to remove it - this came in with some of the earliest pieces
of code I looked at when I started writing the driver.

Thanks for the feedback, it's very much appreciated!

Jes
