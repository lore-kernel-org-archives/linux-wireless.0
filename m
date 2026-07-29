Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC9B36F8F5
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340004; cv=none; b=bwRWxE5Nm0J9BwSB/ctyitYZxyf6xjaBcABO4TVRgPUBcgdsROpE2zySKGVL5mn6KB3JGc5nom1U1NhxVhOI0MLesGzLKX73PiR660NwQmM4Z6+a4M4LxLaD+qV1LmS6GepzW1jAYZtX7xJqO1MeYOOwr5pT55noagxB1yR9viQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340004; c=relaxed/simple;
	bh=kAAZV6Ke9W6NuiZODhVXwhOXoHE0nGV8U1CdHrt2NSM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tRszZFD1Zmt2EU1/Dl3Eb/sCgFi8FQRs/AEjctpVyH4aFw2/gmslgP7p+xOM/Qo5/+38cdAmt4wnHXMEpswKNoQEZVY9dX86ZTb+n+PEYEPZk3kt3wPVSnGc7O8sUYO5HoJJTmIZAl/TwESB0dcjVu467UM0fM6JJ7dOyyxLfWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h9+SSUmv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YkNgKPgI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h9+SSUmv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YkNgKPgI"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF3JEP2108303
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JHn3z83Z1e00LEDWQ5Z3WIqS6nbwKVZUmDm9mg4b/Ns=; b=h9+SSUmvbHGF5rLa
	GuYjgcXFTLqARvq6F3ZUCK7U/VGvYI3bJwKvXVvaISoRBsxbhZSEaQZwBqPM5Txs
	+y3GEjKPUZ+1bqKYv/Iyyf/fSJ4Afs2myTpCGNfa0/NzZUQMO7YuEZOLPpRdwf2w
	mUAdUk6EnVfD/Jl0v7I/ingVcA20O5QdTUATKKRdOVQaaF+fyxoV+GLXCQ0kBgnw
	eEQH2Qsg9xOVHwA8TpPF18KH/XpXjIwkgJEyEBVgnOvQRVQTZK4fdwAprOVZD7SJ
	GZfGmnjhlXrk1bBqmj/ZCNlcsx/PZ/ipKFtV6QSwEg8sTJUshTDXtvtAG/8oJ0+H
	iwGNjg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqkds8e2q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:46:42 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d001671a54so23445975ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785340002; x=1785944802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JHn3z83Z1e00LEDWQ5Z3WIqS6nbwKVZUmDm9mg4b/Ns=;
        b=YkNgKPgIjmvo4GdndxNvxY7NzBrD3nHVZ2VGZXs5KeebPNGeFR7GxRWJ19shZG0B49
         hvbR2hClrysoqy7TxSLPl0jL2dckZcVebZSVfy2Vo7Bt3vwwFuVVUWptGGcWHARqs3Hg
         0bpvtfWr8YkmcQDpDwO73pt/ESKTI6jswOlQP7rzxVCvtnQToBKKyM+pvFJQEpRFUphF
         i1FCW488gX1zhbar8EYiSrFaA4vct2N3B4USwdtes0l/pOJc8+KWgd6Tj4e9+lAOyzsy
         YYlP2dW5OlQ/UPhQCDa0mlCJo2hcD9J1ddveOTGPTJz7Maa3XEP3BTblOwq9/CTejVfm
         b8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340002; x=1785944802;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JHn3z83Z1e00LEDWQ5Z3WIqS6nbwKVZUmDm9mg4b/Ns=;
        b=oHu/SKDMZqE6iGv55bKPZ8K5ClbCSFrRTsQQXpwE3koniZBAY7l72Cg2i30IcS8TsF
         lB7B1zCvHrQC5neFzUYdsR2a2gu8nL8l8dvP0aoAWukJLGY5HOTrOHTSkpgPdkf0IRvs
         TuNr6LrfaO3AW6phBDVGqZeF4i+TRzjURpufFYpZCP0dzBXca1WQ63DlI5bGedhphux0
         sSNaPDmCKUXmpkGvJleaz89pOlOgmMEozEkVVrGV6G6gk4YchZCjIOY9empNaNmniNet
         SXiJzkYZQR4IGxmQ7C/SgiOedMv0eEpEyKH227X/c/HwUkxg5SFz5N4d2NWaxsUUaZkX
         ewAA==
X-Gm-Message-State: AOJu0YwniMoVFoWL00Rkk9XwANBh2pUK6qqjpv/1cB8+V6+bbOVtJ0iJ
	CbiPG7QtpOuM/1EqlNxmjpdAyf4wnA3d3pjv21f1Zu+YkhijD4Bqo1+eOiQDdJu9/sh8J87BoTS
	BYConFGojWD3/rsluWNP7zJgFaHIHnlumkG0zm/xAxNP/PWwJs4ensDH4pIy9/FW+eXv9DA==
X-Gm-Gg: AR+sD13DDD5E7AJPx37+eJpEYXNmojP2kbc4Wz0Nrkc8j/HO6F2AVrE/xC9NcoZK7uv
	aKAnph0LddYSF1l5ip/g7HDsAfk4XwNUKLsGmOJI+UUTd5U2yGEmWgZ54wvCyrbeI/Og4U5MEB1
	WBvtfjnitc0o8xigheXOBaxH13E8wdI8Y/voIVw+mjZdCuAF6tVmD+atGytXqhfAuScBP2UYeDV
	1oAOcpnk5XYeHhvKcLyW8rUxS1yU/ocmiFzsq+swAg+ob+WFiKc+V2Awryq2HvDSvfnPyozXBlj
	0kSyHD6vf+zw8XzX+3qvIBqYf7Ehe0/x888Czt42REuInLcnj4a8J1vkHjQg3dxRlANwYZMsxCf
	JNk5s5o402oBSgkEHYWh6lve2YqibKO3uXVykTqhe9oHr1flw2j3Y/RQ=
X-Received: by 2002:a17:902:ce89:b0:2cf:47c4:3d1a with SMTP id d9443c01a7336-2d015b14a19mr81944615ad.3.1785340002112;
        Wed, 29 Jul 2026 08:46:42 -0700 (PDT)
X-Received: by 2002:a17:902:ce89:b0:2cf:47c4:3d1a with SMTP id d9443c01a7336-2d015b14a19mr81944205ad.3.1785340001609;
        Wed, 29 Jul 2026 08:46:41 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a76a5bsm13577185ad.35.2026.07.29.08.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:46:40 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
In-Reply-To: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
References: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath: Fix buffer overreads in CSA
 switch count event processing
Message-Id: <178534000034.2826154.16110623603163023219.b4-ty@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:46:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX4nzBWIglLr+4
 JYrVu5whPdOY4PVA1kYJ0s/gFiqFdRBsIpEpKKxdv2mLHlsDmKdXDABk8H7tqpiKBNBV3hFtSu/
 J0BZKfawfEVNeKZ7vHTlXsk3e999PDo=
X-Proofpoint-ORIG-GUID: inM2dY7iHLiIA1WBzArj7EUA53lTNrCN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNiBTYWx0ZWRfX89wbCadoiRGa
 nsmFlhLnRZ/ncyjGgnLQOVN7uxmMYw5JzYaY/+6tfM1fD1U0p4F4+RGuKFNozqo5SWdOldKhDQ8
 q2vwGbkI9Y2074lQhoJXa0JWseKTlU/uYrTaruiu9NOUtn1TEuDX90UrvpkqVB3ZFDKOmfGIoZu
 g2vqJaUyUu81miZuCinUT7zV4KDGQzUnrpAg41M8ZGGGptAKUqzP7nVpleBh5660cKheQ+oBTpy
 1/73Dmy0qfJRXjUaKmAYZgEm/ANpO0xLd8ve8lh7xWqnYPCrwlXGkQ1HGuoab3ICHZ6dv4T/O7z
 GqDPMZk/n87/nLKfJFEnD810hyUBkVMt4oa5YFt8xr4KS1QHmokP8qvXM2imOjS/jb0Nq/01F9M
 MD5wj0qBXgePM+7Yo/QTUqX8yuXxOAIX1pnmUZWFKtYgRH8LW1bxudNTl4Xnr/DakVT+lVJybJh
 lyMRN9r+Gw5OH7un6sA==
X-Authority-Analysis: v=2.4 cv=VJTtWdPX c=1 sm=1 tr=0 ts=6a6a2062 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=2ZIKi5-oWpO6KCP1_QMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: inM2dY7iHLiIA1WBzArj7EUA53lTNrCN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290126


On Fri, 24 Jul 2026 08:56:12 -0700, Jeff Johnson wrote:
> Both ath11k and ath12k fail to properly sanitize the CSA switch count
> event.
> 

Applied, thanks!

[1/2] wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
      commit: 878654eb78c6aa0ff585baf1376567c775ca28ec
[2/2] wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
      commit: 208d7fdb85976a737a715b81d54efaff6703880c

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

