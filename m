Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:59678 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab0DHWdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 18:33:55 -0400
Received: by ey-out-2122.google.com with SMTP id d26so254199eyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Apr 2010 15:33:54 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register initialization.
Date: Fri, 9 Apr 2010 00:33:47 +0200
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-7-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <201004090033.48341.IvDoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010, Gertjan van Wingerde wrote:
> rt2x00 had preliminary support for RT3070 based devices, but the support was
> incomplete.
> Update the RT3070 register initialization to be similar to the latest Ralink
> vendor driver.
> 
> With this patch my rt3070 based devices start showing a sign of life.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>


> @@ -1086,7 +1084,7 @@ EXPORT_SYMBOL_GPL(rt2800_link_tuner);
>   */
>  int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  {
> -	u32 reg;
> +	u32 reg, reg2;
>  	unsigned int i;
>  
>  	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> @@ -1204,11 +1202,18 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
>  	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
>  
> -	if (rt2x00_is_usb(rt2x00dev) &&
> -	    rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) == 0x0200) {
> +	if (rt2x00_rt(rt2x00dev, RT3070)) {
>  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
> -		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
> -		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> +
> +		if (rt2x00_rev(rt2x00dev) < 0x0201) {
> +			reg = 0x00000000;
> +			reg2 = 0x0000002c;
> +		} else {
> +			reg = 0x00080606;
> +			reg2 = 0x00000000;
> +		}
> +		rt2800_register_write(rt2x00dev, TX_SW_CFG1, reg);
> +		rt2800_register_write(rt2x00dev, TX_SW_CFG2, reg2);

Might as well put the rt2800_register_write call into the if, rather then storing
it into variables first. That way it is consistent with the rest of the code.
 
> @@ -1751,6 +1739,28 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
>  	rt2800_bbp_write(rt2x00dev, 4, bbp);
>  
> +	if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201)
> +		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
> +
> +	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
> +	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
> +	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
> +
> +	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> +	rt2x00_set_field8(&rfcsr, RFCSR17_R2, 0);
> +	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
> +	if ((eeprom & 0x07) >= 1)

Might be nicer to do the access using rt2x00_get_field16,
plus some name for this magical field in the header file.

> +		rt2x00_set_field8(&rfcsr, RFCSR17_R1, eeprom & 0x07);
> +	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> +
> +	if (rt2x00_rt(rt2x00dev, RT3070)) {
> +		rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
> +		rfcsr &= 0x77;
> +		if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201)
> +			rfcsr |= 0x03;
> +		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
> +	}

Any ideas what these fields mean? Could set_field8 and _get_field8 simplify the code?

Ivo
