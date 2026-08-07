Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAAA35E925
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 01:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786067266; cv=none; b=UfcKCiD+uR0yqkpH5bBE5kdJ7c9YkAtxTlq465XWVGmvFk0ujBVGEaQVdrPIiWEACa4m8Pg8nGjgNZQk2M+yoFLLPcixw3677wzynBy6N6ezKm/mau+18j3oZVQQvKTw9XDzM+SsueCP7408GNRkImKQ+hF8/RfRHKUF25F4WCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786067266; c=relaxed/simple;
	bh=klrxJKPs/SxSqdEiDtHEjI9ihnBPB3tTRXMGfG6Qms4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bxjjw+/XlIoLfDA3WlbZ+10mUEbCRwBxZzRUHTsd/rQOG9ANCqFhnGwbeIjUtwEX/wWyOrdH9ucjDspVmP8m1MVQFXyh8ccOXzf/+i1AZJmug6gQrqVLffHfUYvP67z5S2Q6wYyT8NYhj7yjxm/q8M6OEH8fp1R4f2megpXdyhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DdEyf+vu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L/yhpDL8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DdEyf+vu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L/yhpDL8"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770GoGI2803111
	for <linux-wireless@vger.kernel.org>; Fri, 7 Aug 2026 01:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T4yQd5VpQTZvFK02L358x4zxAu2+dKl10X0+R1gySgk=; b=DdEyf+vuBXbVuEks
	WrN++mMFH9m43FY2Z9c0V6+32xm0btAXC52gubLs9vjgRg4Ww4mO4k4TDYjQio5o
	pNmLLBlaF0rPnGGzYE9WXuds/rJNplbbvPrSumiUY52QqK1m+HeHCdIxt3Bq26HJ
	ZBS/R5ksobke/eHArFA6doyyDuV4mEgdWTLagqp1vZjGN5ZJXpAYgf58xP7WoR77
	rQWLinK6UJ7QZvIaOffLWHgATROVpGHXs4peIgw1Z1lrWG8DBXBhzWXPlgZ69mal
	x7PSp2PRHCQzEDuZih0e5LX6y+XQZBJJTW60TgbS0rVbo0AWw3RwT/vFmX5kdsMC
	AAqVeA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6hsm4t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 01:47:41 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dbf293831so5773402a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 18:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786067261; x=1786672061; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T4yQd5VpQTZvFK02L358x4zxAu2+dKl10X0+R1gySgk=;
        b=L/yhpDL87CaiFLBzZ7MXHvJLsPmKpLwLcRm0s9P8KxiyLcjsIsj3kwP+QMhEM9Wz4w
         Dj4yn9OtgvAqBCq2EOJ3YM5OcSNSL4sPJLEeWbD7YP2PR7aFAz3k9fe4+aA+jM2eTwRh
         /AFrkKRkUUWBuGBXtS76NYRX9uWe0pPlHTfW9oHArVbJ/MK5FpTOdowR+D5YMg+8s+58
         GV/OofjRwoxWhCvdzZOUpIlWtgY+xBWsWYkmVxYfB6YiLJn47JcWnuRGWblG1N4E+O59
         gDRnooRnoHl3vtmNcvn60HgTRZk92qB6U9q2Hx02A7RN1T49w7rVkx+3SOE3t2eZFh7s
         lJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786067261; x=1786672061;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T4yQd5VpQTZvFK02L358x4zxAu2+dKl10X0+R1gySgk=;
        b=rLNDaxu7Bgovy/xxGiCDQnqEySiNcdpYxH/o5ya9fQNxaKy1+cso0JBQqqnKWIE3Bh
         WV8wPXynOCjW6vbHz2XztVny2QNsviDdPbS0Zd1Np876FLBaG3Xv0cJa2ZRyY4friv3h
         rfkN+H1T4swGy6gwX9HyMyjHQ+YNVqLax1jc5cKIR1+EZ961Fv8OrFtkVzLAtpN9pk/W
         Px0dWFTkF+BgFlnSiyWb/ruvOSyNFqecWv+j2hIY8S0zwfJTS8B2EeSAmudZKP79Gkv/
         7mk+r/EthnCqmewz7iy5He0GIuSkwzakTFGkGxbtD4SenDHV7NwdsDUGVZsFHpwzVlu4
         lq3Q==
X-Forwarded-Encrypted: i=1; AHgh+RpVFmBp2X8VG1WVLf2FYuM10eVG6/knUsZyfeG3Lmh/bYNvtgMoinweW3kKuGCE6n3iCmwTuVebNBfBCbgItQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWM0/DoGP4lj/nV4jekwheG93na0dPxv0v8Zdaz8lr0bed0DF4
	Hwe5L133HzYH6uIvL+g/5NZ9VTpQpPdtd2qaIK4UEL1YU2QQcwhb6zR6jajysFLW2yIkcmPGplp
	aqtp8oUXtKdG5af3TNkx4+9oa+ReUimZR1K78YSRIrudKv4hyg/mvQRbEhfhDg8ov2zEAcA==
X-Gm-Gg: AR+sD11RvEbVX58myJTQrB17kdVkTDDokzmfQCcwQOMtTNtIanh6RU9ebtBDCB+15Ek
	S9epvRQeTuMTL73QaqQlOj/Uf5tZJtFb3ctjj4u34k8Xr7ZETCre/+eQ7m2lcGA5uu/LLd68xB5
	oyJs7fHHJrD28aeAKqr+2jRJeSA8wThfM9HtF45w5vuoBCub8/sKbEJLGn0SXFMe3wF2jHomIWD
	ASPQmUZwEyKQTHK7vYLkRCFL5AJ34At5PsuofgyxrHwZCpUq8duEr4i/cH1rFa9BAuzcrvoe4z7
	9UkEFrrc8gWFaPMCZqnT53YCNH1+W8d1cc7IlKp6hShSiFN8vhgDiDH7F5DzDLE6kSMgkv3ZuvX
	xrznZBrarz5rJWpUHZbMqXWyaqZehjwQdiIrvysC47vXXieG7NKbK/06+89CI
X-Received: by 2002:a17:90b:134f:b0:38e:488f:7068 with SMTP id 98e67ed59e1d1-39261f729d5mr365772a91.2.1786067260879;
        Thu, 06 Aug 2026 18:47:40 -0700 (PDT)
X-Received: by 2002:a17:90b:134f:b0:38e:488f:7068 with SMTP id 98e67ed59e1d1-39261f729d5mr365726a91.2.1786067260421;
        Thu, 06 Aug 2026 18:47:40 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec5aac2sm1064869eec.30.2026.08.06.18.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 18:47:39 -0700 (PDT)
Message-ID: <6a9196e8-2e2f-43f8-9665-6ebb82b95951@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 18:47:38 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: fix channel list double-free on error paths
To: Linkai Gong <gonglinkai@kylinos.cn>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: goXsB2JgDiXqH1VR-flVRzUjcnR4crFX
X-Proofpoint-ORIG-GUID: goXsB2JgDiXqH1VR-flVRzUjcnR4crFX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDAxMCBTYWx0ZWRfX/QaX1bKhpQjg
 M1Q7BxwIyElqwCs4uVr9YOhJarc0sajXmj4nyVwQFzDlcIkokG3VIkFgpfr0TsDiLxw5jOuYfni
 bH8p/N9G9XBEw3WwO/iuZ+ZTiPt/P8Hh6RVVqGEjGRIKZ/Th7uZRh9Q/lDHA4d0+fXUeDCfi/dt
 OezVzI40fqlCgnHyzKXAq/zWH3tyeDxFs4jjbdkaya/mgKCcNucR9yZ5AxQhULIjJ9kJDskAsa8
 sgE9+aHGgKSY2Gz8DvaB9icYDxscAP08rHVVNOQxagl+3t8Ijl1k8IS39jesPdNUuFtbh7BW/2U
 scEkKkHZlhMQjqE0kN77mgvUItnJSaKyknXSlOdbaDtU3BuqoY0uyH/sunP6qO0LUveddSvThzj
 72L3A4/LaIUkMc6LRYB06ryJd8PwuOYIaYPv8NbJeHp/Rpe/nFD3Z5D9wuByyjcY6lsS71w3IWz
 YpwkalHFQViTs4fVN1w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDAxMCBTYWx0ZWRfX63uWUrIqwOoc
 rn2JHHSzU+kj7HF3ulyiJy2l2CU/sRBz3XgcA3dDSg8jq7JiZ80iKg81ypoPJTc7HKLcid2cIA7
 008nSPT1vKS5lAVVSOSDSdVYV0tEd3U=
X-Authority-Analysis: v=2.4 cv=bot8wkai c=1 sm=1 tr=0 ts=6a75393d cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=2tX9H4ud-KebakibVqoA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070010

On 7/31/2026 2:38 AM, Linkai Gong wrote:
> ath12k_mac_setup_channels_rates() frees band channel arrays on failure
> but either leaves the pointers non-NULL or clears the wrong band. Later
> ath12k_mac_cleanup_unregister() frees the same pointers again.
> 
> Clear the correct sbands[].channels pointers after kfree(), including
> a copy-paste bug that nulled 2 GHz after freeing 6 GHz channels.

https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/submittingpatches.html#tested-on-tag
Tested-on: tag missing. How was this tested?

> 
> Fixes: acc152f9be20 ("wifi: ath12k: combine channel list for split-phy devices in single-wiphy")
> Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index a0928890671a..5468a8d2d5d5 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14275,6 +14275,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>  					   sizeof(ath12k_6ghz_channels), GFP_KERNEL);
>  			if (!channels) {
>  				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>  				return -ENOMEM;
>  			}
>  
> @@ -14325,7 +14326,9 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>  					   GFP_KERNEL);
>  			if (!channels) {
>  				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>  				kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>  				return -ENOMEM;
>  			}
>  
> @@ -14365,7 +14368,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>  					kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>  					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>  					kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> -					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
> +					ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>  					kfree(channels);
>  					band->channels = NULL;
>  					return ret;

