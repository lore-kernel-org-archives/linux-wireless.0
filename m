Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2F14315A
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 04:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784868945; cv=none; b=GhjEm5jILV+iA8d484hzPjHn5ZVFXn+aRletJu2BHIk4GJ2ifxe9Anx2Id9cs7DY5Gcfz/GlJixaAc5F72mfYEZCJkaaXgAm922Rado1djiczd2vc9+G44/XV2HQn24ffytHV2yTMtQWgBOVcI2WNdhvE0NVEbl2Pe9l7JJuoZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784868945; c=relaxed/simple;
	bh=YtyXZgJihk4e+oFcI4i+ttPqVRcRc9i0BxR6uKJoYD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ci67vfLVxxPfyOg3rWJ02BRnXqnOmue8bJSAjwUmushUzqsLSAAw2+zt39m8w38VYn9Gn7uQbT5/MOxE27R/6bV0QSFZ2yZac5pMtfvo8oL25iLfXytIaRfT+EuQTzKRrQPrqApRqshey/LAh9cWOhhDBTStNng7nUmqFYTbkQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QJdn+SWv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kpvJ1+lb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QJdn+SWv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kpvJ1+lb"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4siFA1897295
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 04:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d40fEAvsg3aYGm3ZuNQRGj0KLdYyAEXqJk6tyRxsTW8=; b=QJdn+SWvp2Hj6tHk
	N22hdSqVUq2dtb/PczEtPHIXGWocvLC04+KxPa/tagQMdNSH1Tbg39GX668P8ILZ
	KH+hx+C/g7TzfHkJW/8Ie1sLSIizyEq0hy88wqcX5UEls7PD4fOOZFnSMst8edc2
	JDu6LkzRvelGyEv/sfsJ8jWw586oRsdkXncXgQnSE84Vr7nO3eaV3ALJlTIjaN7l
	6YYMYghZPx7ISHli9Y3mxPDZYBQ6hGFiEkAHRgBnHUxKKvNgqKobKwc7hc7oOcpW
	O00yzhEbEHBAT+GJx04FMpmMWI1EkZLfeeVY/bxABwgIJvnVZBDQo8+nQCNqq8gH
	rqunCA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fm1em803d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 04:55:42 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so1110455ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 21:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784868942; x=1785473742; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d40fEAvsg3aYGm3ZuNQRGj0KLdYyAEXqJk6tyRxsTW8=;
        b=kpvJ1+lbpeC72o+VdpzSTOLN0B/JMyQdZKRvNV+EMFB+L34gV4lioMV/KX//IZkg03
         Uhvf7YzAkDT+wMyTpmgz0HkPgEqkwW2oc9YEjjrjiDmyQN02nOVUoJN9Nutx6yRDHy5V
         yFzJsM59gjKvmFgWHOPsOeiAQB+TRIIly+yNYETXAj463ORGKWr98zmxGd0nuG78lEXw
         +kV2vjKOeXOkz4mx9nZBeYuQRpL6zP+hBg3Q43FkT+kcp5p/NasqR2W7b07MXd9U+u3u
         l1n1lxxs8DWZp7ec5CpEB+hlzkMx7or3EwA57aWeAFdvpV1/7PmUwUIlLg3vtXZdwyIy
         bgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784868942; x=1785473742;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d40fEAvsg3aYGm3ZuNQRGj0KLdYyAEXqJk6tyRxsTW8=;
        b=f5Msl78BXuYnDAV6rBdRQWw8auvi55ki6OSqlcrsu7IlRk4V7QWVaq4ty2fJgkbJW7
         jCiE6ULaMKW9n68qkWcVNEWso2RACG9K3/UoWcE8Vt+0ZL0vUIzazF0ZcP3YoZs0XyRr
         0T4qyd27lg8RAiAREDKwPWJ4VLFNkk+wRrNo9d/+bJrgNNO20qhzxadvf1ZbiN+YnAxk
         vDrli2wfpCKZ0S50dNpwR9XR53g91wXs8P7MHEAa5hBpD03bw8SAPUympT3sAaPYdyaN
         t6Vit+ZtdZVdqGUslBZbmoP4Rf3Hbijxn2UG5Od8kDyKuicpGL5cpK50gJ5DYXISiuWh
         KSnw==
X-Gm-Message-State: AOJu0YxHT2eD/Xad0x7ZMOW3Xj5zm08/Nlyx9UgGa6LrBsjnKlHKfzzw
	8Syw+6VcbxTeMsm60OPY/hJYy5MFmhPC3zD8eDbUPeWJho0ztuzV5kruvyoIc0Le/QSdnRqDLZy
	eFDKw1UmModIZrZG5X7t8d/ss87ShYIrBfboiRxJ/C/xs48Dc+2x6hawIoe29abQQC5O+bg==
X-Gm-Gg: AR+sD13Nbme9bH6kUKlx6vT90gO2w1rxq1iM2QoyhFgjE1pjgLLVYJYVTdk3giV4VPV
	rkhdp+4rYG/zNMgQvw4IW7PvdQgKxb5lyLT4JGNol4QCdNlLP3wymZNA+mOhRP7X0WWTwl6mPkE
	y8srPG/30Ia5BrH/FA34lILi2+c3P0NMxVPV40DY/jjNDkJLjmurb8BUGhklGOHGWHLc+zN+4EJ
	pDWorDnEvGw8Y921CPEHW9x7JCq2pnHoZs2L+7mD4iiZVRGi6TEuVLfsW87cQcKNaX91FuMQADO
	RvGfG3zuVDFCcB7SqmwAMtG/mbxIIfl8DTSghxX1IjquS6Sf+4oZQ0RTRlKYKhnNy9IXDhnv5K5
	+x1mHfSiv5MmrhFxREY4SwORhgIi5EHc3xsbd1a+z
X-Received: by 2002:a05:6a21:117:b0:3bf:e3d6:ab5a with SMTP id adf61e73a8af0-3c44b210ec8mr6635225637.52.1784868941920;
        Thu, 23 Jul 2026 21:55:41 -0700 (PDT)
X-Received: by 2002:a05:6a21:117:b0:3bf:e3d6:ab5a with SMTP id adf61e73a8af0-3c44b210ec8mr6635200637.52.1784868941414;
        Thu, 23 Jul 2026 21:55:41 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc1a6adsm24598410eec.6.2026.07.23.21.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 21:55:40 -0700 (PDT)
Message-ID: <4b27b14b-23cb-4cf4-93d9-239cd2cc08b4@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 10:25:36 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2 0/8] wifi: ath12k: support
 firmware-allocated MLD peer ID
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA0MSBTYWx0ZWRfX1RE1qwTscIcO
 8xWANsjThjhE+ak48s+YVktsgkwbUQWUWY3ylpzlwrXDdY3tkuiL6xrxWXYtchtAr7tEkxilMe4
 fZlvI3R9vWzuoZs9GU8lxkHxxvrzoek=
X-Authority-Analysis: v=2.4 cv=BIODalQG c=1 sm=1 tr=0 ts=6a62f04e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=1CCuyHwD0-y4VE8UPjEA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: byf41SmSCISCk52OKRnKaMZe7ai9XjRL
X-Proofpoint-GUID: byf41SmSCISCk52OKRnKaMZe7ai9XjRL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA0MSBTYWx0ZWRfXzOXQvnANezsc
 2h7Fe4Umt/NKGW9Gb+0dx1ihu9KhzjjXYnr6RgxEB5TUyIIXdg+osYTOIlRM6FXyeO6Z7aEsnLI
 zqrLsYc+WPdcjSzPXDsfIQeN9/9qZ1oCJ0f05NzJ062BOiuQsap8rahmUbIPpDtt2j8rAgXRV5K
 ejTDsGKfAIOveAJoEmMliAl28FazkgAuqMLNyiLaS1GYonx/BokgoXoKN+JQexIO21/vaFHYhv1
 nI1Dc8oX7qitXo7L7S7hAt7+CzWgJNDClq3Hmh/FfKvK0zOxkuMthg3YpFMb1I9x5hNhUmvGIrq
 krsmnTDkipiq9oufopDQF9Q9ctQuWSxHuJijqIVBDn2bXM64MbFOQpLXPla94tTqPLbT5/bpiY1
 Z+l3jxEnphr7ibjg4QuzGjrZRGyYdvFzGEAAePhAfmO2z5X6Y3do8HgXQZnxJJC21TObNU711ou
 pwpeMWggUBZytsgUS+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240041

On 7/20/2026 12:13 PM, Baochen Qiang wrote:
> ath12k currently assumes the host allocates the MLD peer ID and passes
> it down to firmware via WMI_PEER_ASSOC_CMDID. This works on QCN9274
> but breaks WCN7850/QCC2072, whose firmware always picks the ID itself
> and reports it back through HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP. As a
> result dp_hw->dp_peers[] is never populated for MLO peers and the data
> path lookup fails. On QCC2072 the firmware additionally crashes on MLO
> disconnect when ATH12K_WMI_FLAG_MLO_PEER_ID_VALID was set in the peer
> assoc command.
> 
> Add a host_alloc_ml_id hw_param to branch behavior, defer the
> dp_peers[] publish to the HTT event for firmware-allocated chips, and
> propagate the firmware-assigned ID through the existing host
> bookkeeping when it arrives.
> 
> Patch summary:
> 
> 1: fix for an out-of-bounds clear_bit() in
>       ath12k_mac_dp_peer_cleanup().
>    2: group peer assoc send-and-wait into a helper
>    3: refactor, keep ATH12K_PEER_ML_ID_VALID set in ahsta->ml_peer_id
>       so later patches do not have to OR or mask it at every call site;
>    4: parse the HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP message;
>    5: introduce hw_param host_alloc_ml_id, set true on QCN9274 family
>       and false on WCN7850/QCC2072;
>    6: on host_alloc_ml_id == false, leave peer_id_valid unset and send
>       ml_peer_id == 0 in WMI_PEER_ASSOC_CMDID;
>    7: on host_alloc_ml_id == false, mark ahsta->ml_peer_id and
>       dp_peer->peer_id as ATH12K_MLO_PEER_ID_PENDING and skip the
>       dp_hw->dp_peers[] publish until the firmware reports the ID;
>    8: in the MLO_RX_PEER_MAP handler, propagate the firmware-assigned
>       ID into dp_peer->peer_id, every dp_link_peer in
>       dp_peer->link_peers[], and ahsta->ml_peer_id, all under
>       dp_hw->peer_lock.
> 
> ---
> Changes in v2:
> - patch 5/8: initialize ret before goto err handling in ath12k_mac_allocate()
> - Link to v1: https://lore.kernel.org/r/20260713-ath12k-fw-allocated-ml-peer-id-v1-0-d0a2a1a519eb@oss.qualcomm.com
> 
> ---
> Baochen Qiang (8):
>        wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()
>        wifi: ath12k: factor out peer assoc send-and-wait into a helper
>        wifi: ath12k: keep ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
>        wifi: ath12k: add support for HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
>        wifi: ath12k: introduce host_alloc_ml_id hardware parameter
>        wifi: ath12k: do not advertise MLD peer ID for firmware-allocate devices
>        wifi: ath12k: defer dp_peer registration when firmware allocates MLD peer ID
>        wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event
> 
>   drivers/net/wireless/ath/ath12k/core.c     |   2 +
>   drivers/net/wireless/ath/ath12k/core.h     |   3 +
>   drivers/net/wireless/ath/ath12k/dp_htt.c   |  49 +++++++++
>   drivers/net/wireless/ath/ath12k/dp_htt.h   |  12 +++
>   drivers/net/wireless/ath/ath12k/dp_peer.c  |  75 +++++++++++--
>   drivers/net/wireless/ath/ath12k/dp_peer.h  |   2 +
>   drivers/net/wireless/ath/ath12k/hw.h       |   2 +
>   drivers/net/wireless/ath/ath12k/mac.c      | 165 ++++++++++++++++++++---------
>   drivers/net/wireless/ath/ath12k/peer.c     |  31 +++++-
>   drivers/net/wireless/ath/ath12k/peer.h     |   1 +
>   drivers/net/wireless/ath/ath12k/wifi7/hw.c |  12 +++
>   11 files changed, 293 insertions(+), 61 deletions(-)
> ---
> base-commit: 951dc0a744e4dc8490935316d3b76e23990bde3c
> change-id: 20260527-ath12k-fw-allocated-ml-peer-id-2b456891157f
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

