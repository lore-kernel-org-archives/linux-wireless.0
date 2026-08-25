Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7623D5222
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645388; cv=none; b=uOneF+HnsbXVZa/fL5i/oevVM/YvhEhWKoPXha2xJN5y6F6SNTuBxvxWPHNBc9G7tTwb73faHrymOLrXMoWsJsOKp4/xPcHckeZ3HlYRO3kyYDGvGQsxsBAVXtd+N3LXx4MFZk2X6daURQSAP00xCSogs7rV8Bka/XlMpoXZkC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645388; c=relaxed/simple;
	bh=JS3zYppONvAuEDVWZ7rAxABKuO9vdZk4ALqKGB5uCdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUkLxtCHWNBaY0K32/9Vy3HA5vRSlP0VeBs+AkD0oyjgjf1N3alnr4KB+Qs4t4bLjAWwJYNUAJ1W/z5sEgjwen9cCrdg3QgT3Ddd36BnUNOf4gHPa0n4q9Erv5j71vY++3NIt74lbgns3Un6dZ6Sx0/tIEHsRQVzy6kuvFFViwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cfnd+CDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cfnd+CDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0411F000E9;
	Tue, 25 Aug 2026 08:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787645387;
	bh=QHYvRb50MdqIPeYRe0+znoq6T68k12xscjcfmZzkBVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cfnd+CDMowaClKWWCT8lhpr+8hwiu2r7rS0NOr+JbLiZdmZ80jHfWndw1S32SttJa
	 m/GOdM/3v+KYxOUvamLPfBQWDoL/S9ystFT5o4k3NQdMqeFh/hK815ylxh1aWO6FH9
	 9o4xZUgiibr+NVGq4jKiiEgPMXGXs0GhebQhI8vPMtC9BC52USqA/3o9SF/JNHsSth
	 baIeglt4sQsDkbSZv3vVqdbRmEQ6D8YYsURDGCoEl+u9afjqb2yehALDPRAznwtA2x
	 hq7220vtSkAdZhLCASPdOO5smlPN5q2Yb840sOUQW9TxyJKJQ8qoJtNuuA2VZcOELJ
	 zz3BOozc2Olkg==
Message-ID: <90f8a48c-f7fa-4811-b3b5-5f47e32f4194@kernel.org>
Date: Tue, 25 Aug 2026 10:09:43 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/2] wifi: ath12k: add AHB platform descriptor
 support
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
 ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
 <20260721065038.126046-2-aaradhana.sahu@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260721065038.126046-2-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/07/2026 08:50, Aaradhana Sahu wrote:
> AHB-based platforms associate each device with a userPD ID that determines
> the firmware name and Peripheral Authentication Service ID (PASID) used
> during firmware authentication.
> 
> Current implementation does not support platforms with multiple devices
> sharing the same compatible string but using different userPD IDs.
> As a result, the driver cannot uniquely identify each device for firmware
> selection and authentication.
> 
> Add an AHB platform descriptor to store device-specific configuration.
> Implement userPD ID resolution by matching device tree reg properties, with
> node name matching as a fallback. Centralize platform configuration to
> simplify the probe path by removing hardware-specific conditionals.
> 
> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/ahb.c       |  4 +-
>  drivers/net/wireless/ath/ath12k/ahb.h       | 19 +++++
>  drivers/net/wireless/ath/ath12k/hw.h        |  1 -
>  drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 90 +++++++++++++++++----
>  4 files changed, 94 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
> index 07bb83710b1f..14ee696960c7 100644
> --- a/drivers/net/wireless/ath/ath12k/ahb.c
> +++ b/drivers/net/wireless/ath/ath12k/ahb.c
> @@ -704,7 +704,7 @@ static int ath12k_ahb_map_service_to_pipe(struct ath12k_base *ab, u16 service_id
>  	return 0;
>  }
>  
> -static const struct ath12k_hif_ops ath12k_ahb_hif_ops = {
> +const struct ath12k_hif_ops ath12k_ahb_hif_ops = {
>  	.start = ath12k_ahb_start,
>  	.stop = ath12k_ahb_stop,
>  	.read32 = ath12k_ahb_read32,
> @@ -715,6 +715,7 @@ static const struct ath12k_hif_ops ath12k_ahb_hif_ops = {
>  	.power_up = ath12k_ahb_power_up,
>  	.power_down = ath12k_ahb_power_down,
>  };
> +EXPORT_SYMBOL(ath12k_ahb_hif_ops);
>  
>  static irqreturn_t ath12k_userpd_irq_handler(int irq, void *data)
>  {
> @@ -1038,7 +1039,6 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
>  
>  	ab_ahb = ath12k_ab_to_ahb(ab);
>  	ab_ahb->ab = ab;
> -	ab->hif.ops = &ath12k_ahb_hif_ops;
>  	ab->pdev = pdev;
>  	platform_set_drvdata(pdev, ab);
>  
> diff --git a/drivers/net/wireless/ath/ath12k/ahb.h b/drivers/net/wireless/ath/ath12k/ahb.h
> index a153db6cf1d3..037347ccd21b 100644
> --- a/drivers/net/wireless/ath/ath12k/ahb.h
> +++ b/drivers/net/wireless/ath/ath12k/ahb.h
> @@ -30,6 +30,24 @@
>  #define ATH12K_USERPD_ID_MASK			GENMASK(10, 8)
>  #define ATH12K_USERPD_FW_NAME_LEN		35
>  
> +enum ath12k_ahb_userpd_id {
> +	ATH12K_AHB_USERPD_ID_0 = 1,
> +	ATH12K_AHB_USERPD_ID_1,
> +	ATH12K_AHB_USERPD_ID_2,
> +};
> +
> +struct ath12k_ahb_userpd_map {
> +	phys_addr_t io_start;
> +	const char *node_name;
> +	u32 upd_id;
> +};
> +
> +struct ath12k_ahb_desc {
> +	enum ath12k_hw_rev hw_rev;
> +	bool auth_enabled;
> +	const struct ath12k_hif_ops *ops;
> +};
> +
>  enum ath12k_ahb_smp2p_msg_id {
>  	ATH12K_AHB_POWER_SAVE_ENTER = 1,
>  	ATH12K_AHB_POWER_SAVE_EXIT,
> @@ -43,6 +61,7 @@ enum ath12k_ahb_userpd_irq {
>  };
>  
>  struct ath12k_base;
> +extern const struct ath12k_hif_ops ath12k_ahb_hif_ops;
>  
>  struct ath12k_ahb_device_family_ops {
>  	int (*probe)(struct platform_device *pdev);
> diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
> index 49cfd5dfc70a..3ed38f8f2b48 100644
> --- a/drivers/net/wireless/ath/ath12k/hw.h
> +++ b/drivers/net/wireless/ath/ath12k/hw.h
> @@ -100,7 +100,6 @@ struct ieee80211_rx_status;
>  #define ATH12K_REGDB_FILE_NAME		"regdb.bin"
>  
>  #define ATH12K_PCIE_MAX_PAYLOAD_SIZE	128
> -#define ATH12K_IPQ5332_USERPD_ID	1
>  
>  enum ath12k_hw_rate_cck {
>  	ATH12K_HW_RATE_CCK_LP_11M = 0,
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
> index 6a8b8b2a56f9..98a6606ffd76 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
> @@ -15,44 +15,100 @@
>  #include "dp.h"
>  #include "core.h"
>  
> +/*
> + * Node name to UserPD ID mapping
> + *
> + * The io_start field is used for additional validation when the reg
> + * property is present in the device tree. If io_start is 0, only
> + * node_name matching is performed.
> + *
> + * For platforms where not all WiFi nodes have a 'reg' property, set
> + * io_start to 0 for those entries. The driver will match purely by
> + * node name in such cases.
> + */
> +static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
> +	{ .io_start = 0x0c000000, .node_name = "wifi", .upd_id = ATH12K_AHB_USERPD_ID_0 },

NAK.

This slipped past my filters so I will be reverting this. YOU CANNOT add
such undocumented ABI.

Test your code - how does it work when the node is called "wireless"?


Best regards,
Krzysztof
