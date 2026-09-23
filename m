Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391C9370D79
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 02:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790130239; cv=none; b=W8vuuA5N1b/82Oz/SGldwWcIE7BM7fwddh/OnWXLQ3U6ZXb1YSBgzBJdrQVEPl+GFITI8TnyFPU6aSLFkUxtwaGK/whha2nvbzfUsQxoaw1g+FW6buQFx3Z87pLZciVLmS0THFbGiqye2wmKojdQG+lQIDXuaCZ+gddf19k0vf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790130239; c=relaxed/simple;
	bh=oAFjTQfUKulQLWM7YiS29Zl4JeiiE5zmnGIXqAlTlxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grxvRIVIz5W54mYb/l/BUUQUL7xFWjILPUTCQSGJ6O5kWcK2CGaEIwkHzDgyuTTTvYbi4MVKQkDf0P5ygAUMFdfx/z7PS8q5+7iPFdF7DGaGe0ZKKkPxWArczsy68vA+rzg6bI48bPeC92HrNoaMMr0h+ImDkYtqnOfosaB/yLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WyNbrWli; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PkKd4Ulu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WyNbrWli";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PkKd4Ulu"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MN7F1T1529713
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 02:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AX2Nle44Lv8ybfqYcCzu93O+KbWu3Hg1NB0Oi0gGgoQ=; b=WyNbrWli/8KG39EM
	0SdHfzufOO/i/WBjfV3LbpNtptLDb6Ls5zr5PJgLnM9nFQdUEDkdQ3yr81uKmPT2
	B2z39q5ivlbOlWRTVFa/CLTj4Uc7gMbRCG4bm4cj9yhj93EwD7yOZTBHFRxpjqu5
	bQQrAH0hesMpJXCzG5DgyRDZEj9u2AjmAN2N98VpbWnBNmxUGDo3T5H+GZU3O40m
	b3AXzxUAeKDgIfChMCGmHjKPhtO+72+o4V53XoBqciH8kQPr4LWW1ezA39pDZmAT
	28JJFQj1OTTdZFEGYONej1w/g2Pkc3KkS/4cWWaqBdOW64d8BZJT8x08/00M81My
	05yhMw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gv32qrhqd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 02:23:56 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so586220a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 19:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790130236; x=1790735036; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AX2Nle44Lv8ybfqYcCzu93O+KbWu3Hg1NB0Oi0gGgoQ=;
        b=PkKd4UlumPSL68tUIiaNEzWHAelCH804MrQzwAiCsLd7yvQWmrV0SAq3SDp/YQuQKZ
         dXzfbkklVUn2XszT5iBFGNaZlqzPJCnSTw23jzBhaZ0BVHHeZEo8htK3vAqXvDyIHJTw
         ZEabcOfbVpye3TdjD8qYd5y6O9MtEsTKnjuigWiEeD4Q+ExXA6fKcOj8v/Za1B/VquWV
         Ek2mrmdUsFRUlzgFdv3+EIreSy3SMdtgoI7qV1vhPQPCsEd9E2p8Hxs5oq2D5c5PBv33
         ssRPoV/x9UNNxO1ZBv98dVV9AettjGRLCNh2fi+YZwrHHdfpBCPb88g1KC51710pQ3KS
         w5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790130236; x=1790735036;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AX2Nle44Lv8ybfqYcCzu93O+KbWu3Hg1NB0Oi0gGgoQ=;
        b=Kh7eNUkXiBezOfbJ2ZogoCCFnLkFsaMmQ4UZeHmPrkTMMHj08FADTMglplcVA2BLCs
         M9PaLlouY+p98fgQdrMAi87TQMp59ovbIhuyK+BbW9H1R0z3CQpVoiPhFLt/0spn0+hx
         wqiajcuRDurV9xPc6P/CaRSbayHyqOPZld2TeJqG5E8SNbQDJoEX/DvrPCYur+cbcfjZ
         RxkX5UER0GB+E+ebQsKV+R1nWFT3Bcn7BXImztkAH10wA4Gnn838ielmEc1HhC/AUId/
         Z4QUp3MZf+4jpnkb9Zw+sAHZSQQXFXeAMcdJMo/tbQ14HfyrqL4cNHdzZohpYsOxs/aN
         wrsw==
X-Forwarded-Encrypted: i=1; AKwUvBzOthPMMQx/BuIWG4Ho0JFwmD22Szp/TYQcRqIkHj2PKVyz2yLL1LIQ36BQQBgA59fnG0zipNRIwA5YdWyz0w==@vger.kernel.org
X-Gm-Message-State: AFuF++kBRjCyB5Cmn0WE2aFMDAqtwn/EbqQYQ4+j6L2nHdF0VeOtMGsw
	aPhjF0nYAZ8LsAyZm3kXWZc7ozKzKOT/eWfXyd2ViqAa7dCk/UtCuVCXOZFtzgwgBOHfMFTuGrX
	fmCuTKYsvZmk2CpcMrzld7gui+V1yrb6pnh3UD87cQkiI/1sgiDVxF2eYD21JrT642+MXLQ==
X-Gm-Gg: AYBFou189TcIGK4GhNOt+8YTcPpycrJUO1oWdN4U1oeWBDqc2f10uj5XEUMbY8vsF2F
	Qm/rACxcFLfHYqqUc26T4PYgntsTB/u+KRgC/wxzKZ1zxJvLGP1Xqp/fwwjCYSC+Z/sFJz+gDNj
	WZPt1a8StPHR7MrK6542WPbhdYsipwRnkz3MDbNtSgTltcuN5W6OXqHXSvDH2GyO4+FBf9Zsy+8
	EJCbirI7wgyJYwaAcAMw8oAirEZdH/zJqZUhEFyk2tiMN+OsUBM7WNHBsyFg6wd4zZPKNA4tAgs
	lnk5cz8lRScIIFq/4TAC3M5MTSoLIvcXwRBbl44/TNG9WQrKkizSl4+4q+QC6Curp3HEUrUXOTv
	9sNn1BiR6MsP4K29SdQexEW6Q5Qw5/4OozcJIJV/Im+8ENTt1XO/RH6ISBbxiyd2vytA=
X-Received: by 2002:a17:90b:3e4b:b0:39e:6c69:34d4 with SMTP id 98e67ed59e1d1-3a07e793f0dmr1094058a91.56.1790130235977;
        Tue, 22 Sep 2026 19:23:55 -0700 (PDT)
X-Received: by 2002:a17:90b:3e4b:b0:39e:6c69:34d4 with SMTP id 98e67ed59e1d1-3a07e793f0dmr1094043a91.56.1790130235472;
        Tue, 22 Sep 2026 19:23:55 -0700 (PDT)
Received: from [10.133.33.151] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dc5f3d7sm2197098a91.16.2026.09.22.19.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 19:23:55 -0700 (PDT)
Message-ID: <87097a5e-d334-49a7-865b-f4660f9a8cc4@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 10:23:51 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4] wifi: ath12k: advertise interface MAC address
 pool
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        baochen.qiang@oss.qualcomm.com
References: <20260922200643.1133491-2-ivitro@gmail.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <20260922200643.1133491-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=SJnXx+vH c=1 sm=1 tr=0 ts=6ab3383d cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=m8ToADvmAAAA:8 a=EUspDBNiAAAA:8
 a=XWmW6VCIqsrZXVgdJaoA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-GUID: 2MfMihy_qBE6Fj4mgVRHVei_ZFngAR1D
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAwOSBTYWx0ZWRfX/2esGDz/dMFn
 s+NRFNAvRu7pGV/cBrQmpLbQJoTq0CTOZ5moMqL+dj59G4e2vDh+7fQlLeEpbzD5ivMaq7limcy
 PD4e8+DUT/7p29m/vN7bmkPLDERJGD4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAwOSBTYWx0ZWRfX39Z7yQmMlKjd
 psp9zS8FsJbIvOCDxcnfMwgJhtAoXWpUBy8SnEDa3tx6+1Q92mEkKZRJ8CHQkCWt8izX6Yu8wLM
 uTvh2F9ezLgB6bxSowgkCEd6DMs/vt6tfZKvmPxe4whCJiIdYdFeeXm0H1KqzlZJwvIdbq/n/fp
 YWiXZln4y1KbDx3u9Ewy24Z5XwfJ1W9yRBi0+YmnH0qIxe7bqgQnCevt5Tmi/XRmVX+tfkbfoPb
 Ar+3ffS2cR2AAvcvY0WGGcxNBq4XB59MOiBQTogjJrbcvQJ/AqfJP4nHX150Rr88e9CBk34VpV2
 nuSutPR3AvCwheTjTDoABhxmFKAG3N3WvdU7Eg6Nyc38Kh8JsteQC4iwmpbCEGOoqa7ifbmLapb
 ZOhjUSeWSzmAE8q91xN04URuG5quD+Y5W/tNhlsTlHgy9vL55mkn2uGtOkW0X7L5w42v5Tdifoa
 FQdffFv9Gf7Rg/fTLpw==
X-Proofpoint-ORIG-GUID: 2MfMihy_qBE6Fj4mgVRHVei_ZFngAR1D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230009



On 9/23/2026 4:06 AM, Vitor Soares wrote:
> From: Vitor Soares <vitor.soares@toradex.com>
> 
> ath12k supports creating vdevs with addresses provided by mac80211.
> Userspace can already make concurrent interfaces work by explicitly
> assigning different locally administered addresses.
> 
> However, ath12k does not advertise an address list, so when a second
> interface is created without an explicit address, mac80211 has nothing
> to pick from and falls back to the permanent address. If the first
> interface is already running with that address, bringing up the second
> one fails with -ENOTUNIQ.
> 
> As in ath11k, provide a list of usable addresses so
> ieee80211_assign_perm_addr() can hand each new interface an unused one.
> Keep the first entry as the wiphy's permanent MAC address. Generate the
> remaining entries as locally administered variants by changing only the
> upper nibble of the first octet, which naturally limits the pool to 16
> unique addresses.
> 
> The cfg80211 definition of wiphy->addresses does not specify where the
> addresses must come from. Some ath12k platforms use it as an interface
> MAC address pool, while others use it for firmware-provided per-radio
> addresses. Gate the generated address pool behind
> advertise_iface_mac_pool and enable it for WCN7850 and QCC2072. The flag
> is read from the first radio, as all radios behind a wiphy are
> expected to have the same setting.
> 
> Other platforms keep the existing behavior.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> Tested-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
> v4:
> - Document why the first radio's hw_params is used.
> - Add QCC2072 Tested-on and Kang Yang's Tested-by.
> - Link for v3: https://lore.kernel.org/ath12k/20260921173033.846332-2-ivitro@gmail.com/
> 
> v3:
> - Rename host_alloc_iface_mac to advertise_iface_mac_pool.
> - Clear wiphy->addresses and wiphy->n_addresses during cleanup.
> - Drop the single-radio check and rely on hw_params gating.
> - Enable the generated interface MAC pool for WCN7850 and QCC2072
>    (QCC2072 compile-tested only).
> - Follow kernel block comment style.
> - Link for v2: https://lore.kernel.org/all/20260915152815.254016-2-ivitro@gmail.com/
> 
> v2:
> - Gate generated interface MAC address list behind hw_params
>    host_alloc_iface_mac, as suggested by Kang Yang.
> - Enable it only for WCN7850, the only part available for testing here.
> - Add Assisted-by: tag.
> - Link for v1: https://lore.kernel.org/all/20260902082219.3010793-2-ivitro@gmail.com/
> ---
>   drivers/net/wireless/ath/ath12k/hw.h       |  1 +
>   drivers/net/wireless/ath/ath12k/mac.c      | 54 ++++++++++++++++++++++
>   drivers/net/wireless/ath/ath12k/wifi7/hw.c |  6 +++
>   3 files changed, 61 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
> index e790de5737db..c58db8482aa4 100644
> --- a/drivers/net/wireless/ath/ath12k/hw.h
> +++ b/drivers/net/wireless/ath/ath12k/hw.h
> @@ -238,6 +238,7 @@ struct ath12k_hw_params {
>   	} client;
>   
>   	bool host_alloc_ml_id;
> +	bool advertise_iface_mac_pool;
>   };
>   
>   struct ath12k_hw_ops {
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index d4116ba0da08..c131358efb69 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14743,6 +14743,56 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
>   	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
>   }
>   
> +static void ath12k_mac_cleanup_mac_address_list(struct ath12k_hw *ah)
> +{
> +	kfree(ah->hw->wiphy->addresses);
> +	ah->hw->wiphy->addresses = NULL;
> +	ah->hw->wiphy->n_addresses = 0;
> +}
> +
> +static void ath12k_mac_setup_mac_address_list(struct ath12k_hw *ah,
> +					      const u8 *mac_addr)
> +{
> +	struct mac_address *addresses;
> +	struct ath12k *ar;
> +	u16 n_addresses;
> +	int i;
> +
> +	/*
> +	 * wiphy->addresses is per wiphy, so the generated interface MAC
> +	 * pool is advertised for the whole ath12k_hw. The hw_params flag is
> +	 * expected to be consistent across all radios in an ath12k_hw, so
> +	 * use the first radio as the source.
> +	 */
> +	ar = ath12k_ah_to_ar(ah, 0);
> +	if (!ar->ab->hw_params->advertise_iface_mac_pool)
> +		return;
> +
> +	/*
> +	 * Only the upper nibble of the first octet is varied, so at most 16
> +	 * addresses can be derived from one base.
> +	 */
> +	n_addresses = min_t(u16, TARGET_NUM_VDEVS(ar->ab), 16);
> +	if (n_addresses <= 1)
> +		return;
> +
> +	addresses = kzalloc_objs(*addresses, n_addresses);
> +	if (!addresses)
> +		return;
> +
> +	ether_addr_copy(addresses[0].addr, mac_addr);
> +	for (i = 1; i < n_addresses; i++) {
> +		ether_addr_copy(addresses[i].addr, mac_addr);
> +		/* set Local Administered Address bit */
> +		addresses[i].addr[0] |= 0x2;
> +
> +		addresses[i].addr[0] += i << 4;
> +	}
> +
> +	ah->hw->wiphy->addresses = addresses;
> +	ah->hw->wiphy->n_addresses = n_addresses;
> +}
> +
>   static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
>   {
>   	struct ieee80211_hw *hw = ah->hw;
> @@ -14762,6 +14812,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
>   		ath12k_mac_cleanup_unregister(ar);
>   
>   	ath12k_mac_cleanup_iface_combinations(ah);
> +	ath12k_mac_cleanup_mac_address_list(ah);
>   
>   	SET_IEEE80211_DEV(hw, NULL);
>   }
> @@ -14878,6 +14929,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>   	wiphy->available_antennas_tx = antennas_tx;
>   
>   	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
> +	ath12k_mac_setup_mac_address_list(ah, mac_addr);
>   	SET_IEEE80211_DEV(hw, ab->dev);
>   
>   	ret = ath12k_mac_setup_iface_combinations(ah);
> @@ -15120,6 +15172,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>   		ath12k_mac_cleanup_unregister(ar);
>   	}
>   
> +	ath12k_mac_cleanup_mac_address_list(ah);
> +
>   	SET_IEEE80211_DEV(hw, NULL);
>   
>   	return ret;
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> index ae8df80928b0..ad362244ed9b 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -445,6 +445,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   		},
>   
>   		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>   	},
>   	{
>   		.name = "wcn7850 hw2.0",
> @@ -539,6 +540,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   		},
>   
>   		.host_alloc_ml_id = false,
> +		.advertise_iface_mac_pool = true,
>   	},
>   	{
>   		.name = "qcn9274 hw2.0",
> @@ -629,6 +631,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   		},
>   
>   		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>   	},
>   	{
>   		.name = "ipq5332 hw1.0",
> @@ -713,6 +716,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   		},
>   
>   		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>   	},
>   	{
>   		.name = "qcc2072 hw1.0",
> @@ -808,6 +812,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   		},
>   
>   		.host_alloc_ml_id = false,
> +		.advertise_iface_mac_pool = true,
>   	},
>   	{
>   		.name = "ipq5424 hw1.0",
> @@ -895,6 +900,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>   		},
>   
>   		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>   	},
>   };
>   

LGTM



