Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44102 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2DBRyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 13:54:05 -0400
Received: by iagz16 with SMTP id z16so4394571iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 10:54:05 -0700 (PDT)
Message-ID: <4F79E7B9.7060504@lwfinger.net> (sfid-20120402_195410_543693_3E8F4313)
Date: Mon, 02 Apr 2012 12:54:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH 1/2] rtl8192de: Clean up and fix 92D cut version constants
 and macros.
References: <20120402142525.GA20611@alittletooquiet.net>
In-Reply-To: <20120402142525.GA20611@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2012 09:25 AM, Forest Bond wrote:
> From: Forest Bond<forest.bond@rapidrollout.com>
>
> The previous definitions included both {B,C,D,E}_CUT_VERSION and
> CHIP_92D_{C,D}_CUT with conflicting values for the C and D cut versions,
> and literal hex values were used in the IS_92D_{C,D,E}_CUT macros.  So
> we clean all this up and in doing so enable cut-specific code paths for
> cuts C and D, which would not have been executed because the
> CHIP_92D_{C,D}_CUT constants were wrong and the cut version was thus
> recorded incorrectly.
>
> Signed-off-by: Forest Bond<forest.bond@rapidrollout.com>

This patch does not apply to the wireless-testing tree. That is the one you are 
supposed to use.

Patch #2 also fails to apply. In addition, your mailer mangled a line.

Larry

> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/def.h |   17 ++++++++---------
>   1 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/def.h b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
> index eafdf76..260ac7e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/def.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
> @@ -151,9 +151,6 @@ enum version_8192d {
>
>   /* for 92D */
>   #define CHIP_92D_SINGLEPHY		BIT(9)
> -#define C_CUT_VERSION			BIT(13)
> -#define D_CUT_VERSION			((BIT(12)|BIT(13)))
> -#define E_CUT_VERSION			BIT(14)
>
>   /* Chip specific */
>   #define CHIP_BONDING_IDENTIFIER(_value)	(((_value)>>22)&0x3)
> @@ -173,7 +170,11 @@ enum version_8192d {
>   #define RF_TYPE_1T2R			BIT(4)
>   #define RF_TYPE_2T2R			BIT(5)
>   #define CHIP_VENDOR_UMC			BIT(7)
> -#define B_CUT_VERSION			BIT(12)
> +#define CHIP_92D_A_CUT			(0<<12)
> +#define CHIP_92D_B_CUT			(1<<12)
> +#define CHIP_92D_C_CUT			(2<<12)
> +#define CHIP_92D_D_CUT			(3<<12)
> +#define CHIP_92D_E_CUT			(4<<12)
>
>   /* MASK */
>   #define IC_TYPE_MASK			(BIT(0)|BIT(1)|BIT(2))
> @@ -205,15 +206,13 @@ enum version_8192d {
>   					 CHIP_92D) ? true : false)
>   #define IS_92D_C_CUT(version)		((IS_92D(version)) ?		\
>   				 ((GET_CVID_CUT_VERSION(version) ==	\
> -				 0x2000) ? true : false) : false)
> +				 CHIP_92D_C_CUT) ? true : false) : false)
>   #define IS_92D_D_CUT(version)			((IS_92D(version)) ?	\
>   				 ((GET_CVID_CUT_VERSION(version) ==	\
> -				 0x3000) ? true : false) : false)
> +				 CHIP_92D_D_CUT) ? true : false) : false)
>   #define IS_92D_E_CUT(version)		((IS_92D(version)) ?		\
>   				 ((GET_CVID_CUT_VERSION(version) ==	\
> -				 0x4000) ? true : false) : false)
> -#define CHIP_92D_C_CUT			BIT(10)
> -#define CHIP_92D_D_CUT			BIT(11)
> +				 CHIP_92D_E_CUT) ? true : false) : false)
>
>   enum rf_optype {
>   	RF_OP_BY_SW_3WIRE = 0,

