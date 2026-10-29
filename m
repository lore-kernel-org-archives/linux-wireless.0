Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277241;
	b=KnZj3tKc8/yzDAWZH+Ii0kwu/Z3o7GnzEIZKeP0EiSZFRoEf7odFuJ3hz7eTxJeAHekZ
	 QDBY6H+UUW09x19UEZ/G1bhSQNlQqyMT4lGq8qFK83Z6ONGSnneOe3SRnYmXcLkEGFlyK
	 HCr9tTwK2yFlRry63kDrzAw/RFF0OiLjoATAIm5oe9XTrbN0UdRKFH23iqPDi7Fm0H3sr
	 /MQ4Srt8LFaRzPWQmIrBFryEM6FXMjKePuI1hrMfEAKDNXFI+PRILA602VtQem2ThctBO
	 /rDgKgVM4r1Jt4K7ykFgZZbuFYvmiIazz4Bg2HmavrHNYA/DHwcdS1qIsNHJtLQpRtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277241;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Xk1ChXaKxZzggnQH9hm8eNevc8cdvoStZhssz/jXe9w=;
	b=n85W2ddL2OXUmN2Z8p5CCQ+/JRpwJiph2YG3StCNeccdEOLBjYCM9+/Fqoq85Yf+WOdc
	 EnjjVU59lokFqoFluRhBwkOlUFxn9dtY8bRsoPuo7O3o05i6Df+Ee4Nbl8lenbo3fVSsV
	 kVBycrdt6cJjCg20R6iqAFcG7EWzJGv6vGc57nj4Fxqz/dqj8jb5KIsF16DMNZ5hRUihw
	 JIrLmGxgGmiF4DmQUkMP7pbDsO/zKqUwK8X4itXNSHZ8kr93qRcphn2XmfUna0r8vqVYY
	 xLJTz1IQ1ASCkd7KcdRc8JUEuxYIpUNUYcMwoPiSrXRSyI6Yp9nlcY3mA0DoPKBNt2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="cbUlug/w";
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B4606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 12:34:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 340B4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cbUlug/w
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so13616025e9.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793277239; x=1793882039; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xk1ChXaKxZzggnQH9hm8eNevc8cdvoStZhssz/jXe9w=;
        b=cbUlug/wGkjde0wDIGkj0HbxXW7CSWnTessiXjBYofWN0F70Rgye/svWNUBJ/4DSMw
         CW70oleQz8zoqREYlS+67vr6cR4oDlJhHIlVZUde+SeNzcRmQqBiBipB8F/YJTaSILhm
         tKjlADUmMu098F5kR7nkl+b+UANIC95pQDy1PbXrEiDM4l4gr55vPCxFYv/zWPwHIcI7
         EepLpOnmWBvUmTxymKlPBjAIDG73HHe3MJIFVXL4A0Ymr9y7HsH4t2lDQGGqJkFWJMB7
         sGKFsjpFJ3WaS+96UTICFDu7cBA3Ufu8awxPm6rDxNcD55CapIAVee+JrrRymTRl6/84
         Hm/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793277239; x=1793882039;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xk1ChXaKxZzggnQH9hm8eNevc8cdvoStZhssz/jXe9w=;
        b=2Sp/TlmfeTa2ekAlwNniiunhiMjBU9aKnknnAG8elIbKxfXlR3NDuqwoa4bci8DyDD
         N9NqZQqj+gq74bMgG27rB+5bLmt++4Wtp/GpcFvjFMFt+QhLLiQwuHjZr9TR1u7ioQHQ
         7rALCtLMLlS1f2zN+rN5/eH59rUzhvTdvqe+dU49IVoZgXnPgDbr/Um4xvEpzD04SjL5
         DR+WqN+7mbH8EwUDm0WmLsT1ZDfegMbaq3Wq/d3GXis1MV5noIBmx2K6UeWHD/QXOg/Q
         uBwPIs9d17j6+j2s+XYrW2a51BT+8FPAD2HQdmjHLC5uN4DeKqq27tp9cyd8DPQXsz6q
         cDwg==
X-Gm-Message-State: AFq9FYKeeW82U4maoMSmA2Zbdyk8+KlmcNkcMTr1IfaedjL29H+wqIiB
	MsgZokfBM6zww/u9i89f/SelKBp2Y0DV81WEXyWidC1lZn6VMfY/9YAQDhYlCw==
X-Gm-Gg: AYBFou2abkixlyKTArG8TziJLDGLzG2rqDyBGYItxGAMrQA04jEU9phdsjHNNwqgr4A
	+azPS+JK3NpEOHO8Mhwud7Lg/59cQ1r7wPfrEkvDtyOuQrJt7VrIenT2j6yXetiP9D5pMUynPP+
	IQ8bBbq7bE+i/kWaKOrwMOtD0F508OuCP9MW9YiuYeXb4uPW7i2M1kdJukRLVlmvdbKR0dwIpCq
	+PE++T3K65kyNA0lBZ5RbQ11w9l0ovadRWk8pQ0gLCyHKEsDqpH3GgljKu8i1pRKa4P0pVaP6NH
	gbp06G+l2xz6FLIyRkt451QKWEln7Layjwf2qObk1eKYNrWSmMchDRElE77ivrO5bNzd/o+ebEt
	q78c1i1qofpA0pQYojG228KIVyCQyO4m03fiZne3MLFk6P3Q7yKOca1EkWjn+el9OPuijbP1nCI
	8N/0FMB9vJY28tiP4ezX6X9okX8DrcUXjkJvJhn+igqrDgqBDd+WyCcVQ7VhKfOQnADOkiQGQX3
	wM1cNN6bIkMAOI/8fhPKMgjj2GGW3KhHO8UkSsXijjFfOaFtq8qvxBwXG4GcR2Jy0h3zSmosGRg
	tsUzNwwg05oX3sJLwL/0DcLLo48jJOx9w44n
X-Received: by 2002:a05:600c:a11:b0:4a1:e11f:b2e1 with SMTP id 5b1f17b1804b1-4a966773233mr128035615e9.15.1793277239374;
        Thu, 29 Oct 2026 05:33:59 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f4188f4sm60307085e9.4.2026.10.29.05.33.58
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 05:33:58 -0700 (PDT)
Message-ID: <a437b090-8285-4fda-b695-da4b66c8f365@gmail.com>
Date: Thu, 29 Oct 2026 14:33:57 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] wifi: rtw88: 88xxa: receive VHT SU beamformed
 transmissions
To: linux-wireless@vger.kernel.org
References: <20261029055212.84711-1-hjf3108@gmail.com>
 <20261029055212.84711-3-hjf3108@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261029055212.84711-3-hjf3108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/10/2026 07:52, Ho Jie Feng wrote:
> Implement beamformee support for 88xxa since they have
> support for it.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/bf.h       |  2 +
>  drivers/net/wireless/realtek/rtw88/main.c     | 12 ++--
>  drivers/net/wireless/realtek/rtw88/reg.h      |  1 +
>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  3 +-
>  drivers/net/wireless/realtek/rtw88/rtw8814a.c | 36 ++++++++++-
>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  3 +-
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 62 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  2 +
>  8 files changed, 112 insertions(+), 9 deletions(-)
> 

Is it really this simple? The vendor driver has a lot more
beamforming code than this.

> diff --git a/drivers/net/wireless/realtek/rtw88/bf.h b/drivers/net/wireless/realtek/rtw88/bf.h
> index a5d3010e6be6e..0aa78fb6a7e64 100644
> --- a/drivers/net/wireless/realtek/rtw88/bf.h
> +++ b/drivers/net/wireless/realtek/rtw88/bf.h
> @@ -12,6 +12,8 @@
>  #define REG_ASSOCIATED_BFMER0_INFO	0x06E4
>  #define REG_ASSOCIATED_BFMER1_INFO	0x06EC
>  #define REG_TX_CSI_RPT_PARAM_BW20	0x06F4
> +#define REG_TX_CSI_RPT_PARAM_BW40	0x06F8
> +#define REG_TX_CSI_RPT_PARAM_BW80	0x06FC
>  #define REG_SND_PTCL_CTRL		0x0718
>  #define BIT_DIS_CHK_VHTSIGB_CRC		BIT(6)
>  #define BIT_DIS_CHK_VHTSIGA_CRC		BIT(5)
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index f7d7b66844862..0a1b5575b7299 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1605,6 +1605,7 @@ static void rtw_init_ht_cap(struct rtw_dev *rtwdev,
>  static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
>  			     struct ieee80211_sta_vht_cap *vht_cap)
>  {
> +	const struct rtw_chip_info *chip = rtwdev->chip;
>  	struct rtw_efuse *efuse = &rtwdev->efuse;
>  	u16 mcs_map = 0;
>  	__le16 highest;
> @@ -1623,10 +1624,13 @@ static void rtw_init_vht_cap(struct rtw_dev *rtwdev,
>  		       0;
>  	if (rtwdev->hal.rf_path_num > 1)
>  		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
> -	vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
> -			IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
> -	vht_cap->cap |= (rtwdev->hal.bfee_sts_cap <<
> -			IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
> +	if (rtw_bf_support && chip->bfer_su_max_num) {
> +		vht_cap->cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
> +		vht_cap->cap |= rtwdev->hal.bfee_sts_cap <<
> +				IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
> +	}
> +	if (rtw_bf_support && chip->bfer_mu_max_num)
> +		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
>  
>  	if (rtw_chip_has_rx_ldpc(rtwdev))
>  		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;

This could be a separate patch, since it doesn't look related to 88xxa.

> diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
> index afcdb66fdb9a1..f8ec1e2931f63 100644
> --- a/drivers/net/wireless/realtek/rtw88/reg.h
> +++ b/drivers/net/wireless/realtek/rtw88/reg.h
> @@ -671,6 +671,7 @@
>  #define REG_IQK_COM96		0x0984
>  
>  #define REG_FAS			0x09a4
> +#define REG_CSI_CONTENT_VALUE	0x09b4
>  #define REG_RXSB		0x0a00
>  #define BIT_RXSB_ANA_DIV	BIT(15)
>  #define REG_CCK_RX		0x0a04
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> index 55f1d3d3240be..5d58dff4fcee7 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> @@ -931,7 +931,7 @@ static const struct rtw_chip_ops rtw8812a_ops = {
>  	.phy_calibration	= rtw8812a_phy_calibration,
>  	.cck_pd_set		= rtw_phy_cck_pd_set,
>  	.pwr_track		= rtw8812a_pwr_track,
> -	.config_bfee		= NULL,
> +	.config_bfee		= rtw88xxa_bf_config_bfee,
>  	.set_gid_table		= NULL,
>  	.cfg_csi_rate		= NULL,
>  	.led_set		= rtw8812a_led_set,
> @@ -1084,6 +1084,7 @@ const struct rtw_chip_info rtw8812a_hw_spec = {
>  	.old_datarate_fb_limit = true,
>  	.usb_tx_agg_desc_num = 1,
>  	.iqk_threshold = 8,
> +	.bfer_su_max_num = 2,
>  	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814a.c b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
> index 5bb55606f14a1..2db05a83766d6 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8814a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
> @@ -4,6 +4,7 @@
>  
>  #include <linux/usb.h>
>  #include "main.h"
> +#include "bf.h"
>  #include "coex.h"
>  #include "tx.h"
>  #include "phy.h"
> @@ -115,10 +116,13 @@ static void rtw8814a_init_hwcap(struct rtw_dev *rtwdev)
>  			   BIT(RTW_CHANNEL_WIDTH_80);
>  	efuse->hw_cap.ptcl = EFUSE_HW_CAP_PTCL_VHT;
>  
> -	if (hal->rf_type == RF_3T3R)
> +	if (hal->rf_type == RF_3T3R) {
>  		efuse->hw_cap.nss = 3;
> -	else
> +		hal->bfee_sts_cap = 2;
> +	} else {
>  		efuse->hw_cap.nss = 2;
> +		hal->bfee_sts_cap = 1;
> +	}
>  
>  	rtw_dbg(rtwdev, RTW_DBG_EFUSE,
>  		"hw cap: hci=0x%02x, bw=0x%02x, ptcl=0x%02x, ant_num=%d, nss=%d\n",
> @@ -2039,6 +2043,31 @@ static void rtw8814a_led_set(struct led_classdev *led,
>  	rtw_write32(rtwdev, REG_GPIO_PIN_CTRL_2, led_gpio_cfg);
>  }
>  
> +#define RTW_NDP_RX_STANDBY_TIME_8814A	0x40
> +#define RTW_SND_CTRL_SOUNDING_8814A	0xDB
> +
> +static void rtw8814a_bf_enable_bfee_su(struct rtw_dev *rtwdev,
> +				       struct rtw_vif *vif,
> +				       struct rtw_bfee *bfee)
> +{
> +	rtw_bf_enable_bfee_su(rtwdev, vif, bfee);
> +
> +	rtw_write16(rtwdev, REG_SND_PTCL_CTRL + 1, 0x0202);
> +	rtw_write8(rtwdev, REG_SND_PTCL_CTRL, RTW_SND_CTRL_SOUNDING_8814A);
> +	rtw_write8(rtwdev, REG_SND_PTCL_CTRL + 3,
> +		   RTW_NDP_RX_STANDBY_TIME_8814A);
> +}
> +
> +static void rtw8814a_bf_config_bfee(struct rtw_dev *rtwdev,
> +				    struct rtw_vif *vif,
> +				    struct rtw_bfee *bfee, bool enable)
> +{
> +	if (enable)
> +		rtw8814a_bf_enable_bfee_su(rtwdev, vif, bfee);
> +	else
> +		rtw_bf_remove_bfee_su(rtwdev, bfee);
> +}
> +
>  static void rtw8814a_fill_txdesc_checksum(struct rtw_dev *rtwdev,
>  					  struct rtw_tx_pkt_info *pkt_info,
>  					  u8 *txdesc)
> @@ -2068,7 +2097,7 @@ static const struct rtw_chip_ops rtw8814a_ops = {
>  	.phy_calibration	= rtw8814a_phy_calibration,
>  	.cck_pd_set		= rtw8814a_phy_cck_pd_set,
>  	.pwr_track		= rtw8814a_pwr_track,
> -	.config_bfee		= NULL,
> +	.config_bfee		= rtw8814a_bf_config_bfee,
>  	.set_gid_table		= NULL,
>  	.cfg_csi_rate		= NULL,
>  	.led_set		= rtw8814a_led_set,
> @@ -2231,6 +2260,7 @@ const struct rtw_chip_info rtw8814a_hw_spec = {
>  	.rfe_defs = rtw8814a_rfe_defs,
>  	.rfe_defs_size = ARRAY_SIZE(rtw8814a_rfe_defs),
>  	.iqk_threshold = 8,
> +	.bfer_su_max_num = 2,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
>  
>  	.coex_para_ver = 0,
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> index 6096d3b8e41be..6d106ae70d914 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> @@ -877,7 +877,7 @@ static const struct rtw_chip_ops rtw8821a_ops = {
>  	.phy_calibration	= rtw8821a_phy_calibration,
>  	.cck_pd_set		= rtw_phy_cck_pd_set,
>  	.pwr_track		= rtw8821a_pwr_track,
> -	.config_bfee		= NULL,
> +	.config_bfee		= rtw88xxa_bf_config_bfee,
>  	.set_gid_table		= NULL,
>  	.cfg_csi_rate		= NULL,
>  	.led_set		= rtw8821a_led_set,
> @@ -1188,6 +1188,7 @@ const struct rtw_chip_info rtw8821a_hw_spec = {
>  	.old_datarate_fb_limit = true,
>  	.usb_tx_agg_desc_num = 6,
>  	.iqk_threshold = 8,
> +	.bfer_su_max_num = 2,
>  	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> index c298fa0fb2a6b..d3dd0ebfb4024 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> @@ -138,6 +138,7 @@ static void rtw88xxa_read_usb_type(struct rtw_dev *rtwdev)
>  		efuse->hw_cap.nss = 1;
>  	else
>  		efuse->hw_cap.nss = 2;
> +	hal->bfee_sts_cap = 1;
>  
>  	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821A)
>  		goto print_hw_cap;
> @@ -197,6 +198,67 @@ static void rtw88xxa_read_usb_type(struct rtw_dev *rtwdev)
>  		efuse->hw_cap.ant_num, efuse->hw_cap.nss);
>  }
>  
> +#define RTW_NDP_RX_STANDBY_TIME_88XXA	0x50
> +#define RTW_SND_CTRL_REMOVE_88XXA	0xC8
> +#define RTW_SND_CTRL_SOUNDING_88XXA	0xCB
> +
> +void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
> +			     struct rtw_bfee *bfee, bool enable)
> +{
> +	static const u32 csi_rpt_regs[] = {
> +		REG_TX_CSI_RPT_PARAM_BW20,
> +		REG_TX_CSI_RPT_PARAM_BW40,
> +		REG_TX_CSI_RPT_PARAM_BW80,
> +	};
> +	struct rtw_bf_info *bf_info = &rtwdev->bf_info;
> +	u8 slot = bfee->su_reg_index;
> +	u32 addr_bfer_info;
> +	u32 csi_param;
> +	int i;
> +
> +	if (bfee->role != RTW_BFEE_SU || slot >= 2)
> +		return;
> +
> +	addr_bfer_info = slot ? REG_ASSOCIATED_BFMER1_INFO :
> +				      REG_ASSOCIATED_BFMER0_INFO;
> +
> +	rtw_dbg(rtwdev, RTW_DBG_BF, "chip %d SU beamformee %s slot %u\n",
> +		rtwdev->chip->id, enable ? "enable" : "disable", slot);
> +
> +	if (!enable) {
> +		rtw_write32(rtwdev, addr_bfer_info, 0);
> +		rtw_write16(rtwdev, addr_bfer_info + 4, 0);
> +
> +		clear_bit(slot, bf_info->bfer_su_reg_maping);
> +		bfee->su_reg_index = 0xff;
> +
> +		if (!bf_info->bfer_su_cnt)
> +			rtw_write8(rtwdev, REG_SND_PTCL_CTRL,
> +				   RTW_SND_CTRL_REMOVE_88XXA);
> +		return;
> +	}
> +
> +	if (hweight8(rtwdev->hal.antenna_rx) == 2) {
> +		rtw_write32(rtwdev, REG_CSI_CONTENT_VALUE, 0);
> +		csi_param = 0x01090109;
> +	} else {
> +		rtw_write32(rtwdev, REG_CSI_CONTENT_VALUE, 0x01081008);
> +		csi_param = 0x01080108;
> +	}
> +
> +	rtw_write8(rtwdev, REG_SND_PTCL_CTRL,
> +		   RTW_SND_CTRL_SOUNDING_88XXA);
> +	for (i = 0; i < ETH_ALEN; i++)
> +		rtw_write8(rtwdev, addr_bfer_info + i, bfee->mac_addr[i]);
> +
> +	for (i = 0; i < ARRAY_SIZE(csi_rpt_regs); i++)
> +		rtw_write32(rtwdev, csi_rpt_regs[i], csi_param);
> +
> +	rtw_write8(rtwdev, REG_SND_PTCL_CTRL + 3,
> +		   RTW_NDP_RX_STANDBY_TIME_88XXA);
> +}
> +EXPORT_SYMBOL(rtw88xxa_bf_config_bfee);
> +
>  int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>  {
>  	const struct rtw_chip_info *chip = rtwdev->chip;
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> index d9c8db58909ca..0aaf7aa4aafdd 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> @@ -170,5 +170,7 @@ bool rtw88xxa_iqk_finish(int average, int threshold,
>  void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
>  			   void (*do_lck)(struct rtw_dev *rtwdev),
>  			   void (*do_iqk)(struct rtw_dev *rtwdev));
> +void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
> +			     struct rtw_bfee *bfee, bool enable);
>  
>  #endif

