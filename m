Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8722F8E8B
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788919296; cv=none; b=g02fvA35I8X8pRwtub41PocTboLe0DD6f2SkETaY1AC/5VB0bjFGSxDR52+JnUl5QV6fmKRwZ/5OUI3JEgOmOijOMUJjKDFbWRtCCQogYt64a8JyHWov8nLnm2fyER2dUL9toRKQGbgDb+oGvXTeGfOwlxI4CdP5Oc6OkgfotQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788919296; c=relaxed/simple;
	bh=UjQrVj/X6EzTczNB1Cv438XqdsQBHX43AjP5mF5UDAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YRYdieFGZUgppoIYpvpvRPYsZkvEljdc44ms7X+SpjEzlJUsSO6uHtrDL8CF6WD+mQ4TslyDjo/V4iCbOhaUMVFBESvFKYHEjAERp7hxMH5qDYBzcb8TceZ/whznBoxrIkbVD1GlOyh7N9l5FphZ5IAK0/O1zKcCsmr+QZqfjbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MKunbbv4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J+uYem4X; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MKunbbv4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J+uYem4X"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688MgEZO045456
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 02:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HZSDTdETZl73boqQuQK6aw9fkyLRGToqtXSvqysrG4M=; b=MKunbbv4L7NAs9RA
	0EyYZE7lY8VIHHhuXzHTuKCKdWmgxYqkpBov2uKSnbFqg0dsGMfNAv19cdoktYaX
	v+C2FjiSsXb3MrqL6FSjy3VbdW4dblIOKALEHSBp0s4kwe4cRAr9y00lt0Er2Yxs
	xruTuiGZ5MLugdjI/cHKH685eWQG95cLH8MZaE6OFQsvqkbVsPurFIprRANhtWnz
	flE1fXdwF3IsggpEhuWxUe7jH9T+rjA7B3LM2kk55sCLS41bjMxRI59PYK30UyMM
	xjsirEiB8sZJZs6EV4yAj/bNxDJa7qF2nZZcTn1isyqCLfhKhjawOza1oQjTPRjn
	VRw3SQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjqewhkhr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 02:01:33 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8663802b58fso2526657b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 19:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788919293; x=1789524093; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HZSDTdETZl73boqQuQK6aw9fkyLRGToqtXSvqysrG4M=;
        b=J+uYem4XfiOymTZEN6pw7sNus5skjCLFrQ+f01ChD5U74vwctJt72+mnNuk53v4+w2
         g86miKeKcJ/AfF+7Hgl/RSK1E6RBISeDEIkqnvKZVmAZqE2EUxiUHl3fR7Pxg49uuHAR
         d96xcasA3DEe6wINOLfW06Bab/ZIpltFSJXUyJyRq1Q/a6QrkPPw24KLMYQ7by7pMDQ2
         ZNmzBWyOOgSgxn//I2YJBSWStwiBdVy9qC1614vRF0bO2Els+X/xkXj9G+mIOp2k10yE
         5qRQWd7SJIKbLbvW9tpNiaTmwJABSWOV9u5h/QAUGLrzVbqy39opzz6hzKVCtMH7Ckag
         NFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788919293; x=1789524093;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HZSDTdETZl73boqQuQK6aw9fkyLRGToqtXSvqysrG4M=;
        b=nFdV3xdXtTJFz/t3f9xZtk0Y5FScbIfy4/McghH9xbVvX5qyEpfQ66vPlSZjRR9vPa
         6RhxDxoRrFrF8E056UZpVk0Rsrz+23KshLrgtqA/Q5yRTsu5P3JA/WfFoRfbbDSyiaLk
         ZnblhLsbOGT+XFME3HRfCIIPwpSwKwQUHwmQzb9BD1isvzE8r6u6uLM8uvw9d2G9i409
         XBlHhX3UteFwM/pbzSGrbHB3zZjzvk67bW09y5mvKYZK6NRig3uZ2PypSCHcGTJcnzP2
         liqkDxQP92wRWffrm2dU0a8RY1XZJQ2IdjiLK8kvFQAbqCySjNTn3qKb9BGleMJNkcFv
         Xbww==
X-Forwarded-Encrypted: i=1; AKwUvBwXfXm4JKRUsF1I4vNVxCdUHu0bw8F7cVAKekuCjPOROO1yXSqo839/yQIyVDwhuJi9UareB+RkUtuj2QsJ3Q==@vger.kernel.org
X-Gm-Message-State: AFuF++mJOMwecWV4GlzPwUOOIpgnUvdgCBsY9c0V2RyYngHqjgKzL0lK
	QiMERudkD3TMlMqzObyV9fhiUaOvoTrQ+5cPOQZVXy9fTc1HJoGUd/UiXA3vmvlzYUhS63plkAS
	wxQ4SXq5lWQd0Zw8lveHbKH6Tg80rpCvf9lOyrwK3US9qT2AXFITQOBGJTKAeXrHC/pPvqw==
X-Gm-Gg: AYBFou3XR364LZdxDYQJ+gF6fgW6U+RdVMttMczwHXZlzH45uku0nR1/IrTFLeh8NhC
	KWj9SIxi1Bk6HugjYA1f6qALfe4vHBGrmp285X5pZGwSZ/cvR3g57fjldjHc3vnT2pKGsexfR3H
	4hwQRhMbtvOfiwUZtHr3viKcbSf1Q+SZsAoztiUok8X4GLPumrls5hUMPRTpOWM3OfK3jjklawd
	H1kTslndzvoSniAsc3uCKc91QWvOSbie/5vNX+KH4ukHvjGVnxlbqWV2c/uNZzD7n/Bfnz51dhe
	mcwIWGqRWSfUFI/QZmDewXU2rNG3EnqEYpO8zOo0A7finSpa/+M/V6pOmqULakuBbf4KkErmYIO
	zb06aYkiotERzZIfSqwV2ODeK/CLYKpCtOAuSVjzxzvq1hz8TtEX6gPA=
X-Received: by 2002:a05:6a00:302a:b0:848:67ca:bfd with SMTP id d2e1a72fcca58-86168596eecmr53684037b3a.16.1788919292246;
        Tue, 08 Sep 2026 19:01:32 -0700 (PDT)
X-Received: by 2002:a05:6a00:302a:b0:848:67ca:bfd with SMTP id d2e1a72fcca58-86168596eecmr53683964b3a.16.1788919291597;
        Tue, 08 Sep 2026 19:01:31 -0700 (PDT)
Received: from [10.133.33.250] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152e2f1e0sm6181927b3a.36.2026.09.08.19.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 19:01:31 -0700 (PDT)
Message-ID: <e2701af9-a9ec-4851-9f78-a1bb6568f050@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 10:01:24 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: preserve PPDU state across monitor
 status buffers
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
 <CABkEBKYdFcUfMGj1pGmVYrdLQTO0eExq8Z+vMdjYGN+yjQ2uFg@mail.gmail.com>
 <e7a1a2da-bcd9-4510-8c26-c049064d68eb@oss.qualcomm.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <e7a1a2da-bcd9-4510-8c26-c049064d68eb@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=cpirVV4i c=1 sm=1 tr=0 ts=6aa0bdfd cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=CwnV7Y8CetrsFUvn-6YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: fh9knZgX8atTeB0_nxmBdGSNRM_KAx5s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDAyMSBTYWx0ZWRfX7OC4tUfJVNS+
 j7c1HmIV0nvHClH/46/Ue6BEUrL+5tfJZfok30q002eCHjKfqU9W1aaw9UZfuIgJVq3v+2IIfuV
 oHqIOUJ9S/B3N9t0LuBLUugA1lK6s4feRJh6mMcslBcyYUjuFdc59+4rRqe7Wq0IOk+any/llyH
 K1MFcbmo2DbqkVj5kuSI1t+j8K6h0a5D8LO+H5CsxeE8vI1cbMo9dGsIvsuIBVZcrSYWM7td1Cf
 PKFNzQ3n2GuCzBanXNfkeqS0njTEtEFxzIpGZ0Kdm+3JlE07L5T4WlFl1nvTGXnztac8sHg6yDP
 SDJw585RtW6m3EwygZd7i0yLZG7x3D1nVQood6h/5X5bPZZSY7bDXDi9qAfT3wKadkarSB0JDuv
 jls8dJxSiTyYB4y6ytO7Kw4I6A4G/V76TjJl40Mr4y6rEVYy7fKzD8ja73QHagelcfswq0eL5gb
 jnfaDvG6NdvvzGXqQiA==
X-Proofpoint-ORIG-GUID: fh9knZgX8atTeB0_nxmBdGSNRM_KAx5s
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDAyMSBTYWx0ZWRfX913e+Da/EMvI
 88yu6BWcjVXyY0kQVmsTTFfg/i5x2HE885JkVQHXINNZbwTrKCFTgroeIAirJ102HkQ7pTzyg9l
 1YZfwBMWVHM/EmnKPpKp72J0+pW49rE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 phishscore=0 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090021



On 9/9/2026 6:07 AM, Jeff Johnson wrote:
> On 8/30/2026 10:53 PM, Tamizh Raja wrote:
>> On Fri, Aug 28, 2026 at 12:26 PM Kang Yang <kang.yang@oss.qualcomm.com> wrote:
>>> -               if (ar->monitor_started &&
>>> -                   pmon->mon_ppdu_status == DP_PPDU_STATUS_START &&
>>> -                   hal_status == HAL_TLV_STATUS_PPDU_DONE) {
>>> -                       rx_mon_stats->status_ppdu_done++;
>>> -                       pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
>>> -                       ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id, *budget, napi);
>>> -                       pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
>>> +               if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
>> Consider HAL_RX_MON_STATUS_PPDU_DONE instead of
>> HAL_TLV_STATUS_PPDU_DONE to match the declared return type of
>> ath12k_wifi7_dp_mon_parse_rx_dest().
>> This is a preexisting inconsistency, but it is good to clean it up
> 
> Let's clean this up with a separate patch


Yeah, will raise a new patch for this.

