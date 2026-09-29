Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C703B38B9
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790689370; cv=none; b=gze89pvjosN39+pTxtWm/qA3YfWQQ0MkUkFMNjv5Co28zzYBBOhtBcjk3/9jbeAOQTO/oo34Lr/gE33Ses/1q1ClFZ63cq3VEzjyXcmEedq/n+aLCzZBcUnLpt28BfNdwiwIEL1QObm6j/wIKsw3Xr+toDmVbCcvxzLaUtFf6cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790689370; c=relaxed/simple;
	bh=iCvByNjKt6QMSv5n6e7ZqpFxTzkQZqEHS2f96tEZyk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HC6OGlf6bVgvdpWltvW162T92JtlFcOy/GwtZiPfj/7b1C+DpksgAq6CvRd+eslEExKvWdP9zJ0I/W0gB942MHuSx8MjlcgmTWUtSgmrjbOk+Tyzjj8mcdRmGA6JmkgVf7L2fm10M76tgQoG62CGnot/KtKMU7FwLNUqLiHpkg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ITCSzNyr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OoE3Yoky; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ITCSzNyr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OoE3Yoky"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCrDMC1018403
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 13:42:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	A4q8PcKc/LALQELqeDQHOETFsx0GxhuJarxyxdMEMOo=; b=ITCSzNyrm/C2l0os
	cTNFBDHKMZM+8ds77Kjc2401zZHx0TrxHsuh+tscdfu1oQWM0YP/PU/BdQhh6cLN
	c1DEAmZ+fW/5/KmCUB4oAIOpAkm9dE0h5oa+g0J3B28srtIz1XSDeEpWRJEbsDPG
	lVZubpuiv8zbIxULnEU2njgTuLLc1pwRYfGOhmfXjZoxCEkG/rwnvyMCEiKaXGqM
	4YCEhdLH8m9kzfsPp9YeUv+3IadaZy5gDKb04yNylI8g/1aH77klohi/3OI55PAP
	pEPj7a3dMdBfva0NlRd0va86vUQvwS4SCIPgavHOkLO1af3LbhSlMa1vsBmmkxBz
	O4JyCg==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h05yxj98p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 13:42:47 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab8b4887d4so4017575b6e.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790689367; x=1791294167; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A4q8PcKc/LALQELqeDQHOETFsx0GxhuJarxyxdMEMOo=;
        b=OoE3YokyZ6pF+8eFiObp34dHZ3ri6N9Ef/ORuHOajKsDzaa5dNYP+xTvVokWnv4uJK
         nYHEpbi1/p69xjSNoTp66PHJwWFqYIg8t/F95vyWzpwtNrleM0B+ojN8sb7x1PLiqBj4
         vlTige4gy8jnDIKsGXOgYIyOkmNW7F3tA9IY/FOFwNs/8hXSGZdmac49K8O8EU/Ryy8V
         r3mT37mapVjFUUvZphFil00W7jqZVpB2+y3s86JrQo34/CTbP72KCqXUpJu+DCupE7iU
         xTxNUSmbJqgJJgOdhvOIHdQgpWp32RT94GEByn5BE1AEd4nE6+ONL6IUj7+ScuCljfEc
         krOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790689367; x=1791294167;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A4q8PcKc/LALQELqeDQHOETFsx0GxhuJarxyxdMEMOo=;
        b=NQKy5KpyLOOmERem9JCCIk/EheSM2v0DVDKEBRoYogqOjs9Y9LMhtUhkPn5Xk6cUcD
         jYFRbM52N1DkBfoEe7lFrWwHvo6LbS1YEATdMrdP+SzprDD1PEoS9uJKuzVRIDh/Nc+I
         spYymWYctqLYbxN8AbhDGpF1yCis2H/UE2C3UqpOg1MshmmWanrJlU2KD33k/mNTOh2a
         jleUljQvtawawo5MosnWBytPzYr2sKsIKZOhO9Q8eGuRTZRL+Vi0plst2zSUDaMFtVTK
         hhrroZ1F6s+SAAdCoBcM0WbOPJT5K2owvowB41LMZivKsIKkWFzWuOpn6zsQScipDIHq
         z0Mg==
X-Forwarded-Encrypted: i=1; AKwUvBwx5HramRG9F1Vw7LN+DcU9hcTLXMCM2bH/KQoygD1XtbKBGdLAGAhoZCNOuT+vVu7U/7xPW1X6NSWsRbYqeQ==@vger.kernel.org
X-Gm-Message-State: AFuF++msedRQGJzShsh4QxaB/GKJAw+hvaS9q4JBWma+YokgEA19a8Qv
	c6OfgbCWWoIfLZIfKprqBS/hTg1YKXFy00BkLt0HWKZBMkx+yjPv62joQRCjpTpN84vFOxTAy//
	xgJp0NqFl72SMW7emAgXyA/dMkvCpGSauA5MimwwIEOwjpx+ucHbNnFP+6f6vrR3by2xn4g==
X-Gm-Gg: AYBFou0HWFlvkHhqzezMNJqI0ybCseiWGu46NuMxGR12DurOwVB+W1FDjojKC83kGmU
	+sZ2QatQZvTtYY/0INEQ04DlKpRiADoFvORxOAsbgCzwgzic+HdHj14Z/Z7jCCUPpJJUmIlc7Qz
	EVX2wMkK8FnYkYX2Dani+/K3s2NAMZv8K0z76AIXdsAAb+sYajhw6Wr7u/TnFnk/hgWRapcPL4N
	/Zqk+4yvs7gnvcgfQvbSRfXfZuf7wML2hW0Kl4ix/Rc4swmqk/fu1ZRhg0cuvLvSM0/PAUypZ5W
	2neyCmM0JCBNwUV2JvLZwOnjO9H7S2kNOPRpQ3dhPUioYUNwbObkUqZtcdQUFTBqDzFm6ImBeLk
	5m47aYlmbJ7vQYk+eZIOPa1fvuFRpUVL5NNkU+w5vMOmsiLTklp8EtTq4dsxH
X-Received: by 2002:a05:6808:1314:b0:4e8:5ba:8809 with SMTP id 5614622812f47-4e805ba8a21mr9177523b6e.26.1790689367090;
        Tue, 29 Sep 2026 06:42:47 -0700 (PDT)
X-Received: by 2002:a05:6808:1314:b0:4e8:5ba:8809 with SMTP id 5614622812f47-4e805ba8a21mr9177485b6e.26.1790689366517;
        Tue, 29 Sep 2026 06:42:46 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ebbd3520c1sm4151760b6e.17.2026.09.29.06.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 06:42:45 -0700 (PDT)
Message-ID: <d44a7d63-2540-4886-a709-9fd75cbd4c0b@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 06:42:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: Fix failure to create
 ath12k_dp_peer on MLO reconnect
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1NCBTYWx0ZWRfXxrDCgV2mUe3G
 B2Ano5s/AWuuavilNg1qrDLYkswcCRurlav5YucqXgJuKVRhr/d2U8IlYSA7ptlQ7hqfN2Odd2+
 oYELaqmedCmvOSpR7UDyKmm5cqp4OFM=
X-Proofpoint-GUID: CR01YqxggrfNFaBdvdNu2906Xmy2AEn5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1NCBTYWx0ZWRfX3QHWyeFIMmmj
 wp/q6vKFhGk5l+J4d2T6jhP0+YV9DpcSARtrC+lScLMqKfKCaWOhnJ0efuFpZWwbCPQimDmZQj0
 ZfwHGBi9bHhaP2oxAqmfWseTpiN60EqJEipER0A1CZWC8sQSaqDcf6e5eWygQCiutFTxCZyOH54
 ejSFDrFURpBayQJdInQKAmbsKQyrgkC3xIrwYzokBfQkmSIUf2kh2B0mZZwVRxNWE78Nw0NgWTJ
 3/wsBcis3Oy9r17cKKZGs+xB4kSiSt5Eyy/xvy3LP9i1mC7iZ0XxwWhM3gqs5Ab/AQ8psMq0xw9
 QGAQPZrbxfUFfvjwKT1N0lvrTgosbiUTFp5cm+CEDWbrwjWFeIITDRcvw/Ujpf+1/63Ho/1lNOn
 Mup3J6/eJAC6AHbnWF8ZHxqSxPFFwf7iHLQbbJx/wMyUec9fQOt8g97MM4sy6yRMlUokHaqF1bv
 l/heCWBpwRULbFV0omA==
X-Proofpoint-ORIG-GUID: CR01YqxggrfNFaBdvdNu2906Xmy2AEn5
X-Authority-Analysis: v=2.4 cv=SaFi5fRu c=1 sm=1 tr=0 ts=6abbc057 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=FeBjiSnNOcrKIJN5QMIA:9 a=QEXdDO2ut3YA:10
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290054

On 9/15/2026 1:00 AM, Miaoqing Pan wrote:
> In ath12k_mac_op_sta_state(), when transitioning an MLO station from
> IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
> succeeds, on is_sta_assoc_link verification failure, it takes the
> 'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
> the dp_peers_list.
> 
> On the next connection attempt, ath12k_dp_peer_create() finds the stale
> entry and returns -EEXIST (-17):
> 
>     wlP4p1s0: failed to insert STA entry for the AP (error -17)
> 
> Fix it by changing 'goto exit' to 'goto free_unassign_link'.
> 
> Also, there is another error path in ath12k_mac_op_sta_state() that
> jumps to peer_delete after ath12k_mac_assign_link_sta() succeeds, without
> undoing the assignment through ath12k_mac_free_unassign_link_sta().
> As a result, the link RCU pointer remains assigned and a stale bit is
> left in ahsta->links_map, which can trigger the same -EEXIST failure
> on subsequent reconnect attempts. Fix this by redirecting that error
> path to free_unassign_link instead.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 0cd46d1f36ce ("wifi: ath12k: identify assoc link vif in station mode")
> Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
> ---

Baochen has a more holistic approach to this problem in the works, so dropping
this patch.

/jeff

