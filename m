Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793727696;
	b=ANtMXYabvCv30nUc8VaQhUVlDXZMXHtghjJWhsn3gspCqhcTFU3MIA+y2yEaUbgEPysv
	 wzUv6OWxGRpNmQygUtrMEHTe251cCX+VTc0kFGJkt7ehoW5K8m1TNCNz5UNIKzvvWw/3A
	 1JAm/uKQVw5GsDcAGGptIJnffW8NWu+/s0WChW72Xd9UvSU3+cgNl3FUjIUjNDdqB+xGI
	 E4Y0TMHD1GzYWkMqf5N4pM/KtHgTC26NBaSe6tRvjpokGn6IUnFkFuB0+dPZddO31Eo/m
	 cOL95FZs9pWQZ2clHB/vaI8Z2cIoW6TksMqivVLroNeBlm24IuUaFAk7olpoBpUVt/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793727696;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=/ibwG7pxQeDLHnh8l8SGVbmksesbbfllVpF+LvlHHkQ=;
	b=Q+qmMtrefO3Obf8MayX2CNDy7nTBxef0ygy+eHqdjs0Zq1aKf92J0GTPioLYFb/6QtOZ
	 Dio0NkH7M/ISGPZAo3aClq2NJKbGV4xY6nuwXul6BDe8dEwCY7mD7qCFONLixbn9Y+prU
	 /10NhN29eL8wkkniopY/ZFDjAFte92gf64rWD4daMrrutjqLg6ECBPn/DIe485oFPX5eS
	 szphHFUkEC+ViZoJmegIzMjP9tnNVNp0GEUxobwkUWo9HaqTh41z4UBtOfPh0Jz7M4002
	 bhIGWH5cfFB97TX4EYyWOEEGPks/VpmQP+oBblPacezGobubLCCHM0aG21H/C/Efn3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yiOGd7ea;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496F606A31B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 17:41:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8496F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yiOGd7ea
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so9883355e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 09:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793727695; x=1794332495; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/ibwG7pxQeDLHnh8l8SGVbmksesbbfllVpF+LvlHHkQ=;
        b=yiOGd7eaS7PEKA7kWxVt/qy/UW1dJxGXFrIW438m4oya1POwDrmNWFFfjVTrLY6Gau
         QU0KfVJLANiREBXumoN/yhGzrFlqZ+ImvDEWy9O0pemiFOA8uJfZ4HFtHs7y6SF26bdF
         KRu+jlED3zLyYUt+EDABwOergKLISBZZbvhos9e9UDKmGoW2qTznxS81yVyI6LkA/rM3
         pYQLH4lWYZyexIdCadTcDszRgGzQEw5xSLo5iZ/SEjZMO0r5jDOZS6CIKcUDXdVfwYTl
         89jJrFxpZdrLQkZahs76xu3Hfw2wcHCsDGr/LVLXYNJT8MozpYS598iyalRHJ+Q+Csz7
         HKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793727695; x=1794332495;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ibwG7pxQeDLHnh8l8SGVbmksesbbfllVpF+LvlHHkQ=;
        b=etTqQjVETDXg6Pf6Pd7SMBfH4fdC2hDT79v84eKS83d3/fYdV5cpRm+HNo23R8Irt4
         +JIsPLhDAcUpkfVucEPHViK6LeOK58d9FT0+uYwN2tmKMcfbUKi0NTPQmJ0xFsffrt0F
         mGPviXbCTGOGX1pbIpj+b5Rp46xrDkHvR6sMNqPzWkCuGPnlg51+/MHIrYW2Or44cw+2
         aFcV3+SUcxuy2LzNF9NNa9BG/ndr0o9cYmXVdMNC20VFwn3FofzXz8FeWntiXabEKf1x
         mkhg/MO8mo+NZ/n+6xWNflgH5aDwRBJ5VpImCyjgCnExAoRSCyy11+YUTor3oCbY8Mk9
         gXwA==
X-Gm-Message-State: APuU4Z9q4D6Ti2latPelqvT1yaHApqJ35Mnusgw9LToDuwqm03GYOuvZ
	UhGym/a6+qXBJ2MQnVewLuivYyjxZk/CEjd7hFtGUHarDn8gkFRSe+hH+WUIpJri
X-Gm-Gg: AYBFou3NHA/4GrPjkxKgGBRf6THSBucWwq4gKee6Bd47EOaYDs+IkXKlzu3fWqbjuWV
	/oN5yPB9AJ90MyJxSqPu6uMMNO2IFTRRJQ0zZ+nqO9nDVRA83Og3A/ExvtseWHgpDIflpNXNQMk
	10GR55cjWV6+y5A5xT08ixWKKauv4gIz2DmYztA/Yb0RBK+lRhCq9a3DsnjRKUYn7blWk9/5A4E
	14n6R6EIAkww03OWJuuk/Nxes4mZuw+QP9WEQFgXDK/MDqCqdO4LHTgeOmeLY6DsfChaJwrzMEG
	IdjT4XubJ6u8IQxgn4dtNsqjPQ5fApym0VUnzfi0Snl+K2A+Ax1DnyKGVdaluqyCfpzDP3o31u9
	w2c3f2p6KKhEoKBtWLhvuRb/Xnv0sqGhKjGFoqmMOitkeHfHxS3NINObrxTaKvXSrplzmrJKTEs
	15x6pS9nyk9yiMXUIgG2zfz98HQJoZ2wOGg7POhCQq/fQFowz9IW68i1lrLgEEM6Y+9fO1XX2qQ
	cSXi7aZi+/aMeHIgoeCOA3sUftChRUfbswQro+J3cLHZj7OdRPM7lSj3lyqe043Q3xbwE2pWR72
	yVWGCQxFDPcfrhAyR6dALuEm/0j090pkalw=
X-Received: by 2002:a05:600c:5246:b0:4a2:1960:6fa with SMTP id 5b1f17b1804b1-4ac16acd947mr328780195e9.4.1793727694870;
        Tue, 03 Nov 2026 09:41:34 -0800 (PST)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab3ea6a9sm109394745e9.15.2026.11.03.09.41.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 09:41:34 -0800 (PST)
Message-ID: <08bfa108-3e8a-40fb-a901-99031b284236@gmail.com>
Date: Tue, 3 Nov 2026 19:41:32 +0200
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
Subject: Re: [PATCH rtw-next v2 6/7] wifi: rtw88: 88xxa: adapt channel sensing
 to receiver gain
To: linux-wireless@vger.kernel.org
References: <20261031070950.425176-1-hjf3108@gmail.com>
 <20261031070950.425176-7-hjf3108@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261031070950.425176-7-hjf3108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 31/10/2026 09:09, Ho Jie Feng wrote:
> Implement adaptivity for 88xxa, since they support it in
> the hardware.
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>

This version doesn't have the high latency during scans anymore.
However, the message "firmware failed to leave lps state" appears
a lot more often now. It stops if I disable EDCCA.

> ---
>  drivers/net/wireless/realtek/rtw88/main.h     |   1 +
>  drivers/net/wireless/realtek/rtw88/phy.c      |   7 +
>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  10 ++
>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  10 ++
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 125 ++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |   5 +
>  6 files changed, 158 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index d59f6e323adf0c9bf9aeab7a62adb77e3e5f9d74..796fea308fdf7bf2b46f42c703b1b518327e1e0a 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -1787,6 +1787,7 @@ struct rtw_dm_info {
>  	bool is_bt_iqk_timeout;
>  
>  	s8 l2h_th_ini;
> +	s8 l2h_th_lb;
>  	enum rtw_edcca_mode edcca_mode;
>  	u8 scan_density;
>  };
> diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
> index 69998c0d7c1f851bb30d2702233d62e14b305bf0..7a04aec9a045f1e308a4c5d331c900e013996bd5 100644
> --- a/drivers/net/wireless/realtek/rtw88/phy.c
> +++ b/drivers/net/wireless/realtek/rtw88/phy.c
> @@ -377,6 +377,10 @@ void rtw_phy_dig_set_max_coverage(struct rtw_dev *rtwdev)
>  		DIG_CVRG_MIN);
>  
>  	rtw_phy_dig_write(rtwdev, DIG_CVRG_MIN);
> +
> +	/* EDCCA thresholds can be relative to the IGI */
> +	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_ADAPTIVITY))
> +		rtw_phy_adaptivity(rtwdev);
>  }
>  
>  void rtw_phy_dig_reset(struct rtw_dev *rtwdev)
> @@ -388,6 +392,9 @@ void rtw_phy_dig_reset(struct rtw_dev *rtwdev)
>  	rtw_dbg(rtwdev, RTW_DBG_PHY, "Resetting IGI=%#x\n", last_igi);
>  
>  	rtw_phy_dig_write(rtwdev, last_igi);
> +
> +	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_ADAPTIVITY))
> +		rtw_phy_adaptivity(rtwdev);
>  }
>  
>  static bool
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> index c8008cf43da9df68a8c1dfb277d529a1191bda01..d93c4776e0303f52273d92eaa75341ebbcfcb066 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
> @@ -945,6 +945,8 @@ static const struct rtw_chip_ops rtw8812a_ops = {
>  	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
>  	.cfo_init		= rtw_phy_cfo_xcap_init,
>  	.cfo_track		= rtw88xxa_cfo_track,
> +	.adaptivity_init	= rtw88xxa_adaptivity_init,
> +	.adaptivity		= rtw88xxa_adaptivity,
>  };
>  
>  static const struct rtw_page_table page_table_8812a[] = {
> @@ -999,6 +1001,11 @@ static const struct rtw_hw_reg rtw8812a_dig[] = {
>  	[1] = { .addr = REG_RXIGI_B, .mask = 0x7f },
>  };
>  
> +static const struct rtw_hw_reg_offset rtw8812a_edcca_th[] = {
> +	[EDCCA_TH_L2H_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE0}, .offset = 0},
> +	[EDCCA_TH_H2L_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE1}, .offset = 0},
> +};
> +
>  static const struct rtw_rfe_def rtw8812a_rfe_defs[] = {
>  	[0] = { .phy_pg_tbl	= &rtw8812a_bb_pg_tbl,
>  		.txpwr_lmt_tbl	= &rtw8812a_txpwr_lmt_tbl,
> @@ -1089,6 +1096,9 @@ const struct rtw_chip_info rtw8812a_hw_spec = {
>  	.bfer_su_max_num = 2,
>  	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
> +	.edcca_th = rtw8812a_edcca_th,
> +	.l2h_th_ini_cs = 10,
> +	.l2h_th_ini_ad = -17,
>  
>  	.coex_para_ver = 0, /* no coex code in 8812au driver */
>  	.bt_desired_ver = 0,
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> index 17d3677ca463cf633d8c138612deaa676bc02986..f7391f6aa3039c7ba4d88249d968a5f1763ea866 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
> @@ -891,6 +891,8 @@ static const struct rtw_chip_ops rtw8821a_ops = {
>  	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
>  	.cfo_init		= rtw_phy_cfo_xcap_init,
>  	.cfo_track		= rtw88xxa_cfo_track,
> +	.adaptivity_init	= rtw88xxa_adaptivity_init,
> +	.adaptivity		= rtw88xxa_adaptivity,
>  };
>  
>  static const struct rtw_page_table page_table_8821a[] = {
> @@ -944,6 +946,11 @@ static const struct rtw_hw_reg rtw8821a_dig[] = {
>  	[0] = { .addr = REG_RXIGI_A, .mask = 0x7f },
>  };
>  
> +static const struct rtw_hw_reg_offset rtw8821a_edcca_th[] = {
> +	[EDCCA_TH_L2H_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE0}, .offset = 0},
> +	[EDCCA_TH_H2L_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE1}, .offset = 0},
> +};
> +
>  static const struct rtw_rfe_def rtw8821a_rfe_defs[] = {
>  	[0] = { .phy_pg_tbl	= &rtw8821a_bb_pg_tbl,
>  		.txpwr_lmt_tbl	= &rtw8821a_txpwr_lmt_tbl,
> @@ -1193,6 +1200,9 @@ const struct rtw_chip_info rtw8821a_hw_spec = {
>  	.bfer_su_max_num = 2,
>  	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
>  	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
> +	.edcca_th = rtw8821a_edcca_th,
> +	.l2h_th_ini_cs = 10,
> +	.l2h_th_ini_ad = -17,
>  
>  	.coex_para_ver = 20190509, /* glcoex_ver_date_8821a_1ant */
>  	.bt_desired_ver = 0x62, /* But for 2 ant it's 0x5c */
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> index 851d198f76f3b10d5ba77c7e07e4be9d7fd54e4b..ee72380757721dab7dc409aabc24b2b825969465 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
> @@ -2040,6 +2040,131 @@ void rtw88xxa_cfo_track(struct rtw_dev *rtwdev)
>  }
>  EXPORT_SYMBOL(rtw88xxa_cfo_track);
>  
> +#define EDCCA_TH_MAX_88XXA		0x7f
> +#define EDCCA_L2H_CAP_88XXA		10
> +#define EDCCA_L2H_INI_NORMAL_88XXA	20
> +#define EDCCA_DBG_PORT_88XXA		0x209
> +#define EDCCA_DC_BACKOFF_88XXA		2
> +#define EDCCA_LB_START_88XXA		(EDCCA_L2H_H2L_DIFF - 30)
> +#define EDCCA_LB_RETRY_88XXA		(EDCCA_LB_START_88XXA + 18)
> +
> +static void rtw88xxa_set_rf_mode_rx(struct rtw_dev *rtwdev, u32 data0,
> +				    u32 data1)
> +{
> +	u8 path;
> +
> +	for (path = RF_PATH_A; path < rtwdev->hal.rf_path_num; path++) {
> +		rtw_write_rf(rtwdev, path, RF_LUTWE, BIT(19), 1);
> +		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_ADDR, RFREG_MASK,
> +			     0x18000);
> +		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_DATA0, RFREG_MASK,
> +			     data0);
> +		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_DATA1, RFREG_MASK,
> +			     data1);
> +		rtw_write_rf(rtwdev, path, RF_LUTWE, BIT(19), 0);
> +	}
> +}
> +
> +static void rtw88xxa_set_lna(struct rtw_dev *rtwdev, bool enable)
> +{
> +	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A)
> +		rtw88xxa_set_rf_mode_rx(rtwdev, 0x3f7ff,
> +					enable ? 0xc26bf : 0xc22bf);
> +	else
> +		rtw88xxa_set_rf_mode_rx(rtwdev, 0x0002f,
> +					enable ? 0xfb0bb : 0xfb09b);
> +}
> +
> +static u8 rtw88xxa_edcca_count(struct rtw_dev *rtwdev)
> +{
> +	u8 cnt = 0;
> +	int i;
> +
> +	rtw_write32(rtwdev, REG_DBGSEL, 0);
> +	for (i = 0; i < 3 &&
> +	     rtw_read32(rtwdev, REG_DBGRPT) & BIT_DBG_CCA_BUSY; i++)
> +		usleep_range(3000, 3500);
> +
> +	rtw_write32(rtwdev, REG_DBGSEL, EDCCA_DBG_PORT_88XXA);
> +	for (i = 0; i < 20; i++)
> +		if (rtw_read32(rtwdev, REG_DBGRPT) & BIT_DBG_EDCCA_BUSY)
> +			cnt++;
> +
> +	return cnt;
> +}
> +
> +static s8 rtw88xxa_edcca_search_floor(struct rtw_dev *rtwdev)
> +{
> +	s8 l2h = EDCCA_LB_START_88XXA;
> +
> +	rtw_phy_set_edcca_th(rtwdev, l2h, l2h - EDCCA_L2H_H2L_DIFF);
> +	msleep(30);
> +
> +	while (l2h < EDCCA_L2H_CAP_88XXA && rtw88xxa_edcca_count(rtwdev) > 1) {
> +		l2h++;
> +		rtw_phy_set_edcca_th(rtwdev, l2h, l2h - EDCCA_L2H_H2L_DIFF);
> +	}
> +
> +	return l2h;
> +}
> +
> +void rtw88xxa_adaptivity_init(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> +	u32 dbgsel = rtw_read32(rtwdev, REG_DBGSEL);
> +	s8 l2h;
> +
> +	rtw_write32_clr(rtwdev, REG_TX_PTCL_CTRL, BIT_DIS_EDCCA);
> +
> +	rtw88xxa_set_lna(rtwdev, false);
> +	l2h = rtw88xxa_edcca_search_floor(rtwdev);
> +	if (l2h >= EDCCA_LB_RETRY_88XXA)
> +		l2h = rtw88xxa_edcca_search_floor(rtwdev);
> +	rtw88xxa_set_lna(rtwdev, true);
> +	rtw_write32(rtwdev, REG_DBGSEL, dbgsel);
> +
> +	dm_info->l2h_th_lb = l2h + EDCCA_DC_BACKOFF_88XXA;
> +	rtw_phy_set_edcca_th(rtwdev, EDCCA_TH_MAX_88XXA, EDCCA_TH_MAX_88XXA);
> +
> +	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY, "EDCCA L2H floor %d\n",
> +		dm_info->l2h_th_lb);
> +}
> +EXPORT_SYMBOL(rtw88xxa_adaptivity_init);
> +
> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> +	/* igi_history[0] keeps the pre-scan IGI while scanning */
> +	u8 igi = rtw_read32_mask(rtwdev, REG_RXIGI_A, 0x7f);
> +	int igi_diff = EDCCA_IGI_BASE - igi;
> +	s8 l2h_lb = dm_info->l2h_th_lb;
> +	s8 l2h, h2l;
> +
> +	/* toggle the ADC mask to work around an EDCCA hang */
> +	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A) {
> +		rtw_write32_set(rtwdev, REG_FPGA0_RFMOD, BIT(10));
> +		rtw_write32_clr(rtwdev, REG_FPGA0_RFMOD, BIT(10));
> +	}
> +
> +	if (dm_info->edcca_mode == RTW_EDCCA_ADAPTIVITY) {
> +		l2h = min(dm_info->l2h_th_ini + igi_diff, EDCCA_L2H_CAP_88XXA);
> +		h2l = l2h - EDCCA_L2H_H2L_DIFF;
> +	} else {
> +		l2h = EDCCA_L2H_INI_NORMAL_88XXA + igi_diff;
> +		h2l = l2h - EDCCA_L2H_H2L_DIFF_NORMAL;
> +	}
> +
> +	l2h = max(l2h, l2h_lb);
> +	h2l = max_t(s8, h2l, l2h_lb - EDCCA_L2H_H2L_DIFF);
> +
> +	rtw_phy_set_edcca_th(rtwdev, l2h, h2l);
> +
> +	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY,
> +		"EDCCA mode %d, IGI 0x%x, L2H %d, H2L %d\n",
> +		dm_info->edcca_mode, igi, l2h, h2l);
> +}
> +EXPORT_SYMBOL(rtw88xxa_adaptivity);
> +
>  MODULE_AUTHOR("Realtek Corporation");
>  MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
>  MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> index 09b72d33f62e1e99a2ac5af23ac1630dabb38ef9..b8719c278df7326842e09509fc52d12f226fd417 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> +++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
> @@ -139,6 +139,9 @@ struct rtw_jaguar_phy_status_rpt {
>  
>  #define RF18_BW_MASK		(BIT(11) | BIT(10))
>  
> +#define BIT_DBG_CCA_BUSY	BIT(3)
> +#define BIT_DBG_EDCCA_BUSY	BIT(29)
> +
>  void rtw88xxa_efuse_grant(struct rtw_dev *rtwdev, bool on);
>  int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map);
>  void rtw88xxa_power_off(struct rtw_dev *rtwdev,
> @@ -173,5 +176,7 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
>  void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
>  			     struct rtw_bfee *bfee, bool enable);
>  void rtw88xxa_cfo_track(struct rtw_dev *rtwdev);
> +void rtw88xxa_adaptivity_init(struct rtw_dev *rtwdev);
> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev);
>  
>  #endif

