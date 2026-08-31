Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F59C37CD32
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 19:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788205272; cv=none; b=PKms1q3e+L/0gujzx9+/tCfPp3NgB2BN6jq2Pa/90a5skH/jxlLjzefc/vPMmzgZpg/fLUSPr0EhOBSPiTO9jShBAw5FlP6ovw1wZ3NjO/YDb38mOxk54Oj4+ZUL+Q1VJsDnOk8bQ5hjyvlnDuJ/hC+eic3m6IbTJk3/YpgIzpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788205272; c=relaxed/simple;
	bh=0o9MyypgBrEnlUxFc6x0hzOj8hpBUJe8OJr8Wwb2Vrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGIuKFE0FVG+0agwsKbmx6PNGHHWFFt4uYUkum+1xCL/EgvZa8LjSsZ/jsEGl+wy9dpHcTHFrvDPt8ZSzT1p2vGVdSnpMENOKsc77UC3ORWFmTVdkgq23Z1yK8eM6GCk51rPSAbgllReaTMa1kCtqHHqIpA3Q7reVCCWWXoZOQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hTCHifCk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KONIQfF9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hTCHifCk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KONIQfF9"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VIxJSp736679
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 19:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	a/VOoKcp2TQjssQcleMKDkNpgoRKV2OUeoT4RilSG/8=; b=hTCHifCkykOx3BUv
	Dk8viKoBBKc75sKUj01VBObMyqFUU65gRpe2AvmwkdsicPmjbaaZslhLZt+owvyE
	rQttCHCtCr3ZoyHco0lybdDMV4Zg8tnWvA20Bj1a2NKqhEP9SffFwXPUYgl02A/d
	wzzz6eUpHDkHknCT2f39KPK/EduolDGiqx4PCpr62fRwrB2OWs0GDSIAFC1MDvWy
	nGbcTIYGMiHlBMxizFcBZFsNSwaY8PaNVpaWVJm5UwdsSFq8H/5FyyIYHptVYCzK
	dRHOo7NlQF2CA0QJaHoY2WzEO2RmEmBYg7IMnZj/8WrWqOVjKtz4QJFZ36a1Kutw
	/zljwg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdfch85m7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 19:41:10 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c89704da8c7so6489273a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 12:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788205269; x=1788810069; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a/VOoKcp2TQjssQcleMKDkNpgoRKV2OUeoT4RilSG/8=;
        b=KONIQfF9nhZre9w0N7C+TMOPVR1BbCsJpMb4fo8wl7GXwHP2xXQCuzdJx53i6/mJws
         Ie7YGTWW4XKuP1ICefb+HTODNRRJftgxmBB8BXd0y8o0HNy57UqaqfXgeUhmIfdrwaot
         LP0WbOSw5DAZ7ntvlDpN6ZwWT35ShRVlFoflOO53z8uk9cQVzzxlblLwj3KYKQ+4D/Hj
         KCWzCLkaj2bPs35sQ2Tf2TBdMUFAd989EHlAHLDK4SoXsXX5gF3m6LB/J+/VisAhGzwI
         K3R4/1dN+UZ78GwG7mUc2Pi1tjtoTIiV97x+iczoZTa0AofAl7hGz0LAsxxCaOA629LJ
         JQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788205269; x=1788810069;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a/VOoKcp2TQjssQcleMKDkNpgoRKV2OUeoT4RilSG/8=;
        b=rR2ZYXWMWvZnTo/wTqqXPGPuziQMLoQka86fd8Iu8G5rcoHgWMcSnTSZKXsc44KYxy
         Cma1Rc1tbGq13oC6g/qCmKdsY6rJY3NLPNBa6nKs4r4VbcBfll6uaXL51M1jF+xgQBKR
         J2Yo72MwNnN1GxaAeOkA1gLGBT6NOggDWBBqKsDoj/ArLASCzrbw0xUIL9myHP8mSGhZ
         01paZ/xhvGOa6B85r/THhCQ8WBBdruoFwVSxkogJsP2RBEtgaA64bhQ4AEv4baw9tuJv
         TIYf3W0Vj93XeVgwh+I4rG1TkbtqLnxAkRm5QtE+38NdQCRuRAbrfVOzqxgYy8CtR2hX
         mnhQ==
X-Gm-Message-State: AFuF++mT8fujdbOTcpQf8hXs5ZQl5hVX/aia6pSrtuuN7jwGgwOdVOID
	3eaZPM8upNULP8p87Qf6EgaNNoj12CIDq6GP1OOYpkXCVRbzA+39R2/ulW7Goju2sORKsw9cxRj
	VaerWkcAgi+1qwLBUAOOqV9IYlhTcA/1jH/9skUX8iOeswhlbhK45hyFn4r6xmA9w7+w07Q==
X-Gm-Gg: AR+sD117lGwt6G/6f2djMWfElBQVeJzW6VYgKBOjqU2IgZ9XKkp7P/V2nTsIww0OlKf
	VeK1YFcewhmeD979F5D/loV8xP+RFqJyRaaufDhOQIG1uwoaA4YW4dKYMHvx48fFDR4D7cK4YZX
	4KJTqvswXJs7MBhak9O0GMS3PF1SUajur7yLaIXALKEKyEtEl6OhAy2TM/6V26DajP2IsvAkDd0
	ththXHqhnl9RwOeR9Cg4S9gcOnacwVmenDUTA1+atZjRaDaOulvBs2bNUMb0HjVrjmysRdhdMKA
	UwR8vgRGUuVlktVuKfF4SbKwmdoWE0QVEsJXhvUNK3xTE73kXXAzRr0Z6As0WuOw/lp3aTjO1W5
	38ZBr1u5o9PG3nb/rhaYRgaEZN05IosCImdgQEoNto3iV1itVH84bkLg=
X-Received: by 2002:a05:6a21:6b05:b0:3d3:aec2:4dc9 with SMTP id adf61e73a8af0-3d7b054a699mr5311312637.21.1788205269018;
        Mon, 31 Aug 2026 12:41:09 -0700 (PDT)
X-Received: by 2002:a05:6a21:6b05:b0:3d3:aec2:4dc9 with SMTP id adf61e73a8af0-3d7b054a699mr5311251637.21.1788205268534;
        Mon, 31 Aug 2026 12:41:08 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f552473sm35477313eec.0.2026.08.31.12.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 12:41:07 -0700 (PDT)
Message-ID: <dacc398e-04e0-4b30-a770-9308ad4e80bf@oss.qualcomm.com>
Date: Mon, 31 Aug 2026 12:41:06 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: ath12k: support calibration-variant from
 device tree
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Andrew LaMarche <andrewjlamarche@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson
 <jjohnson@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
 <8024a15f-bbab-47ba-bd18-f85eb1fe3dcd@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <8024a15f-bbab-47ba-bd18-f85eb1fe3dcd@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: e0GJS086AIUZZnN3_M0PgpMV-iwmNClu
X-Authority-Analysis: v=2.4 cv=G9Ms1dk5 c=1 sm=1 tr=0 ts=6a95d8d6 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=hMWfrMBfY0pDR5NQx0oA:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: e0GJS086AIUZZnN3_M0PgpMV-iwmNClu
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDE2OSBTYWx0ZWRfXwf+6DLkNTOAO
 Q0+rQWl8+MHx0YwGb1dJwyyXrjDjEty3nbgYS1WcNvXpyyK0zXwOIjlBFR/lpPPn9hlFot4nwSN
 u+IwjI3/0SQB0A1k0D0YE/ce6v9pDmI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDE2OSBTYWx0ZWRfX9uiVD37QG3K/
 +9V6ZMc/q6jN0yz2onyWNmwml7sDm06Ny4vPNANH4CeGHd5hfYjzKWZvnPjvTOBDCQzoS1znFpX
 Ws8lzgU/6FC37XKGL3l8oxKdHM1pSfDb6MTqe65mpGIZeELdIg1SMuIyXSWzHC6qCJRDmJtXUha
 r4kRI+LNVE8H/GbunJxbzVjKht64ZaykUGd7JwhEVeB2Cqgw4FbzRnYMQi4B9M/yu/uKnzp6V21
 1YWDGEU9cK+12aoAdFdk+BiilOc+9S9xHIGmWG5KI2dKTytlhqBz22Ulliy3rS1wUmyYgJyzMAv
 Tzpea06rSAzdBHsOpFTfSXyuEMEDL+yXNzOpglVP/X8TpLSTwqLDWu/+ArGN2Jb7dx9Or4c56ZE
 X82+ZYfInZggXUCfn02pnSritPSw4D9383P8FNpU9PB6q982T7/y40B54Phztl3EQAUTZgx7+Y1
 WTU5znK4GuP3hmRbP/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_06,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310169

On 7/2/2026 2:32 AM, Baochen Qiang wrote:
> On 6/30/2026 9:30 PM, Andrew LaMarche wrote:
>> diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
>> index fd762b5d7bb5..3cf39ae06fd3 100644
>> --- a/drivers/net/wireless/ath/ath12k/qmi.c
>> +++ b/drivers/net/wireless/ath/ath12k/qmi.c
>> @@ -2945,6 +2945,10 @@ int ath12k_qmi_request_target_cap(struct ath12k_base *ab)
>>  	if (r)
>>  		ath12k_dbg(ab, ATH12K_DBG_QMI, "SMBIOS bdf variant name not set.\n");
>>  
>> +	r = ath12k_core_check_dt(ab);
> 
> I understand there are already some variant exacting helper (ACPI, SMBIOS) being called
> here, but they really should not. After all, how could a qmi message relates to ACPI or
> SMBIOS?
> 
> I'd like firstly move the existing helpers out and then add the new DT helper.

This code is exactly following the pattern from ath11k. So I'd like to have
this land, and then we can think about how we can clean this up, especially
since folks are waiting for this.

> 
>> +	if (r)> +		ath12k_dbg(ab, ATH12K_DBG_QMI, "DT bdf variant name not set.\n");
>> +
>>  	r = ath12k_acpi_start(ab);
>>  	if (r)
>>  		/* ACPI is optional so continue in case of an error */
> 

/jeff
