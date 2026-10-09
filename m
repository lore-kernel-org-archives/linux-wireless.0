Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56154D90C0
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550081; cv=none; b=dDBK2QEESD5L8DJN/7YFQx/JILSHRM2zR1w6E6gd6RL3hK6fy22TN/elIVbKERGCI3szdeeyb6cNBxRfRD5RljTXDWtNHlYlIEjdeZNYF5WfLn8m0OuF7cu97sDzib7qYma5gp9IGAW5qoDmtnhkp1AY93bqiX+QERx/1jlknJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550081; c=relaxed/simple;
	bh=TnhmdYIAiJzst2gnSrwSJsqAlKKP3Je4JEHX9L3UYXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nl7pwSiaHdTDkOtPPY2jlX4Md4gj48ZnBhlAur/6o8sfPoLM0UVq1n4ZSsxJTSe0UQfAB4ovyY8M4G8OUvqLl7GH9lsMGaEQ7+II3VtNFy/QJqgqT09X2tVDmpPqmpkqq7C4D+4KpSgScALjdUHfgx5IHAdfY7xlb8qQ2KXlQ9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ETTsiKKO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N4TtWkR6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ETTsiKKO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N4TtWkR6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KGrq1625870
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 12:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fi4Lenn/1HZ0mxBvi7sIRJ9/Q2Lyl9RNPe/iy0qSU/s=; b=ETTsiKKO6gTMSJVO
	foMa9llGuTpv+YPo9x6ikH08/PIp026BhF8Nw9sPi1CeC5NIV7irWXvmt8aQpTgK
	vrw4v7OavA2SPTN8nWVZH9lXHatMXDmKrKHSj95psLyYfEtgwVJKMoF6I48jtK2b
	6j3ArriPMxPSK3H1bTM9HUgtQLpiE3mGBXgiMNKU6oScjZeazyD0IszCjdTZZHyt
	tpuL9r6E0fkrKX7ad+90wQ8ixkoDsFZ9gpbsID2ioOJWJBFXkCt+hb4EEyXW19wl
	rfyq3YIxv3e+INNQVaj37OKkE1L89HatNLWfV9YssgIXTGPIvwovTu8uPVmEGawZ
	s9XGcw==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fyj3hjn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 12:47:50 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6df3bf8d029so8132794eaf.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 05:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791550070; x=1792154870; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fi4Lenn/1HZ0mxBvi7sIRJ9/Q2Lyl9RNPe/iy0qSU/s=;
        b=N4TtWkR6FxBTc/Ihso6eJSnH8hUR02SiLWiColVD3wSWn4VE6gNpHA9SSBe8WeDOTq
         M9aFUjx/R6XSRyrvNo2s6upXIanshcRu4CX83d6lCT+FlHzh4kQwAuRYUivjv3Tp+LSF
         rdBYAxmTnE9TaQI4AgNqJjGSLXX/Q5uICnRiB/6fgfFv/WFrqdxj3w31oA5XIcBIbM9x
         EdQwCv4cruJGFqbRpilqGq5YbaPmYP/4iqOQm48WlaSRu610fiOK2i/TAZUpInThiF0K
         TB6upA1CnrGmNrZ2m9REDEquIb9RWZUfTI3j/UwRzhIpjtGJ7McDvXwsvzzyzjGm5GLx
         B05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791550070; x=1792154870;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fi4Lenn/1HZ0mxBvi7sIRJ9/Q2Lyl9RNPe/iy0qSU/s=;
        b=voKiabiCWlu7/JtMRPCqqObIt9zpMZ95aEWKG4igrWbxZjzPJdj+wh60p1KZV6tK7A
         1QYlyPftZjPbXm7SppGmE2SX7poCbfhQRg2Cs5w+99W6ChPj6GeZWh3+PnHwrEJ2MeHw
         Gs68Dd7Vu3x+5Ag8+/5IEho9b3HIfkBneCec+LNmoAAAy8UnNpkH8NJbwkg/BsRBGWe4
         YwBWS8LNBnEJ7PWIyNY/cB1rH7i4Yi+7fxa8W+Q6yNeskuFE0tTsT/3YbDfbXzZiXySQ
         HmrYnDLQCIzyYp4z/D4CWgPyJ8dmbVbt2rdCeU2M3QG2xc3YSrT1efZDdm0vYs0i4bBF
         B8bQ==
X-Forwarded-Encrypted: i=1; AKwUvBwy3Jone4zA+oNorHrpYYFvMzhA/0inHFbUYMGfBfYjrOtE0sH05cwL0rjgeMjsXxmpPwIeGCYShD9fnXOWgg==@vger.kernel.org
X-Gm-Message-State: AFuF++ku+OfcGTCUg5lZRo8wKzLKR7rOzUES/6rnYPuH6c+oQ5RA98nT
	S0XJV+TwisM9/dH/nvJdkx+zOga7zNVCmXOrw41kFJP+uJNsMtYkzmlV93XssMu6zrD3joE1kx9
	39hoMghx7kFEEE28gNTDaWdUk+owxe0HhkMMKmUkyIv6f5rP6jIvC/H70UTADECJ6Tq6f8/sM7u
	nqLw==
X-Gm-Gg: AYBFou2x9umDuE9qZTx8/blGiHgYVc2Uu3dP3qblz5CRnGpXp0DFe1F3rkwD6j0D7ZG
	NgVYLj7uOLc6cGLF28rACSPqSQGLA8TsswnhAVzXQ/VBRXi0X0x3mP4iLnxGuKT+he+9dPOJlqV
	D2rwp3uc4/0NpTa/vcjUVnQKn6+FbrsHZOlkULJ2d5f7vy0x5IYI1FtJx3lj5gTTG6a+xAEIUmj
	igGdq8sKUmGdEb33qJFpzaHIl0GRkMDw+PlA1gH7O85gXuEUumFmRhMjjHOpaPM7/phrb1qc/IM
	hnHhXegSe3Hn08EGDQBknJKNyWLG3L4QPPP7WLiITeDKKCs20T3y0BCniWfhaGB6YlXeK2r4Esy
	CHRU+iEMzRZEl8vGz4qYni175p+okqG0=
X-Received: by 2002:a05:6820:1519:b0:6d7:deb5:b428 with SMTP id 006d021491bc7-6ef11a3171bmr1141183eaf.70.1791550069767;
        Fri, 09 Oct 2026 05:47:49 -0700 (PDT)
X-Received: by 2002:a05:6820:1519:b0:6d7:deb5:b428 with SMTP id 006d021491bc7-6ef11a3171bmr1141173eaf.70.1791550069214;
        Fri, 09 Oct 2026 05:47:49 -0700 (PDT)
Received: from [192.168.0.104] ([139.227.98.172])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a2a86317a5sm1550324fac.17.2026.10.09.05.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 05:47:46 -0700 (PDT)
Message-ID: <61633969-9a1b-4613-9fa9-fae978159d11@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 20:47:39 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 ath-next] wifi: ath12k: Add EHT capabilities to scan
 probe frame
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, baochen.qiang@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
Cc: gaolez@qti.qualcomm.com, miaoqing.pan@oss.qualcomm.com,
        hangtian.zhu@oss.qualcomm.com
References: <20261001083940.3051840-1-gaole.zhang@oss.qualcomm.com>
 <93d5fc5e-8174-40ea-9fb0-7beca2f37aa9@oss.qualcomm.com>
Content-Language: en-US
From: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
In-Reply-To: <93d5fc5e-8174-40ea-9fb0-7beca2f37aa9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=BfpNQbt2 c=1 sm=1 tr=0 ts=6ac8e277 cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=I+RT22yiDMp2GQVHM3N4LQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=O0upp9YDQ7zQVZpXey8A:9 a=QEXdDO2ut3YA:10
 a=k4UEASGLJojhI9HsvVT1:22
X-Proofpoint-ORIG-GUID: x3FJacAmA9kpL84_UqFmtiUYJCQ2cQxf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1MCBTYWx0ZWRfX6atPsifEW958
 eeEqlvVgHfnTfsDfDNxkPHvcMAqc/JR7x1u6NF/OKX0UK+2etyuv5KOWKjtvAynoTEoO7K7Q4KH
 WHntMuvDIydnnUCMvWBB6n2SggRwhdpLSNKsKCembPCu3FsImzT/Vryc+8X13OFGfjrwz1/+tZZ
 Q6RR2O0BIdqGdNvE/52hAFoDfL69wUmvrUss5clQ5uRaHyJZ2puv8EK21utQktT41K7PSrU6g8r
 Qrv9mVOfH7WK7Sa88nvY5eZtcJ/cgfA3XZK4MEdp7qN+w+xv18mB1qQ9kOw5f7EZfX3cXIj+Kw3
 fAPD9SK/jhhPjXjyYAldDsk5CoVUSi98MOlxkWzLHLMVSi1Dx4UosMa0W7OYtIukzWoykLbLLcA
 n5DiNDGAzLNwnRrY+8T37/0ttDfW4abYKwCeVBFOiMxAIBTodJVrA3cZrDaQOQDgaMwB4vjZ/iI
 j4siDraKiANLhiSKlSg==
X-Proofpoint-GUID: x3FJacAmA9kpL84_UqFmtiUYJCQ2cQxf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1MCBTYWx0ZWRfX2zdeS9gymOML
 s1b++gArGVWMiivITDDCgX1IzPec7boBV05fPH6prj9MF1Nh5xmZI9PDdkEwYQPeJqWqW6g7bxz
 BylgcTv9f5GmcESZsH6bNK9/8iTlyw4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610090050


On 10/5/2026 2:50 AM, Jeff Johnson wrote:
> On 10/1/2026 1:39 AM, Gaole Zhang wrote:
>> ath12k hardware scan Probe Request frames do not include the EHT
>> Capabilities element. Without this element, an AP cannot identify the
>> STA as EHT-capable during active scanning and may omit EHT-related
>> information from its Probe Response. This can result in incomplete scan
>> information and prevent userspace from correctly determining the AP's
>> EHT capabilities.
>>
>> For firmware to include the EHT Capabilities element in scan Probe
>> Request frames, two conditions are required:
>>
>>    - The scan channel must have WMI_CHAN_INFO_ALLOW_EHT set, which allows
>>      firmware to add the EHT Capabilities element to Probe Request frames.
>>    - The EHT Capabilities element must be configured on the vdev through
>>      WMI_VDEV_SET_IE_CMDID, so firmware can use it when building Probe
>>      Request frames.
>>
>> Set WMI_CHAN_INFO_ALLOW_EHT for channels when 11be is supported by
>> firmware and not disabled by ACPI. Also configure the EHT Capabilities
>> element before each hardware scan when the element is present in the
>> mac80211 scan IE buffer.
>>
>> Firmware retains the configured element in the vdev context until it is
>> replaced or the vdev is deleted. However, ath12k scans may either reuse
>> an already started vdev or create a temporary scan vdev that is cleaned
>> up after scan completion. Sending WMI_VDEV_SET_IE_CMDID for each scan
>> request ensures correct behavior in both cases.
>>
>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>
>> Signed-off-by: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
>> ---
>> v2:
>>   - Clarify the firmware requirements for adding the EHT Capabilities
>>     element to scan Probe Request frames.
>>   - Explain why the EHT Capabilities element is configured before each
>>     hardware scan, covering both reused vdevs and temporary scan vdevs.
>>   - No code changes.
>>
>>   drivers/net/wireless/ath/ath12k/core.h |  6 ++++
>>   drivers/net/wireless/ath/ath12k/mac.c  | 29 +++++++++++++--
>>   drivers/net/wireless/ath/ath12k/reg.c  |  4 +++
>>   drivers/net/wireless/ath/ath12k/wmi.c  | 50 ++++++++++++++++++++++++++
>>   drivers/net/wireless/ath/ath12k/wmi.h  | 23 +++++++++++-
>>   5 files changed, 109 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
>> index a98fc6e0699d..e7373a523dc3 100644
>> --- a/drivers/net/wireless/ath/ath12k/core.h
>> +++ b/drivers/net/wireless/ath/ath12k/core.h
>> @@ -1394,6 +1394,12 @@ static inline struct ath12k *ath12k_ah_to_ar(struct ath12k_hw *ah, u8 radio_idx)
>>   	return &ah->radio[radio_idx];
>>   }
>>   
>> +static inline bool ath12k_is_11be_enabled(struct ath12k_base *ab)
>> +{
>> +	return test_bit(WMI_TLV_SERVICE_11BE, ab->wmi_ab.svc_map) &&
>> +	       !ath12k_acpi_get_disable_11be(ab);
>> +}
>> +
>>   static inline struct ath12k_hw *ath12k_ar_to_ah(struct ath12k *ar)
>>   {
>>   	return ar->ah;
>> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
>> index d4116ba0da08..f353af63c5eb 100644
>> --- a/drivers/net/wireless/ath/ath12k/mac.c
>> +++ b/drivers/net/wireless/ath/ath12k/mac.c
>> @@ -5602,6 +5602,25 @@ ath12k_mac_find_link_id_by_ar(struct ath12k_vif *ahvif, struct ath12k *ar)
>>   	return ATH12K_FIRST_SCAN_LINK;
>>   }
>>   
>> +static int ath12k_mac_set_scan_eht_cap_ie(struct ath12k *ar,
>> +					  struct ath12k_link_vif *arvif,
>> +					  const u8 *ies, size_t ies_len)
>> +{
>> +	const struct element *eht_cap;
>> +
>> +	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
>> +
>> +	eht_cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies,
>> +					 ies_len);
>> +	if (!eht_cap || eht_cap->datalen <= 1)
>> +		return 0;
>> +
>> +	return ath12k_wmi_vdev_set_ie(ar, arvif->vdev_id,
>> +				      WLAN_EID_EXTENSION,
>> +				      eht_cap->data, eht_cap->datalen,
>> +				      WMI_SET_VDEV_IE_BAND_ALL);
>> +}
>> +
>>   static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
>>   				       struct ieee80211_vif *vif,
>>   				       struct ieee80211_scan_request *hw_req,
>> @@ -5718,6 +5737,13 @@ static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
>>   			goto exit;
>>   		}
>>   		arg->extraie.len = req->ie_len;
>> +		ret = ath12k_mac_set_scan_eht_cap_ie(ar, arvif, req->ie,
>> +						     req->ie_len);
>> +		if (ret) {
>> +			ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
>> +				   "failed to set eht cap ie, ret %d\n", ret);
>> +			goto exit;
> do we really want to bypass scanning in this case?
> would it be better to still scan, just without added capability?
done on v3 patch
>
>> +		}
>>   	}
>>   
>>   	if (req->n_ssids) {
>> @@ -8983,8 +9009,7 @@ static void ath12k_mac_copy_eht_cap(struct ath12k *ar,
>>   
>>   	memset(eht_cap, 0, sizeof(struct ieee80211_sta_eht_cap));
>>   
>> -	if (!(test_bit(WMI_TLV_SERVICE_11BE, ar->ab->wmi_ab.svc_map)) ||
>> -	    ath12k_acpi_get_disable_11be(ar->ab))
>> +	if (!ath12k_is_11be_enabled(ar->ab))
>>   		return;
>>   
>>   	eht_cap->has_eht = true;
>> diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
>> index 89abf2e87ad1..0aba1e74a3e9 100644
>> --- a/drivers/net/wireless/ath/ath12k/reg.c
>> +++ b/drivers/net/wireless/ath/ath12k/reg.c
>> @@ -140,6 +140,7 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
>>   	enum nl80211_band band;
>>   	int num_channels = 0;
>>   	int i, ret = 0;
>> +	bool has_eht;
>>   
>>   	if (ar->ah->state == ATH12K_HW_STATE_RESTARTING)
>>   		return 0;
>> @@ -180,6 +181,8 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
>>   
>>   	ch = arg->channel;
>>   
>> +	has_eht = ath12k_is_11be_enabled(ar->ab);
>> +
>>   	for (band = 0; band < NUM_NL80211_BANDS; band++) {
>>   		if (!(ar->mac.sbands[band].channels && bands[band]))
>>   			continue;
>> @@ -201,6 +204,7 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
>>   			ch->allow_ht = true;
>>   			ch->allow_vht = true;
>>   			ch->allow_he = true;
>> +			ch->allow_eht = has_eht;
>>   
>>   			ch->dfs_set =
>>   				!!(channel->flags & IEEE80211_CHAN_RADAR);
>> diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
>> index a63bbda0219c..5fe7af731a4e 100644
>> --- a/drivers/net/wireless/ath/ath12k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath12k/wmi.c
>> @@ -2005,6 +2005,54 @@ int ath12k_wmi_p2p_go_bcn_ie(struct ath12k *ar, u32 vdev_id,
>>   	return ret;
>>   }
>>   
>> +int ath12k_wmi_vdev_set_ie(struct ath12k *ar, u32 vdev_id, u32 ie_id,
>> +			   const u8 *ie, size_t ie_len, u32 band)
>> +{
>> +	struct ath12k_wmi_pdev *wmi = ar->wmi;
>> +	struct wmi_vdev_set_ie_cmd *cmd;
>> +	struct sk_buff *skb;
>> +	struct wmi_tlv *tlv;
>> +	size_t aligned_len;
>> +	int ret, len;
>> +	void *ptr;
>> +
>> +	aligned_len = roundup(ie_len, sizeof(u32));
>> +	len = sizeof(*cmd) + TLV_HDR_SIZE + aligned_len;
>> +
>> +	skb = ath12k_wmi_alloc_skb(wmi->wmi_ab, len);
>> +	if (!skb)
>> +		return -ENOMEM;
>> +
>> +	ptr = skb->data;
>> +	cmd = ptr;
>> +	cmd->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_VDEV_SET_IE_CMD,
>> +						 sizeof(*cmd));
>> +	cmd->vdev_id = cpu_to_le32(vdev_id);
>> +	cmd->ie_id = cpu_to_le32(ie_id);
>> +	cmd->ie_len = cpu_to_le32(ie_len);
>> +	cmd->ie_source = cpu_to_le32(WMI_SET_VDEV_IE_SOURCE_HOST);
>> +	cmd->band = cpu_to_le32(band);
>> +
>> +	ath12k_dbg(ar->ab, ATH12K_DBG_WMI,
>> +		   "WMI set ie vdev_id %u ie_id %u ie_len %zu band %u\n",
>> +		   vdev_id, ie_id, ie_len, band);
>> +
>> +	ptr += sizeof(*cmd);
>> +	tlv = ptr;
>> +	tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_BYTE, aligned_len);
>> +	memcpy(tlv->value, ie, ie_len);
>> +
>> +	ret = ath12k_wmi_cmd_send(wmi, skb, WMI_VDEV_SET_IE_CMDID);
>> +	if (ret) {
>> +		ath12k_warn(ar->ab,
>> +			    "failed to send WMI_VDEV_SET_IE_CMDID for vdev %u ie %u: %d\n",
>> +			    vdev_id, ie_id, ret);
>> +		dev_kfree_skb(skb);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>>   int ath12k_wmi_bcn_tmpl(struct ath12k_link_vif *arvif,
>>   			struct ieee80211_mutable_offsets *offs,
>>   			struct sk_buff *bcn,
>> @@ -2946,6 +2994,8 @@ int ath12k_wmi_send_scan_chan_list_cmd(struct ath12k *ar,
>>   				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_ALLOW_VHT);
>>   			else if (channel_arg->allow_ht)
>>   				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_ALLOW_HT);
>> +			if (channel_arg->allow_eht)
>> +				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_ALLOW_EHT);
>>   			if (channel_arg->half_rate)
>>   				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_HALF_RATE);
>>   			if (channel_arg->quarter_rate)
>> diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
>> index b508aa759bd8..e51b3bdab77b 100644
>> --- a/drivers/net/wireless/ath/ath12k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath12k/wmi.h
>> @@ -3075,7 +3075,8 @@ struct ath12k_wmi_channel_arg {
>>   	    allow_vht:1,
>>   	    allow_he:1,
>>   	    set_agile:1,
>> -	    psc_channel:1;
>> +	    psc_channel:1,
>> +	    allow_eht:1;
> add after allow_he to keep in a logical order since this isn't ABI?
done on v3 patch
>
>>   	u32 phy_mode;
>>   	u32 cfreq1;
>>   	u32 cfreq2;
>> @@ -3694,6 +3695,7 @@ struct ath12k_wmi_scan_cancel_arg {
>>   #define WMI_CHAN_INFO_DFS_FREQ2		BIT(16)
>>   #define WMI_CHAN_INFO_ALLOW_HE		BIT(17)
>>   #define WMI_CHAN_INFO_PSC		BIT(18)
>> +#define WMI_CHAN_INFO_ALLOW_EHT		BIT(21)
>>   
>>   #define WMI_CHAN_REG_INFO1_MIN_PWR	GENMASK(7, 0)
>>   #define WMI_CHAN_REG_INFO1_MAX_PWR	GENMASK(15, 8)
>> @@ -3845,6 +3847,23 @@ struct wmi_p2p_go_set_beacon_ie_cmd {
>>   	__le32 ie_buf_len;
>>   } __packed;
>>   
>> +#define WMI_SET_VDEV_IE_SOURCE_HOST	0
>> +
>> +enum wmi_set_vdev_ie_band {
>> +	WMI_SET_VDEV_IE_BAND_ALL,
>> +	WMI_SET_VDEV_IE_BAND_2_4GHZ,
>> +	WMI_SET_VDEV_IE_BAND_5GHZ,
>> +};
>> +
>> +struct wmi_vdev_set_ie_cmd {
>> +	__le32 tlv_header;
>> +	__le32 vdev_id;
>> +	__le32 ie_id;
>> +	__le32 ie_len;
>> +	__le32 ie_source;
>> +	__le32 band;
>> +} __packed;
>> +
>>   struct wmi_vdev_install_key_cmd {
>>   	__le32 tlv_header;
>>   	__le32 vdev_id;
>> @@ -6583,6 +6602,8 @@ int ath12k_wmi_pdev_resume(struct ath12k *ar, u32 pdev_id);
>>   
>>   int ath12k_wmi_send_peer_assoc_cmd(struct ath12k *ar,
>>   				   struct ath12k_wmi_peer_assoc_arg *arg);
>> +int ath12k_wmi_vdev_set_ie(struct ath12k *ar, u32 vdev_id, u32 ie_id,
>> +			   const u8 *ie, size_t ie_len, u32 band);
>>   int ath12k_wmi_vdev_install_key(struct ath12k *ar,
>>   				struct wmi_vdev_install_key_arg *arg);
>>   int ath12k_wmi_pdev_bss_chan_info_request(struct ath12k *ar,
>>
>> base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c
