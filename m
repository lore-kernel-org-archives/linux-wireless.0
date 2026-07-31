Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D640C345EA3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535448; cv=none; b=r5ddrRatrY3S6HCnrgeOSUHvdbxB9w2mzlS0Fn/da5m6Wy64pctpbrSRo7yrJZPH1KH5GEKGQfJf2UXWxpgk2T70Lt/hX+vLrekhHV13uljv6o1MGrGPxpQNvuLxgZuNxJ1FhQZ6s8eEC0SAqSD6lDmIqanilBNcMyPuDikK1Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535448; c=relaxed/simple;
	bh=wprVu+4rI6oZhTEdzwm6VygX6UGfweOUmvNii/btMF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e9oTbR+GU2p54mmUfz3wc3LSy2HnpMNigQyMOLb2o/oOcUCiYDWnvWINeDegWGEDstqUW7yjGDqvGVhtaiwJUlGCC/if7FVOJ0Sjee+GjbpupoHNCpMG9W9IOxOoQAOcEo6wyEJQ8VvnqvS2vxg0E9429Y06fcTUVhaqDCu0VKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kU1raL0r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AOu7sEX6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kU1raL0r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AOu7sEX6"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VM0pce1096987
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 22:04:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	djLiBrCrntR2/g21yzu3z+y0eymgeWBUmxdBpdNDfug=; b=kU1raL0rs+7Krbr4
	rYXNg2OZfV+iaVADXFJ5vs2lOpu0FOApn3zvlhKWoyFpPeIuOEGMTXCXmphnyxpa
	bHEOLNiZBQaB2uZ6GgWY1AWMzzHojxBqeRUl6KVEBwyZ2s4FmKY7nMXctWzPBy5H
	qgBkU7ytWCvP5MHVlUL1/7bKS27FM3Q835/do0Ra0WHHfArak98kD98A/qOXkD5Q
	b0LAcqlqJfl3p2yVY0bneAWqa9YchV36H3pMPkUCMJZmPa5tYkyJ1qcGxr1bw/ka
	vHKWK6Jw6Q/KCsMlrJ+tdmJauJHYJDtXLgp16dQ+fNigSSuUEe6po3W+vWbY/cDg
	C8M6tA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frujuth9g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 22:04:05 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d001671a54so28303625ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785535445; x=1786140245; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=djLiBrCrntR2/g21yzu3z+y0eymgeWBUmxdBpdNDfug=;
        b=AOu7sEX6Yheku3Uhea8M5o+s/wMsW/mxKSDWQCtNXvcGmW9i7OCgUKh+mSZCFRLdv2
         J4uzs2DB3zMIYn93J+PnMiSf7vqsojurPFKl864MjBwZv/7KeWMHf1iMhyqFLW9dGy7h
         8PyVOeXW1iVABvMuC5cwx8Yvj0t7d0NeuCWK+jVIn44Uu/dtOBErzRUDf+RliLp4QFPe
         VCDwRzPL8HffWcSP/UsKzXKEjzk5XWpytfjV62eTI8Gv7dNL1FFC8YajuMrXio9IHlpy
         mZCUAusK4iPXAvdzI2E+R0HMCSulvZ/8OQSCDcBT8nBUch3wBwh4saSvbIF82T4zcW6K
         484w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785535445; x=1786140245;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=djLiBrCrntR2/g21yzu3z+y0eymgeWBUmxdBpdNDfug=;
        b=Z/9C+2nGuVAPzIJtKcLQusyBDbOO2L7ZvNyEV4TbASNljszWgdh3glQNt8fFBJrqcO
         cWlMv/tQ3hxv0HrLuwnNeF+40brBqhVlICNM7AAIUJ/2YttcVy9TUzefnMWA3BKhOnQZ
         XxQo0S5xu83D0XBOPL6EJcxg4ROUsshVCvKhFxUhO0Os7gvvr1IJqM0KnEAp1tS3CdES
         tNjeuNO+0ilJEVWIiwEWA4ec9OzhM+wZBd9O7vihyPdZbQ/AwzXLmRYcBWT7fCwp01+v
         5j2s9V1F5/AccnPtuUv+nol+Fy1fj2ejwZ0yOKrRM8TTsHhHBH8QoezgWPXX9y3/SrVd
         SMrg==
X-Forwarded-Encrypted: i=1; AHgh+RoRdbGFuYVkbhlJ7tXhgrUOkWcOIj+w55TeL+0d8lip8t0uQ7VLpQd0RJtxhJXITmVZ2s1MsYq6VbwrDHcdrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvgmJREjMNWw2mgwa1sW4G1fP3uqO+iugbbJrMPoULlIKU3G8M
	9lmzYm9a0tBhti6AECmic0EUViMkTGXAwM00gunetVow9RCN0WnLeEaG97jjrz97TZKBdnqixTd
	dSjOz7v/NH27J54BtDNaHjBupbta/+tul9+nOphqYjWKwjsHSVBD/bBUXsXCENomuwOGsLw==
X-Gm-Gg: AR+sD10y8P0+xFhAj2dSrRKDEj3tGkg8U98GiwDylDkZ1rkQyOj3Q5cqBC6WvLZRZ2y
	F8oh/XwxBSxIQNoeNcXRDJr4aO9ng4/dVhcHl5eimHABvUt2TdwWvsxUo/qd25Hw3cw1/7IdFj/
	hI5ixIw9gByOsqU9LVe+o/lY2wXe35IVJs/FF2r0tAM79CNk/xITRUeUMnFXgtRoRDu/O2L19HP
	Az9u9QWQ4hv/7wEwkhA3RaqLCbJp8Iq9tLYaiECk9OwSVbi4M40+eE0y1Pok6TnCQyZ94ZtwtmD
	cM2kEWIjnPIH+8e5lGZUK4NXgD/7OW9vCCCGG8tewcoZ2SDsZDtYdWDRMLqFL7WBKTHulI4ivJp
	hrwguHnFo5ehoODTmU7YGnOpvWVtViHIjLSUG7HjrxPaCPmF8e0XFLcbt9eM=
X-Received: by 2002:a05:6a20:4499:b0:3c0:9c19:65ab with SMTP id adf61e73a8af0-3c92a9054e1mr1240320637.67.1785535444669;
        Fri, 31 Jul 2026 15:04:04 -0700 (PDT)
X-Received: by 2002:a05:6a20:4499:b0:3c0:9c19:65ab with SMTP id adf61e73a8af0-3c92a9054e1mr1240278637.67.1785535444178;
        Fri, 31 Jul 2026 15:04:04 -0700 (PDT)
Received: from [192.168.1.9] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e04491dsm12966664eec.16.2026.07.31.15.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 15:04:02 -0700 (PDT)
Message-ID: <a9565939-0ff0-4672-a733-20692b9f9f26@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 15:04:01 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] wifi: ath12k: fixes to improve MLO station stability
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727162748.963275-1-jtornosm@redhat.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260727162748.963275-1-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=U6Giy+ru c=1 sm=1 tr=0 ts=6a6d1bd5 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=vNYMOvrsSQ6qDk_1z1wA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: vwcxaEwxn0Fhyk8epzfzPuQszGeMim1V
X-Proofpoint-GUID: vwcxaEwxn0Fhyk8epzfzPuQszGeMim1V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDE2NiBTYWx0ZWRfX4nUD7v2770xB
 5JYzqAzvVXTIbLwjkpt3bSVIoO5vIwsAZKV3CiQp9mc3OcpAA8KOlis73/x+Z5zBKazNfdmMSwC
 NWYXOQ0JmshilKbbFQlX6opPs0Jr5ZjYpfQYyss1XtdUabj1dQ4W3liUGyqggLUMzWup4ag+b8h
 o7CyfqC3ofr5HUPEIIFf6GDgnP9XLKD1aCUprjfOIETGjxHfYH/TlKiR8lHJ8/b621o/26+LFid
 P4+sf+o6Kr5cudOS7udlxVq1lxt8CWyzX0yT/DOjim2iuKOH49M+6TSVpiFy2Clm5M/EqxN9uaB
 iuA0yIn/ZV3FULBmITqNwWyG6FC8UweCk619jpDLWn4h6TIbXv/zPFMMQqV8y6UmueDUlb0Bupk
 kEuGF+Mc9O0Mg1+sRVNtRWvQ34wW3FEE1D6+fOKx0NjUs8rYWfYJs52yIn9u8uAqs/ntRF56SlH
 Cm8TbLHz4cIyYmMDmjg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDE2NiBTYWx0ZWRfX/6h+Gdcgsw8G
 8I3QJOJRUvgQXsczS1zeTmTl+GaTqTNEY2YdstSYyB0tfL9UlZhx0aoGJSTL6pu92nKTGL6+eVO
 p2S3GAtrhi0ao3Wgdjg+/vtnT0fNxRc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_07,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310166

On 7/27/2026 9:27 AM, Jose Ignacio Tornos Martinez wrote:
> This series improves firmware crash recovery and connection stability
> for MLO (Wi-Fi 7) stations on ath12k. Both work correctly for non-MLO
> (Wi-Fi 6) stations, where the driver handles the full teardown and
> reconnect cycle without issues and maintains stable connections. This
> series brings MLO to the same level.
> 
> Without these fixes, a firmware crash during an active MLO connection
> results in kernel warnings, NULL pointer dereferences, 20+ second
> recovery delays, and periodic disconnections both after recovery and
> during normal operation under heavy traffic.
> 
> Patches 1-3 fix firmware crash recovery:
> 
> Patch 1 moves the RECOVERY flag clear to reconfig_complete and adds
>         CRASH_FLUSH guards to prevent operations on dead firmware.
> Patch 2 prevents scans during recovery to avoid NULL dereferences.
> Patch 3 fixes ML peer ID desync between host and firmware by syncing
>         the peer ID from firmware's actual value.
> 
> Patches 4-5 fix MLO beacon miss handling:
> 
> Patch 4 fixes beacon_iter to iterate all MLO links instead of only
>         deflink for BSSID matching and connection_loss_work
>         cancellation.
> Patch 5 complements patch 4 by skipping connection_loss_work for MLO
>         entirely, since its cancellation mechanism is unreliable and
>         the mac80211 probe triggered by ieee80211_beacon_loss() is
>         sufficient to detect real AP unreachability, as done by other
>         MLO-capable drivers such as mt76 and rtw89.
> 
> Tested on WCN7850 with MLO (Wi-Fi 7).
> Firmware crashes were observed to occur spontaneously during normal
> MLO operation with intense traffic testing, though rarely.
> The debugfs simulate_fw_crash interface was used for systematic testing
> and reproduction during active MLO connections with traffic.
> 
> Note: I will have limited availability from mid-August to
> mid-September. I will address any review feedback before then
> or promptly after returning.
> 
> Jose Ignacio Tornos Martinez (5):
>   wifi: ath12k: fix MLO station firmware crash recovery
>   wifi: ath12k: prevent scan during firmware recovery
>   wifi: ath12k: fix MLO dp_peer ID desync with firmware
>   wifi: ath12k: fix MLO beacon handling using per-link addressing
>   wifi: ath12k: skip connection_loss_work for MLO beacon miss
> 

This series doesn't apply to ath/main, please rebase:

Applying: wifi: ath12k: fix MLO station firmware crash recovery
Using index info to reconstruct a base tree...
M       drivers/net/wireless/ath/ath12k/core.c
M       drivers/net/wireless/ath/ath12k/hal.c
M       drivers/net/wireless/ath/ath12k/mac.c
M       drivers/net/wireless/ath/ath12k/peer.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath12k/peer.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath12k/peer.c
Auto-merging drivers/net/wireless/ath/ath12k/mac.c
Auto-merging drivers/net/wireless/ath/ath12k/hal.c
Auto-merging drivers/net/wireless/ath/ath12k/core.c
Recorded preimage for 'drivers/net/wireless/ath/ath12k/peer.c'
error: Failed to merge in the changes.
Patch failed at 0001 wifi: ath12k: fix MLO station firmware crash recovery

