Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63150 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbBJDXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 22:23:11 -0500
Received: by mail-ob0-f178.google.com with SMTP id uz6so29494474obc.9
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 19:23:10 -0800 (PST)
Message-ID: <54D9799D.5090909@lwfinger.net> (sfid-20150210_042334_858353_FDF34321)
Date: Mon, 09 Feb 2015 21:23:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
CC: wlanfae@realtek.com
Subject: Re: [PATCH 1/1] rtlwifi: Clear ACM_CTRL AC3_VO bit correctly
References: <1423261472-4607-1-git-send-email-Jes.Sorensen@redhat.com> <1423261472-4607-2-git-send-email-Jes.Sorensen@redhat.com>
In-Reply-To: <1423261472-4607-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2015 04:24 PM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> All hw driver components in the rtlwifi driver, except for the
> rtl8192de component has this bug. They would clear BE bit in the
> ACM_CTRL register instead of the VO bit when processing the VO queue.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Jes,

Good catch. Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192ee/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 2 +-
>   8 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> index f2b9713..edc2cbb 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> @@ -566,7 +566,7 @@ void rtl88ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   				acm_ctrl &= (~ACMHW_VIQEN);
>   				break;
>   			case AC3_VO:
> -				acm_ctrl &= (~ACMHW_BEQEN);
> +				acm_ctrl &= (~ACMHW_VOQEN);
>   				break;
>   			default:
>   				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> index 5c646d5..545b2c1 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> @@ -363,7 +363,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   					acm_ctrl &= (~AcmHw_ViqEn);
>   					break;
>   				case AC3_VO:
> -					acm_ctrl &= (~AcmHw_BeqEn);
> +					acm_ctrl &= (~AcmHw_VoqEn);
>   					break;
>   				default:
>   					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 5513217..ab38e68 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1867,7 +1867,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   					acm_ctrl &= (~AcmHw_ViqEn);
>   					break;
>   				case AC3_VO:
> -					acm_ctrl &= (~AcmHw_BeqEn);
> +					acm_ctrl &= (~AcmHw_VoqEn);
>   					break;
>   				default:
>   					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
> index 1a87edc..bac42e4 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
> @@ -588,7 +588,7 @@ void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   				acm_ctrl &= (~ACMHW_VIQEN);
>   				break;
>   			case AC3_VO:
> -				acm_ctrl &= (~ACMHW_BEQEN);
> +				acm_ctrl &= (~ACMHW_VOQEN);
>   				break;
>   			default:
>   				RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> index 5761d5b..dee88a8 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> @@ -293,7 +293,7 @@ void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   					acm_ctrl &= (~AcmHw_ViqEn);
>   					break;
>   				case AC3_VO:
> -					acm_ctrl &= (~AcmHw_BeqEn);
> +					acm_ctrl &= (~AcmHw_VoqEn);
>   					break;
>   				default:
>   					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
> index aa08546..b3b0947 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
> @@ -362,7 +362,7 @@ void rtl8723e_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   					acm_ctrl &= (~ACMHW_VIQEN);
>   					break;
>   				case AC3_VO:
> -					acm_ctrl &= (~ACMHW_BEQEN);
> +					acm_ctrl &= (~ACMHW_VOQEN);
>   					break;
>   				default:
>   					RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
> index 6dad28e..b469983 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
> @@ -603,7 +603,7 @@ void rtl8723be_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   				acm_ctrl &= (~ACMHW_VIQEN);
>   				break;
>   			case AC3_VO:
> -				acm_ctrl &= (~ACMHW_BEQEN);
> +				acm_ctrl &= (~ACMHW_VOQEN);
>   				break;
>   			default:
>   				RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
> diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
> index 8ec8200..ac235df 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
> @@ -667,7 +667,7 @@ void rtl8821ae_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   				acm_ctrl &= (~ACMHW_VIQEN);
>   				break;
>   			case AC3_VO:
> -				acm_ctrl &= (~ACMHW_BEQEN);
> +				acm_ctrl &= (~ACMHW_VOQEN);
>   				break;
>   			default:
>   				RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
>

