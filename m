Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50413 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2FSRtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 13:49:07 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	<aeolus@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 19 Jun 2012 23:20:20 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH 07/10] ath9k_hw: Add hardware code for WoW
Message-ID: <20120619175018.GB7191@vmraj-lnx.qca.qualcomm.com> (sfid-20120619_194911_371611_E79E35EE)
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>
 <1340120850-9155-8-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1340120850-9155-8-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 09:17:27PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> add a new file wow.c which takes care of the hardware code
> for WoW.
[...]
> ---
>  3 files changed, 591 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/wow.c
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
> index 9c41232..2ad8f94 100644
> --- a/drivers/net/wireless/ath/ath9k/Makefile
> +++ b/drivers/net/wireless/ath/ath9k/Makefile
> @@ -17,6 +17,7 @@ ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += \
>  		dfs.o \
>  		dfs_pattern_detector.o \
>  		dfs_pri_detector.o
> +ath9k-$(CONFIG_PM_SLEEP) += wow.o
>  
>  obj-$(CONFIG_ATH9K) += ath9k.o
>  
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 2a20216..8e417c1 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -1110,6 +1110,37 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
>  }
>  #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
>  
> +
> +#ifdef CONFIG_PM_SLEEP
> +const char *ath9k_hw_wow_event_to_string(u32 wow_event);
> +void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
> +				u8 *user_mask, int pattern_count,
> +				int pattern_len);
> +u32 ath9k_hw_wow_wakeup(struct ath_hw *ah);
> +void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable);
> +#else
> +static inline const char *ath9k_hw_wow_event_to_string(u32 wow_event)
> +{
> +	return NULL;
> +}
> +static inline void ath9k_hw_wow_apply_pattern(struct ath_hw *ah,
> +					      u8 *user_pattern, u8 *user_mask,
> +					      int pattern_count,
> +					      int pattern_len)
> +{
> +	return;
> +}
No need to return void function and also fix indent for arguments
> +static inline u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
> +{
> +	return 0;
> +}
> +static inline void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
> +{
> +}
> +#endif
> +
> +
> +
>  #define ATH9K_CLOCK_RATE_CCK		22
>  #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
>  #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
> diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
> new file mode 100644
> index 0000000..66a7a74
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/wow.c
> @@ -0,0 +1,559 @@
> +
> +/*
> + * Copyright (c) 2008-2011 Atheros Communications Inc.
> + *
Please update the Copyright.

> +
> +#include <linux/export.h>
> +#include "ath9k.h"
> +#include "reg.h"
> +#include "hw-ops.h"
> +
[...]
> +			if (AR_SREV_9285(ah) || AR_SREV_9287(ah))
> +				set = AR9285_WA_DEFAULT;
> +			else
> +				set = AR9280_WA_DEFAULT;
> +
> +			/*
> +			 * In AR9280 and AR9285, bit 14 in WA register
> +			 * (disable L1) should only be set when device
> +			 * enters D3 state and be cleared when device
> +			 * comes back to D0
> +			 */
> +
> +			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
> +				set = set | AR_WA_D3_L1_DISABLE;
> +
> +			clr = AR_WA_UNTIE_RESET_EN;
> +			set = set | AR_WA_RESET_EN | AR_WA_POR_SHORT;
simplify it as |=

-Rajkumar 
