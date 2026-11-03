Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723787;
	b=svte/SKTvIY95JHpM7y5T0SZtLwVS5EO4w/QzDPqPeUX5fB1lT8fkTenRxEZanMVVRdb
	 FfZdTdXTkxJ8G7KqZ0o8Q2TTZTUNnx8bxAlyTo01b29SK+uh0j+h6srfbbnflS0OheW5u
	 eUz7/Y03jlC3G5boby6FR//d+cPsAHHacgWzkNkBe5pTDTYTboE3bSM219j2pxGpOso+4
	 390J4BaHIdN5kWlP1vKyIZCx3uyKGJ9FMJgV1/bLOKfR+2sluS0Ln5tb3IvtlieP5JbiH
	 PGvGwZ4MzEdOXCjzjrNx8jwaxwzjN5xBYYgf3zIStJb/GVMvfRQU0X1UpRj+CfOVvew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723787;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8Ejv8GVvQd5owGxqcqoZOElpKPNmDNBalD0J5dSHWPY=;
	b=nn+ZU9oJkKmsBfpEd2MKht0HDw0dMnDk0DJs1g3gv2u8hNDcyxecww8dZNgQH8Pn0npY
	 nU5poJtI5ZtvouDkMSL8BXnyYz4NM4dcew1UbjhtuiSFx4HJtO+ODqc8O9c1f/bE+EgcW
	 wxChpJUkGJSIxzR1gOmjUov7Fhpr4lcoynT200WnETK50ol8Qg5HWd6XU4SHNfMEbEYHt
	 PaDu9ILl8LiJKZ2oCvJe3AOZ9+XkQCWQdsGNqvcrHJQxkmaR2mNCgywWGb8uRooCd6DY3
	 eUKLplnlhQy4wQzlcnZcjTwV+QbLKI5Z7J5LKEPnv1hVLsFpRhRbKyMHrhYNmDEFQOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VcdfYzzB;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3DE606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:36:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B3DE606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VcdfYzzB
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so11911555e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 08:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793723786; x=1794328586; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Ejv8GVvQd5owGxqcqoZOElpKPNmDNBalD0J5dSHWPY=;
        b=VcdfYzzB0aWEHxMJhWG6Rqs7pDEB6PpdaFlLSzBDIIzXPC4696e0qLG9Cqi8kHCSQr
         mNb/rWUJlJwJVAA70cV9cdkjyK7NXOWAiCuZIjIh2DXHYQQPhFm1UD4EKE6T/zKePp4u
         /+nN+plADEXxS3Xl66a8jHFrtrzjQmKpb/xY1OS7LwbmJ8YKe5b6iC+PeArPnBtmrdDd
         z3IONmpJajUK42pw80yknTSobJj976cn/LmePGEMBuT5fE8IJAdHtRhl5az5X66Csp9y
         67+an66QIAiN7UvfPC694Pm8DH0onrBsOw9uPqj/NhJUlwXrkWwfSmNbEZn6yAICZgIL
         omOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793723786; x=1794328586;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Ejv8GVvQd5owGxqcqoZOElpKPNmDNBalD0J5dSHWPY=;
        b=QQpZ/81YZxXL7aSgKqx9C1eholdPSriQaAFyMdDL6bnjvBlnjux6WsbZbps9Nl9KNC
         YmMiGKuaX5K8igwxX8HbPTex/Fr11WvHaemYVISBC80LoHpOGu/4h6nV1gJd25o5z3tA
         7Uu54sw2Ygl8v/Hb9nUFMRs6LK1zEFYPrl/oj+NWGhJ5SKV7P+0ZnDJgvTTTRlJaQd6e
         DYwkX/QnYJ+58Al6eJq/ZO1yxCALvyYRhPnV8AeHHSM0Nm3G6CN5FxhP3npBPjOL/wqD
         kASvO+CX9+GhFGpAuzoNz+iAM4ftjZSCwQ3hE9tUqfjGgaUeCBgP58v77JAnXMOEZ0bi
         z6ew==
X-Gm-Message-State: APuU4Z/5w1+eS5yQLPwjylgFvAeCsiI1oQh/7vtHIQQvS42FybtD79Rt
	s9ya1ftuHExvlg+gK/FVDkJPgHrL6m+MdX++ojeEC2GDKvajFaHcFH1eHGxmknlc
X-Gm-Gg: AYBFou3ge1UXfLKKAexcy7XMNtspsmvyyH2C5jXRPEGYw0/HUWaH1frBxUPQcljYyoS
	NuEOzuMnVD6sY0VAErgGuzmcR23P2AVsPhje/onSxZ3va0ymiUngT3dTDbZ67KTOiBcIUGQwAds
	fILWqRU5LUS+1hnLxvpTZFp3Uo8y2oEBwRB+iLuEw6EyD7kv80S43FyWHndT/iANSHb7FCIPAxv
	E0latIl2eybo+6aO9MRyPo2mA6WzR+hZHKd6vyNi6eUZJoGXyjxXHLcworZRcLPggM6i3zLJ3B3
	a8LkYqz+uz5ak/oaF4LW+UsNSmwgrDAApeHWZs6EYUTCLor1/hi3KW/sm4VvxO96YnQZmB3WTDw
	7xROoh/W0ZdZVf5PwiaUNzRCkDF8c4MI5p4AsZMWx9sj6QmpRJW0FFZdOmS60K6ohAg6KqHHbKU
	O/tEZhiy/C+DxkhFu62wk9kqGbfG+pJjEY6C1oh+M9IUp7cZpD0twQPatIRQnosv/VVypuIabkP
	Szab7uV7lW3Spj0UMWgZTf+4ESpKmOc67tbCFMoHNWXhrU3sWeqX0TXJFJGYWU25tJVh7vZ0J39
	iOEAmXWR/kip3WTjXp2sPQuJ9cG22/PFqIA=
X-Received: by 2002:a05:600c:8b48:b0:4a8:a341:2377 with SMTP id 5b1f17b1804b1-4ac16acd9d1mr333375815e9.3.1793723785561;
        Tue, 03 Nov 2026 08:36:25 -0800 (PST)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abebe33e79sm259476635e9.2.2026.11.03.08.36.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 08:36:25 -0800 (PST)
Message-ID: <b0ced272-5016-4060-a58b-23a3f4550d1c@gmail.com>
Date: Tue, 3 Nov 2026 18:36:23 +0200
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
Subject: Re: [PATCH rtw-next v2 2/7] wifi: rtw88: 88xxa: receive VHT SU
 beamformed transmissions
To: linux-wireless@vger.kernel.org
References: <20261031070950.425176-1-hjf3108@gmail.com>
 <20261031070950.425176-3-hjf3108@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261031070950.425176-3-hjf3108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 31/10/2026 09:09, Ho Jie Feng wrote:
> Implement beamformee support for 88xxa since they have
> support for it.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/bf.h       |  2 +
>  drivers/net/wireless/realtek/rtw88/reg.h      |  1 +
>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  3 +-
>  drivers/net/wireless/realtek/rtw88/rtw8814a.c | 36 ++++++++++-
>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  3 +-
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 62 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  2 +
>  7 files changed, 104 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/bf.h b/drivers/net/wireless/realtek/rtw88/bf.h
> index a5d3010e6be6ef776b1c604207f68d6331721feb..0aa78fb6a7e64435e4d5fc18f3e9c70a01d73135 100644
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
> diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
> index afcdb66fdb9a11a44bf52c790aea2cc69aeb851c..f8ec1e2931f63a06a72626bf3168256728ed933b 100644
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
> index 55f1d3d3240be24580bdc4a7b3456b8ff8340e70..5d58dff4fcee7c4b3194794266cb48cd472014f9 100644
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
> index 5bb55606f14a126806acb354658c150150ae0cce..2db05a83766d65123edc95f50a40d3f93bfb1dba 100644
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
> index 6096d3b8e41bee6cdc2d05500d2fbeb9e097430e..6d106ae70d9142b45337057311dc423158e7dabc 100644
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
> index c298fa0fb2a6b94118527a297affa5e6e8ab633d..87253fffe78cd6f5b58a325eef42b58b968e2d46 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> @@ -138,6 +138,7 @@ static void rtw88xxa_read_usb_type(struct rtw_dev *rtwdev)
>  		efuse->hw_cap.nss = 1;
>  	else
>  		efuse->hw_cap.nss = 2;
> +	rtwdev->hal.bfee_sts_cap = 1;
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

By the way, you don't need to print the chip ID because this message is
automatically prefixed with the module name (rtw88_8812au or rtw88_8821au).

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
> index d9c8db58909cad07b06ab993a08b246b1a9bf74d..0aaf7aa4aafdd396bff25a8fcd880a5514e589ba 100644
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

