Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EFE136672
	for <linux-wireless@vger.kernel.org>; Fri,  9 May 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746806874; cv=none; b=RJw5ajAwdhgNBWTfHVkSGXRXYMPtH95P/1PkvKw6Mmnd5ZnP2znGnFpGEvmuW4wMdzRptKbGunEe3l9Uk/xKrvaeY8fqn4Bmu2UlrpJf0JqHV2sZFaSrik7aAs+YYZn3SMeYHzmkLazh3v/8IpSyv9aFgDQak46I5D3mAZzd8mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746806874; c=relaxed/simple;
	bh=Lm9XWegNjrsaFhEGJM/YujTWqIEzdJ4IAP/nE2jPUTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DSbdx+UCk5xFQiGfMCycOdLZRQ8gqmLwolZpCQ9qGoCgcgJDtQkuqNgEmTfPO4xHQQncKKU1ngAIEAsikLrR2viFahzoEoP3qXFwoXuTViBY/WQxkDGzVSJQ9vH7Gdfbh+m25i+iMuDh8++9SYDAZPTZkyaTJxh3o6FXGKCwKnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GBfNV7lO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GBfNV7lO"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 549Bw1nG016178
	for <linux-wireless@vger.kernel.org>; Fri, 9 May 2025 16:07:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dN6HcVUk9DFxo5EJlJc1UBo/NrapMDB33csra2IpO7c=; b=GBfNV7lOnDTXXxxb
	lhTm0XxDKtBIYwQ79D/t82pov/xLKosSTReKc3vokOlhSfQC0+gF1aesHg4NOkg/
	hJQe7zn/hHGtwGXYCSHjdLw2Fkqlm6+j4+vRNiRuZ8fDLLKMeF9oxGRNCj5tVKvr
	SW/zj2jbQ288/MdbcUhqhYTtH+uQVJZYev8XqZM7UIw5q5RkAF5f35DC2z8LljeA
	BAXCLts3ubJivDFzoWlG0ks/A12LPILKQTUTWhd131mzDY+oZq/OBm3gjIZFGD6z
	omC7B6IObasQ+Zn1psSzntogRPuHgmR94d+knGi4R7ObfyVSApeRUhm5eNUYg+FW
	u2CzXQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnp8w562-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 May 2025 16:07:50 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7401179b06fso2149499b3a.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2025 09:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746806869; x=1747411669;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dN6HcVUk9DFxo5EJlJc1UBo/NrapMDB33csra2IpO7c=;
        b=uF4qC0/sv14AVjUd/sR8PURByI+HGR2RxWOko4sHihXoGk5/9F+I+pavcIksUhPBJC
         W5B80dgNk/F9s0zLELelmBbYrt1DdH+JZ63fyG9fto6Ucn9IHNqsLvQxhPnTlRmiM1AO
         dvtxx3H4DxsluBGOc/7ni5wMhSGeipbZ00px4EebuzrQvYm0RZiFbmZifymBuDc75i1I
         ++FiYvZkBtmTsaVc2FR8/U9qlElzoK/5iMMIoyi6vp4gVhb6zYh6KohVgalf6LV5NOWw
         p59a1pBqpIjaXATnRShrL4KPnjb0mNv0ScHh1yBK5ucIIxKdY1/G2DFecUydSUhoVMkV
         4w3A==
X-Gm-Message-State: AOJu0YwcBIapz5nYNZ6AH/tH05F9nPYngj+s0aFk7guldmipLjvmZ2ND
	L3ylL3GaVu+0z1T1HaUMYKDS6EXBmyHz63dRF3Bdsch3YW4fbxYMqDGDNQu/RF8EsP2ytqlVwKA
	BrtkBN9PG5xLFI7bxaeEy5RGpdPuVh2UCokXkzJoH0JsBRwv2dwrScWt9h0KK5jEQBSozzRtfhA
	==
X-Gm-Gg: ASbGncs5kaAEfxL1DVVEeN657SZLBrp+scJ5MPZLM9neD783AB3kcVyOsRnqCtfzuHZ
	YpdxsIWla5JoMcPKOh4rAeBSmtH1RsW0vhTvDdTVnfBTO90ABUpUze2e9gns+TzVdVeHmjRn/sk
	6ouCJ07U0d0k1OfMvj9LPtH87x9afksy79PhaCPCn0XUyG/py0fNye2hHqkwhOAP3iqVJmwMIQB
	0SjdOgH4ZEb2loFtwOL613V93J9jLsasgKrmJc/zZoMt0TSk9dRhfBFdvOceu5gQc5v3FkNl12T
	FJQ47OvuSGhI17NTCPF+nS6K/mijXY13Km+tWiNyIhNjAl83GmaRXAZIGojKAZzV5YXMK0i9zXI
	AoGka
X-Received: by 2002:a05:6a00:84e:b0:742:39fa:13df with SMTP id d2e1a72fcca58-7423c061bb2mr5660975b3a.19.1746806869131;
        Fri, 09 May 2025 09:07:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq2z4W0Zc4/O/ESHS2E2kpfWTddtiwZqN4bqCv+BJNJBoRqAW4ZUvRY5SPSUTlIVZgKOsOlw==
X-Received: by 2002:a05:6a00:84e:b0:742:39fa:13df with SMTP id d2e1a72fcca58-7423c061bb2mr5660939b3a.19.1746806868700;
        Fri, 09 May 2025 09:07:48 -0700 (PDT)
Received: from [192.168.1.111] (c-73-202-227-126.hsd1.ca.comcast.net. [73.202.227.126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a0f141sm1902719b3a.117.2025.05.09.09.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 09:07:48 -0700 (PDT)
Message-ID: <9605558d-e785-4eb8-a752-1f591eff393e@oss.qualcomm.com>
Date: Fri, 9 May 2025 09:07:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: allow beacon protection keys to be
 installed in hardware
To: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>,
        Nicolas Escande <nico.escande@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20250421114711.3660911-1-karthikeyan.kathirvel@oss.qualcomm.com>
 <D9J8O65N947J.Y0LSNAOS0AYG@gmail.com>
 <57064b98-5950-4b9e-8d76-265e56127dd1@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <57064b98-5950-4b9e-8d76-265e56127dd1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: gJ5cg_KPGHV52TQS0OLotZJ25FShd8cT
X-Proofpoint-ORIG-GUID: gJ5cg_KPGHV52TQS0OLotZJ25FShd8cT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDE1OSBTYWx0ZWRfX29oZPPGUzoqq
 J44e7LdpJFhY6zVGgPFrbgUeGln0V7cYL/60pSLaCiitrlZGuKqMlzp6TC2yoczKMXu48d9y1OL
 cn1IEIXthZGG1A5MpnuFAIrzbrN8/cBBXdcmgvw8d04PeM8VYRGjt56AQGfhzzuAF+9H7CKuiiv
 UfXfqobWuumgDxY7gyY3T51wQ/EKmkejs/obu450QMhu+7ayUQidC0tMKefxWAx3V6lue15uUF1
 8fhiQwMw2aaupBCFSU6p+VZL0fpAL9DVws0jhzpq1TQZaZptKiQ4SdRQIQCFkFTzN1W1wjTFoZJ
 XV0BUGREOgjs02m1jSzq8BISyHCExy0mX37r4kOU1bygdbja2ysz7+X/EJ8DV3wIl2Sh4FxqhXd
 RzF27kKmsZVv/WNVX42qlaMGr1jPMVYqz6qJ9/ASZRKSnKI6R6A6QBxrvggfgeuqsNBSGntW
X-Authority-Analysis: v=2.4 cv=e/4GSbp/ c=1 sm=1 tr=0 ts=681e2856 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=e70TP3dOR9hTogukJ0528Q==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=qC_FGOx9AAAA:8 a=EUspDBNiAAAA:8
 a=4DEZz_zfAV2FwIUYn84A:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
 a=fsdK_YakeE02zTmptMdW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_06,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090159

On 4/29/2025 11:05 PM, Karthikeyan Kathirvel wrote:
> 
> On 4/29/2025 9:17 PM, Nicolas Escande wrote:
>> On Mon Apr 21, 2025 at 1:47 PM CEST, Karthikeyan Kathirvel wrote:
>>> Install beacon protection keys in hardware for AP modes only if hardware
>>> supports it, as indicated by the WMI service bit
>>> WMI_TLV_SERVICE_BEACON_PROTECTION_SUPPORT. Allow keyidx up to 7, since
>>> beacon protection uses keyidx 6 and 7.
>>>
>>> Control this feature by setting bit 0 of feature_enable_bitmap when sending
>>> the WMI_BCN_TMPL_CMDID command to firmware.
>>>
>>> Check for the beacon protection enabled bit in both tx and non-tx profiles
>>> for MBSSID cases. If set in either profile, enable the beacon protection
>>> feature in firmware for transmitted vif.
>>>
>>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
>>>
>>> Signed-off-by: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>
>> [...]
>>> @@ -4964,14 +4994,6 @@ static int ath12k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>>>   
>>>   	lockdep_assert_wiphy(hw->wiphy);
>>>   
>>> -	/* BIP needs to be done in software */
>>> -	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
>>> -	    key->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
>>> -	    key->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256 ||
>>> -	    key->cipher == WLAN_CIPHER_SUITE_BIP_CMAC_256) {
>>> -		return 1;
>>> -	}
>>> -
>>>   	if (key->keyidx > WMI_MAX_KEY_INDEX)
>>>   		return -ENOSPC;
>>>   
>> This hunk seems to break station mode on QCN9274. Maybe on WCN7850 too ? I see
>> that it was not tested against that HW.
>>
>> With that hunk I cannot receive broadcast trafic sent by the ap anymore.
>> Generated by a simple "arping -b X.X.X.X -I br0" in my case.
>>
>> Replacing that hunk with something similar as what is done in CLO [0] seems to
>> fix the issue:
>>
>> @@ -5575,13 +5605,9 @@ static int ath12k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>>   
>>   	lockdep_assert_wiphy(hw->wiphy);
>>   
>> -	/* BIP needs to be done in software */
>> -	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
>> -	    key->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
>> -	    key->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256 ||
>> -	    key->cipher == WLAN_CIPHER_SUITE_BIP_CMAC_256) {
>> +	/* IGTK needs to be done in host software */
>> +	if (key->keyidx == 4 || key->keyidx == 5)
>>   		return 1;
>> -	}
>>   
>>   	if (key->keyidx > WMI_MAX_KEY_INDEX)
>>   		return -ENOSPC;
>>
>>
>> PS: I tested that with firmware PCI WLAN.WBE.1.3.1-00218-QCAHKSWPL_SILICONZ-1
>>
>> [0] https://git.codelinaro.org/clo/qsdk/oss/system/feeds/wlan-open/-/blob/win.wlan_host_opensource.3.0/patches/ath12k/726-ath12k-add-beacon-protection-support-for-ath12k.patch?ref_type=heads
> 
> Thanks for catching this Nicolas, will check and get back on this

Will you be spinning a v2? Note the dependent mac80211 change has merged.

Also there is an indentation issue in the blob:
> -static void ath12k_mac_set_arvif_ies(struct ath12k_link_vif *arvif, struct sk_buff *bcn,
> +static void ath12k_mac_set_arvif_ies(struct ath12k_link_vif *arvif,
> +				     struct ath12k_link_vif *tx_arvif,
> +					 struct sk_buff *bcn,
>  				     u8 bssid_index, bool *nontx_profile_found)

struct sk_buff *bcn is not aligned on the (

/jeff
