Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C593E639E
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 17:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784827318; cv=none; b=IT2acGdB8X4MUJ3q8e+r0MCvD6u26bsfkT6Oq+IKvZNsMX+aQXZRO1I0BafsD/48/4S6wSiiPay65+q4wxWqSFIm43YSg8qtdlzo9/tJ/R2ZlsWybasxPPdllLxQSow6SRoK5Ck8obmXW6/KCnXSBiLhdr3SnBiHGUIf9RNO16c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784827318; c=relaxed/simple;
	bh=34EaAO/212JpZuLeUzgaxQMEviJ3JDUXyRw1Aqv1u40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7/nqH+Abjqg7m0FosSJIT6YyilHVZW7TSxKnddkC0BQ4MRmS305hhhS6bikKEfGltVRPVE/9KjQH2PYlutmDFkBOYo83mWU8cxzqWb1BdKd7hDjA7VtKQ5kCtwS04LlscDQP0XfSEC/IRO1EmjlJmz9U7PLmWQgpKq4xcHH0p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TcCw/1KE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z6O2hR9D; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TcCw/1KE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z6O2hR9D"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NG596h482788
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 17:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nBubX+qYzAE+thkmI0/fBJno+EcSFSapyej/MN4ZLsg=; b=TcCw/1KEO4hqSTh5
	EbR5wulddeBNwWT6LlQUO+Kvfioib3uJme4fADUp3cH2T77TC7xF1fj8keGpcnG0
	D2P63zRc28+lPiFKt9ACBctaWwObyogaHcIQmXrA/g/AI/CyStcV8GdtbyS9GvSh
	sPgwwzZRpOl6ellW3TTWqxeRuyXpdjiwgxWmw8EFnpfVQmk8wnN+hQguhuk/fNcH
	e0fz4DhFLpjC5QfRclbuw+Oh4eEsTfQ/hZhKN3qpyFlbuCi/ZbxK1D/5t8gEap+W
	LxLFqOwm73mdTNWqLvypPqrDf960tBPiOV//rgUjJxO4wQo8KK+QHsITytN9hmzl
	NkbvEw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkp5vgc2e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 17:21:55 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so1401491a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 10:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784827315; x=1785432115; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nBubX+qYzAE+thkmI0/fBJno+EcSFSapyej/MN4ZLsg=;
        b=Z6O2hR9Dc0Fk8mO58aePdAf/xBCx9PZivPr4mCAHUox/YTclNZNPiO4JOEq2an7yJO
         h4/97Y0peM5Qza0CPK8S1VkTB5Z3DuoTzOdbOVf769BhLe2F5bGc+ylcNiY+A6DgmsxQ
         XsFODMvBwdYOgJSstW0vQM3L/4UVofbPRCTe59p2tAiaXLDwIWyfy2Dy3PKeQ9hhNmAP
         FrzpeDMY6zDVJE1/lHFDGLba7l0oofM1UjVhuuXbdN4RVjLDwZbXUr9tIGUmlVepWps3
         JHCTb4vk35UzJUquoidblAtWJz9PoYEDq+g9S6LKx9byWBOfp+As6NmmJOYwY6aRaE18
         BG8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784827315; x=1785432115;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nBubX+qYzAE+thkmI0/fBJno+EcSFSapyej/MN4ZLsg=;
        b=PvLOcQaZClaMHTNm3pXBgGon6Dvg1njWsNeY8OFM6G8x+4RREAJIZl/zBuR8O3wlNY
         zLSNP/fWKOtgve6XwK5NnA6WjQPq4fMHtlw8dBho9qkAWv91MxrDHKbOgK3nL4VNVRGd
         xrIQbmx3Q3nZx42R4wSsAvi7v1kp2Jfs94mA0tN5rPLTD2MaJuSbpjkVmIg5ltnu3IJ3
         pMDoA1rwM5GpMWl5sfrOuYB1QYGyLvzvvVnO6IYe1WbjeSg7gpxPBS8WuMhVC9ayjTzp
         yCuhjoRIDSadxqwpWxRDJ+4c7P40ntX+LMwTOU1DwdslnPlNuc5pfdxuMb3odwtSBjpY
         xu/w==
X-Gm-Message-State: AOJu0Yy8GhmayFwwopdW7Deiu7qIrcHZ+Tx01B1ZVQYH8cn1I1vTifNq
	fQhZruO+SnNaCcByNuJ82/MRpBNrFZiJVD//NFwHES7e0ubzMKOMlpqt5Ttd0MkUQUA0cPF8bPM
	wlJ9o8sy/OAsqP5ANar5iVfjqL2ySezUq4tZC+GFo8SjWEfAcTWJ6x2WivwoSQ3ebvucWUg==
X-Gm-Gg: AR+sD11TbV2H07WXumvXI3Lzzr/8Dj53Nn4b1XjCxLCByR+03tTjwuoySLlSliza18j
	cggbKZNn/u21mOXA17BuHe8Rixqu6E4iggjstidnH1fmVHgBvXZIMGpyDS/O/NyLVAU0ps1lXtV
	uJ6rzEGSVBBP+nNUnXH7y4BgKq7a+Tbxurv1ZA0SrjzDWSqw3SWsU91VDgJnUGQV+i9rZS9/gfa
	4mrvtydk+uYMIdJh8l3P8qK1x4mK0TuzV5APNN33bdfkrFnspI2Efy7GiY42FgBueKIlYzE3amI
	ByyCryPXsHxaSTmkTJ6UNoQGku5dlUXn5SGPXK3RlGjo1iTVimQcu1vOqzDdQluC9mQHc4BiNec
	mAIk6l3BIoLZxZpWeEjIy0rsWvEsPw474i69bCrwnGd5WZOKCAHB0SZcm9g==
X-Received: by 2002:a17:90b:3905:b0:38e:2524:724f with SMTP id 98e67ed59e1d1-38ec64dd02bmr4247423a91.12.1784827314823;
        Thu, 23 Jul 2026 10:21:54 -0700 (PDT)
X-Received: by 2002:a17:90b:3905:b0:38e:2524:724f with SMTP id 98e67ed59e1d1-38ec64dd02bmr4247386a91.12.1784827314344;
        Thu, 23 Jul 2026 10:21:54 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130f42bbsm19082660c88.14.2026.07.23.10.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 10:21:53 -0700 (PDT)
Message-ID: <4b634fdd-cd97-4e2c-b253-8d239874bcd0@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 10:21:52 -0700
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
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2OSBTYWx0ZWRfX8K+IVCTJ/HlM
 ZLTW6iKyaig/IoX8e/u0REhaN6QMlYA37hnBqcyFqns+n0Q8Hu47UOha3IiwadoTQOcM//VhH9i
 ntXBOeSfEigAt16BFXOLVOj/bF4o0ow=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2OSBTYWx0ZWRfX7qDzDogTULWU
 NR1fSkUm82oMuC7ECxq4N1kbbUcUZ+M+yOc3PUdsoHJGPUq0JprczsFQPB4YUk9v0UyxCT+phzj
 SEGB4lQPXaaRMXqHkgOsF5h+FVoAiqC093tjYg78IbGPsZqK9WCmf7RsDpR+WGRttJxVPYYxm9w
 YNzFnYd/EnOW8UC1rK1c+YsESjjk/Gof/xX9/lGS0TqGRoVGgGapCfR//bi199ZyGCgXskLFY9+
 I+qvIBSlAVjMooTSS9JCa5bx6JFNU5DRm8tU3bttmDrvKLhonVFyybBU61nHYgQkcwo4M6ZGHlN
 bPVV1pBBPvqxXhsvJgUsJSrnHwuWlJ/4ny9McXiZpmaXtRbP9damxRKZe4HOTKzTF/77Twbe4o4
 TaHd3suOtQ1h+8pVRC5v/Y0SxUpM7IeG6znfpwl/ff86+z/EUG3psaDF3SBFnyb90An4DiBtH17
 abMw36R28Ah/sC9ennQ==
X-Authority-Analysis: v=2.4 cv=Z9Dc2nRA c=1 sm=1 tr=0 ts=6a624db3 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=qiebmGgv6xejdxd45h4A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: Nf7rTMTsDKTLDlO4QRkq2JzRpIuVCIxR
X-Proofpoint-ORIG-GUID: Nf7rTMTsDKTLDlO4QRkq2JzRpIuVCIxR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230169

On 7/19/2026 11:43 PM, Baochen Qiang wrote:
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
>      ath12k_mac_dp_peer_cleanup().
>   2: group peer assoc send-and-wait into a helper
>   3: refactor, keep ATH12K_PEER_ML_ID_VALID set in ahsta->ml_peer_id
>      so later patches do not have to OR or mask it at every call site;
>   4: parse the HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP message;
>   5: introduce hw_param host_alloc_ml_id, set true on QCN9274 family
>      and false on WCN7850/QCC2072;
>   6: on host_alloc_ml_id == false, leave peer_id_valid unset and send
>      ml_peer_id == 0 in WMI_PEER_ASSOC_CMDID;
>   7: on host_alloc_ml_id == false, mark ahsta->ml_peer_id and
>      dp_peer->peer_id as ATH12K_MLO_PEER_ID_PENDING and skip the
>      dp_hw->dp_peers[] publish until the firmware reports the ID;
>   8: in the MLO_RX_PEER_MAP handler, propagate the firmware-assigned
>      ID into dp_peer->peer_id, every dp_link_peer in
>      dp_peer->link_peers[], and ahsta->ml_peer_id, all under
>      dp_hw->peer_lock.
> 
> ---
> Changes in v2:
> - patch 5/8: initialize ret before goto err handling in ath12k_mac_allocate()
> - Link to v1: https://lore.kernel.org/r/20260713-ath12k-fw-allocated-ml-peer-id-v1-0-d0a2a1a519eb@oss.qualcomm.com
> 
> ---
> Baochen Qiang (8):
>       wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()
>       wifi: ath12k: factor out peer assoc send-and-wait into a helper
>       wifi: ath12k: keep ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
>       wifi: ath12k: add support for HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
>       wifi: ath12k: introduce host_alloc_ml_id hardware parameter
>       wifi: ath12k: do not advertise MLD peer ID for firmware-allocate devices
>       wifi: ath12k: defer dp_peer registration when firmware allocates MLD peer ID
>       wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event
> 
>  drivers/net/wireless/ath/ath12k/core.c     |   2 +
>  drivers/net/wireless/ath/ath12k/core.h     |   3 +
>  drivers/net/wireless/ath/ath12k/dp_htt.c   |  49 +++++++++
>  drivers/net/wireless/ath/ath12k/dp_htt.h   |  12 +++
>  drivers/net/wireless/ath/ath12k/dp_peer.c  |  75 +++++++++++--
>  drivers/net/wireless/ath/ath12k/dp_peer.h  |   2 +
>  drivers/net/wireless/ath/ath12k/hw.h       |   2 +
>  drivers/net/wireless/ath/ath12k/mac.c      | 165 ++++++++++++++++++++---------
>  drivers/net/wireless/ath/ath12k/peer.c     |  31 +++++-
>  drivers/net/wireless/ath/ath12k/peer.h     |   1 +
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c |  12 +++
>  11 files changed, 293 insertions(+), 61 deletions(-)
> ---
> base-commit: 951dc0a744e4dc8490935316d3b76e23990bde3c
> change-id: 20260527-ath12k-fw-allocated-ml-peer-id-2b456891157f
> 
> Best regards,

This version LGTM other than the one commit text nit I can fix.
Will wait for Ramesh's RB tag to pick it up
