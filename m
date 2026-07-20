Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCFE21ABAA
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 08:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784536484; cv=none; b=jmQD7p0gP0Rk2LnnoWte7hphH+HXBKFab2OwXk/DgxA/U0FGl2CUqkCYEbS4lycVa1oKg4/hlsZHuHvfDbnhpW2JhTqlvFpXiBL2sN9mvQildXdhX61Khmcje2iqP+E6j8DzD3pWKyVDYlRD1fa1561re7WcGCGcNhWtELEzq5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784536484; c=relaxed/simple;
	bh=sXO9mVb6GJecmguZUeJG/AzaDxhWpeNqvdVRm/eo3YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECPzTUMLweiEvtlN4BIYLsiwBHqdSnQqvQfaJyuc3QdV6OKCm9vP8BBx0iTrsilE3x6MmNvzi604tokjmgOY6ARru8hrQ5XvA8e56Bu1nl/3fD1wPVv7kIpGtNPWlMLiSJbE1jHx/mqUe4cm75Q1h3fsI4V2tYgVXq5ZXA75arQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P9YCTXYs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bDgN1K+t; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P9YCTXYs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bDgN1K+t"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K87W0Q2000791
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 08:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jjExmZ+ZBvgP5brGvJupDhlln576J9vFP8VTLvapH2A=; b=P9YCTXYsUlgkGE24
	aLX6y0hij2swfq/Od6UKUsNmYKcPtLwDgSK89P84D9JRI0ru8xWo26ofTLq0TIuT
	2fyK+EEu/6Ph3+rSEmCrtExwiOEXbzucYPMBpogRoqzC/S6TutuHgiDheyQNutqz
	4wFBwWrVDay6BCelyeVyPIWmkyPfDY3+2UaCn4Pmkpi2qII42oFW239MVU6CKlsM
	ow88KoEoR2wRZfq5XtzuE4It4ldF8YMerz4X0GAEAJGYnEtgd2ZD4ONRTfSQDEO4
	7aKqhbJs2htSNcVqDKUfJowzGh74A7PlHBdkD6X+1uI8QktsE+DpbaHZ7sdnjmvc
	ONKUfg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhfvxg3kc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 08:34:42 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cea6a46766so149990595ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 01:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784536482; x=1785141282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jjExmZ+ZBvgP5brGvJupDhlln576J9vFP8VTLvapH2A=;
        b=bDgN1K+tU/YPgOrBvLuyoB9YPpSlDSGvY2doNJrO2GfvcJ9pBr1mPI4T0p4v/02ips
         FJueZnTv1jnSqL5hKX8UB1yujfljOX/KBGEM3KB8nPZqn2DS455YWQdJcr4qwN/x2/fE
         c8ViVlze9yD0PptY1i6r7ecLBrqo1Kz5l+YWEOKN4QDwOscglVlzJ4Xw1vs/bGWc2fi7
         5fqtyIDTH54xYAIE4oNgeBjEVIQt/lkrsHLDWQvH1m5463ekG79gZBZdCPixLj916Gm0
         bduwmR+jlyg+xlPn/+k7zJXGfM8mqt6sJUsq81f2iDq1zw24ne227NqmOQQSHfmkLTjC
         TDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784536482; x=1785141282;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jjExmZ+ZBvgP5brGvJupDhlln576J9vFP8VTLvapH2A=;
        b=bcKOpPi7p0h5/E3us+5DyynOSCaADbNhWDWWMet6OSZ2BQ7ETBRulWKeeQpxJsfX51
         zvtlAngC2awxKVRfPzfZVsNtCvi7xcx5Y4IiBsYAMe4BGz9pJYca2ICpR6BVsQcJC4N8
         y8/+e0/U+gahRs/taVs/m8uIOBfDdvUh7k7LunyTkCKZVDlZCBCfq9qoxmfjg2l3n1fq
         mXJh7c0VwnQzfMYg5fdHQvyd6+qCsD5iB8YFZZQKWCCft3NiEx2HeI/c1nBxG34Eag5F
         pYvyA3HnUAB2jfDmVSjmgAHp1HXjNWJmFP65v/yY6OlHPNIOXl+uxRZOc2HXrVa7GHFj
         sNLQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBj2/zU++mKKjYBIAx/1052OXxtC/+RbCJHAoNPOoJn+Bgt5qgVLPbX6mkL7lccqcdu5MZ71hUPlSYELfxLA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7HYwcHCEVNjjcEXRAoqQkJVUA618vHXmnNJfQOlM97GEvc5ZR
	9E8fEYtWZ6ED23t2fG2eBNG+cSc540icKW09qP7AxiSqOUwCxEpop+YsSc6w0O9nAUKStaq7yHg
	Q9qgG/uRbqz+5zvc2zKQ2z1OmiY3OpYKLyU6GyYwQ2QqbbslijzvU70qh71T9YcwA58FHfg==
X-Gm-Gg: AfdE7cnU/NY4LUaOXByBONQ7ej5hvyb8EwUaBqq1C45pz1oXehkjvnxmhwKHGv+nkoV
	Q4Kpokh2vz7vFECEHBHWs2GmaxmYQlKUZhm/y+J0JKnZyUaZQ4IkzWfBJkKtas/hWXhMZ31yTig
	1/3yfsPGWa2Pd61/EY0ceBOuSUEo0K6yNXr9fo6Mcb3EvG6w+Ayco4BGwxIuvnkVsOTley1P/qn
	Wmo294UZBq6/dfmfasdC4oMwYaclg1OYGAobo79z0f4LLkgIG08jt8iX5qFJgsVYsxT93Wujr3w
	BIjCMn606JGQ1e7hVJFBLxbf0ZhVJfjT1gzxTvolWiXcC012UYsi5pQypg3McBK7/Fnjl7Eo2Ar
	29jbT6ewsknPnUx/rJbwg5f6R9OlBtdl++ysCSoCm+l1efVRzUn7k8R7kjai4v4vlxcqDI8Vc
X-Received: by 2002:a05:6a21:4edb:20b0:3c3:bbe6:95c9 with SMTP id adf61e73a8af0-3c3bbe69a7cmr8385777637.16.1784536482167;
        Mon, 20 Jul 2026 01:34:42 -0700 (PDT)
X-Received: by 2002:a05:6a21:4edb:20b0:3c3:bbe6:95c9 with SMTP id adf61e73a8af0-3c3bbe69a7cmr8385757637.16.1784536481606;
        Mon, 20 Jul 2026 01:34:41 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb519de2fb2sm4237277a12.24.2026.07.20.01.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 01:34:40 -0700 (PDT)
Message-ID: <5ca16013-e8a0-4403-a2b3-b3b43ea2bb2d@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 16:34:37 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: fix frequency range for
 single-pdev devices
To: Shenghan Gao <gsh20040816@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260715065218.41232-1-gsh20040816@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260715065218.41232-1-gsh20040816@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=HKLz0Itv c=1 sm=1 tr=0 ts=6a5ddda2 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=ptET_oXVa2BxEO8-YBQA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA5NCBTYWx0ZWRfX/AQXfA3ZuR6D
 bO2JW2RBrW5ZW0phYOtAtT8alTl88iLBR+ZI0pB2deUcA3k99VeJiXaVlmEy+foYUgyqizPel1G
 OQhNFsJL9G7xw33m8nsH/6LeXTNZlkQ=
X-Proofpoint-GUID: RBhRJRPWlN9WYdbOhtzNGbfUDJjda3Cu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA5NCBTYWx0ZWRfX4ajoDSCA/FTp
 VL+/55UKKGoEHwi9okR5qc/d2nIoJaFHCKngVa/b+kMjI0yw4tZ01KhndYl9hVxucPrrzCBgeK6
 NYvCPC9IBOZF7uDiMt8Kcdqrk5kUWV/77gDgL6qwpM8DzOQp7dJbt3/iuHSpLm/zUKvCUcY5DH7
 OFp7/UT6q1ACfiT6ELRRwVSsCDdi0Lqr2f18h9/++kZob3CwCXd1InkTJ5a2oSHGXWDKjXjUK2d
 RfzWXsf/2xiHAVhn+g/+ERn6uu/YR44SpCgmuh1NENaAu8SAYeXXRXzM5rXCbY3NYaN4MHlXBFO
 TiQN3jEwv7884KC7EVe4g1ZmUE3bXMnd9pYMvw8YS100V7MJylgNZiqIXlobJOVqAbFzC1Uld7H
 3ai/AjLzXUEoOrUkAyUPIswNxnTcdlvTvBbh2aK41C6hR1Qv5dGkZ+BXaJmO0UHULgUhCD7WY2F
 bBzikNPzZqLnTm/wsHg==
X-Proofpoint-ORIG-GUID: RBhRJRPWlN9WYdbOhtzNGbfUDJjda3Cu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200094



On 7/15/2026 2:52 PM, Shenghan Gao wrote:
> Commit 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
> made ath12k_regd_update() handle each supported band independently.
> However, it uses WMI band capability values as indices into
> pdev->cap.band[]. Those values are bit flags, while cap.band[] is indexed
> by enum nl80211_band. As a result, the 2.4 GHz lookup reads the
> 5 GHz entry, while the 5 GHz lookup reads the 60 GHz entry.
> 
> Also, the 5 GHz range is skipped whenever the radio supports 6 GHz. This
> is valid when 5 and 6 GHz belong to separate pdevs, but not for single-pdev
> devices such as WCN7850, where the same pdev covers both bands. After a
> regulatory update, 5 GHz is therefore omitted from ar->freq_range and later
> filtered out of the channel list sent to firmware.
> 
> On the tested WCN7850, the 11d regulatory update left the frequency range
> at 2402-2482 MHz and sent 13 channels to firmware. A subsequent 5 GHz scan

can you share more details on how the frequency range is updated to cover only 2 GHz band ?

> failed with WMI_SCAN_REASON_INTERNAL_FAILURE. With both ranges combined,
> the range is 2402-5835 MHz and 26 channels are sent to firmware.
> 
> Index cap.band[] with NL80211_BAND_* and update 5 GHz for single-pdev
> devices even when 6 GHz is supported.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 0d777aa2ca77 ("wifi: ath12k: fix mac pdev frequency range update")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:GPT-5.6 Sol
> Signed-off-by: Shenghan Gao <gsh20040816@gmail.com>
> ---
> Testing notes:
> 
> - Runtime testing was performed on WCN7850 under the CN regulatory domain.
> - 2.4 and 5 GHz scanning and 5 GHz association were verified.
> - 6 GHz operation was not tested because it is unavailable under the CN
>   regulatory domain.
> - QCC2072 was not tested because the hardware was not available.
> 
>  drivers/net/wireless/ath/ath12k/reg.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
> index 89abf2e87ad1..c3bb1df2b1e2 100644
> --- a/drivers/net/wireless/ath/ath12k/reg.c
> +++ b/drivers/net/wireless/ath/ath12k/reg.c
> @@ -300,7 +300,7 @@ int ath12k_regd_update(struct ath12k *ar, bool init)
>  
>  	if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
>  		if (ab->hw_params->single_pdev_only) {
> -			phy_id = ar->pdev->cap.band[WMI_HOST_WLAN_2GHZ_CAP].phy_id;
> +			phy_id = ar->pdev->cap.band[NL80211_BAND_2GHZ].phy_id;
>  			reg_cap = &ab->hal_reg_cap[phy_id];
>  		}
>  
> @@ -310,9 +310,10 @@ int ath12k_regd_update(struct ath12k *ar, bool init)
>  		ath12k_mac_update_freq_range(ar, freq_low, freq_high);
>  	}
>  
> -	if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP && !ar->supports_6ghz) {
> +	if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP &&
> +	    (!ar->supports_6ghz || ab->hw_params->single_pdev_only)) {
>  		if (ab->hw_params->single_pdev_only) {
> -			phy_id = ar->pdev->cap.band[WMI_HOST_WLAN_5GHZ_CAP].phy_id;
> +			phy_id = ar->pdev->cap.band[NL80211_BAND_5GHZ].phy_id;
>  			reg_cap = &ab->hal_reg_cap[phy_id];
>  		}
>  
> 
> base-commit: a1a21995c2e1cc2ca6b2226cfe4f5f018370182a

