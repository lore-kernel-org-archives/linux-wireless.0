Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35469 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbbFSS5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2015 14:57:34 -0400
Received: by oiax193 with SMTP id x193so86335389oia.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2015 11:57:34 -0700 (PDT)
Message-ID: <5584661B.5030307@lwfinger.net> (sfid-20150619_205822_923703_CA37B98F)
Date: Fri, 19 Jun 2015 13:57:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Remove rtl8723 code
References: <1434738495-29498-1-git-send-email-ap420073@gmail.com>
In-Reply-To: <1434738495-29498-1-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2015 01:28 PM, Taehee Yoo wrote:
> In the rtlwifi/rtl8192cu, rtl8723 code is dead code.
> So I remove it.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/def.h |  9 ---------
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 16 +---------------
>   drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 12 ------------
>   3 files changed, 1 insertion(+), 36 deletions(-)

Looks good.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
> index c940a87..74a479a 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/def.h
> @@ -32,24 +32,15 @@
>   /*-------------------------------------------------------------------------
>    *	Chip specific
>    *-------------------------------------------------------------------------*/
> -#define CHIP_8723			BIT(2) /* RTL8723 With BT feature */
> -#define CHIP_8723_DRV_REV		BIT(3) /* RTL8723 Driver Revised */
>   #define NORMAL_CHIP			BIT(4)
>   #define CHIP_VENDOR_UMC			BIT(5)
>   #define CHIP_VENDOR_UMC_B_CUT		BIT(6)
>
> -#define IS_8723_SERIES(version)		\
> -	(((version) & CHIP_8723) ? true : false)
> -
>   #define IS_92C_1T2R(version)		\
>   	(((version) & CHIP_92C) && ((version) & CHIP_92C_1T2R))
>
>   #define IS_VENDOR_UMC(version)		\
>   	(((version) & CHIP_VENDOR_UMC) ? true : false)
>
> -#define IS_VENDOR_8723_A_CUT(version)	\
> -	(((version) & CHIP_VENDOR_UMC) ? (((version) & (BIT(6))) ? \
> -	false : true) : false)
> -
>   #define CHIP_BONDING_92C_1T2R	0x1
>   #define CHIP_BONDING_IDENTIFIER(_value)	(((_value) >> 22) & 0x3)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 767358a..7cf3661 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -2280,7 +2280,6 @@ bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
> -	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
>   	enum rf_pwrstate e_rfpowerstate_toset, cur_rfstate;
>   	u8 u1tmp = 0;
>   	bool actuallyset = false;
> @@ -2357,20 +2356,7 @@ bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
>   		if (ppsc->pwrdown_mode && e_rfpowerstate_toset == ERFOFF) {
>   			/* Enable register area 0x0-0xc. */
>   			rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x0);
> -			if (IS_HARDWARE_TYPE_8723U(rtlhal)) {
> -				/*
> -				 * We should configure HW PDn source for WiFi
> -				 * ONLY, and then our HW will be set in
> -				 * power-down mode if PDn source from all
> -				 * functions are configured.
> -				 */
> -				u1tmp = rtl_read_byte(rtlpriv,
> -						      REG_MULTI_FUNC_CTRL);
> -				rtl_write_byte(rtlpriv, REG_MULTI_FUNC_CTRL,
> -					       (u1tmp|WL_HWPDN_EN));
> -			} else {
> -				rtl_write_word(rtlpriv, REG_APS_FSMCO, 0x8812);
> -			}
> +			rtl_write_word(rtlpriv, REG_APS_FSMCO, 0x8812);
>   		}
>   		if (e_rfpowerstate_toset == ERFOFF) {
>   			if (ppsc->reg_rfps_level  & RT_RF_OFF_LEVL_ASPM)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
> index 490a7cf..1c55a00 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
> @@ -69,8 +69,6 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
>   		chip_version = NORMAL_CHIP;
>   		chip_version |= ((value32 & TYPE_ID) ? CHIP_92C : 0);
>   		chip_version |= ((value32 & VENDOR_ID) ? CHIP_VENDOR_UMC : 0);
> -		/* RTL8723 with BT function. */
> -		chip_version |= ((value32 & BT_FUNC) ? CHIP_8723 : 0);
>   		if (IS_VENDOR_UMC(chip_version))
>   			chip_version |= ((value32 & CHIP_VER_RTL_MASK) ?
>   					 CHIP_VENDOR_UMC_B_CUT : 0);
> @@ -78,10 +76,6 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
>   			value32 = rtl_read_dword(rtlpriv, REG_HPON_FSM);
>   			chip_version |= ((CHIP_BONDING_IDENTIFIER(value32) ==
>   				 CHIP_BONDING_92C_1T2R) ? CHIP_92C_1T2R : 0);
> -		} else if (IS_8723_SERIES(chip_version)) {
> -			value32 = rtl_read_dword(rtlpriv, REG_GPIO_OUTSTS);
> -			chip_version |= ((value32 & RF_RL_ID) ?
> -					  CHIP_8723_DRV_REV : 0);
>   		}
>   	}
>   	rtlhal->version  = (enum version_8192c)chip_version;
> @@ -114,12 +108,6 @@ void rtl92c_read_chip_version(struct ieee80211_hw *hw)
>   	case VERSION_NORMAL_UMC_CHIP_88C_B_CUT:
>   		versionid = "NORMAL_UMC_CHIP_88C_B_CUT";
>   		break;
> -	case VERSION_NORMA_UMC_CHIP_8723_1T1R_A_CUT:
> -		versionid = "NORMAL_UMC_CHIP_8723_1T1R_A_CUT";
> -		break;
> -	case VERSION_NORMA_UMC_CHIP_8723_1T1R_B_CUT:
> -		versionid = "NORMAL_UMC_CHIP_8723_1T1R_B_CUT";
> -		break;
>   	case VERSION_TEST_CHIP_92C:
>   		versionid = "TEST_CHIP_92C";
>   		break;
>

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
