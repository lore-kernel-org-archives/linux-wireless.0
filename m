Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2842 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbXELTdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 May 2007 15:33:00 -0400
Date: Sat, 12 May 2007 15:18:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jeff Garzik <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Message-ID: <20070512191823.GB6018@tuxdriver.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705111602.18729.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705111602.18729.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2007 at 04:02:18PM -0400, Michael Wu wrote:

> +void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
> +{
> +	struct rtl8187_priv *priv = dev->priv;
> +
> +	data <<= 8;
> +	data |= addr | 0x80;
> +
> +	rtl818x_iowrite8(priv, &priv->map->PHY[3], (data >> 24) & 0xFF);
> +	rtl818x_iowrite8(priv, &priv->map->PHY[2], (data >> 16) & 0xFF);
> +	rtl818x_iowrite8(priv, &priv->map->PHY[1], (data >> 8) & 0xFF);
> +	rtl818x_iowrite8(priv, &priv->map->PHY[0], data & 0xFF);
> +
> +	msleep(1);
> +}

msleep seems better than mdelay, but why is it there at all?  There is
no need to speculate.  Just give us a comment for why you put it there,
even if it is "copied from app note" or somesuch.

> +	msleep(200);
> +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
> +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
> +	rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
> +	msleep(200);

Please comment these magic delays too, and give us a symbolic constant
for the magic addres.  Yes, "RTL8187_MAGIC_INIT_ADDR_1" is better than a
raw number. :-)

Or, just remove this section as you indicated you could do in another
post.

> +	/* setup card */
> +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 0);
> +	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
> +
> +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 4);

More magic addresses...

> +	/* host_usb_init */
> +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 0);
> +	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
> +	reg = rtl818x_ioread8(priv, (u8 *)0xFE53);
> +	rtl818x_iowrite8(priv, (u8 *)0xFE53, reg | (1 << 7));
> +	rtl818x_iowrite8(priv, (u8 *)0xFF85, 4);

And more...

> +	rtl818x_iowrite16(priv, (__le16 *)0xFFFE, 0x10);
> +	rtl818x_iowrite8(priv, &priv->map->TALLY_SEL, 0x80);
> +	rtl818x_iowrite8(priv, (u8 *)0xFFFF, 0x60);

And more...

> +static void rtl8187_register_read(struct eeprom_93cx6 *eeprom)
> +{
> +	struct ieee80211_hw *dev = eeprom->data;
> +	struct rtl8187_priv *priv = dev->priv;
> +	u8 reg = rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
> +
> +	eeprom->reg_data_in = reg & RTL818X_EEPROM_CMD_WRITE;
> +	eeprom->reg_data_out = reg & RTL818X_EEPROM_CMD_READ;
> +	eeprom->reg_data_clock = reg & RTL818X_EEPROM_CMD_CK;
> +	eeprom->reg_chip_select = reg & RTL818X_EEPROM_CMD_CS;
> +}
> +
> +static void rtl8187_register_write(struct eeprom_93cx6 *eeprom)
> +{
> +	struct ieee80211_hw *dev = eeprom->data;
> +	struct rtl8187_priv *priv = dev->priv;
> +	u8 reg = RTL818X_EEPROM_CMD_PROGRAM;
> +
> +	if (eeprom->reg_data_in)
> +		reg |= RTL818X_EEPROM_CMD_WRITE;
> +	if (eeprom->reg_data_out)
> +		reg |= RTL818X_EEPROM_CMD_READ;
> +	if (eeprom->reg_data_clock)
> +		reg |= RTL818X_EEPROM_CMD_CK;
> +	if (eeprom->reg_chip_select)
> +		reg |= RTL818X_EEPROM_CMD_CS;
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, reg);
> +	udelay(10);
> +}

It seems like these should be named "rtl8187_eeprom_register_{read,write}"
instead?  Current names seem like you are operating on the wireless
parts instead of just the eeprom.

> +	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
> +		printk(KERN_WARNING "rtl8187: Invalid hwaddr! Using randomly generated MAC address\n");

I would prefer to see lines wrapped at 80 columns (or less) if at all possible.

> +	for (i = 0; i < 3; i++) {
> +		eeprom_93cx6_read(&eeprom, 0x16 + i, &txpwr);
> +		(*channel++).val = txpwr & 0xFF;
> +		(*channel++).val = txpwr >> 8;
> +	}
> +	for (i = 0; i < 2; i++) {
> +		eeprom_93cx6_read(&eeprom, 0x3D + i, &txpwr);
> +		(*channel++).val = txpwr & 0xFF;
> +		(*channel++).val = txpwr >> 8;
> +	}
> +	for (i = 0; i < 2; i++) {
> +		eeprom_93cx6_read(&eeprom, 0x1B + i, &txpwr);
> +		(*channel++).val = txpwr & 0xFF;
> +		(*channel++).val = txpwr >> 8;
> +	}
> +
> +	eeprom_93cx6_read(&eeprom, 0x05, &priv->txpwr_base);

Magic offsets for the eeprom data...

> +	/* 0 means asic B-cut, we should use SW 3 wire
> +	 * bit-by-bit banging for radio. 1 means we can use
> +	 * USB specific request to write radio registers */
> +	priv->asic_rev = rtl818x_ioread8(priv, (u8 *)0xFFFE) & 0x3;

More magic register addresses...

> +u16 rtl8225_read(struct ieee80211_hw *dev, u8 addr)
> +{
> +	struct rtl8187_priv *priv = dev->priv;
> +	u16 reg80, reg82, reg84, out;
> +	int i;
> +
> +	reg80 = rtl818x_ioread16(priv, &priv->map->RFPinsOutput);
> +	reg82 = rtl818x_ioread16(priv, &priv->map->RFPinsEnable);
> +	reg84 = rtl818x_ioread16(priv, &priv->map->RFPinsSelect);
> +
> +	reg80 &= ~0xF;
> +
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, reg82 | 0x000F);
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, reg84 | 0x000F);
> +
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
> +	udelay(4);
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80);
> +	udelay(5);
> +
> +	for (i = 4; i >= 0; i--) {
> +		u16 reg = reg80 | ((addr >> i) & 1);
> +
> +		if (!(i & 1)) {
> +			rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg);
> +			udelay(1);
> +		}
> +
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg | (1 << 1));
> +		udelay(2);
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg | (1 << 1));
> +		udelay(2);
> +
> +		if (i & 1) {
> +			rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg);
> +			udelay(1);
> +		}
> +	}
> +
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +			  reg80 | (1 << 3) | (1 << 1));
> +	udelay(2);
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +			  reg80 | (1 << 3));
> +	udelay(2);
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +			  reg80 | (1 << 3));
> +	udelay(2);
> +
> +	out = 0;
> +	for (i = 11; i >= 0; i--) {
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg80 | (1 << 3));
> +		udelay(1);
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg80 | (1 << 3) | (1 << 1));
> +		udelay(2);
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg80 | (1 << 3) | (1 << 1));
> +		udelay(2);
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg80 | (1 << 3) | (1 << 1));
> +		udelay(2);
> +
> +		if (rtl818x_ioread16(priv, &priv->map->RFPinsInput) & (1 << 1))
> +			out |= 1 << i;
> +
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +				  reg80 | (1 << 3));
> +		udelay(2);
> +	}
> +
> +	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput,
> +			  reg80 | (1 << 3) | (1 << 2));
> +	udelay(2);

Please explain the origin of the delays...

> +static const u16 rtl8225bcd_rxgain[] = {
> +	0x0400, 0x0401, 0x0402, 0x0403, 0x0404, 0x0405, 0x0408, 0x0409,
> +	0x040a, 0x040b, 0x0502, 0x0503, 0x0504, 0x0505, 0x0540, 0x0541,
> +	0x0542, 0x0543, 0x0544, 0x0545, 0x0580, 0x0581, 0x0582, 0x0583,
> +	0x0584, 0x0585, 0x0588, 0x0589, 0x058a, 0x058b, 0x0643, 0x0644,
> +	0x0645, 0x0680, 0x0681, 0x0682, 0x0683, 0x0684, 0x0685, 0x0688,
> +	0x0689, 0x068a, 0x068b, 0x068c, 0x0742, 0x0743, 0x0744, 0x0745,
> +	0x0780, 0x0781, 0x0782, 0x0783, 0x0784, 0x0785, 0x0788, 0x0789,
> +	0x078a, 0x078b, 0x078c, 0x078d, 0x0790, 0x0791, 0x0792, 0x0793,
> +	0x0794, 0x0795, 0x0798, 0x0799, 0x079a, 0x079b, 0x079c, 0x079d,
> +	0x07a0, 0x07a1, 0x07a2, 0x07a3, 0x07a4, 0x07a5, 0x07a8, 0x07a9,
> +	0x07aa, 0x07ab, 0x07ac, 0x07ad, 0x07b0, 0x07b1, 0x07b2, 0x07b3,
> +	0x07b4, 0x07b5, 0x07b8, 0x07b9, 0x07ba, 0x07bb, 0x07bb
> +};
> +
> +static const u8 rtl8225_agc[] = {
> +	0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e,
> +	0x9d, 0x9c, 0x9b, 0x9a, 0x99, 0x98, 0x97, 0x96,
> +	0x95, 0x94, 0x93, 0x92, 0x91, 0x90, 0x8f, 0x8e,
> +	0x8d, 0x8c, 0x8b, 0x8a, 0x89, 0x88, 0x87, 0x86,
> +	0x85, 0x84, 0x83, 0x82, 0x81, 0x80, 0x3f, 0x3e,
> +	0x3d, 0x3c, 0x3b, 0x3a, 0x39, 0x38, 0x37, 0x36,
> +	0x35, 0x34, 0x33, 0x32, 0x31, 0x30, 0x2f, 0x2e,
> +	0x2d, 0x2c, 0x2b, 0x2a, 0x29, 0x28, 0x27, 0x26,
> +	0x25, 0x24, 0x23, 0x22, 0x21, 0x20, 0x1f, 0x1e,
> +	0x1d, 0x1c, 0x1b, 0x1a, 0x19, 0x18, 0x17, 0x16,
> +	0x15, 0x14, 0x13, 0x12, 0x11, 0x10, 0x0f, 0x0e,
> +	0x0d, 0x0c, 0x0b, 0x0a, 0x09, 0x08, 0x07, 0x06,
> +	0x05, 0x04, 0x03, 0x02, 0x01, 0x01, 0x01, 0x01,
> +	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
> +};
> +
> +static const u8 rtl8225_gain[] = {
> +	0x23, 0x88, 0x7c, 0xa5,	/* -82dBm */
> +	0x23, 0x88, 0x7c, 0xb5,	/* -82dBm */
> +	0x23, 0x88, 0x7c, 0xc5,	/* -82dBm */
> +	0x33, 0x80, 0x79, 0xc5,	/* -78dBm */
> +	0x43, 0x78, 0x76, 0xc5,	/* -74dBm */
> +	0x53, 0x60, 0x73, 0xc5,	/* -70dBm */
> +	0x63, 0x58, 0x70, 0xc5,	/* -66dBm */
> +};
> +
> +static const u8 rtl8225_threshold[] = {
> +	0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd
> +};
> +
> +static const u8 rtl8225_tx_gain_cck_ofdm[] = {
> +	0x02, 0x06, 0x0e, 0x1e, 0x3e, 0x7e
> +};
> +
> +static const u8 rtl8225_tx_power_cck[] = {
> +	0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02,
> +	0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02,
> +	0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02,
> +	0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02,
> +	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03,
> +	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03
> +};
> +
> +static const u8 rtl8225_tx_power_cck_ch14[] = {
> +	0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00,
> +	0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00,
> +	0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00,
> +	0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00,
> +	0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00,
> +	0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00
> +};
> +
> +static const u8 rtl8225_tx_power_ofdm[] = {
> +	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
> +};
> +
> +static const u32 rtl8225_chan[] = {
> +	0x085c, 0x08dc, 0x095c, 0x09dc, 0x0a5c, 0x0adc, 0x0b5c,
> +	0x0bdc, 0x0c5c, 0x0cdc, 0x0d5c, 0x0ddc, 0x0e5c, 0x0f72
> +};

Plesae explain the origin of the numbers in these tables...

> +	rtl8225_write_phy_ofdm(dev, 2, 0x42);
> +	rtl8225_write_phy_ofdm(dev, 6, 0x00);
> +	rtl8225_write_phy_ofdm(dev, 8, 0x00);

And these numbers...


> +	rtl8225_write_phy_ofdm(dev, 5, *tmp);
> +	rtl8225_write_phy_ofdm(dev, 7, *tmp);

And these...

> +	rtl8225_write(dev, 0x0, 0x067); msleep(1);
> +	rtl8225_write(dev, 0x1, 0xFE0); msleep(1);
> +	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
> +	rtl8225_write(dev, 0x3, 0x441); msleep(1);
> +	rtl8225_write(dev, 0x4, 0x486); msleep(1);
> +	rtl8225_write(dev, 0x5, 0xBC0); msleep(1);
> +	rtl8225_write(dev, 0x6, 0xAE6); msleep(1);
> +	rtl8225_write(dev, 0x7, 0x82A); msleep(1);
> +	rtl8225_write(dev, 0x8, 0x01F); msleep(1);
> +	rtl8225_write(dev, 0x9, 0x334); msleep(1);
> +	rtl8225_write(dev, 0xA, 0xFD4); msleep(1);
> +	rtl8225_write(dev, 0xB, 0x391); msleep(1);
> +	rtl8225_write(dev, 0xC, 0x050); msleep(1);
> +	rtl8225_write(dev, 0xD, 0x6DB); msleep(1);
> +	rtl8225_write(dev, 0xE, 0x029); msleep(1);
> +	rtl8225_write(dev, 0xF, 0x914); msleep(100);
> +
> +	rtl8225_write(dev, 0x2, 0xC4D); msleep(200);
> +	rtl8225_write(dev, 0x2, 0x44D); msleep(200);

And these...

> +	rtl8225_write_phy_ofdm(dev, 0x00, 0x01); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x01, 0x02); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x02, 0x42); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x03, 0x00); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x04, 0x00); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x05, 0x00); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x06, 0x40); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x07, 0x00); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x08, 0x40); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x09, 0xfe); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x0a, 0x09); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x0b, 0x80); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x0c, 0x01); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x0e, 0xd3); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x0f, 0x38); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x10, 0x84); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x11, 0x06); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x12, 0x20); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x13, 0x20); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x14, 0x00); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x15, 0x40); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x16, 0x00); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x17, 0x40); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x18, 0xef); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x19, 0x19); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x1a, 0x20); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x1b, 0x76); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x1c, 0x04); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x1e, 0x95); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x1f, 0x75); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x20, 0x1f); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x21, 0x27); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x22, 0x16); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x24, 0x46); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x25, 0x20); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);
> +	rtl8225_write_phy_ofdm(dev, 0x27, 0x88); msleep(1);
> +
> +	rtl8225_write_phy_ofdm(dev, 0x0d, rtl8225_gain[2 * 4]);
> +	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225_gain[2 * 4 + 2]);
> +	rtl8225_write_phy_ofdm(dev, 0x1d, rtl8225_gain[2 * 4 + 3]);
> +	rtl8225_write_phy_ofdm(dev, 0x23, rtl8225_gain[2 * 4 + 1]);
> +
> +	rtl8225_write_phy_cck(dev, 0x00, 0x98); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x03, 0x20); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x04, 0x7e); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x05, 0x12); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x06, 0xfc); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x07, 0x78); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x08, 0x2e); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x11, 0x88); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x12, 0x47); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x13, 0xd0);
> +	rtl8225_write_phy_cck(dev, 0x19, 0x00);
> +	rtl8225_write_phy_cck(dev, 0x1a, 0xa0);
> +	rtl8225_write_phy_cck(dev, 0x1b, 0x08);
> +	rtl8225_write_phy_cck(dev, 0x40, 0x86);
> +	rtl8225_write_phy_cck(dev, 0x41, 0x8d); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x42, 0x15); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x43, 0x18); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x44, 0x1f); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x45, 0x1e); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x46, 0x1a); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x47, 0x15); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x48, 0x10); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x49, 0x0a); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x4a, 0x05); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x4b, 0x02); msleep(1);
> +	rtl8225_write_phy_cck(dev, 0x4c, 0x05); msleep(1);

And these, etc, etc, etc...

> +static const u8 rtl8225z2_tx_power_cck_ch14[] = {
> +	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
> +};
> +
> +static const u8 rtl8225z2_tx_power_cck[] = {
> +	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
> +};
> +
> +static const u8 rtl8225z2_tx_power_ofdm[] = {
> +	0x42, 0x00, 0x40, 0x00, 0x40
> +};
> +
> +static const u8 rtl8225z2_tx_gain_cck_ofdm[] = {
> +	0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
> +	0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
> +	0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11,
> +	0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
> +	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d,
> +	0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23
> +};

More magic number tables of unknown origin...you get the idea. :-)  I
realize that these are either copied straight from a datasheet or from
someone's reverse engineered sources -- let's just have a comment saying
so for each block of these.

> +	__le32	TX_CONF;
> +#define RTL818X_TX_CONF_LOOPBACK_MAC	(1 << 17)
> +#define RTL818X_TX_CONF_NO_ICV		(1 << 19)
> +#define RTL818X_TX_CONF_DISCW		(1 << 20)
> +#define RTL818X_TX_CONF_R8180_ABCD	(2 << 25)
> +#define RTL818X_TX_CONF_R8180_F		(3 << 25)
> +#define RTL818X_TX_CONF_R8185_ABC	(4 << 25)
> +#define RTL818X_TX_CONF_R8185_D		(5 << 25)
> +#define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
> +#define RTL818X_TX_CONF_CW_MIN		(1 << 31)

Using an enum for a sparsely defined bitmask like this should let the
compiler identify if we misuse a bitmask in the wrong place.

Do we lose the benefits of the __le32 typechecking by using an enum?
There is probably some way to force that...

John
-- 
John W. Linville
linville@tuxdriver.com
