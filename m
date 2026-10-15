Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3C754DAFB
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 15:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078711; cv=none; b=AqudFd/aAk44Nm2xU3tD4TZYrEiBzorosg+j4/dhhuSs6AcUec4BAh6br6hT1pjJtsAvOCpZOzpPzzFEQk1eJJNjtZp0eJozT27tJ2VZeNLF5l/FklOxZwOgLpJLSwqfSXY5BrWxUqoEV97r17nKeX1MZkIlMjvS++mgDUlSazE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078711; c=relaxed/simple;
	bh=QVo+YHVxl8jT12ZA0eNu8ZIZ/OEoEampA8Vm7oeXkVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xiyhfgu9J7KP/Vn/7mG/9qnXje94Ak0Ye5nqgJRjPa3yD/5mzzNv3DRKU+npjYMK3gD0pxkjHiYd+IKhsc1Z61bTnbOy7sCYEPOiIWjKTexvomzFooSL0mRXeuI4KwHmfn+H4biTmlu8ceiS2a1HioCXyQfu3ZC/6KDYbyEHb4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lYFFnjWR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cUtMPjRq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lYFFnjWR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cUtMPjRq"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FDYNUh3462710
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 15:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3HVvCN3iv+As078Gmff0ARZxT6mIW44MrC4GBBlAmpQ=; b=lYFFnjWRmbFmaK2N
	kmsXfgVyZjgBwQpZ/RGuXDeGxxBhKi4tPvT0Kzml+RkRZeHjmayOcSVGUMHUnZYq
	/+FneWtnTYRAN4ina9gZpBfzdMYhP90Lz9C/FGBsrEM+dlXs7AcyKUYyvf7yei0l
	p0uLs45vpEzeNKDfF77ptvaudR70Y6F0Bwle/gDpBV0U/kqX7kSfzriDh3bPzXnd
	fHs0vNPeMPdCEj8pQ7peCn+Wm8P7l9lEI2tjURqFpyCgT8R4zicdTdpNmmaleJpt
	OnLuigWwHlZmhEYUfCLRhgvdN9LTHg3in150XOSRxLRIBbnWb+4hDBw3zeyA9Fiv
	iaE+JA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hayu68hpa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 15:38:19 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-898f641684aso6475937b3a.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 08:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792078698; x=1792683498; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3HVvCN3iv+As078Gmff0ARZxT6mIW44MrC4GBBlAmpQ=;
        b=cUtMPjRqQ4+XJvCB/hKyOYr6LsK5O4zmQFGSS/36jsyW4i8bcdvksT4L9VUErMbeY4
         XiMOw9oS61SmSzkJkWAJaLJyNuJpk2JUnOevls5Mp7oUqyaCK8S8uV4Xu9JsgvBSYQ1w
         4eqY1oWPs6sqqBSM4/tSosInnD9LDLoDSVh58puduv595LRcxg5ohLnFWI019G1ik+U1
         pY9vIcvcVHSe1fjel2v6I3BlVAdvtXlw+v4KDQLy5J5oOFpJjeF2jCm8lAEVIeMzfgpw
         zh5ZcccsfiboohunvcnFpfEpPtkXqbHnoWN9Vz8LyRRopIKD6HQD3zaAttPWXO8dFm0d
         ssHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078698; x=1792683498;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3HVvCN3iv+As078Gmff0ARZxT6mIW44MrC4GBBlAmpQ=;
        b=pq4kOnMDEQVkuPbeON7iU0fIgXoH/yNGT6MUrM24Gjht6DMJc+HT4ObzmCUSqHpYAv
         ZBif0W4xS51mM1gso7DDlaVHjPynp18ps5Bf0m5ilt7A3b68ZDqOSYC+FjwTtMRss7Bv
         5a5crGQv36SQ7Yu74EPhfagF2AcGpzZ/R0d6pkz8cRZ8jZJEhQgEbB38BcmpIXeQVXs3
         swCvq4XHl+ZDvqS9XmLFZVnH+Qf7qTfmGFjxMMxYvxnns8KCnaE6+nSYVXFyAnhA8aAy
         bCUr39lBpqLpN4pAOsKmkfu7vb2C0BoMqofghbuwEUMkllIqUXwMir3TRm6npesU/bid
         LhRA==
X-Gm-Message-State: AFq9FYIbPlX4yxCt/pFoNmJQ3k0fX/CQJ2QoA/EtnVLvNIfa2+WIsFg5
	7eEVY+O+8j2X5ag3IrW8/5sgDdhrf/BbeMKdEqCdpoZS3oWMLXrXrZpa/FA0SmQ2GL5a/njKhiJ
	uwkODAoRn7gDU82RjILFPZUj8IaPPBQqFVnz7eKMHGiZi4pGz9zDevfRL2DQmwiin4i0tGQ==
X-Gm-Gg: AYBFou3yU1OmcGqm1MEpXgxsS080jRzXy3AO8SNtrMixV4soBhjqwyzBd9MW60pC2ya
	LlYYaaICFhhCC+QApmsGCA3a3NW4Q9Uv2scqm/nhwOOForBsUjgRR7RyazyvSLvlst64C7yAHUR
	8zAX+tTb29zL0ybDSPi1IQCY99jAVE3Yj9q3cyqqJTg4LW57twLE/285LZTKPHXKq69C4qvOhPF
	apUsaA7Pmgr5C+7l3BuZHVit+Pp60mEMDApozqM0o6KbjD1SibxmQDqAri3Guy/ThatgnMo+9++
	54jL3hBJiE2yV1PJJLbsYZyQ+urGamqH9z3awlHM52QmTbW/NgBrZvjL+1Je4EpM50AzTh9MJuk
	ogulcidT1wsP4lQhpQVQyU1dgMDj0oCyY+aI17nGAoXQamDxAvbSxAPCZYg==
X-Received: by 2002:a05:6a20:430d:b0:3de:51e1:e7c1 with SMTP id adf61e73a8af0-3e16baa4b77mr18585611637.3.1792078698083;
        Thu, 15 Oct 2026 08:38:18 -0700 (PDT)
X-Received: by 2002:a05:6a20:430d:b0:3de:51e1:e7c1 with SMTP id adf61e73a8af0-3e16baa4b77mr18585589637.3.1792078697463;
        Thu, 15 Oct 2026 08:38:17 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89d803cf66fsm2577196b3a.32.2026.10.15.08.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 08:38:15 -0700 (PDT)
Message-ID: <048365a7-0ce0-4f98-98d2-eb040ff87b39@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 08:38:14 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ath12k: WCN7850 firmware stops uplink TX on EHT
 (CMD_REMOVE_AGED_FRAMES)
To: Enrico <vovkap97@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>
References: <CAGHkXsZX7Tnze+rqJY=D5Zz2Vo=t2Hee28pDxFpoE+Lno+EcxA@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CAGHkXsZX7Tnze+rqJY=D5Zz2Vo=t2Hee28pDxFpoE+Lno+EcxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: q_rtd526aXdvDzYSdj-K6Z1pfQEGtMd-
X-Authority-Analysis: v=2.4 cv=ff04WEQF c=1 sm=1 tr=0 ts=6ad0f36b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=4omKq1ZWnG6OjGzzdTAA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: q_rtd526aXdvDzYSdj-K6Z1pfQEGtMd-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA2MiBTYWx0ZWRfX6Y0uauxpUg3o
 9cmROoM4wy/Bz4U2qao0hbZB8Wwh/c1SRxvm7NpzaKWyMAxsqBn36sq5IGm4B/H+Y9+Xl3U+OET
 CDNmm3zavdcR2LHt5SQqZQBDweQa9qNyzgX8ysqAS7PgF1wiQwmewKkzz7AByJ4SHlT3uVzWBI8
 2gEggtpuu3e9mowsXRWGdJ8qDDunP7mrpRY+uV516Zx5HtKv5n03kQrkb0yYunkjGxu1WsTYyqV
 htWWOck7Otg4Ra8mqpzP7umr4RLYQToqgRtWj8bkZfp5g7zR9PTsce2w27m+AVsJUBgulJcy9mQ
 xjEzoc55Slruur+y4mh3vjC4kAFs8Mmh010tP7b30U5MFbOGqSmoRpp0F4/qk26hJ+mDhZZfqF4
 MH6ojTUaghdkrtX/+mN0gmtnSImaDds15ulwV7zZAbDOSQpCJo2+mMyn+7AuoOziN+Ds3nglW6o
 rSXCfr8PqiMSXWl2zcA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA2MiBTYWx0ZWRfX20ZCsH07I3ZB
 WAdINFve5hpgiLON8S6Rrb+tf//5FOviGF22a7Uvolg1GC5VCnhAitAfbNxDK3yXotM+OKwMugf
 5XOpPI3A46A52jmPe4VyjEo+RMpSFZM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150062

On 10/15/2026 4:59 AM, Enrico wrote:
> Hi,
> 
> On EHT, the WCN7850 firmware stops transmitting uplink data for 1-4
> minutes while the association stays up. The driver keeps handing it
> frames, the firmware releases them as CMD_REMOVE_AGED_FRAMES, and the
> AP receives only the few frames the firmware reports as acked.
> Downlink keeps working and the kernel logs nothing. I saw 11 stalls
> in 57 hours on EHT and 0 in 24 hours after switching the AP's 5 GHz
> radio to 802.11ax.

Please open a ticket per:
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/bugreport.html

Then it can be assigned and tracked.

Thanks!
/jeff
