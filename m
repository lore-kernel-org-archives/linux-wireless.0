Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A58939A4AA
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784931044; cv=none; b=iuyndDiNPnkHV/nYNCKbvqnGzcmkAM9EFxjSdmQ5RpXWMINcCXBixdzEEhzXAAp36DkcdvHYFyo2b539DnDyghC/hpkZM5xvtxn37wpwH1jW9l5a3jeNv+RsVuNLVCSSl17iUpm1Q7fu09al4aI0LiIv0L6ZXSB75crynqRpn94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784931044; c=relaxed/simple;
	bh=ohOFeJY9h8tDcp37kno3adSeq/OhevTE33FpGFOFAyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KTbPNiDPyjYdGo+EBb1mhaoVjk615utsll0bOXEAiHijHcL5fPqOmA9UIab9DIcE/uruqGJy4t5azcpQBIbkRkL24olVLoyMD1Zp5MoO31TlgJOH+PlCjNl7YLsLkWEpUWOb5jaCDtO2e42az7S7p9eMHCAo+KoeU+j0IKxzpWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+n1X9HC; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+n1X9HC"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso615093f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784931036; x=1785535836; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yqs4jWXpQot2YwX9w73crNB1xIUPmIM/U3nv5DCazug=;
        b=C+n1X9HColJEuDWeuhjjmkMtj5DqBilLJ17qP40+5Ug5Mpnw/CAqfuXJLJq1v/Ef2k
         KFVe2Az5SM2lzCoxXq+fmxvpAx57ny6d9FAt2A1kHHn23h5ZOA78s6GFTiOzXnMR+r79
         OaRu49TZ2CjBnZZXXEYAPM8ZwZKFEbQAq163WLWTA0pFEHJpgPwRaIX5nh5mMFNOrjZt
         Env5XLBKnE8FDCuwwbhCvIxFhFTSCGay2NLb/5l2foKu6n1/JazPyDFjA6YaZqHaugtH
         MwDfQcl87g1Y7us3ZcIFF7lMM5SRj0JXkJT/dMGoFGuIu2Yxr/0NQb+6/6hMMdB8Lt2C
         4OoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784931036; x=1785535836;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yqs4jWXpQot2YwX9w73crNB1xIUPmIM/U3nv5DCazug=;
        b=B4dDuItIfwdlrVpnUahGY/+1fZD3cfB22YS1FMXXFxsKByOWfXQ0MBOFxcaRjqno3B
         FR65dFE5n4ZAn7qCYOu+pXus/xvLJdDS0htmE0/M2kErVS530a+qkd8to01F2xPeqYI6
         SCyBSMRNeY2tyBsFctS5GaSX0IGbIJdqG9olPEcZzGTHJ4XPniS3gixZTscrFSaowWLi
         1Fzw5mbup8hGHOcJCdAUVjPzx+YajTgtTHJmJqFxo4ry208slGi2PEebBPzBFuymCQGy
         DA7jpeKvmnEhefg8aeFFJk6kseJ+LJXO3FWX7D2zkUxaCT0PXb3XGalCMSivTn4iGA1e
         fc+w==
X-Gm-Message-State: AOJu0YzFFX3qItBxu1A3mtzv5CGPUDoMjajJb88mKtWIVRH2Zl9yzNNu
	IR1ccR9aT21yeR0tpdeY+okPgiGH4I97F3w5munWF0CiU1M6FZHJuvkA
X-Gm-Gg: AR+sD12nL7GTs3FfH+O8LaiU8ojJJeSXprZlU+tsJ/UdEVL5v+01EBkeuhmQUtBFD+U
	BCHl1mK8h3Qv3JzioIiU4SNXI9tmMLkR/go5wokOKthiZamm0BFC/myZ0dvGpkoGPLXxBLWHRv9
	Dgy4m+QYsItn7E6ipNVvmUgJMMWvSpO5JtMkLkZR2fMVfIA4p08vMSS69LJlhDeuyRAF0nwliN1
	cXUH/Y5YHoNpfbueX3iWCuxZND3uqctBjOH+BCVu/UZlKgY2xvUH56vGo9dFH6d8i7FEMSJpgvt
	DsX6bNzh7sy1NBRJMqMO6dway0zfXEu4JIjzQHB//EOzS4m34rXszwMpXSch64fQHShz9+5JNIs
	z/t7l9BcgFbrGO+e7G7X4SVBx2TJBo7AaCvTilqvf4ex8p9eTBeRuNdC5od9cOmxhQP5exGFCZA
	yGyN6jFuBZ
X-Received: by 2002:a05:600c:c177:b0:495:4056:9473 with SMTP id 5b1f17b1804b1-496b5754455mr1076615e9.28.1784931036095;
        Fri, 24 Jul 2026 15:10:36 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4d8d6efsm18832335e9.0.2026.07.24.15.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 15:10:35 -0700 (PDT)
Message-ID: <fe9a4df1-1ea9-44b6-8f98-10130d37e55c@gmail.com>
Date: Sat, 25 Jul 2026 01:10:32 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/19] wifi: rtw88: match the RTL8723BS firmware connect
 and power save behaviour
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724183314.197195-1-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724183314.197195-1-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:33, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> The vendor firmware expects the connect media status report at
> association completion rather than when the station is added, so defer
> it until the station is actually associated and track whether it was
> sent, so the disconnect report is only sent to undo one that was.

Does the firmware really care? What happens if you don't do all that?

> 
> Leaving LPS also costs enough per-packet latency on this chip to
> throttle bursty traffic badly, and the stock check enters LPS after a
> single quiet two second window that an ordinary session hits
> constantly. Gate LPS on the smoothed throughput for this chip so it
> only sleeps after sustained idle. Other chips keep the existing
> behaviour.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 47 ++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index a2ef4479f408..63d1fb4bc87e 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -304,6 +304,25 @@ static void rtw_sw_beacon_loss_check(struct rtw_dev *rtwdev,
>  /* process TX/RX statistics periodically for hardware,
>   * the information helps hardware to enhance performance
>   */
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
>  static void rtw_watch_dog_work(struct work_struct *work)
>  {
>  	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
> @@ -382,6 +401,17 @@ static void rtw_watch_dog_work(struct work_struct *work)
>  	 * get that vif and check if device is having traffic more than the
>  	 * threshold.
>  	 */
> +	/* On 8723BS SDIO the firmware's per-packet wake latency out of LPS
> +	 * throttles bursty traffic hard. The stock check enters LPS after a
> +	 * single quiet 2s window, which a normal bursty session hits
> +	 * constantly. Gate LPS on the smoothed throughput instead so the chip
> +	 * only sleeps after sustained idle and stays awake through an active
> +	 * session. Other chips keep the normal behaviour.
> +	 */
> +	if (rtw_is_8723bs(rtwdev) &&
> +	    (stats->tx_throughput || stats->rx_throughput))
> +		ps_active = true;
> +
>  	if (rtwdev->ps_enabled && data.rtwvif && !ps_active &&
>  	    !rtwdev->beacon_loss && !rtwdev->ap_active)
>  		rtw_enter_lps(rtwdev, data.rtwvif->port);
> @@ -450,7 +480,13 @@ int rtw_sta_add(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
>  	INIT_WORK(&si->rc_work, rtw_sta_rc_work);
>  
>  	rtw_update_sta_info(rtwdev, si, true);
> -	rtw_fw_media_status_report(rtwdev, si->mac_id, true);
> +	if (rtw8723bs_defer_sta_media_status(rtwdev, sta, vif)) {
> +		rtwvif->fw_media_connected = false;
> +	} else {
> +		rtw_fw_media_status_report(rtwdev, si->mac_id, true);
> +		if (rtw8723bs_station_media_status(rtwdev, sta, vif))
> +			rtwvif->fw_media_connected = true;
> +	}
>  
>  	rtwdev->sta_cnt++;
>  	rtwdev->beacon_loss = false;
> @@ -465,14 +501,21 @@ void rtw_sta_remove(struct rtw_dev *rtwdev, struct ieee80211_sta *sta,
>  {
>  	struct rtw_sta_info *si = (struct rtw_sta_info *)sta->drv_priv;
>  	struct ieee80211_vif *vif = si->vif;
> +	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
>  	int i;
>  
>  	cancel_work_sync(&si->rc_work);
>  
>  	if (vif->type != NL80211_IFTYPE_STATION || sta->tdls)
>  		rtw_release_macid(rtwdev, si->mac_id);
> -	if (fw_exist)
> +	if (fw_exist && rtw8723bs_station_media_status(rtwdev, sta, vif) &&
> +	    !rtwvif->fw_media_connected) {
> +		/* connect status was deferred and never sent; nothing to undo */
> +	} else if (fw_exist) {
>  		rtw_fw_media_status_report(rtwdev, si->mac_id, false);
> +		if (rtw8723bs_station_media_status(rtwdev, sta, vif))
> +			rtwvif->fw_media_connected = false;
> +	}
>  
>  	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
>  		rtw_txq_cleanup(rtwdev, sta->txq[i]);

