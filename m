Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58040 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2FSRTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 13:19:36 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	<aeolus@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 19 Jun 2012 22:50:49 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH 03/10] ath9k_hw: Add WoW hardware capability flags
Message-ID: <20120619172047.GA7105@vmraj-lnx.qca.qualcomm.com> (sfid-20120619_191940_304162_DAB68F78)
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>
 <1340120850-9155-4-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1340120850-9155-4-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 09:17:23PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> have seperate wow capability flags for
> *basic wow support
> *device capable of matching exact user defined pattern
> or de-authentication/disassoc pattern
> *device such AR9280 requires first four bytes for
> all sort of patterns
> 
> Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Cc: vadivel@qca.qualcomm.com
> Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index d0e14a3..73a1238 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -231,6 +231,23 @@ enum ath9k_hw_caps {
>  	ATH9K_HW_CAP_DFS			= BIT(16),
>  };
>  
> +/*
> + * enum ath9k_hw_wow_caps - WoW device capabilities
> + * @ATH9K_HW_WOW_DEVICE_CAPABLE: device revision is capable of WoW.
> + * @ATH9K_HW_WOW_PATTERN_MATCH_EXACT: device is capable of matching
> + * an exact user defined pattern or de-authentication/disassoc pattern.
> + * @ATH9K_HW_WOW_PATTERN_MATCH_DWORD: device requires the first four
> + * bytes of the pattern for user defined pattern, de-authentication and
> + * disassociation patterns for all types of possible frames recieved
> + * of those types.
> + */
> +
> +enum ath9k_hw_wow_caps {
> +	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(0),
> +	ATH9K_HW_WOW_PATTERN_MATCH_EXACT	= BIT(1),
> +	ATH9K_HW_WOW_PATTERN_MATCH_DWORD	= BIT(2),
> +};
> +
>  struct ath9k_hw_capabilities {
>  	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
>  	u16 rts_aggr_limit;
> @@ -246,6 +263,9 @@ struct ath9k_hw_capabilities {
>  	u8 txs_len;
>  	u16 pcie_lcr_offset;
>  	bool pcie_lcr_extsync_en;
> +#ifdef	CONFIG_PM_SLEEP
> +	enum ath9k_hw_wow_caps wow_caps;
> +#endif
Why can't you align with existing HW_CAP_* flags? why do you need a separate
place holder?

-Rajkumar
