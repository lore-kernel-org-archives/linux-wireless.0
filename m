Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A20846A
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785479019; cv=none; b=aJ64Qd27hRm8szR+pe/+FQBhfMPapol6xCfRBvJwWv+Nvkhwe7dbJc9cThKJh8BjfvKee4HU0q3SrHDZKh1vMmVYTqAkDddKq8PX9IvNcF2rPkhdKjWFCzNdGomJi1/ykp6dNVUDhlwsaIeSlY1cd29ou+9Go8/pYni1gdxrtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785479019; c=relaxed/simple;
	bh=E8BkLYLHk+oZHdUsyq/TJKECMGA7IM6K6m9ZN76YBU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YCgMcsvmELykIlAwfBc0th0NNWGWszY4JQWUh9UQo1OzNpQ/MywqdJDHBr3WzbGj9/roYF2YbP9qRcd/K717w1bs6i9mj58NZS3bg4zbMmtphhcAMeMWW3SGVEhcGmRog7BHp2XR7q5GcxFV6fCAImFbmnlUyiUatJg+meJHyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EcxERQMk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D46+z9NO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EcxERQMk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D46+z9NO"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V68ceX3639326
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bVXFujmtpSg/DPMRsHV+0ro6tp6DHPW4SthA6FCswqQ=; b=EcxERQMkAsaiwhZS
	bmyQVEkggkEbhTDL4OW6CNkJT4hyRwNo0LDE2qPLLAsqC/NDsjNCMXdYswQy6yd0
	cVradAsO3fjWl2FA5WBJXwPNmVRdgc7J1vffTc6bzntvQsQCLx9GFJ1ynvvvcLK/
	lEbsGjY/l8u0gQG9Bjv2MnExaWYRKrDIvcgfbiULRVvUAgqD/LiT7x4Qx0Lut2ao
	gywhrBH+yYX8Gv2cu1itspmN6BLO6vOD8AXU4KooB0eCie94H/U/jR7/PAfGFXVl
	uGVRN6xOkUa0ogRWLNenMATtV4KO6nQ8YTRXKXngVPjERhJqMBkSpYEwd7mI+wfL
	Nusn4w==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frp68r1tn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 06:23:36 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cf6acd760cso7267225ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 23:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785479016; x=1786083816; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bVXFujmtpSg/DPMRsHV+0ro6tp6DHPW4SthA6FCswqQ=;
        b=D46+z9NOYO0JOx4H1QVXUHXqDTGUdRoRyq7jV0S9GVdpaHj3VCsOtdtTZP4PMaMebX
         9zqsVs1Tj3xX2oZnkURFKDeOBTGEV9qzrc2jeJvR3H+KVRij7DI0cLiv24PN/x0bNzcJ
         5DfM+mol1B4yGCd1hCGO+Lg6Pr+pXYmuQYNXefdqxcnqGhCANWU/G3NOgHDC5D7EhqvT
         JXLEPCDqr1s+6+UHELJBFl6QQCeXvGUu7+gLfP5QEYcqhrc54KZLAh5ZpUys6kDz3Bg+
         U4GeUsybst2MvAveieIirPBhBoB51ZB0WEtEa8DTjwyZ180WD0gDbp2UTRM76rr5dwXj
         HB7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785479016; x=1786083816;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bVXFujmtpSg/DPMRsHV+0ro6tp6DHPW4SthA6FCswqQ=;
        b=rLAq9nMW18H8pqM/hk7uRiU/YhTXP1+l32fioFKOlO0XzwLLDbW/hyRnDz8b+HsRR9
         lzkM+zp06GzUccDcVXR58PWuo8eUvrLBV16bt4eHPFz4oNzEbyQYu8xEQ1/sh90tSG24
         B+hJjIGyUPvFReajkwT1Kf+ha37Kz5UOlWBfh23KqDbTqx8tmonrbmDgJivE4jXU9zX3
         2Dt4HdRIyrJJzEMB5wsl7QxB0RzFyeVuEVEeCinw5ap3NhO4JRMaG06KNs8zzQoG8sRa
         x/LlJhQQqqIaUAXgFEIVqY1Jkl9YKgn0BtCxdLW35Sn2baetbNXItysbILx7Nojqukgw
         JEWw==
X-Gm-Message-State: AOJu0Yx5ApVRkq60fWNyeIiS03Zb3x6t9hEXcxC+1QuDryrW34R8y/3M
	mQh5yahP/U9uzwLvaY4EQsZDyKgiv5nSndMtD0aPFXyOKaWAGe2LdYFoxOXgNn2NsJN3wc0XMuF
	z5UTMpxLIuRD3mBsCPqktuS8USqBkIcrvhrVcq4R9SupD3uSW5yXCJW1soCXM1V1UFYoarA==
X-Gm-Gg: AR+sD12g/SwjXZIH9QUUjNtqEwVEDOv1hlsdiTwsCDYgxuBh+4gRYrJqkJh5Acb1oj0
	iLUrQC4CgBYxzErvroRpt/7Zl6pZ7mGvVj1evkdFiEwQC/zRrAHHvRQJhvsEKdr9RQnBtqr5RPM
	Ca5Oytnx+anRhKPs5AKWLjg2uG3uKasm/uGJvu8+0QnLZW2gBWJF2rHi6EciCtK5y9mx6PSd2d+
	LyPhmG+bQUtEW38w1x6pV7NoExuZR1O2w2RDjlo36ge1fd0e8JKY9OnKy/YhynZribBjbjU8lrh
	aliCwV0qehp607a00BJFSNctPWxWr1pH/virb1/mORqSZR85tBWfJLyNXB/ewEiwSMSulol/Xv6
	WZTjcpuYo6NimJQryaKSFIeY9Yel9mVn5
X-Received: by 2002:a17:90b:568d:b0:38e:7aa3:df25 with SMTP id 98e67ed59e1d1-38fb149f6b4mr762946a91.43.1785479016192;
        Thu, 30 Jul 2026 23:23:36 -0700 (PDT)
X-Received: by 2002:a17:90b:568d:b0:38e:7aa3:df25 with SMTP id 98e67ed59e1d1-38fb149f6b4mr762928a91.43.1785479015664;
        Thu, 30 Jul 2026 23:23:35 -0700 (PDT)
Received: from [10.204.116.224] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e5c7sm2115494eec.5.2026.07.30.23.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 23:23:35 -0700 (PDT)
Message-ID: <4d9252fc-fe64-4b34-988f-5280f41dce10@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:53:32 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: cfg80211: fix regulatory.db async
 firmware request blocking __usermodehelper_disable()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260629063159.3288957-1-kavita.kavita@oss.qualcomm.com>
 <8857cc85-ab3d-44de-8ddc-cb9a4c22709b@oss.qualcomm.com>
 <4ea5025bc19f0ec89a42427aadb45e943884400e.camel@sipsolutions.net>
Content-Language: en-US
From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
In-Reply-To: <4ea5025bc19f0ec89a42427aadb45e943884400e.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA0MiBTYWx0ZWRfX58bOxIZeMJMS
 WlBz+w9eZegeZa0lB160AwRCa7RWXskn5CMKZHw/JSeQBxOpDO7DYicnqUrp7WoTqB7BuyF+lQI
 YhxU9i3LSPmRPZm92TKbsN3iGpTevmo=
X-Authority-Analysis: v=2.4 cv=fojsol4f c=1 sm=1 tr=0 ts=6a6c3f68 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Vybox7iHBPBuRZm1_VQA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: AUO944OIxpJZcrcJ13OPk8HYYLP7K_Bd
X-Proofpoint-ORIG-GUID: AUO944OIxpJZcrcJ13OPk8HYYLP7K_Bd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA0MiBTYWx0ZWRfX3qJnC9ZjJQUr
 9jYbqDtUL6einZZ8Rnu0Ab/1JBAcQTcBLLDv5y67+B7+SkJIPz00QGbem+/KdY7behAWdiBRtoJ
 OF35/mPMXPkSh39PFy1t2+AqzK3+ZziO9eBzLxFRtW50Oty08wdjzSSfHYforh6a83sg6n0cCjE
 YH8cwDW5HyI563QFiCv08rFCkBEM+raXbDO1bNUQqT2b25pvDp9A1M1Fo+1EdInxh8hNK6bWpR3
 KJqwyn6/CJJJioy3FF5sg7wWrSqJ3eBCuaU6w7Rw2ixrB627SN1EokdEvP7yuGFNM1SGfCjhxiX
 jCEaOcjhfgZxBFtg+YQlEBRlCJR6ygHQ/oZQimgI7XokExenWmgARJb14ppaurTO2oBmPZQcxtR
 l8iDozxFZ4P9ChjHrBF7zPDHdduOnGWuCPyip35Xz95vPuvEV7NK9qbdJ1Mc+b5tqM7DBANfIXG
 SqxDpXyEdXQjGR8I//w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310042



On 7/22/2026 3:35 AM, Johannes Berg wrote:
> On Mon, 2026-07-20 at 10:26 +0530, Kavita Kavita wrote:
>> Gentle Reminder!!
> 
> How many exclamation marks make it non-gentle ;-)
> 
> I really cannot convince myself that this patch makes sense any sense at
> all. If there's a problem between request_firmware() and
> __usermodehelper_disable(), why would we fix it in *wireless*??



Both request_firmware() and __usermodehelper_disable() are behaving correctly.
The delay occurs because the userspace firmware-loading path waits for "regulatory.db",
which is not present on the system. While making "regulatory.db" available would avoid
the delay, we believe the underlying issue is that it is being loaded unconditionally
even when it is not required.


For self-managed drivers, regulatory information comes directly from the driver/firmware,
so there is no need to load "regulatory.db" at all. To avoid this unnecessary dependency
and overhead, we moved the loading logic into "wiphy_regulatory_register()", where the
driver type is known and "regulatory.db" loading can be skipped entirely for self-managed
drivers.



> 
> johannes

