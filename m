Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB134FF41
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556100; cv=none; b=pUHKUZis3r3/FDsf20ed85N43O5St2oS3gkMiB73ysih9Bc/mxUCbsh12R4N4pxgOBxn2btA7ToJVo4ahjzI4x4AhhYFo1jkcvdrn/6yN04uWcGiPt3N+PU/pux3AgWM/NvLPta2WuRnHdkjmA802I4Lwtqr5oEaQcuXLCZYXXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556100; c=relaxed/simple;
	bh=Wgg0Xu0pKRAoIE/78sNdaI2/OubTxL4i+ZlvCaiEPtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rCWtn3D0dDCdP15PPwfZLlp96ucK24meDGOQFn6HokAuWtlHXA1yLZqeH7H0oiV2rBl+/+p5mFTRbBFBKhhhLoBbi1DelL0inn+Ht20rXizqQiKQjbJDk0YESuFVB3e4Myc0DDW6tOTtJHOqomY7v7KRS0ZM1jFUTpDkJS1g8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U46QdtAY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vfmoidvd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U46QdtAY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vfmoidvd"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KDrALB3859382
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Me63HAxi1n5R+/58j1Al3kh5edACqJibvGy9/ANPjZs=; b=U46QdtAY6/peMZ0V
	gX19r7MV7qAaHtcSr4pyGTiBNNikQahYh4VaECdQVFONzJ3D8SbianLZtmUoR3Qt
	0mB+fDXbwkG6X5GZTWxpAAYRFeV6zdCGgXLdZk0X0idf5Qp2JUKx4EkKvHWPAVCi
	YJXFeZxxiFiSsRQeu3BD3T+oyWKfsFb68CDqPd8ClEmL/FTixEhHkEbQKzz2ZMws
	7T9KpnYop1BmtnI9zBayME9vp6LkD3wzII5P0WqhjwnezQqGMczZ1mtHhzXZoVyw
	tIxCxGoMTpBvAKyICLikOhMb79uuWaBMNh0IaHk4RwxtcrPDG/ekov6fimxetr70
	wJMqMQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhfpg1m63-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:01:38 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cacf17c7e0so98409265ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784556097; x=1785160897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Me63HAxi1n5R+/58j1Al3kh5edACqJibvGy9/ANPjZs=;
        b=VfmoidvdC8aN3FzCEn6fay/NsekTnRyFFPF+oVeBwsmEnUbQBSOMxSA3W17anNu2zt
         3c1u1lKJwjthm/fS32i6SNfw8XFDBulrVKO1N9B0UzeFlXz2QKnvJW8pE1g/ymgAggPj
         mI7lYuf/N9yxrGeYp9h6B7wMHPfJlE5Tr17XXqitOWFZ6PvK3LU8w7fqPTOcxNHQkXzm
         uEuq5HceFKXqKXtA82bHRKIUHJ7ErW7sQbi8HhwtXiXMCCBXbtoC6YU1g+x1UHXTuNWs
         2emgoJdVqs/BC3usHfjb042xdow7Aq79rNo3NRHO1dgZArhDTfoePptz56ZcIzarUbsx
         RUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784556097; x=1785160897;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Me63HAxi1n5R+/58j1Al3kh5edACqJibvGy9/ANPjZs=;
        b=DBFfBtO7tDB3f5gL0zL1oQu7OYlUrsa/VsX2hDOG+KkBTm1bRcn9wwX5SzOd/yVkvf
         xV/MGqeTOFLUoaxWhftm5tVNQz3IS6D9Z4N3GqeQHHNtC38RtJMKEnhNpN8TaQubKirn
         XmfNSc0nkoT4gjQwMHFLYDAIR0IqP+/eu1B8ltYhY4//OlHCfrSafR7oynF8v4c8miiB
         dpyjE1/yRslAijgYltNYnAhWfPtMXiq08m2gfCJh+Ts1e0eoasOMnLNFP6/tFNWYRQA3
         n6BUqv/TWuLBcJMelFW1cgfeACm7Oidq4gdSu+QvjV/RkE2aEW+pmZWC0+m89wmZbZSE
         m7pg==
X-Gm-Message-State: AOJu0YzDZj4QGLtSNhn5z/ViCaJwZJQdFFSl3rGf/vN0bW0nAMk6rw6O
	PceKZyTVsAYCHZfTL/SCVJtOms1aq1cIbqXhg3DBWBzMA4HVF/tC0Wt1Rpy4cG6dqicY5KT80/p
	mHhhPSSRajeaYOLBJjkM7KRyTsNLxtx0C2EOszf2U41Tn2ycECAI9W5N9TB6i6QCsB6jnPw==
X-Gm-Gg: AR+sD11dbKlcEemGG/maLLqh+X/5JyAkXEY83XXYut/OL70PxuswUgZlwJPIQ4bb8GW
	htf8UIfTSkgS49GtrVpIqp4u55oLRL+D/3tsXy00CCo6uGamtp0dLiK9ZpbY6d9V0JpsMZ/l56o
	AK5xlMcEZz6ydDa39LuYFSY6He8LAxHjJJL2BFjFZJ1PRVdDF7hUogETOapRDdxdLyc5CIKr6LQ
	8M2UCKJ1IGlKDx/u6kiNfqVPvZGTAQSACWKoXUty2Zqcx/zrCf+4jLyiGrUqtMxCwGaSwLjT7KK
	axEmUmpAKWeXSmjZjSp24gRLjHDyjwfLp2RFn/ccC7nppbeOSfs71QjQx22M63xdRXMHJN3iP4k
	30EflULElrC/1SpTi6P/9r7k7NB1vDD3Ri6jFqjbdxRGT/INHZqCg7yGa02Mp
X-Received: by 2002:a17:902:ef01:b0:2c2:62ee:5a0d with SMTP id d9443c01a7336-2cf3489181cmr154941475ad.14.1784556097009;
        Mon, 20 Jul 2026 07:01:37 -0700 (PDT)
X-Received: by 2002:a17:902:ef01:b0:2c2:62ee:5a0d with SMTP id d9443c01a7336-2cf3489181cmr154940705ad.14.1784556096252;
        Mon, 20 Jul 2026 07:01:36 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429ff04absm34396812eec.8.2026.07.20.07.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 07:01:35 -0700 (PDT)
Message-ID: <8e4a3842-4fc2-4a05-9142-6fd8f23751ed@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 07:01:32 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath12k: fix survey indexing across bands
To: Matthew Leach <matthew.leach@collabora.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@collabora.com,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Nicolas Escande <nico.escande@gmail.com>,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>
References: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDE1NiBTYWx0ZWRfX8YKw2z6zVbE0
 QK5wpo9N3305npFJiUquCNXaQNXet5dizy916ttJifJ6MivJQW7JuCi82+OQep/ijL1KkH56mJh
 MC1Zm78WPnRxP5QABgwLgbsjr+pmRpo=
X-Proofpoint-GUID: bjyvnNZGv0L7t3HWcfpGJCTM11GStRv0
X-Proofpoint-ORIG-GUID: bjyvnNZGv0L7t3HWcfpGJCTM11GStRv0
X-Authority-Analysis: v=2.4 cv=c+6bhx9l c=1 sm=1 tr=0 ts=6a5e2a42 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=QX4gbG5DAAAA:8 a=xhY4wr4glCW0yVQm5PkA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22 a=AbAUZ8qAyYyZVLSsDulk:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDE1NiBTYWx0ZWRfX4QMEoVBy/3AJ
 5rtCNCxC8x6TPJ8yX8Jeqz+Nr7BCa7tFrG5F6nF4cQtoPmNPDAtojGUp1uJKJo/19E4iArQUqR5
 xT9K0/wPzWVv5WiTvkkFhgDuIKaMD4CH45/jprtj5qVO2bzPypWfeJOcQNNZynlfocQEf5OsHw6
 pq0GP5CKYREEXh9Z+4TFqrd/Ld/gKQTgSL6VBYA6ILgr2/54q6yZYAJ/K+6vI+tua4bov7IXrWV
 1y2mMMsH7hlgEgc+HxlmYy4AmTo5F7W5VR17c87xT1KKL6eEG6nB+KPSLydtGn+bz9KGU1n/eSq
 X4vqYbCFmdF+YDiqJ4QBSWPSniO/lViV8nJaV8QIin+bjgGXVGzWBgrncZxhGqdrhpF2RB+AGp3
 NCLlqf18u8fQcGU9gIL27WrJ3qG/qhrNT9Rk6N6i0h/CdgRhJ8BJ040qi5TVvZTiIUbhSmaH+sm
 hITM9IXOojgjnuLh2NQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_03,2026-07-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200156

On 7/3/2026 8:56 AM, Matthew Leach wrote:
> When running 'iw dev wlan0 survey dump' the values for the channel busy
> time have the same sequence across bands. This is caused by indexing
> into the ath12k survey array using a band-local index rather than the
> global index passed by mac80211. This results in surveys for 5 GHz and 6
> GHz channels returning values from 2.4 GHz slots, making the survey
> unusable on those bands. Further, there are redundant survey slots for
> multi-radio/single-phy instances.
> 
> Fix by moving the survey data into ath12k_hw so multiple radios under a
> single wiphy share one table, and index into it using the global
> mac80211 index. A new spinlock in ath12k_hw serialises access to the
> survey array, which is now shared across all radios under a single hw.
> 
> Band busy-times Before this fix:
> 
> 2.4 GHz: 9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
> 5 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
> 6 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
> 
> After this fix, times are independent:
> 
> 2.4 GHz: 23, 5,  5,  12, 2,   12,  26,  5,   3,  1,  27
> 5 GHz:   30, 40, 29, 27, 118, 118, 112, 120, 11, 11, 11
> 6 GHz:   1,  0,  0,  0,  0,   0,   0,   0,   0,  0,  1
> 
> Tested-on: wcn7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
> 
> Fixes: 4f242b1d6996 ("wifi: ath12k: support get_survey mac op for single wiphy")
> Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
> ---

my review agent flagged:
"file": "drivers/net/wireless/ath/ath12k/core.h",
"summary": "data_lock comment still lists 'survey info' as one of the fields
it protects, but survey data is now protected by ah->survey_lock",
"failure_scenario": "A developer adding survey-related code follows the
comment and uses data_lock to protect ah->survey[], introducing an unprotected
access (since the actual readers/writers use survey_lock, not data_lock)."

I'll update the comment in my pending branch

/jeff

