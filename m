Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbbJUA50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 20:57:26 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 02/16] rtl8xxxu: Use REG_EFUSE_TEST register only on multifunctional devices
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-3-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 20:57:24 -0400
In-Reply-To: <1445323546-12807-3-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:32 +0200")
Message-ID: <wrfj37x5xcln.fsf@redhat.com> (sfid-20151021_025730_043310_1FCEFD9A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> rtl8192cu driver doesn't read/write the REG_EFUSE_TEST register.
> Neither does the rtl8188eu driver.  Do it only for RTL8192CU-based
> devices.
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 9 ++++++---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)

This looks a reasonable change - I verified the 8723BU does this as
well, but 8192EU doesn't.

I did modify you commit message slightly since it said "Do it only for
RTL8192CU-based devices" and I am sure you meant 8723AU (and now
8723BU).

If you dislike the change to the message, let me know and I'll pull the
patch or change it.

Cheers,
Jes

>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 5f90261..a8d7e0a 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -1704,6 +1704,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
>  			priv->has_bluetooth = 1;
>  		if (val32 & MULTI_GPS_FUNC_EN)
>  			priv->has_gps = 1;
> +		priv->is_multi_func = 1;
>  	} else if (val32 & SYS_CFG_TYPE_ID) {
>  		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
>  		bonding &= HPON_FSM_BONDING_MASK;
> @@ -1934,9 +1935,11 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>  	if (val8 & EEPROM_BOOT)
>  		priv->boot_eeprom = 1;
>  
> -	val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
> -	val32 = (val32 & ~EFUSE_SELECT_MASK) | EFUSE_WIFI_SELECT;
> -	rtl8xxxu_write32(priv, REG_EFUSE_TEST, val32);
> +	if (priv->is_multi_func) {
> +		val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
> +		val32 = (val32 & ~EFUSE_SELECT_MASK) | EFUSE_WIFI_SELECT;
> +		rtl8xxxu_write32(priv, REG_EFUSE_TEST, val32);
> +	}
>  
>  	dev_dbg(dev, "Booting from %s\n",
>  		priv->boot_eeprom ? "EEPROM" : "EFUSE");
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index f2a1bac..622e6f5 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -597,6 +597,7 @@ struct rtl8xxxu_priv {
>  	struct rtl8723au_idx ht20_max_power_offset[3];
>  	u32 chip_cut:4;
>  	u32 rom_rev:4;
> +	u32 is_multi_func:1;
>  	u32 has_wifi:1;
>  	u32 has_bluetooth:1;
>  	u32 enable_bluetooth:1;
