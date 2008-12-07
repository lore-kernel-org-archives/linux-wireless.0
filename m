Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44558 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYLGOv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 09:51:28 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] Add stlc45xx, wi-fi driver for stlc4550/4560
References: <20081206173056.6853.95209.stgit@tikku>
	<20081206173211.6853.59029.stgit@tikku>
	<1228653534.22164.27.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 07 Dec 2008 16:51:08 +0200
In-Reply-To: <1228653534.22164.27.camel@johannes.berg> (ext Johannes Berg's message of "Sun\, 07 Dec 2008 13\:38\:54 +0100")
Message-ID: <87prk42g4j.fsf@nokia.com> (sfid-20081207_155134_032693_59A44F86)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2008-12-06 at 19:32 +0200, Kalle Valo wrote:
>
>
>> +static const u8 default_cal_channels[] = {
>> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x6c, 0x09,

[...]

>> +	0x00 };
>> +
>> +static const u8 default_cal_rssi[] = {
>> +	0x0a, 0x01, 0x72, 0xfe, 0x1a, 0x00, 0x00, 0x00, 0x0a, 0x01, 0x72,

[...]

>> +	0x00, 0x00, 0x00, 0x00, 0x00 };
>
> Is this data actually usable?

Yes, it is. I tested it yesterday and it works ok.

> The static data in cx3110x didn't even parse correctly iirc.

I don't even remember cx3110x having any static calibration data,
wlan-cal provided it always. But then again I haven't looked at
cx3110x for a long time, I might remember wrong.

>> +static void stlc45xx_tx_edcf(struct stlc45xx *stlc);
>> +static void stlc45xx_tx_setup(struct stlc45xx *stlc);
>> +static void stlc45xx_tx_scan(struct stlc45xx *stlc);
>> +static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable);
>> +static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave);
>> +static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave);
>
> Can you reorder the file?

Sure.

> And I think you must be basing this on top of your PS patches, so
> could you not put Vivek's in the middle too?

Actually I didn't use my PS patches when I tested this patch. But
true, I should try Vivek's patch also with stlc45xx.

>> +static ssize_t stlc45xx_sysfs_store_cal_rssi(struct device *dev,
>> +					     struct device_attribute *attr,
>> +					     const char *buf, size_t count)
>
> I still think it would be better to use the firmware framework with a
> custom helper for this. At least it should provide a uevent like crda
> does so userspace knows automatically when to upload the files after you
> reload the module for example, I think?

Yeah, you talked about this already and I liked it. I haven't
implemented it just because a lack of time. I'll add it to the todo
list.

>
>> +static ssize_t stlc45xx_sysfs_show_tx_buf(struct device *dev,
>> +					  struct device_attribute *attr,
>> +					  char *buf)
>> +{
>
> That should be in debugfs, I think?

I think I should even remove it.
>
>> +static int stlc45xx_request_firmware(struct stlc45xx *stlc)
>> +{
>> +	const struct firmware *fw;
>> +	int ret;
>> +
>> +	/* FIXME: should driver use it's own struct device? */
>> +	ret = request_firmware(&fw, "3826.arm", &stlc->spi->dev);
>
> own struct device? I don't see why it should? It doesn't have one
> anyway, does it?

There is stlc45xx_device:

	ret = platform_device_register(&stlc45xx_device);

All this device class stuff is not yet fully clear to me, that's why I
added that comment. I guess I should study this more on a boring train
ride.

>> +static int stlc45xx_upload_firmware(struct stlc45xx *stlc)
>
>> +	fw_addr = FIRMWARE_ADDRESS;
>> +	fw_len = stlc->fw_len;
>
>> +		stlc45xx_spi_write(stlc, SPI_ADRS_DMA_DATA, stlc->fw, _fw_len);
>> +
>> +		/* FIXME: I think this doesn't work if firmware is large,
>> +		 * this loop goes to second round. fw->data is not
>> +		 * increased at all! */
>> +	}
>
> Indeed, the last _spi_write above needs to have something like 
> 	stlc->fw + fw_addr - FIRMWARE_ADDRESS

Thanks, I'll fix it at some point.

>> +	/*
>> +	 * FIXME: this gives warning from __ieee80211_rx()
>> +	 *
>> +	 * status.rate_idx = data->rate;
>> +	 */
>
> That works on p54, afaik?

Yes, I haven't looked at this yet.

>> +	edcf->queues[0].aifs = 2;
>> +	edcf->queues[0].pad0 = 1;
>> +	edcf->queues[0].cwmin = 3;
>> +	edcf->queues[0].cwmax = 7;
>> +	edcf->queues[0].txop = 47;
>> +	edcf->queues[1].aifs = 2;
>> +	edcf->queues[1].pad0 = 0;
>> +	edcf->queues[1].cwmin = 7;
>> +	edcf->queues[1].cwmax = 15;
>> +	edcf->queues[1].txop = 94;
>> +	edcf->queues[2].aifs = 3;
>> +	edcf->queues[2].pad0 = 0;
>> +	edcf->queues[2].cwmin = 15;
>> +	edcf->queues[2].cwmax = 1023;
>> +	edcf->queues[2].txop = 0;
>> +	edcf->queues[3].aifs = 7;
>> +	edcf->queues[3].pad0 = 0;
>> +	edcf->queues[3].cwmin = 15;
>> +	edcf->queues[3].cwmax = 1023;
>> +	edcf->queues[3].txop = 0;
>
> Shouldn't that be taking values from mac80211?

Definitely, just has been pending on my todo list.

>> +	setup->bratemask = 0xffffffff;
>
> That should also take values from the BSS config.

Will fix.

>> +	scan->flags = LM_SCAN_EXIT;
>> +	scan->bratemask = 0x15f;
>
> or that? not sure

Me neither :)

>> +static int stlc45xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>> +{
>
>> +	entry = stlc45xx_txbuffer_alloc(stlc, skb->len);
>> +	if (!entry) {
>> +		/* the queue should be stopped before the firmware buffer
>> +		 * is full, so firmware buffer should always have enough
>> +		 * space */
>> +		if (net_ratelimit())
>> +			stlc45xx_warning("firmware buffer full");
>> +		spin_unlock_bh(&stlc->tx_lock);
>> +		return NETDEV_TX_BUSY;
>> +	}
>
> Just drop the frame please, it's much easier and I want to remove the
> possibility of not doing so from mac80211 at some point.

Will do.

>
>> +	for (i = 0; i < 8; i++) {
>> +		rate = ieee80211_get_tx_rate(stlc->hw, info);
>> +		data->aloft[i] = rate->hw_value;
>> +	}
>
> You can do much better, like p54, which makes minstrel work a lot
> better :)

I'll fix it.

>> +static int stlc45xx_op_add_interface(struct ieee80211_hw *hw,
>> +				     struct ieee80211_if_init_conf *conf)
>> +{
>> +	struct stlc45xx *stlc = hw->priv;
>> +
>> +	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
>> +
>> +	switch (conf->type) {
>> +	case NL80211_IFTYPE_STATION:
>> +		break;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
>
> No need for this any more since we added the interface_types bitmap. But
> you can keep it as well, for extra error checking.

I'll keep it anyway.

>> +static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
>> +					 struct ieee80211_if_init_conf *conf)
>> +{
>> +	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
>> +}
>
> You really need to implement this better for proper monitor mode.

It's on my todo list.

> Maybe it would be simpler to make p54 work? :) It also implements
> basic rates, slot handling and other things correctly already.

Due to non-technical reasons I cannot work with p54 and that makes
things a bit difficult. So my solution is that I try to make stlc45xx
as good as possible, and if someone wants to add spi support to p54
based on stlc45xx that would be just great.

>> +/* can't be const, mac80211 writes to this */
>> +static struct ieee80211_rate stlc45xx_rates[] = {
>> +	{ .bitrate = 10,  .hw_value = 0,    .hw_value_short = 0, },
>
> No need to list hw_value_short since you don't use it, mac80211 never
> uses hw_value or hw_value-short. Since this is identical to the idx you
> could even just use the idx and leave it off, though this is probably
> easier to understand (just a little less efficient).

I'll drop hw_value_short but I want to keep hw_value. Like you said,
it's easier to understand that way.

>> +/* can't be const, mac80211 writes to this */
>> +static struct ieee80211_supported_band stlc45xx_band_2ghz = {
>> +	.channels = stlc45xx_channels,
>> +	.n_channels = ARRAY_SIZE(stlc45xx_channels),
>> +	.bitrates = stlc45xx_rates,
>> +	.n_bitrates = ARRAY_SIZE(stlc45xx_rates),
>> +};
>
> Actually, I don't think mac80211 writes to this. Not that const or not
> const matters in the kernel at all, except during compilation.

Ok, I'll remove the comment.

>> +static int stlc45xx_register_mac80211(struct stlc45xx *stlc)
>> +{
>> +	/* FIXME: SET_IEEE80211_PERM_ADDR() requires default_mac_addr
>> +	   to be non-const for some strange reason */
>> +	static u8 default_mac_addr[ETH_ALEN] = {
>> +		0x00, 0x02, 0xee, 0xc0, 0xff, 0xee
>> +	};
>
> Probably just a missing const in the inline declaration :)

I'll send a patch.

>> +	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>> +		IEEE80211_HW_SIGNAL_DBM |
>> +		IEEE80211_HW_NOISE_DBM;
>> +	/* four bytes for padding */
>> +	hw->extra_tx_headroom = sizeof(struct s_lm_data_out) + 4;
>> +
>> +	/* unit us */
>> +	hw->channel_change_time = 1000;
>> +
>> +	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &stlc45xx_band_2ghz;
>> +
>> +	SET_IEEE80211_DEV(hw, &spi->dev);
>
> I don't see you setting interface_types anywhere, that isn't a good
> thing. mac80211 will automatically create a sta mode interface but
> that's more a bug than a feature, and you won't be able to recreate it.

I'll fix it.

>> +#define MAC2STR(a) ((a)[0], (a)[1], (a)[2], (a)[3], (a)[4], (a)[5])
>> +#define MACSTR "%02x:%02x:%02x:%02x:%02x:%02x"
>
> Those should be %pM now, I think? Not sure that's in wireless-testing
> yet though, but that tree still has DECLARE_MAC_BUF etc.

%pM specifier is really cool and I'll add support for that as soon it
hits wireless-testing. But I didn't find it from wireless-testing, I
guess it will come after the next merge window.

Thank you for reviewing this again.

-- 
Kalle Valo
