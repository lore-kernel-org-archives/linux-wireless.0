Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DE746EC68
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784932155; cv=none; b=dXCGW225ML5Dds/FzMD/Hw5Q2iZC3PihD+oqXnFPotIncQ64VUdDPZeTqT5iM1W6iEg8jvnzgR7b9J6iiCzstOnSDgFOjsWjv6OZ4LtGCXv0u9t4en1cDwgWXKUa3HzfZ7cGCpQ/ycs0GD+N+F3A/yUNY+gRjA2LfLNjoowfxlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784932155; c=relaxed/simple;
	bh=gXxh3+jWrWr1GT6V9rtVJjSM6LU9GmXwMdM64ZEIrMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VzAnC+Ww0gtHmWJz/cyMlnBdFlshIzz9ymoneprwVyBjvtNuFrSDZsgTpW6cLmoE84Abdqfy5n7pLUHNk9B2CBB4SyZWc66h3OXKhmwqMxbYtiEJbK0MQI9SIw2sHSnNgaBFM69mmuaJJLQlIlkc2CfAjTudinf4kPo8b00QTZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pKGd9Nsd; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKGd9Nsd"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954d29264cso4863955e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784932149; x=1785536949; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n7AxiMwu180qx1wKkVNTB/3I32OKIXq73YUipEU9nTc=;
        b=pKGd9NsdDw6IB5y2eq+KLNyEK5OkOSlZaJqGxVnQPjiEdGBBBKiAy1uP5H5Q4sx87E
         oaahlFMgl0ap1P1fNQT8U0/1iInWGkpDOk7KvrRm7VH5K/vhCJtoLlI4KrVNTiLQCThJ
         ShEySULQiyG6leoLSjfgQZ9MB9xmIGqlsuckIlSnvlYDD//Msvr4x81V5/BmP31ZggFN
         HYZegJRy2b65Oh1SYk4uP54iBQwz7zfmuyJD+iY9y8LYP9d0oxyLFiRdjrtqoh+gByjk
         Bh2WASznof415VXnnHrqu8LHV09RAlQ5pq955qCPxKyYv4it9EZbM7TT9awMRUVcQMo4
         q0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784932149; x=1785536949;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n7AxiMwu180qx1wKkVNTB/3I32OKIXq73YUipEU9nTc=;
        b=PYFh84z+qyDrgvdpVo2IXwvENhiIko127vQKzRCHXUrSXpFl2DkWMkZ5XdzrQmlGas
         ORrrD2QaThB0tdXm+mrFBAqNYzHcj8xuVqcF1Jg1y04DKsrrr5wCNi5qTzYv/nuoZMZw
         DVqeEpMagg3bR3PuB/obkccMAm6p+0No+LJr55M+u7PJzbOonc4Mul++LqNYz/X6X6w1
         BZny3o/WC0ryS6WLObJ7+O7UF9Zwpn3Cc3IjfMnOjrc6xBfiKvigzf39Wm3Z+Y/VP4SO
         NksBvBRtbS8Q8c0WPluCaTFVsfpfjQS/9kEGVfDLmjUpNwjaS6po36DIde5MNOqNZIOO
         z0IQ==
X-Gm-Message-State: AOJu0YxJBAE9ThCTOfj2/nr6OBKGd8+IUfL1h7hIj8LdJmaBbT8OiHsm
	/86boGnPXOj3SdLPWOeZ1HUEkOf6sEHMMGOcPFEY63kkJKoWOQe0hg5Q
X-Gm-Gg: AR+sD12geiaqusOgZrVkdcBJ6NQRoVxVcnNRsXpfEwur+yjWxu0gs+cGuN1dJ2ggIy7
	5EmneF2t8GvVfAkUlq4QxNcFsJ4frBNAyOtKPtLerzLrkesTdzxUJaBzr/dHMFs+d35w3s+D38I
	KPEScmHloNNJ3oR1BJBbyKIcmAT5oCadBbfBnSpDEYeBlUMuxuK6rYJH+HgKW6oSY9Tl8dyQLbM
	BG+PL1yU+IJa0lOR1HDcmNhuoIciSFlsYpl6t7AMyE2tUBuubJHb6uHQ/wNdGQQYjE3D1EkJmfJ
	6GfYobfuGpdIG98PEyycLUdfP6kvsytyUpRCFil+oe/Obbt7XYA8RjqDUJI9yVbhJlGjdmzNDGR
	F3ZP8QS5gO2KsVNf4pzzV7cKGte8Vjki6KN/xORaA+bKJ7JNvW1T+6vl0bWg9ZynaPJDgXPhX58
	ArYLCt9Ryw
X-Received: by 2002:a05:600c:a196:b0:492:45a0:dcef with SMTP id 5b1f17b1804b1-496b56e6f4fmr1130605e9.5.1784932148942;
        Fri, 24 Jul 2026 15:29:08 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957e334f63sm53465745e9.1.2026.07.24.15.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 15:29:08 -0700 (PDT)
Message-ID: <92272d90-a549-437d-886e-308807418485@gmail.com>
Date: Sat, 25 Jul 2026 01:29:05 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/19] wifi: rtw88: advertise the correct receive
 capabilities on RTL8723BS
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183330.197283-1-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724183330.197283-1-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:33, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> This chip has neither a firmware feature report nor an efuse hardware
> capability parser, so the capability struct is left at zero. A zero
> stream count builds an HT capability with no usable RX MCS rates, and
> APs drop the station immediately after an otherwise successful
> association. Fill in the stream and antenna counts from the RF path
> count, and advertise the 20 and 40 MHz support the chip has.
> 
> RTL8723BS also leaves BIT_APP_FCS clear, so received frames do not carry
> the FCS. Advertising RX_INCLUDES_FCS would make mac80211 trim four bytes
> of real frame data and corrupt the trailing element of beacons and probe
> responses, so leave it unset for this chip.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 61 +++++++++++++++--------
>  1 file changed, 40 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 63d1fb4bc87e..e2f0fd367beb 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -126,6 +126,25 @@ static void rtw_power_on_8723bs_sdio_rfk(struct rtw_dev *rtwdev)
>  	rtwdev->initial_rfk_done = true;
>  }
>  
> +static bool rtw8723bs_station_media_status(struct rtw_dev *rtwdev,
> +					   struct ieee80211_sta *sta,
> +					   struct ieee80211_vif *vif)
> +{
> +	return rtw_is_8723bs(rtwdev) &&
> +	       vif->type == NL80211_IFTYPE_STATION && !sta->tdls;
> +}
> +
> +/* 8723BS SDIO: defer the connect MEDIA_STATUS_RPT until the STA is actually
> + * associated (the vendor firmware sends it at assoc completion, not sta-add).
> + */
> +static bool rtw8723bs_defer_sta_media_status(struct rtw_dev *rtwdev,
> +					     struct ieee80211_sta *sta,
> +					     struct ieee80211_vif *vif)
> +{
> +	return rtw8723bs_station_media_status(rtwdev, sta, vif) &&
> +	       !vif->cfg.assoc;
> +}
> +
>  static struct ieee80211_channel rtw_channeltable_2g[] = {
>  	{.center_freq = 2412, .hw_value = 1,},
>  	{.center_freq = 2417, .hw_value = 2,},
> @@ -304,25 +323,6 @@ static void rtw_sw_beacon_loss_check(struct rtw_dev *rtwdev,
>  /* process TX/RX statistics periodically for hardware,
>   * the information helps hardware to enhance performance
>   */
> -static bool rtw8723bs_station_media_status(struct rtw_dev *rtwdev,
> -					   struct ieee80211_sta *sta,
> -					   struct ieee80211_vif *vif)
> -{
> -	return rtw_is_8723bs(rtwdev) &&
> -	       vif->type == NL80211_IFTYPE_STATION && !sta->tdls;
> -}
> -
> -/* 8723BS SDIO: defer the connect MEDIA_STATUS_RPT until the STA is actually
> - * associated (the vendor firmware sends it at assoc completion, not sta-add).
> - */
> -static bool rtw8723bs_defer_sta_media_status(struct rtw_dev *rtwdev,
> -					     struct ieee80211_sta *sta,
> -					     struct ieee80211_vif *vif)
> -{
> -	return rtw8723bs_station_media_status(rtwdev, sta, vif) &&
> -	       !vif->cfg.assoc;
> -}
> -
>  static void rtw_watch_dog_work(struct work_struct *work)
>  {
>  	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
> @@ -401,6 +401,7 @@ static void rtw_watch_dog_work(struct work_struct *work)
>  	 * get that vif and check if device is having traffic more than the
>  	 * threshold.
>  	 */
> +
>  	/* On 8723BS SDIO the firmware's per-packet wake latency out of LPS
>  	 * throttles bursty traffic hard. The stock check enters LPS after a
>  	 * single quiet 2s window, which a normal bursty session hits
> @@ -2122,8 +2123,21 @@ static int rtw_dump_hw_feature(struct rtw_dev *rtwdev)
>  	u8 bw;
>  	int i;
>  
> -	if (!rtwdev->chip->hw_feature_report)
> +	if (!rtwdev->chip->hw_feature_report) {
> +		/* 8723BS has neither a firmware feature report nor an efuse hw_cap
> +		 * parser, so hw_cap is otherwise left at zero. A zero stream count
> +		 * produces an HT capability with no usable RX MCS rates, which makes
> +		 * APs drop the station immediately after a successful association.
> +		 * Other report-less chips fill hw_cap in when parsing the efuse.

You can do that too instead of adding special code here. You can
make your own rtw8723b_read_efuse() which calls rtw8723x_read_efuse()
and also fills hw_cap.

> +		 */
> +		if (rtw_is_8723bs(rtwdev)) {
> +			efuse->hw_cap.nss = rtwdev->hal.rf_path_num ? : 1;
> +			efuse->hw_cap.ant_num = rtwdev->hal.rf_path_num ? : 1;
> +			efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
> +					   BIT(RTW_CHANNEL_WIDTH_40);
> +		}
>  		return 0;
> +	}
>  
>  	id = rtw_read8(rtwdev, REG_C2HEVT);
>  	if (id != C2H_HW_FEATURE_REPORT) {
> @@ -2429,7 +2443,12 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
>  	hw->vif_data_size = sizeof(struct rtw_vif);
>  
>  	ieee80211_hw_set(hw, SIGNAL_DBM);
> -	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
> +	/* RTL8723BS keeps BIT_APP_FCS clear, so received frames do not contain
> +	 * the FCS. Advertising RX_INCLUDES_FCS would make mac80211 trim four
> +	 * bytes of frame data and corrupt the tail IE in beacons/probe responses.
> +	 */

The driver is supposed to set that bit. The default value of
rtwdev->hal.rcr includes it. I think that should work for this
chip too.

> +	if (!rtw_is_8723bs(rtwdev))
> +		ieee80211_hw_set(hw, RX_INCLUDES_FCS);
>  	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
>  	ieee80211_hw_set(hw, MFP_CAPABLE);
>  	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);

