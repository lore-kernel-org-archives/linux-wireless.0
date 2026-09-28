Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287CC4F0529
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 17:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616284; cv=none; b=MncL9dk1gGqZVOhfCBiavIWNmWytdv1Lj0KGIjimxJVf8Sm+ih5gvqiD7pMcnQb0hcApRz7ROta1m9gFXLCSS1PKT/ZX5vVXG3dOzhB8c71fnbMOwOdnGEHOLEV/p/d/xbHCCW3JzDeDJatmPfDg3lTZwgM0K4Yvmb/caPsGCZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616284; c=relaxed/simple;
	bh=0i0UilGl82MDH3rBoNMgz7HdO3fjADg3dVpwa/Ltx2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tBbjKmD4E6C5fQ+Pr+OgiQpGEVqTPH8CtiNPD5Xw/u9SwSCcsfwVUdm4QssriRfiCtiHHblqJrgr08P6kHBeY9YP+7FOFt1GNlloEk9GpvcHOuiQB3kQudhpdxTue4t6lG6aibRDpxg3UHpxHDksL2ZGWwcOf0LnhjuzzUIw/tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N4U2uJv3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c732fxiJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N4U2uJv3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c732fxiJ"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SEdvLU2755811
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 17:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0g5rk72sPsp3Y6F3QPQcKiPf1dfTSfp3yBs9EajvEyw=; b=N4U2uJv3zZMvMt0G
	dBWBodm93IsZJjS3KIeBFMx3CJNrmFn6HMgE8jAkUFD31QmYB6K8uOjLS7KMFMs0
	y+SVyzgJn1TjN7li7f50fnXd1/t5zAxTrEajHU0JT0Kq7bZyp2gFYmCaYFfvADB8
	x4MgKs2HQPgbfX2Z5PS9soapdudcUjEJImiw0X+dlvVYnoxLU4YMpKTT4XDeiCx2
	Xx5qu2iEB1SoPYHPxA8vpDmB/ApaveI5ZzmUKefDdS2mGM6x4OzL21bkscWYmemO
	7CVhPfj6DDOi7NeXRpOZmskuv2PufrF4J+Qa8hPOOzvw1pfw6ZI3EDwO+Wj4hV0j
	/jVSVQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gyhubjrnd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 17:24:42 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1383723dfddso1620435c88.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790616282; x=1791221082; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0g5rk72sPsp3Y6F3QPQcKiPf1dfTSfp3yBs9EajvEyw=;
        b=c732fxiJHvBp7t4S0z4msYAOPuo7fl8HjFyE5jx819/Mvb8K3/GKbl+zIhdwZiuYr7
         BAi0SgjpYDkfTLwTafl4xjXDeHDrQpFtkBXTDEcCyoGs0Uc0egqH7SxqZJxixAzZ5KZB
         T82fUAhV9pGhTN0KqnaZqa8JulphRia/niwmjb/+aZXBEHSXQBmxJNCjvOw5isOEY6X6
         xAZnCprZZ6RLmeKPQIdK9x5QZ2IY5NLA/e3fIX8/oalpWOBnUcpdXnKiAWM7Cxus3gLR
         yGo79laoNA+nhc20svGgNbkA+sqmPsPYwIwv/eQ2P7IfZeTRHEdwXgXoMV/fNDjoey6j
         ILxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790616282; x=1791221082;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0g5rk72sPsp3Y6F3QPQcKiPf1dfTSfp3yBs9EajvEyw=;
        b=bZPuyTvTQC6QU840OXDItrYRapZF38+rAw8SVoimZkiTZL/A+zBusbdVlG/ohXlLJh
         9+Oemm5qUnS1rhnhwDp1a+m4+5r6tgdg+dBOIP1Wd1N7TQTnNN3AHAzkQx5sYxwDQ5n/
         VmX5mo+8OumnZ+2hTD3j91YzES9Vd1qJxDQqZO/fUu7e2YDF35c0oaLt9qMj30Bfz5U+
         7J/TTPzcLBUYqxkKPYnDz98G4T46ljLopUXvZEWjc99do/Hiz3zuDeF+GOr1oEHlHBjP
         PBQBRT4Qto7kyeT9iNMnTXa7Ndu8CffSjiIBa1jNeUl8ImYFX3zi1UVcp8C+5sbeupLc
         d56w==
X-Forwarded-Encrypted: i=1; AKwUvBySk4DKPiWecTAJWeffCVgPkDtiG3ByEuZAAzAcRzx5/JsdGNV/dPIC5VHGRNjrHJdCzE6OaozE/FJs3Cv1tA==@vger.kernel.org
X-Gm-Message-State: AFuF++n6osKXeV6lTarmujEV78h+L0K5sYOFiWg1aeinjvl3+HeUp5w1
	fwRXE+o8ZyxsxjT8fAqeX+cDyPSca4cwEbDfCT38vTr3IpnoPt5iVQsovJhCbSzN+fbrGgYlSyS
	vuDzbZQEAYELj2HBHxBM3BF8WS4b+ldepnXBdMgvDSBOPTQm+Pp7LSWkApwegd/dZEB+lDw==
X-Gm-Gg: AYBFou2mWs7fS8S3V8saTRT5l8/WaDt+xFJ1XWztLKBVNkhdBaiscHbIbaJ39kRXACx
	2cntwYdLoJ6jNHCqHG6rMaBFEuNv82IjUWN6eZdyY885Pm/g021Cl9fdzeaVEGaYkHLuFQYJThV
	H+EdQDlGqVR+0lHX87kM6yXQWqQ3RlmfNxKj4lbS8eVH35SUWtAx2IvsVwjIgQsxW0A+KZrzyni
	epWuLKDjOSksYvYbHC0/8xuUv2l6HOHtIlm9ZoFMi7C9rhpEvkrSC9FUBNlF8sKJ2Vw1SX7sicb
	+HgjEvo3ocmmcGXXaytpOEQzmyw8U1WRxMJM+h0zjB0lA+O0jVm1lMqvtXwJEi0sApnHMH9iH3q
	0rr0cNvITAqMiYmIjOk2WwiiooO2bQSaN3KpwIt3jSMc=
X-Received: by 2002:a05:701b:4292:20b0:143:298d:c1eb with SMTP id a92af1059eb24-146d096b191mr11011458c88.43.1790616280779;
        Mon, 28 Sep 2026 10:24:40 -0700 (PDT)
X-Received: by 2002:a05:701b:4292:20b0:143:298d:c1eb with SMTP id a92af1059eb24-146d096b191mr11011430c88.43.1790616280163;
        Mon, 28 Sep 2026 10:24:40 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ad8e43d2sm30595645c88.12.2026.09.28.10.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:24:39 -0700 (PDT)
Message-ID: <494ab3a5-7f36-47ad-bf14-0b7cac74b70f@oss.qualcomm.com>
Date: Mon, 28 Sep 2026 22:54:34 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: Add EHT capabilities to scan probe
 frame
To: Gaole Zhang <gaole.zhang@oss.qualcomm.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, jeff.johnson@oss.qualcomm.com,
        baochen.qiang@oss.qualcomm.com
Cc: gaolez@qti.qualcomm.com, miaoqing.pan@oss.qualcomm.com,
        hangtian.zhu@oss.qualcomm.com
References: <20260921043148.3071142-1-gaole.zhang@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260921043148.3071142-1-gaole.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: M3P9YWy53hWcTkMiVjg8XWqPB9RBlQZI
X-Authority-Analysis: v=2.4 cv=C7F8WgP+ c=1 sm=1 tr=0 ts=6abaa2da cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=f8BdWhLognpqapH-X3EA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: M3P9YWy53hWcTkMiVjg8XWqPB9RBlQZI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA2OSBTYWx0ZWRfXwv5J0GSO8zJX
 6nCv7O8aLe1h8TKksGHiog7Dmbx8yilcrmnEVeeE6/PV1lD0swO9rJZodMkiAYU0wtV3xW/RG2B
 2XyLZxCMWE8pe8EiK85a2s2e79MJFNjyXUp4bwdz5Y6502AUAjTmPsuoChfRIGI4xWf1BOyrCsl
 w9C0zQWqw667+1Q2pN+BlSH5UEaJuOowlOdL9IYF5XdDVXPOQtL+yDSyXBx/TS7I+Mhz5M3hsXR
 zNcYlGPABEAJSfhhCWkLny2Wr44MXln7QV7Iuvyik5sh13HcYsvyg6BjcrKI3nEXDpxPjwFd80Z
 3A3i7PUQQz+gmtS6zBvhfc6CrHthGXVq8hogcw6jGIuIvlbKzLVfEpYObOC+FnsNmV7xtoYZeEN
 Zd710KWgC5EgP5nEbPkc9TJOfthN9M80x91VF9AxOVPig2KIiAb6qbjRBqKWcV+T+pJ3QZohEh5
 46C6Fcs0/JjnKr6b6kA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA2OSBTYWx0ZWRfX3ITX3aapeQIP
 JSWI5pQmDgrVXP6+baUEArWPaHfmQ4D6ozGJRJOdGjbXmZt5DxwXeZW9W8phMCs/YsYSjQWTJXn
 Pm0K/aO22Svy6rbV8UGyk3UOFEZxARM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280069

On 9/21/2026 10:01 AM, Gaole Zhang wrote:
> Currently, ath12k does not set the EHT flag in scan channel
> information and does not send WMI_VDEV_SET_IE_CMDID with the EHT
> Capabilities element configuration. As a result, EHT-capable STA
> Probe Requests do not contain the EHT Capabilities element.
> 
> Without this element, AP can't identify the STA as EHT-capable
> during active scanning and may omit EHT-related information from its
> Probe Response. This can result in incomplete scan information and
> prevent userspace from correctly determining the AP's EHT capabilities.
> 
> Set the EHT scan flag and configure the EHT Capabilities element so
> that ath12k includes it in STA Probe Request frames.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/core.h |  6 ++++
>   drivers/net/wireless/ath/ath12k/mac.c  | 29 +++++++++++++--
>   drivers/net/wireless/ath/ath12k/reg.c  |  4 +++
>   drivers/net/wireless/ath/ath12k/wmi.c  | 50 ++++++++++++++++++++++++++
>   drivers/net/wireless/ath/ath12k/wmi.h  | 23 +++++++++++-
>   5 files changed, 109 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
> index a98fc6e0699d..e7373a523dc3 100644
> --- a/drivers/net/wireless/ath/ath12k/core.h
> +++ b/drivers/net/wireless/ath/ath12k/core.h
> @@ -1394,6 +1394,12 @@ static inline struct ath12k *ath12k_ah_to_ar(struct ath12k_hw *ah, u8 radio_idx)
>   	return &ah->radio[radio_idx];
>   }
>   
> +static inline bool ath12k_is_11be_enabled(struct ath12k_base *ab)
> +{
> +	return test_bit(WMI_TLV_SERVICE_11BE, ab->wmi_ab.svc_map) &&
> +	       !ath12k_acpi_get_disable_11be(ab);
> +}
> +
>   static inline struct ath12k_hw *ath12k_ar_to_ah(struct ath12k *ar)
>   {
>   	return ar->ah;
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index d4116ba0da08..f353af63c5eb 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -5602,6 +5602,25 @@ ath12k_mac_find_link_id_by_ar(struct ath12k_vif *ahvif, struct ath12k *ar)
>   	return ATH12K_FIRST_SCAN_LINK;
>   }
>   
> +static int ath12k_mac_set_scan_eht_cap_ie(struct ath12k *ar,
> +					  struct ath12k_link_vif *arvif,
> +					  const u8 *ies, size_t ies_len)
> +{
> +	const struct element *eht_cap;
> +
> +	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
> +
> +	eht_cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies,
> +					 ies_len);
> +	if (!eht_cap || eht_cap->datalen <= 1)
> +		return 0;
> +
> +	return ath12k_wmi_vdev_set_ie(ar, arvif->vdev_id,
> +				      WLAN_EID_EXTENSION,
> +				      eht_cap->data, eht_cap->datalen,
> +				      WMI_SET_VDEV_IE_BAND_ALL);
> +}
> +
>   static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
>   				       struct ieee80211_vif *vif,
>   				       struct ieee80211_scan_request *hw_req,
> @@ -5718,6 +5737,13 @@ static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
>   			goto exit;
>   		}
>   		arg->extraie.len = req->ie_len;
> +		ret = ath12k_mac_set_scan_eht_cap_ie(ar, arvif, req->ie,
> +						     req->ie_len);
> +		if (ret) {
> +			ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
> +				   "failed to set eht cap ie, ret %d\n", ret);
> +			goto exit;
> +		}
>   	}
>   
>   	if (req->n_ssids) {
> @@ -8983,8 +9009,7 @@ static void ath12k_mac_copy_eht_cap(struct ath12k *ar,
>   
>   	memset(eht_cap, 0, sizeof(struct ieee80211_sta_eht_cap));
>   
> -	if (!(test_bit(WMI_TLV_SERVICE_11BE, ar->ab->wmi_ab.svc_map)) ||
> -	    ath12k_acpi_get_disable_11be(ar->ab))
> +	if (!ath12k_is_11be_enabled(ar->ab))
>   		return;
>   
>   	eht_cap->has_eht = true;
> diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
> index 89abf2e87ad1..0aba1e74a3e9 100644
> --- a/drivers/net/wireless/ath/ath12k/reg.c
> +++ b/drivers/net/wireless/ath/ath12k/reg.c
> @@ -140,6 +140,7 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
>   	enum nl80211_band band;
>   	int num_channels = 0;
>   	int i, ret = 0;
> +	bool has_eht;
>   
>   	if (ar->ah->state == ATH12K_HW_STATE_RESTARTING)
>   		return 0;
> @@ -180,6 +181,8 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
>   
>   	ch = arg->channel;
>   
> +	has_eht = ath12k_is_11be_enabled(ar->ab);
> +
>   	for (band = 0; band < NUM_NL80211_BANDS; band++) {
>   		if (!(ar->mac.sbands[band].channels && bands[band]))
>   			continue;
> @@ -201,6 +204,7 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
>   			ch->allow_ht = true;
>   			ch->allow_vht = true;
>   			ch->allow_he = true;
> +			ch->allow_eht = has_eht;
>   
>   			ch->dfs_set =
>   				!!(channel->flags & IEEE80211_CHAN_RADAR);
> diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
> index a63bbda0219c..5fe7af731a4e 100644
> --- a/drivers/net/wireless/ath/ath12k/wmi.c
> +++ b/drivers/net/wireless/ath/ath12k/wmi.c
> @@ -2005,6 +2005,54 @@ int ath12k_wmi_p2p_go_bcn_ie(struct ath12k *ar, u32 vdev_id,
>   	return ret;
>   }
>   
> +int ath12k_wmi_vdev_set_ie(struct ath12k *ar, u32 vdev_id, u32 ie_id,
> +			   const u8 *ie, size_t ie_len, u32 band)
> +{
> +	struct ath12k_wmi_pdev *wmi = ar->wmi;
> +	struct wmi_vdev_set_ie_cmd *cmd;
> +	struct sk_buff *skb;
> +	struct wmi_tlv *tlv;
> +	size_t aligned_len;
> +	int ret, len;
> +	void *ptr;
> +
> +	aligned_len = roundup(ie_len, sizeof(u32));
> +	len = sizeof(*cmd) + TLV_HDR_SIZE + aligned_len;
> +
> +	skb = ath12k_wmi_alloc_skb(wmi->wmi_ab, len);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	ptr = skb->data;
> +	cmd = ptr;
> +	cmd->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_VDEV_SET_IE_CMD,
> +						 sizeof(*cmd));
> +	cmd->vdev_id = cpu_to_le32(vdev_id);
> +	cmd->ie_id = cpu_to_le32(ie_id);

This appears to be passing only WLAN_EID_EXTENSION.

How does the firmware make use of this IE identifier, and why is this 
required only for EHT Capabilities? Are HE Capabilities and other 
extension-based IEs handled differently?

Also, this command is sent for every hardware scan request. Does the 
firmware use the host-provided IE only for the current scan and then 
discard it afterward, or is the IE retained across scans?

It would be helpful to capture these details in the commit message 
and/or code comments.

-- 
Ramesh
