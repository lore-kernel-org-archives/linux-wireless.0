Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485453;
	b=ya/FNmLXiQ7lG/7TCJlr0BEiVW3aL30M1AzPsum+rawSTK+lluOkNwf/2FTxWkfrG2DE
	 90OT0nfrmJBKnH/w5EouaM5zqJGENierVKZwVvLN9t9PfaBCguuRzPjbZTljZXnWo7rBq
	 sL5oAPTgxZcnPqD7Va4u/u6d8BpVWLggxmH77JV/9pKLBMXPWgKTJBeVoqbcezrK75DrJ
	 IbpJZz05A7VZf0kIXhdOjfjJKjRr2Rv5b4e9Ed1pjEhUrKJ+NcdWDpl2Av8mGzluBpVbA
	 eyURypyvZ/W9u/0mGGtN0kMz54i9jeS/BqXTk3nr5SunbN+OkkD2cA0+uFtFiMp7xKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485453;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=HU9tUCUqcsJLWDgkm2AupVOmJfSMkAhKvtmhAPSm/00=;
	b=1VRIu/Lnh2tC330/H9aIUi8OJh4HSVeZPHYIpbPCRNqmMQd7fsNm7RkBkMR/D6mRETSq
	 dz9c/bqz6ldJdVFzlX/nLqGEFIYUc5tFchVJRcce1nB8oaikX1UdGB/enwuYT6VDR8BWH
	 CJmlA/QUC4eUOX/RLaRzs5fFLj3XRnQoYGWymZiS4eSDGvhNUlMuR0myMJYb/zC+QvRQh
	 BqpZB5usbmJPQ3K+3fYTiIk15ngKR8ngBi7wMnlpp3KNIOgihLoSs0ve0jxI3t1cTX9Cq
	 93Y9F0iN/aWBQdEsI8GLu9yDYOHqMImFzmgV6g3kR/AW0Sg8vKs608g9yAlP08x2KVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IccQvnrD;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Rk8g6xIt;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCC4606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCCC4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IccQvnrD;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Rk8g6xIt
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K8RdK21254519
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HU9tUCUqcsJLWDgkm2AupVOmJfSMkAhKvtmhAPSm/00=; b=IccQvnrD6BnBFmAv
	OG60Wr78t3cKbAbIa70H9REzsYKxbflhpbYPcYj2NXSmANT+2GbiA8gcdkYvkLTD
	mzZOwcG+Rmd2GgwbreXe7YGOz2X9Vd7Ic9pXvzb+l8056Bb6VnE1Bc42i9JiaKjM
	SMKkjiZ/Uwa73vkcB1vH6L1avb5WIwAkJKM0rkvUcI5QUpPR+drQT+YF9jIAA7dO
	hrGUCDG87meXIBQOkm+ezdVCPYCLq2+W+lCRTA7AeOTMUfQVYkFbKTCLLUAzG/bL
	sYQymqQg/PoXWMq8f1Eik+m81hxypCrOdwqDOg/dkBc+94I4H5yytLu+WvatLzY4
	AGOVOA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5n9mxf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:37:31 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cfc52ddc55so30966115ad.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 01:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792485451; x=1793090251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HU9tUCUqcsJLWDgkm2AupVOmJfSMkAhKvtmhAPSm/00=;
        b=Rk8g6xItNqAad1hKoW0I10KaX+vfoss11lKLMRkSjTy8PJL93DXkoCvi5jVuFBzynY
         90QLDCXErbqgZ1m4b0h/1YV9z7SoZu6uS0VIytd3bKofwfV2So78yGp8SqC8QrI8KMhB
         UcExwr2ZTeToB6W8/gEkN6jZwDZRftZeXM9eJg5keaHkt1DDfTGFBhgnhRLHWedFlJsy
         K0WT0+kUPEgo0yBEQEKgPX8dfC5GYZVJ4tHNsllL/vqLqla1Afej5m/765ZjL9UN3d2e
         SUkSPKBEIwGtv+Rn18u8/HCQ0+nEzaApUVtUURlJb0AV9uZSxU+EJPYk4A7LEkU1sT9y
         qPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792485451; x=1793090251;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HU9tUCUqcsJLWDgkm2AupVOmJfSMkAhKvtmhAPSm/00=;
        b=jV4vVUF4S4dLYW/gbCTSg7Y2LccxIkug6+0mj/n+maxW1CHM1gjO4qifQB4lncy9cm
         04PwmkykWUKuNuKZtefsI5YQLgh6++DbsPuwdaTGoiWferdVadzRKA/4wr0DAqp5kDAM
         pwIAfzETcGtvR+jnz1yP7cRZ0ga/REgvWuYtupLxaKDioEgOwdVGwOp2Ymuvhg2zqjiO
         WIR53GAPD2gehEYw0OgXk/0YIKjFvj1d0WqQ0Pl197znWQfxvuPGo4Ao2nnK4xnwTR0o
         TkvJm99O8IOtUO3GKDWW5MZpBnPp5G6fX7K9B/19T9LyvKuYhgf0Gg8xsMWelPCsGGYU
         +6pQ==
X-Forwarded-Encrypted: i=1; AKwUvBz34jlrXthoh21Bugoevd0DYJidnwBzmwlOz4j0tGPZ6kugmqp8KwJdYY+eb8ioon9GwJpnMN2QS8gMwq5EUQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIQAnmadTJxLBBzVJ2sTmz68Dr1PWYTaYBPu/cZ8WYPHxivzFNy
	MpfzPdDJp89GIHysd+ipKhx5dOQdAgyZ2Jnjf65CToMBQIy7LnZTDpW9jlsU4x0LA63SSjwbH7E
	OXTu9h6B6i2F3eN0EG+IHG5qIP0BZQidYbkC9LmwQB58xfG+COuHOgUk2T1BDtrl2nfiUBQ==
X-Gm-Gg: AYBFou1lj3zvUNPcTWrjod5DNqkak3wONl2K2oMIGQjS46U4K+/mYiCtBxr+h8gygm+
	dEAJ9ZAF83GSViBzIbUagqEMD6na0OwLuCkQLwyCw+cSFT4YXOcLOeyC510SgvcgruN7AGkfaxM
	a7iE2BJ7Jqea1IYxVE8fDQRDJpDFoxOBxDIPLKToByI0bbzUpw9PViL7fHka4ScX1THmbw+PA5K
	19p2XqQe2Pp4yQ6iIUkX4B4PzRampt6aayO0ipTJa95/R2ske4MKsaL5NHJ70+Ym/0tCsf2NWb5
	ZqZmFQJiYuh4UfC/jSQyEJutVho0Ngfd9y9wnym+PpcBteH3nt3y4vakdg3ga+90rkxjn8u6BXC
	d4yhYAQ86j4un2ZYIBmdtLlrbwSHXceVc2IQSvSD/zYrLc8Ty94jlAS1fVxzdBZURcStrGx/d
X-Received: by 2002:a17:903:2290:b0:2e9:3dd2:a904 with SMTP id d9443c01a7336-2e9a69f724emr81145785ad.16.1792485450994;
        Tue, 20 Oct 2026 01:37:30 -0700 (PDT)
X-Received: by 2002:a17:903:2290:b0:2e9:3dd2:a904 with SMTP id d9443c01a7336-2e9a69f724emr81145625ad.16.1792485450488;
        Tue, 20 Oct 2026 01:37:30 -0700 (PDT)
Received: from [10.133.33.78] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea15019084sm9823665ad.41.2026.10.20.01.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 01:37:30 -0700 (PDT)
Message-ID: <f0c329ad-a13e-4bd3-b630-c0137a5f42c9@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 16:37:26 +0800
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
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fix MLO station firmware crash
 recovery
To: Johannes Berg <johannes@sipsolutions.net>,
        Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
        jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260804175004.1761075-1-jtornosm@redhat.com>
 <20260804175004.1761075-2-jtornosm@redhat.com>
 <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
 <1c8bd087a5cfd54fbe2825f2fa19a7851357ba86.camel@sipsolutions.net>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <1c8bd087a5cfd54fbe2825f2fa19a7851357ba86.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: dflj2txFXwW73t_nk6AM9cJ--7C625sf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAzNCBTYWx0ZWRfXxO6Bbp+dbCsa
 Ky2kLvvkwqIFEdcAs/nZKeWqStg7gOSo5qQIlsSIuds9cLW65C/X6Geuz8Cd5D1XQvMo//mQurR
 tGa5GK1E+TGzdiWV8FGio8abrSztchlwRJKnwRg/vVqYKLLABhGd37wP2xOdOJYpLRYl2tq1rH/
 tvGPXIBr9z4o4oF2ZEnSsuYhLaLa8eIgMEPuqN4i8Ad47m+lRVvJvEvuTa4qBwGSeJM22Cqq7Yj
 +e5kJ3DoPVwHeEQ2ab4fqgCzZz56vxfYsZf/a6BVdD1ZA30YvCCQM23JCQLQsBaJYt69uBBORPD
 yxwsT57sC8xGXoVKx22k/067VS5VFRfCPrDNC+RgePE2ZI87nJHNuJixVtscHo3L0MkthSedJCg
 q4amGjJqgIE1dpBz8iomob5TEhpexzhLmsvSP9VGnbthQ0FWx3XEyM9gvfOUz+P2sVfAhp4pfyn
 V1+S145/3m2aSAXbTUA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAzNCBTYWx0ZWRfXweKkGCEgsKTF
 XmqBeQfHGQAud3G5x/BNaQ8I6wcZI2Gdj1Laya47fL4zoOVYgktu/qLCBFQ7qZXKqZSAgAw4jHA
 EboyzuvTBX5JG5QvSAdgRp3h3uQWO4U=
X-Authority-Analysis: v=2.4 cv=VI9IDNPX c=1 sm=1 tr=0 ts=6ad7284b cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=j4zPaZQj4CSWEhlzwlkA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: dflj2txFXwW73t_nk6AM9cJ--7C625sf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200034



On 10/17/2026 5:33 PM, Johannes Berg wrote:
> On Thu, 2026-10-15 at 13:51 +0800, Baochen Qiang wrote:
>> I don't think patches 1 and 2 are the right approach. Guarding every callback that can run
>> during recovery with a RECOVERY/CRASH_FLUSH check doesn't scale, whatever callback we
>> forget today is the next crash report. Besides, such guards don't help those in-flight ops.
> 
> So I can relate to that, but ...
> 
>> The trouble is I can't see a clean driver-only fix. The driver knows the device is gone at
>> crash-detect, but it has no way to tell mac80211 to hold off until it calls restart_hw().
>> in_reconfig would do exactly what I want, but it's only raised inside restart_hw(), which
>> is far too late for a device like this - by the time it goes up we've already taken the ops.
> 
> mac80211 has the same problem? How would *it* hold off rather than
> annotating every callback from userspace, debugfs, ethtool, sysfs, and
> the rest of the kernel with checks? *Maybe* at the boundary _to_ the
> driver, but that's bigger than the boundary every individual driver
> has...
> 
>> 1. Do the whole recovery inside the restart path, i.e. move the whole thing including
>> state reset, power cycle and firmware reload into the driver's .start() reached from
>> ieee80211_reconfig(). Then it all runs with the wiphy lock held and in_reconfig already
>> set, so the sync is free and no new API is needed. The downside is we'd be holding rtnl
>> for ~1.3s, which I don't think you'll like.
> 
> This is what iwlwifi does, but it doesn't take *nearly* as long. :)
> 
> There might be a chance to disentangle the RTNL from this given the work
> I did recently on disentangling it from cfg80211, but then on recovery
> *failure* we have a problem with cfg80211_shutdown_all_interfaces().

Hmm, I wonder whether the restart work could take rtnl only around
cfg80211_shutdown_all_interfaces(). From a quick look,
ieee80211_reconfig() itself mostly only needs the wiphy mutex, except
ieee80211_add_virtual_monitor(), which asserts RTNL. Though any rtnl holder that then
needs this wiphy would still end up stalling everyone while the recovery runs.

> 
>> 2. Let the driver raise the barrier early, right after crash is detected, e.g. split
>> ieee80211_restart_hw() into two parts behind separate APIs: the first stops queues and
>> sets in_reconfig, the second just queues the restart work. That way ath12k can do the
>> time-consuming part outside the rtnl lock while staying in sync with mac80211. This would
>> also need a few op entry points that don't currently check in_reconfig (the scan entry,
>> for one) to be filled in, otherwise raising it early doesn't actually fence those ops.
>>
>> Does either of these look right to you, or is there a direction I'm missing?
> 
> See above - I don't see how we'd really implement the latter reliably in
> mac80211? Sure, we have a bunch of in_reconfig checks, but ... I
> wouldn't really trust them and I'm not sure we can guarantee them given
> the surface area.

Fair enough, I agree. Looking at it again, option 2 would just move the
per-callback checks from the driver into mac80211, with an even bigger
surface to cover, so it doesn't really solve anything. Let's drop it.

> 
> johannes

