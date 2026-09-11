Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE754779A3
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789146389; cv=none; b=bn2ercQ40JH1RO0xxmvmJyLoZHMKE5ABPzzwhY1ueh9Bw/O4aX2TrKfy1KF2ndH3NSHMQsDqSGFYBNeDCk3sVXrtQdp7aeJcRUmW7YHoaGaYn8hDAY7eqzLilqPlgxHO8syYh/kODC09Cy6D6G7/oZe4WBFiDCQSE+UUyRP+cYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789146389; c=relaxed/simple;
	bh=jdfOT46mMGVnTtjhHdZMClmhgx/5Uauj11P8htZhivE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n8XWAn6J6a3u4mxlbo11CBfaZf6DsyoRyOHoN+Lfkvul4s12zHc968SyhAD1XcG1xkjqkWEKx1e/qjCT5qAAn+d478Ubm+4x0+yGamBVHsN0VwOx8/UP48O9uxJ+uZl8GAQcMwKZnG6dtDi+uBbJnzlb9D8h7yOwbvs3wS22c5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QYTMrLgn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CeHo1rj7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QYTMrLgn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CeHo1rj7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BFA94C658467
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 17:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jdfOT46mMGVnTtjhHdZMClmhgx/5Uauj11P8htZhivE=; b=QYTMrLgnJnLKE5is
	90WEf9uLcWVU08WxMgSpv12yf220SbNrnaxMqDSnA9pTp7lYmvWONr/D1dPOsknI
	KG/N5luh6LpoC//eBJOHAxJcZZPUg95qaFIFIQwQrRAuQgWpkYmg+O2hSdMxBti9
	a1UBAOVhMz7PeEGvVNKB5MAVwbVxvjUZhPG4WRQBntR2ebzv/qqVPxBc+rClG8Ux
	Bq3+0vZvSVenPWyRf4el19VVd42a5Do81HOeW0j5VjjYyR257Rvms6nweDsicZwS
	GOMHtsqQiNnqZmqmdkBWynYCIUzfyb15PKONtnBQrQrDEEQF9r5Z19WsnRbhxl3K
	nLzfEw==
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmm22rfdv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 17:06:24 +0000 (GMT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6b1413d9c19so1234446eaf.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 10:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789146384; x=1789751184; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jdfOT46mMGVnTtjhHdZMClmhgx/5Uauj11P8htZhivE=;
        b=CeHo1rj7iU4MobTBMuyfmdo/z2zkpo3kODA9WnXbARaviPtJXUKFkb2G3SFnXJSMHc
         UhXdED1HMAGmxHsg/nr2O1rkqPZUMJSWJU6W4rgRirsENkEpOI2kSI5n70lEx0ypfJb5
         JYXJd+s7WLLm+oGrKRi8XHxgb7h+MA8d9V/sCkpkz3yIPj/CA54Xe5OJbQ66bUgwXqnF
         jSrp6Rxs0tMsvaXYH8rkjxTvedNpa1I0DANryS3GfscZdCkwFpViSTMh7z4DrO7rFLJM
         +HeUaeHeflwUnPQrujp8maGnY1fisBfK62bsf9qWlOYfY1nWNAFx76/EECsZSZi3aUvp
         v/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146384; x=1789751184;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jdfOT46mMGVnTtjhHdZMClmhgx/5Uauj11P8htZhivE=;
        b=Ryt9bUjpJtmIhR6WACaJgUFqPzIfD4OUCnry1ohjskrCNJFDvkkGdzEkFrjlVQGBFy
         r+D9kzMOQVwD4O8EwU2uKDvduxPHme9KE8+Cd3BgBPWYpQE2LSL72uoLIOxMTENvn5uB
         YvHCaLwJfAEE/bnK/2n3lNeoBDGD/ZYEGSTQNExlpqHEF4fmXGkhTJUpiPcGNkDwen7R
         7wsK6UbmVuk8KCEEGwzcqmxh/VKYGCln32Y4vYZB+d/CxIffjl6QlgoUcvGpEQF+G4+Q
         F7tNqg8cHbprShdZGHMmMMK5cKnISmozF8DbhUtQT2+iZAOb/nJhtrnsptF8RyxnhkYv
         7IwA==
X-Gm-Message-State: AFuF++lvvdju7mgdIbf2fwm2s3fDmxmAXJtyIt84z8bd3Sy1aqcXd/ZU
	/2dyCOiGPn9VAu2DTJNg0QiJcwof4GuZzawZBcsTu2XELMRY3L8HTgOKkDVDe8IVfyBnCE+XyVS
	GuxNhQxnDjh7ozAX0XdQBotwavFC3OxWiAMk30jVJdr3TdTSZayJIH5psdLUCymvv2l+mVQ==
X-Gm-Gg: AYBFou2pVu/kHkBMvrI19C9n4DjnJo36PSGpE2PGTN+aUXZ59b3KvNnLoeoac77Dezk
	3SkWvesqBRVPGtB7BQJqe8v32o79fC7WIYzrtc0qTHD/p3dgRC6AV4wzqXB+LR/df1tM5GaTi2V
	TbSe5V7Qkn9C+KB5TklT9saeuWIF0s8wTnvXy0inuc0U9HeNHWx1ES5fsnj63Ley3crHwPutpzq
	aBY4flM9NI12LJ5TciPcvEPv63bXyb0yaUnDNmo/nludStBsz15/B1/eBmC+W7neWp0Nqg+nv6q
	sYGsErxxDc0krL+UlyydDk0s1mo9d/C8465rZNA0woCll7q/tySv46bAnaXTYjSGYG3BhgV/LWB
	gxlPxyXD6G4pRJvCgLlQXBP41QrPW6zZJoao5zV9h0Q0AGDXQNJL6NjF3FOzI
X-Received: by 2002:a05:6820:5605:b0:6b1:b33a:db69 with SMTP id 006d021491bc7-6c0bb3f863cmr4855892eaf.15.1789146383986;
        Fri, 11 Sep 2026 10:06:23 -0700 (PDT)
X-Received: by 2002:a05:6820:5605:b0:6b1:b33a:db69 with SMTP id 006d021491bc7-6c0bb3f863cmr4855837eaf.15.1789146383555;
        Fri, 11 Sep 2026 10:06:23 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6c09a122443sm3710647eaf.9.2026.09.11.10.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 10:06:23 -0700 (PDT)
Message-ID: <5f892b6a-7c02-483f-84c3-43c1161ef251@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 10:06:21 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] wifi: ath9k: stop a failed register read from
 opening the RX filter
To: =?UTF-8?Q?Nerijus_Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>,
        toke@toke.dk
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
 <20260911014653.1566388-2-nerijus.bendziunas@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260911014653.1566388-2-nerijus.bendziunas@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIzOSBTYWx0ZWRfX/EsEx44DwwzV
 BMkki6CycOdaNQ4dLlpzI9g7F04j2fw+9ViN2Gun+tbjlrFeLcYGfMzc84LKI2MkuxgIqwIXq8S
 ma06Djnv/sFsl+oWtZy1I718l+nPId+95wzyo0SrtU2FzhcuY5yClvkgBvwrs6YBHye8vmx5NBL
 /BRz5YqtWpdg+5f2yF3rOgFu9Fwqa5dq/tvuP+vFzY+7AnbbG7W22IgBXoC4pN6bCE7r4GfG0Am
 skwdzajnSWnbfHelyY1iScOTG3toCA8xCAXJ4NsD7zs6mtprM2BrZ4/2WO7cx7o0mP1G34+e064
 khkVX77767K5wIY1BCCxCeIaP/QnvVyD7agZAvDVjhkKwLXs7Fa2Cnwk1ZjkiqrsO6HJsgYY1VX
 JaINUVb4Fuzzdp812k4ACCgrICTFJVUtIgwtLrMK9++R0WKJ9/28SLd4lbjL6kLjrjK4RAb4h61
 2e8lbkqbz3Ek6SaLtMA==
X-Authority-Analysis: v=2.4 cv=LPDz05W9 c=1 sm=1 tr=0 ts=6aa43510 cx=c_pps
 a=lVi5GcDxkcJcfCmEjVJoaw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=oCg_hTeQ7_Ete_IDjq4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rBiNkAWo9uy_4UTK5NWh:22
X-Proofpoint-ORIG-GUID: 1jY1_0bcMFtiRdT2R9-sfA0vlGmaqn3a
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIzOSBTYWx0ZWRfX5dcAfoSYFUrS
 0BaCCX9Je8hTIrohRO/U1vQzkU++wiU8gUn6N7dF4YgM258EeCuDrYs9qu5ocNThtoI7bYdlxom
 18q/jKnMuyU+8TIdWf9qC6VjFd+MeNc=
X-Proofpoint-GUID: 1jY1_0bcMFtiRdT2R9-sfA0vlGmaqn3a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110239

On 9/10/2026 6:46 PM, Nerijus Bendžiūnas wrote:
> +/*
> + * Set bits in the RX filter without reading it back: on USB a failed read
> + * returns all ones, and writing that back would open every filter bit.
> + */
> +void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits)

there is a standard for kernel function documentation

https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html#function-documentation

