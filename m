Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5CD31F9BD
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 04:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785472002; cv=none; b=BMWu+gZo81yRdvwtiO9pAuGzI63R9BI593SPjBoIVRCKesX9zXtEW9i6sUwCxYHD2v3EmDzseJirIOL0Q+AvzPuNpOF9jmvak67G2s/9oqE/ptUy1bsJRUx0oZZ4P1Lp6ohpRTm01kFBGmOQRUn23QbT1JPzU18OpJomJW+xHtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785472002; c=relaxed/simple;
	bh=y1CyV6h9yGidd4nHM2GUxhSZNw080dk1jgM9j/3kl2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTrgHJ/uIoLsRsXMkZ8RfTguOcelxe26kC+LcrtCWmP6HfWyoDG8ohBQmtAgAbGvQyzEJ0nZz4VTcAYt57oBPnE5g/R9/FDe8JCEe9mOT1gXYnvh/iZ8tw/+0pNLocffKpB0P2t2dT+ULGrjHPcpthZLT8wrvIhjryJLJWRGNZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PWcPTQFV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gsxUxMFr; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PWcPTQFV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gsxUxMFr"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V2Ogbq2910079
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 04:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E+wZi56qOnAfskyheJnkKhsJlDOlmlkpKY+fv/6C3tE=; b=PWcPTQFVT+cMQZXm
	ClkNQq6Smm4xyhJABDJGo5om717N/125+cIdc73KICkvttD0OkoDMZRidP7vv5Za
	lzKAzEn0RXMKA4hNzKv6NCT828zJJkxa1uq77AvXC/9nQ/yTHGqVantqvVAQQ30S
	KuINv2KYkAIiHB1avLc2brLXojHX6HDvIS8dWBZ5Tsyc82F+9zrhDOrZGddLv9tw
	r74hSV+nQrc4wEQefRug3MKAEPce/DZIs36PK4TJp7tBVjawICkMBZ3I3/lpbNQQ
	Jx9prWVk2PNUiCACIx+3f7pbz1COS2znBxBt/ywgwErE6Wl4qF+W7WGubKAbJtGQ
	61SscA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frjw7gchf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 04:26:38 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso827993a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 21:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785471998; x=1786076798; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E+wZi56qOnAfskyheJnkKhsJlDOlmlkpKY+fv/6C3tE=;
        b=gsxUxMFrWY1Pm5menySDOiCph0jRm8nKSm3deslCavvyLNcMrl0MvkGS9S7C3a0YMu
         A9as0dDG77705evDTdQoFg0MFFh2m8EiuXlf3Th7kgqvOOqE0oQl8K3Jj5j4PIIv3l2M
         sn7GpX+jBKlrD9pMIAhGcLLg2m1FdYnh2DRqN1p1qNZuQjpQUrJ+n/bz4eM7v8+0h4ER
         LQOc0Peuvb1YfkWnRKMdX858HoVWF7wwDWpviZi1vzujnYNBEE2gIpSn45O5mj703Ipr
         Wv9GD86y5h/jbUE/JxJkT1zq/ApYzzGtbdwwR8MlcPw8/ORdENb3mAtBZe5PTZztwTz7
         hvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785471998; x=1786076798;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E+wZi56qOnAfskyheJnkKhsJlDOlmlkpKY+fv/6C3tE=;
        b=DNIAUi09jy1EvsQP8JAjlQjLzQq2EyjIPb3xyUnwHbp4bwsqkA0iS5h7/mMCDERlhx
         DXnWgqap/MKA2Ukfmho3pWyEgwyF0VJXUpQ+/4UcScfGP8ke8nY3lALOs3BBD48QdIAt
         FGH6LgGcRwuU13l9L4tYxPJaML8D+ha3i4vRqPna5VKpv1gYxWDv1kY3uuwphuNY/iLp
         cOmwE6YOOGSWNqlWrYJ5aOotL9kTLQ/+gsgevI+64u35Scgg/VwSJW6wC2N74e1q71bL
         jF2bQchqsV24pWE22093CYyiVZuRGsiDArr+g1A6yinF185pdSZT4VkZIXUpG95l9HSm
         fJGQ==
X-Gm-Message-State: AOJu0YzyGbKERevGgir5AttwqIwFFoGWxPuY9Ta0dQZEJ0iXy5OYuq2K
	+HsYgIsT8IVBmKOAqJPUIUe/GHzi8DVhPjj2thLXYlw0wsQZnqFXQMfNlBixzxAO3EZH1w9sqJl
	+ADV8YrVe5wRbvG0YXQjo5xG7isYDmWJt3ZuYklrZBf6rYZFHkyNgqjzTs3zFi+ZjzZ19McAzR/
	tU9A==
X-Gm-Gg: AR+sD12Ef08ch48RLYal7csVXwivHluwp53EGkFi5GkIpxHwAa1qdgxIsfpBcvWQ/G7
	qGneV92vuRBWsUcjINoC5iyevmOs4EfvA4SRO6p+ZXeJLyf+S9SmprBPXUKHF0HwetLdhqpq2BG
	CcxrFUUrWpZB543V3mxg/voLEPOk6nYmlHwJn03BJRa72ax63IxVam5QSFK0EBhMsfVYjIrxjm/
	nTMevWYolhdqIFYhYZ1uYivOcAJtqBZjqLxWuSufRhDfUj4PvlN7RHV8Vk4b3KUcc6XuGY+iocj
	BuWw1xjw3ZgCsuU4Itmg7znMueEqGlGkFc37E1L0DtbtUku0m7NoantK1PiVriNjDemQOIZo8vr
	TZNP7AP1kadsrRuGUPXV1hcxYxEZS9YjwkTU9L31L
X-Received: by 2002:a17:90a:d445:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-38fb11b7d37mr562392a91.14.1785471997791;
        Thu, 30 Jul 2026 21:26:37 -0700 (PDT)
X-Received: by 2002:a17:90a:d445:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-38fb11b7d37mr562361a91.14.1785471997224;
        Thu, 30 Jul 2026 21:26:37 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fa7470c5csm1094830c88.5.2026.07.30.21.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 21:26:36 -0700 (PDT)
Message-ID: <e4c7cc17-5ed1-40be-9f38-731611a05d5a@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 09:56:31 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: cleanup arsta in
 ath11k_mac_peer_cleanup_all()
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140232.133500-1-nico.escande@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140232.133500-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAyNCBTYWx0ZWRfX5aEDRJHa/laj
 TGJlkXlfYjHDFQU3NU85HEHg4vHkOQdsZNrrJhB3Fh3krXcqlf2VPanrG8RrAsRO09SQp1BgBtc
 odbR11iAL6GW5HImGoxCLYW6vlh42AI7GPNf5u26nYFuUL5urHztQ9AFwnpiCXwXPlnJo3PGmaS
 jjU7n6UGmWCu3f54YmnuF1Xjk0B5OW5BLAJF/HY5lZ5tMfnG9U0Y2l09KvjQEqM/96cK1UzLgcI
 1Pj2urgl8+wT8TMMhqOasFGkG4GLQ1jTIZdY28/R7/L0XsecK6J4ONLKeVe9fFHtfL6QMexnlb3
 SfLptNRyeks0LEsXmzWRqQ3UhwjPSYxnZbe15ywVxV92Q2WHQS47WcBVjD83FZGvxzpuJWIXm3B
 DRBKQZ/b1euwj0VmwWE/pUfHM76jCQ+8rJTrTaM2I9AzUAj67lEr5nUofnd+NeGuJJ9lessvCu8
 TuLmr6rekW2MHNTCe4Q==
X-Proofpoint-ORIG-GUID: w7vZ4Zd5A-lgSI6MpLDEld7URlHBjodD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAyNCBTYWx0ZWRfX0RWxqrCR4ZKl
 zxgOGSV4yjW0ir9nmjgb8TPkVjJAO/0tp5EYfo2BSeBt226M3Yf6h+BcRs5ASWYWkGRj0LIZi0Q
 Wn1mhVZRJeTFm0GbcqLeDL0xghvl1N8=
X-Proofpoint-GUID: w7vZ4Zd5A-lgSI6MpLDEld7URlHBjodD
X-Authority-Analysis: v=2.4 cv=H+3rBeYi c=1 sm=1 tr=0 ts=6a6c23fe cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=pGLkceISAAAA:8 a=-8N9TBOcdXP-3-f-2DYA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_01,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310024

On 7/30/2026 7:32 PM, Nicolas Escande wrote:
> When mac80211 removes a sta, it calls .sta_state() which in turn calls
> ath11k_mac_station_remove(). In that function we clean up both  peers &
> arsta related resources.
> 
> But when the firmware crashes, ath11k calls ieee80211_restart_hw(), which
> assumes that all driver related resources are cleanup up beforehand. This

nit: s/cleanup up/cleaned up

> cleanup is supposedly done by ath11k_mac_peer_cleanup_all() but does not
> in fact free arsta->rx_stats / tx_stats.
> 
> So lets extract the arsta cleanup from ath11k_mac_station_remove() into a

nit: So lets, ... or just Extract the arsta ... to be more imperative

> new ath11k_mac_station_cleanup() and call it from both there and
> ath11k_mac_peer_cleanup_all().
> 
> This should handle kmemleaks reports like:
> 	unreferenced object 0xffffff801ae66400 (size 1024):
> 	  comm "hostapd", pid 1306, jiffies 4295011565
> 	  hex dump (first 32 bytes):
> 	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 	  backtrace (crc d61c08ec):
> 	    kmemleak_alloc+0x3c/0x50
> 	    __kmalloc_cache_noprof+0x2b0/0x3e0
> 	    ath11k_mac_op_sta_state+0x1dc/0xb10
> 	    drv_sta_state+0xac/0x6f8
> 	    sta_info_insert_rcu+0x314/0x5e0
> 	    sta_info_insert+0x14/0x38
> 	    ieee80211_add_station+0x10c/0x1a0
> 	    nl80211_new_station+0x3e8/0x680
> 	    genl_family_rcv_msg_doit+0xc0/0x120
> 	    genl_rcv_msg+0x1b4/0x258
> 	    netlink_rcv_skb+0x4c/0x108
> 	    genl_rcv+0x38/0x60
> 	    netlink_unicast+0x190/0x278
> 	    netlink_sendmsg+0x15c/0x370
> 	    ____sys_sendmsg+0x120/0x290
> 	    ___sys_sendmsg+0x70/0xa0
> 
> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 9d5f28c1366f ("wifi: ath11k: fix connection failure due to unexpected peer delete")

As Baochen mentioned this should point to d5c65159f289 ath11k: driver 
for Qualcomm IEEE 802.11ax devices

older stable trees before 9d5f28c1366f would need a small contextual
backport: add the helper and replace the direct frees in 
ath11k_mac_op_sta_state() rather than in ath11k_mac_station_remove().

> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
> ---
>   Note: this problem is in fact older that the referenced commit, but as
>   it would need another patch to backport to older kernel and the leak is
>   quite minimal & seldom happens, I was hopping to not have to do it.
> 
> v2:
> 	- rebased on ath/master
> 	- no code change
> ---
>   drivers/net/wireless/ath/ath11k/mac.c | 25 ++++++++++++++++++-------
>   1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 2d55cdc4d165..ae91b57c8422 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -873,6 +873,22 @@ static int ath11k_mac_set_kickout(struct ath11k_vif *arvif)
>   	return 0;
>   }
>   
> +static void ath11k_mac_station_cleanup(struct ieee80211_sta *sta)
> +{
> +	struct ath11k_sta *arsta;
> +
> +	if (!sta)
> +		return;
> +
> +	arsta = ath11k_sta_to_arsta(sta);
> +
> +	kfree(arsta->tx_stats);
> +	arsta->tx_stats = NULL;
> +
> +	kfree(arsta->rx_stats);
> +	arsta->rx_stats = NULL;
> +}
> +
>   void ath11k_mac_peer_cleanup_all(struct ath11k *ar)
>   {
>   	struct ath11k_peer *peer, *tmp;
> @@ -885,6 +901,7 @@ void ath11k_mac_peer_cleanup_all(struct ath11k *ar)
>   	list_for_each_entry_safe(peer, tmp, &ab->peers, list) {
>   		ath11k_peer_rx_tid_cleanup(ar, peer);
>   		ath11k_peer_rhash_delete(ab, peer);
> +		ath11k_mac_station_cleanup(peer->sta);
>   		list_del(&peer->list);
>   		kfree(peer);
>   	}
> @@ -9892,7 +9909,6 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
>   {
>   	struct ath11k_base *ab = ar->ab;
>   	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
> -	struct ath11k_sta *arsta = ath11k_sta_to_arsta(sta);
>   	int ret;
>   
>   	if (ab->hw_params.vdev_start_delay &&
> @@ -9916,12 +9932,7 @@ static int ath11k_mac_station_remove(struct ath11k *ar,
>   			   sta->addr, arvif->vdev_id);
>   
>   	ath11k_mac_dec_num_stations(arvif, sta);
> -
> -	kfree(arsta->tx_stats);
> -	arsta->tx_stats = NULL;
> -
> -	kfree(arsta->rx_stats);
> -	arsta->rx_stats = NULL;
> +	ath11k_mac_station_cleanup(sta);
>   
>   	return ret;
>   }

Actual change looks fine to me
