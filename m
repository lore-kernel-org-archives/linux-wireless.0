Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51590 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbbHaOsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 10:48:41 -0400
Message-ID: <1441032517.13980.21.camel@sipsolutions.net> (sfid-20150831_164845_308810_A647F07B)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Date: Mon, 31 Aug 2015 16:48:37 +0200
In-Reply-To: <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150829_231820_002785_12E86989)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 (sfid-20150829_231820_002785_12E86989)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> + * This driver was written as a replacement for the vendor provided
> + * rtl8723au driver. As the Realtek 8xxx chips are very similar in
> + * their programming interface, I have started adding support for
> + * additional 8xxx chips like the 8192cu, 8188cus, etc.

That last sentence here seems like it might be more suitable in the
commit message then here - you'll surely forget to update it ;)

> +> 	> /*
> +> 	>  * MBOX ready?
> +> 	>  */
> +> 	> retry = 100;
> +> 	> do {
> +> 	> 	> val8 = rtl8xxxu_read8(priv, REG_HMTFR);
> +> 	> 	> if (!(val8 & BIT(mbox_nr)))
> +> 	> 	> 	> break;
> +> 	> } while (retry--);

Seems fishy without any delay in the loop?

> +> 	> val32 = rtl8xxxu_read32(priv, REG_OFDM0_TRX_PATH_ENABLE);
> +> 	> val32 &= ~OFDM_RF_PATH_TX_MASK;
> +> 	> if (priv->tx_paths == 2)


"TX path" is very uncommon language for this... I'd suggest changing
all that to "TX stream" or "TX chain"?

> +> 	> if (priv->rf_paths == 2)

Similar here - and should that be RX not RF?

> +static int rtl8723a_channel_to_group(int channel)
> +{
> +> 	> int group;
> +
> +> 	> if (channel < 4)
> +> 	> 	> group = 0;
> +> 	> else if (channel < 10)
> +> 	> 	> group = 1;
> +> 	> else
> +> 	> 	> group = 2;
> +
> +> 	> return group;
> +}

Could remove the group variable, it's kinda pointless - just return
immediately?

if (channel < 4)
	return 0;
if (channel < 10)
	return 1;
return 2;


> +> 	> /* Poll for data read */
> +> 	> val32 = rtl8xxxu_read32(priv, REG_EFUSE_CTRL);
> +> 	> for (i = 0; i < RTL8XXXU_MAX_REG_POLL; i++) {
> +> 	> 	> val32 = rtl8xxxu_read32(priv, REG_EFUSE_CTRL);
> +> 	> 	> if (val32 & BIT(31))
> +> 	> 	> 	> break;
> +> 	> }
> 

Hmm, similar poll loop like above w/o any delay?
A few more seem to exist too.

> +> 	> 	> 	> for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
> +> 	> 	> 	> 	> /* Check word enable condition in the section */
> +> 	> 	> 	> 	> if (!(word_mask & BIT(i))) {
> +> 	> 	> 	> 	> 	> ret = rtl8xxxu_read_efuse8(priv,
> +> 	> 	> 	> 	> 	> 	> 	> 	>    efuse_addr++,
> +> 	> 	> 	> 	> 	> 	> 	> 	>    &val8);
> +> 	> 	> 	> 	> 	> if (ret)
> +> 	> 	> 	> 	> 	> 	> goto exit;
> +> 	> 	> 	> 	> 	> priv->efuse_wifi.raw[map_addr++] = val8;
> +
> +> 	> 	> 	> 	> 	> ret = rtl8xxxu_read_efuse8(priv,
> +> 	> 	> 	> 	> 	> 	> 	> 	>    efuse_addr++,
> +> 	> 	> 	> 	> 	> 	> 	> 	>    &val8);
> +> 	> 	> 	> 	> 	> if (ret)
> +> 	> 	> 	> 	> 	> 	> goto exit;
> +> 	> 	> 	> 	> 	> priv->efuse_wifi.raw[map_addr++] = val8;
> +> 	> 	> 	> 	> } else
> +> 	> 	> 	> 	> 	> map_addr += 2;
> +> 	> 	> 	> }

seems like it might better be in a helper function :)

> +static int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
> +> 	> 	> 	> 	>   struct rtl8xxxu_reg32val *array)
> +{
> +> 	> int i, ret;
> +> 	> u16 reg;
> +> 	> u32 val;
> +
> +> 	> for (i = 0; ; i++) {
> +> 	> 	> reg = array[i].reg;
> +> 	> 	> val = array[i].val;
> +
> +> 	> 	> if (reg == 0xffff && val == 0xffffffff)
> +> 	> 	> 	> break;


Maybe passing ARRAY_SIZE to these would be nicer than having to they're
terminated? Dunno though, might be a lot of infrastructure to do that.

Ugh, getting too long for me - anything in particular I should look at?
:)

johannes
