Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453023AA9E2
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027219; cv=none; b=WV8XR/cIeZAxm53sdDelMzBm6HVwsCWboJGS40cUbGX5tBOczGvL85qybvhNivhqCKQvB78iKlxVF1PWf/zRcoCUlK7ow+xGQgAeisqtbFU4/kBQ2R/JJrIc5so1CVbs0FbSO4+UYrd3vBYUy9Fcth4f7feGUD+d+Ta57YKyxgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027219; c=relaxed/simple;
	bh=+3YyQPwb/WShWVMj6aShCPiAWwBLkUJzAzdABEvWRhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpmQ47hJ+tGJDjYP+0PQk5wut1bKuFOwSx5okjVJoiw/6AUZxbhF5pgs7bbI6RaJA4Ow+tS8hKo97fY80uzRZgYJvxYqdl4pBVpO5TbUY5PsMJhwIaSTZgqZwbSXv7raBasqEfNLdYqFPXxdCBUt0q6Azb6gpahlDlJ1dMxWDEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G3pWi0x/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gx70R0gm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G3pWi0x/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gx70R0gm"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nc3i1227567
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 14:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+3YyQPwb/WShWVMj6aShCPiAWwBLkUJzAzdABEvWRhg=; b=G3pWi0x/T7h7P+Gj
	nZtQK++GtzDcpDLGdegvgr0jTBphibSBvIlgY7GaBbeAE5VHF1FF45od/hvhORKX
	0/nLtfrKaBkaouo7ilFlBTSJh//d6YaghSjVPbv1mIBBQdGx/qeaNd2SL2oBXMsB
	bxSVH/ignV6jnTrT+NJ25IK0Gn/RzvuJn14seoBfp0xmgZYnlZfvKNuyQbEL37tZ
	FDBMuYp4gv41HKi/zNbcK+jRpliAhgmkN+BvComMjPrTBe8bFK/wPOnD7hLxWS2+
	jhGI9eNOjvixY9GOciFR3EnE5Hctk56pXKXboSuZtgpNBumWK5vTBImYyhuszm/K
	Sq9qJg==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvqduhhmt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 14:40:17 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab4dd46ddeso1148309b6e.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 07:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786027217; x=1786632017; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+3YyQPwb/WShWVMj6aShCPiAWwBLkUJzAzdABEvWRhg=;
        b=gx70R0gm6jKgE/GlvrbpEP06ObGBZJPUOdQqMKONWGfqs5FvG1ApIMJZOnTER7R5d2
         4sawDaGHcFYp1u7Uz6NKm+aw5eopuLElx4dTA0iP7I2QzJh9MUBQyS0phrpOhsRu3bwI
         YsSua75wP/XBj60Td4M++8mAp2gGWjcRR/hx+M4FTOrxqK8S/ALc45eUTehU0lFFL5Z6
         JSri3le4ZkrEBd8RtuS8bt89Ell1chCr0OCeBWRdvggmwk+iC3kr8MhW6q8rZlpktXzI
         aMQ3vbypO1v/Je1JEA0JpKKJ33pBTPAAF3fSYLGe+jGkbHlIkmB+FvpltF0qVM+Vs1Zh
         O9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027217; x=1786632017;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+3YyQPwb/WShWVMj6aShCPiAWwBLkUJzAzdABEvWRhg=;
        b=tR7WUl1nBisGPpZ9tp27PK7ouVaQDtaCJqMTmNJicTzbj5RIXGuxcBKCfshoq8NizC
         nWP2RIDQLTKlcvvv67IVAU1/KT68mmHE8iKJeNdLFcdo6KASCkocZfCQS1U2BFbVZoWW
         scNdg2hu1xkxOYuy9YrYIFX/FqZPSyCrYMryjbSZlujYrqoOTMS0E2smDqNejbIwnbl5
         7nqi651JMXaughPoMJ7+ljRavReyGxUgZJ0S3FMPe+qG/UmAu4sPwb9YDm1bJI1lPdqK
         S+3yG4EFlDcYZOIW8yiXpF8udLkcQK8Uk/yklqQF1RgV56RMV6pWVT/bPws91jdvQSqV
         dPzQ==
X-Gm-Message-State: AOJu0Ywoab/HVENqblkB25yzwUgwFRA1cdIuNf3eJUV0UllKCgk0lI3x
	kZuEmsszRKulXL+pYOSmdtW43ty6gytPBwQ7gApZFtgfLYKQq+5NdgS4dMHgVZnvStEPSKhJFZA
	rxToFNltlDK9JVUd3YXRVxfOXa6sS8YosnzsTxdH0j6fu4wED3Yy74k1APSO8SM+fODwo8Q==
X-Gm-Gg: AR+sD125kLO3r18RhUTFrv0IZLlF7Objm6Z4Q6ZhxVUBOEcnyrKGYUu9Eyl6fo3+F2L
	mol0GVbjKa/OIzWTMUCw9Ruls1+tqTlq/wo0R/U2DZcCSVe3GMtmT0531JQlSD2qcSRlK4VCTov
	Q96L3Aa1pGbVgWJkjUjpZm5qsJ9dbpUE+tdkWUBIjlBpbsoclrPxualzsWeds1ka1gmaR5lrFgS
	1Y/l4MqxXrOaxsOicg8UQsex2RtLaN8n75Z+PtmIVNBdxTyzP8HN+udQF8b8N87sdyPHkeh2r6J
	p0/SwP5GAbGYL7yFIP9FMErGaYXWtDHLnZNxnI1X6waMXFjrBRG63w3yTj1lX0aV/01XpQkb8+j
	RMw23tBZxMvpJ6VSxDiQK/GUUdjbF8CaluKlZ8Cft4mafAI1Z/HDk+RgyY6yW
X-Received: by 2002:a05:6808:1927:b0:497:d371:21c8 with SMTP id 5614622812f47-4afae27b56emr10048999b6e.19.1786027216802;
        Thu, 06 Aug 2026 07:40:16 -0700 (PDT)
X-Received: by 2002:a05:6808:1927:b0:497:d371:21c8 with SMTP id 5614622812f47-4afae27b56emr10048971b6e.19.1786027216355;
        Thu, 06 Aug 2026 07:40:16 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4afae45b630sm4755902b6e.1.2026.08.06.07.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 07:40:15 -0700 (PDT)
Message-ID: <a9ea439b-29b1-43fc-b819-1dfce2be510b@oss.qualcomm.com>
Date: Thu, 6 Aug 2026 07:40:12 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/8] wifi: ath12k: extend device DP stats for
 TX and RX observability
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260806132427.3704828-1-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: kGlBfsmI5NASYWO4MR9RVqaedFo7QG2h
X-Proofpoint-ORIG-GUID: kGlBfsmI5NASYWO4MR9RVqaedFo7QG2h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfX4+b6iOFXzkY+
 vjHpqu2yJOz1t6yQe1HTzDSL4oV765Q0SC3lpfSsVABjao0FUnJAAyas/aGrtua3jGUIp3/chk/
 5iOVwfhmvFAbVaXQN2dsP1DseT30oDlEPI5Q8rT3L1VI8iwsc625RqW2GR58B6Oc97s7oX3OVSV
 GaV8MllB2MUrGrNWWPAoBDHu2RoHbKUKrhiwedyX9twT4M/wzzAK5/6CT5B15t/CsaW8zXEyyjD
 cyQY72KMG8m5PoOrOVc2BnU7bQPlooeXof5EekGx1lAeWeQXAmeKKBSXMHUsPXdAfNNoapOJ9s8
 mmdMb0p5kmbkh0zIVibcwYmJ8YObdTF3u8tukAQo8d+0oVxAzh/KxCal2hEcfL4wRJeum6WIE0v
 2jcE2hnJYjB3J4Vcc7fNNtx6so5NO3/aEkiXp+qsq7+cQ9gQ7fPrSAreJ8jAcqqWqMWqmBcX61U
 i6q9zVbniaLceQE74MA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfX0MQJjZ3+Pw68
 iKT07s2F4+5ah+w0XAyGoX4WoKKZuD/Picpzm1P0AxpL0YqUBQvrDfLeMJrflSDWMT6KcCFscHY
 ONSlY0/IOmCYVaEaeeMVsfSvza5IIE0=
X-Authority-Analysis: v=2.4 cv=bdtbluPB c=1 sm=1 tr=0 ts=6a749cd1 cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=ZeT7kjbkWLjvT54KAQkA:9 a=QEXdDO2ut3YA:10 a=pF_qn-MSjDawc0seGVz6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060114

Why are there two separate postings of v2? Looks like the first instance was
incomplete and only 6 of 8 patches were sent? If so, you should have tagged
the second posting with REPOST.

