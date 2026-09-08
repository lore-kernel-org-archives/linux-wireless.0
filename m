Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3F1371860
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 07:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851908; cv=none; b=NTtah2HjOTjAZSmguW8q637a/+QXmLsHVJ0XJA0k2I/FBqZORouu2DMNGwuDwif+LTmZnZpBxsznn/lL57bR5T4pKahsdN9MDFnclkrW5geIeYXPGPFs4XqITTZjpdnSQ7FBvAKfjs/C+4zexEb3hVZE9vh7+JOC0PeCqlw43KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851908; c=relaxed/simple;
	bh=awNKVpbba7txbNiZHCmEdrhtU+RGi370afg+wtscxlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AiWWu+ifvJAdXbWQbAFuVRyO7A02addHlGSeP9x9r+g5b3aMXFMNQEU9OlL0H9OwGijGZp5l9lSdfTD5nj2fanXeaOLW7bllw3RNKHnqLgdZWXYZHcA1LCylaqWU+5xebg/kVct9J4W9LTZTdJZ707jxel5xzlR+4Iu82Q7bRxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ndUbY35u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JJgS/4FG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ndUbY35u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JJgS/4FG"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6886M28i2712396
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 07:18:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yySNJ2c/T3/7UiSJLByUZbtOSSdVDE444k2LE0ArApM=; b=ndUbY35ug66347vF
	2aF7dQwPlR5/Fa5aKgu/jzPrfxpDnTj274Fpp6b40pAGHDftnf5yuCd7I8zb8RGg
	m6utY83nJS95l2aFLRO26vGp+jEgYDPEIr/kG3KKfKKtjz98zh5Q31F+WH7grfGt
	GvmTdzGL8RjQkPta3mRreaJpjqUVJLGG3FBk+uhpaTyfUzZOdVSWDSz8SPFkMMiU
	crMj9P6kDsDQYnQ1k1TM1IWmvgVE+Kk9kXPjBMJbTohBGCELaKD/d9dvRUgDZ0fP
	gvyRWiL4boxFJLAQ3n390Zxo2sVAZ3R76gKefFW67wAHozIIvQUWbk3Yzs+xJ4Ge
	IClpGQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghtdqm0f5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 07:18:25 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2db050d469fso25322015ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 00:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788851905; x=1789456705; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yySNJ2c/T3/7UiSJLByUZbtOSSdVDE444k2LE0ArApM=;
        b=JJgS/4FGlG/1UzDCuXRv1Ygfui3srxFvMALo9l6Min01o+rglLDxeCNOGl765gNAq3
         yIwCDOTGLTIAfm1YjlDqMhDWpdSlxLKdhDoL+8OffA2bP+4YproT1nQD3W2Jf+tdUzNP
         7A1xcARKUJe7xURuv1oASTMhDJelWnnVekQNuYdYo7nDhTpVWBhQ5a3FNcHfKUglX4H8
         cRsYu5iFPr2OB1jeNxKNakV7w74gBEysOFT49MiGgo2oMLPEfJg9XihrIE72zUmbani1
         Hw4/ln/h5+FIN7x09+2TfBeKOjXFmFP8H7zLk+Iebke0+qUI3lPQVNkl3AmTs2X7hpGK
         TEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788851905; x=1789456705;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yySNJ2c/T3/7UiSJLByUZbtOSSdVDE444k2LE0ArApM=;
        b=noT1zcDBrJdsSQQjuYCTT8QcMcj+GV+6AYaBJv+KhLw9UyJ7cOCa3x8+TsQxQn28zi
         rH0RfRB5gsK86jGLUgNH1ySgwARMssazGErPkk46QfmhUmhEYnO5v1orsFYF/gtYNeGF
         6ykZck9XKr5YHlZNPYifvV2SuS+mP2VB2PfMHbv3Pf9fWiOvsCRS/sVPalHQJt2Dwzwx
         edf16uQE9oS/97itj/kwHsEgzMs5soNRqQ9sPgbQwNuJQ93SUCpoU5D1S1wsryOiRUqw
         38e8VpXSoXEhqVhKNInAdqBK5yCjZeqw+ARQ/y6yCsfT9X7h9P95FPyas1tdF3H5gIfh
         vpdw==
X-Forwarded-Encrypted: i=1; AKwUvBwxsmPKcLJ18rc2gtOx+C8WYNQ4WcKuksXnkKqZrfoXd7FGumulioloZrU/yeCv6QtxvRnjL4eXljmGb+8JZQ==@vger.kernel.org
X-Gm-Message-State: AFuF++m9n+PAnYTT0lY82HxUQcRUKLmiKynZqX9+DiYt9Jmn/XYICGaS
	QSA9PpSaunZlNKtY48vxPNTPxlHW7BUXN8KBxoMwKDBIfqb3VHs6AkqNIO7WF6JYQAVOrhKLO9/
	q+Y8g/YLs6Ln917HPF86Av2zNBTsGt999WfQUNH61Q5WTMKrVT2p7ho6ZTpLWhPd21Z9FQw==
X-Gm-Gg: AYBFou2ZBPM2zZG5avaYEV8F1a/+O8mp8MaiPKqy5EupNPziU0lQnQ8IoibSLps4qNq
	fyLlpHHSf8ZNoHpPJZoTDTFG8uVlunhP/7YdV2cE4auG9XtAHKtF1r3EMS5mIc2Dmj4S/Iz4Zsx
	c/twojHIW66n5Osaud7gzd9dA8dVcjT+AA4lp2WntXv2iWojA0MlUjiXKTNYx9F5toIqELyCAxe
	FzerFn+W55rFlUEA9IJMEBwlY6qgyPPKmv720RDAQu0IOVkWgp3A0AwGV+7FyNiceE1z57uSHKs
	bDxnV1PDu1BQqSOcnkWaAIW7M4jeW3YFC9EL5gx7idpxGNVCnoE1XAs/ljR4Hr+jeLO6NrR3S3m
	+adxQCCmgtbYbrw0GsdORKDKrbIcf+X3PE5eHLKRsvOQP2tSPKQ3Hgiqw9WLRkZGhS6K6JIk=
X-Received: by 2002:a17:902:d48b:b0:2d8:d4d2:d139 with SMTP id d9443c01a7336-2dafb1820bcmr307986975ad.21.1788851904561;
        Tue, 08 Sep 2026 00:18:24 -0700 (PDT)
X-Received: by 2002:a17:902:d48b:b0:2d8:d4d2:d139 with SMTP id d9443c01a7336-2dafb1820bcmr307986695ad.21.1788851903977;
        Tue, 08 Sep 2026 00:18:23 -0700 (PDT)
Received: from [10.133.33.87] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14ae36adsm53287175ad.76.2026.09.08.00.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 00:18:23 -0700 (PDT)
Message-ID: <54f89935-526c-4582-a8ca-4f645257db53@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 15:18:20 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: provide MAC address list for
 single-radio wiphys
To: Vitor Soares <ivitro@gmail.com>, Jeff Johnson <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260902082219.3010793-2-ivitro@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260902082219.3010793-2-ivitro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDA3NCBTYWx0ZWRfX+wDqmHRifiTy
 EFJM75RaFm98kT7DU6SHqE3FSr66h4lpps8DgocKx9OFgO9U3wuJWVlcLGHttnH2aj8O0m4XMof
 I7ENyJ1JtuVrDQYiM9hU1aYvVHDvZSz1yRRNTUfQmXVedSnGVQjyvUTYBn1lCsrhI2eb4+sFu+B
 rNK2G0zxe+lICHxpj4Ptf6kguG/Z/k9Q88ZZBqUaf5GMNO1293CeFRY+qcvlHL+Wv9Nbsf4nihk
 hvPGFCNcDghX2vj2S5cTEwYMVc646O29PLqQ5Q3MAXVjd9U0PraW4xUqUqVFJ1m05Isj7USw6yt
 VojtppqN00WzUCDw/PgT3m4wlhUBzCkObZPmurt8Mc3iPkKltd7WnG+3Y2yoJgbCDLvKpXof2a+
 mgPv+utYcP1ReGNkkK9SNUUbFuGsKWYTdC7eMqAj64jQssIVjPAS8oypzrTh6axso/q3kB+++Ye
 5TTZktXOulZKOQCVP8Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDA3NCBTYWx0ZWRfX5ZywT/F6leYl
 YikYPlOdmVI7ds6ECBktGkSBpbSZiMLs++INMRq3pbjT0vTRrWnUFyK3vejCwM3tA09VyvGkEx/
 k2atvcZGfWy/BWV6pKptFgbOvlI/QkU=
X-Proofpoint-ORIG-GUID: TwAlCPJLYIgQoTJwLaYsxmibdTpZZln4
X-Authority-Analysis: v=2.4 cv=U6aiy+ru c=1 sm=1 tr=0 ts=6a9fb6c1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=m8ToADvmAAAA:8 a=8dmAZdvqxf5LAHb2O34A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=kCrBFHLFDAq2jDEeoMj9:22
X-Proofpoint-GUID: TwAlCPJLYIgQoTJwLaYsxmibdTpZZln4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_01,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080074



On 9/2/2026 4:22 PM, Vitor Soares wrote:
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

We (Qualcomm) ever internally proposed a similar solution, but it turns out to break chips
like QCN9274 etc. I have forwarded this patch to internal developers, will come back once
get a conclusion.

> Handle only single-radio wiphys. Wiphys with more than one radio behave
> exactly as before.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> ---
> Note that a device which is not MLO capable registers one wiphy per
> radio, so each radio of a multi-radio device also gets a pool, seeded
> from that radio's own MAC. I only have single-radio WCN7850 hardware,
> so that case is untested.
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 48 +++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 9a775602775d..bee6701f1029 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14685,6 +14685,50 @@ static void ath12k_mac_cleanup_unregister(struct ath12k *ar)
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
> +	struct ath12k *ar = ath12k_ah_to_ar(ah, 0);
> +	struct mac_address *addresses;
> +	u16 n_addresses;
> +	int i;
> +
> +	/* The pool is derived from one base address, so it can describe only a
> +	 * single-radio wiphy: with more radios each radio has its own base
> +	 * address, possibly from a different ath12k_base.
> +	 */
> +	if (ah->num_radio != 1)
> +		return;
> +
> +	/* Only the upper nibble of the first octet is varied, so at most 16
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
> @@ -14704,6 +14748,7 @@ static void ath12k_mac_hw_unregister(struct ath12k_hw *ah)
>  		ath12k_mac_cleanup_unregister(ar);
>  
>  	ath12k_mac_cleanup_iface_combinations(ah);
> +	ath12k_mac_cleanup_mac_address_list(ah);
>  
>  	SET_IEEE80211_DEV(hw, NULL);
>  }
> @@ -14820,6 +14865,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  	wiphy->available_antennas_tx = antennas_tx;
>  
>  	SET_IEEE80211_PERM_ADDR(hw, mac_addr);
> +	ath12k_mac_setup_mac_address_list(ah, mac_addr);
>  	SET_IEEE80211_DEV(hw, ab->dev);
>  
>  	ret = ath12k_mac_setup_iface_combinations(ah);
> @@ -15041,6 +15087,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  		ath12k_mac_cleanup_unregister(ar);
>  	}
>  
> +	ath12k_mac_cleanup_mac_address_list(ah);
> +
>  	SET_IEEE80211_DEV(hw, NULL);
>  
>  	return ret;

