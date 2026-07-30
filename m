Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A60C364959
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785380991; cv=none; b=Zs+0utrg+DYcBjpCO2n8EShyR3wuZr5Tyi9sbtcsyuVXvmDmsQ8K87GsanJyXDIuPkQ/4bnvdPxq1jMPSCyLa4IA6QO2O/xLm1IHLaDr/i9WoGXZDpY0XN5zQAC7Pza3T+efpMDwA+LMdu4tMP2Z762Cf2dC73iTN5kCOGh/a1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785380991; c=relaxed/simple;
	bh=Rjs3c9/MFhifE9OwnKoOMraGkadNRj293DxVRe+yTsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkZJw16SUN9oXvHFoHqYaSEiwiBqGWVpfJJOVRFPr6mhSxZL4uVXWEx/4qUwn0SpI+WOquRBebywM6A4kDjWmItUSnIs8QRS70LBYTKsUtu0jqdgQ/3HIk/ilXkOrdE1bF0C5M9EC0gZDuqq/PScmXpiIb3SUdVMtNiosoAE2Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y0lIf2OT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BCrQuoPL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y0lIf2OT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BCrQuoPL"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U35opL3634848
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2m0/BtdRgV3NUxbDOKh7ojCOHm73mLPU2prtdT91/us=; b=Y0lIf2OTDnZMafJd
	winP9FCSBPirWY/GumfPqMxeNgNledpAL0rdzHZkrN5VHHrEBl944YPTWtuH26Gy
	fSJlZMlJ+OFdtqR7CeTRLM49JBzpt5WZYzOISLQA2sFJTIF7vIcP0cZuEk2am7ed
	IKom/IqAi4ORbKgoEZx+Jn0aZEVTXATSetmT+6cVROdIwloRnRc3muYdhsddu/Yz
	RtyFRv2Tm6i5u4j+IjbFvI2W3IHMyWdcCLurs+wnMNosJPyoCGAzOq3eY8Zt5AAg
	obhnjTRd17IPYrUVs69SR11qyvcj4S42+Ds6cLoC2JjYHMrHku5dMNzpVINdEWVf
	ukSvNw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqxde80ff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:09:47 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc86a9ef97so33697395ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785380986; x=1785985786; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2m0/BtdRgV3NUxbDOKh7ojCOHm73mLPU2prtdT91/us=;
        b=BCrQuoPLqQhzAebZIVC6SSF3VSkzHL9DEVlcz34G+jOkmIbusPC/28ZFTy0Rz98iqu
         ebDRUfjiQMLbLUuPhFnufrGbt8teCSi2TYinlICfyCe47Js2MpWx/n72UFEN66ejSwgA
         klU9IPRhI/+ul3g6hzJbyvzeMe4W7Td9QOVPtgRjAAG/sb+VhpOHd2NS5rn83d5z26dF
         lX2SafKEPzk4he6W+30V5h7/bGXeVYL4b8tn4FA3SsZUCF9oq54+P+IpG/QB/5xrtVaf
         XkjdwzR4WyrYVL6TGi8LMlU3R04JsPdPh1tLUYV8Zcz8uaDl9Pgx5lT+c7hACSpoB51f
         HQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785380986; x=1785985786;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2m0/BtdRgV3NUxbDOKh7ojCOHm73mLPU2prtdT91/us=;
        b=fjpVwWW4XgqGuF6RMyZBzX8PBHK/N6qM6wnvCVFxM7WspkG/I4VLXsLj/TuGZpRkAw
         46W8RdScaUaour11eOipcqMU8LjaM29YaPb47/ipok4ZviUrHTV7Z4SOLqKHoDwKPFcK
         c4wIyWUS0V2mSdAmWMKcMY91NY8Ix2UH9Z3KOeTqcC2N4W5kp93mRbyO8V4FmjzpXE2I
         4pkVlI54VgNTBmWUQmGhLvU6Li1teZEjDtC50/El3MQesr+IxBVJZt0r+M/pMXbkgZuF
         l+WU40A4/+1IzqeDDckJ1JYUfLkTIJq4yH7ytmR2iW6xqX06x6NILyggvVLtj+2KbEzI
         hCzg==
X-Forwarded-Encrypted: i=1; AHgh+RpZDF7/wOJtb4ZWZZ+SGLE2Cmb41/LcI+b9bhQYbzDek2q8rWUCAwrpbtuj5JdQRm2GpOrMV8BEPB9S1D7ymg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJhKAAQr4+OexLppQHw7VxwvuVLm7uBAilgtXTXF4qIgQ6aplx
	LrDwSkW01/n9mpgSaborn0+TIuhhx59G1wq29OLN8Z88mtsMDzB+De80SfhXhfbj88SZtkpKQ59
	yUYqTszYP0maO1sLZQ2i0hDttQjS0GOQ+FjRCHlZys6t53POjAZAHU53olWuJ/VsLKpEDiA==
X-Gm-Gg: AR+sD11RYpZkdBybpzIAc3R5vlhqrcdnwStE7Cb8eXvfK0w6aC8TbBCwdZ2hiCAfsqO
	f0Thz07twytY4+nbB84M/3kbiVh/rQWMZ2j/jOb7r/XtywYy4r2WyZiOlE62otKz3E03zzCmlIZ
	2cgnPOL6n5cfI4Dxl6tWfOWypBSH4R/YeISBbmXAFsj9Lezk9VKFo+bASJ+3LkDOvWEsQ6ajn5T
	ISUqF0jmFVeU1MdiNMv6NtA6fYMnnyPDIFYe2Irsv0UG2oZh93bBbyTuScaV18N3NROE2TRZkyU
	9LYSwXeFsXFgiYZ9UMq1GAW7Q9iVm0N5yiFz6p8JkWbFmllgYoxIz+718A3jEv4WbyQjGlQUErr
	AgVlrFxasZrYDeBhsNhRyVNXYg0GBfOLdhS9ctHDge2x3lSA3oC/qcC2mMESc3hBm6FaAgIM=
X-Received: by 2002:a17:902:cf03:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d035b8914cmr9095845ad.10.1785380986086;
        Wed, 29 Jul 2026 20:09:46 -0700 (PDT)
X-Received: by 2002:a17:902:cf03:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d035b8914cmr9095655ad.10.1785380985658;
        Wed, 29 Jul 2026 20:09:45 -0700 (PDT)
Received: from [10.133.33.58] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a16987sm18779785ad.16.2026.07.29.20.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 20:09:45 -0700 (PDT)
Message-ID: <f04d4839-c3a8-47b3-8ac0-00ded3ec2905@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 11:09:41 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current 0/3] wifi: ath11k: fix QRTR readiness related
 WLAN initialization failures
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
 <ce9e9251-8b92-44bc-9807-a527524d3415@oss.qualcomm.com>
Content-Language: en-US
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
In-Reply-To: <ce9e9251-8b92-44bc-9807-a527524d3415@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GcInWwXL c=1 sm=1 tr=0 ts=6a6ac07b cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=Op1iSC8d4qv81Z_IT8AA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfX2lULQeISxzDu
 OKRIvChrWwNpeFO+29PkNG4rAHzwsneme6KN3eToxiYc11k8fLIYuHH6eaaNqEB6EdupI7teUxN
 jILidoOx/3QpEoE/w7QBSdG0wIsSeAs=
X-Proofpoint-GUID: O16rKfeuUCie_rvKIfCtBIaZTWj7_udP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfX6qEdkbkdelFN
 ahNqsRvUCwvaiWIx8jp8xcGiKCcIKkYXSmc+0/2xvzhitJfCTcwkH9JiCIBV/np0h/QKtHlI19z
 PPbF3Gob5UuehRs595gMBZEO+W0gIrLzHnHxJrl0WehySn837zNsPuIP6lb0YSEobq/yLxSGvet
 0VTU2ioJLfsB9mLvH4zfyk4VGx1kZ+p3Kdp0YBul1gCT4xgqpcjZEaAQWE6TjFZW5FtTEq6kWuI
 z33bWkwu1laemM+MCqqzGmZhR6n0sXMEZgxRVOdwoZmn04ho7M3NjNV+uTABOTI7hnl7qfbhv/n
 b8Zrwcsi5sM/tBpC5U1EyNmd19qpuZ3HtA/wEckjomfXOSgQR8aw0kXNxaQGWBgGIFtshyFuoEV
 bIIYnto/83Wcsxv4j1oY/S+6nE3+jrpENuKlbT2vx8uRVE0w/sQVqwLu/HUPAu+l3vsAGNpv4J0
 jvnVinpauUgmiFtHcWg==
X-Proofpoint-ORIG-GUID: O16rKfeuUCie_rvKIfCtBIaZTWj7_udP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300018



On 7/30/2026 9:53 AM, Baochen Qiang wrote:
> 
> this is ath11k patchset but you are sending it to ath12k list.

Will resend, thanks.

