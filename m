Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252334;
	b=dWsOf55htQjJDctqvAMQhDnmKn7bspeQZPLm2BRzRzPRGzdwUB+BUQ5EygsVnMeLYKr4
	 jf9B0V59DLVf4mfrj8n1IwabHi5Jr7OhFcDd0Mh9mHcf9xjaEG1PxEFPWZsNClkTL/x1V
	 0WH8BjwmoYQFoyt4M2FWXWcFf972WpB9y2eCZD23GtT3RKOt0AmpBAhzuLfeCOsNo/n99
	 e53HJ/ZgGxs8zsm1Ba8aGchpdi1AQ+s0txXi7zFfL2IN2Dz5ecUug/OGFhNUMjlbypJ1E
	 zGzhmyIxPYL87tbLgrjgk+6se677AF0IwI5DGggCA/t2hwu3HqfHePiZWtU+sgcdKYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252334;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7TJq6ezoddiw0WtE00XQmq7Nc4tiEz7eeOE29EDeZng=;
	b=aV3g8kWO/1sW5FhKmfTtQsbWOD0A1ktVX/a6RkWHnosZwkvu4Ukxk2CFnPL1w4wAW7yO
	 7qlKlPXthV+Q6kogCQUwlm4+J0E/GGODvtdQEt/ce+++7youzQx5j+FUmPiFMPo+4taq4
	 Fygm+Jqi8IPUOCo9P/czlZxmV/trW6fOmNk4Z8GTtQyYK5DDKp2xhI7AXn3FtJDYUBo2e
	 7c07XbjXqZLfb8p/3x2tlC04JssVqJ0EYvDDSxbJvwNTP2Yrm/RI+R5tD+oTDw43f7knh
	 tf//INAifVpR+Uea4Jw5/6GQyn7la97G864/8RPjOXtncGg6bUcHHnWqZUFJ7OCBxOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kAu0H6dv;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RDqaZs8G;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED78606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BED78606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kAu0H6dv;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=RDqaZs8G
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T5Gohf3341043
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7TJq6ezoddiw0WtE00XQmq7Nc4tiEz7eeOE29EDeZng=; b=kAu0H6dv4D0+AO6t
	/ZAb64NIm7yOs4UHvtuOOEZOlHnUCnYuJaU/cD8/FC6n3Su5nDlPDUzrPBUNGExb
	qZLduFlS1e/KSm6LNZByIeFVj7lHJs+zyFQ8bGF5G30/T8oBInVPWMsf0n+xgS7P
	DAXQXY1Ma6SB4ROD3i/37ZYNvJbY1MMF1nbjvbll2nWYKKe8aHf+Cujxabmfof37
	r0Yo/5ECD3fVLypRw6srrE2LfTgx8rme1S8A6jUVmQDjJYyTsP3sbcCPwcp1e5i5
	3tP5gFUncomOx7OX0/shgrzf1o4bzEUulAjpB63BiV1k/873/Rjln2NxRPXya6Dy
	YsMqJg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkut3gurn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:38:53 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd67d4bbdffso1334906a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793252332; x=1793857132; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7TJq6ezoddiw0WtE00XQmq7Nc4tiEz7eeOE29EDeZng=;
        b=RDqaZs8Gb3Tzl++RVWvz5sbGPrPBCe/ugihLyZeoVS1YphJts7koW/RsIemuWML7/s
         7XrYp9C8c7Xj7jQPO2NwikMaTnUV437hjU1O0eDzV333zw747rN4n0a34WLgLANEHWld
         YXe0np5st5AAG2d0PJAXCEKZbKfeEp3yLaMz2yNcKv/cGJkcafyr53baks6s9DgfQVvb
         +hlpYxe/OEKtqAMP4+uEUbmNL6FLcq3v9b5nEfKVgZB3ducRdDgLuLgftPSU24LVKtWn
         k1+xIXGUfhaWptt5zoOYnj4bekoAAwv6vGLvYjWGQBXlpzr85VCJhEyMPlQJQh6OGyj2
         bQNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793252332; x=1793857132;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7TJq6ezoddiw0WtE00XQmq7Nc4tiEz7eeOE29EDeZng=;
        b=hRwUN4+D368DXZLlkXfTFcfthSb5Ig2PfjkpmIA6GZosN5k57T1yQGrMZGDeqUGPm+
         3ltFoSMhwdgYktA4yfGCFFQ5hxGkFHJEkFTXDWtOTR1L4SPjgXaNCGzX4b+wPDjw/wko
         qgAWwqpWAHLbFEsCnqqSgkeeuGieTu54fBxlTBVQgWSw87e+TAqlkwj0lgytVp0K9iPo
         FdCMtR7sy9ESOC1Ek4m3dv+OmHMnOmhaOHlyOZf2buUidi1sPWZ/7kRwMjtrG1q8vYrU
         NUb2du7+SYZ13N12cZgW5kvbrNiO2uBefy2e5qisw4JSIxfjqZgBgiCd+e7d4vcWObhT
         mE7Q==
X-Gm-Message-State: AFq9FYJX/LZ/aFllK7wd/6Quqalorgq5wsnwNxHzAPIVJPVBolji9fu1
	1JIc3HB2s7VX1s/tRYBXi3+rzAYWodf6IGP6w3uPuHMnrcL1Sa3KoBX1CUVrHb9Yy/uJgnqqmhd
	DjuOjzYHZEOXHEB5CYeSlEUBFP8UU1XbmkS067P5lGVxg0UuFu/O0tYVWkjQ0Rt7gqkiQ5g==
X-Gm-Gg: AYBFou1tXUQYnCNCxl4b70Dm7bhqY9NiEw1MWjZ4yVYsw7gr2QnCFN96f7d2STlVAsO
	NnohBHPGJJ7PK4Y5QhPXns576G7yseWBxmXUGHZWjErrkmyZW2bvQmXwpo7K1J9HKa9NO+qElou
	e4KVC3TwGMG1c5U+nA27PHMcs7FseXMGsFUOv6hTYk28CwMwSz7k7iJ/Wezz1UaEUTJcFGifXWS
	HY8u7G6yFSxiTCgOt0ayCKSZ5uWwKKXycV53hJ5zmo2Fq2wo50zmPKtUkAVY6KugqAne9R3mmSV
	aZtD16YbRCzQ8tuD9vRX/82eJFy2MDIYKYOnd/egMcBKQ4r4C+Du/NL9F2+Sxq+dQjaScFC5TBE
	SRGrrKg36Fqt7MRfHX6KWqNKc7WWZ/TkLQs+v3BjZGoqPEKJVAKOpfNIH0iuAhftIydfQsJ/YPx
	8eGeCzw1OEObqkARgmop+8ue8hY7dQm3vEaZHNB8m89T80
X-Received: by 2002:a17:902:da8a:b0:2e6:1715:e48d with SMTP id d9443c01a7336-2eb0040ad44mr43199855ad.35.1793252332276;
        Wed, 28 Oct 2026 22:38:52 -0700 (PDT)
X-Received: by 2002:a17:902:da8a:b0:2e6:1715:e48d with SMTP id d9443c01a7336-2eb0040ad44mr43199715ad.35.1793252331745;
        Wed, 28 Oct 2026 22:38:51 -0700 (PDT)
Received: from [10.133.33.77] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6455a00sm28716615ad.2.2026.10.28.22.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 22:38:51 -0700 (PDT)
Message-ID: <e67e9442-03d3-425f-85d9-0983a16ae5f7@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 13:38:48 +0800
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
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261028104336.1686334-1-vz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAyMSBTYWx0ZWRfX3IeGkhkvHgJ8
 xU7pwyTqyrs8mKX+E8MfVBcKfo/+iaDmaaL3HSHPlKflYTy3hkoW8Nf/QW0Qt2Yw6+OvWlupVBS
 6oQuW0h4WMNJYmqFgyj7yfy6NGsmous=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAyMSBTYWx0ZWRfX1jFqW8JjONFu
 YPfN6C9K4800BqQ/1d2dYweJk1WMXpXjQoImWNSHM02iTKS88A3BAxn+VFtMfFtFYK1Sf4J2v2z
 4mDL7DqyOrdUutMuR5iZpsb37vsvg2VWOrCAxw1/0mYItmFZxz4FmnkNd5RBAd5TmTCkCFvtJ8b
 QwLfhbRPe6wsZfSYHQRSr1VtwzLFYGmDzzz6S0qS38mqGaJbxRuhEOeEXSgFjaQ6olQDg0ynGTY
 Wy6U7aaQtQPt2RcLThKuetRhUb8aLRCXz4gBojBmvxhseQ1hpCr67C68I+2PWrdl8+DtXUW5/Xu
 xx+kO/ayJeYx6qVVmTCdqMXBsl35DqRlP/va/Bg5QY1PK7BpyFrvrkj8X+PnXNx6LojhGB931rS
 YzOonOVmLBIswIz+jkUyBUHxITLHbXyoJg6H29BnmV8cM27oNJq+rxnxdBhhdhP1Eye2f7QOiOk
 DARb1qb8GKEeQj4sdew==
X-Proofpoint-ORIG-GUID: TG2vaGVt-lEb_1e06uTzPkxZItHHDNgh
X-Proofpoint-GUID: TG2vaGVt-lEb_1e06uTzPkxZItHHDNgh
X-Authority-Analysis: v=2.4 cv=HYSB3SE8 c=1 sm=1 tr=0 ts=6ae2dbed cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=CJITIh9EL64xvWp9jcUA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290021



On 10/28/2026 6:43 PM, Vladimir Zapolskiy wrote:
> If MHI power up fails, for instance it happens due to a missing firmware,
> ath11k_mhi_start() returns without undoing mhi_prepare_for_power_up().
> Then the failed probe or power up unwinding frees the MHI controller,
> but the MHI device context and the RDDM image table allocated by
> mhi_prepare_for_power_up() are leaked along with their DMA buffers:
> 
>   % cat /sys/kernel/debug/kmemleak
>   unreferenced object 0xffff00079156a140 (size 64):
>     comm "(udev-worker)", pid 595, jiffies 4294893781
>     hex dump (first 32 bytes):
>       00 d0 f1 80 00 80 ff ff 00 50 f1 80 00 80 ff ff  .........P......
>       00 d0 f7 80 00 80 ff ff 00 30 fc ff 00 00 00 00  .........0......
>     backtrace (crc 62662f0a):
>       kmemleak_alloc+0x34/0x40
>       __kmalloc_cache_noprof+0x224/0x3b8
>       mhi_prepare_for_power_up+0x58/0x548 [mhi]
>       ath11k_mhi_start+0x30/0xb8 [ath11k_pci]
>       ath11k_pci_power_up+0xcc/0x188 [ath11k_pci]
>       ath11k_core_init+0x8c/0x190 [ath11k]
>       ath11k_pci_probe+0x4e0/0x870 [ath11k_pci]
>       local_pci_probe+0x40/0xa8
>       pci_call_probe+0x64/0x190
>       pci_device_probe+0xac/0x138
>       really_probe+0xbc/0x298
>       __driver_probe_device+0x16c/0x19c
>       driver_probe_device+0x3c/0x114
>       __driver_attach+0x98/0x19c
>       bus_for_each_dev+0x74/0xd0
>       driver_attach+0x24/0x30
>   unreferenced object 0xffff0007916fb800 (size 512):
>     comm "(udev-worker)", pid 595, jiffies 4294893781
>     hex dump (first 32 bytes):
>       00 60 04 81 00 80 ff ff 0a 00 00 00 00 00 00 00  .`..............
>       00 10 e0 82 00 80 ff ff 00 00 00 00 00 00 00 00  ................
>     backtrace (crc 52e9e075):
>       kmemleak_alloc+0x34/0x40
>       __kmalloc_noprof+0x280/0x440
>       mhi_alloc_bhie_table+0x54/0x168 [mhi]
>       mhi_prepare_for_power_up+0x318/0x548 [mhi]
>       ath11k_mhi_start+0x30/0xb8 [ath11k_pci]
>       ath11k_pci_power_up+0xcc/0x188 [ath11k_pci]
>       ath11k_core_init+0x8c/0x190 [ath11k]
>       ath11k_pci_probe+0x4e0/0x870 [ath11k_pci]
>       local_pci_probe+0x40/0xa8
>       pci_call_probe+0x64/0x190
>       pci_device_probe+0xac/0x138
>       really_probe+0xbc/0x298
>       __driver_probe_device+0x16c/0x19c
>       driver_probe_device+0x3c/0x114
>       __driver_attach+0x98/0x19c
>       bus_for_each_dev+0x74/0xd0
> 
> The MHI device is already powered down by mhi_sync_power_up() on
> failure, but mhi_unprepare_after_power_down() still has to be
> called on error path to release the allocated resources.
> 
> Fixes: 3df6d74aedfd ("ath11k: mhi: use mhi_sync_power_up()")
> Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
> ---
>  drivers/net/wireless/ath/ath11k/mhi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
> index a6c9ff112c68..76c194573ec7 100644
> --- a/drivers/net/wireless/ath/ath11k/mhi.c
> +++ b/drivers/net/wireless/ath/ath11k/mhi.c
> @@ -446,6 +446,7 @@ int ath11k_mhi_start(struct ath11k_pci *ab_pci)
>  	ret = mhi_sync_power_up(ab_pci->mhi_ctrl);
>  	if (ret) {
>  		ath11k_warn(ab, "failed to power up mhi: %d", ret);
> +		mhi_unprepare_after_power_down(ab_pci->mhi_ctrl);

For the probe path itself this is fine: when probe fails the driver is not bound, so no
remove or shutdown follows and this is the only unprepare.

The problem is that in runtime, ath11k_hif_power_up() is also called from reset and resume:

reset:
	ath11k_core_reset() {
		...
		ath11k_hif_power_up()
	}

resume:
	ath11k_core_resume_early() {
		...
		ath11k_hif_power_up()
	}

The later teardown in rmmod path or shutdown path then calls power_down unconditionally,
regardless of whether the last power_up succeeded:

rmmod:
  mhi_unprepare_after_power_down()   <- 2nd call
  ath11k_mhi_stop()
  ath11k_pci_power_down()
  ath11k_hif_power_down()
  ath11k_core_deinit()
  ath11k_pci_remove()

shutdown:
  mhi_unprepare_after_power_down()   <- 2nd call
  ath11k_mhi_stop()
  ath11k_pci_power_down()
  ath11k_pci_shutdown()

so the unprepare is called twice, while in the second call we can hit NULL pointer
dereference or double free ...

This comes from the fact the existing code does not handle power up failure correctly in
reset and resume. I don't see a proper solution to this, maybe we need a new flag telling
us whether the unprepare has been done already ?
