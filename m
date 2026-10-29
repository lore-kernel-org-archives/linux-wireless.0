Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793250648;
	b=oDMUwIHizifmbl43HqsKFeHN0LJ2Y3ygNYfu+dn2+Fozm1Ke0GC9QvmOZ5zVBHDlHRK/
	 eiaNuQPAMfRGJjGtwmxVFcXQDrR2hQiqzxWg17Xe4X7+wQHZyi0pFx0f0xnGabC3dvkg0
	 NaqnsBn4bVeIf7195JuT6hWXCbRcYHn3pAuGY/LWnL+6QW2swOvCSHQg0bF6sc891Jb+v
	 ucxMq9x6tDnxth4ZD846CmuszWk4csFfNamyrLEyn7gkG4kn6O0TB3P3WhAv8bRbWpQGJ
	 4aDlpm2+xHhmg62/C1wsoK+VB+N5pOa7xSr5xHf99qhtP2UfFFTZz9BYzGEUhu1qIGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793250648;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=L1hwVhNMNrZDpSp9Zo6hTIicT+T/hSEE+lSDb02eR3Y=;
	b=goWfwDuT3cWCsJ+9GF+FIS+A9S04Ql3yXvb5s2p4wNgWTGiXe8QVhQYmeWiufR3Nlva+
	 ok/9yUrb63Xt0limcDAFW6eny/mnXnijfNT+AiNir7nuHcxa/drJV1PWkVmjWDTz4q3+o
	 36MiMtlXhzVK45s5Rjv4EIQf5eXdJDv78ZTLoRqG/ayMYOxPR+1tfQciuKqKSZ3+4niSs
	 s2v+PRnNVY6t21t2BxcBTAGheUiE5rQEjMVULzpaonpgI0D4djQ83IsYAYTIKDfnGPpZc
	 ps4ryxyUNelXLUnezjdDY+Gm20HkqGGvsFIWIlZPM1ZLjcjVc4XRpFQ0mNFxALBT2BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dWbKoIjO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="N1v9GSj/";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB11606A31C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBB11606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dWbKoIjO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N1v9GSj/
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T1jhIL3948044
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	L1hwVhNMNrZDpSp9Zo6hTIicT+T/hSEE+lSDb02eR3Y=; b=dWbKoIjOImTRjj8I
	eqgt4lsHWxR6UWkUQI3vdsbE3OvdnGwWFTZGqmg3PNN6C1qvsJmsVbFGcNvzt/pb
	GiOY260ngBVwX0QX651igqVwyq6WgxgOAsFLXTV8blErYlf+6dITv0vA2KAl/kJ0
	7vDvJYycdVXyTMLBpIalvukZV3aCPM2nxKfPiStfRQn8npQGWOuLDzPVjxQW63mn
	XnzjAfPGhkOMRJFPh2yRq9NPzTyIVJFERDuOMDmMLANmFjIt6tolmZt2R6SiAu1g
	GeHeXrquAc7Q050Cuy4K3mQPNwNMwg+FuRYBLEbpeAUGZk6WMl4iS/0XWgBgK1FP
	SyFWjg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkneuta2m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:10:46 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c3c370b17so2852478eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793250646; x=1793855446; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L1hwVhNMNrZDpSp9Zo6hTIicT+T/hSEE+lSDb02eR3Y=;
        b=N1v9GSj/Y1xFG3qNjUmQvBGZtgIFWY4J+fH0yYjKP3iZjLTkPK/iuYX8DpqvUQqfr7
         NAg/E1sfO7lCMKpo1n/xJtX9s4ZJjxknp121t/+vllJAzxe5O/oRPYVJIlW5P8YpRRbJ
         TRhob+mZsGaHMaH5YztQAA0wfKIS9b+exOSvidlKhixsxrZF+K8UfOuDBVNcsMVfKfAP
         1Mbf/XC8Rd4dcrRbIk7RMwqdr+5Nuj/YH2045hJpr8TdwhtMPoMJQDbqoawbjYkQtGi+
         y2XqWiEbrdNJUOByJxpRJg9Z12Hpq82JWvz7kM5Ym58fMM5ajSJnjHkdp83TX8/bnV1b
         jjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793250646; x=1793855446;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L1hwVhNMNrZDpSp9Zo6hTIicT+T/hSEE+lSDb02eR3Y=;
        b=Erfql7TooGwy2SeJSM8WkWMZoFjldRP7EY6tX1RRixg1AvxCwvWhKXFU260d3MwLuy
         QPe20wHRtufuRPtZsjr83Sj1gxJLF5uTWg2iXmopLOlkIZ4Oij7Gl51OZAQ4j1A5UE9N
         RKRTkki6AIkS857LvOUBcJrbmWMV3SqO/gF7suH61EEhk4x6Y6/GIAqDQTKPLJ6L9tEz
         x8PwFPzO6seNgXA6n3cykqnQxzhVkgMuVGpteF1Cb/dB4LZe4AKVKuQ0TPsC3hayF/0j
         XQ4WE80PjklD7loNLmABHN/EL+OepJiq3AoKoI7iZ1CT/byn80gm3gC0gYkb1bXWLeOb
         b1Fg==
X-Gm-Message-State: AFq9FYK+N5FB5QfKBLa/82XYesrZ33nsORS0uO0VWYAdYq8BY/0tK2ZP
	rGn53vJEg0hOB5yXF3+5h+tytWTyILz86bPJtdHs8BKQxSxB/MAYvYKW8IGIlQEOVjrrkJw7YZL
	TIJ7gb/Ftl/wBz3HeCViatE6PFHF/OWfTTTgKhPH209lbSRIObvhjkkz5uwEAHg/PoV8YpA==
X-Gm-Gg: AYBFou1tGcNT7yOkOigj2n/2WrEXaOOXT/E4ma70q/Kh94U/06Ys01NrDAqye7mzb5V
	EgGeSVGJ0w3qCg2zQZExajzoJNQe5v+0E4A8j5LczomRZInEpOiXqi7HxGDgLvSVRmDxhF19APi
	SPEK0XjZPDX4Vlm6Z48VCR6Ofi29Q5NwEHykSyDn9CElwJbLHlD+Gq1SJkQuLKq8CvTQEeOslvf
	kbGoDrU9ySvrV8squL7HQb0+2vUIGj6GzhRe0COSGtLQk6q4k6xr9tZHuodoJZaRaSEf0OQRvL0
	niDosoQYsTaVA3aKo8RnZDmHym3WL2iq69FLhi96v0SOw4yfpvNS8OyyJ3nV8jqk3TNNGC9/2Vy
	TG/G1MIGQ+0Dj0PyMFDYaIv+4+3je4RSsl454B7lzMnUf7y9C3CTCXdewSz16ip0GX0aK9IECEL
	OTDQTi36z4oo8XtA==
X-Received: by 2002:a05:7301:1407:b0:35e:6eae:c01a with SMTP id 5a478bee46e88-36a203febbdmr6925386eec.19.1793250646129;
        Wed, 28 Oct 2026 22:10:46 -0700 (PDT)
X-Received: by 2002:a05:7301:1407:b0:35e:6eae:c01a with SMTP id 5a478bee46e88-36a203febbdmr6925342eec.19.1793250645462;
        Wed, 28 Oct 2026 22:10:45 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a23641e78sm14113652eec.0.2026.10.28.22.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 22:10:45 -0700 (PDT)
Message-ID: <22adbcac-94a9-4528-90fe-ad5ef2b00974@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 10:40:39 +0530
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
Subject: Re: [PATCH] wifi: ath11k: Unprepare MHI on power up failure
To: Vladimir Zapolskiy <vz@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
References: <20261028104336.1686334-1-vz@kernel.org>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261028104336.1686334-1-vz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAxOSBTYWx0ZWRfX6bxXxzC6fcD1
 NRYplJlmSCWcFmkBpUMv4xZpi6R/WaKkgza6wlNWXSJl5orglNbh5eLhR9IkBcCBDTWtjAaXXda
 zjED4MzPaoEz7btbm0VROzCWcAPreDvB2CaXpywdzaYKg+Xtnr2ftcombYba5snCgkEQTX/YV8y
 cM6zk3CylDajLA2tpokAQXRkHimy8dEGrqLkO4miwavfZ+h9jIkg2zY8yfKWYr2oplTIXSGqnNN
 cGBZiCvV4RR8+i3X0+qnBmvw5NRzr3m0+Omv0PSfDEhDO+NlU4XPXDHtuB+OLD7ScZuV/WXkKY2
 GjdsF8Nkdz/NoBKc7imHkS++5HegoV8mztfrmWYOE1pgu2Ov/8Ni69p2AsI6eET7gHRj9ueGLkv
 OkV/dB8X77vroNNk02oMFK2y1GzwXYpu5oMD/fd4rzyM/0FaTYwOqQfhA1dwL6Y8zvnDScJdJh+
 AV8Ga7pLxKOLkr1lfpQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAxOSBTYWx0ZWRfX/rb7tZfDNo3L
 uhtvM8vQ6XdsJPGhgc11yyMXD3QPOEz4U4genepJ+VS7TNLgQSyuVKTZiDxecNVr4hVKd5EkxOz
 YOny4lBMN6xlk4AI5gIeT2+2jp9lJYk=
X-Authority-Analysis: v=2.4 cv=LoAHWXdc c=1 sm=1 tr=0 ts=6ae2d556 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ZPdQ_4gUyuuPvppjJ1YA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: 3JdUT6t0SHLFI94SpDYzA8AmiOpqLfb5
X-Proofpoint-ORIG-GUID: 3JdUT6t0SHLFI94SpDYzA8AmiOpqLfb5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290019

On 10/28/2026 4:13 PM, Vladimir Zapolskiy wrote:
> If MHI power up fails, for instance it happens due to a missing firmware,
> ath11k_mhi_start() returns without undoing mhi_prepare_for_power_up().
> Then the failed probe or power up unwinding frees the MHI controller,
> but the MHI device context and the RDDM image table allocated by
> mhi_prepare_for_power_up() are leaked along with their DMA buffers:
> 
>    % cat /sys/kernel/debug/kmemleak
>    unreferenced object 0xffff00079156a140 (size 64):
>      comm "(udev-worker)", pid 595, jiffies 4294893781
>      hex dump (first 32 bytes):
>        00 d0 f1 80 00 80 ff ff 00 50 f1 80 00 80 ff ff  .........P......
>        00 d0 f7 80 00 80 ff ff 00 30 fc ff 00 00 00 00  .........0......
>      backtrace (crc 62662f0a):
>        kmemleak_alloc+0x34/0x40
>        __kmalloc_cache_noprof+0x224/0x3b8
>        mhi_prepare_for_power_up+0x58/0x548 [mhi]
>        ath11k_mhi_start+0x30/0xb8 [ath11k_pci]
>        ath11k_pci_power_up+0xcc/0x188 [ath11k_pci]
>        ath11k_core_init+0x8c/0x190 [ath11k]
>        ath11k_pci_probe+0x4e0/0x870 [ath11k_pci]
>        local_pci_probe+0x40/0xa8
>        pci_call_probe+0x64/0x190
>        pci_device_probe+0xac/0x138
>        really_probe+0xbc/0x298
>        __driver_probe_device+0x16c/0x19c
>        driver_probe_device+0x3c/0x114
>        __driver_attach+0x98/0x19c
>        bus_for_each_dev+0x74/0xd0
>        driver_attach+0x24/0x30
>    unreferenced object 0xffff0007916fb800 (size 512):
>      comm "(udev-worker)", pid 595, jiffies 4294893781
>      hex dump (first 32 bytes):
>        00 60 04 81 00 80 ff ff 0a 00 00 00 00 00 00 00  .`..............
>        00 10 e0 82 00 80 ff ff 00 00 00 00 00 00 00 00  ................
>      backtrace (crc 52e9e075):
>        kmemleak_alloc+0x34/0x40
>        __kmalloc_noprof+0x280/0x440
>        mhi_alloc_bhie_table+0x54/0x168 [mhi]
>        mhi_prepare_for_power_up+0x318/0x548 [mhi]
>        ath11k_mhi_start+0x30/0xb8 [ath11k_pci]
>        ath11k_pci_power_up+0xcc/0x188 [ath11k_pci]
>        ath11k_core_init+0x8c/0x190 [ath11k]
>        ath11k_pci_probe+0x4e0/0x870 [ath11k_pci]
>        local_pci_probe+0x40/0xa8
>        pci_call_probe+0x64/0x190
>        pci_device_probe+0xac/0x138
>        really_probe+0xbc/0x298
>        __driver_probe_device+0x16c/0x19c
>        driver_probe_device+0x3c/0x114
>        __driver_attach+0x98/0x19c
>        bus_for_each_dev+0x74/0xd0
> 
> The MHI device is already powered down by mhi_sync_power_up() on
> failure, but mhi_unprepare_after_power_down() still has to be
> called on error path to release the allocated resources.
> 
> Fixes: 3df6d74aedfd ("ath11k: mhi: use mhi_sync_power_up()")
> Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
> ---
>   drivers/net/wireless/ath/ath11k/mhi.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index a6c9ff112c68..76c194573ec7 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -446,6 +446,7 @@ int ath11k_mhi_start(struct ath11k_pci *ab_pci)
>   	ret = mhi_sync_power_up(ab_pci->mhi_ctrl);
>   	if (ret) {
>   		ath11k_warn(ab, "failed to power up mhi: %d", ret);
> +		mhi_unprepare_after_power_down(ab_pci->mhi_ctrl);
>   		return ret;
>   	}
>   

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
