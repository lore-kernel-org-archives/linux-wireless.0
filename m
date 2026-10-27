Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793127252;
	b=QdFOCM1IwmAI4MjfgvlGqVAa5Crnp+mON2KGuH5GpYlh+rhCo+HWgtAfWhMP7H2PpxMF
	 6uzJG2LyHRddx5FLpJEf7L8G5PQNcmnJWDtI6ixNKDVuYemj8SEzMyyYS+sp9d/ICGiAV
	 SKMDLry0c9mbZxQoqJx12uNQU0FoD3DvLekjIspDRnodRjLB7ow7AsDgRuQMcRJ4779cH
	 Z0AyaPy4Yl20DeiaWvnNp9Yi+of/jTCv2t9po2qUj84rwJ1jhvh3sfN1pWQjiWGBD24gX
	 2+RO0sdQyoeIZPNFEfZAWnh7FFiO++XJvsZxUGbk9f5LgrqtiGwm/njsooRBZzuCExw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127252;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Wit30iP+wjWokmtkJr6+vqKTT/0WES+HK7+H57YGve8=;
	b=f/8JGHG37P9tBaJTKEus9FDZrZjrTo+QUVADdtpCrWyjlmZLCuagcHBLu2upPsnVd+ix
	 ZGt+WGs04r3HhS3df4tkfFStJoDC6Dsp1YAFJ6W/2aEfXoDF3WI6dx/KsTIgk/8HOvYhl
	 KpAIRKHQViq4nAsQNTKipwviVBf+bfm4P8adI2MNoDAw+T5tIaTCl1fwQ/Q9uxa6mT/3L
	 ypOw5EL2UID5BoGjrNP7jBI7IP5shBruJ/M/iaXoQ0B9YyiemMRthoL/tggdXB22nlCJQ
	 rp4KJSAmvTKRO1kaRHx+Perv/I82uw5Fup4G9qe/X9GpMGGiFkH4tJQjmkLqFnGMUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DNh04kEb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OFfX4i18;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAF7606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFAF7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DNh04kEb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OFfX4i18
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RIHZKf1917416
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wit30iP+wjWokmtkJr6+vqKTT/0WES+HK7+H57YGve8=; b=DNh04kEbIqQyKqOs
	zAsFkfOjfchzKr70a8dNXUi5DG5I+4Tdb2gySDSRBgHbfOGcXnwkYNpy5u6A5N/V
	BIKtpbLgRxJpVCBxZD2yaT+dW3uIneyNeQl6TE2eOlrsu5xasjotFKACFC6NDNpo
	OkKs1m04l3yq3voXOwkbbFuMc0hMe+rbxK7FiRvYpZ9MgHb521WIAV509+VwmgQA
	mN7tkhd15ZCig3DyTUBkVxupQPkSbhZuATg3e6RoUOniJs2EaFPsxfp6Pi7THLJA
	AB7fHGsZtgBPN5zebiG1i0SDnXU2dHwShsANm/UYbwkVdeU+OmT3WraJuo8COTyX
	G+whEQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjux99r38-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 18:54:10 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-351788121cfso627880eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 11:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793127249; x=1793732049; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wit30iP+wjWokmtkJr6+vqKTT/0WES+HK7+H57YGve8=;
        b=OFfX4i18Do8+xnbQzzZLPE9g3o+pPCZTjjx3bxP5m5ePqpODLQFlkH13pnox8KEWjF
         fLnySmU6C2/HtqCbzvlgx4/F/qLnrpaPFbP/8pHavBLv2WI+BUM1+8vZ3aCbRu1ybBGl
         E7jRWbPXBWY5jLz7lmDMaqbR0+Jh7Lj5LyG1ifomGQ2ZbB/0cG+xeI2Qh6lkV5UNb52Y
         CMsro+hZnp0CwHR4UvTg03b7/9noyQqZ4r+rnrYS8IhV1bbdNSCBZpt3o65FnsoG/u/p
         XRh3bGsiO2CuhLU5CeuX5yhNmDOVfCUU/oxJcqsjZQfErDD3STXwNPqsauj3YleMYnYz
         hDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127249; x=1793732049;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wit30iP+wjWokmtkJr6+vqKTT/0WES+HK7+H57YGve8=;
        b=Mxh/iFNmaI44VGlZK1sirDw/ETao2IZHm1tw+P0gH+XFLQ8LWDRYlD/3rmwHusWsMd
         BFZly2AcICttRAdwuKy5k141fjh8pjrGlajQ4jHECUabnxE/hZgfO826dF/+EUgbTDxw
         DowmAL3dJhcHvOVKLwDxkEr8xSWHGqq95jdMl0ktNaQGRY59zazB9QcO8qmn2f7HcIbb
         qGM2/h183pRogd8abb4qdxibkvKWrvbWGo4fF4ItvuyXEqscXmoC8z6+x/6OOZzo5CYH
         Csj4kinnMEVwO1MkbZCaVdCb/ly0SpJLIHum/HUNMlQhzg1nTk+DDpdxiJMAkkW5dMoJ
         o7BA==
X-Forwarded-Encrypted: i=1; AKwUvByjvlZ2Lb4kryLqYWpt/QeRL27xRS4Z5fpBPUjLytORFW5Dnb1f4vUE4deGeW8NeEQEHRusCq8uj4J3TPwLDQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIhsyCuRGEJEbMfBvPh6AbMIT+BVZ2/xw1o7COENWEML4ZKKNfW
	6D1ZOQFSYsrQOb+oMB5jCqf6lemrAvhnJ33AgpRtWQ7lhjp50c20lAc8R7zwJdAj2ecU6eO1zPP
	so/tIQ8bpBqJK1QvgDhuScj0A+GLYFMTgupAvSkaM46vFpIr2QUUA21feFRRSbhS0K15/0A==
X-Gm-Gg: AYBFou1/pFrYGL/ijo63RwOi86wUQpFGssxIt4zSTmpkmOak/cEPBSksW0ROPN/b85o
	E44fuUKrTWIWogaVijqo3yTqROHES53Rf9tu3TbTNj6Vm2rB1l/2yUFTxaVwXLzcw9EEyOZzDjy
	LPQZ1zEQGGRP1sRRZ5pYYeY7OHprCD7Gufkl+7UsJndn5eoJa7FTVPicdq57LTg/Ahyh7ETxwpc
	cSEhyPQpoZ/zKnXn2d0J/t9FcykEab4798YsqWOf0Sho70Xs+hC0sOUopnnao1oJIOG+Cfab8vG
	leQELiycpW866VNr1NpBRlDDieyO0uUt6ZGTrsTKcwMvAg2UrVS3uoL0e5ZXF4q5oypdkVfX/kr
	lBVxB2uKqC72mnujsqvdtwhjeOQyXjrmPp3XjefW3izrkTrp6tIvsgA==
X-Received: by 2002:a05:7301:78c8:b0:366:dbf9:32bd with SMTP id 5a478bee46e88-36a20406fcemr338671eec.9.1793127249331;
        Tue, 27 Oct 2026 11:54:09 -0700 (PDT)
X-Received: by 2002:a05:7301:78c8:b0:366:dbf9:32bd with SMTP id 5a478bee46e88-36a20406fcemr338633eec.9.1793127248474;
        Tue, 27 Oct 2026 11:54:08 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a14383b02sm8989983eec.14.2026.10.27.11.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:54:07 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        baochen.qiang@oss.qualcomm.com, rameshkumar.sundaram@oss.qualcomm.com,
        Gaole Zhang <gaole.zhang@oss.qualcomm.com>
Cc: gaolez@qti.qualcomm.com, miaoqing.pan@oss.qualcomm.com,
        hangtian.zhu@oss.qualcomm.com
In-Reply-To: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
References: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
Subject: Re: [PATCH v3 ath-next] wifi: ath12k: Add EHT capabilities to scan
 probe frame
Message-Id: <179312724741.435197.10463767510262088409.b4-ty@b4>
Date: Tue, 27 Oct 2026 11:54:07 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Authority-Analysis: v=2.4 cv=GYyCDgXL c=1 sm=1 tr=0 ts=6ae0f352 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=lsWWqZO9LB58UUU1DoYA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: DuORKOPTBh6oU1Ac0zPYWYTw9yLuSvQB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfX1OBJf3JVMlp2
 w8XUL33YxVrtcPK4/HoKhlM112+gTf1jU8dWEBfItnX+b0UACFO+wvE0YVf/BZzSw42d0N20hRt
 XBMzSvvEuOigmFMlzIWML8/10/TCiwA6Vw+bhZewa1xmxv0MJ1tJ6SSVS7SegDOeckg2NSD+f24
 +kpmGK1RITq4akdhfmWJxfAdS3FTJAPoc9jEJxFq91rmNJll13bMe96vAkl/Hba31JMyWZLsEbL
 wcRuQ1E0GFAdbPpl0g1YkTgavJZ7EelTNTFwmtk3deJ4O1hfxG4GsoEabK5MbZWQrqj3ESrXf/N
 ttrPjMUVnXsHc26KkSIyzl8Wu9sbJsmS0CSqGvX2rY9R4T9N1Ou95toP8mDIW9eAwbrLEPjUpoy
 Af1Qx/RdaEKkIBkh1kEOJckNQJcuw5y9YvJJyLaNICUDmvZ833X4toVpJunrKwgRDwKDrkWR0pZ
 14qHORkKOfwN2hGgQcw==
X-Proofpoint-GUID: DuORKOPTBh6oU1Ac0zPYWYTw9yLuSvQB
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3NSBTYWx0ZWRfXwVFynC4q/Eu2
 4wDM8cPlCwcg+RgPrPp2aLfbIp9mKKaFAun7OeEQuFHpkCYXVGE25afsNmrDQZI12SF65UOusHX
 A+1lq9yV8V8pGlGcxNXG3p+kZh6Ve4w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270075


On Fri, 09 Oct 2026 17:55:38 +0800, Gaole Zhang wrote:
> ath12k hardware scan Probe Request frames do not include the EHT
> Capabilities element. Without this element, an AP cannot identify the
> STA as EHT-capable during active scanning and may omit EHT-related
> information from its Probe Response. This can result in incomplete scan
> information and prevent userspace from correctly determining the AP's
> EHT capabilities.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Add EHT capabilities to scan probe frame
      commit: 8211010c0c6d17dc5214cdc1e03f00a341015f24

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

