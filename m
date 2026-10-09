Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C070C43E4BE
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791553936; cv=none; b=YfKf+KrZSJkJm//RKJH9aA5Uyl0GxXivgEfujwYFF3qLQ4LW+c/uQPrHdMeRHMKNGKLUVlPubeD6mpymgrvcjG0McKscmOaX1FQVMdVjsA2OiVpjEn8Ohi3WXbbfb32wgUNk6tJ8QkCPV4+1QYVgx3L+z/w94HRWZU43wJm4KA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791553936; c=relaxed/simple;
	bh=PXQghjwcSP8cjms7t3b+QdUxG6nrt/Om09/cGvTeVq4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Fbmn3xzyyNn/7sKbDL0unDvBMG+3IrdtUxZPK8pC1LQm/+y/L2QGAC337XelgYiIeF7qc+CjhYQCdt12ITNKePdqNHEMyBPaJzSWlwPfFuLYSqKyF314WKqXMbj/X3nNN1DVXKdU5XXNnEJQ3XwbZWVnDk6HBUECNBuhNPsZd+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CLbFjZ8o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=au7S6Dk7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CLbFjZ8o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="au7S6Dk7"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699DkoD41956559
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 13:52:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eow5nDAkyvY227WNXu3zLt+s7l+RZF4J7TBYixptpkQ=; b=CLbFjZ8oUEMIw74o
	Pr8rBbHUU1nJ1UwIS78zyGcjQnVgg5Xt0tw5moOEGGn7+XXn96RzTAWBFydnfrNJ
	6NAspX3sOimeQsh5KcDbxUDwK+PbT8YDuwzPUOBlC/8+0TMhqU6D2O/eAYKaKfa9
	vg3FYsZnBDyL+mWC7M1+snmaup0HnR1OTYWiY5BaUHXIxlvyPEtJcLUTOyLOPWWN
	BTjfBCFllrehXwWpXmMRPqNGFVGG5e8VE5XBxHNzKbmlbjrZJIyT3BI5di7M7WUN
	svlke71y/HWAbBh2cZskIQreHmkf6sGE/otz6McUYNlPmRSz6sM6YkUabjp6ey68
	emx08A==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h71f28149-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 13:52:14 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-806004ec379so7772484a34.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 06:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791553934; x=1792158734; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eow5nDAkyvY227WNXu3zLt+s7l+RZF4J7TBYixptpkQ=;
        b=au7S6Dk7GPZlksbdBkNpElNbhmhFVVFEJg7KxWRTNRCLPr+fl1BzOMu/BevfHVN6UC
         WWcLFLATULjdRtf43P7ZAcYYEDtBXralepfL7bScw/PwRrjVnG+Pal6EcPL4745xRgvL
         Qd5X9H5f1+WME5Sgat+G+SpB842yWvY95VF3R8vnPtvoRoFWHzDpuf/+kWvO1ZPC0gXS
         f+WWzktJB4/n1fOfER6vux69Pa9a7EoKH6ERoqUA9XMTCg31Ba+p5rwJeyQxOefhGoPf
         NG7Yvfxx2PN4HlVPrxmYq1nYQ6Eu1qeoucjaa6aLhinf+qWBzdrWnVDn4ZhoD8ysKv7H
         Zqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791553934; x=1792158734;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eow5nDAkyvY227WNXu3zLt+s7l+RZF4J7TBYixptpkQ=;
        b=PcxR4lhzJlNcyJCOdcVuRwDf6JBVVFYtJd21X/4Wmcw+gY10inS9CiIf0iIgYVgK4I
         P6aXMuLFz6mf6jnleSmh5nOEIw+aX7sQAIX6JlgC8E/bAp2u2RcBRQ+mpxzG/GX4WbSN
         Ia2wLJRgFJW/TOr7hGiMhQD0kDkdpmhBqb+O6odFl6tQw4uBum+sJOpUClExXCkL8blx
         zZArPC+zZXPYNIk+piSXbjshyUG+Lrt0+oz73xP9hrM1NWDBPP+2glodq4XB9QHpkRG2
         LSaIPdQq4D8We2Fyc4OyVaxs+y8z/YU2id/CoL+FgnVFVZIGf+nb7z6lVeamMI3szcht
         d6KA==
X-Forwarded-Encrypted: i=1; AKwUvBwc8cNc8Q0tG0ME2LYoLl6eBupOnhFVXnKiVWeEOivhaAmTtyp+ijCzojpWfmf/LShI08KMvJftNcLbMv0BmQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mdQbG2HcUa2oZJenbeLdRJPYAUuHn+G+SEe222jL5YTF9HQq9C
	YEePRWiXMWUUJgci5pevni2faNlJ/7SKVngDuHpoNm/0VT0mSoh9WW3iOzFblOpbvTAIBk0F2Zc
	LPShOGFyxpgH7ZJH7s4T+zExgdHZNSEuR0nZz9EQjnsX+AFAjnu5ufq0XAtKxPQ2uacY5EA==
X-Gm-Gg: AYBFou2OLDNTXcS0XZzjIWu5RixygH9tbbkH23CYDrQ0WCdvoratVXK2o8aWihHmfdI
	2U82DxcCbjGejdjTM7A5VcRM79x0/9WJGsmyYFZW+39c5L8DUxHmldtKxCGkOCd3TghNNdsoro+
	2IpjPKbVjBfEC1w4lBumPgOtHSyVmXNOnCucNSdgi6XL5pNBNdCqvNIZRPm4cfNVM9LzwE0p6Ih
	3pql22RlDvtvSD3QnhHXmYDkKETNlcGbQGaJXOLwbUPPr9xzfTrOFZ2a1f37ybQ0ZPavI4ofIzZ
	+jO+68SkeaXOxW+8hMfYgWsKQ9U/vR8qPvzZJEpBbPml2GL2JIsMkdfz0iesZm1tlzvXb31RKJ7
	OKLCRww1+JBBPKJ7D7hz2GYbtWfSb1MqzzxPJmok5bgiPpW/Hn0GMGiA=
X-Received: by 2002:a05:6808:138e:b0:4d6:90f3:74b3 with SMTP id 5614622812f47-50c553c9e9cmr1325765b6e.51.1791553933964;
        Fri, 09 Oct 2026 06:52:13 -0700 (PDT)
X-Received: by 2002:a05:6808:138e:b0:4d6:90f3:74b3 with SMTP id 5614622812f47-50c553c9e9cmr1325740b6e.51.1791553933478;
        Fri, 09 Oct 2026 06:52:13 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-50c16755587sm1949024b6e.5.2026.10.09.06.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 06:52:12 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Vitor Soares <ivitro@gmail.com>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        baochen.qiang@oss.qualcomm.com, kang.yang@oss.qualcomm.com
In-Reply-To: <20260922200643.1133491-2-ivitro@gmail.com>
References: <20260922200643.1133491-2-ivitro@gmail.com>
Subject: Re: [PATCH ath-next v4] wifi: ath12k: advertise interface MAC
 address pool
Message-Id: <179155393169.875832.17468268809769517120.b4-ty@oss.qualcomm.com>
Date: Fri, 09 Oct 2026 06:52:11 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: hGujs3w5WJOG483c2ZVOaOrDKaecn2sw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1NSBTYWx0ZWRfXxwc46Ap6OHCO
 5XWRk7tOje3J4vSJqEUC0EjIzbGPR7K2NvcburuPJy+wRI0rKnfjwz4ojSTAjMAre6EgnFKnzmE
 UyV9EmELX33uaTu1beCGFsjitl/3D9wj3raJsVe+oInwh5iEbclQyDkT6G3rSxZ9vljjQJf7+r9
 dJjkJW3MY6jU8YmlcJbjjb4iCBd3tTaffeeUbitfhvmrXtQ+xQY5QgIOeWo/09HC9ONb4SQWBS/
 OVcq14Q9LpUhLTKcHVEU4Zbn/2TmH3pJJHTTE43ZhggdXoNqn3g/Lake1YmoHMoePT2Y6LHRNFK
 7Zr1Stm9DXvK1oz8GrU78pJFvp9vffZvOF8lv9vm22Qqq4vwuqjUDqtfr5m8rCvZ6ttG6jnyu/1
 RmzbniK3zmmiFQdi3cY+aeoXD1SooS3OuCd46VNjt3wyhVuPY7Wk52qjk6P93lNjovIb3tD+9bV
 OxjABJyDzmYVPuj5mKg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1NSBTYWx0ZWRfX8ROK54Cb8MWr
 U1snFYf+Mft0HisrOeOllAEUqfqEILo/0KDwb8H2VFCgmn06XEgILdp4UFavi51ayFIkCWWgAys
 kEZeqEVfC2WQQ6ThXu7CD6XN1qTFusU=
X-Authority-Analysis: v=2.4 cv=B8ksQ+tM c=1 sm=1 tr=0 ts=6ac8f18e cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=rRgXgv_aqFsOssekQl8A:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-GUID: hGujs3w5WJOG483c2ZVOaOrDKaecn2sw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090055


On Tue, 22 Sep 2026 21:06:42 +0100, Vitor Soares wrote:
> ath12k supports creating vdevs with addresses provided by mac80211.
> Userspace can already make concurrent interfaces work by explicitly
> assigning different locally administered addresses.
> 
> However, ath12k does not advertise an address list, so when a second
> interface is created without an explicit address, mac80211 has nothing
> to pick from and falls back to the permanent address. If the first
> interface is already running with that address, bringing up the second
> one fails with -ENOTUNIQ.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: advertise interface MAC address pool
      commit: 4b2f8de21708c02203a31e2e83f8240dbdc702e8

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

