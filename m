Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C43E3F6C59
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 12:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374956; cv=none; b=MJgRdNKw4QhcbHA8pNALu8i2xK0lxrpTaOJUOKHeF0oIsFanCO3ooc3UyoCEc1i9RWVJhJ9nzERgrB/yRWpjMExm/Q7CmZeeDgQUSxiSgiWO9NXzPDkN6eIbTo9S1mfKPHhdINsmG646q6q3q3gJ5/qKZqQeb3p2lWJ7hgpoSsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374956; c=relaxed/simple;
	bh=96iZXdi+rkObGITqP2/UPHfHyVPqYPyD1uRhrlU/3aM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQlRxAY2pXvZsdG14fbGD1h2hONgzjJBPZYh4gGLJygGTUSwo5zQphiETl7JCnwgQRMBUVHEQrE/nGOyB8hjLPeOBYz8zqDd53OdB94Lw3zg9YCFMxtiAPnOKISOTWnVb024rx4j3CFgQNT2gnaBEHxyFLIwfjRfQ+Gd8QmhuPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f9xVHKxR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SmamYxin; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f9xVHKxR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SmamYxin"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BV9o62969960
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 12:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CcNNpl+F8yq8Irb/mTzVN0nAs7pU1mZxVhXa4uxL7eo=; b=f9xVHKxRDZ4BW8kV
	+gbcixFqpb9gPqrRjATq9I09BZYT5n85uXB7mMEknYT8icYstyj4q4VzoiI+n2OY
	VvV8RRKqqN3H2uRQ90PmErGeidECggoXSKRN7fgtl4/+8pTgiBeuUqej9Vtp5/YX
	+e+U1I//KQmfBQtSAljx9POlDn070rrbV+NY49NlUUn+ZtmtOjB9aVZpKBm48mC/
	lispCq1EhiWwz9Rtf8LYCe3x4IAzh9m336uQxkwyKgYClikQssb7dQxFwCu4JeE+
	/lKTHceWs5LAd6ghE2d8auRM4kz6h5PYwW0k6Hg5pZnkoTSn5P9oWDwQcIQAqPO/
	6s7rEw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c6u1ywm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 12:09:07 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e5cf051ca5so17801665ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 05:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791374946; x=1791979746; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CcNNpl+F8yq8Irb/mTzVN0nAs7pU1mZxVhXa4uxL7eo=;
        b=SmamYxinqT6REgIf5iZ3Vewh/ywTYEoEFN1xrJnJzNb2DZz6ZTtHiVX8YpGBS/DGZy
         pq5K8lHcqJRpkXRZKhD4T7Lqgj4PbTpzCh7ilDRBQP2xqpQ4LXzIca7UIHH6Fv4j6Ni4
         Pbp6DUuhe16oRbUJwCLpcz6g3qwYPvDAFhsTkau4JhuedmLbaf9BiDnaBf08y+BC8iBN
         f023a/F6XJr4Hf0ri2qscvggZkacE5bmnVgjFr1BHbXn6Gk6WqLZfQhou3elESERPPLa
         wuA7+8q06ZSyxPekWiM3bFgHEFwf8X3TVQsbySwJofg2jGptjFIB/2V6yoFstyaKEiPV
         d+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374946; x=1791979746;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CcNNpl+F8yq8Irb/mTzVN0nAs7pU1mZxVhXa4uxL7eo=;
        b=eifDEmOW7S8JPk5DjHXAfCjl+HMb3dIQiB4OshUX+B+Th0r+q6EogPnB5tgt3alVNK
         WFIvhlfZh+RB/e3uGbbX0iQGw2PEXiUSFqYKQxJ9bflh3kCicW8+aedWlaYN9rIXYbGU
         61I1qFj3tWgXqg9NAiHiMH1lzy25fHDRTVfRqiDdnpTfa6kLr00SZHaXaNCtSvK0qVUZ
         mWvNufvAEWJIelq4L0j7V94QRgMiTmQOy5w93lC4rIN8KkrV6Q06Bef17pbwm+lU0Xqt
         TvY12UsT7JF39CEd8XzsWxgiY5kvwBdZ3QByWUcrhJjh0RWAGYL8oY7Om4xVAr/6VYWH
         Adrw==
X-Gm-Message-State: AFuF++nLKIjcndkfNsjcHOEz0L8ACE6FUzb2q2vY4N5P3D3Tqaek9lOs
	X28L8JYSHtlFpICAmR5ha5OoD+OENNNVtXnHBXLJSHgy1T+DvPt9bJqDEmlYvzV7GA2fsXpDOma
	kAQ3V9mInZ6bDwHBulfgwUMiqpWKYq9+UJmT8p5lsqqqYjMdzeN8V2PPQ8p70xdhlEQMiPuJ3r3
	bq
X-Gm-Gg: AYBFou05nawBu8GZWeRwG80OGnSKMQfGC/gL9qlP/LNBbF0OmuF89Dkjuas0nvsa+dR
	yaJdoJ6MhJpL6oIT0kHY9f8HHRz/mreHHLge8NQsvaTWExHf4o6/7FO4ysj6g/G/NdkuhM+XZv6
	Wu/4U9MsSi2lsZwAE1yeX+cuaUeWMRLBd5GnhJ6ajclMgJBHdOzm/0KHQOPQT9nQz5XD+ZrAADA
	JotfrPVj74hhvCS7n/OfmQZQadkn/tnVvxBB99mdOBCBW2/9vm9ViAY7lkcwidEp8/wliggs5Dd
	bC2znENDpNVxfrEUS3NVoWAg+kEGOoJ1AJ5B/BCTW0HnQICL6+QoTn+JTBoX0dQeXYxY53B5avk
	dccwKSlzUVhctm7/qEiMVbwwyH0VKEFsD2j6sKiMcsNRwjt/95Ske8Rvke7P06YOAtwWD/s0MaV
	w40raRYy/R2gmLg3Dk
X-Received: by 2002:a17:902:d54c:b0:2d3:716e:e2ae with SMTP id d9443c01a7336-2e5ffaa3ab7mr18404825ad.6.1791374946030;
        Wed, 07 Oct 2026 05:09:06 -0700 (PDT)
X-Received: by 2002:a17:902:d54c:b0:2d3:716e:e2ae with SMTP id d9443c01a7336-2e5ffaa3ab7mr18404565ad.6.1791374945529;
        Wed, 07 Oct 2026 05:09:05 -0700 (PDT)
Received: from [10.50.61.110] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604a59a31sm8911615ad.81.2026.10.07.05.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 05:09:05 -0700 (PDT)
Message-ID: <a33608a3-623f-484a-bc74-7d4663946cf6@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 17:39:02 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 00/16] wifi: Add Seamless Mobility Domain
 (SMD) AP support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
 <3d6e053b4f9c4f3cb91a2ea91a0c3abfa7c7025f.camel@sipsolutions.net>
Content-Language: en-US
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
In-Reply-To: <3d6e053b4f9c4f3cb91a2ea91a0c3abfa7c7025f.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0OCBTYWx0ZWRfX0shifOseE875
 yEDYQYnMnwsYN7t3R72dpyweW8D2sdzcaG5KaCQ+Dnta1C74LhS3ku01X12JJpOczBVCDCRrB1W
 H/ZQNSTwQcSPgLJlK8PdvD3cCauNOo8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0OCBTYWx0ZWRfXw9//2vP8grDm
 Buvy1CG3XgkmLRY5+ZkCPGyJE6h0Y4YCIYDFiqh4t8Vu8Ytzhi7OI0Jna1vDyNpU1JNeuauMPSi
 qGJ5l788rvplft83iPOMstEQeB65xqMLEtZkBAN33/Ji1kcT4iIS8sJM+jV0G+Jmt3qXTmHr+GQ
 4XiQ1X8Vx49zvltunqlQdj8ADtbbFn0uyNEwXFlR9iGNMy0tKpGx8RXfh84A2m/n7CMOBsHa0r8
 JKgrcsF8cOQDnVaCfMr8ow5ziBc8er8uX8Pcw9am5chqf9i66gSuiuCsQRTlL94islme8M3daki
 YJwqr3l5s2Sl4zAK1MAO5B7NT4ZFsBtG8MfNgEsKqrIYSMxoDaukEbbvYee2yKSAtLjPTE/0/hC
 +XTKrl+VPn4BK2gLcXCb/FP4nsGL25hlcfyI3Isp1HGKyx7lBfQTKAuG2ygbCzdlZPQCFbiUTGy
 UmirYoU3a9zr1btoSEQ==
X-Proofpoint-ORIG-GUID: ZfX13s9YKfRkVo18X0lcK4KKhNvEjSLp
X-Authority-Analysis: v=2.4 cv=T5EZ3PKQ c=1 sm=1 tr=0 ts=6ac63663 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=xZk0DLfG5lygWoUhd6AA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: ZfX13s9YKfRkVo18X0lcK4KKhNvEjSLp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070048



On 10/04/2026 04:19 pm, Johannes Berg wrote:
> On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>> IEEE P802.11bn introduces the Seamless Mobility Domain (SMD) - a mobility
>> domain uniquely identified by the SMD identifier MAC address - where
>> a non-AP MLD that is associated to the SMD Management Entity (SMD-ME) can
>> transition from its current AP MLD to a non-colocated target AP MLD
>> without requiring reassociation via SMD BSS Transition (ST) procedure.
>>
>> This series implements the nl80211, cfg80211, and mac80211 support for
>> SMD BSS Transition in AP mode. Along with a summary of the ST procedure,
>> the design of this series and patch structure are presented below.
> 
> OK I'm wondering ... more things:
> 
>    1. How is this supposed to update the DS correctly? mac80211 normally
>       does this via cfg80211_send_layer2_update() and I don't think
>       you're changing that, but then it's the wrong place?
>       
>    2. In the kernel here the state is the per-AP MLD state of the STA,
>       not the SMD-ME state, so 4a isn't _really_ "AUTHORIZED", is it?
>       Ties in with 1. though, I guess.
>       

(combining #1 and #2)

Yes, Johannes. 4a is not part of state-4 per se in this implementation.
Patch 6/16
[https://lore.kernel.org/all/20260924-smd-v2-6-bb40094da1d4@oss.qualcomm.com/]
sanitizes only substate-4b and 4c transitions in state-4.

Because, we are not introducing a new entity to track SMD-ME states but rely
on MLD states (subclause 11.3.1, Table 11-6a). During Preparation, on the
target AP MLD, STA will move till just state-3 and then to substate-4a.

On the current AP MLD:
STA moves to: 1 -> 2-> 3 -> 4 -> 4b -> 4c (optionally) -> 1

On the target AP MLD:
STA moves to: 1 -> 2 -> 3 -> 4a -> 4

When STA moves to state-4, L2 update is sent via the existing state transition
handler.
>    3. I commented a few minutes ago about handling of 4a in rx.c, but
>       now I'm beginning to think we also need to handle 4b/4c
>       explicitly.
>       

Yes, I will add frame limitations for all 3 SMD states.

>    4. Adding a station in 4a should have _something_ about powersave, at
>       the very least some documentation that it must be done by drivers
>       (and then perhaps also hwsim changes)?
> 

I will add documentation that drivers should handle this powersave since this
is specific to SMD.
> 
> johannes

