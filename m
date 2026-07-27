Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C25836165E
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129990; cv=none; b=iBI4TXXSrnBlREuWeTPkIk17vkM8iWVASdcTbUw4jkV5d8Sqx/TLfx0+HUV7DXyD3y1J7AkpgooPKuFRFJ21uYsCct5mGymurgyfsy7cZWRDT1K3X+0IzGbzzSziwQkg+ygoJYCojM02XcWF8FjBmL37Z7qo+LHuq7UiiBmdhdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129990; c=relaxed/simple;
	bh=wBgpHqZZLtYcASnOzQ9MVCznEllJg/tb5twYsrG2hv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OmYo1J0zkraPhNwntvxmyn0uRHbMEA2rq3Y2gnzRO20IKbHMPcbQDbQhCqj/5IRo5+7u3JtZTwcxRlvxaXiCKMdIvp8GLAgOV9j7jagLdR2kehukIfyZ6aDFtP5C1Uhc8ZurLJmNXy7h4pGEcwEjepyCuxJrk22N0IP+BWwBhJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MltfTlHc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e85SwIf/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MltfTlHc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e85SwIf/"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1fwx32240252
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oNiOmlsCm+nfCb70/oElfZ8sq7jZl++puhIth6cHpd0=; b=MltfTlHcYHJxjrJG
	2z3+mEqlWOaNQTPDrzTImE7kZyEn88M2+PjnAxsjzvBdr6/lAxiBvHLIoUaWfRDF
	VDK09WqJwdhlrkW5qnG/osZCGlFD7n98JSLxQN1LA5ziy+rH3y75TRXxfvC89ZJi
	hTDeWWzW6nz1zem75xGIf80bnKC9VkvUQH1fOaZgt168TgBCpO5FLwtAnGakRA4N
	LIxX8ejVjDzlf/zylTwWNwzqqf4bOllgnQOTURAQ6ShEpg0w2PjY+fNX0pnc6+jE
	R+4GVq5MIj7CfF6cMzAGP7d6VznL80GFFu2+zu/k8hCrfZqKj0L3/drj0MoHj0MD
	PmWeNA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fnsxs0whf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:26:28 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so1749693a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785129987; x=1785734787; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oNiOmlsCm+nfCb70/oElfZ8sq7jZl++puhIth6cHpd0=;
        b=e85SwIf/mx8DOoL8R9Q4jtx/z4LRILfrBS49BNzH5RvSls1MllPItBYfU+Zikkkyb2
         44lLvZAjBP/kJZNF96eCv6dB2JhxaBtA0dxzga+1ZKQn28HyipGpxet9JTK3VwAvz6tC
         XXOdDmkDYlS7Egcz9iKp+mY5cejkTNLxuYFI1wVxytgFAXVLzk5bq+LmQl/9xd4X75Ec
         7pcQk5dMotl2Qlj7O30wb9aESz2to84CiC+x1gCCB0hkRO1fsrTHAWWrSbCJoIgbeoMb
         EIEQRPCCVgXlFqPOMA7vpSUoppNWOdlChKYYqahRa6ZqKS9IulVfLSEu4G250v0HHxwZ
         zhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785129987; x=1785734787;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oNiOmlsCm+nfCb70/oElfZ8sq7jZl++puhIth6cHpd0=;
        b=lhVYIERMt/riQSehMkboLgYz8r+JlrcM12Bu59jene107WbIb8bLQtBKiNk9RVbmhv
         sh624YR9eH8QcwMJhYvo9VNx2aCIlE+TCfHj4rdMAhyKPjKBq4/6gFMpwds6zBAeyg1E
         GeqFS7lCMCbAN2Xn0Wa3/PUsQWGNl12P6QlQ8JOPrem0z+FQEbzamqBhiAy8Bawztr1a
         G5Zm2PMPP09ExgBWw95ngihqeJGoSt8wIlvW5byHBEFinMXcbvrMGneT0Xn0p2PTnsAV
         LtQPVEmryDOiuXT7MvgTMgkMaYF4vW08SB8GthZnQBPjVH56qmBTL8qS0tNjbmVOT+Uu
         y7yg==
X-Gm-Message-State: AOJu0YxXwOlOVuRrgkvHRFUjFUaEQpSS5DvxQm2I+Hx0rIILHDobsC+r
	HiL91qHSqg/7LA7h3Kt1KgZAo1SjurafcKoDnz9IiwTgUW12V18/zqZ8HOO7hY1dOj5jrF3rIo4
	aa7jSLSQIwv/WVKRkon/DALqxz0LHZaC3Wd6IlLN9XDiWt6FFNy8/9xAXobXQnt1QOUguew==
X-Gm-Gg: AR+sD12DhPx7CkKTM7KY9BfBZEPHUyuiXLWnnTS+ZBjFQXBLc0iAcRxIdjnQVo20Hvc
	CNALHKBFyymZUYsoHYM//5rdZu+3/q38vSkwPUYI1ghkZQNVvQ4dd3x3OeLanozRpXxfC9AZ1iu
	ug7TBU7DuAu/w0Or1g0ZgL/PfbMWXxvw48sdnhLq4G7VHgiBZhqsy8dwIb86CG8Ibhs6MED4BkN
	p/+7qnCUSygKW4biekwyMPTNG4Nzk3WVvFuzuIWT6877Jppuqv/efaHf5tNETEn7FVB152++eTU
	wXIyuu9MnNPeNc2hhNpUap0swBTKewf01P3nGFdAwIrEkXPpVwdaBmRlyr9I2CWPrkK+m4e631O
	A/GCUwLerkCg27w76lpNoXqWJ/LEaK7TnXbdRWRy9
X-Received: by 2002:a05:6a20:db95:b0:3c3:a529:1e44 with SMTP id adf61e73a8af0-3c67df58a6cmr6360564637.57.1785129987345;
        Sun, 26 Jul 2026 22:26:27 -0700 (PDT)
X-Received: by 2002:a05:6a20:db95:b0:3c3:a529:1e44 with SMTP id adf61e73a8af0-3c67df58a6cmr6360550637.57.1785129986947;
        Sun, 26 Jul 2026 22:26:26 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc447f6bsm30949947eec.12.2026.07.26.22.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 22:26:26 -0700 (PDT)
Message-ID: <8825226f-91b2-4b7d-883c-7cc8e732a167@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 10:56:22 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: Cleanup ath12k_firmware_mode
 enumeration
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA1MCBTYWx0ZWRfX6xNdX+gJ2KeY
 qGo264ou+4p2FVT5c4sL1M78V0zECERP3pZiDCeLSXC/fEOV2MNOfaIy7C8/qWtRpGgBVL+Murn
 lL1q006y3NJNGkamf2VHIUrVkve/O5XxFChoVWxh9oG4zdVGu4DFlo0Ezq5yLKbc64uxfG4P0xB
 cj4H70X/11D66V9AL+QYVjEaPQ8JTmHvL2yRfwAMyT6EMxC9m8KbgvTfY9hC1lTUt20vRdPEdIh
 rZQ2nVwjBSUHV0XS5krNxC1ERLcGpJpmmnziQrGJKtxb1F0cR7avaQpBJ/TL/0LpjTLH17S6SQv
 mRpB2BJCuQTi1UifWjvQOd6NJmPVNwdowz6UAD0Fy39iOZrRx///D85BxIAP9t6twdv9Ymrqis5
 WnVkRvzStS7Q1hVdgsYqiqo6KzAkrTj8/rfxYGL5Ebadb1tpgkpVjwsY11KCe2pvJSB5FqNTvRr
 kF1pfuxy/oTwILkQOGQ==
X-Authority-Analysis: v=2.4 cv=EYr4hvmC c=1 sm=1 tr=0 ts=6a66ec04 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=G7SgPBRoAAAA:8 a=EUspDBNiAAAA:8 a=NlHsPbxmrbyDciBibFUA:9
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22 a=2rYB-OeQH5pmQqQB7sEg:22
X-Proofpoint-ORIG-GUID: aVwc1MW8uX26Exy5p9uCgDdU_qK_R-fH
X-Proofpoint-GUID: aVwc1MW8uX26Exy5p9uCgDdU_qK_R-fH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA1MCBTYWx0ZWRfX/ohN4dMczkWX
 rzj7x6HSZiCyWkHeBPMonJBFJpmata3Y1i1+DL8uJ2ZpteRL+pj4tAYXzbScZNIsbH8FCztjpLE
 aCmuw0blciN0CjqY0GtXZ9oHKoHS2f8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270050

On 7/25/2026 11:41 PM, Jeff Johnson wrote:
> This series inspired by [1] for ath11k, but takes a more comprehensive
> approach.
> 
> [1] https://lore.kernel.org/all/TYZPR01MB55561DF4543A0265B47A58CDC9C92@TYZPR01MB5556.apcprd01.prod.exchangelabs.com/
> 
> ---
> Jeff Johnson (2):
>        wifi: ath12k: move firmware_mode enum to qmi.h
>        wifi: ath12k: rename firmware_mode enum members to use QMI namespace
> 
>   drivers/net/wireless/ath/ath12k/core.c |  5 +++--
>   drivers/net/wireless/ath/ath12k/core.h | 10 +---------
>   drivers/net/wireless/ath/ath12k/mac.c  |  2 +-
>   drivers/net/wireless/ath/ath12k/pci.c  |  3 ++-
>   drivers/net/wireless/ath/ath12k/qmi.c  |  8 ++++----
>   drivers/net/wireless/ath/ath12k/qmi.h  | 14 ++++++++++++--
>   6 files changed, 23 insertions(+), 19 deletions(-)
> ---
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
> change-id: 20260717-consolidate-firmware_mode-93c215fdb29c
> 

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
