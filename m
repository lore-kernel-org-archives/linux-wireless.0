Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776247;
	b=RSY1fVMnA4ldGDegAa9wkluAHbk+mqwPCcGx4dr9FtDV3E/hdD0Mn2zle73ReMpbFpJd
	 oZ8aWlF9APiwJi3Duq+CCvd1EE4+vWYBgFzF17Wf3gUbcNKu9QKvjipzFIADcggU26Xqm
	 tDNoSCDiLbt1XzD1FSaMLztS1FR1w8koQiu4gJRGrzo9AuTl5N0IqKV+88oZnAu70qLhx
	 kkpzq9qnlOYrFmu9uH0tzx1K7/xgmJ9bSVic7vTC4X4Z4RMptziPS7bP3poo+VZ6qGcCP
	 kQQSN1Z106tdx0cQh9tJV/OHYfkHSJO3zsj8C8lOJgEl5Y+HMzF6GcnghkhF+uaj3Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776247;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=10ADF5JQeUer4/g5urR4VSj0TBVpQcovMyF3zEdeDss=;
	b=nq55q2H6CUyvsgcGpooDQI0tc+gHBBJs/EZHT9T1ldYyUSRFermRXeM5WGNUVEZxdY4q
	 UZqKyuTfEcm6/4vxzg7S9JUcCaa7kD4kUWSPE7YezSKLAb6Xr0r/RXb+qeh8kk+tYzKoZ
	 wK/vkUlR1EeM89ZDi5zy/gsKFf0l9bu5Ca0YJ5XiEG996gYOLMHUc+xAP4W0yPXAlC8/N
	 ikILw+HqRzipVCUgAMwJM68tdKguXpUz+15iglwu2IrhSiHNcFG386yEWTxbzLniRwbib
	 pBvaD0zNOyam49nsoTN64F805+ZK4yalKuw2n1dhlVpC+DDWfJi5GkGOs1KaLIMqs8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dvt1Ofbr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BtCplkE1;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBAB606A328
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 07:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BBAB606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dvt1Ofbr;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BtCplkE1
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4701XV838284
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 07:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	10ADF5JQeUer4/g5urR4VSj0TBVpQcovMyF3zEdeDss=; b=dvt1Ofbrr58NBoVw
	WNP/pnxH/mRsjtCRAX6ocamjOFeTdkZDC4DQPS1mNiZj//P+LXiYt7iLT9qbgkq2
	98T4trQn2Q15fOshFyM5ZKbXG3HuT8B569Issr4WXu8sBKcmxpgkQHzFsfKLBZ8W
	jgHhwg4a0Fj2iIxS6gJPxhig+rVrHzOBmtqNgijTsTBvoEupvdnn8ELRCmOA2pYI
	a1lBk/lFcg2+LTHf0fx/XHoQ6s7F8zbcMQCdgXGiotMyHuZA+l1nZ6RuSs5+QuZY
	t8Z1ptb9ShbQd/otJNkijy+zst9M/01opeE1rpq/X/N7dCtSJnGgv8njpqb53kQK
	wPvstg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqn8mtj47-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 07:10:45 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed05b3eaecso4086085ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 23:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793776244; x=1794381044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=10ADF5JQeUer4/g5urR4VSj0TBVpQcovMyF3zEdeDss=;
        b=BtCplkE1fTO6ZjkB2j8sSDyXFAdG1K7CA+Os/bc+koWTV0mwzWB6utIrW+8kWqJbP6
         /1f8wjxVSM2nVMieH4fJ7CgjSYWIfYKnEuRNEB7ynCoTh0kn88OdMNABzxVtkwnbF9Q0
         cuZdQxBYzTuEZ5FAVOn0qdgTxEp1+76aIlC+Q9alnq0jgUpVBJfT1SnTCXuTwrX1SNFC
         VkXXKZnR3osx40mRuRLpG9E72woNs8gVML9sCqC2N+Lgam+SQWJ/PFe+IJOvAlVqJAMw
         7ry9j9ceGuBSaSSprf3vFxr2QV8PIZKhlWEPppqpV0KEIp0nEP0twU4m6HEYD1qesTwx
         MhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793776244; x=1794381044;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=10ADF5JQeUer4/g5urR4VSj0TBVpQcovMyF3zEdeDss=;
        b=CygOIP2fRSAsxFRSGZ1HL4Tc+EJBfAdLF5k4PWoHMPBVIBsLYUK+yANTQqE4jn2tcV
         qRvPWZ+5iWw+Zxf/kFPVPP+qC2zekPExctE/+PV8ebZrrPavN1Z7ZlTHJkVPXtipXp8T
         71qN02TBXAtPdhkZ4jq01U/nHsjEFnv8yI4vXbovB7P6SwBL8ZXhFuOCTXBmZEqTFdWR
         AQPKc8CGfHbAuxFensy127erPb6I/UIcG92E4uFvQSLuAgyNbsigXB4BfU/jqoEvbA4b
         P/JnSNlJ8yWW2NNjyPdBdaTMpdafnC1niznP7Vs36AKX/pjY0QKEt4fU+soMOJ5maq1c
         GLWg==
X-Gm-Message-State: APuU4Z++3xLbkOZAowXVDOBjTQii371TuOI4qISQphl666NaLN/T7rKQ
	KrIKcd07GFSGiab2b1xWZMWsEHjF3PW0SuwjYoQGc3dyhmaY8EGKwZmSgxonoI1YaWG51XsP3yC
	u/i/dbjbBpcS5XKqtqrVI0W9un+sy0TeJjIRxK8IlseB7fVgKzgd6edKBoXNSTO1Klvk7rw==
X-Gm-Gg: AYBFou2Wu+4dS1zXUVPGqyyF+nlKomIS8/sccMj+l62A+Dr8ff6TSJeOixY5vPb9xWG
	436vvXgHiZoZ1g4NQtADce1m9qz+Wi5S1m2BkhG1agkA6Qkgju2vr3b0SAJXQgMK+Bzdi6lCkWN
	KoxwskSrRF0LjD6YvvGvdouepiB3FFaesE8IhDO1L8zYymrezSQLVQMI/rhu3neuR15DLmNgTb4
	nI3SBxZKJrmIthZ03vlFbdOcC/4iY6RRfCVySzbcfiCGCcIdzUn6bUnf+2fvpDGNN/ZEqE9I2Lj
	8maixU0o6YU2m6Y5Y5M6dPDywet8ddVp0BYcH7wVLXpHh+ZWPG840WQQp8cSrFeB+5qargFsLRY
	DR1ce1joxjFFU/5lv7nmyE9jiwH6jK3jYc/tXwae8+DKvVKiLft3PidvTZBNdQN6NtCrEWz7IbG
	JQ/SBbLm9G
X-Received: by 2002:a17:902:e788:b0:2e9:7ace:ccd9 with SMTP id d9443c01a7336-2eb36509c20mr146988895ad.52.1793776243926;
        Tue, 03 Nov 2026 23:10:43 -0800 (PST)
X-Received: by 2002:a17:902:e788:b0:2e9:7ace:ccd9 with SMTP id d9443c01a7336-2eb36509c20mr146988665ad.52.1793776243414;
        Tue, 03 Nov 2026 23:10:43 -0800 (PST)
Received: from [10.152.203.150] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed091cf87fsm3641085ad.67.2026.11.03.23.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 23:10:42 -0800 (PST)
Message-ID: <e05f0373-aa6a-40a4-b778-22f40a4de0a4@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 12:40:38 +0530
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
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
 <029eac4d-9516-44eb-922f-73ebce894925@oss.qualcomm.com>
Content-Language: en-US
From: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>
In-Reply-To: <029eac4d-9516-44eb-922f-73ebce894925@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Zq9VGR9Oh1SPHD8K4JjnLayHqvc2m2QI
X-Proofpoint-ORIG-GUID: Zq9VGR9Oh1SPHD8K4JjnLayHqvc2m2QI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyOCBTYWx0ZWRfX15DlnDFxy7Yq
 FUI+gCdYkj+xtGOC7Vpa3sp9tGKK8T4PIaUXnWRg3b1USpr7lCI1XNR8cwewyEgbq9z/aRi6p7f
 myIO0s/t2ffFbxXeZeBWN3lxfq15a8B59vM+kvQ3DXBOBs1hQVfixdfPcvMlY03FUNrc7DRM2ha
 mzgUMq8aPNmL81SK8PriwZvyLVMbhJQtryHlQzanh0ydPyKSHwyALY2xlbyt1VBzWYYdGrWexdE
 c4MXd+9z3esUunPEBdbTSLuzfFSsqyF1xwqfwERIS9041A9T3kqoITPpbmfuIaNNVoGlMd3Hly0
 KvpzBVvMlgo3/dingXR11eDkwK4GNdf6eyW96GyjQm3B6hCmGoFbwq0GolY7t7ZOXnFLCxiDCDK
 c2v5hS0JnNvi+qWaF7xz38cn00r6pmLSlMvw+bwJ+tGg+iYq1/GpQQqYXmopiXKqkM/7i4irZew
 Wopyy3GIMg++54nCrvg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyOCBTYWx0ZWRfX+xle+kaGYhMa
 TAw6YNezVhJd9kdCpDUI+7NkdHG/DrFMVjqsPeuZmCDPSKaKN16kQXgdNunsATayG/CoNKVt97w
 JraQlqRN2ew8TPeFKXjtDBCTdlsTe90=
X-Authority-Analysis: v=2.4 cv=HbWB3SE8 c=1 sm=1 tr=0 ts=6aeada75 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=6tpJQmiB9JWEHceHjxYA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040028



On 11/4/2026 12:23 PM, Baochen Qiang wrote:
> 
> 
> On 11/4/2026 2:30 PM, Madhavan Ganesan wrote:
>> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
>> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
>> logic for freeing a DMA-coherent firmware memory region and loading
>> firmware into it. Factor the shared logic into common helpers.
>>
>> Patch 1 is a preparatory, no-functional-change rename of
>> struct m3_mem_region to struct ath12k_fw_mem_region, since the type
>> is also used for the aux_uc region and the old name no longer
>> reflects its purpose.
>>
>> Patch 2 refactors the shared free/load logic into
>> ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
>> rewires the m3 and aux_uc wrappers to use them.
>>
>> ---
>> Changes in v2:
>> - Addressed the review comments.
> 
> this is not enough: you need to clearly state what are changed in each patch.
> 

Acked.
 From next revision, I will clearly mention what I changed in updated 
patch set.

> And I already gave my Reviewed-by: in v1 review, any reason why you didn't carry it in
> this post? I don't see any major difference between this and the previous revision.

Based on Jeff's review comments, I have cleared the paddr and reorder 
the function definition. So, I thought I cannot retain your Reviewed-by 
tag. Please let me know if I need to re-spin with Reviewed-by tag.
