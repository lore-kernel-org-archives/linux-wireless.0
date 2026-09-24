Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0B63FE66F
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243135; cv=none; b=CNk5nnvBzfSqEMOrBQsSeUTRC3orVKOSSvdpT4vjxvjxh39gryPvHxQKnrn9l/fVoAQgefboINE6LQtAMl2Q991yhyJlV8XS8zSLVxPU7mFiNcmiRZInGgHWs8BAzQwgb/LHHYWg3FAow8WvpU/aGHzVrCISaF6aIe+3KpGZvdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243135; c=relaxed/simple;
	bh=rDVOcETI5NlA4rmCoITPV14AW21wXA+uGKHBF+eoTJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGBL/4SDpbO3Do7wkXTRNbG+Fc2NXx/vZRwTyoveKCUinMAZh1G9DuY4QRu/Y17QhYEVB3KGFxm/EFuEnijZOJGU+EbtUqwmnvqlnkROUtuNp/glZ8Tlr/aPVMopD1Npk4hh44aiSh7YciEELTE1kzGhCB0TsQZzrIAZqA57xwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H1HapTO6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M6RQd9xw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H1HapTO6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M6RQd9xw"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O9PC1p2025616
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 09:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EipT5pYVDVhEVttGRYx0g0vRneeQ4JYuUYGj5ngSQD4=; b=H1HapTO68ShtonSW
	G5Wwwqy2WvcWyEZCkYyX0wIncTc/uyybk/SbEic0cQBcy10oStnSKQ0I7IZ4PlVp
	vWV5hG8mgga+mYkGwygwFyDxyVrrQ5NALy9vbzXWt9jzI6rHR1TobNV+t90EmKV2
	wWCWqZUzDZmR9dgsniT1XJHWEy3kmMgBrQuGSH3ZkH0W9yFBqoH7PD9iJMu9UulB
	bQZaYZkIDlNsk4oB0oXHeYoT7w7UTTBRQ257IZtjHNvKU7vTmCrWfUZ4lrBxU2iS
	drhSPKJPLjBZE/Qg3kBtXCwO2fViYRih3rFh1sJwMUNqBFHhD1zA+ECzw4P3bnlx
	EXa74w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvsfgsshh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 09:45:22 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33baaba6371so2031080eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 02:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790243121; x=1790847921; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EipT5pYVDVhEVttGRYx0g0vRneeQ4JYuUYGj5ngSQD4=;
        b=M6RQd9xwaL01BkUiHPhRE47Z0OTZfIof1b88y81IP4ro8tpzt2G1lzPIxw1GDzj8Xc
         Fyh6IN3EJYjWJgFQIeBweAs8vuQYIcGlwAZX2LsaEhUixWYbcNxOvGgqu6ajjbKl7kRi
         u34MIHplUvMbzxnl3uqtL7NeQd+sQwhZzqzxSuX+RRm9kFpzeaxeFltrZZdopltf0/8v
         ENyXtdxFRtQDb5+oj1PeYL4dVJHr7XWxTcee2CLZh0RWu3Qr116D/QZMb54ViSTrr6NB
         JyL7judoBF8d7g5JK0g1x8NRWMvgqhv5ckCNd1Z1x5ZoxWjxPueRp9fsbqNwwy+MTBVO
         iCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790243121; x=1790847921;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EipT5pYVDVhEVttGRYx0g0vRneeQ4JYuUYGj5ngSQD4=;
        b=woRwsl0k10JAQrXe5HdEk1qYvL1wp5PFKbm2DdZ+amwbolE+qRF2eYH28VDRcEjQmu
         QkJo8h+X3wQW0/7U7PsXWY1QOzx8d2xC/844zv08GMB3lHf9ystaQMjRzJ8aSwgWSMXe
         AeNJGpSRjw2KLqcrF7N0VDy05uVfEl6l5fwr/VtF/NBmJ1dYBQGg29bgNNU7E92SI8vR
         a1Qpv8mKLPYWljfWGiDPTZ7DHyF2SZMOBqIotjIFyq0kYhu1eRvrfZBEBcep1uBYiG9r
         adTrzbPFzAOqR1EGMhTorsLL37MkxNIpdThdys1zJ9Ywry9xCLDF72QGSsiedP9SGDO0
         fyww==
X-Gm-Message-State: AFuF++k5N46q+q2g+py48omq385HH7imOxuBW8jKdIgTSYd9g33dnvlU
	L0NdhEGPNSlbhTptPfZug1kiNqE8HQz9aYQYP2QMpwkqMhF9aw4YAZal7AbNqOjPmLfVM/ANO29
	vOwPtmTXsol7cIj/6HXxZXXz2HxIoQlG7LBfUMpIE/k6WPiLVEmx+D9Kcr271I9uHfPZkcmYjbG
	hg3A==
X-Gm-Gg: AYBFou2aGoY1d+zoaoLZd3Ld5sGeA3nsfm+1bUBb+o1skqw160YIOasD8W1cKnK3gAA
	+IypQ4JRboMmnfxu2p2kct89xkcwaW/sV6MIKDbt3sTD9eiRjTtO3slfbyEqpB8DMMcGnFYYBIX
	h7Ivt1POWUaTwsZph89GkXapFD0J2g7H5B7CAeywBHkRMNgDvuQHRbtMeEUJ4w0VPtELuUXovwP
	dQn2JObm8wMq66h7ucB1IALP+h5Ce8rWMHmRighUTZICpQTIgYjlRBCeSuMfFV5NduZwt1FSG6K
	fTmCp2jLbvKeaw+T2I7WeQHuM2Xrdd2ctOa8DsWxS1Jlc3K/rog2q5jNSm1GCMGDuCrih4mcCTu
	BM3OWgcU8Km32JqfDJaOzM/fAm1dP
X-Received: by 2002:a05:7023:88b:b0:144:c11c:370f with SMTP id a92af1059eb24-1450402ce4cmr1656026c88.30.1790243120998;
        Thu, 24 Sep 2026 02:45:20 -0700 (PDT)
X-Received: by 2002:a05:7023:88b:b0:144:c11c:370f with SMTP id a92af1059eb24-1450402ce4cmr1655993c88.30.1790243120335;
        Thu, 24 Sep 2026 02:45:20 -0700 (PDT)
Received: from [10.152.194.17] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f982089fsm12439685c88.5.2026.09.24.02.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 02:45:19 -0700 (PDT)
Message-ID: <5e7ca8e6-bcb3-4fcc-b4b6-1f7bf2a69411@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 15:15:17 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: remove duplicated STA state
 from link peers
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
 <8340ba71-cc37-4dbe-a82a-b88d27c0703c@oss.qualcomm.com>
Content-Language: en-US
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
In-Reply-To: <8340ba71-cc37-4dbe-a82a-b88d27c0703c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=YfoodARf c=1 sm=1 tr=0 ts=6ab4f132 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=z2ZSEd9kmZY8weE0PYEA:9 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: PvBJTOdRlnFvZNDa7mIFVngCIoQFNGbL
X-Proofpoint-GUID: PvBJTOdRlnFvZNDa7mIFVngCIoQFNGbL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0MCBTYWx0ZWRfX9ETWp3o4Kxy7
 1laZ02m/iDWVZxnjHKCfTXQECQQCgLh0wIRVS2hCHc3gc18XO+ERtQLJPP3DnbNJa4tWYpmmOKx
 gzdqgLQsTcUmDWFbUmFRc+R9yIR8XNs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0MCBTYWx0ZWRfXxzBZXx1IN23d
 NJvQpmCmegneYC7RLqg10I9xSHx6J/+wrXryBeST2dB9QoFWsN9/KfR7jvF5Dvnqdsq/tcYINJC
 lNIF+NJekqkvtf1iuF37rqZ+43dE7fqKWAphWc1ORNTf2h+vL+a9Ok8/1pwh26N3shB1BTApEfO
 xmnZLd2BfC62EI+V1jcRdRZxp06aTqHa2jbjhgcCONlI3opjgKRzBd7oSpAvx3l/d4c6upwytQ1
 KIhpwVBtqFvXOyj/bfN93zQslnk6jyHGdxQIDat4mmIj3aVSmTAeXIct5D+11dNZo0oIm0yTAvl
 E3Z7hdYvMtHzA73zbW/+il1qHbBO1vPyuRIVgGjUUBSV/8HJEcXwr/S9jvb/OweBHOAo+6gRjBS
 Mq+g8dbMeTcXgnsUbwatOwYasjjluC1PFqGoRSlbPLnNr5JJOSNYBnh4tHpLP2ga3+ahWBhM/FH
 A21CjL+QFIBLD7e/XSw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240040



On 9/24/2026 2:15 AM, Jeff Johnson wrote:
> On 9/1/2026 1:56 AM, Aishwarya R wrote:
>> ath12k_dp_link_peer currently carries state that is not inherently
>> link-specific. Both the station pointer and authorization state are
>> shared across the links belonging to the same logical peer or station,
>> yet are stored separately in each link peer.
>>
>> This series moves ownership of these fields to structures matching their
>> actual scope:
>>
>>    * Store the station pointer only in ath12k_dp_peer.
>>    * Store authorization state only in ath12k_sta.
>>
>> Doing so eliminates duplicated state, reduces bookkeeping required when
>> the state changes, and makes the ownership model clearer.
>>
>> Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
>> updates users to retrieve it through ath12k_dp_peer.
>>
>> Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
>> updates authorization handling accordingly.
>>
>> Aishwarya R (2):
>>    wifi: ath12k: store station pointer only in dp_peer
>>    wifi: ath12k: move is_authorized flag to ath12k_sta
>>
>>   drivers/net/wireless/ath/ath12k/core.h        |  2 +
>>   drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
>>   drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
>>   drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
>>   drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
>>   drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
>>   drivers/net/wireless/ath/ath12k/peer.c        |  2 -
>>   .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
>>   drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
>>   drivers/net/wireless/ath/ath12k/wmi.c         |  2 +-
>>   10 files changed, 36 insertions(+), 84 deletions(-)
>>
>> base-commit: e07447e654476262558bee570f4cf456e2b32565
> 
> This series no longer applies, can you please rebase?
> If the conflict resolution is trivial make sure to carry forward the
> Reviewed-by tags.
> 
> Applying: wifi: ath12k: store station pointer only in dp_peer
> Using index info to reconstruct a base tree...
> M       drivers/net/wireless/ath/ath12k/dp_rx.c
> M       drivers/net/wireless/ath/ath12k/mac.c
> M       drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> M       drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> M       drivers/net/wireless/ath/ath12k/wmi.c
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/ath/ath12k/wmi.c
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath12k/wmi.c
> Auto-merging drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
> Auto-merging drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
> Auto-merging drivers/net/wireless/ath/ath12k/mac.c
> Auto-merging drivers/net/wireless/ath/ath12k/dp_rx.c
> Recorded preimage for 'drivers/net/wireless/ath/ath12k/wmi.c'
> error: Failed to merge in the changes.
> Patch failed at 0001 wifi: ath12k: store station pointer only in dp_peer
> 
> 
> 

sure will rebase the changes and update v2

