Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793615787;
	b=tfRWaenmtO5gHlwMdTSbP4c2D/MXGjXcmPgrrfaV/rvCXvhfI53rF/8/wu35zGYzJcT4
	 iR8wA+DaK7wkM+5OpVCWvHwy4iKvgxoL79PlIFwQWeizJuBOCGbNgwhQv48WAmo9vfQwU
	 NdQf4csttG6B+XoFAxaVt1sJj1Kuo5rBzfxzbMhV4hMJDfIr801IGn7D3624Hhv0Hvj2B
	 RWtsBIlgLb5xr4ukFKnoChR0JnGKo485FF0ads8w583JvjAVmSASCVvcUiLfc5oFzOxie
	 FCUXxnkvlWhrqFwRmT4DhNTP7n9NK+Yy0aQU5YFjuUuFn1suolufQlGLapjDJSGLTcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793615787;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=j/h1nzyLwLos+57W9zu2/iGj9UgqL5dXrMfiNd2SNZU=;
	b=POys1H0dONvYkguD8hgSfV+kGG6Hlom0XKstPvIWYxl8p17qe0fYGPMtyOkm0SWo+2k3
	 hl9XOvyFcHRgl8SQhHsn0fi0vjUk4/CPI0kTdmVT1Q0qzYF5ylS9aPzWKU1YFroK46u2k
	 b+jw0ML/4+pWj5jjtH/8pc3v14VaPIEJAI5phvhJ0kyb44S2VUv8zun151vouXVgXm4RC
	 kuUNu6p3wFAZcPR7GwKC5jylPri9+RqLL2Ko3+EVLbnmDGCUU+on6AOaU/RHYjH0APfy1
	 wowqcTELdcY8X7MqBO1OMESwfnNkeAByPlxjPfFwrvNigXBw/xlYz/6XtKfkHe2dSlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dqRMo+cS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VGVeLrOd;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E61606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 10:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2E61606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dqRMo+cS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=VGVeLrOd
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A29AQNK2361159
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 10:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j/h1nzyLwLos+57W9zu2/iGj9UgqL5dXrMfiNd2SNZU=; b=dqRMo+cSRMsreCgu
	/jQKDuUdCRXiqAJDUQ2UirIhyyJWVFsvA8LlMNa0KNYMgtJLXUhwfWytP1BaGd47
	M5DCeDHRqxfY4DfqHtDCYoVs8G2VZqnQrnKPufVksU+LUk56E+UEu5w0i2pHWkX5
	uCf8jHzk8sQzqLnRVSL7E9DIMWZZHwJzQgP62+ucqxqvAAlx1G6YNWjFmZnqpwGQ
	kH4nioi3AmWiJZiS6g6zR9Zi2Bo+5VtnQ8go/0y4XQ3OLCT5cgjYRPWF5LlODaGc
	GcS+dPi1ZgNGVlykOAXqj39gd9Grf0G6H0CaCILsSF4IJv3jM3jz8h+PMH3opAfj
	H5LW+w==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn8q7xdep-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 10:36:25 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-139b62317d0so5856516c88.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 02:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793615785; x=1794220585; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j/h1nzyLwLos+57W9zu2/iGj9UgqL5dXrMfiNd2SNZU=;
        b=VGVeLrOd2GvAG844DHWOJb4z9Lof6lYEMcp71dRe6sOzmqbWZGfNW4GvU3btuJY/M9
         /naAlIOkgwZkwUmFm1Bl8mbnTiiXhly5JFh+Td7fxMM9KYtmYADh2WQnF0D/Eo1lo0wK
         OXVhYlaermIrag7qWKW0st1FxQFordHgWn73Xc46ImmY7GsL9TKN+cfpie/t6Ppqlcfh
         phnvvITabs76yq/xAhizPkGumXteCO3wfV8TXfkxkD4q9ke8cfz5F6YyTUHutP6toHRV
         GYaLMPBPZKxZi0pBrPiL+k9iUaIjbjK8N7FkGwp1xY37E7pn7RdSJ/t1QnMoIMrM0vQh
         9BxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793615785; x=1794220585;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j/h1nzyLwLos+57W9zu2/iGj9UgqL5dXrMfiNd2SNZU=;
        b=G057gSFcy5gHIH4o+LAvWVxKCv2LCcaGh+Gs55dX70WMAJcXXa3ce3hzW5iW4HBotv
         qyqq9UmKb0HDlkQqvRYC08whXOO+YQp+uxGAY6PhAnalru7ldqoWbanLO2IoamXDgf9k
         JFUtRnACIg4n6Q1fP/3q17s+7J08goy3kA2L56mW5N2wda0/EcCrs0LvWpmthx7nYgzW
         x2caNZh7oOBLn2zNhG59GHyMmFfG3Ea9AAF/GWDJ8irMjCfG9R+1BufpOJ4aAZWn3Gkh
         gI0NkLjExHDNyIC6e6EqR7YF2PUb53060Mv3pj6kiQlNPNjXu4Pml0ceE+D4VFmdFUc+
         l9wA==
X-Gm-Message-State: AFq9FYJ+/x4MzlmD2yBv6pmP1qeGYI7bE3t13TBzLh0gGBIGUGjsPKXv
	GNXcnfThgNdKgAeIxpRmh+t8NloLyT58Re22RisFfnjVIhA/WTnJhFjEI2nCGeRooFP135OgFcV
	+YFUoO3K7CgUIKwbeLcfMuQQr+GAwDeu/2mXhCu2N6jZTQYYSaaTmrx4y5MVOVoMyTpLVIA==
X-Gm-Gg: AYBFou0Q3fa0/OCdQ3uHA9rWAGZ7HYbKcAjg3f737Q5Sh8vLCWONkXDUu3QNOWH/9X1
	87S4yaYxq1e6Pzzn+DBotzCrbsURQp51ALP4+owARgN9RcQ90N2iKpsjcY10sbX2cUZtb7Q7csU
	jZq46rmZy4o3LergEOT7WuVsJJD/u141XyE8JcXif/LEEZbwYrjmu6oT4J7oalpp4aicsAxAS9w
	DHKzQkABPRbFR6Le4/MI+H4d8AHgqL10MF/m7NCHvK5zhl4BGx8/q0fsPTa1eL7drLxswhjVQvj
	zIIa0ZCisi5n2+EAH6UkxKVatiJYhrLX9RffQwOjooCKbs5MCNCsoeYevUeZh5Ys0qVGjej3ZTp
	/b/7HgDYxRAH8+5lVXAAKQ48LnKt5LPG1cFq44fo0ZudR+V9g15BxmOiujJZ6kgIPLuIeDeqVSX
	5pZQgvsjAeaViG
X-Received: by 2002:a05:701b:4244:10b0:188:ed6d:ebc9 with SMTP id a92af1059eb24-1ac5e6f5225mr14728397c88.38.1793615784531;
        Mon, 02 Nov 2026 02:36:24 -0800 (PST)
X-Received: by 2002:a05:701b:4244:10b0:188:ed6d:ebc9 with SMTP id a92af1059eb24-1ac5e6f5225mr14728355c88.38.1793615783725;
        Mon, 02 Nov 2026 02:36:23 -0800 (PST)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac19f4b08bsm38136990c88.16.2026.11.02.02.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 02:36:23 -0800 (PST)
Message-ID: <98f13907-fe0a-4a8c-8ac9-3be40edcaff5@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 16:06:18 +0530
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
Subject: Re: [PATCH ath-next 1/3] wifi: ath12k: allocate the AFC memory region
 requested by firmware
To: Goran Sustek <gsustek@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261030220824.915760-1-gsustek@gmail.com>
 <20261030220824.915760-2-gsustek@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261030220824.915760-2-gsustek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: MVoFkWMEQHnuNyPkg1Y8vbSZgjsjKsd6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA0MiBTYWx0ZWRfX3IBnkNJJPelu
 FufrCEsMfdwBlvhUOJKkFm946KTqTyoFHcRzr0N3hbaSGxNCbXcjgb4IY2WlfSeYPD2uDJzyhi0
 EHAIekpL0O2IMDoX/OJUfb4m30v7fJM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA0MiBTYWx0ZWRfXxRySY3DDgeT6
 jYDQ/4ehq93sVE2nofVMniSHvhGAtazFgaU25MsEt/ZdXRH2QCz9Js0KcxEpHt1dxhqXyMnxrlw
 mtiHZNh+5sSVElOjjLLPVo0zN3digCzHOXi2WG0gJcq1TUtFyN6ehHLuzUgnEI+b8ARqHnd00K+
 QDYeLurPB/599WK8/YaiK+guYD1sZPGrqWEyfgd2t33IAX0A/co5o9H8GbpF0oDrU7pXyswT32z
 7DAeHdAMPRvyNw4GOceRpPadHgtYmy6BF8qMqfAheNkwNsXH4EPfgwHWHn/SuH+vunKt9cpsnz0
 TIYU52Oi9WoCnbhicSahWl0HNKjGdkBJSXgHobHCZD6Gw4rT87wdnEo6B7fAZYY+Xo6fSPKSZIJ
 zMx0W2noMMOjLkDo/LlAciCF2RLDtKDBeWo+K/b+lFKyYvaHunodcJlX4N7EEDcfz5wk39vEt3R
 FBT8/ptzqZX3cVmZQhQ==
X-Proofpoint-GUID: MVoFkWMEQHnuNyPkg1Y8vbSZgjsjKsd6
X-Authority-Analysis: v=2.4 cv=PucG/AM3 c=1 sm=1 tr=0 ts=6ae867a9 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=pGLkceISAAAA:8 a=dEvXkhbO6Lc7JD6ITUUA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020042

On 10/31/2026 3:38 AM, Goran Sustek wrote:
> QCN9274 firmware WLAN.WBE.1.6-01243 requests a target memory segment of
> type 0xa at every boot. The driver does not know this type, so it logs
> 
>    ath12k_wifi7_pci 0000:06:00.0: memory type 10 not supported
> 
> and answers the request with a NULL address but the requested size.
> 
> Type 0xa is the AFC region: QMI_WLFW_AFC_MEM_V01 = 10 in Qualcomm's
> wlan_firmware_service_v01.h. The firmware asks for 8 KiB, one 4 KiB
> slot per radio, where the host places the answer of an Automated
> Frequency Coordination server for 6 GHz Standard Power operation.
> 
> The firmware's handler of the memory response records the reported
> address and marks the region as provided whenever the size is
> non-zero; it does not check for a zero address. With the current

In that case, shouldn't chunk->size be cleared when no memory is 
allocated, or should the response only contain the chunks that were 
actually allocated and assigned by host ? (see 
ath12k_qmi_assign_target_mem_chunk() which updates ab->qmi.mem_seg_count)

Allocating AFC_REGION_TYPE while AFC itself is not supported by the host 
looks wrong to me.

> NULL answer the firmware therefore holds a region at bus address 0.
> This driver never enables AFC and no misbehaviour has been observed,
> but the firmware state is wrong.
> 
> Name the type and allocate it like the other host regions, bounded to
> two 4 KiB slots. This removes the warning and gives the firmware a
> valid region. An oversized request keeps today's behaviour with a
> warning.
> 
> Tested as part of the series.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> Signed-off-by: Goran Sustek <gsustek@gmail.com>
> ---
>   drivers/net/wireless/ath/ath12k/qmi.c |   17 +++++++++++++++++
>   drivers/net/wireless/ath/ath12k/qmi.h |    3 +++
>   2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
> index 280e50a1f31d..0679e5d2d4fc 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.c
> +++ b/drivers/net/wireless/ath/ath12k/qmi.c
> @@ -2707,6 +2707,23 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
>   			if (ret)
>   				goto err;
>   			break;
> +		case AFC_REGION_TYPE:
> +			/* Firmware requests the AFC region at every boot, even
> +			 * when the 6 GHz radio does not use Standard Power. It
> +			 * treats a non-zero size as a provided region, so hand
> +			 * it real memory instead of a NULL address.
> +			 */
> +			if (chunk->size > ATH12K_QMI_AFC_MEM_SIZE) {
> +				ath12k_warn(ab, "AFC memory request of %u B exceeds %u B, not allocated\n",
> +					    chunk->size, ATH12K_QMI_AFC_MEM_SIZE);
> +				chunk->paddr = 0;
> +				chunk->v.addr = NULL;
> +				break;
> +			}
> +			ret = ath12k_qmi_alloc_chunk(ab, chunk);
> +			if (ret)
> +				goto err;
> +			break;
>   		case MLO_GLOBAL_MEM_REGION_TYPE:
>   			mlo_size += chunk->size;
>   			if (ag->mlo_mem.mlo_mem_size &&
> diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
> index 6da10f3cb597..c438ef6c7680 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.h
> +++ b/drivers/net/wireless/ath/ath12k/qmi.h
> @@ -26,6 +26,8 @@
>   #define ATH12K_QMI_BDF_EXT_STR_LENGTH		0x20
>   #define ATH12K_QMI_WLFW_MAX_DEV_MEM_NUM_V01 4
>   #define ATH12K_QMI_DEVMEM_CMEM_INDEX	0
> +/* AFC region: one 4 KiB slot per radio, at most two radios */
> +#define ATH12K_QMI_AFC_MEM_SIZE		(2 * 0x1000)
>   
>   #define QMI_WLFW_REQUEST_MEM_IND_V01		0x0035
>   #define QMI_WLFW_FW_MEM_READY_IND_V01		0x0037
> @@ -173,6 +175,7 @@ enum ath12k_qmi_target_mem {
>   	CALDB_MEM_REGION_TYPE = 0x4,
>   	MLO_GLOBAL_MEM_REGION_TYPE = 0x8,
>   	PAGEABLE_MEM_REGION_TYPE = 0x9,
> +	AFC_REGION_TYPE = 0xa,
>   	LPASS_SHARED_V01_REGION_TYPE = 0xb,
>   };
>   
> --
> 2.47.0
> 


-- 
Ramesh
