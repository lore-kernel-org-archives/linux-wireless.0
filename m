Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA3722301
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213735; cv=none; b=CeX85Hn7nl/OR80EdNrbgUzfL2lx15+S0WRzFciYmoJrGj2iWDsWRc8kxkjilERYvDB0oyxREVUe/S/QFEmVTeyclJDzbycaUEkHynuENc0sc52TCRHebDUi5OcFTuxKkody+nMJ0XvDmz1z1u3LLjnsduOprnNCn2o63Rve/F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213735; c=relaxed/simple;
	bh=k/0/6mp06TpneyiOrNjzJszm6XUkpQCKjcpJS7x7Aa0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0txRgAOLucKIYHDy9e6FaQP16bccCrPArjTUm2Ct7MZqhSYSsFSoVZP+AsMj9NQ8+lCYzzzLQZXRdJUxct7M9QiRK/Gq2vBD6OUD4FEFFepqfnT9NnzNuL64aIvhLl2hurQlJflytL+E2T39vwI0NI2bJPuq5yEhNmfe4QvfsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jpaaMNCY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LEG45lgD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jpaaMNCY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LEG45lgD"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GDJk4b2721632
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 14:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jnGeRaQiAEtcbHQhvvtOcosj/FA3UbBfncpYPLc5Bg0=; b=jpaaMNCYpVyqE9N1
	U+spdRjza+9qRZYM1wttsMjZnE8BZaPLbtP4r9CBjIlz0HdLF4YRG/ZE6ZtiBBBM
	IgvIQvsE6ThQ/JJaV5Jt2svvuVgXdoDkJkzUDP7JUTgWKvfxWubnp7eBTBktKHmi
	B3rSVx1lg780f9VDjus1Jn/NsLwCXEcsngVdSqIkgTjOVlvhlaQTLFUz6lXPFJRR
	iJBh1Wq2tkcNeQ6Vi31PBZKGKIjmTel9sdnpwC+ZVQG+FmxlmV6LUxCFEeDa/5ck
	qqunz91blzW4onS/N3+S4C4V6b2y8C/xg7SeeoGM1C2GwTAwC5zW60selWaFZGRf
	4DTs/Q==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feehvcfcf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 14:55:33 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c88e0d11a3fso3020156a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 07:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784213733; x=1784818533; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jnGeRaQiAEtcbHQhvvtOcosj/FA3UbBfncpYPLc5Bg0=;
        b=LEG45lgDvcvsS53IRr0me6KBicd0hd4WGHgFXVN5EMgIeP0tE2QobBadw7fwSK7QV8
         TpWU2n76OBal0vHj+GPFb5m2Zs2rixVxaB7SR5XZ4DNXAcidEOOk3ZkkC6ARa8bGdIAL
         c6leZPlVSKvXWlLa2a3+542CeZuhBhKn+YSwsq+L3HY2EkiuizAGOelyc6iJYDbxS8WT
         cgQzp/iLpzs2n2iSaZJVHF9HBHzVva0VEepSA6ryG0Wp+PAf4XYfD2IHTaeLdua5GvTJ
         stu+QyOryEdYfMLhBpSJu8HNo0TYyjlxP5Ax1bqrDU+7qgczc26KRDPKB740loQUKmNu
         GLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784213733; x=1784818533;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jnGeRaQiAEtcbHQhvvtOcosj/FA3UbBfncpYPLc5Bg0=;
        b=HRdP6KTDGxDIS1HQ9z/yikPnIErKnhz4Ro050kGKPl96i80/brYQ8EwflfOSL/1m37
         i70UQ5b6QstfltXK1LRKbqWfmmdOwqfnLNlgGvnHPfQ4EiIxJzIRfDBu5KvTGGeNsTV2
         HP42LmTCt2Y/uWm29zHxIOcp0X/roav3nTEGZxoCuzeQpd34ERnM56wQ2c2Smq5J1rlg
         AcNyQpiTng/GPInzp0QtbpkrFg/EBpw7R8VmvooQ2BUF9odpfdMRIuaDSkS4gYQ+4hRB
         EjYrzk/Emk6Woe9qhOG+4q3rTS91WK9MYNl/MGqE9M4AL0c6swRMVmEGQ9Fzh3msKq0e
         tsWg==
X-Gm-Message-State: AOJu0YxuOsR+IDTAxSRNw9yQGfNdqGvaWxB3UhDKNF83U0EcU1Eblst2
	klFc49Yia8+Dw9iqZ/AcLOB7Q8ugC2kWGkq8XIQM1rM0WzYt/+3bRgzTJoHJm1PMqt8jnKT1ePi
	EmtrU949NErt8r3ZzXWPn++Rxu1h55msMFRZrhSs3+u74i+fgMPVIyKoL5TYX6r6NvFiOPg==
X-Gm-Gg: AfdE7clKwhQhKvflM+vSMER7YEAILXHKMIWUmD5JoQ1XP5qYJcvuAK5LeGj1loDvClh
	WOsADpZQ/zOImkGmdVdCSTDvEzkFTK5CnXfLb3MMZax6OwwhqGU0EnAZ3XYDLo81cwOU/6WnTJB
	YjCmw6zqTpT0OeKGsDZ4XaCTpuFOXxtf6F+t1gFk8Ebzn2BOk5V3xoYipbGdXus7kQBv5kxTn67
	BXAtOm/icGbDjWu09SXXh92ZY2BBYObm0Ft0DmEAKnHSVAonRbNpwlHu23DutSaNPBtlCYk0DS/
	BA8ZczNAR0kWpUIj2Z/TOwaQhAuhSRqssoBpu8sG/X83bnHgDNre5Cqsv6190J/vh6BnhgFNQjK
	geCaCM/Ua4FP0/NU1xEb50mqCUxYIa1U1F5HfNhSsA0j+
X-Received: by 2002:a05:6a21:9d91:b0:3b3:241f:66c6 with SMTP id adf61e73a8af0-3c1108c1a5fmr22178803637.26.1784213732999;
        Thu, 16 Jul 2026 07:55:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:9d91:b0:3b3:241f:66c6 with SMTP id adf61e73a8af0-3c1108c1a5fmr22178776637.26.1784213732505;
        Thu, 16 Jul 2026 07:55:32 -0700 (PDT)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e5326c0sm15727803eec.11.2026.07.16.07.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 07:55:32 -0700 (PDT)
Message-ID: <a906aae4-b695-4f5f-9ee7-51d40700f8c8@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 20:25:26 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current 5/8] wifi: ath12k: introduce host_alloc_ml_id
 hardware parameter
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260713-ath12k-fw-allocated-ml-peer-id-v1-0-d0a2a1a519eb@oss.qualcomm.com>
 <20260713-ath12k-fw-allocated-ml-peer-id-v1-5-d0a2a1a519eb@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260713-ath12k-fw-allocated-ml-peer-id-v1-5-d0a2a1a519eb@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ZpDd7d7G c=1 sm=1 tr=0 ts=6a58f0e5 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=dNVfuQA5Ti0aT4DNj2cA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDE1MyBTYWx0ZWRfX3MAOjwqrwd1A
 RKut1RSu9jZH9efL9vdJOvHBzG4cClvKcER4bpIZAQORQ2z7SzGGjPgXITTgntLXBnKAzGGj8Kx
 EQzTEVITyglM+iWDmXoH1tg9UsN8oTbqAIkYzfxEA8xYOTJ7kQfQ1XDyuSTsHEX9nozIIOAosfQ
 LcKwPrYHp1iKdgiUkDhUicRRgPGOwSL5VMAonvF5Z4WdNRAdG1mJqb3f0tEYshBWeC5FkmvSCyC
 s4AsbgE0LGYTDlO41fK85iR07oJfMzq3h1ZFs6/i3f3zvIpB346m/loaIwhsdz/NtMo+MFRhw2g
 3Kv/m6U5ZNmOEneSh02OQeYw42W6+d8l6RG989jfetuVG/xxv+YTPG55KVh77hChNt0R630htq+
 lvzzYr8VwjFYR5qKSH9cRKXdH1QZXUNs7w343aKpSiD7G7OvAHoiYxAqHQnbTTECZorW+9bMNNy
 gJXeP5UmBintCwrg1WQ==
X-Proofpoint-GUID: 4FEYAAYN-ldqaNCnjfVXny4SfTY2PNLt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDE1MyBTYWx0ZWRfX4mhpVlBsvvxB
 Rsuq394rJ6K5iUV4Y4vCnT1q6SFti0YJ3WXpn85i4A9OcEwFSt3Gecoj1Q8wKAh0bqvG3WeY8xK
 tXMn3ttAQLnRxC50PtKw5a19p6SVs/Y=
X-Proofpoint-ORIG-GUID: 4FEYAAYN-ldqaNCnjfVXny4SfTY2PNLt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_05,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160153

On 7/13/2026 1:03 PM, Baochen Qiang wrote:
> Different ath12k devices diverge on who allocates MLD peer id:
> WCN7850/QCC2072 have the firmware allocate it and notify the host via
> HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP event; While others let the host allocate
> it and pass it down through WMI_PEER_ASSOC_CMDID with
> ATH12K_WMI_FLAG_MLO_PEER_ID_VALID set.
> 
> Currently ath12k host allocates this ID and sends it to firmware by
> default for all devices. This breaks WCN7850/QCC2072, because the host
> maintained ID may be different from the firmware-allocated one.
> Consequently data path may fail to find the dp peer and drop some received
> packets. From user point of view, this results in bugs reported in [1] or
> the 4-way handshake timeout issue.
> 
> Add host_alloc_ml_id flag to struct ath12k_hw_params (and a copy on struct
> ath12k_hw for hot-path access) so subsequent patches can branch on it. Set
> true for QCN9274/IPQ5332/IPQ5424, false for WCN7850/QCC2072. The flag will
> be consumed by subsequent patches.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221039 # 1
> Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/core.h     |  1 +
>   drivers/net/wireless/ath/ath12k/hw.h       |  2 ++
>   drivers/net/wireless/ath/ath12k/mac.c      | 17 ++++++++++++++++-
>   drivers/net/wireless/ath/ath12k/wifi7/hw.c | 12 ++++++++++++
>   4 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
> index fc5127b5c1a3..1f56474efbea 100644
> --- a/drivers/net/wireless/ath/ath12k/core.h
> +++ b/drivers/net/wireless/ath/ath12k/core.h
> @@ -793,6 +793,7 @@ struct ath12k_hw {
>   	enum ath12k_hw_state state;
>   	bool regd_updated;
>   	bool use_6ghz_regd;
> +	bool host_alloc_ml_id;
>   
>   	u8 num_radio;
>   
> diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
> index d135b2936378..8091501cf742 100644
> --- a/drivers/net/wireless/ath/ath12k/hw.h
> +++ b/drivers/net/wireless/ath/ath12k/hw.h
> @@ -232,6 +232,8 @@ struct ath12k_hw_params {
>   		u32 max_client_dbs;
>   		u32 max_client_dbs_sbs;
>   	} client;
> +
> +	bool host_alloc_ml_id;
>   };
>   
>   struct ath12k_hw_ops {
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 7d0d7d5fbf53..9e5fcbf8c730 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -15382,8 +15382,9 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>   	int mac_id, device_id, total_radio, num_hw;
>   	struct ath12k_base *ab;
>   	struct ath12k_hw *ah;
> -	int ret, i, j;
> +	bool conf = false;
>   	u8 radio_per_hw;
> +	int ret, i, j;
>   
>   	total_radio = 0;
>   	for (i = 0; i < ag->num_devices; i++) {
> @@ -15423,6 +15424,19 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>   			}
>   
>   			ab = ag->ab[device_id];
> +
> +			/*
> +			 * the assumption is all devices within an ah
> +			 * share the same host_alloc_ml_id configuration
> +			 */
> +			if (j == 0) {
> +				conf = ab->hw_params->host_alloc_ml_id;
> +			} else if (conf != ab->hw_params->host_alloc_ml_id) {
> +				ath12k_warn(ab, "inconsistent ML ID config within ah, device 0 uses %s allocated ID, while device %u doesn't\n",
> +					    conf ? "host" : "firmware", device_id);

a garbage ret will be returned in this err path.

> +				goto err;
> +			}
> +
>   			pdev_map[j].ab = ab;
>   			pdev_map[j].pdev_idx = mac_id;
>   			mac_id++;
> @@ -15447,6 +15461,7 @@ int ath12k_mac_allocate(struct ath12k_hw_group *ag)
>   		}
>   
>   		ah->dev = ab->dev;
> +		ah->host_alloc_ml_id = conf;
>   
>   		ag->ah[i] = ah;
>   		ag->num_hw++;

--
Ramesh
