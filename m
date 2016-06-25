Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:35592 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751379AbcFYXsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 19:48:08 -0400
Message-ID: <1466898485.1847.73.camel@perches.com> (sfid-20160626_014818_417341_35BCA179)
Subject: Re: [PATCH 01/10] rtlwifi: Create common routine to get hardware
 info
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Date: Sat, 25 Jun 2016 16:48:05 -0700
In-Reply-To: <1466884421-722-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1466884421-722-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1466884421-722-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-06-25 at 14:53 -0500, Larry Finger wrote:
> All of the rtlwifi family of drivers have a similar routine that acquires
> the hardware info from efuse and initializes a number of variables in the
> driver's private area. A common routine is created for all drivers to use.
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
[]
> @@ -1243,3 +1244,80 @@ static u8 efuse_calculate_word_cnts(u8 word_en)
>  	return word_cnts;
>  }
>  
> +int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
> +		   int max_size, u8 *hwinfo, int *params)
> +{
> +	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
> +	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
> +	struct device *dev = &rtlpcipriv->dev.pdev->dev;
> +	u16 eeprom_id;
> +	u16 i, usvalue;
> +
> +	switch (rtlefuse->epromtype) {
> +	case EEPROM_BOOT_EFUSE:
> +		rtl_efuse_shadow_map_update(hw);
> +		break;
> +
> +	case EEPROM_93C46:
> +		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> +			 "RTL819X Not boot from eeprom, check it !!");

Is this EEPROM specific to the 819X series or should
this message use RTL8xxx instead of RTL819X

And this should have a \n at the end of the format.

