Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C50356A12
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 07:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789026248; cv=none; b=uJoOdx19fVZYwK1pipC/9s4bfuzkD17hpR9hLcm9EtEbTqav7b9336RcFBfASyddCWgxQV7ZJoQH+FYcinD4hGrHMqX5ChgJDQBB7nnb2fhlmgdmucoQea1z2DYCf/IsviULYrS+B5dHHHT295jJqDOvZUqk6Tky9qcj/hXgggY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789026248; c=relaxed/simple;
	bh=HO0OcFMKlIn6U8OAWQpnRWhW3yEB9HIP8nb3cys1FIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqUkrvj+mht8YdnXZNtEfr9LtxMwwCh60o7KmErvARhpqP2yek2l9QfzitxLU//Pfcb3M++LcYkT2boeO0kLSsBiNGFwvE5Z3YEIxp3+6pYLqTc2TNWZ5zgvIXhjfZHkGcZC7zKSz2Vp19+HHf8lc2h8IfTuCo1Mcr2OEetXgNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ugmzhy4l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A6BPG3H0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ugmzhy4l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A6BPG3H0"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A7aweH174776
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 07:44:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WDTHVRI0XWgtJZVWPPiIvHeC9YCjbbBV7nAStzyPMYw=; b=Ugmzhy4lsUZ4VQsl
	Eq/hY+WAZnqYlD8CE5wrtG7NqWpjjU+GL9JBWN2D0eCcfvr0CZpXcsPfE/YSRP1o
	evb1E4tjabX6yZels/Mfd1LsSuSax91spCohBsLWnZy3YDdGfYQGtBGP3Le6A3z/
	U7nKaxh88SNhNp2+yciahrTsdQmHH+wdkW4cjmAAtU8sQixHznjC6wbitMskUkD1
	cFRAawNTBV4TeL/GGGLgOt8jCnWOEvwNn8z3J7ZkvVKz9cBWw/bTQvwN4fyMzLi+
	1FlhfEy3gWPL4lKcxYfQuaOJTixBI0To0HR5mTl4PmQLWDDSnW2eUXuqz9AYepv0
	n8HyhA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrak80tm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 07:44:05 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8623e5d4279so8312170b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 00:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789026245; x=1789631045; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WDTHVRI0XWgtJZVWPPiIvHeC9YCjbbBV7nAStzyPMYw=;
        b=A6BPG3H0gAONZbczz2UOZpzhyRDZoYcyOAO1BfLL9NMhAbs6bVtTjTM2Z1qgWt28vR
         lR2MWTXt46KVYZFKaHM0WKu5kIrBkQczZjp/4s/xIiOI2Bcm9pMMS4SsNqPe6VPHns5H
         6kqffxpDp+aGz9iXNDX7qz6Xt6Dn307COD0BzT0cDuG7mxhJIJaMDwZel0zXMepAbA2v
         jJcVAd3J5zs3j6Hqd0QwMBAjXyR7NHsv8BR+VFF+9ypvd5AdQbASntCcId7r9u40dNGh
         pSGVIfEG6t4F2pR9Afb1KF9nyZVhVP02FVEDhimhGMsxO7eDJizWMHeOVAiDiO3fMcBO
         C5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789026245; x=1789631045;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WDTHVRI0XWgtJZVWPPiIvHeC9YCjbbBV7nAStzyPMYw=;
        b=TFWyftIWdnsVjqYrhHyuINCONQOo1+OZxaS33o21LEsB7DZmQtdOiL7O2ivAkBROWZ
         dzxgoGNNIrDejtBo9hIOKBU0eoTcDFTgo1PUE66jQFpI5T4tXLD+hqwRndAoIuRUbU2z
         gcsfnm9In66LjvblVcG4JiVKO4TZDUbDokRWBZYlRMmuOsxnbh0thsZme0luFSV8LIOE
         hkF2rILhdiSz8KxOvI4xxGh5BKjcRhf1+c12wO9ja96QW3F1BX0bbB/BpbLvejIcadch
         PFOb5GWAJL4fAWW/z1P/UH0MIH+/DGnJMD1zlKCb4NumdcFE1u1GVmgXWzQw9TSfmPGh
         36nA==
X-Gm-Message-State: AFuF++naH369cXr2moKQg7UGDiZoea+Cbhhc8CHllqZn8u1xiu+VmhYA
	DShymsG0iFPbCkMSewYyQg81kLANhBbqGJO9tS7gjY0ODgGHtUPplLJ979O1vmNq4lHiWPtU+K2
	RyDmmd2lnhmfy5wj01eol5KV+tjtlLhlQnooVANIkn99r+Kd0erXsC/SD9HPmh2IdO9VzYvQA+c
	EU6A==
X-Gm-Gg: AYBFou328pETv82uK4aNU7DEvbbQM7QRDCylHPDdds4f8vF2HHRl9jgeIUo0ota12FK
	78rRVcEMzkVnTXGTdGdtkdhU82NuJ4ASyjze/qt+N7SCew08AuMe5OJCz1Bt/TH5X4QKNyGS7E/
	4Q+zukFI4J1y8X3oZdatSqFQgLlX2c8ItUpGoEYH2bng+zJM1Rj3CyYbQfc1gUcN0r3H54clSDO
	5uX140VJYeGX7XpJ8x2/EY6ICoLTJiWaDR9r8haKIh+Jz8pkGVm/PIF4H/fbxSJUcxH5i56vW+G
	VfvSnIgKVC5hJ3kZj5SF3kTjfqPT8rG79yKxdcTKCBNtaYKyuLyOkIKb+MN+cu12JzrA2quasXv
	0cg80bYtIZ8Pz9yIl/Qsri3bfGe6jo/3UxvCgZEmmgg==
X-Received: by 2002:a05:6a20:7284:b0:3c3:875d:c52f with SMTP id adf61e73a8af0-3da39ec3ef2mr57403772637.10.1789026244878;
        Thu, 10 Sep 2026 00:44:04 -0700 (PDT)
X-Received: by 2002:a05:6a20:7284:b0:3c3:875d:c52f with SMTP id adf61e73a8af0-3da39ec3ef2mr57403709637.10.1789026244303;
        Thu, 10 Sep 2026 00:44:04 -0700 (PDT)
Received: from [10.152.207.30] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14340a69666sm27644611c88.9.2026.09.10.00.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 00:44:03 -0700 (PDT)
Message-ID: <ff91a2e3-fd29-46b8-ba63-7cfe0f8c8e26@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 13:14:00 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com>
 <63ab746686edee2e7919edb1cf6c5ce06e9999d0.camel@sipsolutions.net>
Content-Language: en-US
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
In-Reply-To: <63ab746686edee2e7919edb1cf6c5ce06e9999d0.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA4NCBTYWx0ZWRfX5GTdlRwRImEP
 uqpyUXWRLGIOQvZAY42xQ38VqhWTeRUecQIN8f/ZUSP3enZXzy00Xi+UU8FljHF4FO+ByMGcdud
 lkxWJxs4RQTW6VQrPQ3WnGfLYDUgTU4=
X-Proofpoint-GUID: XiF4KDcovg8EJy8CxX9imJdrdO0PALPp
X-Proofpoint-ORIG-GUID: XiF4KDcovg8EJy8CxX9imJdrdO0PALPp
X-Authority-Analysis: v=2.4 cv=EspHPicA c=1 sm=1 tr=0 ts=6aa25fc5 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=GD1dXBpUDxVK8xaUgI4A:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA4NCBTYWx0ZWRfXx5CDRZXP5T2G
 w/+GyYVWnuh2Bh6JxAjKPG/q/cdLryxrTLZWmxgg5Gsr6EU6M9WLB0WGQUZNtqfgPSat+ofWKFn
 EP0ukcWiKnbbm5CQRJvnp/aY56f+DFNGvNU1hRUPhVVPleXIw8I4A7nHUMmNboaGPA/rGW901ty
 Lf5ol1U9GVk8cUuaDznCkqPwD+csXi/iGPTts6v3mRnIWCQyubKdPnOqxXj6mqThVpU//dTJyye
 JYkJsC+SgFSi8jpEW60H5P2+ex3WYi+7amj3hTh2zmvo1iNHzwyi3CHCcJEpuoxomICxzz6kUsE
 aG78Aj23wm/04E90KTLYxuYV14T1cywY0h4thInno85F0fDzeUGilatJINbxou6TdLMgxvmzqR2
 3LoS4I6FEeDKWauTBMVrP0N37eIxSLWhuYCmO/KYYFeR/fjvkJolzy4HfrNQwMH2aECZ1XUcF8E
 U2O0f67fQOxQCrhxnAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100084



On 9/4/2026 3:46 PM, Johannes Berg wrote:
> On Thu, 2026-08-20 at 21:37 +0530, Manish Dharanenthiran wrote:
>>
>> +++ b/net/mac80211/cfg.c
>> @@ -1138,7 +1138,7 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
>>   	struct fils_discovery_data *new, *old = NULL;
>>   	struct ieee80211_fils_discovery *fd;
>>   
>> -	if (!params->update)
>> +	if (!params->update || link_conf->nontransmitted)
>>   		return 0;
> 
> So why shouldn't we just reject it?
>   

Currently in user-space there is no restriction on sending this for 
non-transmitting BSS, thus it may send this for those BSSs as well, 
however the driver will use only for Tx BSS and ignore this config for 
Non-Tx BSS. Returning an error here could be fatal because failing 
start_ap or update_ap operation would result in failure of bringing up 
those BSSs.

We are working on the patch to update the behavior in hostap as well to 
not set this for Non-Tx BSS, but to maintain the backward compatibility, 
and the update from any other user-space application thus doesn't handle 
in a similar way, we ignored the update silently and kept as no-op.

Please let us know your thoughts.

>>   	fd = &link_conf->fils_discovery;
>> @@ -1173,7 +1173,7 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
>>   {
>>   	struct unsol_bcast_probe_resp_data *new, *old = NULL;
>>   
>> -	if (!params->update)
>> +	if (!params->update || link_conf->nontransmitted)
>>   		return 0;
> 
> Same here.
> 
> johannes

-- 
- Manish D

