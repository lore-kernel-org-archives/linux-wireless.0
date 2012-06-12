Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2FLP3a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 11:29:30 -0400
Date: Tue, 12 Jun 2012 17:28:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Woody Hung <Woody.Hung@mediatek.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00 : RT3290 chip support v3
Message-ID: <20120612152853.GC5657@redhat.com> (sfid-20120612_172934_494917_C333630A)
References: <1339491889-3587-1-git-send-email-Woody.Hung@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339491889-3587-1-git-send-email-Woody.Hung@mediatek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 12, 2012 at 05:04:49PM +0800, Woody Hung wrote:
> + * RFCSR 29:
> + */
> +#define RFCSR29_BIT0			FIELD8(0x01)
> +#define RFCSR29_BIT1			FIELD8(0x02)
> +#define RFCSR29_BIT2			FIELD8(0x04)
> +#define RFCSR29_BIT3			FIELD8(0x08)
> +#define RFCSR29_BIT4			FIELD8(0x10)
> +#define RFCSR29_BIT5			FIELD8(0x20)
> +#define RFCSR29_BIT6			FIELD8(0x40)
> +#define RFCSR29_BIT7			FIELD8(0x80)
[snip]
> + * RFCSR 47:
> + */
> +#define RFCSR47_BIT0			FIELD8(0x01)
> +#define RFCSR47_BIT1			FIELD8(0x02)
> +#define RFCSR47_BIT2			FIELD8(0x04)
> +#define RFCSR47_BIT3			FIELD8(0x08)
> +#define RFCSR47_BIT4			FIELD8(0x10)
> +#define RFCSR47_BIT5			FIELD8(0x20)
> +#define RFCSR47_BIT6			FIELD8(0x40)
> +#define RFCSR47_BIT7			FIELD8(0x80)
I would like to see descriptive names. Those does not tell much.

> +
> +		rt2800_bbp_read(rt2x00dev, 47, &value);
> +		value = ((value & ~0x80) | 0x80);
No, please use rt2x00_set_field8 function as in previous version of
the patch, but with descriptive name.
> +		rt2800_bbp_write(rt2x00dev, 47, value);
> +
> +		rt2800_bbp_read(rt2x00dev, 3, &value);
> +		value = ((value & ~0xc0) | 0xc0);
The same here.
> +	do {
> +		/*
> +		 * Check PLL_LD & XTAL_RDY.
> +		 */
> +		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +			rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
> +			if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
> +				(rt2x00_get_field32(reg, XTAL_RDY) == 1))
> +				break;
Indention.
> +			if (count >= 10)
> +				return -EFAULT;
-EFAULT mean "Bad address", which is not quite good error code, -EIO seems
to be most appropriate.
> +		} else {
> +			rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
What for you read this register here?
> +			count = 0;
> +		}
> +	return 0;
> +}
>  static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
> @@ -1028,6 +1095,17 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
>  
> +	/*
> +	 * In probe phase call rt2800_enable_wlan_rt3290 to enable wlan
> +	 * clk for rt3290. That avoid the MCU fail in start phase.
> +	 */
> +	if (rt2x00_rt(rt2x00dev, RT3290)) {
> +		retval = rt2800_enable_wlan_rt3290(rt2x00dev);
> +
> +		if (retval)
> +			return retval;
Probably moving this part just after

        retval = rt2800_probe_hw_mode(rt2x00dev);
        if (retval)
                return retval;

will be more appropriate.

Thanks
Stanislaw
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
