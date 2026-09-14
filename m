Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8B2386559
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411589; cv=none; b=Bdv0PDprgxLleIMfinIU4p/ihg6R7HherKKDYgQ/PMHasQ30ExwUVAz95VqWjXj/wjU6CCWyYzEkRPPUEmA5pWBe8cufxog8jd1kmXM67vP8sSInaQ8BWjc8dEpDm45y30fP2BzIsbWnzI2lpaHORtGvkKDgTRJsyaUWXSFfgQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411589; c=relaxed/simple;
	bh=/8g8dechR+/Vj9t/nQ46EGGHn4SiPMwOZ/GvTtA80Yc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lhlrXeL+RXhA7FbF5EA8JaHcp4psm6ofZEWPOu9j69BQN3HR/n1LVBiKeaPngvVyZWwvzaESh7jOrZaqF503CMTcWiEvD0la6CJGcfjVawtarIVoJYf3tJ2dKOvxuIaNr28KDn20DqAcb1+i01JU6Hd5xtKRs2HsRA38e8pWZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nxQz1vLc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ujsbd5zU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nxQz1vLc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ujsbd5zU"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED0ZE64157651
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Nfvq+5Yyj0sd0gHJP35ZxMIsGdDSYDtwVPF1iXJOIRY=; b=nxQz1vLcXvGcV5q2
	O0SsczMHIbYthUogD8pwdoQYjF60BfbYFqhah3UkEiBrLpK3fm6x7FqC+uTQXRJb
	RfbWLX0u4dTpgkElA1dbRPv+Cq0TuTdCa+cPW+TpaqdKStomNWT4PiGiBOXZcLow
	6wYJJyj8qC8JJxV/0NKgOgF5gEfiNIX4u5yvgS3SD76B4fu0Joa9uY3JCV6aAcLG
	65H5qftG2kzo7lIGY0AbefV++lBPQkiSOI0cIapcu2Zs+VlIuVGBEBwB453aNVzh
	NBPRKAc2XYwINQeVzKXiWeAjdD5aDiWhkuOszyJawgM8zLc+bSNQcWFQ5t/WEG9O
	/mPoeg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpd1f2m4u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:46:26 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1b8088202so3124132a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789411586; x=1790016386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nfvq+5Yyj0sd0gHJP35ZxMIsGdDSYDtwVPF1iXJOIRY=;
        b=Ujsbd5zUo4RWJqWMwc8dVjaR8mIinGcmBHDFqHTWtixbpreI0qaVeQ908LUsgYQ3U8
         LNFVgYPsIAWX15d7pJeCJ8TVTcrdgeg5xZnuL6BU7o/ikPYU7Fy7lfrU9BghgsOiwCAl
         43QB2TuUqO4A88EVBuGG8CnpLa00ksaR4iasYKKJXlHmWT6CNmTvycRodEXiwdFIaVVr
         Fmo7zZdQtlJuaPCpTeQlZVMCQIi0nNbBtj08sfKqd7d5OrmE/ToAGQSJcF64eUYby2rZ
         jTv+COV4SGT074PWil8k3dWFZ97Ila7CC64oRqMMCG96aRUk4p+e1BFokqK3x5pAjubf
         yq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789411586; x=1790016386;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nfvq+5Yyj0sd0gHJP35ZxMIsGdDSYDtwVPF1iXJOIRY=;
        b=IOtdM1DPgmAGyk4uiCUsL4Tw72LNdcrJG5hohqti1de8tOryeYDeAaTLT983vJstSE
         V/WSbGzt3WdWPMSwFG3Bqbmnpzw2Bd+6VJHMuMBwr6iYLmbm2ogjHc0Ro/MBYmCYF8su
         LQJhmwg9e7r3mR1QmC2hdBErkbkJNla3KXVGjHeMpqUGFmcxce+FXUJQd4wYvk6HGxXI
         FgXc8pKcoxpNjp5v31IhCUGtDni1zTcEQazNFWqEnDUPysgi3q2DAiYUQLvtBcNZkozn
         HZziOEZ62M8DNz1iUKuopSGPrpPAqSMsPB4lCwUgzvmRdJd7AnF94GHYNAnPCGSjZUFn
         /w7w==
X-Gm-Message-State: AFuF++nTm3VvFsrgXbCQcX2e4m8Y93PZG4wPpCgyNRhOmEML/NYn9HWJ
	tyZVK9RsinJ1O3faiFed7VuImCgDbN20uzgxZDuJOsGMcCqjbP8dXGzQaNjr1uiQonP4up/y7nH
	CjKTHLVTyDhJH7pUAStjsur8g/o5wKL1T8g22eVmHOCNCQDLlwqBVhjkmUE5VBsn98HaZVQ==
X-Gm-Gg: AYBFou2RAXLjvp7UpRf+44ViSv0KZ5jk35TFdHKuSlN+VYeszN8Dg49sBkMW013dMcH
	yRgm2MC/23lUQ35Somv7PeQ14SYWmrxpAYf23Um0HHbsirNwKg08n3uHAwXtJJYCZn4hYl6mjKk
	vQh3C5hm2r3YyBIPEKE+I/vgq/fwbfSBJzjZxJk2xYUCd/SdfczcYx+Te37ptJiX4XBXb7EYuHG
	zvttEYtmv8mD2u1Vo6+CFfn5O8L3ikS6t4XDmMShlW1TOSU+YsgxZv+lUJeujE5BUNDa6YkZfR3
	b9oMuowYS4WslBUus/cCSJSLLBg2ulY3NlgoPNMHYST4VifPZaN+RlP4PMkY8wT0iQIeucOFJgh
	9++zuk4s/OlUTyVPoQ6eT+CvMh0FyH7A1uzGvgJUREzzUkD+DMbmnlDU=
X-Received: by 2002:a17:903:388d:b0:2dd:143:d5 with SMTP id d9443c01a7336-2dd6c75a396mr93751205ad.22.1789411585918;
        Mon, 14 Sep 2026 11:46:25 -0700 (PDT)
X-Received: by 2002:a17:903:388d:b0:2dd:143:d5 with SMTP id d9443c01a7336-2dd6c75a396mr93750535ad.22.1789411585532;
        Mon, 14 Sep 2026 11:46:25 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f06423sm32032524eec.20.2026.09.14.11.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:46:25 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>, wcn36xx@lists.infradead.org,
        Fan Wu <fanwu01@zju.edu.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Song Li <songl@zju.edu.cn>
In-Reply-To: <20260910020907.3353-1-fanwu01@zju.edu.cn>
References: <20260910020907.3353-1-fanwu01@zju.edu.cn>
Subject: Re: [PATCH] wifi: wcn36xx: Fix potential use-after-free in TX ack
 timer teardown
Message-Id: <178941158481.2896945.12592794463351144107.b4-ty@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 11:46:24 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: YfZutf4vHbyBnRAADihE-JzNic0EsNDn
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDI2NyBTYWx0ZWRfX2JrB6cwjuQYA
 VFn/Om2qDNqWsI8AkQ6YXmhD3ABSNAL01bhmCXExXtJdnN8eBMvi5mI5VNpqA/o4ugNjCsEtTtY
 YoGyrog76ijM2QZHzHgugULCteZNvXw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDI2NyBTYWx0ZWRfX/1xfIZVy3LCO
 hxR5V2B2z6t6h0zRFYNqeWOn3U1If/U9CZl8rOMtK09H+2BkjFVhkmOQtvAXKFnvJHvkkNMAqHH
 qiLLjlZ1DUzckO2gpyfxFP0icQWtBsFCheteglYfp2+T8jQSFj6GWdPwPxpre2pgGOUG83gmexV
 Ja6tMZsLWZxwZAUmx2Nj1BJ4cbpH1xH/amFi+Ffemkyf/t8OpQk6XF3lTVflQh3urTJqlIhaDSi
 oh6eroRWESxGH0n+j2DSR4n6suHUEeQuCAJEwxTFpkPETrauMSaOscDjz2Fs6pqhkioKbGxxjAH
 mRhrktRfttMVEntcbVnL6nk5Hw4DZbaKsY2AxDSkG/sAUfqIi+r1J7DdXWCo+flOauPhXsKPsMY
 6X8rJGV2uYaaMiWCTcnc0hwwVVT4rdYskbSv7BKEkdvwRntTrpnY8CHM6HXiCM9m+fNckAi3tIx
 fVFBy7itmDPa53E9xFw==
X-Authority-Analysis: v=2.4 cv=XKel2ghE c=1 sm=1 tr=0 ts=6aa84102 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=0lvdRgit-FxgUHpCPWcA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: YfZutf4vHbyBnRAADihE-JzNic0EsNDn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140267


On Thu, 10 Sep 2026 02:09:07 +0000, Fan Wu wrote:
> wcn36xx_dxe_deinit() tears down the TX ack timer with timer_delete(),
> which only dequeues the timer and does not wait for a callback that is
> already executing; the preceding free_irq() calls synchronize the
> interrupt handlers only. The callback, wcn36xx_dxe_tx_timer(), can
> therefore be running past the teardown and use the wcn freed along
> with the ieee80211_hw in wcn36xx_remove(): it takes wcn->dxe_lock,
> reads wcn->tx_ack_skb and passes wcn->hw to
> ieee80211_tx_status_irqsafe().
> 
> [...]

Applied, thanks!

[1/1] wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown
      commit: d9be5e75530772fc31637070d51e5717d6aeaa2a

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

