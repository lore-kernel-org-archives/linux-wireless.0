Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbbJUCHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 22:07:34 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 13/16] rtl8xxxu: Make set_tx_power a chip-type-dependent operation
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-14-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 22:07:32 -0400
In-Reply-To: <1445323546-12807-14-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:43 +0200")
Message-ID: <wrfjtwplug7v.fsf@redhat.com> (sfid-20151021_040737_782900_8D6FA80B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> Preparatory step for adding support for RTL8188EU chips.
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 ++++--
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 83cdc2a..ecda799 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -4223,7 +4223,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>  	/*
>  	 * Start out with default power levels for channel 6, 20MHz
>  	 */
> -	rtl8723a_set_tx_power(priv, 1, false);
> +	priv->fops->set_tx_power(priv, 1, false);
>  
>  	/* Let the 8051 take control of antenna setting */
>  	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
> @@ -5207,7 +5207,7 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
>  
>  		channel = hw->conf.chandef.chan->hw_value;
>  
> -		rtl8723a_set_tx_power(priv, channel, ht40);
> +		priv->fops->set_tx_power(priv, channel, ht40);
>  
>  		rtl8723au_config_channel(hw);
>  	}
> @@ -5781,6 +5781,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
>  	.parse_efuse = rtl8723au_parse_efuse,
>  	.load_firmware = rtl8723au_load_firmware,
>  	.power_on = rtl8723au_power_on,
> +	.set_tx_power = rtl8723a_set_tx_power,
>  	.efuse_len = EFUSE_REAL_CONTENT_LEN_8723A,
>  	.writeN_block_size = 1024,
>  };
> @@ -5789,6 +5790,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
>  	.parse_efuse = rtl8192cu_parse_efuse,
>  	.load_firmware = rtl8192cu_load_firmware,
>  	.power_on = rtl8192cu_power_on,
> +	.set_tx_power = rtl8723a_set_tx_power,
>  	.efuse_len = EFUSE_REAL_CONTENT_LEN_8723A,
>  	.writeN_block_size = 128,
>  };
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 1a767eb..427eb7e 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -679,6 +679,7 @@ struct rtl8xxxu_fileops {
>  	int (*parse_efuse) (struct rtl8xxxu_priv *priv);
>  	int (*load_firmware) (struct rtl8xxxu_priv *priv);
>  	int (*power_on) (struct rtl8xxxu_priv *priv);
> +	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel, bool ht40);
>  	int efuse_len;
>  	int writeN_block_size;
>  };

Lets not add function pointers before we actually know we have a need
for them.

Jes
