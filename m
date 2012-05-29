Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab2E2MWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:22:07 -0400
Date: Tue, 29 May 2012 14:21:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Woody Hung <Woody.Hung@mediatek.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00 : RT3290 chip support v2
Message-ID: <20120529122139.GC2441@redhat.com> (sfid-20120529_142211_266734_ECE7C560)
References: <1338191012-2750-1-git-send-email-Woody.Hung@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338191012-2750-1-git-send-email-Woody.Hung@mediatek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Woody

CCing users@rt2x00.serialmonkey.com, please add this list to CC
when you will be posting next patch evalutation.

On Mon, May 28, 2012 at 03:43:32PM +0800, Woody Hung wrote:
> +		rt2800_register_read(rt2x00dev, OSC_CTRL, &reg);
> +		rt2x00_set_field32(&reg, OSC_ROSC_EN, 1);
> +		rt2800_register_write(rt2x00dev, OSC_CTRL, reg);
> +		rt2x00_set_field32(&reg, OSC_ROSC_EN, 1);
> +		rt2x00_set_field32(&reg, OSC_CAL_REQ, 1);
> +		rt2x00_set_field32(&reg, OSC_REF_CYCLE, 0x27);
> +		rt2800_register_write(rt2x00dev, OSC_CTRL, reg);
You write OSC_CTRL register twice, was that intended? If so please
comment why?

> +		rt2800_register_read(rt2x00dev, COEX_CFG0, &reg);
> +		rt2x00_set_field32(&reg, COEX_CFG_ANT, 0);
> +		rt2x00_set_field32(&reg, COEX_CFG_ANT, 0x5e);
> +		rt2800_register_write(rt2x00dev, COEX_CFG0, reg);
One COEX_CFG_ANT set is unneeded, perhaps you wanted to set some other
field.

> +		rt2800_register_write(rt2x00dev, COEX_CFG2, 0x0017937F);
What this magic number mean?

> +		if (rt2x00_rt(rt2x00dev, RT3290))
> +			rt2800_register_write(rt2x00dev, TX_SW_CFG0,
> +				0x00000404);
> +		else
> +			rt2800_register_write(rt2x00dev, TX_SW_CFG0,
> +				0x00000400);
Would be nice if last argument will be aligned to the "(" bracket.

> +		rt2800_bbp_read(rt2x00dev, 47, &value);
> +		rt2x00_set_field8(&value, RFCSR2_RESCAL_EN, 1);
> +		rt2800_bbp_write(rt2x00dev, 47, value);
> +
> +		rt2800_bbp_read(rt2x00dev, 3, &value);
> +		rt2x00_set_field8(&value, RFCSR7_BITS67, 1);
> +		rt2800_bbp_write(rt2x00dev, 3, value);
You use RFCSR2_ and RFCSR7_ defines for BBP registers 47 and 3. Assuming
values are correct, they need proper BBP_ defines (with descriptive
name, not like BBP3_BITS67)

> +	if (rt2x00_rt(rt2x00dev, RT3290)) {
> +		rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
> +		rt2x00_set_field8(&rfcsr, RFCSR27_ADC, 0xc0);
> +		rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
Same here: RFCSR29 reg use RFCSR27 value.

> +static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
> +{
> +	u32 reg;
> +	int i, count;
> +
> +	rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
> +	rt2x00_set_field32(&reg, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
> +	rt2x00_set_field32(&reg, FRC_WL_ANT_SET, 1);
> +	if ((rt2x00_get_field32(reg, WLAN_EN) == 1))
> +		return 0;
This check should be before two rt2x00_set_field32(), otherwise
looks like rt2800_register_write() is missing.

> +	count = 0;
> +	do {
> +		reg = 0;
This must be not needed, otherwise we check register values, which we do
not read from hardware.

> +		/*
> +		 * Check PLL_LD & XTAL_RDY.
> +		 */
> +		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +			rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
> +			if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
> +				(rt2x00_get_field32(reg, XTAL_RDY) == 1))
Alignment. And also brackets are unneeded, i.e. use (x == 1 && y == 1)
instead of ((x == 1) && (y == 1)).

> +				break;
> +			udelay(REGISTER_BUSY_DELAY);
> +		}
> +
> +		if (i >= REGISTER_BUSY_COUNT) {
> +
> +			if (count >= 10)
> +				break;
Shouldn't we return error if device fail to initialize PLL & XTAL ? Upper
functions probably should then print error and stop initialization i.e.
make ->pci_probe function fail and disallow to use this this device by
driver. 

> +			rt2800_register_write(rt2x00dev, 0x58, 0x018);
> +			udelay(REGISTER_BUSY_DELAY);
> +			rt2800_register_write(rt2x00dev, 0x58, 0x418);
> +			udelay(REGISTER_BUSY_DELAY);
> +			rt2800_register_write(rt2x00dev, 0x58, 0x618);
> +			udelay(REGISTER_BUSY_DELAY);
> +			count++;
> +		} else {
> +			rt2800_register_read(rt2x00dev,
> +				WPDMA_GLO_CFG, &reg);
Not needed line break.

> +		rt2800_register_write(rt2x00dev,
> +			INT_SOURCE_CSR, 0x7fffffff);
Not needed line break.

Thanks
Stanislaw
