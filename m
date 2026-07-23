Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E9C44E656
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821850; cv=none; b=bICX1SjfAivS9wmgoQWvAMFl4SNgU72zDhyHHVhwo+b8feQsIGMc90pYtJDA00hxsVGCg6td3/Lb0fHcQx5i55xy4c/GEE2WvOgXbZ9U0Vw6Xpg5BzSiLVTSLGnPCCWTbet3iYes1EUaov7jpdu7TZEEpcae8t4+rXxlAccVCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821850; c=relaxed/simple;
	bh=e00eOfeaB6uFtEfN7KLEKLlR9NX1FdhY3sKndYVk8Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qTkH7OL9YGPg+1VwzgBK/ZOzmxJ+L8KcjsSxRtoQ/XCB4dtTuNSrq57Y1jn+XxbtRtiO0ul7hRFgZO5k4sNQL2PVdLlNupQQsogA8m87acxcdp9x/AlSkUa878ncjyXDarhK+StjgfzkOxFFpuSfy1qMUgpM6UXqGuaEXNLqhOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Mb25Wlij; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iwvmUYzo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Mb25Wlij";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iwvmUYzo"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NCvVNY3819832
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 15:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2AI3MNO3XdtPhdg8gY6ssE/s3qrDCtqoklZe1KMeMEA=; b=Mb25WlijW0N5/+ad
	5wcpk3NPwQ93Hn/3bfL3HTTO3hQ1cAKMYsJdWhtEVTNPnnZ8BB7Vp8R4eqKTLYrH
	D8guvPZr/anxelG0lb+W6zbWztyFtVr/eagr7ORgC06MONImfKvfLqlEE3C2Lb2u
	TZoiY51iLZxDDqxs6lDSys7pBXr/bjFL4uczHHfYA/U/GUthA5hkp3yxt/tuCmUu
	KVyVyY0l6Bya4/qWv0cVqUpHQchFTQ7rSFpNtTCEuaL57K6j+yY+LDhaEJy3DGRh
	Xt4Q4NFj4KaCqGXaMytD1n+P6AQ39h0EDlxcFKrytKXvHKoRaoRbsThHO0bF7vAx
	oid8wg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkafw35u2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 15:50:45 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cf6acd760cso12054175ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 08:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784821844; x=1785426644; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2AI3MNO3XdtPhdg8gY6ssE/s3qrDCtqoklZe1KMeMEA=;
        b=iwvmUYzo5t1KIHbmKb8rR5JhdszLyONxI6MSDs4FIibGRfTj2QRUtBlLpzG4E9eDt/
         rf1f4qwPWbsDIOdMPRxxbjuPSiIfOIpJsOFtSkCi+ROdWTFGjKH5P/YKRoe0C+LyzVr6
         y9yEg+TKb3rT6dLeJBT99jKBMn9mkdLYgezthm0Xn3DEcufozs+BhFyGTivNbkdPei67
         as13FdhMIhrRjYsBS7rALpAN9BKFIej9C7L4iArXsjmLn3nl+jsw5zwIHIBmnrWIQIzj
         l2Zwb2Obx8gno2bSPDDF+c35hhSYmMAji5Ge0Q6Atx8CNt7tl4BjcSuM6ZQVnYSToFjb
         Xjsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784821844; x=1785426644;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2AI3MNO3XdtPhdg8gY6ssE/s3qrDCtqoklZe1KMeMEA=;
        b=Lq0j13+EIkJ6JbMOgoH11P0xXmbjcytHwoQR0Vs/WurXIBKe26gpPCjXf1zkNZdUG4
         C7/tw68pDPqIBTp7khtaq0koDVP6AGQ7hpblyJuFN0MTfQSnXysSp6zPfI/o8mR17T00
         cT45MsFKSXxKxKNeSGJWl2wXNj6Y7ZCmW5wBEKvP8dSex6BGjUjq3pZ3lK3vzXOFdiWw
         Xp/YspSpm9ppIKpsLwYsNnZyJK9jaBVcti1UJ3h/pyT0bfNMt/H+iMDUyvfTJCng3iut
         EUVzqv0D286ULNe0cu5J8ySi0JuGc5GlnIG3phjVUCSZZamn+lBjdU05w8crlZD00O4/
         6o9g==
X-Gm-Message-State: AOJu0YwB8gLO0WSCMllDl8CSs7aHV3JM3ema6514KnG7AWLCUXbj4DPA
	4AV2bYI/oS5yLY1Q048vC5JlXyw5K2oLoga1E7d1lfEg2kYoYPPORw3pxmCSOM+6VLcia7sTEdv
	I4ruYrXFgAtOhnw9WJxbMajMhO5lp2Ed+IJTCiMRLRG3NOjK3m7vYYR6Y+/HK+hcP4bL/NRRfw1
	/wlg==
X-Gm-Gg: AR+sD127r0HRbFpbw4VyQHdSyPmrfKat5p2MmQJi0vgXHz29lfgHIkHMxGrYIjpYMCp
	RswvHyLGBIfy5C9ZStPIYghh8TXxQFXKuzztQba2jPwKFy1T4COXPNNiRwaVJ468rMAPa8OduHG
	7gUN0IZ8rerMsOQiEH4BqwNcXeBqmBmKvNacyb/NtmC/hc2rvXM0xDY6UoeFRpLH9ywkik6rtay
	0wBU3V2bVhWe/z9jAhuwOd0amNWbro/ddjx4VuATNZDCWNmrtK7Dj7cyicIFvZIZlWR4wTS+dvB
	lRC7FqOwD8GKSs9KKVrsqOl66eZjkE3mLXYDvJ3nVX59OWaixzKy/bBIg+B8dE3Daja99p016uA
	3M/MEiR20ZWIcEhjjtdjdx1wNIprB2EyBYPry2ZE7LQn8zqWzwZjafqHOgw==
X-Received: by 2002:a17:903:3d06:b0:2c8:1f56:9fc5 with SMTP id d9443c01a7336-2cfa6d86c4fmr40575625ad.35.1784821844370;
        Thu, 23 Jul 2026 08:50:44 -0700 (PDT)
X-Received: by 2002:a17:903:3d06:b0:2c8:1f56:9fc5 with SMTP id d9443c01a7336-2cfa6d86c4fmr40575285ad.35.1784821843714;
        Thu, 23 Jul 2026 08:50:43 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1ca3efsm25698810eec.30.2026.07.23.08.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 08:50:43 -0700 (PDT)
Message-ID: <e44df9a5-651a-4ef5-9bdb-626c845dbce7@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 08:50:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2 1/8] wifi: ath12k: fix out-of-bounds
 clear_bit in ath12k_mac_dp_peer_cleanup()
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
 <20260720-ath12k-fw-allocated-ml-peer-id-v2-1-630632758a80@oss.qualcomm.com>
 <21084de4-cdf5-4a99-9e0c-da4db067e4f9@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <21084de4-cdf5-4a99-9e0c-da4db067e4f9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=XNkAjwhE c=1 sm=1 tr=0 ts=6a623855 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=67VretDDciP4QXt5TvkA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: 8IkoCcstBD59DHCbSknbliixd-PBPIhV
X-Proofpoint-GUID: 8IkoCcstBD59DHCbSknbliixd-PBPIhV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE1NSBTYWx0ZWRfX2Rz0iOZdsS9k
 3mGmMrF3ahmCkF7LUFIK6QwwdQKHhbl6clvgcphNVUn9GKCaKUIFD9XmsZLrFUVJQkW4+LjthdR
 d5PM1uBCMBTN1gdWWCu+EFnvpfUZkkA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE1NSBTYWx0ZWRfX5dgG8Hquf0uu
 5epMGgrJuXxk+eNO846+cARLoBxUnARlGdlHymYesAmD2fCzHEumOLUb7rZRncPFRdmtdXHmaKY
 ZP+WuqPyE0zuGf3C1We+BqXomtOWg/0Zx7Dq2ygO0A2tHfyxvSDZOi/lgTA/5b2UUnSX+PEPyOx
 4yXlfInp7TPfcR9mfd5XBDRTFvVvV4a5b/qcfSnCwbQNgH9UGuoR9d/+HS4kQnm5raQER4dfCLn
 yrHibn4a0/5NosiGEt2uCfsFSP60IG50Dg/Vox3hL3p8as38SgT2WEd6FxmTIOOghFmWQqwOx+3
 08KLvPJRVttmqL7c41QX8s0PDN/OPEWnBZtSbE1+fYARJZAW4zqa8nNPeYtEYd4UPgYQmZFI18n
 Klw1pVcc63HWMUfrRaO7knDCFGy293MljFtIzlhVqZeTRx8WZsrknQ8CzAkbDIscBlnXHOv/jvO
 kTaqV6ot5opZNOFYwIA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230155

On 7/23/2026 8:45 AM, Jeff Johnson wrote:
>> +			clear_bit(ahsta->ml_peer_id, ah->free_ml_peer_id_map);
>> +			ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
> 
> so this now matches the code at the end of ath12k_mac_ml_station_remove() and
> in the cleanup section of ath12k_mac_op_sta_state(), so perhaps that should be
> refactored into a helper function in the future

which I now see in patch 3/8 :)

