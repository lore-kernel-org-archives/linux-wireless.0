Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6034E73D7
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 06:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059635; cv=none; b=EWqhdne7qx4Li8azcFjHHX+HkmF1+8ffhLomCoHwTBvCN1CjWFeY/KTXG8slo7qaC0oH9XzkykHAZ4F9qOudxleahuQCbNBdvOiLUK2KizyH/SCqsXPw9ASFgF9wWTjrTfeKVY9pZi95hBzXBkgxbkqspRgT0qzVGHMiNowQRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059635; c=relaxed/simple;
	bh=u8V8WV9EdX/hVEUXlmP+v/EbhnFybghpTvyLLDXZ4co=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PS8gG8r8GKlcpDN7f8hm97ZmuOxDt2EY3lRBpeGWwCsuZXWWfeW2QmcaJV1+5wWleFp8ZlrOftypKUnm8ipbSrTXv48r0muyAfUznjIgnS9otjVgTCilwz/8Mibc5sigfByAtG1coAtXGfzkamtfnhNNO4jZjtm+lWy/r+Phm54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MLdeZK8Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P+/suFWm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MLdeZK8Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P+/suFWm"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68M00XC32166198
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 06:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ydl/Le8STRVOEBLkVL04aUGbtOU5VnHABeS+aKUR8+g=; b=MLdeZK8YpzjHXwfo
	9FDhxskn/jw63QmWPx03UFbjAUlYvICoLfywT5WHECMKfIDG9/uHhyWCpTYWY4Uq
	MsC7eGGz0Ntz7thiU6kGgDnYqNbwZ/78ZEGQ/yYsPfaxMi+dkZDvqNyn3QqNrTke
	9Qymyi1Xc29sM9wbO5mWtWEx7kpgicnKvB1lKB26g0mlVH8A0h2uzq3BJlHdrexR
	r6hy4/78ahK97bWpqzGM+p9ZjqQz/5Va7A3GWeGt2cFVpGRq+pgv05m+VmnE3n1n
	FS+Sqke8338PilmaA+Fj/vhmyvy1qWKWJASA3L/cBu/q3Xe1Hue72iDKztVfQm7n
	V62GZw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu8xetms4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 06:47:13 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39af92138f9so744474a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 23:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790059633; x=1790664433; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ydl/Le8STRVOEBLkVL04aUGbtOU5VnHABeS+aKUR8+g=;
        b=P+/suFWmSHFXhzONM4/PxZOxfwIl+CZJVO4pJjBcnJmyWC8xc5EQPoSg0jhtUDflLT
         VgmI7WxKtwUHVs4L3NEb6w9Yp0fBZu7dAzndJoE6YaaMsMHp1F5pAyGH8UkKYWAdQbE6
         fKD4zW81PPjsDkgo7Wu1wcH5cEYDO33dVT/oMS7tudPtWw4ptKL6DmH5xJNXZWZN3Icc
         pm7XSIf9SHAqJPfzN7j+iU2sZribpsm/JlVGn7W0OMKbmG9dxrnfZhZuxWrHBc7yTAHg
         OEQ7zC4J+ClCKbXVM5b4jrYknTLUmeDoGOIQtkGH3cHrO228EvudiRWxvjFXgLBamtns
         5/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790059633; x=1790664433;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ydl/Le8STRVOEBLkVL04aUGbtOU5VnHABeS+aKUR8+g=;
        b=bcY9q8v1WrqRJHGxlMz4jkInOIDeHR+mZIfKVWCfflP4LlRxnWg2jLSxnBzZxfTR32
         /uUV0idOPzUtiCYRhI4ANYacnWID2uw3oz3OImEtSKWHZzu8epiku0eWf3wPVHNZKtoG
         0WTkO6TzrAWDDsJxy2x+hgwpVTqW5Seb629p8dUENrJtJaK4uEDzYiXtwO/F+wXcaKjK
         weUw54OOLfeVmqqoY5SEHO50UhOHxeYMfPYNfs/Y7KgomSKiTnYbMyMRMs4SoNGFn7GN
         A8Bzbfhg9ezMIEJtyYaQP4J/pqk9iTaFzl547lRq6eXgxodbzHY0dWnNFiTjB4otFMbu
         hKKQ==
X-Forwarded-Encrypted: i=1; AKwUvByjLf6yG12/K6hlSDC7OYUCqqKKG1onNyXNcsqXHCWPIZuptCcP05yz3oEVrK/vRMvpSLXHbIAEn0mgNf/TJg==@vger.kernel.org
X-Gm-Message-State: AFuF++m+hzZtEw0tRmEd0prqIgW963cqNhgNEdXHy1eG6Ivu3GJNNssQ
	vcNwLJUnePstdPnnD8QnCemxiiGkYK9H6VoVvscBcBufhWT09Ica+S/9J2Ki2xG80tYXzSBjsf9
	B4dfMdf3VZw2sJvMbNv+xrevvEQyGvbf0b5b8YgyMX3CzZJ+FWGWZZWg3pHb9rHpibHhPEQ==
X-Gm-Gg: AYBFou1ikP9Ydyq0ZrivTWpA7Xtt9mNH09xoMzTaCNPoin9fOfbTrX8zluX0pn9q3d1
	wJg+rIs2fr9rVOLZ1CSoperNrshxZtK3rwJmch2QdnZB6lR+9koEgM8Ibfd/ZyeRO9mEe6skrNM
	ZJeLkZAMhK6NCwNhWlzMoTDjE0MF+S9RWFlZ2ArFqhgNpbhvBZs8QCd6OFw4VeuvLJ/0VzsqTOp
	CbAeAkb44EFcyZhDxsJLDXmwWDZ+ArWxZVpN/7+cqGw+i96XhHQs5FoAK8Tc1DnvlLHik+mnY22
	g0pwVMUtKzPl7zP2mVzq4UtlsT2UG0ZYeHF2Y7vsD1VHXECMrziBzvwcCmSVM+WN8RZU8UU2be6
	p0qh0FnNf6OcOMiRNLEqKyUX7Mi6KXv8J/VDXloax4igu84LToqz9VwH7EtEBqPCF2TL4nwss
X-Received: by 2002:a17:90b:4b05:b0:3a0:42a9:9c84 with SMTP id 98e67ed59e1d1-3a073672f0cmr103372a91.22.1790059632380;
        Mon, 21 Sep 2026 23:47:12 -0700 (PDT)
X-Received: by 2002:a17:90b:4b05:b0:3a0:42a9:9c84 with SMTP id 98e67ed59e1d1-3a073672f0cmr103358a91.22.1790059631784;
        Mon, 21 Sep 2026 23:47:11 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06dfd6705sm1662145a91.0.2026.09.21.23.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 23:47:11 -0700 (PDT)
Message-ID: <270630fe-e9d2-4028-a70b-2448a370ba9e@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:47:10 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v3] wifi: ath12k: advertise interface MAC address
 pool
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        kang.yang@oss.qualcomm.com
References: <20260921173033.846332-2-ivitro@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260921173033.846332-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: gOwTqh4NNra_dzKRU1vQaOENcogwWdmE
X-Authority-Analysis: v=2.4 cv=PZhqFShd c=1 sm=1 tr=0 ts=6ab22471 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=m8ToADvmAAAA:8 a=9m3d3nHKyyb8iBbjpxEA:9
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-GUID: gOwTqh4NNra_dzKRU1vQaOENcogwWdmE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDA5NSBTYWx0ZWRfXxuCp2y7O1ggN
 EXQYX8cOnqWJdQ99mM/PzTtS1eYgcAs+WT9LScV0bCRQCLMN4EY5Do9EzoI7OWRjCLkSPp0ZuU5
 76jRjGIVrLwC0edvH2ogh0NJiWW2h4ZzFaoTViA/wPYiGEJ1rd1O4EF4oc9SDCnm16wdKL07qci
 hMhVzYaFDatqZctgQ95HDCMGD8CYazIke0/7kfp2g035hfnTZVpeWsFtPrngPw/hSwMt0rLcEyH
 xIudQRCZm6TKC3VJYoKvK3IYGujBtmjx4zOij3c2uGSnd8X0yeEWZhZz+yI4KRl8aTTgM3cOJeF
 Y1eExyyn8oNXc60/7gx/A+aiaOao6AAn1Y9uWLP5rqjUpSF6WiPRaXwbs0690J2bjHYvOtQrbr9
 YLxL0guhCuG6sr4ZoXD5kwyaL7Ye/fhlByg7L5Fvff1MKD0sdS7mSfK8Eg2uw/P3Z7HvxFzeByA
 3v2DRb1VTDhRzoZfryQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDA5NSBTYWx0ZWRfX02xsm9JXEhtA
 bSrVuKnz57pn2bGZOQBjAxmc7kP5jYYZ8xyfzjrEJ4Ta3DJDnWdeo5Oev3IDfkJelroIxl1pGhU
 FoD437fPm/f84a2QhkA64HkndDeSEyc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220095



On 9/22/2026 1:30 AM, Vitor Soares wrote:
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
> advertise_iface_mac_pool and enable it for WCN7850 and QCC2072.
> 
> Other platforms keep the existing behavior.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> ---
> v3:
> - Rename host_alloc_iface_mac to advertise_iface_mac_pool.
> - Clear wiphy->addresses and wiphy->n_addresses during cleanup.
> - Drop the single-radio check and rely on hw_params gating.
> - Enable the generated interface MAC pool for WCN7850 and QCC2072
>   (QCC2072 compile-tested only).
> - Follow kernel block comment style.
> - Link for v2: https://lore.kernel.org/all/20260915152815.254016-2-ivitro@gmail.com/
> 
> v2:
> - Gate generated interface MAC address list behind hw_params
>   host_alloc_iface_mac, as suggested by Kang Yang.
> - Enable it only for WCN7850, the only part available for testing here.
> - Add Assisted-by: tag.
> - Link for v1: https://lore.kernel.org/all/20260902082219.3010793-2-ivitro@gmail.com/
> ---
>  drivers/net/wireless/ath/ath12k/hw.h       |  1 +
>  drivers/net/wireless/ath/ath12k/mac.c      | 48 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c |  6 +++
>  3 files changed, 55 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
> index e790de5737db..c58db8482aa4 100644
> --- a/drivers/net/wireless/ath/ath12k/hw.h
> +++ b/drivers/net/wireless/ath/ath12k/hw.h
> @@ -238,6 +238,7 @@ struct ath12k_hw_params {
>  	} client;
>  
>  	bool host_alloc_ml_id;
> +	bool advertise_iface_mac_pool;
>  };
>  
>  struct ath12k_hw_ops {
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index d4116ba0da08..46f5f338f44c 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14743,6 +14743,50 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
>  	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
>  }
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
> +	ar = ath12k_ah_to_ar(ah, 0);
> +	if (!ar->ab->hw_params->advertise_iface_mac_pool)
> +		return;

commit message does not describe why only the first radio is checked. From previous
revision I know the purpose is to enable only WCN7850/QCC2072. Better to describe it in
commit message, as well as leaving a comment here.

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
>  static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
>  {
>  	struct ieee80211_hw *hw = ah->hw;
> @@ -14762,6 +14806,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
>  		ath12k_mac_cleanup_unregister(ar);
>  
>  	ath12k_mac_cleanup_iface_combinations(ah);
> +	ath12k_mac_cleanup_mac_address_list(ah);
>  
>  	SET_IEEE80211_DEV(hw, NULL);
>  }
> @@ -14878,6 +14923,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  	wiphy->available_antennas_tx = antennas_tx;
>  
>  	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
> +	ath12k_mac_setup_mac_address_list(ah, mac_addr);
>  	SET_IEEE80211_DEV(hw, ab->dev);
>  
>  	ret = ath12k_mac_setup_iface_combinations(ah);
> @@ -15120,6 +15166,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  		ath12k_mac_cleanup_unregister(ar);
>  	}
>  
> +	ath12k_mac_cleanup_mac_address_list(ah);
> +
>  	SET_IEEE80211_DEV(hw, NULL);
>  
>  	return ret;
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> index ae8df80928b0..ad362244ed9b 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -445,6 +445,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>  	},
>  	{
>  		.name = "wcn7850 hw2.0",
> @@ -539,6 +540,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = false,
> +		.advertise_iface_mac_pool = true,
>  	},
>  	{
>  		.name = "qcn9274 hw2.0",
> @@ -629,6 +631,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>  	},
>  	{
>  		.name = "ipq5332 hw1.0",
> @@ -713,6 +716,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>  	},
>  	{
>  		.name = "qcc2072 hw1.0",
> @@ -808,6 +812,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = false,
> +		.advertise_iface_mac_pool = true,
>  	},
>  	{
>  		.name = "ipq5424 hw1.0",
> @@ -895,6 +900,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.advertise_iface_mac_pool = false,
>  	},
>  };
>  

