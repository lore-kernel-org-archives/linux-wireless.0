Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5094D6C55
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 12:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791549670; cv=none; b=ROWfBOu5oiSZQVAxsIxxii4wrPhzLrzQ/ZMXkyYuZoz/DC3CwpSNLxiuLtxT9lH8Ndj1v0aUMfAOQMwFHDVJo3AkhlM8ktoYACrNhUuLOpSFGMJnDc45tTHjKfGVOHVwRJQ8D2cCTEUAtCJCX0dTxtu4Zagu2BOPdIsBpe2WMvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791549670; c=relaxed/simple;
	bh=SrYtqNiBnL/sdf3wDumP9cZU8IbUcKToSztDPNUpXV0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=e+Wr3uJ+GzcpgH/sDbCNJPVgztPPESuTa6Yw0/FcixoNvLVqSgrwJEHEzXu4fsM6/cncI42aRICyDuQW/CA/MG3Y0TG6fQniT7/vYf5CtsCDrNgpCHYmArzHoX6KqZNZg10IObflv+AfEtHUkduFeQ3BzD3dRP0nHtUgyQ3Jxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lU3dWegR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lU3dWegR"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso4799717f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 05:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791549659; x=1792154459; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Ilh0cWGERUMT5Jdo5rmS0OP6WKiInuzzXu6NtogZ9o=;
        b=lU3dWegRnCZUsQLUxSvxjAc9FxyUx3ykJ4+lU77U2s3s790XluPVhf22peCS5fklF5
         FHstQm95+7mpv+USvL/lXFi9ebOmqVkw0d1Nxiv3QGuZE5kPMqSTFScOv7939bwi+AVh
         kuNNuohFzpdTrmKBVe8a1F+T/0JzmjkLg6E+uUWvBzH1ZNQw5dh9zV9zjh6EpdLIk+sg
         7fIyFGhynZHAaN+S5H0pHR1+oqFRCn7xnxeYxv3Jso9tBp2yHFEbXcW6vdF42MrdOCUj
         p///KFKqhuWNEwily7cJMWZ5Z5XU6/Rb+oIIAZVn7dX7DQYPEolJ7tvg3ZrK/Rkfj0T4
         YZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791549659; x=1792154459;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Ilh0cWGERUMT5Jdo5rmS0OP6WKiInuzzXu6NtogZ9o=;
        b=JX7o3VZjZ+2W0pNi+CM0Gsw9adzLu7Le29iBFze3CQrc93MCnbitzjSe9dLieJ8Whw
         R+bF7C/Z634KugU0HJx7ez/6QvL5qI+TrvhGyA8s5BuKUk3MLg0DtiOuY3Qh04tpVq8+
         k2Sg3QEAqLF1lbXhbTLx7b+RpPf63kIiJ4bokY6nAo07+QXeMeVzmCd5tCZXDvOezH0W
         Ts22Tk01rXIiWivZTJfGquhxlWAVY+uheCLLWwSyMIWOokYY4XBvSNSiLIOlA5V32hpB
         2h6pnv8VPlBs3E08YNC/4Lr1boA2KKV4wxEouZDNzOHWBdEKTxqFdZIjJNd6sCQiQJOF
         d/ew==
X-Gm-Message-State: AFuF++nmONHPHNurjDkmeOMLd/4kAFxaAUhSi2v8drxy+iFOMZGxX8sF
	ouFIqCfXlUjLseYicL9Kt0wUCgQOg3zriIJ98K1XWTv6XR+M73p2P75g
X-Gm-Gg: AYBFou01OemhN2U2SN91tBckJ4iyp9IAG7NMqsen4OfSRRMekvxXSyANs4+aTmuvGKu
	u9CRmwCmdVNNT2l1fMsRXMdHkIWzL+MuPSr3k7ByNMzuiUzvLzJ7VpgClPRIxKZ0/kYNuPsetFW
	R0YLQyY/0HAz/011RpkCnhZvlg1zG4b20Aj5tNNatkW+aXREH3mcLNpxeIagWZ/hVu8Cv7QWqXu
	LIHMoJ888XyYfmbQaAFT6mb27BhPAOv9nFGKq/mdkrx99Wu9I4Nvr7uehK5OBmHVmcBD0GL9tCU
	tRSyjAy6goGYCQj1h/I1hGgKxag5SnOFPibNkeEfapbAeKwZSb0baDmIk7n0gvRCkCuXMewuf36
	KOCgaaxbdnNRxL2y2fAEPFmMNpt/aZKoZ+gzT0QPeoQ8fU18ZhlIMFTL8jB98TrMZSCw4GL/EjF
	qy6fDIk+Q2b/qae7MmfldFtlaWcPwPX11ojukTwlD7h0d8ccB0nGBVf7ZJpii/Jzw4ZY9CBGqHL
	e5ONUDgQYW+1NDa
X-Received: by 2002:a05:600c:8509:b0:4a1:7d9b:d4ae with SMTP id 5b1f17b1804b1-4a18e47a8cdmr32518815e9.5.1791549659075;
        Fri, 09 Oct 2026 05:40:59 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bc6a484sm59874925e9.2.2026.10.09.05.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 05:40:58 -0700 (PDT)
Message-ID: <d95aacb8-0032-4d6c-b847-3103afbc3124@gmail.com>
Date: Fri, 9 Oct 2026 15:40:55 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
Content-Language: en-US
In-Reply-To: <20261006130701.120460-6-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/10/2026 16:06, Luka Gejak wrote:
> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
> power sequences, the efuse layout, the RF and IQ calibration, and the
> chip specific coexistence handling.
> 
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> 
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2534 +++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
>  2 files changed, 2548 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> new file mode 100644
> index 000000000000..8bb9c03d769c
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c

[...]

> +static s8 rtw8723b_cck_rx_power(u8 lna_idx, u8 vga_idx)
> +{
> +	s8 rx_power = 0;
> +
> +	switch (lna_idx) {
> +	case 6:
> +		rx_power = -40 - (2 * vga_idx);
> +		break;
> +	case 4:
> +		rx_power = -20 - (2 * vga_idx);
> +		break;
> +	case 1:
> +		rx_power = 0 - (2 * vga_idx);
> +		break;
> +	case 0:
> +		rx_power = 10 - (2 * vga_idx);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return rx_power;
> +}
> +
> +static void rtw8723b_query_phy_status_cck(struct rtw_dev *rtwdev, void *phy_raw,
> +					  struct rtw_rx_pkt_stat *pkt_stat)
> +{
> +	struct phy_status_8723x *phy_status = phy_raw;
> +	u8 lna_idx = u8_get_bits(phy_status->cck_agc_rpt_ofdm_cfosho_a, 0xE0);
> +	u8 vga_idx = u8_get_bits(phy_status->cck_agc_rpt_ofdm_cfosho_a, 0x1F);
> +	s8 rx_power = rtw8723b_cck_rx_power(lna_idx, vga_idx);
> +	s8 min_rx_power = -120;
> +
> +	pkt_stat->bw = RTW_CHANNEL_WIDTH_20;
> +
> +	pkt_stat->rx_power[RF_PATH_A] = rx_power;
> +	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
> +	pkt_stat->signal_power = max(pkt_stat->rx_power[RF_PATH_A],
> +				     min_rx_power);
> +	rtwdev->dm_info.rssi[RF_PATH_A] = pkt_stat->rssi;
> +}
> +
> +static void rtw8723b_query_phy_status_ofdm(struct rtw_dev *rtwdev, void *phy_raw,
> +					   struct rtw_rx_pkt_stat *pkt_stat)
> +{
> +	struct phy_status_8723x *phy_status = phy_raw;
> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> +	s8 val_s8;
> +
> +	/* pkt_stat->bw comes from the RX descriptor, not the PHY status. */
> +
> +	val_s8 = phy_status->path_agc[RF_PATH_A].gain & 0x3F;
> +	pkt_stat->rx_power[RF_PATH_A] = (val_s8 * 2) - 110;
> +
> +	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
> +	pkt_stat->rx_snr[RF_PATH_A] = (s8)(phy_status->path_rxsnr[RF_PATH_A] / 2);
> +
> +	/* signal power reported by HW */
> +	val_s8 = phy_status->cck_sig_qual_ofdm_pwdb_all >> 1;
> +	pkt_stat->signal_power = (val_s8 & 0x7f) - 110;
> +
> +	pkt_stat->rx_evm[RF_PATH_A] = phy_status->stream_rxevm[RF_PATH_A];
> +	pkt_stat->cfo_tail[RF_PATH_A] = phy_status->path_cfotail[RF_PATH_A];
> +
> +	dm_info->curr_rx_rate = pkt_stat->rate;
> +	dm_info->rssi[RF_PATH_A] = pkt_stat->rssi;
> +	dm_info->rx_snr[RF_PATH_A] = pkt_stat->rx_snr[RF_PATH_A] >> 1;
> +	dm_info->cfo_tail[RF_PATH_A] = (pkt_stat->cfo_tail[RF_PATH_A] * 5) >> 1;
> +
> +	val_s8 = (s8)pkt_stat->rx_evm[RF_PATH_A];
> +	val_s8 = clamp_t(s8, -val_s8 >> 1, 0, 64);
> +	val_s8 &= 0x3F; /* 64->0: second path of 1SS rate is 64 */
> +	dm_info->rx_evm_dbm[RF_PATH_A] = val_s8;
> +}
> +
> +static void rtw8723b_query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
> +				      struct rtw_rx_pkt_stat *pkt_stat)
> +{
> +	/*
> +	 * The 8723B PHY status does not report the channel, so we must
> +	 * mark it invalid to allow mac80211/rtw88 to parse it from the IE
> +	 * during scanning.
> +	 */
> +	pkt_stat->channel_invalid = true;

After testing RTL8723BU for a bit, I think this is wrong.

mac80211 thinks there is massive beacon loss when connected to a network
with 40 MHz channel width, but phy_info in debugfs shows that beacons are
being received. The beacons are handed over to mac80211 with a wrong
frequency in struct ieee80211_rx_status. In my case, the correct frequency
is 2472 MHz, but after rtw_update_rx_freq_from_ie() the frequency is set
to 2462 MHz. mac80211 is probably discarding the beacons because of this.
Removing this line fixes the problem.

I think channel_invalid is only for chips which do hardware scan offload
(RTL8822C). With the chips that only do software scanning the driver
should always know what channel it's on and rtw_update_rx_freq_from_ie()
is not needed.

> +
> +	if (pkt_stat->rate <= DESC_RATE11M)
> +		rtw8723b_query_phy_status_cck(rtwdev, phy_status, pkt_stat);
> +	else
> +		rtw8723b_query_phy_status_ofdm(rtwdev, phy_status, pkt_stat);
> +}
