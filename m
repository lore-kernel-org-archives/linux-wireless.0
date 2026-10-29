Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253644;
	b=ifzrfs4SHksQu34NQfraCLdrKIYRRCy4mTip4GWzRfGMxX/vBPhJZ9h5OdzfbBwRgVbj
	 NvSOTiWAFYEIPWsd5rgyucwjpuLurUh6lOzp02wvCHLdOZQfzc8hXoDDTUfg0OWIIUpvf
	 wsN3hXIIKxvID/i5GDX9Qkhxm56aDIuC6uLH3tkXl7xf/gZjId1uQcVzcjHyNyWPVDmJa
	 DlpDY2Hv1+0rfBAZgdtukK6bYSBS9ILkI8zvPhJl6qmkuF+hmfs+hv92pGXks9JhRMffG
	 0S2u+ZvtZFd4hYy79m2GhPzgB3rz8L2P75xkWn77Btpa8wDX+y/BYSqMBo8Wq/OuDVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253644;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=EmImKn6xTR7BjFAtVScQ9ClU28Zoe4LIJE5onFodCJw=;
	b=UHvVl7c3+LN9VN3IQcTicg40pavpv+D7DCqoIrCbVgAJ/1XZx92uqQVaUBjwdKNEISHj
	 W145zbEoYVzGt4NtkCnYw1ZjC26JsZSt/7zjvJnDSqitPBZyY3PfsCuVpUK5KTurajTyI
	 RSwFc2IWCgf89YauZakrKa7cTWuCBFYeqa1h8pBjHtTDxNuVGPG7M7v50Ri5daC29UZ2d
	 KNZaaEJ9zTdeabCHGvmnH7fld92RIovxfQlVuuFdn8cKMe267cMeTXzTt8972s9m42MOJ
	 0ALsKCGQJ7HDH70u/jRrixeHpVtEeONjhDi9oSKPZOOCXQrN/2b4L+sFNsFPEtLcaoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CPW3ipfR;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cDyOhBws;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B141B606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B141B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CPW3ipfR;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cDyOhBws
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69T5HOWU2428427
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EmImKn6xTR7BjFAtVScQ9ClU28Zoe4LIJE5onFodCJw=; b=CPW3ipfRgB2GUOOf
	R/v7LzBQWuoHoz6MIgHk5xhFHA8B1Fsj8N4r6t8r9M7RNA6XhjsGS/6NRfwmnw70
	w/e/+b+ItFBRPmWGpHiQ5OrEJEFWpuywn4OW86gIm3fBRhd0Qz0XDNVTo8cuT5di
	ZUQyTuR0AHnrWuo2jVgADB/ryUes9A5tu4KJOwLzgVRC2ByYWj8roLoRt2wlMM8k
	4ZrKIYI7vNvlE/n00OnIgE04a8qU/iZ/t5HnNKU3tCGcZkx+Jho7E/5O1P6HDvTn
	zXQSo2UtPuO3XfvWgWaqbTbW2Q873NrUTwtv3f0fVpR/eSIbycwF/XtCmQYqE9qf
	2roo9Q==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hknb2ag9a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:00:42 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae73921fd1so231232a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 23:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793253642; x=1793858442; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EmImKn6xTR7BjFAtVScQ9ClU28Zoe4LIJE5onFodCJw=;
        b=cDyOhBwsQHxO0/+aE0VG7qht7Xtr3d/wNitLEWtZ1VEa4mbMAGzhN07JKVCEwwI56Z
         Lhld49cUyJTVIeqaqMv3xUaUfgx+V/FAl89T86cYSHtLRJKj7NUGxsRtLoVt5QeWUZy/
         8+MzDhxDuQb4HDleZoUuj/ia4gT5midmaGcmgJ8g/nx13DYzuxkAOJjFaOzQWCX/h9/J
         PNBI0oYiTjxzBhK4kc1YPPyifr+QiUsKG8de1ujimRRFvilZVeDDhzPra/J/SyKuKZuG
         sxUkdMJAbc4WAukYXZuMSRpXD66dKLw3mhmiBXO8FyGX2C/thnAy373MzCIvQL7L4F5W
         VsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253642; x=1793858442;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EmImKn6xTR7BjFAtVScQ9ClU28Zoe4LIJE5onFodCJw=;
        b=dVfFjJe44NjNnwmzu/kEnrZ39EUCLnLmgWUKf0xAMyrJzxO/h61w3+RsOwwmp8paom
         RhynuL/tFVoKsqlhA05Y/YwVeRQ8UtZfzVGNbAJ9pJgrZS9q6RPCIW6+Z1XSC9lBUPbB
         Vr0DMavn7W13g441UdPv1uvXHxnR22Lc8r3s3g2usDYYg2uC9y/yHKmAydY0aNtBNQg3
         qgVL9r2U14xYyWwoXIo7i2ouY5iCeURWZlGNZLZkbjRSSFIO3Hf7nWE2Id21b2+CgBhW
         rM0NMsirBJvr8RwPWybNpbllNgcG4lin4oQ9L13BUqVqOM2FbNWYgVJQaHamUPIl3jM4
         rYwQ==
X-Forwarded-Encrypted: i=1; AKwUvBzL3yKNPWYW2tYOyRTym4HiXyFwTB/8GmPbOsIzDSoGybGBjMc38RFEej47aGYpwmDwI/gMa5xle1WA/hgXVQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJXq5Gm14wTRLRp12eH8jBbSfwO5OqJDIux52H4NVpVL5FRoKC5
	XVsSGq+EaYmn5t+mQFt8aQgVJt3u0tE/oBXy62YCGI9i6SQkl6mSWFDPpQNVD4IW+0VbpXO8wxD
	RKVhwW52HBNvDUPba1yYhHWhoOfAqB2qTR3Vd1kqEqoTYk7lELwcEwxZ9EIUrzGsqC0AJBA==
X-Gm-Gg: AYBFou2FVbgNtGTmv8A5uYwbsM6WTEx3crPclc4zWQR9bBCgUV3hqxgD+KgoqITFhhH
	UiH8R7Tqb5HZ63cN7po9Uo4k87Lj23UC+6SPsxRJaKRpoDjGiQSnyZYxjM8cQB4UdqBCY4w7bqN
	EYJ7PIaxQTTu8BcCdRVpxjVncjK1UMWfqi0vhFLiQxoh0mfviBOl+leQIgG2I9oMG5jCcKjSftz
	OGSPNAvHdEwSxGp2opQAEXvwM1B7L/XCvbA97CpbMLm/RpimK76ILTQAQykFbeWwSebpNQ92m3X
	M79VVdi3td79cMPbA1SPcqE9XO1T0k+q6WVxAiGXJXfpIGKdnLR2HrSKMNDU66ypocsuKkBImny
	4sytxlR2/MtvwJX6GyfDO31ZplOb7CGHqrJ1MFSrKXqmGWoLSo/8THK4aJGW4qmAQBgF/OnIzog
	iUXBgbrXY=
X-Received: by 2002:a17:90b:3eca:b0:3a8:495b:d64b with SMTP id 98e67ed59e1d1-3ae57e2ae86mr3527341a91.4.1793253642110;
        Wed, 28 Oct 2026 23:00:42 -0700 (PDT)
X-Received: by 2002:a17:90b:3eca:b0:3a8:495b:d64b with SMTP id 98e67ed59e1d1-3ae57e2ae86mr3527286a91.4.1793253641022;
        Wed, 28 Oct 2026 23:00:41 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9db612sm2575016a91.17.2026.10.28.23.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 23:00:40 -0700 (PDT)
Message-ID: <ed272d4c-3571-4291-921c-e26aa78dec4b@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 11:30:36 +0530
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
Subject: Re: [RFC PATCH v2] wifi: ath12k: service all RX rings in an interrupt
 group
To: John Macias <dencity7@gmail.com>,
        Tamizh Raja <tamizh.raja@oss.qualcomm.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Jeff Johnson <jjohnson@kernel.org>
References: <20261025181955.2089498-1-dencity7@gmail.com>
 <CABkEBKZtaWkvxbhnOPBUjbh_iLx-Tyok0PskhduQk4O8qq=NVg@mail.gmail.com>
 <CA+KzPsoFGBe4PBJgjKQf-u+aeS9ckNALFjEkra_UoddRS1TPVg@mail.gmail.com>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <CA+KzPsoFGBe4PBJgjKQf-u+aeS9ckNALFjEkra_UoddRS1TPVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Yu2a1IYX c=1 sm=1 tr=0 ts=6ae2e10a cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=MOjrjcmSYU6aCDbe3KkA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: Lmch4weW5-MuOKDtcWXUfr5SMO8zHz3Z
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDAyMiBTYWx0ZWRfX+XjsIEEoMW5G
 i6I+EhRKcpfT7hFWjH4B2958wg7Ph/bIZ2rSzZ+bh9RUrOWjrBomRa7ikJV9eRZQRAD0M/Tya2T
 b8Hd0e77gLxc/yQMb1qyPkttBKN65xM=
X-Proofpoint-GUID: Lmch4weW5-MuOKDtcWXUfr5SMO8zHz3Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDAyMiBTYWx0ZWRfX0bG6ehCIAJq/
 aHIfdpj57YMCcj1jYLPUyMyO11eQGW3RKrlfv+KbpCdBEau1YbNABjyt0fDES6r31hS9ePpnLCV
 pcOFL0+5kmZcmTCcKvR6qvABtwxp7AxS/tB71tl6jyfnxKBdsOCx68GbZEXCIPT4O6zL02reKT/
 jybzT3ZCWtTj7XkFrs3dBrf+K1KGetmm/R00EToxcseCpmOAE1OC/PugcXBI1QNKr57pHcKD1D7
 Seg8CycJTMbs2lS4I3GAezQ4d6a/DK9IkDYRUPgYreV8R36ATYjdcBj3pAAjbzhT5pGHQbdVn0P
 Ag+cGC0q4S/ASvLaSYxXQcwM21ytiEDe7bQa9BPgQNZPID/Y4wjy6sB1fiSQWQyNBH2x2e5XZrC
 S5haw/4kpEIrIpKgWZSkcc67YBxrmGDTD4MnAyY82McGecQmgY8EwH1GyofSEPLCLywvLQOdXiJ
 KEqZYU7jsvfhtLXvFCg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290022



On 10/28/2026 7:52 AM, John Macias wrote:
> Hi Tamizh,
> 
> Thanks for reviewing this. You were right to question the grouping
> itself. I am withdrawing this RFC.
> 
> The reproducer is downstream only. The submitted base and ath-next at
> 7b14c8f4a961 have at most one RX ring per interrupt group for QCN9274,
> IPQ5332 and WCN7850, and there is no QCN6432 entry in that upstream
> source. The downstream QCN6432 mask groups REO rings 2 and 3 together.
> 
> Its hybrid bus provides eight DP MSI vectors, with ext group i using
> DP vector i % 8. The mask uses groups 0-5; empty groups request no IRQ,
> leaving DP vectors 6 and 7 unused. The host programs each ring's MSI
> data from its group's vector. Moving ring 3 to group 6 therefore gives
> each RX ring its own active vector and NAPI instance while retaining
> the original single-ring handler.
> 
> That configuration now works on the Slate 7 in a short hardware test.
> The tested module was built from the 25 October single-handler source
> with only the RX mask changed. All 16 four-second single-flow downloads
> completed, at 890-1166 Mb/s; the old mask and original handler completed
> 9 of 16 in the earlier 25 October test. An eight-stream, twenty-second
> download reached 1208 Mb/s, with the slowest stream at 72 Mb/s. All
> four REO rings received traffic, and the new DP-group interrupt was
> active. No warnings were recorded in the valid runs.
> 
> The driver reload also needed a Wi-Fi reload on the Flint peer to bring
> the backhaul back, as it did for the installed module. These were short
> tests in one session, not a soak or a measurement of CPU time or
> locking cost.
> 
> Your other points hold for v2 as posted. With two busy rings and a
> budget of 1, its fixed descending order serves only the higher ring;
> the lower ring received no service over 100 polls in an offline model.
> Each rx_process() call also takes srng->lock, and an empty grouped
> ring can be visited twice. I have not measured that cost.
> 
> For the tested downstream configuration, separating the groups avoids
> the need for this RX-handler change. I plan to address the mask there.
> If QCN6432 support goes upstream, it should use a suitable per-ring
> group configuration rather than inherit this grouped-mask problem.
> 
> Thanks,
> John
> 

Thanks for pointing this out. QCN6432 has a dedicated ring-mask configuration
in upstream series, with RX rings assigned to separate interrupt groups rather
than sharing a group.

The driver allocates 15 DP MSI vectors for up to 12 interrupt groups and assigns
a separate MSI descriptor and NAPI instance to each active group. Therefore,
the grouped-mask issue described in this thread should not apply to the QCN6432 series.

Please refer to the latest patch series:
https://patchwork.kernel.org/project/linux-wireless/cover/20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com/


