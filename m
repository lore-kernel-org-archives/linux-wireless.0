Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B903C942C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784927120; cv=none; b=cTwC5/s5F1vaOsfFOHB8uXFnKuHDyL94bGDDCR8xXCeS1cU4YUxnRYJ3or+TirhSmhHL+mPi53rxjeCdMvD7FwomtWqRgXjd3h6V3fjePZqSQsWXAQ3sVPmdzHqPjjl6oWF0qYcjVCK8/lqrzd6Si2B2PEDd/oKq57fRVyb2JOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784927120; c=relaxed/simple;
	bh=SQkf/mxZhOS0alFrnOgpTB3W/KaTGsf89zfqpWJIcec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTvcZUC/5HOLoTyHTTliDT+meoryR5tQ9RAeAvETOQCGzWyVhB7mf3+9QQfkTeEBHntQazc6ehLNLPq+C3/rVl07QUSHMci4FCJIElkq4a5YnuWm48UrLnT3HSBQn4n0rjJqsnWyP54NKVHFng9ONfeGakOfmK0dM0wRzl1Zz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJH/OO6q; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJH/OO6q"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954dff6536so6296875e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 14:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784927117; x=1785531917; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wfz436h5kxcLsc7DBI9vyf4gT/x9M5XGdCoMoDAQU50=;
        b=hJH/OO6qF0pAazSQJZ+zHx0Z9/LXMo8rb+rI0st4JC6qaWeWq+C4cOTpGd9FQWZnT/
         OvlnG7e4O6/NVqFellZ5pJ9yWblC/ipWBBMe68hMLJzsIaeFtYnTCLa4TCe10mf8CjJg
         lI3nNKVL+Zx1OE9uDZ5vQhwHD9aZScIDyZOhdomWFu7OMhRqETGKti6UBeRrmyQQii1I
         crIXcmAGpaYgdfMfdsRYiTvF2Qh3p/S1mvaluXxLc5Bky8ug//j2Xx+QoyYS1ygbPzX4
         zACtvYF22kNX1i/Tbf5gqmKdpg++TX8l6KkYaH/EUF3VCIj8avnUGc/AlEH4+6bQyxCk
         mNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784927117; x=1785531917;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wfz436h5kxcLsc7DBI9vyf4gT/x9M5XGdCoMoDAQU50=;
        b=JMG3zaEeE2LFJKb2E01JAgi6+q22biy94SOKSYgzkgguMwPkNRM8ZZyTUHqkAa9XJ9
         BwsSOzyAOwzZTabgpI0RswoWbRxRHpXw/wZudlSgWWhZIZzGzz5XXiSmeR78M3U7hsHv
         NyTtcfPKkJTgcWm2DI8DR2Hpxo1T3+eE1SERO99EWaZ814RDPS+xSjiOJFEjiKsyvu1Q
         AT5vD6XMLHhTDZ/nMKj9CFObB4XjduaNgrc8mSSY1KAJhov7cpz1XzlEpnCz0OYg5wxr
         +EFvBfJgS0quLkfJ2Tc42x7rFCqHeKfvq4Q/Nd84o6t2Pb+0FWJQXqrmDdmQXHaUqMjA
         U4Tg==
X-Gm-Message-State: AOJu0YwPNZ8yF3O+GKTycmYsNWc2a0xSM7UBJb/Mhww+d7O4qpF11UW6
	icxTMjiJyUIWPWoztSnILUFwLhkBaKbGAKmNXWBLMJUN9dq++sYr+geS
X-Gm-Gg: AR+sD10qpWPX1ugHj+7epkKDlT6H+AXXhnrzrH+Tn+Xj2egsHaDWZz/UchmskQKmewT
	hOsWA2P3JzeFltYGEA/q6ab0KLF5ceoZ2rRbQ3EjH2noZ6JrSypbuQpul+Jn/fZwqGybZB0DsI9
	UWCLGzXj/iTOEw+UkMqEksZggYjEKCbsMzgRMIyAG+6H8LO4bMKi1C3bb8lstp9j2Br01epax7n
	lMLp04UMrIUbFVRs2iafIrbePM9EGE4MKpIg9P6ssSFvvV0fmXBngSlUhPjonjeWCaGKm1dlyOA
	HTEghwYO3kVVmEad0G9c6Pb+7dhp6P43MKCQWi+iaECnbbh1prZTH2xY+xzJ/i0rsGFVeBo1Qjs
	7ReBGav+aAsIl51kF2c4t9D+NWutXhFFqBPHYMm08ePa9zVyC3XqTEvg2sxHsy9lT6SRjEneNRM
	4iLEwMWdUhQLehTyJ0Yew=
X-Received: by 2002:a05:600c:3113:b0:496:b39f:1a03 with SMTP id 5b1f17b1804b1-496b56e6dc9mr10445e9.5.1784927116742;
        Fri, 24 Jul 2026 14:05:16 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f30126sm11346895e9.13.2026.07.24.14.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 14:05:16 -0700 (PDT)
Message-ID: <efef00cb-8369-48d5-859f-623663ddac56@gmail.com>
Date: Sat, 25 Jul 2026 00:05:15 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/19] wifi: rtw88: calibrate and tune the PHY for
 RTL8723BS
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183310.197159-1-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724183310.197159-1-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:33, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> Three PHY adjustments this chip needs. The IQK has to run once at the
> first power on and not again when leaving IPS, because repeating it
> disturbs a working link; the vendor driver calibrates only during the
> initial hal_init for the same reason. Loading the parameter tables
> overwrites the per-rate TX AGC values with the by-rate cache, so the
> vendor power-by-rate bytes have to be restored after a channel set. And
> the scan-time initial gain has to be lowered, without which the site
> survey does not reliably hear an AP that the chip associates with fine.

These are three separate things, so they should be three patches.

> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 114 ++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/main.h |   2 +
>  2 files changed, 116 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 16228cae252e..a2ef4479f408 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -43,6 +43,89 @@ MODULE_PARM_DESC(disable_lps_deep, "Set Y to disable Deep PS");
>  MODULE_PARM_DESC(support_bf, "Set Y to enable beamformee support");
>  MODULE_PARM_DESC(debug_mask, "Debugging mask");
>  
> +#define RTW8723BS_REG_BB_SEL_BTG	0x0948
> +#define RTW8723BS_SCAN_IGI		0x1e
> +
> +struct rtw8723bs_txagc_entry {
> +	u8 rate;
> +	u8 pwr_idx;
> +};
> +
> +/* Vendor/staging per-rate TXAGC PG bytes for 8723BS 2.4 GHz. */
> +static const struct rtw8723bs_txagc_entry rtw8723bs_pg_txagc[] = {
> +	{ DESC_RATE1M, 0x38 }, { DESC_RATE2M, 0x36 },
> +	{ DESC_RATE5_5M, 0x34 }, { DESC_RATE11M, 0x32 },
> +	{ DESC_RATE6M, 0x44 }, { DESC_RATE9M, 0x44 },
> +	{ DESC_RATE12M, 0x42 }, { DESC_RATE18M, 0x40 },
> +	{ DESC_RATE24M, 0x38 }, { DESC_RATE36M, 0x36 },
> +	{ DESC_RATE48M, 0x32 }, { DESC_RATE54M, 0x28 },
> +	{ DESC_RATEMCS0, 0x44 }, { DESC_RATEMCS1, 0x42 },
> +	{ DESC_RATEMCS2, 0x40 }, { DESC_RATEMCS3, 0x38 },
> +	{ DESC_RATEMCS4, 0x36 }, { DESC_RATEMCS5, 0x34 },
> +	{ DESC_RATEMCS6, 0x30 }, { DESC_RATEMCS7, 0x26 },
> +};
> +
> +/* Lower the scan-time initial gain so the 8723BS SDIO site-survey hears the AP. */

This behaviour is already implemented for all the chips, although with
even higher gain (0x1c) than what you're setting here (0x1e). See
rtw_phy_dig_set_max_coverage(). Does it not work?

> +static void rtw_scan_set_8723bs_igi(struct rtw_dev *rtwdev)
> +{
> +	if (!rtw_is_8723bs(rtwdev))
> +		return;
> +
> +	rtw_write32_mask(rtwdev, REG_RXIGI_A, MASKBYTE0, RTW8723BS_SCAN_IGI);
> +}
> +
> +/* rtw_load_table() only populates the by-rate cache; restore the staging
> + * 8723BS PG bytes after the generic channel power update and push them to the
> + * chip TXAGC registers.
> + */
> +static void rtw8723bs_reapply_pg_txagc(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_hal *hal = &rtwdev->hal;
> +	u8 path;
> +	int i;
> +
> +	if (!rtw_is_8723bs(rtwdev) || hal->current_band_type != RTW_BAND_2G)

This chip only handles the 2.4 GHz band, so checking the current band
should not be necessary.

> +		return;
> +
> +	mutex_lock(&hal->tx_power_mutex);
> +	for (path = 0; path < hal->rf_path_num && path < RTW_RF_PATH_MAX; path++)
> +		for (i = 0; i < ARRAY_SIZE(rtw8723bs_pg_txagc); i++)
> +			hal->tx_pwr_tbl[path][rtw8723bs_pg_txagc[i].rate] =
> +				rtw8723bs_pg_txagc[i].pwr_idx;
> +	rtwdev->chip->ops->set_tx_power_index(rtwdev);

With this you are always setting the same TX power, hardcoded in
rtw8723bs_pg_txagc. What is the reason for that?

Normally the TX power depends on values burned into the chip's efuse
(so they vary from device to device), and values hardcoded into the
driver are only used if there is nothing in the chip's efuse.

> +	mutex_unlock(&hal->tx_power_mutex);
> +}
> +
> +/* Staging runs PHY_IQCalibrate_8723B() only during initial hal_init, never on
> + * IPS leave. Match that: run IQK once on the first power-on, then on later
> + * (IPS-leave) power-ons just restore the PTA antenna path and reset RF_WLINT.
> + */

In rtw88 the IQ calibration is normally done in the phy_calibration
function (from rtw_chip_ops) which runs right before connecting to a
network, not in the power on code. Wouldn't that be fine for this chip
too?

> +static void rtw_power_on_8723bs_sdio_rfk(struct rtw_dev *rtwdev)
> +{
> +	const struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_efuse *efuse = &rtwdev->efuse;
> +	u32 pta_path;
> +	u32 saved_path;
> +
> +	if (!rtw_is_8723bs(rtwdev) || !chip->ops->phy_calibration)
> +		return;
> +
> +	pta_path = (efuse->bt_setting & BIT(6)) ? 0x80 : 0x200;
> +
> +	if (rtwdev->initial_rfk_done) {
> +		rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, pta_path);
> +		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK, 0x0780);
> +		return;
> +	}
> +
> +	saved_path = rtw_read32(rtwdev, RTW8723BS_REG_BB_SEL_BTG);
> +	rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, pta_path);
> +	chip->ops->phy_calibration(rtwdev);
> +	rtwdev->need_rfk = false;
> +	rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, saved_path);
> +	rtwdev->initial_rfk_done = true;
> +}
> +
>  static struct ieee80211_channel rtw_channeltable_2g[] = {
>  	{.center_freq = 2412, .hw_value = 1,},
>  	{.center_freq = 2417, .hw_value = 2,},
> @@ -904,6 +987,8 @@ void rtw_set_channel(struct rtw_dev *rtwdev)
>  
>  	rtw_phy_set_tx_power_level(rtwdev, center_chan);
>  
> +	rtw8723bs_reapply_pg_txagc(rtwdev);
> +
>  	/* if the channel isn't set for scanning, we will do RF calibration
>  	 * in ieee80211_ops::mgd_prepare_tx(). Performing the calibration
>  	 * during scanning on each channel takes too long.
> @@ -1429,6 +1514,34 @@ int rtw_power_on(struct rtw_dev *rtwdev)
>  	rtw_fw_send_phydm_info(rtwdev);
>  
>  	wifi_only = !rtwdev->efuse.btcoex;
> +
> +	/* 8723BS SDIO: on an IPS-leave power-on (IQK already done once) skip the
> +	 * BT-path coex init entirely - scan_workaround re-establishes the PTA /
> +	 * coex state. Run the once-only IQK via the RFK helper; on the first
> +	 * power-on, finalise coex with the vendor init H2C toggle that enables
> +	 * the 8051 management TX scheduler.
> +	 */
> +	if (rtw_is_8723bs(rtwdev)) {
> +		bool ips_wake = rtwdev->initial_rfk_done;
> +
> +		if (!ips_wake)
> +			rtw_coex_power_on_setting(rtwdev);
> +
> +		rtw_power_on_8723bs_sdio_rfk(rtwdev);
> +
> +		if (!ips_wake) {
> +			rtw_coex_init_hw_config(rtwdev, wifi_only);
> +			rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +			rtw_fw_set_gnt_bt(rtwdev, 1);
> +			rtw_fw_coex_ant_sel_rsv(rtwdev, 0, 0);
> +			rtw_fw_query_bt_info(rtwdev);
> +			rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +			rtw_fw_set_gnt_bt(rtwdev, 0);
> +		}
> +
> +		return 0;
> +	}
> +
>  	rtw_coex_power_on_setting(rtwdev);
>  	rtw_coex_init_hw_config(rtwdev, wifi_only);
>  
> @@ -1485,6 +1598,7 @@ void rtw_core_scan_start(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
>  	set_bit(RTW_FLAG_SCANNING, rtwdev->flags);
>  
>  	rtw_phy_dig_set_max_coverage(rtwdev);
> +	rtw_scan_set_8723bs_igi(rtwdev);
>  }
>  
>  void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index aa09fef8c19f..c6d993e989dd 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -2151,6 +2151,8 @@ struct rtw_dev {
>  	struct rtw_wow_param wow;
>  
>  	bool need_rfk;
> +	/* Run the initial IQK once, not on every IPS leave. */
> +	bool initial_rfk_done;
>  	struct completion fw_scan_density;
>  	bool ap_active;
>  

