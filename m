Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D87397945
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786356895; cv=none; b=phlk8b2B+6DMu6DNVutap/e7cee6HZlwZRqmMU1Obgi9UkegvRdVd8oygg6yz9NoRpk/+QIS/MZePT5ZPNwDtW2Y4HVsSjsk8Mzjxhh7OlQLBye15dGfIeOUp4Qo2PE9Oy+dLCcWtSwNEL6BMfWRxgcEgpLq/g2N4S8O9Q560+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786356895; c=relaxed/simple;
	bh=wlKu7Zdj316j95U1Ln5YkZ//0Gh/A44GvBhrF1dFRiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pR8IdEosGZo8uRd700CjG7owiQa8qfFf4eioaSyaZRRSOsfJ7tm2PXW8H0b11UMaCxcFiaNHrYudXLhbVhHG6SB0ZjZ3xjBuQj7I6o4SUecujghPPNDeGoZVV8EhsIIHmdWZm5PiIXuDulQNjsib9+rXgD+fbetRUQDV89pDLYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RXVe7XjT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PyrQsUKf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RXVe7XjT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PyrQsUKf"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A9S3rP1189561
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+ndecEpN+n0XznSr43JboGJpcwJUV9bTfXnA5oOtPSY=; b=RXVe7XjTUaBgAQHL
	hi/tmi5wGaZsUzEmogZ5aYQzNlRGUz5RYuWydRzJDF7niW1PVB2XXioXy4YhzDsy
	9+cJbvxnnLVm+KoRTA2r2wJwPeJVdesREIIg2OvZJkVWfphJOMT+PPqqRyHJnOC1
	/+HOOHXIvkf+rtZki7PcLbbVAR7ApUFZGf1iPlf2BWTnXDx8dJdaODgYuX6Twmub
	XrF+GMStT8pPke7E/BlqMiOYnA+k0ESGQUhsfNBvk1lTsnpmm9HvZv1VM1me11oN
	Cc2T3Vv+L6ugVLOYhmO1aVfXjG+GH50c7NT4R8iP3GIIdpnW66ESGei7ADcaddVM
	0xFtIA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8v291mb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:14:53 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cec4226c70so35907775ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 03:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786356886; x=1786961686; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ndecEpN+n0XznSr43JboGJpcwJUV9bTfXnA5oOtPSY=;
        b=PyrQsUKf1ADLcs1KYHnUe+xEVVefzJ7zp/7fwNCorM9ftjsALs+wCIR1ubXqc9oo3J
         IWHbAinR+9AGakEnz/fQDxWHVKUkFslLhf+sR48kF93d5AAr5IzQ+G9X95FSs6B5hE7y
         euXSFIkfEtduiCXzvkUJW1DKDL2QcpdB2OzNcVzRl8mNAY91BblfYiHnpjIn4CBQOSR3
         wnz3SAYdKUd/QAfowJ6gPYrt5+MpIaF8YI3x09PBXM38Bx6YbhjLot0L++7coesq9lig
         HKMO8XsGIzJlH3kWUjz6wYmTGc1Y0ofwxTmMbRhyh4yXdnWPWTje9BM6liKVBPld4gO0
         cTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786356886; x=1786961686;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ndecEpN+n0XznSr43JboGJpcwJUV9bTfXnA5oOtPSY=;
        b=Cb17rUHJw87QIka9v67+v+LaVogG36kOZpnmMqUAtbdGplttBNq2wAKwK/fMUOe8JA
         x+fHD9JD7j7Z2bADR41DfasuMe6PSP01AfEjDJ5miXr6xytWGdlDVgfZX8il0OPYKVNk
         pH0gvQ+riVrQ1SZUxhYqwGRWJjvVBRGHSLxo0o+Wkjw4bLGT80uLEPGSvRb93lEutBMw
         TF2nuUoJerIWCbOvBd0HhPYPCmkPn9v83Td3hGlCv/4fKmzAojz+1GMba1y1IlCZX5Mv
         F0iBXLCv5cKaIBq7+I++NGURYxrCLsMomm55ZZf74HgEsaS1pV5WsKvBnZ7wNBf1aCgK
         aiEA==
X-Forwarded-Encrypted: i=1; AHgh+RpMhH3gt1n0H1OwOEnJ8fr3bH5FUR/jqLf+xjmE4j5zZ+w4DnxrY/LOjoXGMdWotftlvn1TGuS+gdzR0Kh5cQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzvI8VY2oRczRqAYscIUhVFgx4J4qixmZG04S0uA/lApXsP/+m
	JgvrMPdM/9lUvD9nJDEP0zu7kGHdzJFCi1KWEjIwU/7OeSwI1lBJVR+JQ+6X7dVpelhViO5ekoY
	KLWWI2aNB+5HWW1D6Qw2ta2MXpfCHfk1gWq/V7mBMWC8Uta2tcl8V049kfU6FLFCpgYyZ4w==
X-Gm-Gg: AR+sD11TNUyJfhOdGhmWxQk+pm3IqcjdH9kgnE+gh/Exaq7Q3GkhBMlMGnHvynQP4UK
	F8dsAVs0uoA9obOXmREwOoNRC0LN1at8w8prZmTM7o4uo1Bol8Wkk/WdGPTxm23DcOOP+QIecib
	PGK+ibO6mA+D4rXPaeb3e5E6ImK3+7wSZtAmRKUyUDZ/FfJNi9NngVVU6GbJl9/MZzOfMP0lYfm
	AfQctfhUAH+arlaAdcxYuw7ZC1OSyoUWF9KHyXeBJ6Dfjt5Oba44IG+98t8nOrUt5vhG8WjeVm2
	SqYZOaeHcnAG2rfKZx34lbwlX8jjPiypOlb4cJmIjuWnB+/EyFnGYi+xuphHg0MBZaOzeZWtT3D
	0gl/E1ixUPfPrgF1FN65SztgW5N+tbeSTd9/5vP89
X-Received: by 2002:a17:902:f60c:b0:2cc:6329:b7ba with SMTP id d9443c01a7336-2d0ca7835a7mr500883675ad.16.1786356886365;
        Mon, 10 Aug 2026 03:14:46 -0700 (PDT)
X-Received: by 2002:a17:902:f60c:b0:2cc:6329:b7ba with SMTP id d9443c01a7336-2d0ca7835a7mr500883095ad.16.1786356885898;
        Mon, 10 Aug 2026 03:14:45 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be8d6074sm44784271eec.12.2026.08.10.03.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 03:14:45 -0700 (PDT)
Message-ID: <59d20ace-66cc-4a0c-a09a-e669becd2657@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 15:44:40 +0530
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
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260731093816.1771338-1-gonglinkai@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=S9PpBosP c=1 sm=1 tr=0 ts=6a79a49d cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=m_MqYSANrp1KMMaA_BEA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: 5alhbOvfeN0FRhwMuU4pMfK7CWZrB5xC
X-Proofpoint-GUID: 5alhbOvfeN0FRhwMuU4pMfK7CWZrB5xC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA4OCBTYWx0ZWRfXyRA0mtDqhz9I
 LDk/IqWLfM3qPmE/ILa/amm9MRzzrfiuN3WfPKWokn7KUehZ3UbznGSCkQRZuDh2zNq/gik7YCE
 0rjCH6m1g+R8i09u/H6XK8bvqPiprOyoE0sNmGty3tXhluXFtNu13mlHUj6k54re+fv36FhnBOr
 d8BaRgI55YxEhb+w4YpJOLhDksQgWmIR/LGrR6xAvj8IA3wTapvbMc4Z0cktSI3kLjwZ5gyY6XK
 f0ya0N5GXQLZFhaYJBJU3WFw7XW/xp69AtHEMztfRNMc7K5p5TtwRQiIDE9TAH70WqhOr2bXB1x
 Ua3Xp4+as/TWjn2rfywbX6AVcSJqZemXYdYoarC/DA/B+Rp9TMI6CWe2kzOclHwPPT+aiGy+wsV
 RIYPqlR0YSFqLfFIv5p0TY2C+rzs8xrEhQtYQo46o75fI5A1HnfV1dbVh0nB2k/SKMYH6Ytqd4H
 JFJmjwmyqGv/ocJ76Bw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA4OCBTYWx0ZWRfXwnqtuEFPV+wL
 ggR8tA+SacTBzATFyjxfIHJj9Ep/TpXcwffucDiMFJnM3lupTkU/mGw56K3c6DUtKJeM8QiD7wA
 20qvH8RLrEz8ub6chV2CSreopTDDEaw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100088

On 7/31/2026 3:08 PM, Linkai Gong wrote:
> ath12k_mac_setup_channels_rates() frees band channel arrays on failure
> but either leaves the pointers non-NULL or clears the wrong band. Later
> ath12k_mac_cleanup_unregister() frees the same pointers again.
> 
> Clear the correct sbands[].channels pointers after kfree(), including
> a copy-paste bug that nulled 2 GHz after freeing 6 GHz channels.
> 
> Fixes: acc152f9be20 ("wifi: ath12k: combine channel list for split-phy devices in single-wiphy")
> Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
> ---
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


Above two hunks seem to fix older allocation-failure paths which
already existed before acc152f9be20. In current history those lines 
blame back to d889913205cf ("wifi: ath12k: driver for Qualcomm IEEE 
802.11ax devices").

So this probably should either be split into two fixes, or the commit
message/Fixes tag should be adjusted.

But unless there is another reachable path where these stale pointers 
are later freed or dereferenced, do we really need a Fixes tag here?




> @@ -14365,7 +14368,7 @@ static int ath12k_mac_setup_channels_rates(struct ath12k *ar,
>   					kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
>   					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
>   					kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
> -					ar->mac.sbands[NL80211_BAND_2GHZ].channels = NULL;
> +					ar->mac.sbands[NL80211_BAND_6GHZ].channels = NULL;
>   					kfree(channels);
>   					band->channels = NULL;
>   					return ret;



--
Ramesh
