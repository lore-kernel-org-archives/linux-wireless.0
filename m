Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B73492E5D
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 00:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788913251; cv=none; b=s/+qfIdm+dHNjCAkf9+OrVb6SoymHMNC5JGhdJ/eQ3nztR+34Yg8CdNkr63FmC2sv8/BgJwK/47tTfjAowK8oIbDd6LvVEqhvgzgK+YDKBhoa2+Bp4nBegTZ7ozRneV9xTX7/1jCcN6IwogL2x0Rgpr6uVb0449OoCuLdGpVSjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788913251; c=relaxed/simple;
	bh=XecZjoKbyLid/zaEckfBvEKzgChVXx7ZKWsmxEf7Z/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MTVumL0FOwZi0qqhUJK1lgo9klc0cZ5dmtbodDShWED0+qMk+7sHzTI1jcLqB6UeRR6xK0nB2skJLDt3pzXylG2Qx3XuKyY/MP+Nobk162XD+RYmQzhp1YnWWGCNQJmtX1WD9kDnPV/dzPnBeBew73Teb1moIQ/S07rmQ4G/jY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=X3gVPkYT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y+3XjeYL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="X3gVPkYT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y+3XjeYL"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Mg7DR1274463
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 00:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xR8s+UHGZfc61IgB5XEcMg1cwxtjDg51Pfcp0sYGqLY=; b=X3gVPkYTaEhQAH60
	FqBX7lrqlRo9Ar7KdaAByumufL7J7sYUSDdfauUj3x9bcg7vlL+V4hOXL4ubr6i3
	VTYrMBI3BUEhfMCrCp4yV8FWiacWALdrQLjjNaqzk8T5uk52CEqmF/Tkp7J1IOfO
	cAR4NJACKxWF7kGtmfPgFln3aVcNfGCf5P5kayDxezBP1oZHjPON6cfq6NGCy5DM
	eprNPYOVAYBNMPbWRk4SOVAwFe6PusdBxjN2SzwInUn0O/qzJrBWwzqdmZGV2nVz
	cZnucXvVKaNPsLnV68BDxJOeN2tiuM6Lv9ZBhQ7I3TY2XpmQGV6fjkthyH2xbmIt
	W/JO+w==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjqdw1e93-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 00:20:49 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d54187d8b0so37970585ad.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 17:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788913249; x=1789518049; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xR8s+UHGZfc61IgB5XEcMg1cwxtjDg51Pfcp0sYGqLY=;
        b=Y+3XjeYL/GQ30Q4D9qmMH76RPAqc0m9llWdTIS5mqvcOt+n/T/2ti9Tm4X9ZEs5Plw
         RbwL0jC/K6weVan9vmxfXYHVJ+qBk5s+ufI3MdyzndvRGF6R8TK+CCQSjuFlMh0N4hcO
         XkurETV75De6xCynO+PXNCf2vf1uyZ56EMnUYrMwOz6QgBESELt38jOeoR9SutO0Vxdk
         Y0J+RwCmsf/mfpJcAGxH0edOHjuN2dCdhckJ76u4iRqmZEJHRuSpzkWkksETeBWS0Csc
         GyX5TE3M79BIUX+VSnPVpE+BOKJGXGFtQZlxTAui2G+m1uJu/cTjApbDEYvTLMJunuwQ
         GPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788913249; x=1789518049;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xR8s+UHGZfc61IgB5XEcMg1cwxtjDg51Pfcp0sYGqLY=;
        b=qj4wmeRV6jwpFkkjN9Bfa0+JfG8+zbF9pYtsuqjO7m/m6ZF3q07yOjsws+TENV6FXa
         7RfwsNEGm2B/LguMxBVhLgoMLc/wHZDWeZGQ1Vl0tpg03HydcyLLI5dTBsvZeCiSLgeI
         fHlN+p9Yti4ZyUwabFayn4Yp3QgZ8hY8dV5vyipDzP2QkqUXdbpLWpnaA5/iOj/+JHkf
         ljIEpEDv/hXQioBaUlLPrpPaWYae2U6sArmhBZ6fU8xqLo4SxSENjuYLqiqplhcJb53w
         CoLgNS69r/N2mycacvbql+FERB/kpYBsDq4M04SSt940kuXV+o7cbQN+lgeqtSKxfW8p
         PgrA==
X-Forwarded-Encrypted: i=1; AKwUvBwKettAhZyJJOgiuynHmI6FiKYhnwF9CABh6z+c0n5XQEi0OBbVKe9JIBjZakLvcfX5+5HNQCVZjDt17NJzbA==@vger.kernel.org
X-Gm-Message-State: AFuF++mLpiTRwKmkP1w2ZKbLr7rVmrJ8p6UpbfGJ+HSf73HGcvZ7oHLV
	niOh4slgFUfdVjxJR62tU7Cj/A+x98mkjL2545WD8zdFHI8Kxb3d7T6ERYIZrxte3Tx1fOXSRIU
	9B8u2UJ4AnYFwJrmwUMF0HHewEERYwkflRQd7gH4WxNs1B3XRRTXLU4+2m6QmdNg3ONmeQg==
X-Gm-Gg: AYBFou1HrJZ1ep6VwYg7REydaE9ENhwdXe9vI/TreJiHm+4b94vMfViaCxM+Ke552W9
	aagO1paB1jodSERuKLdTHPf/veqzvISWTomErgBeM2kG6Q72EgbMpqU8LhrXCNDE0zM77oKMYcv
	gLbUnfM+5jXYoxNQcz0B2msFIsNdplBIWxP0mV66vJowZMpdtYs4C7L/bf87JPNlUuoaKyceM9p
	DwTSrkh2g+tihYZkOmAruqKg5owizo4Ljon0sfIcQqngZzVxQFAyBzHX2/FttJysD1bjDGxO52a
	x83GdaWF9cmg5WMKW2rlfqR43CYD37HanYQCnFsKOWVixDvmMaj6xuQEnyIGuSSRuFxw5YdudgM
	8oBjRILOqnEkajNcUqb+bo3HBNBl88G7APCC0CAEknuC+sNvwl/MwYfY=
X-Received: by 2002:a17:90b:43:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-39b26141c79mr50483356a91.11.1788913248718;
        Tue, 08 Sep 2026 17:20:48 -0700 (PDT)
X-Received: by 2002:a17:90b:43:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-39b26141c79mr50483286a91.11.1788913248317;
        Tue, 08 Sep 2026 17:20:48 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a62be87sm33243326eec.6.2026.09.08.17.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 17:20:47 -0700 (PDT)
Message-ID: <e7089219-ed02-4288-a678-660a52289e61@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 17:20:46 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
To: Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
 <20260908125017.0fb226c5@kernel.org>
 <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
 <80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
 <20260908132004.29176fec@kernel.org>
 <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 7tcVhmc0sVoeLFM4s2WrW4CLjy0dGbGN
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDAwMiBTYWx0ZWRfXwRfJZ+9ZCfdo
 JZjnS2eNsOpHu4/1ZvDwAhdRbSAbdVidw8QbxTWLIZzBL0fS+H0axzsTE3a5/GRiO7tiPsSjVTQ
 o47+rcjYMBwry/fbikIu9xrPIyuF2GI=
X-Proofpoint-GUID: 7tcVhmc0sVoeLFM4s2WrW4CLjy0dGbGN
X-Authority-Analysis: v=2.4 cv=Bo2tB4X5 c=1 sm=1 tr=0 ts=6aa0a661 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=0LwHWvLHShGMNJdCInIA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDAwMiBTYWx0ZWRfX0lXpoOSiTpd4
 +00tE3lSIRmzu3VklmZalIDZihrsXHc/jpKYkGE2CYH8Jqtfg22d5xSPoBRlOrdwiplgdBrmUta
 b94xHVmVFJ2qZRaPD+tErv5bvgVkfcMqTLNaC8+UL2PS5AS21iU//pz3r074TuZi9BvZJXlLUMb
 bd10ks4D4lEX2gEXvaXNYNRupQdD1Pn/9S03g40ObHFNL7uNbVh6NEl98zFbjQqBsmwB8WAIsze
 6EODz+CwZT40tJIrZadlCJCj//EqMqsw1F9+cpIebv3/8IzYQGdlTsiaHpMaVEyO6wTaBkP7czo
 M/vGTvM5GdLUcmPQ8KwqMLhEer4AWnUrPkaO7vOjM0YIUBcu5Dqp8vf0fbWhawbhJ76xHOJGZh6
 LjkXHmnQRTzNzA01OmJ/fPSQUUlnQWUu/X+Msfvha+uLqGt9JPC+ZcC5aYY1XWOxnmc/vGpbNyB
 JvGta1UHLyhBvuGttNg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090002

On 9/8/2026 1:27 PM, Johannes Berg wrote:
> On Tue, 2026-09-08 at 13:20 -0700, Jakub Kicinski wrote:
>> On Tue, 08 Sep 2026 21:57:52 +0200 Johannes Berg wrote:
>>> On Tue, 2026-09-08 at 21:51 +0200, Johannes Berg wrote:
>>>> On Tue, 2026-09-08 at 12:50 -0700, Jakub Kicinski wrote:  
>>>>> On Tue,  8 Sep 2026 22:39:28 +0530 Pooventhiran G wrote:  
>>>>> Why are you sending this To: core networking maintainers.
>>>>> This is wireless code, what do we know.
>>>>> Drop the core maintainers and netdev@ going forward please.  
>>>>
>>>> They have patch 1 but I already told them a long time ago that was
>>>> completely broken, I don't know why this is happening ...  
>>
>> Ah, missed the skb extension. Obvious AI slop. Fun times.
> 
> "Look Mom, I can push a button, I'm an engineer now!"
> 
> Do we have rules? I'm currently refusing to read anything that has an AI
> written commit message ... at the very least.
> 
> While I was on vacation the AI sloperators were arguing with each other
> on the wireless list:
> https://lore.kernel.org/linux-wireless/20260827074442.826644@enxio.de/
> 
> Can I ban those email addresses somehow?
Apologies for the AI-like commit messages. Those are at my prompting since I
want these patches to be understandable by folks who may not know or
understand the underlying details of SMD roaming so I requested they contain
enough detail that referencing the spec should not be necessary.

AFAIK none of this code is AI generated. But it has been AI reviewed
internally by multiple models.

/jeff
