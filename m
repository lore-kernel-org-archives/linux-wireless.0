Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719580;
	b=U/J8q7lT2ssDGLnE+nTpGz3B7mqx1LI+/PeUU3VC4QMyh4TEGbzmj0s2gd0lvC/xsIea
	 XrgE+J09FF1Pv5PPxqXIEFPkmN/tZbpwjBJvYkzd4Wwy6Vpti/aDLcpE8aoA5CXF9mrjE
	 UYyE4or29OI8YoFoZgLRMs/fruGC2laC7LtDAkCKNnbGWKg/9EnGVO++CR48ebh5c6Fgq
	 UzyH0iowMlR7mWzP9kt9xEDGX2yaqvMVBgdKltGI+pqDLqR8AobjryFkoXgLrjFWkcvFh
	 jLqg2zVAQvYGWyfq6VX+tFZWjvNWn6CyoYhUH9OweBD4j8wInbh8Y6rEZ7MHXQ9G9pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719580;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=HHaDUp2MGnelhZyHzPnyFdDqOtUzyTDwNm6fx39HN6U=;
	b=Un0+JBL/YkPTUOD2T27Cum7K+41VyFgPq2bJVDYQ3ZOpUmE4BceArJTqN4j6+ye00PkF
	 ajahwmq49x1TDxDrW3skN14+e4bWd7H78xeVdJQdX6EY2UXr+sms+8/+utRZBzrMx0/xl
	 1Am5Ioz5B3DHfxvpXnjl+6b5atxa68mA/dDTS4lmmfPasz6c28lWmlPRULghfCMDfD5CU
	 vOhCl4O23oThy94/4sHb6mhRSC2UABEj7x4pJPUOP5JJyw0Km6sEuAbpu8u8HU0RbG1RH
	 TwpSZ970jf1RPWV3IMnWztcycLpr5AZCvVtZxGh8ukHJAoeZuoApnDzi09TDsWwq6mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="FIY+/nW0";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="UU43Cs/h";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D3606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 885D3606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FIY+/nW0;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UU43Cs/h
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3EADQh3689953
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 15:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HHaDUp2MGnelhZyHzPnyFdDqOtUzyTDwNm6fx39HN6U=; b=FIY+/nW0lCcuvrzA
	m03A73JpY1YmWuRLtp+tN92WoSzcbXWPSDb07it3Xz7VJmrxTCrowQQe/uD1N6kC
	Q6FCQpueEmpTcxSoyPJezDoJweGSenYlY7uVdf29SXi1lVJC71F+MgzfLZZH0rnA
	qt1n4knR9KJqvChyuoeolQylL0jlJPvW8JNKdw2nFpS9q/A1jSTfO25vyC3ux7bV
	1HcTYH3PGkBXCEDcWe/2hTvN+KHRKmb/6zV3QHXgWEak5apjh2Iobbmx/oSTjmVJ
	s12G8eTwemp4vFH9o5H7d4Nv0bOEwYAcZ1AYnlmtMgDRU5+2rDR+mMfOVm6nXnis
	hEIPAg==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq6m9axkn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 15:26:18 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1aa0fb7f157so6585701c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 07:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793719577; x=1794324377; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HHaDUp2MGnelhZyHzPnyFdDqOtUzyTDwNm6fx39HN6U=;
        b=UU43Cs/haI5XrByLV9sJB655W6zBu0A9goER7t+LOckAtLE4clrrraCtu+RWDQXL4j
         tBiqtdJlmvow3G+0AI/FFI6bezOT0Bj41pSvwCrJTwaOogOV4ysSj/60k1oAnGCMxpBM
         7Rc3WIbtpKgAhw/Hrkl+5ZnKZg43/ApATNuyvTtY4pRNozZnu+Ceth9XueCLV2mMRuOL
         zH3VvyHLVynGzADjUzRZWBzphiNQOsqBeVbH+57NysKSZzgN1LEOlALRuzXnBpkVg1Fb
         +6hyDb3QlsoMdgSS/trG9EhUNy8y402rBP90Acz5i83A0/utgT3LR4UXkwZ0NEBokWob
         7kGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719577; x=1794324377;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HHaDUp2MGnelhZyHzPnyFdDqOtUzyTDwNm6fx39HN6U=;
        b=u/J3gTH2J5bW8UAvx6AiyCGkec9v5KeEHEg9+Q3xE6hE0Yr8WbmUkwicpTLVdW/HUs
         DFvpHSTbXWBrDIkxOwR25UVkg1gUcQtZYOOquh29uEyOlDlnzmCQcoiUIo1sI+M5gFBK
         KQtC6Eh2bDarWw+0zcyDEsPgmEWdDBHWSTaC9jzeX5Hvc3x6K5uYv7L0CSs1/+n56lOJ
         eEU5sUYL7RaVaD1sWQ5BOYAZtmaIKizanLc6ANInTAV+2qcly2phwjxPA39ZL4xLnn7R
         vUk9ZErzUH/HZSl033VV0XqFn73Zrqw1NmL5aU70KpN2Do4ps6XoEpv3/HN9cCOqQ+gD
         X7Jg==
X-Gm-Message-State: APuU4Z++7+NrTEbyI8SJdeLEeSaF8EzxSH4JPe8OSF6YbRZhJ/Lf1J8m
	037s7ODUIEw48JBKQz00Njam+7MJOvr3NSE4GHkjrstmV7leB+zuGykPrzHYd9CcyzK0Q5kJVP8
	kV3j4EJ+A5VXUOx/0yl0w1sLEz95TjQ08jY+JFsQa2qkO213shtiFjvdxoXQqxD76nkyGNA==
X-Gm-Gg: AYBFou16pWITPRm4w+/wxIPVdn/oFr62hQd+wwnNzYdDNnNWbFm6lgCwV8gFK6T8W7n
	YNTSBf2ndS+NTrRW6tm1gwPdpdeD+lQXdHd/JUwNq55t7CXJddZr97+VpT+coln6FpMFkYPyhB9
	f6lh0l9IDrtKaCp8Me0eREPJ2TONjLnK/sFI40fPBi4b0I3s8dvs/PIYq4b/XXkP/K4NmLZVQXn
	RV5P8ay/FPDODMsm95xh4MIF24mfocsspdngre0TveLRHykKoEkEgawHhk3mbUC9ZFZpEypKDPz
	tEHKUmLRPfBPmjnWQzFltI7ctyaO82dweV/09x8gzunbiPm+eCARK8vQgg8MYzndmKg5iljrryG
	REYPrmvpKqFoEoBvI61sCpxZl+7E+q1STg8L83Hdzaj+uH/k6JUaaXBYp+51baVNQL6SsGCHXeZ
	zKw4Y7omFUFCVxb2FyLli4R2joizqc46w=
X-Received: by 2002:a05:701b:4283:10b0:191:a5b2:ef4a with SMTP id a92af1059eb24-1ac5cb186d7mr20218906c88.28.1793719577086;
        Tue, 03 Nov 2026 07:26:17 -0800 (PST)
X-Received: by 2002:a05:701b:4283:10b0:191:a5b2:ef4a with SMTP id a92af1059eb24-1ac5cb186d7mr20218862c88.28.1793719576388;
        Tue, 03 Nov 2026 07:26:16 -0800 (PST)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1a9e2ed3sm42151011c88.19.2026.11.03.07.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 07:26:13 -0800 (PST)
Message-ID: <a715e044-848f-4adf-b497-de745169e6d2@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 07:26:11 -0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4 00/11] wifi: ath12k: resolve RX link id via
 logical link id on WCN7850/QCC2072
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
 <f154f553-6739-48c6-bddf-21f429b34bae@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <f154f553-6739-48c6-bddf-21f429b34bae@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 3UErkHKDXhZnoyid3IUSZ7kH0iu2v7hS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA2MSBTYWx0ZWRfX8zn3vFAkSkwe
 NfmECH7N2KfPtDR029oFHEMxi3C2VoID1tGI0ae2VjH3xodGATp9JMbdju/b9XkG/3Z9Fzmj8Cf
 9nI3bhCkREwjRKCqtgqHO1I+DldLFMo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA2MSBTYWx0ZWRfX6O1R8Ob6iNe1
 guP25silhfcQmcLr193L2+kNU+ymmLZnhJZ3d/4T+l5wFKOwxLynd0dPzwXAxMnrv8aUEZiXX3a
 q6kptleEkHn5TRgnTA9SVNjnN2BMNx+QxPXEbw22s/epL+UgWsYxHb21KYsRp0FWyks4OM8muJw
 IfdZjj9W02Q/0afBZJPjFn9BMLsd+rncvUuVxbWi1Fhcfo2ODjIwkT1Lfaef/+TA6nYDr4hLJqj
 k1pi4sFH0u8Nl+D4AeKMHngwbL6QNJDXzekLH6frGIloDvrzXVPLgSFjQ03ctPjoDODfi1lYMvt
 aM4L0UASZxb9fr7Hkhzf0YvHk3ak3WIu9kKUvhWwE5x7Jj0hr9uNMbK1oFWzMC3imFepCO/b+zx
 7crHiu+A0NLjdpaFFeHTnQ/LBfeJB8k9K0DKNv354XkeeFkoUnyqoQcfbZ7FzBbuwZQWNIMo3AI
 j/NdKXwmqnKHKpVYpPA==
X-Authority-Analysis: v=2.4 cv=C7B8WgP+ c=1 sm=1 tr=0 ts=6ae9fd1a cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=2Kb41bJ7ohxLfoScjiAA:9 a=QEXdDO2ut3YA:10 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-ORIG-GUID: 3UErkHKDXhZnoyid3IUSZ7kH0iu2v7hS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_03,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030061

On 11/2/2026 9:20 PM, Baochen Qiang wrote:
> 
> Hmm, forget to reset revision number ...
> 
> Jeff, let me know if I need to resend it with number fixed.

No, this is fine. Waiting for a R-B from the infrastructure team.

/jeff
