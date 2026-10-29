Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280562;
	b=EKstsg8oz5/B+zyPsC+2JwuTKERFvl7D0egz8NAhJtHMPoUa8uq7LoQtl7fdA9x9/ozj
	 PjQQISNPi+mpEFxrNOH8WEwE0/Bv1bLrOmyQ2GYHR6zK8M3UwxoohyBD3tImTnGfXoyDj
	 Vc2+SMAzhpi+Rf/NyR3A7TieKs8PtpCS0ZYgPIhhk/MUBlvByegljBo8WlGbS+bh+7pK5
	 QIaYPUVMliLt9FiiFSyNu+LLNwpUEl0lJweYlEkfFhAUGVKmdBnkA3HkGIq+iKUfWqNBo
	 iFs1EpwqVugftn6iczg2aQwI7FJld407X5RR8htak9HFmAC037Wpyu+A5ohmPBJNdrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280562;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=hdNAv1DWvXXl8AhO5BI1RSsKl6nrZ5HKBAmEionbXos=;
	b=Z57ZpXQZndnKNJIQMvnhjfSD4qIn/O+AaNGP+iyHPcwCl69jGBfZw8+2aWksWH+i0taJ
	 5EMqB6E7E7+Z5hk8mFuumArIfK5T+qwXHQVlEJ3WpqSY34AJeoJbXhmLNzLOhVVhgcLzp
	 9RiCVCLVewrflDyLJWLDZE3mwzY5iCscYoQ8WLJaUCi21zt+AHh900z0kJKvIi0c6owVI
	 XSJDEvt6jFhQcU1uOuzg0mZMOSbtbxqrMweYjRCHLi+Gdtv2M2yavgU4DHKereI/k46tg
	 8MXJQQKGGBjmkzhRPNLYJOkXccA4Vd8JwOsiO/9Jh1iSYwguCXMDKczX+A5TUKfc0nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oRuQK3BQ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N4SQHm+V;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BD7606A32C
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7BD7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oRuQK3BQ;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N4SQHm+V
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeN6L669557
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=hdNAv1DWvXXl8AhO5BI1RSsK
	l6nrZ5HKBAmEionbXos=; b=oRuQK3BQXyzkGuOzxHBHr2ppzqgCEJD9XPLxut42
	jjOCo6h0q2c2DFNDa4hevb6u7QefiUicMYsGvkBXfyyTjOxGABnJrrJ891jpvkM1
	rojqN5G8A3YjgKjV5fkK729I9ZD7ef+MYbUf0w9K6ctPZ6SVDGkpESGaoBs9rYIp
	ZkpINwDT3vaFzak0hLqAOUwc5v5cOd3Ca6qcG/2gUO6MnpjEUmId4YYINe4AzQXI
	pHCt+jOWsAMALyr4RqPIxiUwK7heHmRM63xmhSnRZqLptZWeboFoSCcM74wO+Msu
	hHqFhtghPFFPkoGlH4A8a5/8ie+noqbAaq42ZeVcEZx6/A==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkpmc3qe1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:29:20 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e832c03576so31713545ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793280560; x=1793885360; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hdNAv1DWvXXl8AhO5BI1RSsKl6nrZ5HKBAmEionbXos=;
        b=N4SQHm+VXzeW4REvj+4AtK1iawDIxgPHVm8sDOafNEVDEyf0byi4UmWMztzXCXzhzh
         82gGwT1B1wsFVstr2rv49/Re73NO5c0cmK1cDpmTviuI2YJb/A3V2uldAl68MbAHYFBX
         9atKPq7+TrCiIcY8wjm5JTZCSdH4g+q/dF0PRvhjHVVtgVWscX35nWHTbwJP20Xzw/C1
         Mes5B4rHFPnSDoEafbb+askF7Jq2pjVhW3N0MzO5fO+gVa9A+Zv9xwdcGfsfzhciTXoD
         j22TYuLUu082Qtgm4pLQb4jpibrTVqjLq/jD7ys5wwV5Ka1w75AOfKkohOwBTvOOS3W+
         +oKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280560; x=1793885360;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hdNAv1DWvXXl8AhO5BI1RSsKl6nrZ5HKBAmEionbXos=;
        b=VeoboiO+Oe/aIBr2UgAK5dAlX5Dbg6eZ9ocmeZ3bUzkiOm0PD4KgoHMCAaIFILpYqO
         k/hlJLVeAXCAT+MjTWLPhJbmq7eRkcCeOKRAOKoIk8NK1qxAZcYBgAd83v/6ZTHYesWP
         e/OiQXbaFn1hbN7hU/QJDGOEpF+UYHFv96S0zT55opcZ+Dxps55c5MeaiIGlCP0h+cr2
         EyK7lX1u+IDH4xsqbwMQj8MZHw6X8asuFTev0R3AZn9o37vOd3DuST4F0463VuhGWbUw
         Uo5dus3LdcjNWefPSjp0huJ18cuZVBxUn8WiODHOq+QmOppR1P6yV6+Dqa+9cyYAsRgz
         STpw==
X-Forwarded-Encrypted: i=1; AKwUvBz14srIaxgi4qfgQYeoTXRttdPIFWBcwU0Xs8HzGyO/HVr+JExunNbL1n1bKF7NOKySi9dg9G3nqXtZkBzFDA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIt08CDHnBz+ocE8zHbJOD+ZKxZaoTlNc251u9ROjmBzCQ4U1iV
	6uo5zVJEu7GPojWq6YBRM3ecFEW1riB8q+UD5enUJXjPqP6fx9sTXK++0EZmR6O4pIOqUxOidGL
	pOf6MayCn+VHZq1u4AlfoC9TN4TCpcZdBugx2MAjkse6U4khu6k1TOzKkmZ8jF53154VX+A==
X-Gm-Gg: AYBFou00y8iM72XO5DLmfpdBrRFPbweJpdlV/uz3MSC1h2LXPhwy1CM5DSn2CnJ0s4+
	MuVLgOoCpojnIrCVTTpBhGl2MmJ0WOROXzWTTSV23qU8ZCybZSnfmkdEc9ssag1/cHwyiMDxPBE
	CjljhOUOCQOVX6CbkiMhFJJ14htKbCmkfSq/1yLrRn54BEr47LojyYljx0g/oYNcVpIMF+dexUZ
	hjfKcHivYACZrV05PdlvoHt+tES4YGRI8OiTOoybNqYgjOmqfDKdllivwQsQldZNL8UQsm/jNgF
	Fy+A33LQfpnliNibtMZirmofSS//DXYuPP3+A0pamNFxs8EOE6oM2lYCwotBaJlNmkE0V1tizXG
	W9kHSYl9Hm0+YdsmrVHFrhrvNCvS5YNRUKunZ+JVBx1oRR16MBVKPjIydr64sFiRkAFvFquZQWI
	/3BKVGwlA+CmyXHH8=
X-Received: by 2002:a17:902:e886:b0:2eb:1ef1:f055 with SMTP id d9443c01a7336-2eb1ef1fca0mr22399005ad.46.1793280559705;
        Thu, 29 Oct 2026 06:29:19 -0700 (PDT)
X-Received: by 2002:a17:902:e886:b0:2eb:1ef1:f055 with SMTP id d9443c01a7336-2eb1ef1fca0mr22398775ad.46.1793280559240;
        Thu, 29 Oct 2026 06:29:19 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6453e90sm34035495ad.1.2026.10.29.06.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:29:18 -0700 (PDT)
Date: Thu, 29 Oct 2026 21:29:11 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Yingying Tang <yingying.tang@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: Re: [PATCH 7.3.y] wifi: ath12k: Increase RXDMA buffer ring size for
 default memory profile
Message-ID: <auNKJ88kK1_QTPTi@QCOM-aGQu4IUr3Y>
References: <20261029095541.685879-1-shengchao.guo@oss.qualcomm.com>
 <2026102919-confound-remnant-f133@gregkh>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026102919-confound-remnant-f133@gregkh>
X-Authority-Analysis: v=2.4 cv=X4nHu2Te c=1 sm=1 tr=0 ts=6ae34a30 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=MGbNdRo_2CZBHlq_cxEA:9 a=CjuIK1q_8ugA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: JNu8J6qJoxBvKPcRLCMOQHCAY0LyEKEK
X-Proofpoint-ORIG-GUID: JNu8J6qJoxBvKPcRLCMOQHCAY0LyEKEK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MiBTYWx0ZWRfXzjF/l8oasNA8
 gHyQLOiG9oUBOyMTpXv/WdqRhPj5IR72inb5RrHjvAeTj4n0t3mkAxAUhzp8lb05Al2mCVP3lFU
 9hF68XBIF6hO32zWVnTTMb/KTXT3XyTwGoRswnL6f+dqSiJHVovTTgYuj4lzRNKwTgw6E3qfaf2
 ibS/gvV9L00jKMNd56iA9ij0GNCYemSqT7rTwFWvNEabNp8RDMZUA6GW5GTQWJD8o52ASVzfQkk
 DjlbJadbuMrozday9zm4QGutif7+U3BOfOEVBgVe00y7F56Cp3QkjUgCejaJd6ru/WMi4dZnd1b
 aQoi4B6XqWv15vd4FKB1ZWlwQslrNZ+1+XYEQZvMIQHY+yEXMd8S4coE4OEgn3DfMUZrAv5rC5W
 OItfZTgU4YilAHsRrSxYL7KNMG35m9X85icyZ5WVNiw6S96WLfBzNtmV6RfaoIlg5N+KI2YmCWC
 UpupamtdnzvGu/T4BCA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MiBTYWx0ZWRfX74Tgwy9jdTze
 WtBUnqzT+4uesvDzbwd05UfiJLZSy/Cc4xuWlR2TzKVo15keMZudibQ7X1yTR2bsnUtYsjiolYH
 8xN4oZbvsOXWvHtFqxoYanAT2eIsrN4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290052

On Thu, Oct 29, 2026 at 11:14:27AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Oct 29, 2026 at 05:55:41PM +0800, Shawn Guo wrote:
> > From: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
> > 
> > commit 15f7603b69a83a0acc7fcc8992ecbea6110f9424 upstream.
> > commit 643f0bf936176c114d5631da7547e991b5d99f10 upstream.
> 
> Huh?

Hi Greg,

These two commits landed on upstream as a series [1], which doesn't
apply to 7.3.y, due to missing prerequisite changes below.

  wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper
  wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
  wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
  wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
  wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
  wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
  wifi: ath12k: move dp_profile_params to dp.h

So I adapted them into one backporting commit. I'm open to suggestions
how this should be handled.

Shawn

[1] https://lore.kernel.org/all/20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com/
