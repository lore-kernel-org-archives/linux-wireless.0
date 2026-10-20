Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485697;
	b=Vr0dlIIwvruMV5LXZKa9sazsklScehPBxyO3XfVPC8rkbhhr304FHIfVfg9qoM3y+Lxj
	 q7xz74ycGzjZhk6A3GUXQRxABJtirFfXdaK1rcJWSW2yp2SHUV4WHh7qFbhmDpXi3FI2c
	 /+SIK3DOXecIlnorC7eSr98Dyiu+dtAxYtM/i8dNs9bk7iscIi0H7lCkaMZF6xIVzVmdN
	 jM5YOo7iMWNdVXRyjkD/DVikQlF2jEV3XonYL1bSTO+XZoPCYvuGoRWA/daLN75L99YFH
	 mAO+9MDXhnySbE3Tzk56/hlP+FBGeI6DhW9KQRcy68QezcoCbEyJ01e9C/TrI/F7S5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485697;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=C0F7Qr64T8vgIgJx6fh5eCdIiZjLiQKaub8Hq/PVVak=;
	b=ESJrreTm7ht03u4dup8tRPcw2md8pNDug7qW6J6eIFPulEOraIZChKSCBT0DdB/zvkuo
	 ur2/ynY2z4DWcvCWtTTRIUyjJzM/aI9+fbjlZEbxohY2kf2ZOUIqmTp2soaZ6uDjebghh
	 yhThVfrX79hVu2zAu7Kp/WtqEHtQP1wbliqUpbISyu+USHqFGWTR4a4agqper3DJ3vWSs
	 wPFXmEckRW4BEFVEX4MBzmYbReNqNKa74QzTfjusb5ENOjCjJVLT+34oFZUYddfh55lYa
	 cBAITuPOGv4qDDbfZszg39pDmy2j3ghejPgQx7qsl0fpkiUCC/xwT103pumqNlyHl3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W28KrUrB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SeG1rRau;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65602606A327
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65602606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W28KrUrB;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SeG1rRau
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69K8LDNr1211286
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	C0F7Qr64T8vgIgJx6fh5eCdIiZjLiQKaub8Hq/PVVak=; b=W28KrUrBKiz4w8Ec
	Rs+OrSmMHWy3N1RcagyI0NJ9E5zW1qEmNDibvU9Je/LU5Ioc77rP0YloMFuRi5aI
	lICjajkqEmIkuIwzhWoDNSpJXduyAquWJc8xfr6iEbqjd8Xr4byC5anHZO8bpBeP
	4NxYWQSnTT2Ecf+U1v4oglp7Jz4AqwvuE54GsrI0AfqW6a/hz+lsiYEw+qC8ob5R
	nIo208S7bKjNKiE3JFp1spVHPnFAEzRECQGhFLPWB6a3G28zKHZ1yqyvInqQIUD6
	OFeZ0HiSzUyy+6wEXL9yQF35wNDghtplmC0e4h5zEjRRfpsMtE14pC+VG+0v/tqC
	odM41Q==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5p1p00-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 08:41:31 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso2936348a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 01:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792485691; x=1793090491; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C0F7Qr64T8vgIgJx6fh5eCdIiZjLiQKaub8Hq/PVVak=;
        b=SeG1rRauC6Qt7VAO0+6GN17iflchd+CaqNl6d9NomztUVhrY3xiPZ2Alwuq6AUvGCc
         AT+8zZ/lSGKGa+WR2K39pnBU/Fd9acsyfrcGfRdgoZShdOJ3IeR+fUVcnfX88oY88U+T
         YQ+yg5hQYaPKeaiPRpQkqvReYzazX/RTTxhz14jdaH43ETxgArnhzKXQxsyYad9eM08g
         k0jcQU2bg8nNxXRRzgfdOG+iZk9OzYNPTR4fTV4GufzXBobYtBa7yr0ay6iq8PnmLd1Y
         C9rixPNWUYJzEu3+znoa0+H83QFLH2LQZFZfSqLlZqW+P+Wed/jwOUWgsTJHVzZHpwbz
         94Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792485691; x=1793090491;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C0F7Qr64T8vgIgJx6fh5eCdIiZjLiQKaub8Hq/PVVak=;
        b=eeFgT0Wo0IsqhKLAocvUEh1ZjghBwbV3n4kab24oGO0WokOAHhW/6c+v/rxyyBm9ZY
         ecuOL4wbD+NplvjO2pGYXmZvjPZ2IA8jv0ua/TfTT2fnvYhkR0ESn0Sj/aKUUyq+1zty
         +yYgFdkAWfXH7OfXIcCnDjqVRWoFNM8BKbJRGhYOfrdYEILmgDD8TzQs32v0vnNq7r3d
         YEYiVL+JPFBCIRUQA88kAbmcgSmJKf5JKUeGXdbW7k65FaYUE5QyIx3hU5ZUDd+a6e8e
         g35g7GaRkpofpo9Q9rvgu5LT/e4HozjIlew9YOkB9304bBElbQWMar5tbGUgxNsSuA9D
         6ugQ==
X-Forwarded-Encrypted: i=1; AKwUvBwdKWu4WM7PNMFoJnpAPIBTw9XltMVPxk+NbYMhTMZNqLBhLNHmlU/pRspU84jSy+UC4yEQsO+sxlgMwqRygg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL96iLyNc1TlA8WJSyhZi6dWaiVfdbakDjiPt47d21Pi7ngk3oQ
	myzlnUXuO4Fr5xPheB9Nn72S32wQVmANzMCint9I5RNqptCArthX2Y02485kn84xfwdw/N6vivw
	jlEQoUUNTPvoqB5cIBV3+Gn/f8ApFrqOBM4mbVmkleg+nXxVsZ3H7vURYMSOoPYDdl3VyG+TV83
	hnQQ==
X-Gm-Gg: AYBFou1HbteQn4oqIoqUE+kG9OJo3wF3reahtGAc57gnNZ2ieL3hZP28qLUy+UZOUaY
	9Q8Dskbs3LE34VTlXNUCxAJgoGCDT5+tT41Qbw4Yf85xAe59N6IzfFtm9XUyEVz2Y0M4w6s0CMD
	Sh2zVb3ncj2O67YmPoN0Jpl8itu+uoFFeiE6aPBcsF4KaKL9NIP2e3ygIMmeWjsvxTJzn1ByXgR
	edLxUaj7YmgP5FOaFqRiS+blGU3F0cz6pVO1FiargyAw2XZ/JSAAWs2wH5f2ScLjcyvmx4N62rT
	D7hVm8m/pP6lYje1PAEZ/PvgswgFO3CKEjBudfdcFtRmmCmLLk1LL9LymvdRyO67nBU8jiTrIcd
	EvZNEuqC/inI6CbFJ0oXzArh/3cQFozIV5TmIka3tuwruEzzTy36ofJvxXcj3EaO6EWneB++N
X-Received: by 2002:a17:90b:28c5:b0:3ac:4e18:237c with SMTP id 98e67ed59e1d1-3aced87290fmr8764726a91.0.1792485690894;
        Tue, 20 Oct 2026 01:41:30 -0700 (PDT)
X-Received: by 2002:a17:90b:28c5:b0:3ac:4e18:237c with SMTP id 98e67ed59e1d1-3aced87290fmr8764712a91.0.1792485690408;
        Tue, 20 Oct 2026 01:41:30 -0700 (PDT)
Received: from [10.133.33.78] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60f8ae57sm2624196a91.12.2026.10.20.01.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 01:41:30 -0700 (PDT)
Message-ID: <4f2a06f4-601b-4e96-826b-a5453bc03ec9@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 16:41:26 +0800
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
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fixes to improve MLO station
 stability
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
 <20261017080444.41177-1-jtornosm@redhat.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261017080444.41177-1-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: vQZCO49VWs0MsF43b2Pa1UrNSHpKKy_a
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDAzNCBTYWx0ZWRfX7hnQt2tFhzKA
 +CZKBi1NZcjR6Ye8OmeAlhb9bNH5ClVDeUwkI8roB/NeLOPo6CWc9/tcl9kC0KnoZ3S0sV1G0FT
 6b9Af3Xg5V+2oSCH0h00qlMDGED/Kzs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDAzNCBTYWx0ZWRfX1GqQv7ErkIBz
 IP7mM1B4VYqaRlgJo3U/CoGgZiF82NrpUmASM2/tC5WKz9RAbki3G/AkV7XSbh8IDgGJRJyKKAe
 R88DbLJohVBEC5CSjj60yltqieQuZ+yFKF6HTSDxkXl7kIa4ScZ2CyxLKxo75rpuImVd5XmoxBU
 zP0GW2AD4vI66DlJvzVM3pGmzsC9BiycJ3SYYJYwSDurVYc4/rNTwdOIDNOlq0gdT9x9UwghCSj
 LY9Xr01kwQDu7dmzblgl1N5iJzNqUMq1GEObNbF493WItGSElY9B35LTwoz5KFzvdiS9WCgZWoM
 jRU3CjlyeLigpbKqgUK+n+wz/qxsNAWQEJNEoXeKzPS8owILEN8l6QUPDwquYyHxVhxW9gBf/ik
 NYFTn8DQ/GDclxwuUKrHx5NuhJUHbphA4F53w9jMgcIAIme1PVLOhp4zFpB0Y1OgWKFYHI7SpqK
 iXcRobm59OVB9VH+bRQ==
X-Proofpoint-GUID: vQZCO49VWs0MsF43b2Pa1UrNSHpKKy_a
X-Authority-Analysis: v=2.4 cv=crUOAF4i c=1 sm=1 tr=0 ts=6ad7293b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=k-oXM3pZaSIHxhfxeJQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610200034



On 10/17/2026 4:04 PM, Jose Ignacio Tornos Martinez wrote:
> Hi Baochen,
> 
> I agree that per-callback guards don't scale well long-term. Johannes
> can comment better because both alternatives need mac80211 changes,
> but let me share my thoughts.
> 
> Option 1 (recovery inside .start()) holds rtnl for ~1.3s, that seems
> too long to hold.
> 
> Option 2 (split ieee80211_restart_hw() into early barrier + deferred
> restart) looks like the right direction. It would benefit any driver
> with async recovery, not just ath12k. But it is a mac80211 core change
> and a bigger effort, and it still needs in_reconfig checks added to
> callbacks that don't have them today (scan, for one), so the guarding
> moves to mac80211 rather than disappearing.
> 
> In the meantime, the crashes this series fixes are real: without it,
> an MLO firmware crash gives NULL derefs and 20+ second recovery. The
> guards here cover the callbacks that actually run during that window,
> not a speculative list.
> 
> I am happy to work on the mac80211 side (option 2), but would it make

Johannes doesn't like option 2, let's forget it now. Instead, are you interested in
(working on) option 1?

> sense for you to land this series as an interim fix while that is
> worked out as a follow-up?

Jeff can make the call.

> 
> Thanks
> 
> Best regards
> José Ignacio
> 

