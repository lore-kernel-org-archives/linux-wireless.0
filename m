Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:55500 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab2GRLk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 07:40:26 -0400
Date: Wed, 18 Jul 2012 13:21:31 +0200
From: Henning Heinold <heinold@inf.fu-berlin.de>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: users@rt2x00.serialmonkey.com, kevin.chou@mediatek.com,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
Message-ID: <20120718112131.GB29030@mi.fu-berlin.de> (sfid-20120718_134030_675185_04BC137A)
References: <1342600827-18420-1-git-send-email-machen@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342600827-18420-1-git-send-email-machen@suse.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 18, 2012 at 04:40:27PM +0800, Chen, Chien-Chia wrote:
> This patch is going to fix the resuming failed from S3/S4
> for rt3290 chip.
> 
> Signed-off-by: Chen, Chien-Chia <machen@suse.com>
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index e76f03c..1715776 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -400,6 +400,13 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
>  {
>  	unsigned int i;
>  	u32 reg;
> +	int retval;
> +
> +	if (rt2x00_rt(rt2x00dev,RT3290)){
> +		retval = rt2800_enable_wlan_rt3290(rt2x00dev);
> +		if (retval)
> +			return -EBUSY;
> +	}
>  
>  	/*
>  	 * If driver doesn't wake up firmware here,
> @@ -5152,6 +5159,65 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
>  }
>  EXPORT_SYMBOL_GPL(rt2800_get_survey);
>  
> +int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
> +{
> +	u32 reg;
> +	int i, count;
> +
> +	rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
> +	if ((rt2x00_get_field32(reg, WLAN_EN) == 1))
> +		return 0;
> +
> +	rt2x00_set_field32(&reg, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
> +	rt2x00_set_field32(&reg, FRC_WL_ANT_SET, 1);
> +	rt2x00_set_field32(&reg, WLAN_CLK_EN, 0);
> +	rt2x00_set_field32(&reg, WLAN_EN, 1);
> +	rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
> +
> +	udelay(REGISTER_BUSY_DELAY);
> +	count = 0;
> +	do {
> +		/*
> +		 * Check PLL_LD & XTAL_RDY.
> +		 */
> +		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +			rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
> +			if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
> +				(rt2x00_get_field32(reg, XTAL_RDY) == 1))
> +					break;
> +			udelay(REGISTER_BUSY_DELAY);
> +		}
> +		if (i >= REGISTER_BUSY_COUNT) {
> +			if (count >= 10)
> +				return -EIO;
> +
> +			rt2800_register_write(rt2x00dev, 0x58, 0x018);
> +			udelay(REGISTER_BUSY_DELAY);
> +			rt2800_register_write(rt2x00dev, 0x58, 0x418);
> +			udelay(REGISTER_BUSY_DELAY);
> +			rt2800_register_write(rt2x00dev, 0x58, 0x618);
> +			udelay(REGISTER_BUSY_DELAY);
> +			count++;
> +		} else {
> +			count = 0;
> +		}
> +
> +		rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
> +		rt2x00_set_field32(&reg, PCIE_APP0_CLK_REQ, 0);
> +		rt2x00_set_field32(&reg, WLAN_CLK_EN, 1);
> +		rt2x00_set_field32(&reg, WLAN_RESET, 1);
> +		rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
> +		udelay(10);
> +		rt2x00_set_field32(&reg, WLAN_RESET, 0);
> +		rt2800_register_write(rt2x00dev, WLAN_FUN_CTRL, reg);
> +		udelay(10);
> +		rt2800_register_write(rt2x00dev, INT_SOURCE_CSR, 0x7fffffff);
> +	} while (count != 0);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rt2800_enable_wlan_rt3290);
> +
>  MODULE_AUTHOR(DRV_PROJECT ", Bartlomiej Zolnierkiewicz");
>  MODULE_VERSION(DRV_VERSION);
>  MODULE_DESCRIPTION("Ralink RT2800 library");
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
> index 18a0b67..12d6eeb 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.h
> @@ -209,5 +209,5 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
>  		      struct survey_info *survey);
>  void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
> -
> +int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev);
>  #endif /* RT2800LIB_H */
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 235376e..135c2a2 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -980,6 +980,7 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  	return rt2800_validate_eeprom(rt2x00dev);
>  }
>  
> +#if 0
>  static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>  {
>  	u32 reg;
> @@ -1040,6 +1041,8 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>  
>  	return 0;
>  }
> +
> +#endif

Why do you need the #ifdefs here?

>  static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
> 

Bye Henning
