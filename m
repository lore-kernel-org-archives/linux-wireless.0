Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793683045;
	b=q2twek6qN+PsMyp81opo0vRrgJ1Ji99I4S5AlYLqNDOtlEKjffZSvytbz11jFoulNAp7
	 SDQS4tSQkvQlX5g6qAJdA69ek8NsiuHBaTPuxaBx4CXrf8ITPj/RRr+LqdzQGyYElQJTM
	 8A3WEt5fUvvRHglCMQoxGfeRBz024SD/VfHc5yszoA708qiY8nJVRh6rJ5Z6/QbXsox2C
	 NfvrRxt+NuH/sSWAWGdG/Gmpc9Hcfcl6iK+rsEictF6X5KQxkabNhMhYwU2D0YtT7jo7c
	 lh7HvUivRgQt0ewZ2YAzPCWiMuFKjYZzPX9MJGWwP1vUIeCBxtJmWEulcZU4RY5zJ6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793683045;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=KPGGWC/2kBi+rBWx3h/b5/WqLPeVhFgeand6Amw/foY=;
	b=zDXGcoS+T0QJfDJNDumRHw6QLASk68Ejw7ZAQTy4pxOwqRwFOYBuCEhS0aQN0gMVyRq+
	 E+/kFa6TiL0I1g4E35+HVezlYM1p+aahKjLLPf7eU/Qr/CCaWRFPTCE1jlGSrrjBd5nAR
	 7ytxHCUFFtbl2JpIWgvJzL7rgUw5l2u2RQp1B4VrlgqadFlnSXMeltFbH9OFXAgrzBPzb
	 wQImChOhVdr72LoRY86paw6mWEOSoh3vmRKRyBkWBf5DmynXnMrJlPKPapp9n39LylbqY
	 HrXUyJsjfwlzykXdUm60MWl6ycbHY8Ht+x+38Nq0FBIvHgoZfPMfgYSvcnSVwqC8NmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pRH1ILBJ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=j8NSJ2J9;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C3F606A329
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 05:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5C3F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=pRH1ILBJ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=j8NSJ2J9
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A353Ghs2451177
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 05:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KPGGWC/2kBi+rBWx3h/b5/WqLPeVhFgeand6Amw/foY=; b=pRH1ILBJH5f11RCm
	fQ026mVvdf9l/lR62Jbr5JobdX0HhuJd9Cd9pQVgSE+bKzBtS9H3xAFarkRprzr3
	JxEEaqCCEP+O1wL+4/+9s67stSC6oJpmnSk+DfjTpYEhtdCpNquGdl0dnKlFkTjB
	TbVDb1Zip6QjkMp2fwSAZfiCYfO1df3E6vtMdk4g4hoAqph8dwFNLj9sivhD62Dn
	wHzTr6auQzkZfvccsStYu5VijIg4FecPLBhFeXNeXD5ARYTdZqh+Mz4A8agmjpPT
	VQp5lo16AphVn2Cto2/RDlBEuxEHzXayL+aO7plrBw/6cRkObF7ZSwWRigb41+t3
	IvdXrg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq94cr1mc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:17:23 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-359b81ad4e8so5087596eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 21:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793683043; x=1794287843; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPGGWC/2kBi+rBWx3h/b5/WqLPeVhFgeand6Amw/foY=;
        b=j8NSJ2J9Hr5enWlSlHJBROzxWHKyUjD5yIsAJV+9LjjjKep0RhR/+2PvaRPpHT3d/2
         DAZH4LzE7CiU6CdEgfBa4NEswrVxpJvHWGtnvnK97zh64s9XOboaH9bwNwrQUUXvCxq+
         4hZ50Kq19Tu6bWMci+Zp4k/Lz5jFCslVYuumb++BbkJmD7s/M/lJ5sowcbzKemFETfC2
         XHl04bFiY/ZYsHC1RWRxz/YU7SAhCQMfwNupqQHiKNqGB/4TgD4uiUMQK7CIjJRvQENr
         7X3OtWsXT4DZn0Sf+AQi3rbz1EFTRsmabQe9hRrXUCSyOCOQZydn6y6kIqsJPPaPZVbE
         S1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793683043; x=1794287843;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPGGWC/2kBi+rBWx3h/b5/WqLPeVhFgeand6Amw/foY=;
        b=1H9iNpZeIWakzoMbDi5eN6bAstkBV6IobLS23b8QWXq8Yw1/pBGAhwLeUVRGdEZN5t
         PyR8Jbpb1p+zIjDBOdCsQA/cVqmigtmusQfzGxQ7q4qJWIecidDYR0lpweR8qe/9Rxqn
         FunQgVnduXi2VCf6PmykYvKluDY38U2hu19NEzapbXEFV+em8mBtWjubsTgaxruA8wq4
         yBEf7yNidzVqO+Y4vs0mDSSEhgj/wpVLhbpp8XtBF/tf2j8/HpK76lGCdJF4cKeEYEhi
         vq+IVkw6uNldGeMfhJb7eZbFVCugvVVd+rGEtf78JZ/bLggiWnVvFqYB6bwijD/QCe+y
         OJKw==
X-Gm-Message-State: APuU4Z9KoEBeiSTNdJQeBf8Z6fOH8NJpYXaRE9SwhbudUtk2PeqQdjUh
	9MlSNX6GP/3YBfxaNjux+sDkhsOtW0+AXjFIj1bgHJ+el4nrh6xy+FbTQoXwabs/5TUUlTiOkoA
	J+RGgXkR8iLx+UcG5zKWTERElljcWfo4P0bMQPO/nux4Arl2xM4ZopDPg3VidwlWho0uedQ==
X-Gm-Gg: AYBFou1ASVsqHGzKVX3dprahYaXMA+9NHPrjWahiYUR5RXy7R73TdnP4KPU4cuXhi8p
	w0QspmiksRDey9lQ6HfVbq2l5av4OZNTAaDpXmgy7vYcmgD+ruQfr+tbj1L5NuLx7ZTUTWqsHZY
	coXt/wGivLjmZag5eNlreABNU/wMwSs2dy6Z5xLPZAnYZGkeeyLbR+6+rtuPRvRuvcxrUjytvEK
	pdSFsdHVAmZyxDza5uiv9xQCRkro/UKXm2qNABtuZAJ3UkMi2H/22knm7815kSY7uH2kc4IJqc8
	XIwGrA3GdWMzqb+fEALwA5LtPwy60+Cna/0rK+N0DP/zvG6m8hx86T+znwUhpNCjDrtZBoczcQl
	Zc8O7IgmC24YBD+7LGE3dkprshswp+whzvyaoTAlz2zWI43ueZxdmro7SDEQvfOw3Cy1rF1+Rll
	ZxNapaAHhgRYZS
X-Received: by 2002:a05:7301:1a15:b0:34d:7ae5:8d78 with SMTP id 5a478bee46e88-36a42418401mr16935925eec.31.1793683042555;
        Mon, 02 Nov 2026 21:17:22 -0800 (PST)
X-Received: by 2002:a05:7301:1a15:b0:34d:7ae5:8d78 with SMTP id 5a478bee46e88-36a42418401mr16935896eec.31.1793683041892;
        Mon, 02 Nov 2026 21:17:21 -0800 (PST)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm36640109eec.4.2026.11.02.21.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 21:17:21 -0800 (PST)
Message-ID: <8a301454-a8b8-427a-883f-cddcf31a4879@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 10:47:17 +0530
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
Subject: Re: [PATCH ath-next v2 1/2] wifi: ath12k: report no AFC memory region
 to firmware
To: Goran Sustek <gsustek@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nazar Mokrynskyi <nazar@mokrynskyi.com>
References: <20261102200235.48973-1-gsustek@gmail.com>
 <20261102200235.48973-2-gsustek@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261102200235.48973-2-gsustek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=O+KsLx9W c=1 sm=1 tr=0 ts=6ae96e63 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=pGLkceISAAAA:8 a=pQ7Vk2PXlUccqxbdelIA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: s1sUB5Yyeq5WBw85eljRi7783p4Yfv4k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDAxOSBTYWx0ZWRfX/Si0Mkq8dlBH
 u8WYTPemaaDGPoSfJQh90qF1mic/cj3lz1lt2zsci7yEKO/7/9FxHdaxHRG/DrmF6bQyAFcFj/x
 mvOg9CQ58O4qNd/6S9Z3p/cTIu+4CUubREaVSOu/CofDLcCOe01EDNTfgO6gAlt/KFqklj/CSnm
 ysyoNP17GyJv2mc+jkZulB3mSyDO2za682H8a4u4U+e/z4Rs4R9E6TjxQAtv2QwJAsaZVf0YTzK
 PZSHYd/683l9Tce2003r2Qb8Nkt260YSv7QesAkpyzmZ7zP3GUeaXDf73cmCUtP5JEYuvtbHwUA
 BqqzlN+aSCwdETm9zCujurEO8DZUodkCdipBlKXujGPlpQZG6+AeTnuJ1uQCaT32qfdxNKRW1P8
 3bn/HV3cQxwv8joUhZQ8Aq4E+9l9iFFCx5QYOEP8Q1TtcviNSO010HwghEMO2MT/7mdfOPFcv3u
 eWzBLJgmAzSM2wSdjVg==
X-Proofpoint-GUID: s1sUB5Yyeq5WBw85eljRi7783p4Yfv4k
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDAxOSBTYWx0ZWRfX2njvpQj28iOG
 iwb0RxRtXjUL5MeTDNYPKCk0GGlcBEZrv5H42wF9be26bitHRohwoLRHJWZMuM7WlrBUNat2pAq
 PSOFXoU2KhrvVVQbGdjDQqXRau8nvmg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_01,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030019

On 11/3/2026 1:32 AM, Goran Sustek wrote:
> QCN9274 firmware WLAN.WBE.1.6-01243 requests a target memory segment of
> type 0xa at every boot. The driver does not know this type, so it logs
> 
>    ath12k_wifi7_pci 0000:06:00.0: memory type 10 not supported
> 
> and answers the request with a NULL address but the requested size.
> 
> Type 0xa is the AFC region: QMI_WLFW_AFC_MEM_V01 = 10 in Qualcomm's
> wlan_firmware_service_v01.h. The firmware asks for 8 KiB, where the
> host places the response of an Automated Frequency Coordination server
> for 6 GHz Standard Power operation. ath12k does not support AFC.
> 
> The firmware treats a region as provided whenever its size is non-zero;
> it does not check the address. With the current answer it therefore
> takes bus address 0 as its AFC region and maps it for its own use.

What do you mean by "bus address" here? Do you mean the DMA address 
provided in chunk->paddr?

Also, the paragraph below makes it sound like without this change the 
firmware doesn't send the memory ready indication and the radios don't 
come up, which isn't the case. There is no visible functional issue 
being fixed here. Please update the commit message to precisely describe 
what changes with this patch.

> 
> Name the type and answer it with size 0, so that the firmware sees no
> AFC region, and log this at debug level instead of warning. No memory
> is allocated. With this answer the firmware sends the memory ready
> indication, reaches firmware ready and brings up all radios.
> 
> Tested as part of the series.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> Signed-off-by: Goran Sustek <gsustek@gmail.com>
> ---
> v2: do not allocate the region; answer with size 0 and log at debug
>      level. New subject. (Rameshkumar Sundaram)
> 
>   drivers/net/wireless/ath/ath12k/qmi.c | 12 ++++++++++++
>   drivers/net/wireless/ath/ath12k/qmi.h |  1 +
>   2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
> index 817bd820623d..55952da4343b 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.c
> +++ b/drivers/net/wireless/ath/ath12k/qmi.c
> @@ -2755,6 +2755,18 @@ static int ath12k_qmi_alloc_target_mem_chunk(struct ath12k_base *ab)
>   			if (ret)
>   				goto err;
>   			break;
> +		case AFC_REGION_TYPE:
> +			/* The host does not support AFC. Firmware treats a
> +			 * region with a non-zero size as provided, so report
> +			 * size 0 instead of address 0 with the requested size.
> +			 */
> +			ath12k_dbg(ab, ATH12K_DBG_QMI,
> +				   "qmi AFC memory region of %u B not provided\n",
> +				   chunk->size);
> +			chunk->paddr = 0;
> +			chunk->v.addr = NULL;
> +			chunk->size = 0;
> +			break;

I'd rather move chunk->size = 0 to the default: case. That way, all 
unsupported memory region types are consistently reported with size 0.

>   		case MLO_GLOBAL_MEM_REGION_TYPE:
>   			mlo_size += chunk->size;
>   			if (ag->mlo_mem.mlo_mem_size &&
> diff --git a/drivers/net/wireless/ath/ath12k/qmi.h b/drivers/net/wireless/ath/ath12k/qmi.h
> index 1b1c88906f1e..9d9174c6ee60 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.h
> +++ b/drivers/net/wireless/ath/ath12k/qmi.h
> @@ -177,6 +177,7 @@ enum ath12k_qmi_target_mem {
>   	CALDB_MEM_REGION_TYPE = 0x4,
>   	MLO_GLOBAL_MEM_REGION_TYPE = 0x8,
>   	PAGEABLE_MEM_REGION_TYPE = 0x9,
> +	AFC_REGION_TYPE = 0xa,
>   	LPASS_SHARED_V01_REGION_TYPE = 0xb,
>   };
>   


-- 
Ramesh
