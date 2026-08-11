Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8B23B0581
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 06:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431160; cv=none; b=VukLVIbvXeZ5yoQr6+P76pmurqmAZ4giFVMv++1kMr97tQKwMOSzAS0TpKeuPzRT+1aL9RpKekFhatrdJqWMrFcPsIlf0tHxAfbB9cLHEBjKVqAnL7ztFUyRdNCcPUVEZWsJ90OXWP0P517z0MetYvJKarYP1WHfUsRSbgNIa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431160; c=relaxed/simple;
	bh=75/igkwYEPRN3eAtQ9lvDLwg53W8seA07GKnyf+TRuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mfAaZOIRnGDsF0StUodeo46j5NCwk7wh0OrkitdqPKoA4H1peIUUs4VjwQQ5/Bhi7DN+NGulkEMAyi2AO4ipuj6D6ONcliVDB93hsPJAYGOzDsIpzcXwIE9NI3rPKogjhaZGQ6A8aQ761hoc2KBvI3QJiAdd2iZknBh2botRotM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KsvkSiOv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kQPB9HwW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KsvkSiOv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kQPB9HwW"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AMq0dO3047857
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 06:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yx478Qbch/yLjgvZK04UJFjXCxOjVm027z1gNvRhMz0=; b=KsvkSiOvYJq46dfu
	ttX/BOWyEhMUDuyjh3zOiJz7ZWqfB6TqWGllb6aS+PCNHCmXPSghIIGOy9fm40DK
	1pCMg216PtdtCRPyvk3da3GRr5zYMczLHWfQZELQ3lGPamcl3Tq5PwGeOWItnpe+
	jhEgmmUVpeu00siSCNAW6rjTeTWyfjOSqSv8KLKN7lxoQxwh3dVzKXGTFPm8kC2b
	LyxPsorq3cOC6WFdGgwIyrWwvIZTsn+pWvgI0PfGv1Jg+Ci79oaqdtlrjWEO0cHo
	9aSAsGjWYN6iug6kvbpRLInk3DSUkP4oXsz3l4V2hNEbzJ6cBCa7i8Yz+2vJJR2v
	l3KKTw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyjk22u58-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 06:52:37 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so4563502a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 23:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786431157; x=1787035957; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yx478Qbch/yLjgvZK04UJFjXCxOjVm027z1gNvRhMz0=;
        b=kQPB9HwW7TYcox53x8JZEAxdBtFc55spwUEhI0sXlvOhjJIeZYuWoYpFMT804g8cqL
         x8/FbXpBeJ10C6d07jlh+ytt/0p6JIetpaprQ5uoBlfGlYgMGH9F20fTvhi2OtRTBYCL
         F5Xqg3vPDUW4tUDEWC/Y9IIjtd8E0S5orkunuYla9U1lyqX4jSzH37nbIOy5o8I/ObGc
         Hk3jEKpqwSAZYdjJRr8na1LheYxPg7whGSnebzFkFKRwgk9GiZ4/zzjyd/Oku5ki/S8a
         W1SopWM1PY6OHowBz7BW7vtOYzb4M/2zcmYleNBDTIFB8AubGJTabYfg03mTXMpKB2AQ
         6SGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786431157; x=1787035957;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yx478Qbch/yLjgvZK04UJFjXCxOjVm027z1gNvRhMz0=;
        b=iQoIH7n0aT2tCeDYjhkBq7cy0dzMIJn1ssdifhO2Y03XkioQ/L7/JWQGBCt9f7m0cx
         MeNNPooOeYZA1n9Jwf3sSWfDpbdtel4Yl0+DuvSTz9I25r4oeLBB1omIA6C90EyPbjOi
         hSOlacJVarSByb+R2QEIAAGtrJKDDuUIGigeraTPi/amYz5ZROIgyHJnAe84ggTWayZe
         p8LI6OA1d5bnte0XFGdaIqyHH351aKNm+GZ384ZbRbA0C/lXVEMw99b5upNLQih23ysV
         zr6AD6pKidaaEd59dD3wnULwvwqJGJ+2lekV3veYqS6QD/OOEw/MfkVSQsOj7kHckUPB
         LhEw==
X-Forwarded-Encrypted: i=1; AHgh+Rqd1NPUJpPG1I6Y38h3Iz9G14wqk3SFsaCILXHXwb1FDMWumG6yA04MrnZ7FKov0GRM7Tuc8UacJ3jXNaCqOg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5DS9M6GjLM0qSy7+nPwjWq1/Sp0ZYiGbOMZJl2hOKsSBIHkii
	uGrjT54qgXHbraAzrQEWAVE9Mjx4w4GvvQoe49aU1FojmNpdL+bMaJDpbFXVr42VxbHSsS53qPa
	ULtlelyGMe9GQ5HuqnbXkM7nQJCrNSvLTtEguBue04fnqmk9oBwI3YBxQlDaLK/cFHsy2kg==
X-Gm-Gg: AR+sD12VC/VKvHnHsD5Kd4MoCzZiY/bf64uj4Q5x/eaaFfhdxmOA+H4BZmhx/O1EtT2
	OR+Bk4zvXDFqSGl4q/I+y9baKNgK8SPJ8oVAhORbJfDRAuyI9ND9+ViyodiTI1yqtRzDWwx/6UY
	sfQ6nOPB/nItoOKwY3btiSMJ0VyFzym5umDCuJ02SYATQ1m99GhXO121GDZZrVBq11Ivp+IXoGK
	vN/E9AUJFpSy7Ji7fz+4dxuXgjKvkTwV6MaYLH7Od58HoyQ+SrZq8h059dVAAUISKIUVwXqX2s0
	fAujjaWUk4WA4tPkEjJc0oVHy6yFHIeq3G6FtYJS0OXBUy7Kq5pDObJeLU/V1ofNqBLyqGXsx0F
	HZfm3RpEH7dvtVnZoubIAXUFq1Vt7CCtLdeggOZP3
X-Received: by 2002:a17:90b:3fc4:b0:38e:6d4c:14e6 with SMTP id 98e67ed59e1d1-392ec2fbc12mr1333812a91.3.1786431157389;
        Mon, 10 Aug 2026 23:52:37 -0700 (PDT)
X-Received: by 2002:a17:90b:3fc4:b0:38e:6d4c:14e6 with SMTP id 98e67ed59e1d1-392ec2fbc12mr1333783a91.3.1786431156948;
        Mon, 10 Aug 2026 23:52:36 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14120299595sm3320113c88.0.2026.08.10.23.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 23:52:36 -0700 (PDT)
Message-ID: <2a0d9e86-65d7-490b-aaa3-c89a1bdcd1b9@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 12:22:32 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2 0/3] wifi: ath11k: fix QRTR readiness
 related WLAN initialization failures
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA1NiBTYWx0ZWRfXxn8S9BdtqgYN
 U2AdFnz76KGzsg0vbrnGQWXKtUfnGe7Y3Wbbw9V+J+rvWmOpa+92WjJo5mJqDqXh3QMt2TiDFCC
 feXJuodQE+KDuH2p+S2VQRzE8MJOPbw=
X-Proofpoint-GUID: yfLgxcnVQAnLffCgYRmfYD1rnVlcXQ7S
X-Proofpoint-ORIG-GUID: yfLgxcnVQAnLffCgYRmfYD1rnVlcXQ7S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA1NiBTYWx0ZWRfX4KOppHSmEyO7
 jLgYpGh5bEiHmtoPRsevJub7C+TRJrn1y8sIGk5Th5PIzCAj14VVSc5N1JiZdr39o3GqCxUBjCf
 6+HgJVqDk19KxttrQP1sDyGXT0KYTSfqRmJT0TgdnYPAWYI/rlLFERux5F6uFUtCru60LHhwE7X
 8p5xbsuEYqfBVIaOtvs6y9jeik82CwxsIV/oD/JInVZP8uBpd4GtYtQohbo0LnSASyVXfk8zoxV
 3syCg5Kyj4Uo5W2Bw51Mw7fgRG/4GC6aiGWkuOkvXuarh7QEZ6WpXER395v6mijDoyxklHbkkND
 4I+HpeQE/GI23aeooCoyTEFe057u833+LufeNAS6x0HifKed8HcpLThaBqhfwqNnQyo/RLNyJUZ
 CujWBFzXijUq+4Q2z+syY+at+pGk+CUsuveVYMtK+mMc2AK7N7Ir2TxBZGRMqbhf/9ZJApkDyw9
 AjxlffYdSiCUUr8xvmQ==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=6a7ac6b6 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=TU5Yaf3rhOhou0YHztsA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110056

On 8/6/2026 3:43 PM, Miaoqing Pan wrote:
> On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
> during boot. If QMI messages never arrive, WLAN initialization can stall,
> leaving firmware running but no wireless interface created.
> 
> It also hardens the cleanup path to avoid crashes when deinitializing
> partially initialized devices after QMI setup failures.
> 
> ---
> v2: Replace the ATH11K_FLAG_QMI_FAIL guard with !ATH11K_FLAG_REGISTERED.
> ---
> Miaoqing Pan (3):
>    wifi: ath11k: fix sporadic WLAN initialization failures
>    wifi: ath11k: fix NULL dereference in ahb remove when QMI init
>      incomplete
>    wifi: ath11k: unregister PM notifier on QMI init failure path
> 
>   drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
>   drivers/net/wireless/ath/ath11k/ahb.c   | 7 +++++--
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 0ece44d394570806e97c8471a50dc9f584516ef6

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
