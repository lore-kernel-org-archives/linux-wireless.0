Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0104A43F1
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145825; cv=none; b=A5FqrXROTRXyyJkaLrVSjFNuFjI0BwqIc0bEdMbI54HlmjDleaanN5DyNhs3Cd53qoB5qiFzVCuh9QzxAfG1nanKxcNXVQ4cx8Ad8HMwL4erKJYtJKijnCwZHoY1e/IlHqzsau1XKXR+3Lh1MjCzF50kWWt/5pNrSQmY4xiLyy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145825; c=relaxed/simple;
	bh=B5zsMF9jXLjD3nL08zpdAaYkM+jIqmHqIB3oqoo3X+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FkI/wa53gaFmC2+3tp460CM6kdNSJQwbHGalZCoFF9FaOpDahZPcTNLBJqvA+uDEXcyKE6nCkSokQfY3dEAbJAoeUlJpcdo98F/pPcUPu8tlntlBTTYf3hqjb2Zno0/cqEs2CCtnONvPUJ0uRFm+7yJH8wJ/GT+Xv9zfxH5AFA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BdwA4Xf1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TabeQBJ8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BdwA4Xf1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TabeQBJ8"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BFA7v8658319
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 16:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3UcQ8o/UhhKDWN6EeWPHvZdLAtvo7AwnIb5UulqyAYU=; b=BdwA4Xf1JvbJTH03
	VUt1V3LjI+vITHShfAP/WJnsIIcguJ/e3zU6miive28wBO5VHP09RllI/WWM2Ekg
	tqHru9T8OkchkxuBLH4UrVCD0qKc/Lml5oWzav2yGwkm+vuTApbMtny52K/9uhvj
	x8LtMqr7P3tGsMiP2CT6+BW6xCNC3B1/huD3AzDYSnBmoPSXSfau4mCTLzMLUySE
	CgV4c+Dd5oAfidboegmMCiMWucnTCQHRiBeoq4KsX1fEfnWrJdJ7TpC3MBtZAiHA
	e3cPNWXCULM0ODtmVTQNwlBwz8Tv3xPactx7GMmVyH4jZGBnBD99NdJeCayv+GhW
	+jeFGg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmm22re4j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 16:56:57 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2dc7337e2a7so13842975ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789145816; x=1789750616; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3UcQ8o/UhhKDWN6EeWPHvZdLAtvo7AwnIb5UulqyAYU=;
        b=TabeQBJ8pF98j0qjHeJt/GxQkTNdIlNI0FeKNW3ih4eFlAncytmydOYAikgITNPVB1
         naqlsofMs8XcSVK+bkTfvL8pbuvmfTkcAVJztJl7avpN2E5c4jlM8KI8iQeY73zpoRqs
         2PQIy/blRmoWBDIbOWA5Y6tVEzkTJrLNaKJaJy5vHp6uis49gUDshR1RQz+aIAuo5DwR
         7PAc6WM1A6y1GAPWAuvC76lOI5WW95JpONDEKABwb25Yp8sRGLceDw2tp1Lt6Yw852VJ
         69b1ysmA+1kasgY537xaN+5UNUjlmMVvWAALgB7bcJx1VWL3I7Qm5/OLORBoCDnjadtH
         EZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145816; x=1789750616;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3UcQ8o/UhhKDWN6EeWPHvZdLAtvo7AwnIb5UulqyAYU=;
        b=ZfqcWKE3ETQSZWP8Uk0KbI72usn0ZjARc1pq7KosHfQlab49+rHnRsXhsAmWBqFpq2
         vq7XzdlZZWIqGuGHV0T9QAA2cgdWqC8KepTqlnbJ+PU+W36KZOWmIMgOoeqvodxBvJYX
         WjgacWAPpb+RDEYmrtPkeNxP6qCie0v7L4BYn9AF1FD9vpmfVhvbvB+UOYwHCChSKRyX
         xssNoqjyUVln1InC7wR1rvdQPxEyu4EwmUV1+2MkAMer1JH8VRYcCT79GA19r9XmJGTF
         0rCsWJDkqw9YNm3dMyoO+/DPYKVKp9Xmftjj0R5Y7vDb7FeK6cLXXPKt00YyB2X4501t
         0hWA==
X-Forwarded-Encrypted: i=1; AKwUvBwufC0PpL1ENIW9Ib2wkrovgJr1KBtMKh9O4L+Y1vIX1vm4CIcq0YqC3A58IpukFhg6Hr33AdEzbhTrZw3e6g==@vger.kernel.org
X-Gm-Message-State: AFuF++lZt7nPL5TJ1KgStEAjk07ZwjXn3TURenb75/KnPR6dWtUPozx9
	Qi/GMDokhKPyzqEJRFEmmFplIaTfcZ4/3pxWdfC/UcPNMTwGSShKWN9b2jF1Qauiqw32CyzhHk6
	/3UHcqzscUS+5hHZHj2j+a0tot30do7ZbFQ3wvA0FgNwJy9ZtF+cf4A5eKFlwcMuSe0v9UigdfW
	iVfQ==
X-Gm-Gg: AYBFou2yZ3wTXrYGiNulLqzd/UL7sYr1rY2FDnkc83tJfqADLAuX7R/r5Fuy+9tlPb4
	uG9C+By6zW8dqXYy/3KeygY4iS1kUJ2SUVcpx9Sc3Ebn3UhJQG31q8vg0bqlhNTRAFENNTrZexP
	5q/hQ4DrylWWwQtxiz+HeOX8q4QNff+VnbqnoY4aIMAzOecLJHrsj1LQe6FBFayHE3rO2WGPTqV
	20AHfjDnXjYrv4qYlvivlrlb6z1rWkmrjVZpbH+hHzD0qYnOpsbXf/AlqrxnceptloMRmZXzCwb
	mZm67yUyAY+CTFsLf3y5fyyAqpX88+D43y373mNcYQsaJXj/JdBPgfBRFThBCf2r7WROklulbC+
	Qv7O0uQM2XZnnRmXoP1VIRyFTq+ehSG+ymRczXfTg+b0ydBTFFxMHzuh2IZeH
X-Received: by 2002:a17:903:298b:b0:2db:53a0:785b with SMTP id d9443c01a7336-2dd2a347502mr105016235ad.14.1789145816524;
        Fri, 11 Sep 2026 09:56:56 -0700 (PDT)
X-Received: by 2002:a17:903:298b:b0:2db:53a0:785b with SMTP id d9443c01a7336-2dd2a347502mr105015655ad.14.1789145815960;
        Fri, 11 Sep 2026 09:56:55 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cffb5c5sm14206325ad.80.2026.09.11.09.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 09:56:55 -0700 (PDT)
Message-ID: <e8282da4-683a-4fee-a4be-f24d8b7414e8@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 09:56:54 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] ath9k: delete channel-context timers on deinit
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        open list <linux-kernel@vger.kernel.org>
References: <20260904212225.84813-1-rosenp@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260904212225.84813-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzNyBTYWx0ZWRfX61FKiY3Zxcgg
 3U2X4dcyZ06JHoj3fXaRFW23mY6NsTss1c1uuXWzjGAsbHz4WtCkbtglFS0J4N7NAbouxZKatmo
 GY6i90TKeIARShoKBEzF7x/bS5QuMEXmU0QkEAwglyNUDo7VNA3Czsn33Xd3bWe+QST3eht+p+M
 nxCebGhmKFNzMExAulPltmquvEw2uAmuzCy+dr+8ThCOYKrwJiKNeayzfdod5BjbYcMbigDwO6z
 px9uBwE5xC+IVGU70Ng79bXwACZEBxAcdP2zOEiJxnkNcC+VNkB3nhM/yyW0giHSblPfmP/JsNT
 PH2MxOaQptRVWkLYxydKyOmM8uLJXJXFUBBq5ZPoGVJqXkMNB+vy+KbL87GZTlQyBD77xe/4mSP
 lTeOsIqJx4TDuRsvF1PUHDEcXRolr6/AhIQrI+tnZD5aJewvBRUywxhnDGBzmh+NBS9gLSSLrhm
 JvRNxR4tyr08ltGAysA==
X-Authority-Analysis: v=2.4 cv=LPDz05W9 c=1 sm=1 tr=0 ts=6aa432d9 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=7eYl0IV7dGDCLOCTNgAA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: eRDZTYjeuasiyXZYGs9pq9tLG3_CTZ6j
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzNyBTYWx0ZWRfXzBi5oqvz1nXp
 uwEi6KNi6Y4fnKfnqUk8+hHllVCY1EhfYArbSt45eHPZdAfYdcf7MlXgOvLacyVeCFvqJ+QvDBt
 Um/kKM5hddCdxyjSMRNFtwNI5vk99Oc=
X-Proofpoint-GUID: eRDZTYjeuasiyXZYGs9pq9tLG3_CTZ6j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110237

On 9/4/2026 2:22 PM, Rosen Penev wrote:
> ath9k_deinit_channel_context() cancels chanctx_work but does not delete
> the offchannel and sched timers set up by ath9k_init_channel_context().
> If either timer fires after deinit (e.g. during driver unload or
> suspend), it accesses sc->sc_ah which may already be freed by
> ath9k_hw_deinit(), causing a use-after-free.
> 
> Delete both timers with timer_delete_sync() before cancelling the work
> item.
> 
> Assisted-by: opencode:big-pickle

Current guidance is to just have Assisted-by: LLM
https://docs.kernel.org/process/coding-assistants.html#attribution

