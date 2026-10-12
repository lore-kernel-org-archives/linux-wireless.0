Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792CD2BD0B
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791780203; cv=none; b=l8JGDGBdxZTjld/UtGmQLpR+5xZFn4VsgUY8B90jl0jnAEUf/F+RwLrjTuMeqPZcCjhkYpW6ftXR4Kz8F7o2an1rLFqdjTNf61Aa+RX1dSHQBe9BGh7gZdEGjkcYP0/yNdY5CauQJRqa9Zbal2tfV6RsqgEm2tMhKz0V9Cg2qqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791780203; c=relaxed/simple;
	bh=HlvuidG4fqA4epzj/8yFl+1U1bAbGJklw4QmdHF0TG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JMjgawqYis6fAkXmV7gG4g4N3SGXrH0yZILYAng7/u10Cn2g6a0Sv2JRG00gkf0TEvsizM0wX5nNfmmnPeVvBioO1Hr1U/MAdYPgxHVK5Kbed11Pj8/HGSO8aL9pqlIrRCOPQRUL9gquMF3X8DngyvstK4e9VPNjRYPqzZXZvq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mOpyNx32; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MSSvrVCq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mOpyNx32";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MSSvrVCq"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C1lKJH328331
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ci/sk9jVWBmKRQqWTGWVz3nSdbbv/knUpwFr8a0Gvg0=; b=mOpyNx32vfFBwMsz
	98mhK4KJdB5N5WuM5YGZwAXuF8dYYvtP/pCuzQsubPYrsHoLG/J+71yvRk4h/lXy
	W/ySjB7vLl5RJq2+C+cM8TGub4LZGySCfeEmNLVFzMNj9/0kz00hJpE5I6jAfceD
	McMItJ1ieHM7HivP5jHkQfkZ9CifuOgnwRhmQ5KGzVqLE/fEL5KYOl6LcNvcFOu5
	V4n/SmXIB5CTlasODLdonb+fYqsaFZba5v1qMNqFQT0esSrsKJnLlp9D65Cpo/kL
	TBUx5Gi1WjAAk+i4SsM8WyNVcObnCr6/Dl2thBZ9RyeBvsKDLhVkLAlPy0KPPRWD
	Tjjpyg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7e4eck88-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:43:21 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35ac5255f1dso1743217eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 21:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791780201; x=1792385001; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ci/sk9jVWBmKRQqWTGWVz3nSdbbv/knUpwFr8a0Gvg0=;
        b=MSSvrVCqdr4f+5FdPiB5zufhBuR/5R/PdrNaH4nM55tpHelkG60FuzuKZWJdsnO7HI
         xIjCOPsDT8bUm+wjAi5aQ0e2ZM5And5owpK15V88q7S7BUlsT1vG7llllj72IWIYbYWN
         PHmZMulwe18ct0ixhG0CUl0e+kb/69OP1CszvEE90lHMmbtMCHsFyKv9633vZa5nBhQp
         uY8KWwLhJEnajk3mcmRD1xhug8tbbUxsv5ZHQbl4SmcsoOvaNyHUjLOWw/i8mtt1QWn0
         4/tBI2t3MKYO3Qm1o/xhJV4i7r2NC59yhNPea4xi2LS0+wJ0uh3Idiw5mlOZGgVfHZLw
         5CMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791780201; x=1792385001;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ci/sk9jVWBmKRQqWTGWVz3nSdbbv/knUpwFr8a0Gvg0=;
        b=UEJ2F2KSpmiou+YMAgG6V5iRGo6UyrtmP+9Y8w4DByA3iyndITcD2f2ItKg7Ysyjjl
         GrzJyA83GZqaju3dYDLMLO/Kr9qI+slXhKG/ZIwJjzVY2RtfU/oeS714gfOvVSOLQ+IW
         9PX5S+zCovFF+aP7aBnIze8DsYw9nNXiqxDjViiXjYyhyycjOrO8A7Oj+Krr2ltC9tGN
         Bg4foFfprxWeRVaL/zNksxDSOg4Kp8MxJYAg+XPmG6FsqSqGyazpxfPcGyqv+evIXgWA
         y32RGKX+AlNPX/1s4/vrl+ukpH5qg2Lc+CZIKQ4tBLOJ2s3Vrs9wiJ+O1mFKiusczhYC
         NjLA==
X-Forwarded-Encrypted: i=1; AKwUvBzR0QnsS8DQBe3OqVIvvmVfR0WOtn+ICXf74g8SSI3zRMFiwvId9ziD6FYO2qIZQ2wzXMiB2Wig/j7mNQWRag==@vger.kernel.org
X-Gm-Message-State: AFq9FYKsPVTM6EonUgKwVmMdrfJBW/UScb3eDSqkBhU+fkoih5IeOMkX
	Kc0kJQv1dWa0H4bP/QZV2dKwx9EMUSt7dg3xskZvequvn5739/frAra4R8H4xug4BiPj0E6pwJ2
	7/+faSBKnwNyiJwWuppujbvD6NL5ieCyDZaaI7AQvp9W9UTPVZuUCIXhRiJmWnvqyxEX9Ww==
X-Gm-Gg: AYBFou0F/iIjec1OwRTo3AhAAnrcMlphfQgETn+9ddsqukZeRA19wpVp2z+yx0PlXUM
	eYHi35WLmviFL5yGTRSFeFwj5CcmwFWkk43cc5qDxmF8qpc9TBCfrQpctUWcQtHSzSiiz2mSUh6
	RrNGfWFvtUnO6lV8L9Qh7aWYMOD2DJ0cFoAmVdkG5M0XRPF4JwNGxR7wCLkqjvM17H8ZMwpBQOb
	den5Gb8i7u1Ae3IWRvgPWgkMMfajrnJsyVC3QIcHVkBQZLYIXD0sHXNzY3HAvkho+GyvrAOLrg3
	+2aOFoVWP7lBTcFhA6Nejdern5aKtxwd3N/gocqiorNEY0MLzvCQMAtb59WkntccwyjmCNY6Sr0
	yvu7/tf4IEUvk1+i7h+mp19ZBNVVlKCejNegKtsLj
X-Received: by 2002:a05:7301:188a:b0:358:7bea:88d5 with SMTP id 5a478bee46e88-3587bea9608mr8878048eec.21.1791780200772;
        Sun, 11 Oct 2026 21:43:20 -0700 (PDT)
X-Received: by 2002:a05:7301:188a:b0:358:7bea:88d5 with SMTP id 5a478bee46e88-3587bea9608mr8878013eec.21.1791780200204;
        Sun, 11 Oct 2026 21:43:20 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537c61eaa0sm32450382eec.0.2026.10.11.21.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 21:43:19 -0700 (PDT)
Message-ID: <19429424-caf9-4d62-a8b1-8faf7b93b0e3@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 10:13:14 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 ath-next] wifi: ath12k: Add EHT capabilities to scan
 probe frame
To: Gaole Zhang <gaole.zhang@oss.qualcomm.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, jeff.johnson@oss.qualcomm.com,
        baochen.qiang@oss.qualcomm.com
Cc: gaolez@qti.qualcomm.com, miaoqing.pan@oss.qualcomm.com,
        hangtian.zhu@oss.qualcomm.com
References: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAxOCBTYWx0ZWRfX/WKlyjzF988D
 QmkqEaMfw2PdFcjAxO4vO4EZpk+KBuDABnYo2C5VqPb8DWMIVmWOtb0TlE7AwMFEaJ41euRJfiI
 7riByI7s/pVdh2ONrZLgLoP6aG8MNXHiR344ah9S0I2Pdjwq02smYnIFn7rVgNrPuD0eeLrjv8Q
 yOgZMDZPHx55lOEROFRPkx99vzoUnSaiXms4zUpv5QD9NgYZo3ltGU0HJCZIYH4fp66k9ZYHgoh
 +SGav8kob6rvyb3E4XFlbuqQYTxol0rEMn8fRCy3m3Etj8Psl10DWl1Gt6ueV47uZZPgjSVtnYy
 MzXaFALcHJ88u8Fh3AkA+pzHzrW2qfviY22ToKDNpX671SDodAD5cVYrXh+v3H2gaevnsgE1hxx
 Z8NA3kju+RSZCE5SXdy+0migDvEF7WqgBaX6nB5HxUq3H4ZRDDcw3Xf/jXyPKnlf0XWVev/yuyN
 llRO56A31gMh+BPELBQ==
X-Proofpoint-ORIG-GUID: 3d6kB0w055LwpfANUKb_tbSkd4oEv96x
X-Proofpoint-GUID: 3d6kB0w055LwpfANUKb_tbSkd4oEv96x
X-Authority-Analysis: v=2.4 cv=W5utxhWk c=1 sm=1 tr=0 ts=6acc6569 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=QV8Wo-qd4fzodxduY_UA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAxOCBTYWx0ZWRfXwnBlZ/B6+X2+
 QwaBgXYoHrgLACsM1SaGnp2Fk2JVej9115QGn3imTu3kO9P3fvo7mwne9TnwQ9RKlxTi4mqm4I6
 578kDsp6i5A1rRjy/usQ+BzWSP+GHO8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120018

On 10/9/2026 3:25 PM, Gaole Zhang wrote:
> ath12k hardware scan Probe Request frames do not include the EHT
> Capabilities element. Without this element, an AP cannot identify the
> STA as EHT-capable during active scanning and may omit EHT-related
> information from its Probe Response. This can result in incomplete scan
> information and prevent userspace from correctly determining the AP's
> EHT capabilities.
> 
> For firmware to include the EHT Capabilities element in scan Probe
> Request frames, two conditions are required:
> 
>    - The scan channel must have WMI_CHAN_INFO_ALLOW_EHT set, which allows
>      firmware to add the EHT Capabilities element to Probe Request frames.
>    - The EHT Capabilities element must be configured on the vdev through
>      WMI_VDEV_SET_IE_CMDID, so firmware can use it when building Probe
>      Request frames.
> 
> Set WMI_CHAN_INFO_ALLOW_EHT for channels when 11be is supported by
> firmware and not disabled by ACPI. Also configure the EHT Capabilities
> element before each hardware scan when the element is present in the
> mac80211 scan IE buffer.
> 
> Firmware retains the configured element in the vdev context until it is
> replaced or the vdev is deleted. However, ath12k scans may either reuse
> an already started vdev or create a temporary scan vdev that is cleaned
> up after scan completion. Sending WMI_VDEV_SET_IE_CMDID for each scan
> request ensures correct behavior in both cases.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
