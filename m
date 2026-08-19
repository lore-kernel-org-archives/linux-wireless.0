Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779E443B492
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787134007; cv=none; b=tRd0R4iRsxV6FEQ5wEN/78patZynZRSy1C13daNRrJhwSilVlhZwpdWpPl4jzvvj1Ly+ARS1FOD3OqwKOWYVmmoA/kYw25PTMwjj80v9IQgeO7atVoubfgMoSSoJcc8+8xp2XgYwL0Jm/SfTh7/cEVfPQNhMi2kJAP4EvdpITtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787134007; c=relaxed/simple;
	bh=HLhNY1x5gygfrpsa3mWRE8kiKKDHIzW69M9ZtpmZ7w8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjTkg8hmnf+nPYasloZMzGK6KLJXZ8MYX71x59i1DOGi+ALe464sMBwCTHj/a/j6CdyczdlOcdDDLCnXlGdTrdOy1hi33qHlOi8SYELqBdua6+Fp1eKJKkR6iqS85l86Pnbql1rk3afKwd4wr6XSDQPGY0xYmvyAdfxCn7CGGF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BtSgcQYs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=knSiLOtQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BtSgcQYs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="knSiLOtQ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6Z1EH533436
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MWA21dAxPlqU4uyBL8vbOkVE0vMfcnd76JLtITSBO18=; b=BtSgcQYs5VtTNGkA
	Jp8X0ED/hfDS3LD6TWCMy286UL/1lIguDdIv/+0LcrTvo556D3aj/upCSFrD2Orj
	vFZhgtZM5cjuJGgGjz0gwm1eECKYMLJednkSGAgDu4i2X71FcYvHRZVKzxg+yfUg
	FgxdyXxttmHyX+uQLmbYRBTX+STHEYuE4ExhGRjFIJE/j5ONWRFjI4lcqaVpGbxb
	8+YC7YXxTl+xWrTZX3LegmJzB+9jnLXnpmoFOS+dqVsTR5qN9UNmyI1MHoh1fmf0
	MUaE26eNYouS2rZbgD/rSkZ9ig2rUnq89pBAi4V86pmU4PG52QF3r0kwv8WUi/l3
	iX/YOQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfm2jbv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 10:06:45 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1888144a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 03:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787134003; x=1787738803; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MWA21dAxPlqU4uyBL8vbOkVE0vMfcnd76JLtITSBO18=;
        b=knSiLOtQJdDpTPzbARr9nTQNDNxHm9IcWPM3vmAkopwyJXZIbcXA5rYC6ydSLVtG4p
         vFE9G/gEki2cr42caqapa7estHEu5imxCN61P089cPemWAe0f35+O0dP6HaT7eyAdDef
         m+4SNKHO/gAK4GmzA6KRUluJ8dKVrYr6GvCNtQImHXPRMKNx/tGvXpanXS58gv6skd9u
         VY8kjp77GZAhTNdYAyoRct2bYaKE3n84LpuwHZXNl7+cheYvUOk1GKBhfcRTknHDUKwO
         GtMH6+i268+ZJtSrgAFGRTDb3hmm/VW5NhNHpWDErVQT70M8PRs4QKK+F9ksq7kNM9Y6
         4CSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787134003; x=1787738803;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MWA21dAxPlqU4uyBL8vbOkVE0vMfcnd76JLtITSBO18=;
        b=BQOj0QuufIb71fQLKli79dk1udiR990SObQWT4m/s0cB0k1dVFIf9dwgs/ro1zg0Cj
         MPQhkTTFXPJUsBZhbmYHup/GtxewxQgXXGS7oCM5XqL2MMnMcqAw/ZxO2xE+n5oKmx0O
         tDylnsKGNc2XxONJuL05sClP/RmpHei2JnYm59kKHnfmCeJdn4sAdw2QSjElCi6dBzeb
         1rYpA978GA5KSDEmAhwso/QcivxXf1tFBzJ56zOV8fWk/OHLUg1k089D02KJhdzjAtZD
         J4diVb8naQEfEEdVsrt1d80YJn2qdGIn3JdiB61KcKD1B6P8ZYuIyhcGW2TfyQNqP77N
         yZgA==
X-Forwarded-Encrypted: i=1; AHgh+RoNkODWUVyI6osxJJpXEgPCsCMG9bd4tvmJUUzsEi31EhnmiQBpcsnz9HGQcXc+7xPLS8Hm1y9cPqINB4PCJg==@vger.kernel.org
X-Gm-Message-State: AFuF++kaUF+esP4Fms8cOFRHVPJsGx4No9IN4Ks7ZgS4/vSjsomviwvy
	7LsmDJQDujROHkdamktsIekbVRlIlcN0vfP/aHeS/cYYYHustNQ8R7mf06hE0jDG5TuQVfNfgwV
	Nkg3aQPqzANa7FGHzK23Fp+D+6NZmoesfd0i5+gwmwcWmgmI0CoDD5UCe3sepXFkGLDntXg==
X-Gm-Gg: AR+sD13n6ehkUSEw4/HtUr9gAxCqM7POMZjzVuJf7X0+KCUh6yvMrPNoHQVIfkDTOGj
	79rGHoUdA+BcguyPNi9k4oG9HjMs38gSGUNRa5yesf1u6q6SWfp69RpO6mtHakH0fOjwFdvMP41
	6YdBXopO7uBlZYfXpif7fJJzGjaq9GuiC1OrmONilZDScWCDBCAfjuDetVijnr+R9e1kcSSxF/m
	755MZew4+cTBepaO6iZuWfsFfVr+k2D1noFtNJxujK/aeVIiBJeJG/M0hIt6LJ7yn6IC46dbB2p
	wKjD6bp2g5Cyp7S1OXQ8GlSZvWQ9nJUKTv8zrkPVO15iraE9CPGjkrl2AE0bFcHUvwFNyrKpRaz
	4fjj4SK0wNGoBcgGw4E7Wk4+C0NNl7pWye4pEMsreIDs06TfJMmQX4bBZSRWlw6pJFhURHulHuQ
	==
X-Received: by 2002:a17:90b:17c6:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-39580f119e0mr6094904a91.7.1787134002626;
        Wed, 19 Aug 2026 03:06:42 -0700 (PDT)
X-Received: by 2002:a17:90b:17c6:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-39580f119e0mr6094806a91.7.1787134002201;
        Wed, 19 Aug 2026 03:06:42 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb8578asm2026605a91.11.2026.08.19.03.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 03:06:41 -0700 (PDT)
Message-ID: <82fbdec3-5030-4eb6-8a4f-e2be1ddab024@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 18:06:37 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: wmi: Complete regulatory update
 for dropped events
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260818-topic-wifi_reg_fix-v1-1-18c7c289e528@oss.qualcomm.com>
 <f4f1e338-1206-46a1-bbfd-79fb768dc382@oss.qualcomm.com>
 <7334cace-49e2-4a8e-aae2-6541c62f5b5a@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <7334cace-49e2-4a8e-aae2-6541c62f5b5a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA3NiBTYWx0ZWRfX8PMjgyDPVR5S
 RU1bna1l+nh3d95maoLku0N9v+wMlc6fV9uOMZN7E3C1uMNBa8pgUIZtHhYzeBHqGNRtGuQMUbv
 c3A66JmGY5VykBKYnw5xD+tyLjcY3fg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA3NiBTYWx0ZWRfX5bM1CJc8rMRu
 MmVDJV13R8STSQebzpX6F/Fe+NJXoBcn1KisVvR6IuQZq6Goss7s9NPaBCNTGSp8WHX6VUINo+9
 M6ZzBex+YbZenvRaIIVlWwYt8PmdJSndArfX4ds8N2Ri1+JNWSBh8+f9GtNtJPIlBo3HtMgNCGY
 38wPq9f7JBO9V2oCJaAufpZhriKPHsRAIeJxhpUQmjlr4tWpoAjKTFBsVYShFKNiWpW/r7+zDQn
 moIJrJm163/3lvrkY0BWjih9GLD4nW6O5DWOhKoQ3dRDlzzbg0IsPpwQEqOPuMdh4sm+8iAeXT8
 dGq644DP9+OTSrcn9R0QpimreR4h5E/A1HOHbenw45TcioOljM8sgMp+IhiS156HjH1wFAiR25y
 ZsWpexnqMCuvsN9RNEcU+6y3srQfYgsgIXrHeTfYpnZKVhtUd4QIXeKUjNRSQwuNAnGQkmUcCaN
 nPrcBJAXThu9NW8P4cA==
X-Proofpoint-ORIG-GUID: lWO9XFcZRmgwj30tg0cMyFbDG7m9Si3k
X-Authority-Analysis: v=2.4 cv=bN0m5v+Z c=1 sm=1 tr=0 ts=6a858035 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ryZ7i3bytUmpndEZJFAA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: lWO9XFcZRmgwj30tg0cMyFbDG7m9Si3k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190076



On 8/19/2026 3:43 PM, Konrad Dybcio wrote:
> On 8/19/26 3:50 AM, Baochen Qiang wrote:
>>
>>
>> On 8/18/2026 10:57 PM, Konrad Dybcio wrote:
>>> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>>
>>> If ath12k_reg_validate_reg_info() returns STATUS_FALLBACK/DROP (which
>>> are not fatal), the code then jumps to mem_free with pdev_idx still set
>>> to 255, making the following completion never take place.
> 
> [...]
> 
>> there is a similar patch [1] as part of a series [2]:
>>
>> [1]
>> https://lore.kernel.org/all/20260729-ath12k-regd-wait-timeout-v1-1-504aa6e7e93c@oss.qualcomm.com/
>> [2]
>> https://lore.kernel.org/all/20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com/
> 
> Ah, sorry.. I tried searching for whether you guys handled it but
> I didn't find that series. Let's go with your patches.

I should have put you in the cc list or reply in the internal thread ... :)

> 
> Konrad

