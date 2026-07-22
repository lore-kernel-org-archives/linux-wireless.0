Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C4357CF9
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 13:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727297; cv=none; b=bM5I2adanKMoxaB8mIXxphMJ4d1vMYvIXeJJNR2NUVOQFdoUySjY+oNLmPF17QGuybkFwJdzGGoVJBX8BRoKOs+MYSCGqmHZcZHFEIQ8u1AnroShsEvuEN76DjeMAz2Wf/SY/cs/N9vS39N/3qyuhPNRu3QKRi3L81DxpfTtMls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727297; c=relaxed/simple;
	bh=/C8IZwquBav2HFohCAi/UmibUN7UraiczymP5Xcssvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxOLQlsgkOE9zFcgvqXqTHYYFnOljJD+DjQBMoTlCLq2ayjRVj3yR9ivkT7AMsUecDw3iv03nA0dtLR2USb80Tnve/lMW3S6CxQALpf412pDLmoccwXnSIG7X8LPob+X/BcRqh3vqSXyIlsxX3I8mjgvp5wLF7OD2kogreVcDrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=egJp5n+Z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iks3X4t7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="egJp5n+Z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iks3X4t7"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MDWPmH2029990
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 13:34:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bAMC1tEWuW8aUIkhFhHZeU0Otkfs+pd7Gd9KHfl9tMc=; b=egJp5n+Z2iJ/qrQa
	ePIE5rzfZcfL/K4Pw/4v9nh5DhfLs40/CtFfi/HTea9ecA4rRyiho7ltyeXMsrB/
	rhKjJGjxCVhuTwOEZHNIBWcRILG8OcNDsN/pNWwmtfoY2WAx6x3kkma4aCrXXyY+
	Uqr2z0lzOgHW8XFfPw3GEtxzepKKdI8eIt5v2ddyhYdK7YLgZXuYLn//Hu50XGkF
	ZPPa8TRGErrNejPNhIwdAS2CUYrS2Pl57bXbglZWIX5sBCRTMERfjroJ9nPd6R4b
	fbHS8ByNgh8bsOLuSVbEuKr6/q+9k7u7zPnWgZ0e/3NihBS4OqiZPaGx3vAM+9c2
	v8m8Yw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjr839sts-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 13:34:55 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8efad04d884so182325736d6.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 06:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784727295; x=1785332095; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bAMC1tEWuW8aUIkhFhHZeU0Otkfs+pd7Gd9KHfl9tMc=;
        b=iks3X4t7eahP7ra+jJfLGxLIbsUDHmRhmlS1aB2KkfUFfbuAmEoITC08JC0POHLJkj
         hDMuX5PIPZHl0gfBgYA7iFFNGDIovyZgLAGaGjfBpkfTTrf3S/Hu5Z6Tnzyz/FA4xywP
         Pa5JGb0v2TgoRxPzAUjzQvY5pyUScK5cTa4E0+jBjpGPDeBgYxNZsKtK4yB9xjeQ2vIM
         uhwI3XhE5R9xSxupc9PbSsvkSqApJaR1BvKsJ2sgNK62GobYkmwZayY7QJxWmLqtQfu/
         yRrTSvQvNlT9QedtS5ni+JVJeSP1qXuZeq/Oyd5mDt+8u4fWHlXU/3Gi6N3i8q0YeNEq
         HN9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784727295; x=1785332095;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bAMC1tEWuW8aUIkhFhHZeU0Otkfs+pd7Gd9KHfl9tMc=;
        b=cn3hgtVAJOcyetJfD9PniXKj00bRCMFE+7haxOUDsykeUH7DSxqtr7+Ec+QoFaWtxD
         WaWaYXXEFgu/yvkqhcV/+DrcC7HPZmN8BOHu5yqR5YmNlQsVCdK2eraEvA1g0A0WKlD/
         fAG//MvCUKEOyzLqi9xFQC9+QCl70WAqatfURvBQW3NESjrlY86bNdiCqhNaqVC2Eqb2
         XBB9xYd0p6TLzYq2tYB5q5aIpNECy5GP08KtjC1tP6NJ1KZxxjA31APPXPONgPw1jDnH
         UlMx6R5LcBos3sFhGsPClQB0Yjy+41w1p/F3iCs1zlaW2zp5DuxNUfkrcgHW9qiaOXuO
         61+g==
X-Gm-Message-State: AOJu0Yz2x62/Z/rwLgZmC7qwaI4PO58izdDlkGvZYLKpJ702EzGm0taA
	G9MZu9sR8Pbkx4NLzDvPYAWMRhzTpkeE/5lU6e4WgQoHy2a5dbGjz9fqH+6f44xHkdglpcARBUc
	fbzh+ZxegNKuHujmTmXTWxPv570qF+IWlHGpTGajeq+8n9wERbZmt4bd2+7tWMZc4HXBdHg==
X-Gm-Gg: AR+sD10+nt/dRXns9CIO87m1z/I+pDue11f7MBSvBcJ6HDSc7BPm+ZhvADIyxSxOR/0
	mKx8N0C+bWfZmwqYH7wHtG37wKk/WRr/Y0qhM02JUGICp/UbITsJErjW1fPyw1gCwZWUTHE4Yty
	dI3PQ7oyZguKYnfpqVok6UFZP2JURkPOE3sv6MPKk6E2bx+ZnPAi2iTCrBbJ7KhfQKvdB6/J6N5
	PXiSrkSe8OG92MFpHeSOf5tKk6iE9Cm+fQ0Q2AJsi7nq9ebWdowHhCbdNyxcjdx33a6oE1NVlv2
	tanNZLWuTypvPAMfbwLcmzkFVVVNsAfGnIamNBj+RaAYH44wAi/kSIBuJ4V/qaEbo5womC4cdrS
	MVdQiRVD7Fp/DS6/cXdrmDZUIQkij1E9PDlkatqyOHc+PHTR1RcfJnsRkT4rl
X-Received: by 2002:a0c:e084:0:10b0:8f1:ae38:1beb with SMTP id 6a1803df08f44-907783a0557mr191584926d6.32.1784727294635;
        Wed, 22 Jul 2026 06:34:54 -0700 (PDT)
X-Received: by 2002:a0c:e084:0:10b0:8f1:ae38:1beb with SMTP id 6a1803df08f44-907783a0557mr191584546d6.32.1784727294127;
        Wed, 22 Jul 2026 06:34:54 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0b7absm21266636d6.37.2026.07.22.06.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 06:34:53 -0700 (PDT)
Message-ID: <95e9a73a-c076-4bdc-9f1b-ba8a811f4711@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 06:34:48 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath10k: validate WMI header before reading it
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260722042029.36066-1-pengpeng@iscas.ac.cn>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260722042029.36066-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: vUfDZkIsqvgS4f7QuHBkDM-DVKDsKElA
X-Authority-Analysis: v=2.4 cv=VfrH+lp9 c=1 sm=1 tr=0 ts=6a60c6ff cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=PdpW-wIJrJljDUDkzOgA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: vUfDZkIsqvgS4f7QuHBkDM-DVKDsKElA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDEzMiBTYWx0ZWRfX+dKsPCg4Wu5z
 UUotSThzUoQDuKVixjEWvYd6b7ezd+tk6WMT+0TU0v3HVjPVVTEqEtyoKDaVcdKkzd0whYHlTrx
 2j1lko5coe57BdH9ZBhVjMElZkkK/m9msGDYDn539LFl3kiI2rSHcYYFbdOG7jt71kfZgLovWGn
 EWz95gRhcnieIiZhS36WZHU7wg8CtySlD2cw0ePx69uGis/143/Pj0VoEohJt13mqYQgqBLO69T
 c3GDvdQKF6xzvnpLcR0LOJJJ8fmC5xSVV4vg+g+A7pVE9czxVY19EQMZXH7hOeH2rQaavFuWsB0
 /5TNEw8VXTRwZchLtZHxT1PD0AW1rW6aDWlA8XnZ8j1lKbW8Wn7GGXLW51GUyk4KTvFVFjYpPHs
 6YuVu1E0WzFlttKuVbsutVi/r/1v6oY0XKKZLH/DsT/9STxSTeMKfNJc+ObuP0YtInxaEIoXK/n
 tk36UQraaCybFYKhhxg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDEzMiBTYWx0ZWRfX3Shx5lqlJkcH
 PWP+Wo/T3ji8ytWjI6oPncdCyiYRRkznq2Ablzd6hhUHU522N0vuLmp9DmnAjJ9EtfLqF2saq0U
 izZbAfteXjNJKlxKTOqw2IvIpjLWJpc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_04,2026-07-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220132

On 7/21/2026 9:20 PM, Pengpeng Hou wrote:

> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index e57588c19c80..5b64b5f9bff7 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -5873,16 +5873,28 @@ static inline void ath10k_wmi_queue_set_coverage_class_work(struct ath10k *ar)
>  	}
>  }
>  
> +bool ath10k_wmi_pull_cmd_hdr(struct sk_buff *skb, u32 *cmd_id)
> +{
> +	const struct wmi_cmd_hdr *cmd_hdr;
> +
> +	if (!pskb_may_pull(skb, sizeof(*cmd_hdr)))
> +		return false;
> +
> +	cmd_hdr = (const void *)skb->data;
> +	*cmd_id = __le32_to_cpu(cmd_hdr->cmd_id);
> +	skb_pull(skb, sizeof(*cmd_hdr));

consider following the pattern from my ath12k patch instead:
https://patch.msgid.link/20260716-ath12k_wmi_op_rx-overread-v1-1-327a4b1c2372@oss.qualcomm.com

use skb_pull_data() instead of pskb_may_pull() + skb_pull()
consider masking out the id here instead of in each of the callers
(if all of the caller have the same masking)

> +
> +	return true;
> +}
