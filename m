Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7142F35B657
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 17:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786727908; cv=none; b=Nt6yUtv24jGh9uaGZlTfbwEBri8Plz6BT/crKrTgDulkSSmlawzGuOAHXVrvn6EVaEAplad+kNZMciLX3DvWCDIVYBOmt2N7Okoa4vrhRyWQczDiTBHNtStatJutY9OaI3kWQwNXdZ6COCjaWYiIQFzj4xlY/Xdw4oj82shpIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786727908; c=relaxed/simple;
	bh=hqfo/P/1EILA0fas7ZwXx190KZh6OE2KEpHcE1F5mxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sO12tzjQLWLH7yAhCvcW0mjEmKnrk9nzYRKmeWSTRPhObQJuNIn45Xmzb1fuoDg9wgomssqTE+obBNTYgjmRPvrOetTkeAzWvOMwsN0rRdYD6Lu0OLgjAHyOufj6fHkq5rwKx1juuSJo1iKEYoy4WNcDdJwy4X3rV0SBATzVfyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OgDEK+Uo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R09qalV1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OgDEK+Uo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R09qalV1"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EGiD2x2129050
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 17:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gv5W2yYX4quRxCJ1N4tZLLo22II075WOBsSrcOE1tuU=; b=OgDEK+UolCCSGYvz
	ipbRiNc3GilioDbbsXShI6CyAJfAJAQ0Ebb2zcruZU34lVuwCF7+IKZjV5LkHxJN
	IMOTZBPcMkfdUFu/6OSFdTtZt2mHpC9lpFxJBISfcfL3lFQ/CxV/p54C3G5K8hEh
	tiqqA++VwelsLNpmBqy1Cv4xzPpZdw4eqa77Yc5huPoMz7TH9UmRxxdosXwaKGj1
	ZShwN+96tsrxodIrCmVbsM9Q6pcvQUmgZnGYiSKh5EOXc9Yveu+4/b8YsZwFSdiX
	pktkeiOW9q+cfFjdcNNs2hJTjAkHS+VGuquQnb3P6gnsArcqn/3ZcbesaLvZFJhY
	H6BDAw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g21d9hq5n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 17:18:26 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso1493596a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 10:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786727905; x=1787332705; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gv5W2yYX4quRxCJ1N4tZLLo22II075WOBsSrcOE1tuU=;
        b=R09qalV1xsHE4bs18lKY/L9d8KcG+wZcDOkMN9UqFluaRABmMnjLXI4/9P26AnjLdR
         QZ8m51dYvGP1e4ErvyBD2rT/UxhN3I4jxiN4nkOZy6voQW/06kIGmn2fpOGX68OzOgaA
         5O7PW0J2FSOoOpZiVNS1DRm5AKhuckb3Xbt0e3hCsVvCtk+GTFR4c3LOgBPJrEOyrk2o
         Bu1T5bWdWvUjucPTY7Dab4IwI3Hnx1SykMiUuTmvs2U+8FuTsBVR6h0UcWbgSzgdHwMr
         leFTboIOKEoFTuD12TpZigjWKofkb4G3NzD35tlsXnY0Yq6HGDnXAt9LMn34HPw8ltjF
         0XXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786727905; x=1787332705;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gv5W2yYX4quRxCJ1N4tZLLo22II075WOBsSrcOE1tuU=;
        b=H/AAaias5eR9WqzPIi4LhV7o154UgSDxFECm54yF5hSDgoEgFX7SnJq24FagX/etM1
         HvPVEtIbcdq1oPXSeU/MbY4SAFgN7P8l0tk7yPaPvZOuXU7bW5jO+wEWPEpDzKn7bmtT
         qCHXq76WqqvF2peWSGGWP6YyL98ETX31Wjt8daATAHBHX1CProWWmHt0aA+Cnn+V1fcl
         mUxDbaZpU3QZV2rSvqHOhi1yXhm7iopUUJzJ96wzn9edJx6GelM4nfpsMNWUCVQlQg/B
         R04KMgfBL80fpXF6YbAiYDCgb/KljwXoMcUSAmxp26oujlUjXq/B6SeLah4Z/icVwiT0
         xDDA==
X-Gm-Message-State: AOJu0Yzg7Blsi5LMBa569bbWlZIveSB+Ga1QnTIt4+wV9E18BgCal3HJ
	9DH0Betn4Ynd9uFeobqGB+I1kTn9xFdy4Y03wfXQfTh2qHCGpEL/uoxIck4bpxIMo1AK9bVRIJP
	PLfLBH/tpOsY3oRICfqkd9/F/qfd+4B0y2E+TmXAiQJDFKzxawYfuifcZ8t8Mb/qjaNfS+jM31A
	y7tA==
X-Gm-Gg: AR+sD10VPE3tIULqwzg8p5NLNNkaCuwMLBMtzhazbFVIPuBiLa2LQ6L7//tkRsm/HmI
	N6lQ0i/BYAPLgaT1nwvQrh3HHx5nk8DGhQqW1XmaKlnA9BvbsWKofuP0QUTlCKnzPzTgfYGpB+V
	glEVSJ1Ezq0b/ZlpVcM9fXESLAAmIQ//IfJ6sqPOsFa8kLR2qFHOKU9b8EH8c6S9Ir0j0Mx0jzO
	Y0t79EyR2epTCWjAzCC+HTknVyV1YGYACc7Lqeigfs14ZzOOO7b9riU5l8dDSezSQW5HIt5nv7q
	cyLBpS7dAnWgjL+9CWKy2yCThfo4wbzzA0dann8MbgcsHyrVTKFA+neGG3lgoaIxxqAnvsFyArw
	5Yw9ET8ukrcllUpQ7xMTT2xuoYi6RNDRIN4FbtSAdSe5spZ0Oygdrr+wTgyKl
X-Received: by 2002:a17:90b:3c4a:b0:38e:63de:730d with SMTP id 98e67ed59e1d1-3933b6f15dbmr7984729a91.3.1786727905134;
        Fri, 14 Aug 2026 10:18:25 -0700 (PDT)
X-Received: by 2002:a17:90b:3c4a:b0:38e:63de:730d with SMTP id 98e67ed59e1d1-3933b6f15dbmr7984665a91.3.1786727904675;
        Fri, 14 Aug 2026 10:18:24 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394e921709dsm3300855a91.0.2026.08.14.10.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 10:18:24 -0700 (PDT)
Message-ID: <edebd957-79d2-42aa-bd15-878f2eee2a35@oss.qualcomm.com>
Date: Fri, 14 Aug 2026 10:18:22 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v3 6/8] wifi: ath12k: track per-ring RX
 sent-to-stack count
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
 <20260810144444.2033607-7-pardeep.kaur@oss.qualcomm.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260810144444.2033607-7-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEzMiBTYWx0ZWRfX1uUPZNNugVzV
 WT6r4p7dqoqcg/bhn1+vgUD19fnkhYPzYoN1sYKSMlwEt7Vt6kbbR1j/ks1qTuUocdBbySzrdXW
 avqsgv3EsCNficLgbz9OTu+iBgExHZI=
X-Authority-Analysis: v=2.4 cv=eqzvCIpX c=1 sm=1 tr=0 ts=6a7f4de2 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=RhLGSmBNoTyMoNKgCAMA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: aCN1qtGVO8OkjDXLdmUaF0HZZ22siZ7o
X-Proofpoint-ORIG-GUID: aCN1qtGVO8OkjDXLdmUaF0HZZ22siZ7o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEzMiBTYWx0ZWRfX/7YOZUM9+llA
 CsUiF5BueLrCXUT6EBe4SPCvHcSWcyuITxbxWM/UX7KwUlvo4trQpcge1kwfu7xIPBi5o3ib2DL
 aXfaL1jMTOw2dCkimUXTaTptd/zgN3i3T9Zs3H8v/o4G4WNhVDCEv5OfK7wW1CCxJmlkFGpx5z3
 X2BFjTV/mWZ1l5TmlMeRmgXb74CpUeJxiXaMPbggLC/LjaxcRJkpoNp5RIFwK+W1z4yzNu1/kGS
 asNa8LA2L3LKDdkFKsGaD5pHkRrRvIpef6FGRTJd2N2ESSNWdkSivagjdnp4sHmi9oKtj9GqoDG
 SAqB48JvvwTTIAfCX/bdxeGOFc0z9BVEHKIq0ysX6cQqrvlU/lprhHgyKXayAEo47B/NCpJjHYh
 0ZT/8Bh2ccO1QMCGFVRgecLp/fcDUTcFyzDMsn3c963ZN6tDTGbZmNkfE+6VTB6lmK/95TJoBBH
 sDYQyuOlkXgzTvIeJpw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140132

On 8/10/2026 7:44 AM, Pardeep Kaur wrote:
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
> index 34c605b609cb..55e3b411d108 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
> @@ -1122,6 +1122,16 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>  		len += scnprintf(buf + len, size - len, "%s: %u\n",
>  				 wbm_rx_drop[i], device_stats->wbm_err.drop[i]);
>  
> +	len += scnprintf(buf + len, size - len, "\nREO sent to stack\n");

My review agent notes:
**Missing colon in section header.**
`"\nREO sent to stack\n"` is inconsistent with every other section in
`ath12k_debugfs_dump_device_dp_stats()`, all of which end with `:\n` (e.g.,
`"\nREO Rx Received:\n"`, `"\nHAL REO errors:\n"`, `"\nWBM Rx Drop
Count:\n"`). Should be `"\nREO sent to stack:\n"`.


