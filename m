Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28653126C02
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789540280; cv=none; b=tt2bS6syYAlvs5dQ/ATU4izaZRCm7x8V5TzGHo3zhiEFVhJ1UAYFfTKQ6RQo9jdw4hgZmwq4oYaRJHTfO/DRyfWulhhOIkUZbfS96oyQPI9uk9lb/v9JlIri8KyFQwPDP0ISfeaPJHc34l5yMB5ZRTnVJ2r98JnE0kqusqz1/Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789540280; c=relaxed/simple;
	bh=ynW3OMuqFyhUg05yQbjn2RFM4f5Hh561rx1h+le1an0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CamdbhAzol5xcfxmBL5QWXhLkJz/wfEBoDi9S4roH7m6ZGmtkgNMM8tnkTBckZeplEF0Kzo/fmnwFAIXfEfur7Xe2eQkm9Bcmm3wMVw86fubR1yNh2ujTBS1HJ1S91CET6wV3R846AFJOHwMERvAzoZpK3LfkNrzI2Xbwe15LHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UM0xiyLw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YhpNSY5q; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UM0xiyLw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YhpNSY5q"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G698NI1830650
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BvE+1ily9WRpLiX7ByZ1lmquA+GohcfFipKt4On2X/4=; b=UM0xiyLw91WqKKtf
	mQqc3EchzzuobHRJCTNuRVTTmTMolyccj3DBoTRZNfmJ2SZ3YUzy7REBGEJtLHdP
	/KhAKfZcUk79PZAxpEIcByZnqBItR0tWcJ3+PP2tY4cQyryaZjJ2nU4Q2xs2nyIl
	r5PhKIdyP/Ia8JUboLTO3jyp10JIXhpRcS7NaDpWR13wcfBWMTTnYxu/2CWu0hJA
	NrWxx5L+N0rJU2MdKkytGdwj89TwpPZ84zUhJ4NbeV02AZBfK+PuOyse8lekviWm
	0ty35fG0pW3pwTLcuKIwsA6RP4qlLZVRcSXnvPtQumqT53scN3kjCfErSydkusrv
	8IJQSw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqah9trrp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:31:17 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39af92138f9so3195411a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789540277; x=1790145077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BvE+1ily9WRpLiX7ByZ1lmquA+GohcfFipKt4On2X/4=;
        b=YhpNSY5qfIS9FW3oom1ZauUU8yeBMdrABrVTYAtuhK2gQ2oVnPAngjDdHBQeqyaia3
         gAnuNb889S+EwpnEKu/2ZXt314obsLgjP3WYQq5b8+Y/wLm8y8Bzs3cRedxfvkmEe5yl
         B1UyXH9quUBEJiKsZvsAfNBFp/lK6F4sKuGxvjfK2l/554Uk65RzIdYl4hWz0OJkB72O
         10m2OjhI8akKekoWQ6Mx6ZJhkEvTm3FHdquiJvFYgKfeSp2n9+Hkm6lfjMkcGq8kt3MU
         miKzcBjGKl9TlIMY2QZ9iF7O56FMr/+L3VXXmX0DVLzdJurT71mEj1KJYSMSuhZvCIuZ
         qUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789540277; x=1790145077;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BvE+1ily9WRpLiX7ByZ1lmquA+GohcfFipKt4On2X/4=;
        b=t8UGgslGHORJ0hHvbCE51cuXdKZEk+Q9sbrVe6/5cXZ8cMAeH/dj9kljLm/FFdqKd6
         BnxA2Z6eg0ykWXiOTKHp72ooQP8UkxKlQRJ/Hc1pMdwG4uwybH3KhcQIUKMdTg2kqusz
         Z6gd4ExLCAPRyHucv9RE38t3DtUrGXztgsK5/fTzHx0stof/TT0HvtmZW+hD+Sfv1SjZ
         Ey2oL34U3E89NnhQ3aazWuKAt4TtXQV9nGy/njnyDfjcKuicDN8wnXHqk0yPKyBMqhJ0
         o14/SNXsBe3y+4RpyelzBLXvpk5tzTJ5vlgPI3e0+6575/Xmuzg6DrmO7MnKtj5LFAEA
         L0lw==
X-Forwarded-Encrypted: i=1; AKwUvBysakO1WljKJf1jZyvPNdco/sgTmboXIR+0WagZx3OwCxm1qmgzBXGf8DlRV0gTHt262/Uy/puA4Zd+woYp3A==@vger.kernel.org
X-Gm-Message-State: AFuF++mhHJUmf41+Iy9G0PD9FB4rLilhUYWLehbYbYvGxcI4T6vWDsvb
	gzllBpTLs2/khXN8QTF77D9pckEvLJGKd7z2UNIMwsN0cBAtFANVNAxG4IZOSD45tpCCZMk42ua
	CtT1bGr3f87a/3JFy5HIMI/5FiYzZ2dN9d2/1BNK+jo0M2jtEcJzm1FGbogPWTqv2KG47zzmYWo
	ts1Q==
X-Gm-Gg: AYBFou1lFpSJm0PDRlaOle/L9C+1qno3o1yz6GNwUo04QUTEhbPoUawqlxHghy146Yb
	mORQ/eU96kTqKkkdyDll4f+u6+SzapsHM8QJ50bZ+K+YX3OUsdY0rI5HKm+LIgjYY5lH3zbGLwh
	8HdwwJATlNiplTgpvYqE1eCA4GEk31dX0iD5riaxPyFufF2h+RBjNzf1eJIblTEM764Nh+zR7R+
	AA4MWikVJJnhI+2iEmKDwk15H8Elt0ohVS0W13lZWP+hWUHw4NOx4pB5TEGXt9PxY6LsIaiSUbT
	DlzRCY06nFDzeOnN+KyvWKSs9g/dIhOcHj1HD9c0jfTkRF4CJjmfTgrvivP4etFbRJiNJ6yeoq0
	tMUrD1iI1sobm+5Dk9uVJHrDAlh+ZcNwzpzAgYLxGlqR3OfsX0MwvETkZzw7XbEg7Az1ck76x
X-Received: by 2002:a17:90b:4e88:b0:39d:fea0:33f3 with SMTP id 98e67ed59e1d1-39e1fecbd80mr1528506a91.2.1789540276736;
        Tue, 15 Sep 2026 23:31:16 -0700 (PDT)
X-Received: by 2002:a17:90b:4e88:b0:39d:fea0:33f3 with SMTP id 98e67ed59e1d1-39e1fecbd80mr1528481a91.2.1789540276174;
        Tue, 15 Sep 2026 23:31:16 -0700 (PDT)
Received: from [10.133.33.84] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1bbdfd89sm2763789a91.9.2026.09.15.23.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 23:31:15 -0700 (PDT)
Message-ID: <976d2e23-1ce9-4877-8241-bff04226554b@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 14:31:14 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2] wifi: ath12k: provide MAC address list for
 single-radio wiphys
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        kang.yang@oss.qualcomm.com
References: <20260915152815.254016-2-ivitro@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260915152815.254016-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BtkIUoX5 c=1 sm=1 tr=0 ts=6aaa37b5 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=m8ToADvmAAAA:8 a=wblLnW-cDSaZONvgar0A:9
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-ORIG-GUID: 8aDYkUKRmfbPEymAm1ETryRM2j8hH6Es
X-Proofpoint-GUID: 8aDYkUKRmfbPEymAm1ETryRM2j8hH6Es
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA4MiBTYWx0ZWRfX8loyxURfKk/H
 bK7ho6z9nfLsmk8t41CWyG4aiy4Tag3ma73oMrBAXPVP5Kgy/jw8rfXXb3D2QXlIUDmE0V64jgH
 4r0NYDfoNZGYbIVaerB19pln2m3DpWi486lv9JT8cU/c0dtXcgmjW5W0PnIGsjk+km+gOTPJ+dE
 i5je8HmDpiwShwL0vbg4FEUHZoGuAa3DECD/YhJCtbDVLLf7L3nQedu1EUUWma8ybtz9I5UTNMs
 U5P2lFCiiUK/XnZueq/FAcwOVmWoKBCg95dfvvDs+PtpeljOQJrltrz+6ZXMirH/YZnUYu5wGHd
 78kI+FB4gGm36tyMUGa9yaYZtAABQ5q/zZNLi7v25rD0+3InsYd+f85aPWLsjkNtzWjgOOfBIn+
 7+a2yKcTzGT91WEXbGHBmxw8wiy2phGxrlCVnkbflSY2CpT1LouVP2P/VA2OIe4mCrqrztQSEyn
 Lc9GRf/0e0hCd/miBeg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA4MiBTYWx0ZWRfX1qhlNOlFuPpT
 Aon+QW0fxN2/+akLPwmocSr0JsPdqOAsnfJ2MBc72rFjm89iRWmhnghs8F+z52uVEJfbiufsUty
 PtIQzm2aOXk+ya5EBIv1SdzMB1ygS/o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160082



On 9/15/2026 11:28 PM, Vitor Soares wrote:
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
> Keep the first entry as the radio's own MAC address. Generate the
> remaining entries as locally administered variants by changing only the
> upper nibble of the first octet, which naturally limits the pool to 16
> unique addresses.
> 
> The wiphy->addresses semantics are hardware-specific in ath12k: some
> platforms use it as an interface MAC address pool, while others use it
> for firmware-provided per-radio addresses. Gate host-generated addresses
> behind host_alloc_iface_mac and enable it for WCN7850.
> 
> Handle only single-radio WCN7850 wiphys. Wiphys with more than one radio
> and other hardware families behave exactly as before.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> ---
> v2:
> - Gate generated interface MAC address list behind hw_params
>   host_alloc_iface_mac, as suggested by Kang Yang.
> - Enable it only for WCN7850, the only part available for testing here.
> - Add Assisted-by: tag.
> - Link for v1: https://lore.kernel.org/all/20260902082219.3010793-2-ivitro@gmail.com/
> ---
>  drivers/net/wireless/ath/ath12k/hw.h       |  1 +
>  drivers/net/wireless/ath/ath12k/mac.c      | 52 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c |  6 +++
>  3 files changed, 59 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
> index 011bb22e21c7..03cb35071e0b 100644
> --- a/drivers/net/wireless/ath/ath12k/hw.h
> +++ b/drivers/net/wireless/ath/ath12k/hw.h
> @@ -238,6 +238,7 @@ struct ath12k_hw_params {
>  	} client;
>  
>  	bool host_alloc_ml_id;
> +	bool host_alloc_iface_mac;
>  };
>  
>  struct ath12k_hw_ops {
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index d4116ba0da08..45be5b08aa40 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14743,6 +14743,54 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
>  	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
>  }
>  
> +static void ath12k_mac_cleanup_mac_address_list(struct ath12k_hw *ah)
> +{
> +	kfree(ah->hw->wiphy->addresses);
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
> +	/* The pool is derived from one base address, so it can describe only a

networking code prefers that the first line of a comment contains only '/*':

	/*
	 * comment starts from this line
	 */
> +	 * single-radio wiphy: with more radios each radio has its own base
> +	 * address, possibly from a different ath12k_base.
> +	 */
> +	if (ah->num_radio != 1)
> +		return;
> +
> +	ar = ath12k_ah_to_ar(ah, 0);
> +	if (!ar->ab->hw_params->host_alloc_iface_mac)
> +		return;
> +
> +	/* Only the upper nibble of the first octet is varied, so at most 16

ditto

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
> @@ -14762,6 +14810,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
>  		ath12k_mac_cleanup_unregister(ar);
>  
>  	ath12k_mac_cleanup_iface_combinations(ah);
> +	ath12k_mac_cleanup_mac_address_list(ah);
>  
>  	SET_IEEE80211_DEV(hw, NULL);
>  }
> @@ -14878,6 +14927,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  	wiphy->available_antennas_tx = antennas_tx;
>  
>  	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
> +	ath12k_mac_setup_mac_address_list(ah, mac_addr);
>  	SET_IEEE80211_DEV(hw, ab->dev);
>  
>  	ret = ath12k_mac_setup_iface_combinations(ah);
> @@ -15120,6 +15170,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  		ath12k_mac_cleanup_unregister(ar);
>  	}
>  
> +	ath12k_mac_cleanup_mac_address_list(ah);
> +
>  	SET_IEEE80211_DEV(hw, NULL);
>  
>  	return ret;
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> index a20c21807344..8658828ea47d 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
> @@ -445,6 +445,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.host_alloc_iface_mac = false,
>  	},
>  	{
>  		.name = "wcn7850 hw2.0",
> @@ -539,6 +540,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = false,
> +		.host_alloc_iface_mac = true,
>  	},
>  	{
>  		.name = "qcn9274 hw2.0",
> @@ -629,6 +631,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.host_alloc_iface_mac = false,
>  	},
>  	{
>  		.name = "ipq5332 hw1.0",
> @@ -713,6 +716,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = true,
> +		.host_alloc_iface_mac = false,
>  	},
>  	{
>  		.name = "qcc2072 hw1.0",
> @@ -808,6 +812,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
>  		},
>  
>  		.host_alloc_ml_id = false,
> +		.host_alloc_iface_mac = false,

QCC2072 behaves like WCN7850, so we should enable it as well

