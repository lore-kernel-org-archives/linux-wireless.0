Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991BB48AE06
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787678915; cv=none; b=sUF8LBrX53RaGzaZazt+kHOIFs9FOpW1tQkZiQ/54LNOWtSI4DiCLhhuBlt2AIDctkzCxuxLvVN120Ftx/DCQbBKv+bnEd7Li9FIcZF+C+0+D3jhV7qRYutyQITA0pMLkJ1bi5Rzfo8sg4APh9KsCF6hTYbIpcdtxbFDRjx64gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787678915; c=relaxed/simple;
	bh=4aDKlssntfJLAE5XypWf+NdQtX+NdnVtragCw7N8iTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dQ0XULTlkbqiZiKnZMsj2WzF/vGJTuenoECY8FPTvvIaRyqiEKP7L2mygMNoo9mo0xtueis+ZsZhzqU/GXuAaKMYKJSZo0O00MsaX3+pXbNbR7UO//HxeX8O7WSHikT1slggJTfSeoRkax4BbhTmgtfo0X+FdQh6XIqIhqoBRLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ei+qmLFF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FiXPGKjQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ei+qmLFF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FiXPGKjQ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PHQMdi2115607
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 17:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uRiq4k43x6g0FlQYiIBHzlixzzb5eQIhX6AkPCST7nM=; b=Ei+qmLFFTNN/dS1W
	0k50RPiwclU53IhYV5TO3S9t/iK4IqWyc0SxYUkCYGOw0PllUcZWPtVycK8FxlB/
	eQmthK33iNxANkQvBNrYVGsMDYIgIbq6yJexUozey6r9syP+FDwHcUVXkUFKQ7li
	0Ef1pEWZI/w2xTc2uD7LfJn2F7/K52YRWx18f+N+Zs60FX+6cLSgDWaLGNfsPP60
	uLG752P4pDmoPt+OjULpV/cLJtwySlKbUhtyJhKSm8aIMXAoD+gV2JRUwrpL92iH
	c+XtxohKo7hrXuGbx5iN/Ev3lVTPR3rdsc3zfleSJvek+l0gJJYIOwZomcteyG4V
	XR5J0w==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g9cgu0v4g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 17:28:32 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-385d2703b64so1333805a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 10:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787678911; x=1788283711; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uRiq4k43x6g0FlQYiIBHzlixzzb5eQIhX6AkPCST7nM=;
        b=FiXPGKjQ91cqlsKF9ud5sNsV8M2RyFbrftV6EUq+iKsebumsmjhDagfCqWJfHTOP7l
         1sD/pok+TpQd3oPxSu6qUFqtqnk4ASxorM+AAFFNxHnqyCLJffYl/4yt7B9/9HKBwMA3
         qy3mj2214aadI7cggR+/SRH3rlXY1zqlAjDA+ofRznJ/eS/2L9Z5D1K8Ta/ToTUc1vLn
         kW3fDC/RMZojDZ9L463lHIQPLYbt90u8rPYFs8QrIBWDSl5rOoBl3Hg4j0vRB+HMD9lH
         7v0zLrn9Rsma7BOuBhnfm6Noj90Ar8X7RzRyesoAV/IelWWrjlcF+1ZaJaOU3HuTrE36
         MvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787678911; x=1788283711;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uRiq4k43x6g0FlQYiIBHzlixzzb5eQIhX6AkPCST7nM=;
        b=B7V6f6wHKsL6mbaSEJjt7SYAwonzL5YIlOvoYTYZzgKQ5xQVIaGj4hTCm25RkmOBxI
         l5dSFaKJBFhDLmyoNZ4s2Z+Gn6d1EWtSOrbqxzveWLeGwSz+3+qQXqzjNN6SqCFOyUr6
         //k5UBxxWmuE2hO2bt5a0CDQ5vJu2quxNdpKxNXpBBnNGodaCqfCpFTWN3KbIhreloPV
         y7PNs/alsOCIKTtvJWdRMdViXRq9TdTZ61XVa+xE0+UAhTOI1NdIFpRQbV+uaRyze600
         gyzHWSq+SKb7OuRS+TmWJX7AwtNr8B/qAubjgY5S3pCoIcPdj6MqOIXyBCC/+N+ducud
         wccg==
X-Forwarded-Encrypted: i=1; AHgh+RryG39kaNON45OQo8v+ea1TVA3V+/GpCeZonnNpaE9epzwyGoOzyQGHuzTyR1KLH9+/ddZnv7M4AihD9gJB/w==@vger.kernel.org
X-Gm-Message-State: AFuF++nOZ3zJcwKuMWC6+GMNaoImjI0a8xIEK1eDIu2Syel4z4eLBQZ0
	RV/o0zjDjTXD2Ew/o7LkzzwM/y9NqQEmZV/npdloMl8Xhkcwae+2I2ElE1Ia/QLXs+UviinYlcX
	YZiv/Z0zlEAy3kdtLGm28BuvUJq/IzXb0ZaXK6a4fjLhecqYEsL5OM05x+ROEYWydhyc4UA==
X-Gm-Gg: AR+sD10LRG06yuoXonXFpBt+z8Kv1CsYVFbrgkhh+TE7x4PR8jtRHOjEtC8W9k0neYM
	gaYN0e3qwAGe0IH2jcZ30Dx21pDbqhc3fo4aPl3kA3DxM02Qo5IH0KAoTdqTRhxQ1jOzM91vHxo
	4SoBDtFB19kn3spAzUyQY1q+GWU84Uoe+C26MQmDGO3zTVIgL8ZnOZNfzmM2s44G88vDCUibeL+
	Vbld0EYxMDWNY/Y1jk1xgYFlc9wK92tpqOKpkDcEXPTNWh4NO3CK9suiOHGQOGvd/10GwSWEFZS
	RkVHyBTEOr2IGChUq7DWioOp5klfF5A9awy9Fel2IOpZ4fz/XcOCyLvL+sufOjjvZY4bx40jPTs
	wmewfz8n/vpwgrq4KmoVQ82Ns7IR215xtXfWzVQ==
X-Received: by 2002:a17:90b:4c43:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-396458291d9mr10587097a91.4.1787678911090;
        Tue, 25 Aug 2026 10:28:31 -0700 (PDT)
X-Received: by 2002:a17:90b:4c43:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-396458291d9mr10587022a91.4.1787678910600;
        Tue, 25 Aug 2026 10:28:30 -0700 (PDT)
Received: from [192.168.1.7] ([122.167.99.239])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a905cf38sm984220c88.12.2026.08.25.10.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 10:28:30 -0700 (PDT)
Message-ID: <ab922bb8-6eba-4cfe-b756-45c0b653416c@oss.qualcomm.com>
Date: Tue, 25 Aug 2026 22:58:01 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v3 0/8] Adding NO_STA flag and reworking RX
 link resolution
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Johannes Berg <johannes@sipsolutions.net>, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, Benjamin Berg <benjamin.berg@intel.com>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net>
Content-Language: en-US
From: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
In-Reply-To: <20260819135703.4072215-10-benjamin@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDE0OCBTYWx0ZWRfXws3N+WuVsZOt
 BPiATSUDMcSBhutGanc7g8kSWVH+sTDf38CKPAIQeTZf28DD2RGPasj2EaQQ3jOBwgzGbqY+xBA
 tLZ3BFoQWge0vo/WvmUXhTwkI6XEAFQ=
X-Proofpoint-ORIG-GUID: DiZzhzQgI0p6tHCCTfrx-2Oya3-Xy1R_
X-Proofpoint-GUID: DiZzhzQgI0p6tHCCTfrx-2Oya3-Xy1R_
X-Authority-Analysis: v=2.4 cv=Sb7HsPRu c=1 sm=1 tr=0 ts=6a8dd0c0 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=oX6zrBFkKDnm7aSYfwAOkA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=-TwTuGK1WEEtMzw1PQMA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDE0OCBTYWx0ZWRfX9heoU43Cyczc
 GRJ6z0nEP65nFxe4AiQxTLpV8hVOnMRh4KsdN+P60qUm8K9x89hwTiNzZiNsUwpOa9E5bjxoz1i
 VamagXZ7dkkLt1UVDR87HlKqZxsRGA5c9+aS8HYdJjZx1DJLRg6a1yAfj+crUVPUMdRXryLN7Rz
 GYiVrn5mPE9kRK1RE/NdcvOhwT8xQ4ftWrGACWk7UjeerVfhJpMPjPNXll8Q5+rMWKW1CaUowZj
 hoQ7dLoe9oDbaLWdkqzysH/hnclFt+z9kxAu21gQMkpyrKVaOguuQxPk/MQlRKxg0Hu50Lx8CGf
 Hkdt+GRs8jzKJ/u1TLJhUm20GJekomua0Zoav8nqtsMn7HUNtNZqFkpoLQD+UE9uMmpXxix5PPx
 74mwgb81UmxFefIzDwqXEQprarEEXHDzrTed0b/8tV4bZUJHzPcQKAkepm/BS6NDj6HhZNJZ2xn
 IT+l6YRuFGBXqJUFWPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_04,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608250148



On 8/19/2026 7:27 PM, Benjamin Berg wrote:
> From: Benjamin Berg <benjamin.berg@intel.com>
> 
> Hi,
> 
> This patchset refactors the RX link resolution a bit to fix some issues
> where mac80211 might accept frames on the wrong link and incorrectly
> translate the address. It also adds a new NL80211_ATTR_FRAME_CMD_NO_STA
> flag so that userspace can know whether address translation was done by
> the kernel on RX and can also prevent address translation for management
> frames during TX.
> 
> This together should be enough to fix the existing issues in hostapd
> where stations that are still associated try to authenticate again but
> hostapd for example ends up sending the frame to an old link address.
> 
> Benjamin
> 
> PS: Sorry, the last mail had various issues, so resending properly now.
> 
> v3:
>   * Fix issues found during review
> 
> v2:
>   * Remove unused variable in rtw89
> 
> Changes in v1:
>   * Add NAN_DATA interface handling
>   * Handle NO_STA flag correctly for NAN
>   * Fixed forwarding of station parameter
>   * Rebase and other small fixes
> 
> Changes in RFCv2:
>   * Port other drivers to new API (untested)
>   * Fix a checkpatch warning
> 
> Benjamin Berg (8):
>    wifi: iwlwifi: use link_sta internally to the driver
>    wifi: mac80211: change public RX API to use link stations
>    wifi: mac80211: refactor RX link_id and station handling
>    wifi: mac80211: rework RX packet handling
>    wifi: cfg80211: add attribute for TX/RX denoting there is no station
>    wifi: mac80211: report to cfg80211 when no STA is known for a frame
>    wifi: mac80211: pass station to ieee80211_tx_skb_tid
>    uwifi: mac80211: pass error station if non-STA transmit was requested
> 
>   drivers/net/wireless/ath/ath11k/dp_rx.c       |   2 +-
>   drivers/net/wireless/ath/ath12k/dp_mon.c      |   2 -
>   drivers/net/wireless/ath/ath12k/dp_rx.c       |  20 +-
>   drivers/net/wireless/ath/ath12k/hw.h          |  20 +-
>   drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  20 +-
>   drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h |  12 +-
>   drivers/net/wireless/ath/ath12k/wifi7/hw.c    |   6 +-
>   drivers/net/wireless/ath/ath12k/wmi.c         |   6 -
>   drivers/net/wireless/intel/iwlwifi/mld/agg.c  |  17 +-
>   drivers/net/wireless/intel/iwlwifi/mld/agg.h  |   4 +-
>   drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  50 +-
>   drivers/net/wireless/intel/iwlwifi/mld/rx.h   |   2 +-
>   .../wireless/intel/iwlwifi/mld/tests/agg.c    |   7 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   6 +-
>   drivers/net/wireless/mediatek/mt76/mac80211.c |  22 +-
>   drivers/net/wireless/realtek/rtw89/core.c     |   7 -
>   .../wireless/virtual/mac80211_hwsim_main.c    |   3 -
>   include/net/cfg80211.h                        |   4 +
>   include/net/mac80211.h                        |  25 +-
>   include/uapi/linux/nl80211.h                  |   7 +
>   net/mac80211/agg-tx.c                         |   4 +-
>   net/mac80211/ap.c                             |   3 -
>   net/mac80211/ht.c                             |   2 +-
>   net/mac80211/ieee80211_i.h                    |  11 +-
>   net/mac80211/iface.c                          |   7 +-
>   net/mac80211/mlme.c                           |  10 +-
>   net/mac80211/offchannel.c                     |  13 +-
>   net/mac80211/rx.c                             | 447 ++++++++++--------
>   net/mac80211/scan.c                           |  10 +-
>   net/mac80211/tdls.c                           |   2 +-
>   net/mac80211/tx.c                             |  10 +-
>   net/wireless/nl80211.c                        |   8 +-
>   33 files changed, 413 insertions(+), 358 deletions(-)
> 

The changes look good to me, no hwsim test cases failure.

Note: The hostapd changes posted in: [PATCH 0/6] hostapd: handle nl80211 
no_sta flag in management frames


Reviewed-by: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
