Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46629 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab2IKMq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 08:46:26 -0400
Message-ID: <504F31C5.4020901@qca.qualcomm.com> (sfid-20120911_144629_549448_0D24474B)
Date: Tue, 11 Sep 2012 18:12:45 +0530
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] ath9k_hw: Add version/revision macros for AR9565
References: <20557.25427.250740.150293@gargle.gargle.HOWL>
In-Reply-To: <20557.25427.250740.150293@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2012 09:19 AM, Sujith Manoharan wrote:
> And recognize the device in the init path.
>
> Signed-off-by: Sujith Manoharan<c_manoha@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/hw.c  | 7 +++++--
>   drivers/net/wireless/ath/ath9k/hw.h  | 1 +
>   drivers/net/wireless/ath/ath9k/reg.h | 9 +++++++++
>   3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 48af401..3638626 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -355,7 +355,7 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
>   			(val&  AR_SREV_VERSION2)>>  AR_SREV_TYPE2_S;
>   		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
>
> -		if (AR_SREV_9462(ah))
> +		if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
>   			ah->is_pciexpress = true;
>   		else
>   			ah->is_pciexpress = (val&
> @@ -647,6 +647,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>   	case AR_SREV_VERSION_9340:
>   	case AR_SREV_VERSION_9462:
>   	case AR_SREV_VERSION_9550:
> +	case AR_SREV_VERSION_9565:
>   		break;
>   	default:
>   		ath_err(common,
> @@ -708,7 +709,7 @@ int ath9k_hw_init(struct ath_hw *ah)
>   	int ret;
>   	struct ath_common *common = ath9k_hw_common(ah);
>
> -	/* These are all the AR5008/AR9001/AR9002 hardware family of chipsets */
> +	/* These are all the AR5008/AR9001/AR9002/AR9003 hardware family of chipsets */
>   	switch (ah->hw_version.devid) {
>   	case AR5416_DEVID_PCI:
>   	case AR5416_DEVID_PCIE:
> @@ -728,6 +729,7 @@ int ath9k_hw_init(struct ath_hw *ah)
>   	case AR9300_DEVID_AR9580:
>   	case AR9300_DEVID_AR9462:
>   	case AR9485_DEVID_AR1111:
> +	case AR9300_DEVID_AR9565:
>   		break;
>   	default:
>   		if (common->bus_ops->ath_bus_type == ATH_USB)
> @@ -3157,6 +3159,7 @@ static struct {
>   	{ AR_SREV_VERSION_9485,         "9485" },
>   	{ AR_SREV_VERSION_9462,         "9462" },
>   	{ AR_SREV_VERSION_9550,         "9550" },
> +	{ AR_SREV_VERSION_9565,         "9565" },
>   };
>
>   /* For devices with external radios */
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 6599a75..0d17ce0 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -50,6 +50,7 @@
>   #define AR9300_DEVID_AR9330	0x0035
>   #define AR9300_DEVID_QCA955X	0x0038
>   #define AR9485_DEVID_AR1111	0x0037
> +#define AR9300_DEVID_AR9565     0x0036
>
>   #define AR5416_AR9100_DEVID	0x000b
>
> diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> index 87cac8e..6ca34a4 100644
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h
> @@ -801,6 +801,8 @@
>   #define AR_SREV_REVISION_9580_10	4 /* AR9580 1.0 */
>   #define AR_SREV_VERSION_9462		0x280
>   #define AR_SREV_REVISION_9462_20	2
> +#define AR_SREV_VERSION_9565            0x2C0
> +#define AR_SREV_REVISION_9565_10        0
>   #define AR_SREV_VERSION_9550		0x400
>
>   #define AR_SREV_5416(_ah) \
> @@ -909,6 +911,13 @@
>   	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462)&&  \
>   	((_ah)->hw_version.macRev>= AR_SREV_REVISION_9462_20))
>
> +#define AR_SREV_9565(_ah) \
> +	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
> +
> +#define AR_SREV_9565_10(_ah) \
> +	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565)&&  \
> +	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_10)))
> +
There is an extra braces. Please check.
>   #define AR_SREV_9550(_ah) \
>   	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9550))
>

