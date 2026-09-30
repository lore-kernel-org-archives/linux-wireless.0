Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258BE5187F2
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791455; cv=none; b=uvdQ3iPAS6vDzyaOchMeuGhRBnUIseRWHnawQ1LWBNLZidEwVtKlEX3600XC9IYupKl+ykiD0VwpuNJmAncO4Xeplx680Qy958DLpX8qXGvmsFOj/ypsgW5jeLnaGTeOFsjSm11VcdOpZGN6uDVLdEc43X0lUBBG98RFNLDhxUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791455; c=relaxed/simple;
	bh=QIG1zvSUGauIoXtqtHh2yufnecHZavhFDmqcR25makY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pSzbmFs4ZrJX7Tgo1rHw+l7z1+FWQ+h2uGwIz3e6Wx57IrHRXFq3Pi3gYjujKLrtF4we1Q1YdohQlt/uaHMcTimIH7Bn5zhBW/LvzSLgG6WEfQ5evlcFgfQJgSEU9qmIHXm+4FU4ennPoSAmrH/5D/PiIVvkfbn27bwoxURfJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g7g5Gpbv; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7g5Gpbv"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffde3cec6so25057495e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790791451; x=1791396251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e36HxZ24cTROxvIeKoBoxdqQGOepjEsy2kiFHXydvxA=;
        b=g7g5GpbvKSf8lxUP0Ex77aQuer5Uu0yPkIwfSwUX4yIXFWdgfyBcUNCSy3r3J9i11R
         zLM2gG/d5UXXPb0S3AtdTVj2IXMNGxXuj3jzSpudT7otSoP5GHQsBwEkUA2aIj8DP0rj
         nQfmATWR+WmHjypZGC5P8KXgPvPutI9w/KufdGV+ndbRgCQW5DDdhIfOtVaM0tDyjzIB
         Y26JGzwX+oZ9x8ewcX5Y5DiwqVuz9BF1panZKKvUWa2EmhLS6uEShT4UeemZFw2IQ+dy
         9re4XL9KpT5dIjVm37n/XtbItCKi9kIZpFCRPjU0oa68hv5hJ06YYQ2tX3hqT7N1Rgmx
         PQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790791451; x=1791396251;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e36HxZ24cTROxvIeKoBoxdqQGOepjEsy2kiFHXydvxA=;
        b=vb/oyWq7Bns3jxlmElMmbfnniYWUQwjH/EkBUUIV4uycuRThb5OmBmCeMFkglRJopd
         o6LvvOFsqWe34yN/RfyWA0355u+osg2MZGYwJqC7SvUqhFDz11i1+SL4RVXOqe9FR/Nz
         b95LFJqLUkTFuf43kbyLKH1uqmRYAtFEdefFZJwHh8v+lPBUH6pNbqAJfEjx8MIF2x4b
         iB4YwfM/fIY5r3LqrgXc4ReoMKuozjD8cKaTSqtFcqMfFfFXz2cPQzeVeFRege7CGWI4
         nLl649YVIRQdgbbSzMC3sqe5/7NiW+lZAGtKbFSRc1ULbeZ1XJ7hq3kFz112OHDM5qGR
         WDIA==
X-Gm-Message-State: AFuF++kH/9VAoGSSuAlFOHqQ1tEzOIkoIVfXDKL+SpV+lQ7txf6C2nI/
	Gh3ggIvb2iAfbxDGPJXhz61us+Ym4LtLaKyvwK1kIa8/+TwNoH/MGFyf
X-Gm-Gg: AYBFou0OhKIQucqee+ENOPdIl4XAfspXUvlo6fAlboejS19N5tPLyTEeXNAchO8FOAu
	dueh7NDAKMCngDxTgGHusFU85oGphp/9xqN7j9FkY1J7rCaNpRG0tO/8RqKLJoD59CGKUddDAYw
	8sXwoRlbpB4MSNYwxa5/3g1s5iHDLbktqXHc5vosWsxckyM9mBsmwiLf7g1M0glA0euSd5d+V0x
	N7t+VEx+ILLutqg1KwVkG1xNXSj75UpC+uBDFhhLh8qFkds+vgTVGF3S7dOWA9VR+BaLogqvaVT
	RQY1m79oRq6G4/f34m3vYDpB5+OwPEOrOQNWSWQVqjN5+bX23Gb5CP2QIX1fyJKWao2SaaSUqfi
	5Vn68xKA02P21R6Sjn+A7gM6b3T+MlFl8LGVp8gTtWf+vh5z9Me3DFFP0NE1zkU8LYTwLZY4ska
	viOmgdRWgjmnZImOC6FbO9CK7eqqkul5hHvwTuXDLhz6BDeyYmxMAD/cJZtQZtHbDbfgmoDaW6o
	705igEzSj9GGkfH
X-Received: by 2002:a05:600c:354e:b0:4a0:1eb1:133b with SMTP id 5b1f17b1804b1-4a01eb113acmr7148175e9.12.1790791450972;
        Wed, 30 Sep 2026 11:04:10 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01cf9b1fasm10196965e9.4.2026.09.30.11.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 11:04:10 -0700 (PDT)
Message-ID: <17f1504d-4a27-48f1-9c8e-e84a3416c383@gmail.com>
Date: Wed, 30 Sep 2026 21:04:09 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 rtw-next 1/7] wifi: rtw88: move the shared 88xxa init
 helpers into the core
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-2-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260930091604.52891-2-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/09/2026 12:15, Luka Gejak wrote:
> The adaptive control, EDCA and CCK power detect helpers in rtw88xxa.c
> program values that are not specific to that chip family. The RTL8723B
> needs all three of them, which would make that chip select RTW88_88XXA
> and pull in a whole chip module for three helpers.
> 
> Move the CCK power detect setter to phy.c as rtw_phy_cck_pd_set(), where
> the rest of the CCK power detect code and the level enum already live,
> and the two MAC init helpers to mac.c as rtw_mac_init_adaptive_ctrl()
> and rtw_mac_init_edca(). The chips that need them call the core
> versions, so rtw88xxa.c no longer provides any of them.
> 
> The two REG_USTIME_* writes are not carried over. rtw88xxa_power_on()
> writes the same values a few lines later, and rtw_set_channel_mac()
> writes them again on every channel set, so the register state of the
> existing chips does not change.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/mac.c      | 22 +++++++
>  drivers/net/wireless/realtek/rtw88/mac.h      |  2 +
>  drivers/net/wireless/realtek/rtw88/phy.c      | 38 +++++++++++
>  drivers/net/wireless/realtek/rtw88/phy.h      |  1 +
>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  2 +-
>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  2 +-
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 65 +------------------
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  1 -
>  8 files changed, 67 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index eaa928bab240..83f142f61df5 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -1419,3 +1419,25 @@ int rtw_mac_postinit(struct rtw_dev *rtwdev)
>  
>  	return chip->ops->mac_postinit(rtwdev);
>  }
> +
> +void rtw_mac_init_adaptive_ctrl(struct rtw_dev *rtwdev)
> +{
> +	rtw_write32_mask(rtwdev, REG_RRSR, 0xfffff, 0xffff1);
> +	rtw_write16(rtwdev, REG_RETRY_LIMIT, 0x3030);
> +}
> +EXPORT_SYMBOL(rtw_mac_init_adaptive_ctrl);
> +
> +void rtw_mac_init_edca(struct rtw_dev *rtwdev)
> +{
> +	rtw_write16(rtwdev, REG_SPEC_SIFS, 0x100a);
> +	rtw_write16(rtwdev, REG_MAC_SPEC_SIFS, 0x100a);
> +
> +	rtw_write16(rtwdev, REG_SIFS, 0x100a);
> +	rtw_write16(rtwdev, REG_SIFS + 2, 0x100a);
> +
> +	rtw_write32(rtwdev, REG_EDCA_BE_PARAM, 0x005EA42B);
> +	rtw_write32(rtwdev, REG_EDCA_BK_PARAM, 0x0000A44F);
> +	rtw_write32(rtwdev, REG_EDCA_VI_PARAM, 0x005EA324);
> +	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, 0x002FA226);
> +}
> +EXPORT_SYMBOL(rtw_mac_init_edca);

No one said anything about moving these functions. Please put them back.

> diff --git a/drivers/net/wireless/realtek/rtw88/mac.h b/drivers/net/wireless/realtek/rtw88/mac.h
> index b73af90ee1d7..b7adc4dd0255 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.h
> +++ b/drivers/net/wireless/realtek/rtw88/mac.h
> @@ -30,6 +30,8 @@
>  
>  void rtw_set_channel_mac(struct rtw_dev *rtwdev, u8 channel, u8 bw,
>  			 u8 primary_ch_idx);
> +void rtw_mac_init_adaptive_ctrl(struct rtw_dev *rtwdev);
> +void rtw_mac_init_edca(struct rtw_dev *rtwdev);
>  int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
>  		       const struct rtw_pwr_seq_cmd * const *cmd_seq);
>  int rtw_mac_power_on(struct rtw_dev *rtwdev);
> diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
> index e2ac5c6fd500..ee16474ac026 100644
> --- a/drivers/net/wireless/realtek/rtw88/phy.c
> +++ b/drivers/net/wireless/realtek/rtw88/phy.c
> @@ -811,6 +811,44 @@ static void rtw_phy_cck_pd(struct rtw_dev *rtwdev)
>  		chip->ops->cck_pd_set(rtwdev, level);
>  }
>  
> +void rtw_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
> +{
> +	static const u8 pd[CCK_PD_LV_MAX] = {0x40, 0x83, 0xcd, 0xdd, 0xed};
> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> +
> +	/* Override rtw_phy_cck_pd_lv_link(). It implements something
> +	 * like type 2/3/4. We need type 1 here.
> +	 */
> +	if (rtw_is_assoc(rtwdev)) {
> +		if (dm_info->min_rssi > 60) {
> +			new_lvl = CCK_PD_LV3;
> +		} else if (dm_info->min_rssi > 35) {
> +			new_lvl = CCK_PD_LV2;
> +		} else if (dm_info->min_rssi > 20) {
> +			if (dm_info->cck_fa_avg > 500)
> +				new_lvl = CCK_PD_LV2;
> +			else if (dm_info->cck_fa_avg < 250)
> +				new_lvl = CCK_PD_LV1;
> +			else
> +				return;
> +		} else {
> +			new_lvl = CCK_PD_LV1;
> +		}
> +	}
> +
> +	rtw_dbg(rtwdev, RTW_DBG_PHY, "lv: (%d) -> (%d)\n",
> +		dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A], new_lvl);
> +
> +	if (dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] == new_lvl)
> +		return;
> +
> +	dm_info->cck_fa_avg = CCK_FA_AVG_RESET;
> +	dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] = new_lvl;
> +
> +	rtw_write8(rtwdev, REG_CCK_PD_TH, pd[new_lvl]);
> +}
> +EXPORT_SYMBOL(rtw_phy_cck_pd_set);
> +
>  static void rtw_phy_pwr_track(struct rtw_dev *rtwdev)
>  {
>  	rtwdev->chip->ops->pwr_track(rtwdev);
> diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
> index 8449936497bb..8a843aac7350 100644
> --- a/drivers/net/wireless/realtek/rtw88/phy.h
> +++ b/drivers/net/wireless/realtek/rtw88/phy.h
> @@ -65,6 +65,7 @@ void rtw_phy_config_swing_table(struct rtw_dev *rtwdev,
>  				struct rtw_swing_table *swing_table);
>  void rtw_phy_set_edcca_th(struct rtw_dev *rtwdev, u8 l2h, u8 h2l);
>  void rtw_phy_adaptivity_set_mode(struct rtw_dev *rtwdev);
> +void rtw_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl);
>  void rtw_phy_parsing_cfo(struct rtw_dev *rtwdev,
>  			 struct rtw_rx_pkt_stat *pkt_stat);
>  void rtw_phy_tx_path_diversity(struct rtw_dev *rtwdev);
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> index 2078eb6e3628..781b66ccde67 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> @@ -929,7 +929,7 @@ static const struct rtw_chip_ops rtw8812a_ops = {
>  	.set_ampdu_factor	= NULL,
>  	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
>  	.phy_calibration	= rtw8812a_phy_calibration,
> -	.cck_pd_set		= rtw88xxa_phy_cck_pd_set,
> +	.cck_pd_set		= rtw_phy_cck_pd_set,
>  	.pwr_track		= rtw8812a_pwr_track,
>  	.config_bfee		= NULL,
>  	.set_gid_table		= NULL,
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> index cab85203b828..6096d3b8e41b 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> @@ -875,7 +875,7 @@ static const struct rtw_chip_ops rtw8821a_ops = {
>  	.set_ampdu_factor	= NULL,
>  	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
>  	.phy_calibration	= rtw8821a_phy_calibration,
> -	.cck_pd_set		= rtw88xxa_phy_cck_pd_set,
> +	.cck_pd_set		= rtw_phy_cck_pd_set,
>  	.pwr_track		= rtw8821a_pwr_track,
>  	.config_bfee		= NULL,
>  	.set_gid_table		= NULL,
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> index 2eaadcfec4cb..c95405eacfa3 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> @@ -520,29 +520,6 @@ static void rtw88xxa_init_wmac_setting(struct rtw_dev *rtwdev)
>  	rtw_write32(rtwdev, REG_MAR + 4, 0xffffffff);
>  }
>  
> -static void rtw88xxa_init_adaptive_ctrl(struct rtw_dev *rtwdev)
> -{
> -	rtw_write32_mask(rtwdev, REG_RRSR, 0xfffff, 0xffff1);
> -	rtw_write16(rtwdev, REG_RETRY_LIMIT, 0x3030);
> -}
> -
> -static void rtw88xxa_init_edca(struct rtw_dev *rtwdev)
> -{
> -	rtw_write16(rtwdev, REG_SPEC_SIFS, 0x100a);
> -	rtw_write16(rtwdev, REG_MAC_SPEC_SIFS, 0x100a);
> -
> -	rtw_write16(rtwdev, REG_SIFS, 0x100a);
> -	rtw_write16(rtwdev, REG_SIFS + 2, 0x100a);
> -
> -	rtw_write32(rtwdev, REG_EDCA_BE_PARAM, 0x005EA42B);
> -	rtw_write32(rtwdev, REG_EDCA_BK_PARAM, 0x0000A44F);
> -	rtw_write32(rtwdev, REG_EDCA_VI_PARAM, 0x005EA324);
> -	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, 0x002FA226);
> -
> -	rtw_write8(rtwdev, REG_USTIME_TSF, 0x50);
> -	rtw_write8(rtwdev, REG_USTIME_EDCA, 0x50);
> -}
> -
>  static void rtw88xxau_tx_aggregation(struct rtw_dev *rtwdev)
>  {
>  	const struct rtw_chip_info *chip = rtwdev->chip;
> @@ -1103,8 +1080,8 @@ int rtw88xxa_power_on(struct rtw_dev *rtwdev)
>  	rtw_write32_mask(rtwdev, REG_CR, 0x30000, 0x2);
>  
>  	rtw88xxa_init_wmac_setting(rtwdev);
> -	rtw88xxa_init_adaptive_ctrl(rtwdev);
> -	rtw88xxa_init_edca(rtwdev);
> +	rtw_mac_init_adaptive_ctrl(rtwdev);
> +	rtw_mac_init_edca(rtwdev);
>  
>  	rtw_write8_set(rtwdev, REG_FWHW_TXQ_CTRL, BIT(7));
>  	rtw_write8(rtwdev, REG_ACKTO, 0x80);
> @@ -1947,44 +1924,6 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
>  }
>  EXPORT_SYMBOL(rtw88xxa_phy_pwrtrack);
>  
> -void rtw88xxa_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
> -{
> -	static const u8 pd[CCK_PD_LV_MAX] = {0x40, 0x83, 0xcd, 0xdd, 0xed};
> -	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> -
> -	/* Override rtw_phy_cck_pd_lv_link(). It implements something
> -	 * like type 2/3/4. We need type 1 here.
> -	 */
> -	if (rtw_is_assoc(rtwdev)) {
> -		if (dm_info->min_rssi > 60) {
> -			new_lvl = CCK_PD_LV3;
> -		} else if (dm_info->min_rssi > 35) {
> -			new_lvl = CCK_PD_LV2;
> -		} else if (dm_info->min_rssi > 20) {
> -			if (dm_info->cck_fa_avg > 500)
> -				new_lvl = CCK_PD_LV2;
> -			else if (dm_info->cck_fa_avg < 250)
> -				new_lvl = CCK_PD_LV1;
> -			else
> -				return;
> -		} else {
> -			new_lvl = CCK_PD_LV1;
> -		}
> -	}
> -
> -	rtw_dbg(rtwdev, RTW_DBG_PHY, "lv: (%d) -> (%d)\n",
> -		dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A], new_lvl);
> -
> -	if (dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] == new_lvl)
> -		return;
> -
> -	dm_info->cck_fa_avg = CCK_FA_AVG_RESET;
> -	dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] = new_lvl;
> -
> -	rtw_write8(rtwdev, REG_CCK_PD_TH, pd[new_lvl]);
> -}
> -EXPORT_SYMBOL(rtw88xxa_phy_cck_pd_set);
> -
>  MODULE_AUTHOR("Realtek Corporation");
>  MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
>  MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> index 09a45c1a4129..d9c8db58909c 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> @@ -170,6 +170,5 @@ bool rtw88xxa_iqk_finish(int average, int threshold,
>  void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
>  			   void (*do_lck)(struct rtw_dev *rtwdev),
>  			   void (*do_iqk)(struct rtw_dev *rtwdev));
> -void rtw88xxa_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl);
>  
>  #endif

