Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E744A4EFF
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263862; cv=none; b=lzxgmBw8A8gcJfzDtaqnbCunIABjaTnAujt7Kvm+WrKP5BdCfHVsVoRClPCblebzAez5l0GbG+PNzG9aR/whsjhRdROqTkbN+x4/BbZwk3Q1OikNmbtcAtm4J1+uvUpk1jSNam6+g0ouyiQTYigDHzxlIBx/Vu1eMEv1HQEms88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263862; c=relaxed/simple;
	bh=aY9BlFyfWfGA8HiZfc5xvC49012CpHRWxFdQ71yO6ng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rb+CKdCTb73v7mTx9AKaMQPUujy0IT2XvCxpvAolhh4nSJLIJNatE22LxGJTzv7Je+JDRPMDFxcs2PIgSkp0nBtxAPNGiADe3qGGgAK8eQSnYI8adaRvq3wJggy/CTvZF9UmvjJKgNzvzhcd6zF1is7bVITB1BF4DXL0utXF7A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Blwpb5SI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=It0oDo7N; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Blwpb5SI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="It0oDo7N"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OC4quV2386288
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 15:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aY9BlFyfWfGA8HiZfc5xvC49012CpHRWxFdQ71yO6ng=; b=Blwpb5SIlHNB5zh9
	Q4nhjw3DeFgNXgqZA9LK9Oa+W3DcTNfo8XMasKZ9inJqXBsRztQztFID/OS5XwkJ
	ILTfTXD7vXjo+DmKy0WhS+dBMhm7MZPyjnhpCf1LmINkFOYBAoaccqjLKMhuvKqc
	6sLTZXP7rrpSj0lDSHbmS1uyIeqKNVZobf+GqZpeYcspsGxbE4NMx3N7VBUjiaB8
	MDDqC5PIQx2s+x7sNR2oCXthcfuCcupuq6W69V6WP0vYwFIs+3zzZkbaagmWB3yh
	tVpNvxU4TlgyGtBetKPtRiqlt+d7XaavCN+le9VVWBdLpxoyX9j3TSte5RYxFxqw
	tt++VA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvsfgu89h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 15:30:58 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2dd1631d291so19386155ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790263858; x=1790868658; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aY9BlFyfWfGA8HiZfc5xvC49012CpHRWxFdQ71yO6ng=;
        b=It0oDo7Nr1q4wD6c6GzQuVjfq1+X1Y4rRbxlubS0Y+UGJd6hfTNG3o2+z7MDg0z9UT
         bef4QcMJ0aEUxvLLif9AEAAUV0vIYlgDr1PFteFYWH0AFxx70u5P/3PNzLf9J49QbSZa
         qJdUjeEnycNrxOuwva/r6M0x8idOPpxxxJyYBGuW/Fxaa8WNv7kZQXq/U1g+viw130hR
         fcOEl3iClBP+VE0H2QNMWq6OFS4kwOwHr9ZUdInnk0HqPfbOI7x1tG9GCdoNJkGD4mh1
         ErcOyp9vzaOexuljPmeV25yA42uOl9hsRALuN17CVn1NvdWjfJgCrhzjZHwNVQEFNlZg
         VCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790263858; x=1790868658;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aY9BlFyfWfGA8HiZfc5xvC49012CpHRWxFdQ71yO6ng=;
        b=FKXMl87OVZRxe5PhR163LcAb1pqkjAIqTI69u1W9Nk8mOJbBsE0DGrna6tYSY4wYnt
         VeOM9KZl69uOKvcWS3iUXlH6m97Ca8DAcdEj+214v6r7bJx5lU+1SJ3X6Ri2g2ca+2M5
         kVAMxemY/cZr1sTlK+pZ7AK8PKISjov5NKWWIGhhwIYkNWclcnRfXO5hz+E2t/SkyfDw
         i7zTf6AupFTzBPFecqe+TxTdKneJ7BKTyhX42mTV/EvXSe8XwzjSOiB4l8o5kp5zF+tv
         IjwgIQuR0GSuodWYWIlx56E3x/uKyKZ2dNRgte6c3qes3XcUUPhTRl7re4lng4mHIhLI
         oPfQ==
X-Gm-Message-State: AFuF++mUf0EIKXeMH4mAp4GjyYuoeIMe4pMF4ELZxLO17rPTdnL+v4vW
	5deFLuw0JnQFUO8jw8qO43IGOY826dS/j7khDnAbLCKZTmeZrOr9BBffnPOb0JDwgk8iTYZ58U4
	4cdddPYrFlQr8dxfPM6+rMGD79z+SM06JxnPEJchvj9iLqRSp0eSmEZVQTKb+DBDEQABI8Q==
X-Gm-Gg: AYBFou1qn6k3d7VHHswhfrmXSdYHmKO/A+oIq5zLFDcLsiGqfRI1W7ASkHoHiOuyNR3
	TBnqT5xKRi/2LWM+TN09GZHHZ1glOMFMCVHRAk2g09TaYR+JVR5mOITja+s6CBnOIklLFD2pQLt
	NlS4ndShTaF60B/e1abTIcfQQSGgOfEXFq07kjLdj6bFiVUPeeRsNO6KFlmzyqmDJrH9PosERmS
	mIUBFpZH+xhwhJNSCKe9wxFsjf+lTQwYqhf5U+/96/WAsEabKfJDRHQRJe1HMl86XLrqqLtncm4
	ZsvESMCygYSssr+upCoDyq+XC9I0bxX1YduqXdDI2Ts99pZaXw7q82P+spmTD0xWd7n6r1enbwO
	iN5wcQvXVZz+ZR7JkuYvJVwjPNogNSC/x+HThNgyelGnON0CHJHBNKLh9PA==
X-Received: by 2002:a17:903:19c8:b0:2dd:ad74:ac27 with SMTP id d9443c01a7336-2df7e39a0a2mr23958265ad.25.1790263857447;
        Thu, 24 Sep 2026 08:30:57 -0700 (PDT)
X-Received: by 2002:a17:903:19c8:b0:2dd:ad74:ac27 with SMTP id d9443c01a7336-2df7e39a0a2mr23957755ad.25.1790263856817;
        Thu, 24 Sep 2026 08:30:56 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5de5c8sm29772105ad.60.2026.09.24.08.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 08:30:56 -0700 (PDT)
Message-ID: <8e027ef0-6956-4766-9ba1-55963bb6c537@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 08:30:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v4 4/8] wifi: ath12k: add device DP stats reset
 support via debugfs
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
 <20260819053247.1420393-5-pardeep.kaur@oss.qualcomm.com>
 <435e3012-9b6e-4327-97cc-f65ed1e0e5c0@oss.qualcomm.com>
 <30303e94-f0a3-4e91-8690-006fea92dff4@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <30303e94-f0a3-4e91-8690-006fea92dff4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=YfoodARf c=1 sm=1 tr=0 ts=6ab54232 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=1IDsVKZWqnER_imYb_IA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: Qm-AL1VXKAZbIJZbnwUv6yMCr6NHv_Iz
X-Proofpoint-GUID: Qm-AL1VXKAZbIJZbnwUv6yMCr6NHv_Iz
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA2MyBTYWx0ZWRfX8z6lEtv/JjrC
 7VDltvVbLwivo5UJslAIzPIDDOhI+xiRUr/2eIr9pR8RYhkYG1I21hAsOJ8Us1YsWytEBY527jv
 S3oAYnm1+hjGNIk0QAZPeI2sioQesz8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA2MyBTYWx0ZWRfX0pgSFHGT+vJh
 rZ3Rel0Yn9zxanXkQ81zj6b0d2lj8tpTHu0h4cMbnBBnnqmwRx4OULNj0I3n/PQ5vJmmbnvfWIU
 j2F2pMsNewNAZjqxgHU348LyRYrB1PaDoQq3NKcWwkpyxNi/kiAlFZhY4OomROSE0ma/dgAZMUx
 ayyHm5z2wXWrRXDA1SDgoJ+frNzeVII9AByHiSkNLsprrpUrs6spey3XSZIBqWRQP1+JMcMCaHo
 1Fy+ZtT4rf+pVDdqUVw/IS4UedKjTlzElXd9kissQBq0mIDB+9/ao7Hbh7yDh5X8QkA+TZHW1sF
 S9AEE/ml8QXIAHYielLBvNn11UDJ09/wbieOdkrKduRrpYOXGMBHpf43aHRf8TT6SggFv8j9YKs
 HzVHPB1++Nu8C9ziy85KRq4W9u6oU50Uq+FILSKiLL8NSEhHQYTzcRML/ryqd1y6LjEaVcEXD78
 +fqnB4k+srMlz5VXeZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240063

On 9/24/2026 12:55 AM, Pardeep Kaur wrote:
> On 23-09-2026 05:42, Jeff Johnson wrote:
>> On 8/18/2026 10:32 PM, Pardeep Kaur wrote:
>>> From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
>>> Add a write handler to the device_dp_stats debugfs file so that
>>> writing 'reset' clears all device DP stats counters. Change the file
>>> mode from 0400 to 0600 to allow write access. Use
>>> simple_write_to_buffer() to correctly handle partial writes and
>>> non-zero ppos, consistent with ath12k_write_simulate_fw_crash() in
>> in what? the last sentence seems to be truncated. Or perhaps just s/ in$/./?
>> if there are no other comments in the thread there is no need to repost just
>> for this. Instead just let me know what text you really want here.
> debugfs.c.

since this patch is already modifying debugfs.c, I did s/ in/./ in my pending
branch:

non-zero ppos, consistent with ath12k_write_simulate_fw_crash().

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=3bd2457570ab0a4ca5e7e354e7b6d8703ece6c93

