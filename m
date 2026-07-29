Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEA2311958
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 03:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297457; cv=none; b=j1dcNGoZ5dJ5dEk/8SSHIhQIYAlpFVZ1rnWrKfAbD8K5dAFAOnIgUE1YK196695+kMqieoSdiIkEgiIQb5bqEhrTvx2aNPXYgkdPkV1txC4B3dFUTbmkYIbNH9XfsJQhYmCyBywWEphSSH4A66o1Z8/2hC8A3R0VW6oZW29zXyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297457; c=relaxed/simple;
	bh=BapkDcdUScFQvM8zm+4ymhD5sz6HuXo+73G+30X2Kuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IuDFCx3nt3WF9KUq5akRdkIEVtbcVeY1YqKSBYPQRB9udx2jTWkt2O8TUfUg8aGmgzot726/nUxtUV9hyLAFVHNUIqOq1T1nqr5FKBdN8xp4kTW1j3lpg1CR42s0FNhnIE0JmSS0mhcsltkuUhzhwq/EkHOrg+ml+IWlKeQwcyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q+EV4mdm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J+c3TUTF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q+EV4mdm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J+c3TUTF"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T1I524322359
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 03:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4xLplXp06MskGJnYJTS+C/PUBSsiZL82WCkaiM9odTA=; b=Q+EV4mdmyLYlcrkA
	XjPTyD20Xx0agRpKXjikjErnK+COidStfjXta+OdPbUvkDFdVIcCZLn9YWBdKSTT
	vIKzAsCSByPCJMYchypqeBajBmRb66uYCWiGvEds/RdgjurLsEazdYXDlJIihYER
	jwLn/7O7JEko+bkZw10y/080TjztYnnrOxo6/aYnMsJoE/CgiWR26atwNVjcTozv
	cZGSM1RgJDvDRtIWIamc+haRY1NLnUIsviKS8HpokoHb7KboQ3pivn7ZcX2/nCDS
	ofnSaXTmKLm1m3zi1apFtKq6oLo26Fh9Cmm0Q5kHe3uZuQFx+iZIJQD7utBMu2Nu
	GOFEcQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpyuktc9n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 03:57:35 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e667368f0so857261a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 20:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785297454; x=1785902254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4xLplXp06MskGJnYJTS+C/PUBSsiZL82WCkaiM9odTA=;
        b=J+c3TUTFSvoe+W+yGsBJYgn0SQH6E6M+GmfBdMfeiQE/Hosrlui2l19L7rcYJptdxw
         O2VEwe9lhlGHvQ7RF5n5RkwN2p4jgjWQjyf/+vNPB83tqrRVLmxCkMgB6Cg5UfW2DhY0
         oB5JzlzP27u8It54U8agMWG6MabwfTWzugcbcXdUiKwYqVXlJHPDyKnsVZY0lZT5r+6v
         AzBTOtGbb2BFTusUMKHL+om9gKLk45x4WmF5P4/1b3n5AyZPMTAd2Wwv/jNSIUSPt13k
         SkVw8fbR6nVWCpPwwt8TTHwWhWh1d5rbgm1uDfCqTLvScHH4u/3JNrb8dpAGvq3YYARg
         pxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785297454; x=1785902254;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4xLplXp06MskGJnYJTS+C/PUBSsiZL82WCkaiM9odTA=;
        b=qUpwamGhC+mCDk+nm9FtNiJ8aSxZuoVAe/Pa/TMSYZhSkBMqzHuwLVomkEhlsWye4P
         Qu0YQEA7HmjwJWZIEaIfMoVTFx63MG23xRdTQ9kF5Fdblo7JgGnuRlmfIU2cqY7YoBDo
         6r5PrejrldVQr+AquQsizh2l6tmjhU6RDEiWrs99Sw6W0yqI2zelsXUu11kJ3mtxIZM3
         HIYrKEM4qTfZ8TwKpUBme6c4UJmX++64nb4B0A0rEoiAhlOUMkk/BVZjjZwq/4EBqDC4
         RrnfyHhIDlX7x0uTtRYj9KOwlw/bC+G1zkfM2YZp/h4hMOH3ccPUxLhMZ4kFQsZFxTmA
         vxuw==
X-Forwarded-Encrypted: i=1; AHgh+RolbD62XQs23TjL0luJ+M6Dhsj4iCcaszwakK1Tj4XX0Yj/3g1w5PVjSxqeRe5LT9hqRCY8c+mqm6sM863EwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd7yZ2Rhq56Op1gjPllVP2nPhWyCopJjp8stnef/GZdPoHBcUn
	bXf5tpRn4AvdqY9UioxQ3sY+fuayGGw4rSKvPmnvQykcJN6TCHS3A2LNjcpnbbPprItgbqRvhgj
	t264rScD02Bd5NJz1lDsInE7024laMT7+D49juCkArPDBWDcWylcAwV8i0t4S/mdeJcDI2w==
X-Gm-Gg: AR+sD10hhcjIZN3LNcNlyA9W0P7HJVKhvfAKZhakg6p2B9KD6LxaLeQQj6Y45bM9sr+
	XV/qRlmXv5VHSogiMEdOxVxHHTRjTrPV4v/bwMklKM52pvRIhxIiVZ7NZgnGtbxKT/mQPBpmjJ2
	9u1RWw7k2IsIxxBLLbek/KntCvEdXNC9vcgiziU2Vi5GKDkj2MpbLiK2hKF/j/AQ+7iirUirq/Y
	1X19n1GRl9B4ko+yb+xIE4fB0qS9inj5sxYce+jnc3Low0yjdd28N6G+085YFv/dUgFjQd/DMQG
	n/XCplsPnljjxQ5F9rhuSMUCp0uOLAdpaUj4djfV7jsxD/FOpT/9xr59W4lYKRSTbTubbKBZc5M
	wm2/G/ZwcxtaajvKxR70beI6JgAVm23cvZNhWG2oE
X-Received: by 2002:a17:90b:3dc3:b0:38e:6bd7:fbbf with SMTP id 98e67ed59e1d1-38f6a46023amr5079604a91.20.1785297454061;
        Tue, 28 Jul 2026 20:57:34 -0700 (PDT)
X-Received: by 2002:a17:90b:3dc3:b0:38e:6bd7:fbbf with SMTP id 98e67ed59e1d1-38f6a46023amr5079582a91.20.1785297453633;
        Tue, 28 Jul 2026 20:57:33 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b67063sm4983518eec.9.2026.07.28.20.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 20:57:33 -0700 (PDT)
Message-ID: <6309c972-0d3e-4b13-a65a-480aa4736095@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 09:27:28 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath: fix stride mismatch in
 mac_phy_caps_parse
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=O/kJeh9W c=1 sm=1 tr=0 ts=6a697a2f cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=I08Pv1SOXqSCRlEE_s8A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: RW3wY1imcKa8Tz6sski4bNZZIZB1dO7M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyOSBTYWx0ZWRfXxx/Q+jWXmrX5
 gGCI6OFLouIiQgel1JJUu+grzkoFHGhL/BpypgcTj8qfdt9YvWqHbp//9BfzdyAuI2smdf+7QZT
 om72Ne2q/njSi1b2qv5NZPo8mXOtHh1I4Xz8zHLj762GWsi3d25DGrYtIb+BQo5mto/Ql67Be9N
 aaf5uLpfQY3E58//eoFNahQT+3xPGC8oj31l9jcCF6GtIGz76xltPnxYL1ieT1Dq/2fUSOH3KH0
 IQcmD/hJH9Za/tqb1rQ0adSCdO4ELzC+DEICUO8rgs1CKyfbkGyF66TD97gXWam0i56DhBY5lNi
 BFS/AhCXBnAofWcZMTRsjY4YYQPrPTxEJU/dUxynWoDmPC6WGMrywStpo9oDFNSqXplZlufnKwo
 pEmSLr//UETFysGLAqweGraS4xN3bJqhbeVaBbE2MhlNKr5gTKndpRFtXA0Y9dE9Y/fuvr54VcC
 QRoZcAPywIYZO/TjknQ==
X-Proofpoint-ORIG-GUID: RW3wY1imcKa8Tz6sski4bNZZIZB1dO7M
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyOSBTYWx0ZWRfXwvq4bJjwHTUd
 uYtTwuf39CXtrnKpe13QXXMio+LFo6oclvrbUpU4WN2tmEZs07ZmQxN+EjYzgXLTuO098o8yH13
 PNmPI1ArVSxFWYdqK7aYbt6mhvqqeVo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290029

On 7/29/2026 6:35 AM, Jeff Johnson wrote:
> Both ath11k and ath12k have the same issue.
> 
> ---
> Jeff Johnson (2):
>        wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
>        wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
> 
>   drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
>   drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
>   2 files changed, 10 insertions(+), 6 deletions(-)
> ---
> base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
> change-id: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072
> 
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
