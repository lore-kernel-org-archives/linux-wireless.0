Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12583B637F
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784974633; cv=none; b=JGOaxLJXYv0Fq4//54g6MtKfhlEJw+dFo6L9iKfUkCeaKHsevCUnSTpFmzu/akbpdVaOqaZ/MctLK7EbHtJ2jRHPIWSyrBjdvYqIRHqpdeQHN0nXEOCnp3tNw+0nNDxDdXJT9+V7QMa3KRwaR9ehu9H+Di7S+BgwQ6yLTtvf65c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784974633; c=relaxed/simple;
	bh=W65bBVTTPPNOnEjP4KCxhnd+X0yisxFIm/BrThabImk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qMGvJO8qd16nmkQgd2oP2f6HElVmhrRHoh+C0iXwWbe4S2v4R/gw7VRa+yBk8iVKQ6FDiF6ysj/uY0K9BBCUFICBExubv7ba57n/OVSgUGXJHRTD4BO3W7xxhNwEzgexzttzqaJMa4sawHbAkYis0UylwcZxUVPG0CwYLiCFxFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmMwILh8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmMwILh8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49557167508so11909295e9.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 03:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784974628; x=1785579428; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pxgaj4ziBaYk3jWVl2nTaXJq4vxwI5aO/MKEtSh/FrA=;
        b=BmMwILh8TcSC0qeBWThAY04XC2G2BReJV/RKUkn0MNKZkpJMtTfvRvAKyJi0LKgW+s
         Ijr6rPmPaphfBiUGyxNwStSYlk2Pf0r0K3oDG/IeKf/Oc8GTfX5+owxbRkmLGuOfAvYm
         SnajUHlq/TMzZaOrZezl6cUYyHrVnQBjBAkGf7n08R2QVdzg472K+ehzax3ofm0zBpPO
         7vC1UnfvetEp1E4a5IJncRC86zF/HG6yf8se3exIbHTTFuehALuh+3Y3Ru82CO2LJVku
         25U4a6UnXxseWovvNr1hjA9HC+MW5qfMjG7C7NrvvY7h3VtcWf0DwOfQ5ojhhcroNC7A
         mL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784974628; x=1785579428;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pxgaj4ziBaYk3jWVl2nTaXJq4vxwI5aO/MKEtSh/FrA=;
        b=SvPxODkTWHTKiAWy8xGs2Pm77yRJv5zWM3+OV4HqanWg7KLk74oAmQmVQulIa1yf45
         LQsk0Ce4Urf+ZydnzvKojhNwheaOeRPgFkEmKbP0sHnR0NWls6YBA5DacuQXECMpoeqe
         T8OG5hMkKlW+2WoOlhv2kcaAavlfSjJur+tmmyBH9c7aHFZXdGxNfLlPFoCC9nFDg+U4
         Napr3dyhVfkz8fH/stLkT4Z3Tp8p/YdHmhp0u4amNXuQov47rdeuPCFMduw1RgdDXkGx
         QAv1K96ArKGn4c7I7Qa0D9ME+qkSi6YSk2jj53a4ZdGkZ2qqDOE6GRFDWxh5qCW4DvjB
         /7tQ==
X-Gm-Message-State: AOJu0YzX85FsKFk/aisotpogr1vWYEIdtef4tZNlnYcDpsM+o13ggn2C
	SpGNq6DGf/L5hP40RoIb/tLnWrcOt344OliRjszUTrOVHGuM5ACHo5Lg
X-Gm-Gg: AR+sD10/6aH+03YVAm6zGIu/05ySenR/T+C1RHxQxoELGG8pb0y/yJKunS3adBYPujs
	LaIuhYAxZrakE6LwBpLHiQt9sqLXxBJF8/jmfnpdJjiJj4EFrF6Nnaqpx3Z8RnLO0wlamDK9YWj
	FYkdhS74bnP6SUv8mb7nCxWnCCNIGsTKYP4uRwpsP7w5hw4Vin7zrNJwruLua059k5azknpX2q9
	xSuzX7tm5JJWC7A9ulwS0Gop/7jGrd+2oe7mSnoiWe1VjyOrStKevaNrCHzelIvgg2GYshNdzFh
	EjyQnUL5uw4tCQR5VEHppr5ZensvYcEJJnb584UM34sWXtKylvIFFsW2ZpbckrBpd4vArAsYURE
	UVlZfd37sB4K1TiogjRHDd2Fn28X/v5+ItTH/+Slf2Rv68oYLgiPWkq5XmNWFEE2W6GwZOjA8dA
	pC6G+NBZeR
X-Received: by 2002:a05:600c:3512:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-496b56c57e4mr22178785e9.10.1784974627865;
        Sat, 25 Jul 2026 03:17:07 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bd850asm30605411f8f.15.2026.07.25.03.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2026 03:17:07 -0700 (PDT)
Message-ID: <c767bcbb-a2d1-4ebb-bd67-0d9661b285cb@gmail.com>
Date: Sat, 25 Jul 2026 13:17:05 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/19] wifi: rtw88: fw: add the vendor firmware commands
 used by RTL8723BS
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724181858.192903-8-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724181858.192903-8-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:18, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> The RTL8723BS join and coexistence sequences need four commands that
> rtw88 does not implement: MACID_CFG to configure rate adaptation after
> association, the WL channel info report, the firmware GNT_BT state, and
> the coexistence antenna select reserve that forms part of the vendor
> initialisation toggle.

But rtw88 does implement the first two.

> 
> Add them here so the coexistence and association changes that follow
> have the commands available.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 59 +++++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/fw.h | 13 ++++++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 87da0dd82aaa..b43ee5d951fd 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -856,6 +856,65 @@ void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
>  	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
>  }
>  
> +/* 8723BS SDIO: post-assoc rate-adaptation config in the vendor v5.2.17
> + * MACID_CFG byte layout. disra (bit7 of [2]) must stay 0 so the firmware keeps
> + * running rate adaptation for this mac_id.
> + */
> +void rtw_fw_macid_cfg(struct rtw_dev *rtwdev, u8 mac_id, u8 raid, u8 bw,
> +		      u8 sgi, u32 rate_mask)
> +{
> +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
> +
> +	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
> +
> +	h2c_pkt[1] = mac_id & 0x7f;
> +	h2c_pkt[2] = (raid & 0x1f) | (sgi ? BIT(7) : 0) | 0x60;
> +	h2c_pkt[3] = (bw ? 3 : 1) & 0x3;
> +	h2c_pkt[4] = rate_mask & 0xff;
> +	h2c_pkt[5] = (rate_mask >> 8) & 0xff;
> +	h2c_pkt[6] = (rate_mask >> 16) & 0xff;
> +	h2c_pkt[7] = (rate_mask >> 24) & 0xff;
> +
> +	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
> +}
> +
> +/* 8723BS SDIO: report the connected channel/bandwidth to the vendor firmware. */
> +void rtw_fw_send_wl_ch_info(struct rtw_dev *rtwdev, u8 ch, u8 bw)
> +{
> +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
> +	u8 bw_byte = bw == RTW_CHANNEL_WIDTH_40 ? 0x30 : 0x20;
> +
> +	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_WL_CH_INFO);
> +	h2c_pkt[1] = 0x00;
> +	h2c_pkt[2] = ch;
> +	h2c_pkt[3] = bw_byte;
> +
> +	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
> +}
> +
> +/* 8723BS SDIO: set the firmware GNT_BT state (0 = WiFi owns the antenna). */
> +void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state)
> +{
> +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
> +
> +	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_GNT_BT);
> +	SET_GNT_BT_STATE(h2c_pkt, state);
> +
> +	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
> +}
> +
> +/* 8723BS SDIO: vendor coex antenna-select reserve H2C (part of the init toggle). */
> +void rtw_fw_coex_ant_sel_rsv(struct rtw_dev *rtwdev, u8 inverse, u8 type)
> +{
> +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
> +
> +	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_COEX_ANT_SEL_RSV);
> +	SET_COEX_ANT_SEL_RSV_INVERSE(h2c_pkt, inverse);
> +	SET_COEX_ANT_SEL_RSV_TYPE(h2c_pkt, type);
> +
> +	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
> +}
> +
>  void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev)
>  {
>  	struct rtw_traffic_stats *stats = &rtwdev->stats;
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
> index 6927d2041d24..8b238b41decf 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.h
> +++ b/drivers/net/wireless/realtek/rtw88/fw.h
> @@ -572,10 +572,12 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
>  #define H2C_CMD_QUERY_BT_INFO		0x61
>  #define H2C_CMD_FORCE_BT_TX_POWER	0x62
>  #define H2C_CMD_IGNORE_WLAN_ACTION	0x63
> +#define H2C_CMD_COEX_ANT_SEL_RSV	0x65
>  #define H2C_CMD_WL_CH_INFO		0x66
>  #define H2C_CMD_QUERY_BT_MP_INFO	0x67
>  #define H2C_CMD_BT_WIFI_CONTROL		0x69
>  #define H2C_CMD_WIFI_CALIBRATION	0x6d
> +#define H2C_CMD_GNT_BT			0x6e
>  #define H2C_CMD_QUERY_BT_HID_INFO	0x73
>  
>  #define H2C_CMD_KEEP_ALIVE		0x03
> @@ -688,6 +690,12 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
>  	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 24))
>  #define SET_QUERY_BT_INFO(h2c_pkt, value)                                      \
>  	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
> +#define SET_GNT_BT_STATE(h2c_pkt, value)                                       \
> +	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
> +#define SET_COEX_ANT_SEL_RSV_INVERSE(h2c_pkt, value)                           \
> +	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
> +#define SET_COEX_ANT_SEL_RSV_TYPE(h2c_pkt, value)                              \
> +	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(23, 16))
>  #define SET_WL_CH_INFO_LINK(h2c_pkt, value)                                    \
>  	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
>  #define SET_WL_CH_INFO_CHNL(h2c_pkt, value)                                    \
> @@ -853,6 +861,11 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
>  void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
>  			 bool reset_ra_mask);
>  void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool conn);
> +void rtw_fw_macid_cfg(struct rtw_dev *rtwdev, u8 mac_id, u8 raid, u8 bw,
> +		      u8 sgi, u32 rate_mask);
> +void rtw_fw_send_wl_ch_info(struct rtw_dev *rtwdev, u8 ch, u8 bw);
> +void rtw_fw_set_gnt_bt(struct rtw_dev *rtwdev, u8 state);
> +void rtw_fw_coex_ant_sel_rsv(struct rtw_dev *rtwdev, u8 inverse, u8 type);
>  void rtw_fw_update_wl_phy_info(struct rtw_dev *rtwdev);
>  void rtw_fw_beacon_filter_config(struct rtw_dev *rtwdev, bool connect,
>  				 struct ieee80211_vif *vif);

