Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792730536;
	b=JKAYr5pHN9l6GAhfBYZmCVu//DVhsQtKSNUgiSJZL8CfZRPcxE2GfqQJjbARN6Xt6Lch
	 tfpdSLN1/A15WyyJoHByZyDbghTrw+xWM9jBmemHl0PXFr1/Y/zeYVcYBdLieVVPMAVmj
	 fR47VuZqsYWwVMMr5cdzsKLR36rnYghycHl59yUZQ+ROyISQlpA6eCT3YBtt0vMtp9hjV
	 93dlviYIjDaYxTAcydS0w8OUSYX3ydzOfovOAizpsiiEFkzGMVDEXfKg5vN4orn86DDln
	 pNwffnrgcndthuOGfPr+kilp+Kdymq7hQ4cnlnDBQlxUTj7g3iIlfElKNbX9qIThq1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792730536;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=lUCDU9lFfVuOMh+Kt/eYlre5SnQJD9k+JA/X7y4mPTw=;
	b=ud3mYtpbaTqa8FBWFP/wugTK5YLManUct+lrGmnGW1KcZqZVMhiz1E3QPEaKjPaP+pdf
	 9l2jWX4REklUF6B0VVQOMow2W9px9URrknAJI3zgMxQEbXpFxCl72BM/dZ9ovEUCDFOJA
	 XSzstaBPxYKkyu38xTCPNCf2oC7ddWLbenfBGonb8BB5jPIBzaWkWsIEW8zgUegNA+N3/
	 P39dpczTb3tbMA/EVWjgy2DvQI4hLCWp9AyhiGq5l1FlmWMinF8+aOyyHhIs9DvDd97MR
	 aLSCHGxU8mGXFo0oPb18ZZWTiei06CZfWISh5tpsPJJ8CsmVGnobbD5coZ9q332x/tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bmVNkx5h;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FLGYaryR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43E606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 04:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB43E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bmVNkx5h;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FLGYaryR
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1GM9L1320013
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 04:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lUCDU9lFfVuOMh+Kt/eYlre5SnQJD9k+JA/X7y4mPTw=; b=bmVNkx5ht5WdX0GO
	kS1R2BbLYVM3oerFlqW5Ikhz74kOpupOXPOXKOB6l/8Rl4NOa6L/vMtYO0p+sUBi
	D039qjgaGaTQ56DSLQE3BRT+0C7/yd7LhC8cfR/ABqUS05JHENnBJpV9AsGOFxxc
	b6T+FqF/EZIu0YPvvDLsPq/SExkfqc+ci/af7ef9Mo/WEhREb4zjhBR1HOGsSI9c
	dc9BFTF6ZobfYMo3KJtv3hdcsb1HzTcvWnYdDiYAXHzMaCjsbmEpdsHT1Rwsm9oW
	Pqi/iC9D1hH2LyNQa5F0MWjIJq+6CSPQQCpioj38OPbSb3LQS6LfHswp4bEbu8/1
	319mMg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hftyg940k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 04:42:14 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e8dd9b9743so5597035ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 21:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792730534; x=1793335334; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lUCDU9lFfVuOMh+Kt/eYlre5SnQJD9k+JA/X7y4mPTw=;
        b=FLGYaryRXykIiNMJSadKx05v4itqylhfmMOrTcBIyvVIsbYtPK5lb3UhkowA7U5hI8
         +qOq0I+7kxL3EUbW+sCrnY3zcuLQVzw3jEjhE2MF1AiHvttoDXCS03bN+2nl6oQe0EWr
         x0OisPFJsTZ4fWtbST/A77Ex18iHvSfB1AdXdp+rPKW2livrS/8MAoZdK2oEvaHgk95G
         oUW6OkiX2pBOCOYn4EMbuo6tY1QWroJE19ArPkNfvgjLMVvhSvJP80CG9qnqd30ACone
         DsvjzoW69lYcre5LeXOhnE+50T+F911Zn//0FXSvewD3LI6Qe6ZoW2qMdE7S8h9U1gQR
         +GRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792730534; x=1793335334;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lUCDU9lFfVuOMh+Kt/eYlre5SnQJD9k+JA/X7y4mPTw=;
        b=IM5w2ONmjhez9LiiNbq/fJi2gjMazOU/GYTwJHEKzv8jOwi62ceZUr1YKL1f+uzjfM
         Kv5Ft70/HiztxhZMgo1QMq6vpdStFUCrsBdn7BJaU6j5EPrZnTjse/Q41mVtkMCBnJ6H
         D3AHnbDQpSQQdDrp/GpuceTTjC6uHrvUY6gC6HNuoLbNYpfbclAeUwobgLNMIHS81UVE
         E2bDfYBbUBjgbDijHkN+WF7DqgXNniWiepQNROn1KdvlxoOK3zuCT8W97fX8oYiKEOtZ
         tSWcTHP4dJtWVTptY0+kfk2/99pcrUKc2bcGpGGWq81KOO8Gz1kFta6OObf6T4bLr8F4
         9KDg==
X-Forwarded-Encrypted: i=1; AKwUvByBUAH9fCAwHmbjHu7jHWxwEqrfPzEalL3BigTnCS5ySEWPw3kpBV9mukzu1+iogYcoAmrp/S+mQBV2dL6MQA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJPlunSz7NwdXG+zWcj+RRhAw716zijgmoPXg7P45hLrU+u0dL0
	NWNbTyS7y4B5P9pyIoox133X9LEkodzCQ3uOCb0kUidI78y6SY2jhC1pbjFEsZMLyD6lVmYWAKX
	FhS3ryDwmXvpwxWKUjD7DFAPU9YPuYJoMG1pHMcswBRvPJ9GPZcyiR7WGQ2yi6aFynVjnxg==
X-Gm-Gg: AYBFou1Z9ZlU/IeRAtEtD7s0yZsSCzg5W9y0ZaSfh4tMGCXEikavSIapoWIWKVEYhRm
	pcJ+PVNnVMjUWb5tX2ws8YDpGKknxGV7baIKcxDaTzqDniEXiYd5JKTCWa1FMlCM+FIm/g7zzeV
	CdOYD1PYTIIYPZnRyU5vCZnEF2m1IUwOG/OnNMpzjTZOWkvClgfhjIw70HhwCqwIes3vF4iAJNF
	d50yHZPSzRpBUvc+2XoeQveNzN04qoHmcsn0a0FV6IpjdpoKb+GQmTWrxrgioyVBzbz6TgTEEf/
	G+GPeA8zd4gHUUPOpwPXHtDd9Pujor1eKPTsGfT7fJbrMynHPJixhIkqdoVNWAo9nvbY+i+jizX
	etSERes5N7aWWAf26rnImvBfvWBcSWV0s3s+jlOiaaBZV/2bo//SF1M8jNbC8D9Sbr9c6mYnL
X-Received: by 2002:a17:903:1b48:b0:2e3:598:75b8 with SMTP id d9443c01a7336-2ea7cfb86e7mr10901195ad.27.1792730533660;
        Thu, 22 Oct 2026 21:42:13 -0700 (PDT)
X-Received: by 2002:a17:903:1b48:b0:2e3:598:75b8 with SMTP id d9443c01a7336-2ea7cfb86e7mr10901065ad.27.1792730533227;
        Thu, 22 Oct 2026 21:42:13 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b3bad94sm4880885ad.49.2026.10.22.21.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 21:42:12 -0700 (PDT)
Message-ID: <76d4ee42-c8da-485d-9623-6f65a19b0c58@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:42:08 +0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y> <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
 <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
 <atrJv0wgF20tmuDr@QCOM-aGQu4IUr3Y>
 <38fc5a6d-c019-43bb-98f6-ba6a667c64e1@oss.qualcomm.com>
 <atrYGgGWB_zQIrc1@QCOM-aGQu4IUr3Y>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atrYGgGWB_zQIrc1@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=cZpHPXDM c=1 sm=1 tr=0 ts=6adae5a6 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=0oYm2DgIxsn4U9MLWVAA:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAxOCBTYWx0ZWRfX3FZeOnXEaqQ6
 5ur8MDc3OU+qixF+n9HKdQSu2kTBeLglZO58csuwV8ufVY0QgCnNCGMP9SrHhrsq5ZR6pMuJcAV
 IzmsisLs4F371KHFCV7zBZlHdFaTNOU=
X-Proofpoint-GUID: AJbkIhFn4qSwXTZLIHuZCc8aAssip3me
X-Proofpoint-ORIG-GUID: AJbkIhFn4qSwXTZLIHuZCc8aAssip3me
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAxOCBTYWx0ZWRfX0rb8FIK7GjBR
 AR60Xu6FD3Vxpb6j39Mp6Jdimj9kMhf3jwH3yK4HRoIaU1iWQWlshUHhSO1Qtv/xdEOKAIQHL//
 23uztqHn/c9zuLQBQrAme7ZI357MDGfLSWuTDM4KjAeU2TJDzP2PvimbPJ1GAi1h9AVG6wZ+sPP
 qYjnrYR8rZqHjQ8Vea+mnqcvARmt/bbYrXZ42w4g/WpvK19M7rp4VMZJH0F7k0kXqqmhgrbcH4K
 X7sVPW02JxUVh/5ZovJBBPFzeAxxWtGaAHzMjhtlOjHjlA6Te/h4FpmYaBKZAYeH60MEmxlQVeX
 /m6vL7hmUOKMAIzBg9vGlTIb7NZUuUUJe4rHkaWTLy0XbyXHzxqTx8N8kqJENFNVJG0RxPeecuY
 U1LOArdQwfgcpI97n/vCetqF59Xth3wIhXrro+EaZMHzQo1QUgzvGLbPy1f5y70HS+pK7+7vyat
 /D/2Ms2nLEFlGsztxlQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230018



On 10/23/2026 11:44 AM, Shawn Guo wrote:
> + Jeff
> 
> On Fri, Oct 23, 2026 at 11:13:56AM +0800, Baochen Qiang wrote:
>>
>>
>> On 10/23/2026 10:43 AM, Shawn Guo wrote:
>>> On Fri, Oct 23, 2026 at 10:13:18AM +0800, Baochen Qiang wrote:
>>>> On 10/22/2026 9:44 PM, Shawn Guo wrote:
>>>
>>> [...]
>>>
>>>>> I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
>>>>> the ath tag (working). It lands on:
>>>>>
>>>>>   15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")
>>>>>
>>>>> The previous commit, 643f0bf93617, still has 4096 entries and is broken.
>>>>> 15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
>>>>> and works.
>>>>
>>>> thanks for sharing this. I can repro it using the 481 firmware once get 15f7603b69a8 reverted.
>>>
>>> Thanks for confirming!
>>>
>>>> so the rule here seems that rxdma_buf_ring_size must be at least twice as large as
>>>> DP_RX_MAC_BUF_RING_SIZE (I also tries four times large, it works). This rule looks
>>>> reasonable to me, since WCN7850 get twos HW MACs and its firmware setups rx_mac_buf ring
>>>> for each, and each ring fills itself using the buffers all from the single RXDMA buffer ring.
>>>>
>>>> maybe I should submit a patch mandate this rule.
>>>
>>> I'm more concerned about how we would fix the regression for 7.3.x stable
>>> kernel.
>>
>> we can try to ask stable team to backport 15f7603b69a8 ?
> 
> Ok, I can do the backport after the commit lands mainline, assuming it's
> part of Jeff's PR for 7.4 merge window.
> 
> Shawn

Thank you Shawn!

