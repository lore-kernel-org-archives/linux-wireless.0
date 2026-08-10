Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397DA32D0EE
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786337763; cv=none; b=irqz8PtfrKXmNLUxWcBcgDgAL2ahMSlQBAOp537xjrRsya7GWp80iEbevC9FcA4wLnFE6EZIeozTDRNSUW1CC3Z87wRGRheenzXbm4oHdBp8SKjz7LyrOTnmoRjz5F4DGNlpSq0g/Red3IJyNgnPLplk4X0QaimbjksyjbbBw6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786337763; c=relaxed/simple;
	bh=BqQB/4LLSggual9waKmZjByLYIJs78CgJFNjdtgnP54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sr1TukivNBRh53SAgv8Sw9yAbWQBLTLQWWcpYCRpSmA/YmDIDvyuxQJFPxub0G+lQiQ2JiZ8LNOLPzRE6GEBcJUsSE+CIWiQWC2EAGdVyu3Ti5zw1st9l94Gd0IQdafgtVSHX9bIz4Qb76sc0N5jycZ15QzeliHfIQFeDDUVelg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YHHttd8L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hp4rY6h3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YHHttd8L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hp4rY6h3"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679LuaGD3597620
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5WsshM48rhq3oko+rk+xALFZQt/sxdV74HMC+99dUD8=; b=YHHttd8LmLJ1bJ7s
	pGl1xh+yN9FcaJvXR5lxJUxO7NMDRPzZEsi5fG3zOCDFMyIB7CtkSYAmvdMjQlYs
	KFww2vtIW8hLSQbIAg4wKTEtDq/vdI9Mi8pVWxuHeLmVBY0LHUivWVJCW6iieBMO
	yFBjHC6bHFbKZuV5Zi1K04gBgYECjBxKTAQBtNWxuYnMmx775nsmkedhBtY22zWl
	kSCOtPJz+Pl57hJzTgMhKn9yKoP8TzeWfu/GD75FzBRdUbBxZ8+TohuH9xo1nn4I
	BA+rKDkSlfwiieUBBqM4ApAHfuUGuDMAhuYoHhSsaGFmdMHC7iDOHggmikiIHfyL
	Jc6VHg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fwvu8mcc8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 04:56:00 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84eccf9d899so2308812b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 21:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786337760; x=1786942560; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5WsshM48rhq3oko+rk+xALFZQt/sxdV74HMC+99dUD8=;
        b=Hp4rY6h34tvCNwqzNje8KMhBAYVkvCrTIh5Zk+8UJlF3qvaaQEW7MCBjXrnUUWe86a
         ROVhpwr5pSdE6XM//PV0lHuEPaZ3ZjWvHxUACWs7ny7m4XVEVwkOcXYx5oda2MtNL0oC
         Iyj8O8wlBvAf8hFLluuFNnHQuUxwqfzXTxiqbziF5BzQ2Pamp2aUGTkH8WYiewWFFGSX
         0PKd0JhEXMI6UL0wZQqwKLC4oB6AShOlWLcLSRmfB0Gvto05ijX2w72CNGDMAmuyUZrv
         O931eY+lvMIBwpcfLWNWCJhIEUMTbalCE3LWZ/r9ANl3y8lBbPUNtfeJ3ZqWbTWK+N7q
         L8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786337760; x=1786942560;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5WsshM48rhq3oko+rk+xALFZQt/sxdV74HMC+99dUD8=;
        b=mv+6G2WqTODm0ervHCRACOBEe4VhdPsZcHgxMBap/FE+LVazhRdrlr4EHsSWGpm2jI
         YKVrJS5OGtvSAKbRzxcHhnGwaioYODl3RSVJfdy5sDMnKOJksP5GvE8hxwgResVIPQh5
         NY+6EnvQi2Y96DFdjwApeZmOdbqcCudVEqjoerp2DfhyaRuC065H9a0U49DFPiQANRXY
         +Z4Ca7xrcZZSbV3L8OJZ7v0oIPaMHvJjn0c1ary3qF515WfCB6A2gdXAXvZQq3RRjcrj
         MU4Wp0BA0v4cOU1jXn//syi755+nJtK09ZFn0ar43PuU6pByELoJONnVSNwPRpvSAfpq
         J7JA==
X-Gm-Message-State: AOJu0Yx3vtQGt0gMIiY+zSA3RHXHZE99NfGU3zSEzSf1SFZew7O17z8b
	ulAso64i5BPv6BqhgfyDKCbeEgyW7JAbGmHvYe2j1UXxzTTbC5AyA/BalAcgmN+/Y7G+7iyBjtk
	Aym15GukomEfzL3l+Ef/6wcqY0O2E0AJrc/UcWfIw6CN9Ohr9xwUJJlpwepuPR0mrDff5/P+usr
	hzPg==
X-Gm-Gg: AR+sD100ZCY+CbHKlmUc0uvauViUg7F3Vp9wyBfs1HMAFOnLP0vM2AxI0CdFhJkytH1
	+eVGW9LT9iRzROkhxxrudiW3lHIbEHHxRP/H5igZ2yTAhN+gSc0fCYrVsk2cEwuk/dRWNzDbbbO
	p1trCn2G0jR4TEwKD1kMOG6wl243o0PgQfrRFpSmg+e4Nnfo3PjbuE+GcsKU0GuUKWLFmqC5kRU
	mpCNI1Fe6vJTJF2AomzCRkKo2LG42Hr+ZTohYICClXW9+16SRpg9ZXs/wc7l6njP0xonuVwp1gX
	DikYDWcsTzCeLDu5woYa52mvQgcSXHUN3VpOnW+BWj/nN9A67J8mWejlHrLDj19TpMri7fGi4wf
	0cpQ+fR3yJu5N9OgwJCj5SDPxuE3a8MnfGpKKrl2N3skJv4uVDCYSjj7G55U1qBG3GGmE7rNjTL
	TtIQKT9RPyDzJ+LpM0QQ==
X-Received: by 2002:a05:6a00:2887:b0:847:8449:2ba6 with SMTP id d2e1a72fcca58-84f2dfcfd34mr47829874b3a.8.1786337759774;
        Sun, 09 Aug 2026 21:55:59 -0700 (PDT)
X-Received: by 2002:a05:6a00:2887:b0:847:8449:2ba6 with SMTP id d2e1a72fcca58-84f2dfcfd34mr47829849b3a.8.1786337759261;
        Sun, 09 Aug 2026 21:55:59 -0700 (PDT)
Received: from [10.79.124.186] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a3d1155sm3203620b3a.20.2026.08.09.21.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 21:55:58 -0700 (PDT)
Message-ID: <41001b17-36b8-4c5c-9a8a-959ecf7b28ce@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 10:25:56 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 7/8] wifi: ath12k: fix 1-based ring index in
 REO Rx Received debugfs output
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
 <20260806132427.3704828-8-pardeep.kaur@oss.qualcomm.com>
 <746f106d-f435-47ca-a33b-32e4b97843f7@oss.qualcomm.com>
Content-Language: en-US
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
In-Reply-To: <746f106d-f435-47ca-a33b-32e4b97843f7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: YVAnEZJt7KJBCdHXsLpKKbV7mMKRBpvQ
X-Authority-Analysis: v=2.4 cv=M8p97Sws c=1 sm=1 tr=0 ts=6a7959e0 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=ZXtejqto8Ws31T1WmfgA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: YVAnEZJt7KJBCdHXsLpKKbV7mMKRBpvQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDAzOCBTYWx0ZWRfX6dEaO5UqRQgJ
 itCGTcSQs7N9t5ZqiZQy2Uj+LsPRXjHp5Um7wcwisCWBpD/pu0taR+lNLf7sUkSezDxIy6x3E/U
 iZsbSe5SUUVKTd7XZW91U20gtpJlBoyqiOhNFhVg/qYL/RP2fXg+YUyLW9IkvqDHydjNwPdU7zM
 oDRxMluzc1XbE3qOqP5ula5UNFUvZQdOajPFEu3yZlSQqhf+gkbnHyTJATGUmxrbHPc6+9Jp8uZ
 umlvUsJnemo3dzVTruMqb0+GqPzzyuh+XfYbua25AQ2u8pS16MBMH9qlDTHPe2QDe7pG1szStgk
 By0yHBMcYOaXfrCBh0tu0IU2rFj7iqBEhWHL3EpCXx28nTaIIv60dUpCUTufxtAk+RyoaAcSx5Q
 v277ho2j+vfR2QYvTP0P0Uk0oT0jNkYGkz/aPFE9dQ8oPqMKuid9MBuaOpSM/Kk1C1m7MMZnrhr
 9wrdJxCPJmLLuMy2xUA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDAzOCBTYWx0ZWRfX9i7Etu1qfcQo
 9m0MV72Y+v/I6mepyUbmT2i1gthVJ6VEAaQFaK8S09VKFsDjBe/nDqV4ZbU3JWKYa4fddoSsDL7
 sacMiC7DAd2NCtPkbOORrX/8LfWBIS4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_07,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100038


On 08-08-2026 20:56, Jeff Johnson wrote:
> On 8/6/2026 6:24 AM, Pardeep Kaur wrote:
>> From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>>
>> The REO Rx Received section in device_dp_stats debugfs uses a 1-based
>> ring index ("Ring1:", "Ring2:", ...) which is inconsistent with the rest
>> of ath12k where rings are indexed from 0. Fix it to use 0-based indexing
>> and lowercase "ring%d:" to match the style used by all other ring counters
>> in the same function.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1
>>
>> Fixes: 84873d542e95 ("wifi: ath12k: print device dp stats in debugfs")
> drop the Fixes tag -- this is not something that needs backporting

will update this

>
>> Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath12k/debugfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
>> index 216a1af22898..d4ea21aac21e 100644
>> --- a/drivers/net/wireless/ath/ath12k/debugfs.c
>> +++ b/drivers/net/wireless/ath/ath12k/debugfs.c
>> @@ -1215,7 +1215,7 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
>>   	len += scnprintf(buf + len, size - len, "\nREO Rx Received:\n");
>>   
>>   	for (i = 0; i < DP_REO_DST_RING_MAX; i++) {
>> -		len += scnprintf(buf + len, size - len, "Ring%d:", i + 1);
>> +		len += scnprintf(buf + len, size - len, "ring%d:", i);
>>   
>>   		for (j = 0; j < ab->ag->num_devices; j++) {
>>   			len += scnprintf(buf + len, size - len,
