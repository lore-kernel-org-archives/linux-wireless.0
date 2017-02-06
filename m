Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40109 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbdBFLw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 06:52:59 -0500
Subject: Re: [PATCH v4 3/3] mt76: add driver code for MT76x2e
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <20170202115208.8614-1-nbd@nbd.name>
 <20170202115208.8614-4-nbd@nbd.name> <20170206112508.GA9255@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <3f9febb5-696e-884b-7c9a-76866f3e55e9@nbd.name> (sfid-20170206_125303_810983_5FAF6353)
Date: Mon, 6 Feb 2017 12:52:56 +0100
MIME-Version: 1.0
In-Reply-To: <20170206112508.GA9255@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-06 12:25, Stanislaw Gruszka wrote:
> On Thu, Feb 02, 2017 at 12:52:08PM +0100, Felix Fietkau wrote:
>> This is a 2x2 PCIe 802.11ac chipset by MediaTek
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Driver looks great to me, though I think it could be better commented.
> I have some minor issues, but if they need to be fixed, it could be done
> by incremental patches after apply this one to the tree.
> 
> Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
Thanks for the review.

>> +enum dma_msg_port {
>> +	WLAN_PORT,
>> +	CPU_RX_PORT,
>> +	CPU_TX_PORT,
>> +	HOST_PORT,
>> +	VIRTUAL_CPU_RX_PORT,
>> +	VIRTUAL_CPU_TX_PORT,
>> +	DISCARD,
>> +};
> Not used ?
Yeah, I guess it can be removed.

>> +void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
>> +{
>> +	u8 ackto, sifs, slottime = dev->slottime;
>> +
>> +	slottime += 3 * dev->coverage_class;
>> +
>> +	sifs = mt76_get_field(dev, MT_XIFS_TIME_CFG,
>> +			      MT_XIFS_TIME_CFG_OFDM_SIFS);
>> +
>> +	ackto = slottime + sifs;
>> +	mt76_rmw_field(dev, MT_TX_TIMEOUT_CFG,
>> +		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
>> +}
> Interesting, if this correct way to configure the TX_TIMEOUT_CFG_ACKTO
> we will also need this in rt2x00. Vendor drivers use 32 for this setting
> and do not change it.
I don't think vendor drivers even have support for coverage class.

> Note we have also EXP_ACT_TIME and EXP_CTS_TIME registers, which stay
> with default settings, but perhaps should be changed depending on
> channel properties as well.
> 
>> +static u32
>> +mt76x2_tx_power_mask(u8 v1, u8 v2, u8 v3, u8 v4)
>> +{
>> +	u32 val = 0;
>> +
>> +	val |= (v1 & (BIT(6) - 1)) << 0;
>> +	val |= (v2 & (BIT(6) - 1)) << 8;
>> +	val |= (v3 & (BIT(6) - 1)) << 16;
>> +	val |= (v4 & (BIT(6) - 1)) << 24;
>> +	return val;
>> +}
> TX_PWR_CFG registers consist of eight 4bit entries, masking 
> two entries with 0x3f does not seems to be correct.
No, these registers consist of four 6bit entries. Both the vendor driver
and the datasheet describe them this way.

>> +	mt76_wr(dev, MT_TX_PWR_CFG_3,
>> +		mt76x2_tx_power_mask(t.ht[12], t.ht[14], t.ht[0], t.ht[2]));
>> +	mt76_wr(dev, MT_TX_PWR_CFG_4,
>> +		mt76x2_tx_power_mask(t.ht[4], t.ht[6], 0, 0));
>> +	mt76_wr(dev, MT_TX_PWR_CFG_7,
>> +		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
>> +	mt76_wr(dev, MT_TX_PWR_CFG_8,
>> +		mt76x2_tx_power_mask(t.ht[14], t.vht[8], t.vht[8], 0));
>> +	mt76_wr(dev, MT_TX_PWR_CFG_9,
>> +		mt76x2_tx_power_mask(t.ht[6], t.vht[8], t.vht[8], 0));
> Looks like some of arguments instead of t.vht[x] accidentally become t.ht[x],
> for example t.vht[6] is never used.
There are not enough register fields for all rates individually, so they
overlap. This looks a bit confusing and random, but I did check it
carefully against the vendor driver and the datasheet.

>> +static void
>> +mt76x2_configure_tx_delay(struct mt76x2_dev *dev, enum nl80211_band band, u8 bw)
>> +{
>> +	u32 cfg0, cfg1;
>> +
>> +	if (mt76x2_ext_pa_enabled(dev, band)) {
>> +		cfg0 = bw ? 0x000b0c01 : 0x00101101;
>> +		cfg1 = 0x00011414;
>> +	} else {
>> +		cfg0 = bw ? 0x000b0b01 : 0x00101001;
>> +		cfg1 = 0x00021414;
>> +	}
>> +	mt76_wr(dev, MT_TX_SW_CFG0, cfg0);
>> +	mt76_wr(dev, MT_TX_SW_CFG1, cfg1);
>> +
>> +	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_CCK_SIFS,
>> +		       13 + (bw ? 1 : 0));
>> +}
> SIFS for 2GHz should be 10us and for 5GHz 16us. Setting SIFS to 13
> or 14 looks wrong for 2GHz band. Can be correct for 5GHz assuming
> we have some internal delays configured on TX_SW_CFG registers.
This is a CCK-only SIFS value (there's a separate one for OFDM).

> But again this is interesting for rt2x00, where we stay with
> defaults, but looks we should configure XIFS_TIME_CFG based on
> channel. 
I think many of these might be mt76x2 specific tweaks, so be careful
with applying any of that to rt2x00.

>> +	if (chandef->width >= NL80211_CHAN_WIDTH_40)
>> +		sifs++;
>> +
>> +	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_OFDM_SIFS, sifs);
> This probably should be set together with MT_XIFS_TIME_CFG_CCK_SIFS in 
> mt76x2_configure_tx_delay().
Will look into that.

>> +static int mt76x2_insert_hdr_pad(struct sk_buff *skb)
>> +{
>> +	int len = ieee80211_get_hdrlen_from_skb(skb);
>> +	int ret;
>> +
>> +	if (len % 4 == 0)
>> +		return 0;
>> +
>> +	if (skb_headroom(skb) < 2) {
>> +		ret = pskb_expand_head(skb, 2, 0, GFP_ATOMIC);
>> +		if (ret != 0)
>> +			return ret;
> This should not be needed if hw->extra_tx_headroom is set properly.
Thanks, will send a follow-up cleanup patch if this one is accepted.

>> +	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
>> +		qsel = 0;
> For better understating: qsel = MT_QSEL_MGMT;
Right.

>> +void mt76x2_pre_tbtt_tasklet(unsigned long arg)
>> +{
>> +	struct mt76x2_dev *dev = (struct mt76x2_dev *) arg;
>> +	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
>> +	struct beacon_bc_data data = {};
>> +	struct sk_buff *skb;
>> +	int i, nframes;
>> +
>> +	data.dev = dev;
>> +	__skb_queue_head_init(&data.q);
>> +
>> +	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
> This symbol, not like most of other mac80211 symbols, is exported via
> EXPORT_SYMBOL_GPL(), so I'm not sure if it can be used on dual licensed
> file, perhaps licence of this file should be changed to GPL only.
Technically only the resulting binary will become GPL. I still want to
keep the source code of the entire driver ISC licensed to make it easier
for the BSDs to copy code from it.

- Felix
