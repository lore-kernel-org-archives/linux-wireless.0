Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDAE31619C
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 04:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786940638; cv=none; b=o+VwqveQS8svP7kMJptm97HF9slbzqlFWLED4gbAITvcsFGIwPAkfptbgiVZpAgPcnX5CXUEoaEQxNq7O/WPJKJySD+hgiXPeIs5wrXvxBcnLjmcktvlsZGt8lHNraAKvGRf8pIRH/wOOEq3yNMhDldGgKqBE/tI96/l3RHomh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786940638; c=relaxed/simple;
	bh=iqt5z9vPsZ4P7O3OibwhqnJo2iicrPfALJs8/cgQB4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PwI0vEdg2eOCfmMauQS5fsPbc83jUo16JOGfVlDKqExTXacXaMMtdO4foDnb2X0VMYGdYFwdK7EE0c/jUy96m0iujfUdnTPs7ZGiyaseOs5Cxz1ygKYdawBFPPnkU0YcI2G17oPZRTu2Iq/1+R5NInpJhEEbNwJMWVErwgbCkkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Op+sgt18; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Upi5qPTp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Op+sgt18";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Upi5qPTp"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLCaci161041
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 04:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WYIbWS+0szvbHvH1b9Rs+RyGOF4FPIL5Yrhzv6pLsEI=; b=Op+sgt18SxoJlgUQ
	jIF4dtjcFLc5NwlJUKY/R2ChMCKcrS4epmYaqEvkzdP/HbBGTOe4JFqK4+l5NTP9
	wq7uRpyeoOeDktGnA2rGi5S2o3a68XPIBUWDtqqvGRyvRllInXa9Vqy+cxwzUuoJ
	rpkNIMQq4lJu9Lgzfu8oz+O3vkKTlV1lYX5sHNCQWKmMzb77YkK76OxIYhhDzPX5
	LyOdLkzX2eQlg/4LGIkNjoL+pvfN2b7xdV94ACiK11eLuYcvCTF/SG1fOjI4iL5V
	2ueUPZgR2q6LclWBo1VRbYwKUZdTNa7TLXkbQiFhskcU1uzBHQG6B/iXZ4WSk/mm
	ikDhlQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g2ghk5588-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 04:23:56 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cab048cdb3eso3473464a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 21:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786940635; x=1787545435; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WYIbWS+0szvbHvH1b9Rs+RyGOF4FPIL5Yrhzv6pLsEI=;
        b=Upi5qPTpEXP8vKJCw3zuo8OKcu2VPSUX/QAD7PhVbRn6o3/tPxdak1CDNfth6OmTI6
         8a7FCnY4uBV+wxh9vF4CXFnN/938nIobKl6WQy+tLVa88gU1ILFtuNlmU/zNmfR6GqGn
         Z/V/fFmWtOp5pcESQhc6N6Kfa74GfFD1wwiqA6y0C0j8L629N2gTJ80N/aOCjzsa84u7
         Q4oX3zSjwTjI7WDuHRj+wYHxGW3O8cy3GVCFQWg5GQNUPjUSKcNHPf+UT+0UnXvXPCb0
         7OWxFn1oiflT0PX1uQOP8WUdNLW8CI24VFMLTjW2kjE564OJZVgj9fOaEGdNWLXEkMlH
         bmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786940635; x=1787545435;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WYIbWS+0szvbHvH1b9Rs+RyGOF4FPIL5Yrhzv6pLsEI=;
        b=a7U4OWrTpKr4Pp4MAHJkVd3Pr7BFPWAK6b2dG1/L4S01MR3sP6fpiSBaK2lBmZq35M
         Br8HAZ2y6Vohut0tGinVil2xjBAglJSNcv0+iC6JyXDaF0qxrgPsK/mba8MnI+jlHTrb
         TGuhnsE4U7T904i+wokPTg+9hoU9XiVo1bHAZJBNCnI9vY79ADNc2HPCdYZsbrnqI+Ft
         mCBt05Ix9hb6hUuaSvuWtEn9j1GeGOH+bMNoGdzcLp+w161REP6mnLGgLeSVAXpFMruV
         wctKSliegVfkVSEmFAE3ZFBbajn+LvduqPq37V9SQD5+Re3+M0svysRn+p2rUCxJWhZp
         94Dw==
X-Forwarded-Encrypted: i=1; AHgh+RpC9bai0b6+JqKNNOfBICTR1IM9cPU78EEVLspBpvV1+idCbuauQIPpS8Lo/5y09EtCHh3fDxAt/HU4k5eEDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfPfNKhjpNWk6YE1MkhWhxTVh+yiVNWYH48Z5vZnp9CGvU/QUS
	0x8g7hlBKhWe+lm3zQrBjKDEYKFph5T3H819vtFW8lsG7EdNRcjKirpsPBp1e7LV9vNWXC6cQep
	pkHe/dfU1jUyGrbJUMdlg9U6GsygZ2wtqEkNLtIKUeHlKMoudxtxX0NevXIb0h0AM6KogSQ==
X-Gm-Gg: AR+sD11RaSUsJlHLoILJwS447gwPkLyaTL6q7lbWQBFrCnS3Dh8d+fBHEdBinBnbkAe
	bLE0w0QqlfO/SIRp7eMhzWemftw3EXhfczAa4AhEKYV3ltWT4sUqbGDu6h4jrrLq/vKzQKr77+M
	2PBKRFocy+/18NgnRuBrK1LnVtmAT8beSNKVX+/QPaDbqdcGspnXWlzDRWo8yW5WJ57t7DEzSOZ
	58M5rHm/8Aq+UfbhmIBjC4KWRshOwy9mnfCe55YmFEMv20ahgz75DDbuA4KsNfvxcfe1UCXvuP1
	cQAbrZvZnHhSaF3Tv4jZ4W8qAPXtxk1/0xgvy/BwBo2FfcpYhCWyOElhU1EC0vEOgntN0euHMsJ
	dEzPz1mlZ8oqFzVH31PyzvkAZ4VV6Dnmkk3Uv0vi1
X-Received: by 2002:a05:6a20:4321:b0:3cb:82de:b952 with SMTP id adf61e73a8af0-3cc71a24c51mr23219963637.2.1786940635062;
        Sun, 16 Aug 2026 21:23:55 -0700 (PDT)
X-Received: by 2002:a05:6a20:4321:b0:3cb:82de:b952 with SMTP id adf61e73a8af0-3cc71a24c51mr23219926637.2.1786940634486;
        Sun, 16 Aug 2026 21:23:54 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267be8e272sm1281142eec.17.2026.08.16.21.23.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 21:23:54 -0700 (PDT)
Message-ID: <6559e362-162c-4046-9fb7-947aa8a8a228@oss.qualcomm.com>
Date: Mon, 17 Aug 2026 09:53:49 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: clear dangling channel pointers on error
 paths
To: Linkai Gong <gonglinkai@kylinos.cn>, jjohnson@kernel.org
Cc: vasanthakumar.thiagarajan@oss.qualcomm.com, baochen.qiang@oss.qualcomm.com,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260811020523.387433-1-gonglinkai@kylinos.cn>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260811020523.387433-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDAzMCBTYWx0ZWRfX7XpYHO/7fq+r
 f3BIWchFkD4jV7Z3SQHQkboPT/Py6mRBrcXs6mys9ZsGA0PBJeaTCYTa+diFzjWSc3ORgSu48iR
 u1RVMxFuEc6y8UqAncSUwJ2qd6UzB4M=
X-Proofpoint-GUID: lVtdVcK9mPU2KXSbJ1Us1Yp1CTzbl02S
X-Authority-Analysis: v=2.4 cv=f+14wuyM c=1 sm=1 tr=0 ts=6a828cdc cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=m_MqYSANrp1KMMaA_BEA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDAzMCBTYWx0ZWRfX7fNTqRH1BKxJ
 bc6IVQ3eXsdU5X00p5R+XYeY3KMF45oYPB35oa2DwWiyvV4s2ACBSYgrzIQnY230YYgp2Jns6v8
 zD96fcFQEl7Wz0CevC7Gqqfvg19suQqsQ6d0Dl7j6t8x0Yx4rSMO9IY/ipkbUMIx57t4skTAC8i
 LgkCTcwNv14lF+R9bl/yP0PkEQz+zOOSIC/MHx+nJulV4xT5qcB1/R1WfzLXuCjcHMgR8q72zvF
 n69bNnwiis3AXjeEQCUtyhkF/Dsfo5aUXAv24aO2LvJUCv5yYQOI8j+sqC4OCwSCbd/lOi0A3Ab
 t9390HBEhfB6i+tq3pLoVUmXbqflRundVk+eQoxTvbaUuinh1xO41kcdXiNF6wbG8luiRIzbWra
 Fw2dzR4TErVjkoCiIPgFNs4K0NavqFoYAUEfrtqIpYPazaGh7m2lRV1CEnvOmzPEEjOPTZ8BEJ0
 0tA3M0nQPpQh7he1M2w==
X-Proofpoint-ORIG-GUID: lVtdVcK9mPU2KXSbJ1Us1Yp1CTzbl02S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170030

On 8/11/2026 7:35 AM, Linkai Gong wrote:
> On failure, ath12k_mac_setup_channels_rates() frees band channel
> arrays but leaves the pointers set, or clears the wrong band after a
> copy-paste typo (6 GHz free paired with a 2 GHz NULL). Clear the
> matching sbands[].channels pointer after each kfree().
> 
> Compile tested only.
> 
> Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
> ---
> v2:
> - reword commit message (dangling pointers + typo, not double-free)
> - drop Fixes tag
> - note compile tested only
> 
> v1: https://lore.kernel.org/all/20260731093816.1771338-1-gonglinkai@kylinos.cn/
> 
>   drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index a0928890671a..5468a8d2d5d5 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14275,6 +14275,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>   					   sizeof(ath12k_6ghz_channels), GFP_KERNEL);
>   			if (!channels) {
>   				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>   				return -ENOMEM;
>   			}
>   
> @@ -14325,7 +14326,9 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>   					   GFP_KERNEL);
>   			if (!channels) {
>   				kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>   				kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> +				ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>   				return -ENOMEM;
>   			}
>   
> @@ -14365,7 +14368,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>   					kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>   					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>   					kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> -					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
> +					ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>   					kfree(channels);
>   					band->channels = NULL;
>   					return ret;


Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
