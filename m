Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdBFNQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 08:16:32 -0500
Date: Mon, 6 Feb 2017 14:14:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH v4 3/3] mt76: add driver code for MT76x2e
Message-ID: <20170206131400.GA2716@redhat.com> (sfid-20170206_141636_818235_F6FD242E)
References: <20170202115208.8614-1-nbd@nbd.name>
 <20170202115208.8614-4-nbd@nbd.name>
 <20170206112508.GA9255@redhat.com>
 <3f9febb5-696e-884b-7c9a-76866f3e55e9@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3f9febb5-696e-884b-7c9a-76866f3e55e9@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2017 at 12:52:56PM +0100, Felix Fietkau wrote:
> >> +void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
> >> +{
> >> +	u8 ackto, sifs, slottime = dev->slottime;
> >> +
> >> +	slottime += 3 * dev->coverage_class;
> >> +
> >> +	sifs = mt76_get_field(dev, MT_XIFS_TIME_CFG,
> >> +			      MT_XIFS_TIME_CFG_OFDM_SIFS);
> >> +
> >> +	ackto = slottime + sifs;
> >> +	mt76_rmw_field(dev, MT_TX_TIMEOUT_CFG,
> >> +		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
> >> +}
> > Interesting, if this correct way to configure the TX_TIMEOUT_CFG_ACKTO
> > we will also need this in rt2x00. Vendor drivers use 32 for this setting
> > and do not change it.
> I don't think vendor drivers even have support for coverage class.

Even not supporting coverage class (default is 0 anyway) this results
on different setting depending on slot time and sifs. My understanding
is that this is correct approach, compared to constant value used by
vendor.

> >> +static u32
> >> +mt76x2_tx_power_mask(u8 v1, u8 v2, u8 v3, u8 v4)
> >> +{
> >> +	u32 val = 0;
> >> +
> >> +	val |= (v1 & (BIT(6) - 1)) << 0;
> >> +	val |= (v2 & (BIT(6) - 1)) << 8;
> >> +	val |= (v3 & (BIT(6) - 1)) << 16;
> >> +	val |= (v4 & (BIT(6) - 1)) << 24;
> >> +	return val;
> >> +}
> > TX_PWR_CFG registers consist of eight 4bit entries, masking 
> > two entries with 0x3f does not seems to be correct.
> No, these registers consist of four 6bit entries. Both the vendor driver
> and the datasheet describe them this way.

That different compared to old devices. I assumed those registers would
not change meaning in MT76, but I guess I was wrong.

> >> +mt76x2_configure_tx_delay(struct mt76x2_dev *dev, enum nl80211_band band, u8 bw)
> >> +{
> >> +	u32 cfg0, cfg1;
> >> +
> >> +	if (mt76x2_ext_pa_enabled(dev, band)) {
> >> +		cfg0 = bw ? 0x000b0c01 : 0x00101101;
> >> +		cfg1 = 0x00011414;
> >> +	} else {
> >> +		cfg0 = bw ? 0x000b0b01 : 0x00101001;
> >> +		cfg1 = 0x00021414;
> >> +	}
> >> +	mt76_wr(dev, MT_TX_SW_CFG0, cfg0);
> >> +	mt76_wr(dev, MT_TX_SW_CFG1, cfg1);
> >> +
> >> +	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_CCK_SIFS,
> >> +		       13 + (bw ? 1 : 0));
> >> +}
> > SIFS for 2GHz should be 10us and for 5GHz 16us. Setting SIFS to 13
> > or 14 looks wrong for 2GHz band. Can be correct for 5GHz assuming
> > we have some internal delays configured on TX_SW_CFG registers.
> This is a CCK-only SIFS value (there's a separate one for OFDM).

CCK can be used only on 5GHz? OFDM only on 2GHz? I thought any rates can
be used on both bands. Or maybe this settings is just named wrongly
i.e. CCK_SIFS mean sifs for 5GHz and OFDM_SIFS - sifs for 2GHz ?

Stanislaw
