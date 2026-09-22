Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F32B33F59A
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 12:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081028; cv=none; b=fbM7q0ZhxpLG4TNcmpUQONZaWnbHKgga759oSgcmxBWCyiqpHSUjQlNyHQesDyEKhjT3aum6+UO46SgKUh63tqGEsVjBQ7NA72IbLPjIJMzbkciyPzog4aS4mG67ChOzd746SZTO6b2kIKQ82yebFiz1VoV9ztWTWT4DsPvrxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081028; c=relaxed/simple;
	bh=lvItJnQZOiSblYTc02DR1TpdqxZksZA3LYi8XWAn3to=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4zkqy4lD7mzv3vw+hmpq6DZciZ+Pu+T8O8c+uE5I0q6cEZ2qXS3VhrbFVwmOpP3WwY6qSDEaaHhi0YGyM1MAbW8YFBQkPJhgG5QYoq2p/6zVB2zGOCNGw0DVVhFIe2pzpvAaOBKuH2UubP7Vxqoe5d+qPSaykzVQFD+uF10ce8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hqD8sz/O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gfwIw0pi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hqD8sz/O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gfwIw0pi"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPmch016512
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 12:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Y+mrUpHrs5vfvIGvPD/26tzNP96x8VU+sQRx/PRjuHU=; b=hqD8sz/Ojiyj1gV8
	d3xmgBWazuxrDHmApibms2ZetxHFAvEp62am1mzQh+EckUo9xuCU37DPp3JnvW7t
	ah5B390GAqV1I4GEH5SUVq7GWx8c0n+x3jRB97x8M0VfZRrovwlcX5eeBK3u51t7
	80ISigJHwpsZx3Wubh+77olBBJIRQUDDJ2UNYXqDSLHp1nAqT+Q24a1DXHh8aCd8
	//hBAjeo+ZWWmNu7KLXjZHIL+N8qMQ1FWRAAHKZSasNmFwt81hIokvwXujL5sTmQ
	NhUq1GWKT160qK5xdSYWI2VHPAujoj8WiH0zZd+7A7jsg5QBTf52FaDeJghT+XTV
	aouG9g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gunjys735-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 12:43:44 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d959904658so72629765ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 05:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081024; x=1790685824; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y+mrUpHrs5vfvIGvPD/26tzNP96x8VU+sQRx/PRjuHU=;
        b=gfwIw0pitsepI47d2XUFzMHQjtxcNqB27g69cGue6wuxJyTs++hDeXhE0mjxM+PhR/
         92evOm31/SqysVcyil/Kfcrd7OQN5XEOXzijq502QNomXWZPMerP51+GFx9ZGhbisCTN
         HVUInCJSPJu6/wo4P4q4QoStY8pdGUisNcOkh43UeggI23ush3f/jg9rXlJ/7jBNTZMZ
         mZgTu4pNHegDSlTUs9ImpSkIV5o5icZNgJMqNolH9R7l4kjQEgesGnvSA0j49XCd74IZ
         EC999Bww5ZRAiPkQraLTpt08VTpQMVy7zz2SPiph1+E75wHc52zEPJhnn/yoCOyMRBYO
         UPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081024; x=1790685824;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y+mrUpHrs5vfvIGvPD/26tzNP96x8VU+sQRx/PRjuHU=;
        b=Y8UoXjlRtEpHEax46084oRK64RHAcOJDJjDcCy9nrDGy9MkVfVOAXug0z9PMFc/l4X
         ZcT1be4S6qAxaaCmA7iXx70lbRPcP+VtCMZ2e/LxxoyLpz0aQ9OoGEmyjlhfMbtVinTF
         rFQgyBH71YkiGCJ/xn2PgedtK5ZpOAmURY68IGsvzqnoQWx/4imAWKlQ6beBjS0KG+bw
         7zEHwzw7958gzGL2JQ0ExyWjLcNVHjfUjd3P9Q95cXWIm4xBwT3r2nbX9RaEKTFH/qGd
         J3HEO1Iz+JcXl4Nxsc2bWGVbmWOrtJKhpz3q45GSFD1pP/m453ryvIokDzaCIfzSmahI
         3y2w==
X-Gm-Message-State: AFuF++k5jxuTW0cvtr8kg47PlBI2IfmEGByZWbdBlXde8U68rqUZNBXp
	sO5I49USLl7Z0XO87VVaxAoBML3Ic2OaIGgVp7QneYrOtoP303Iq/TQvwTPpm/6ABD//KSdIp2Y
	kRz4DrmYhpA8StKLpFz9NjZ26xulya2TwKkRAKM9JDGDLukGAOwLuoKcR03kyybf50hxdKw==
X-Gm-Gg: AYBFou3fVQlI3rBhx1kqVsu1YP59AzZm4cuGhjjZrcU5Np1YNcEDTSyMQRO3E5aBM01
	ZyVLREB86qAD1WaVl9fCJFx8MwkKA7kJmCYjKTpVPq6FAiRDjo3+1so+3Lk17xKm87DdgCQ8vLl
	swAdexD8UrQbgW32LdBBQxidRoQek+YhQUe5/0vBPJq7Sx+FJ9O5o6CDFkXXAmBT4O1XvW0d8nz
	1B/Y7Un6a5c0UuXmyP0XyrAEIfZ8OeR+4TozRBJuRWJVjSsH3AKDZ9P1oYcucmvxncts++zj/Zb
	iMiVTah1/tAEp1fjPrtciNk9egfswit79oSv9cepXRdahecrweLRCdS23Olj720H5Pyqy4l3x+x
	GXFQR07y37Uc4YkvL6xlYGb8fxjsgCoqMI15KLDJaNYk=
X-Received: by 2002:a17:903:350f:b0:2df:5b0a:33ea with SMTP id d9443c01a7336-2df60b46fbemr12054185ad.35.1790081023536;
        Tue, 22 Sep 2026 05:43:43 -0700 (PDT)
X-Received: by 2002:a17:903:350f:b0:2df:5b0a:33ea with SMTP id d9443c01a7336-2df60b46fbemr12053875ad.35.1790081023027;
        Tue, 22 Sep 2026 05:43:43 -0700 (PDT)
Received: from [192.168.11.104] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e6129ae9bsm4950086eec.11.2026.09.22.05.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 05:43:42 -0700 (PDT)
Message-ID: <bbceaa85-f8b6-4e34-9a1b-dce1e7525bd0@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 18:13:37 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/7] wifi: ath12k: convert DP profile parameter
 macros to inline helpers
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: QFoyiyb3nedg1FpwTsQUIIF6bWy5JShY
X-Authority-Analysis: v=2.4 cv=KqHYSmWN c=1 sm=1 tr=0 ts=6ab27800 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=Y3uJ5WifsOlXRAKWd9sA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NCBTYWx0ZWRfX5iP4o33/thHx
 44PJqom/nQlas5kXQJDIoPl1ZLHl/WS4aq6J7kPQRrYUBmEzT78OJkMr6GL/J/7CmBOHyZHjEfL
 BnVHkol4IMIIxEnMI8WvsWwsrrGeCtYfQXD8NgJkkZdqz6RmowyX6b+cPAcy6i1u/SsiuXKHL+B
 k/uEuNJz51PBm70mlrRJpVzJI2o71e04jTl3v6cuYzB3xNjOz2DR9HK537C3JXxBFASmxVCzGja
 vSDhHdxETzn1PB4iYOXmsHhlHOMBct5ibROeLqpBxAB7X6o0sEUKI4+LaXH4UfrVhwNUgubi9Jk
 Mo1fqEpHgorXvkxV4bGvVKHGwpPj7shc/DDsFGdJaM1hP/mR79iUdo4EgSn19opFw1QlKpxmlyP
 mvErpK1tSuQjvwUQFYlBGtpu5UNd0GwStyjRl7S+LrCNxb4JgCg4mn7KM6RJ1Unx0okIpkz0t6d
 dHq4wUF2tER/ckoiqSw==
X-Proofpoint-ORIG-GUID: QFoyiyb3nedg1FpwTsQUIIF6bWy5JShY
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NCBTYWx0ZWRfX8qe50Y7Xx8/X
 /ryku6BJGKq9b8llkIj9EqE+aK2nuxfGhQdn2DbF01pQ3t9PQnvkAte3Hp/ZmaKSYwXwr3GR4QV
 GWFTRPW+1uhK3oJlvw+l58VVPZVgZiY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220184

On 8/20/2026 11:17 AM, Aaradhana Sahu wrote:
> Convert the Data Path (DP) profile parameter macros to static inline helper
> function without changing any functional behavior.
> 
> Aaradhana Sahu (7):
>    wifi: ath12k: move dp_profile_params to dp.h
>    wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
>    wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
>    wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
>    wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
>    wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
>    wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
> 
>   drivers/net/wireless/ath/ath12k/core.h        |   9 --
>   drivers/net/wireless/ath/ath12k/dp.c          |  81 ++++++++------
>   drivers/net/wireless/ath/ath12k/dp.h          | 100 ++++++++++++------
>   drivers/net/wireless/ath/ath12k/dp_rx.c       |  12 ++-
>   drivers/net/wireless/ath/ath12k/mac.c         |   5 +-
>   drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c |  12 ++-
>   6 files changed, 140 insertions(+), 79 deletions(-)
> 
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
