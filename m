Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818794;
	b=ObrGY+fnX/n9VTEUrtWu8mHE4+Agv4L0fic9spXHiHeuYpXl74Yspq8F6sGc3qKFFIgo
	 d381rVCZEf25YFU9B1Gn4YFliwvr8XRgDfWfaUSpcA6yokk7Q8+NLNu39+xKFTcZWRcxc
	 VVeIqw+lBYjCZW/gMhPIUzwgQ1IjvBy4LBljkZypmpQIdFxmpVmpitgvpQRJMoOSrgul7
	 x+vDGkIfeMNNdgbM6v73sLGI07rD8ZbWYuLTM3hYD2S/zzZOHEoGX5n8VZA50Vg4uMMFo
	 reLt/0fsBBwvXJ0kyC36wsDFLKMCaLVmyRZu9bzso7moi1fghXNT2S4+/BhKlJxwBfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818794;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=YV0xYcAbjZFkY14Cybj7K8Wm+B6qVMefd9Y1baOJvn8=;
	b=3UiuWeLa5AnsmgY2rgmiWCJ5LNld0+GUSyzLbxjBX20mIZDI+U7gRTn+tXBpwPUpe7Pq
	 4m/gTArgTo5kIh++9vjoZJoIk9lJ80uJs5UgCjdTWiIFugBN01Q2Zd1GJ/iayKbblDaIM
	 thOIQd/NKZrKa1Xrpu0LmNXqV2Qyk2vXenubRSabvxZd5y3ow6t0iY/qaMYlt9qGr2FJ6
	 EGCiyyPSP1YNCmZDxDs9ezrg47Pxu6vg2ZnArosIFlC44o4jCQEw9mAUiD+NT6NsJhpUk
	 bbLLn3/hTJpNy57hZYmpeXSccDV3KBCHxb8NLz2kUIbEDgfi9w7ZflqW5gt+7I660cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OEUlIayp;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EBLN+poW;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA14606D804
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 18:59:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACA14606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OEUlIayp;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=EBLN+poW
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4FjEN82828839
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 18:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YV0xYcAbjZFkY14Cybj7K8Wm+B6qVMefd9Y1baOJvn8=; b=OEUlIayp9ty/OGOo
	Wm9eY3B3sfv8AGOZVHI+zKENjlfJ5PMDULSlY3/7YCVY26W3d8L6m/OnKOpuQehD
	3PBA834HNHN+T0w948vrQkIExkHl/zOk+rkS8wBkkjcC5a4YxSTZ2VONly4AjVz0
	j62TtQFcer5DMa/iUbdK1z0GsqYMbq712FCKcmow6Zr/fApUrt3XDwyQsLUs1ZLw
	Cu4XqxoSRwTdlxkV21OCUt497oOXxGNlQNDzazM1SWGd7SXuX/0sN2xW7M9GPVNT
	DmyuDArphVsOoV/Lw054WHUJf6Ip+hcwZFGY54GQdbVPcw4xhtFePsbf3GFlLqgd
	jkGSww==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hr284tb5a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 18:59:52 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a223755e4so3555363eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 10:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793818791; x=1794423591; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YV0xYcAbjZFkY14Cybj7K8Wm+B6qVMefd9Y1baOJvn8=;
        b=EBLN+poWofLzRQxcun986iWbtB1vYhxeU/2v+mz/Ovyq2Gwq2DEL7N8WvBp3zCVkkQ
         irlNVrtAUXMnbRadddPBYyJcY82nSvnupzUrkFXxRZQABnLpzNJNduq1RRBb1vi/8nlR
         X8WxzKcUoVPnmKsjaf6HYvETMyCgF0Btc08Ow6JlRAGUiPPMg7c1ciSHrxYxjjS7ZCnv
         008BpSFVhtWCHiwrQsMCbjKDhcfB/jyDXQfK/JbiyTwCfvDfUxaSFqAXwxKA2REu6MqN
         e9YEgt6VUqMRf/I0cHdgIT+cMGqQkdjeFg+gqpSmQtYebqbPintaIQmXCEK6mLBiwC1d
         hwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818791; x=1794423591;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YV0xYcAbjZFkY14Cybj7K8Wm+B6qVMefd9Y1baOJvn8=;
        b=qdcgsBK2ukzUvR+6GRnHSiYaV58fNLJHB+Oek84yzZKeciIkcYaZVEgMlH+MFkP1rS
         2AbHqdQ3wJpsr0kQGZD/Bn/NxV1Q1uanjEw4jYGlYXrJEo0vWEVqdnHGqzsGnWL3KcJh
         R87Y2TRa/xfPr3tnLfcIzZ5dxtluTTwPuS/UReIj7TK/R29PU+kcQmFPad+SNI7gDvXh
         uYapL8KNAbfpHkKUML2bfDiZgE1HVJvKsdqYbZcgcWFrGjnKXo9RcFrT/glpBrzH4d0F
         qdAno9uJc+ZogWRrdnwMB0SHz0vvZ0ZYgxSEGrq2Qnv9ZNaGWNI13lJG3jryiaey5XPf
         U0Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxU5vB09ngvaHkRRvgFmeTqLPKzVYyGBeCUVUVr0SiLaSsO+A3qyq+jlqhj1MCeQVwcia6CSCE2AwdDjMphAA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Vrix5/1vdT0qus1W+4B6xS7p1s/wqtpbgGcbCBdVy8qJ69KD5
	tvJQs1ZZJ8ecVKRIWFpDKF/tH9XoXqHfgUsS1HplLI/BjQL/Tl1fqL5mdGHLdIcG/Dmxd8OABt+
	KQ6SyWBIc+SKlBbCh+3WqwGpQ/8RbJxQd7ACvnG0EUazvQIuZLo3hfV/7yoSE28b6SwsGKHjcIa
	Q1cQ==
X-Gm-Gg: AYBFou1cNlo/1P/MWxFskDukU9TQpjEUhdWOxc2m17dLMn/wmLxYDErD3+wdnBSsYzx
	fll5U4qJoy3oJqCvY2pCf1sUXPN911osQIge6k1oPEU5wV7xk/QzHWwj0KX5qGZ27VKwq3Hqdzs
	bVj80Kh+bKIBAH6xvToyKWXgrgohzxTO82XV/YU62Yde0c6k8MCdIwGjlepePvU/tfABI7pNSfG
	Hs6pRie9V6H6FhAPxiozMAqRGIDoV6/p3sUiYOnZQrdOnFFJNAImxYd2iNPqjW1JkIiJKRCNtWc
	e+gMQZrV/KGPsP3QXpKzK08zllpK0pL7obd0jvFrnyuRJCn/l5Hsw+ovYAQa7kFKXaOEGIiEhkU
	pY6lf4MKHp4nBkRqyBx0SRrFccp7XQgh5pYCkC/klvGvWfAJja1UC3toq2OjeReF7D+QxyDQ29J
	RwD4WLdslieCD1vF8ofcBOrGTWqCs=
X-Received: by 2002:a05:7301:3d17:b0:36c:9af3:22f3 with SMTP id 5a478bee46e88-36c9af33136mr9242483eec.37.1793818791096;
        Wed, 04 Nov 2026 10:59:51 -0800 (PST)
X-Received: by 2002:a05:7301:3d17:b0:36c:9af3:22f3 with SMTP id 5a478bee46e88-36c9af33136mr9242403eec.37.1793818790212;
        Wed, 04 Nov 2026 10:59:50 -0800 (PST)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d36besm14596861eec.11.2026.11.04.10.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:59:49 -0800 (PST)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20261028-ath10k-maint-v1-1-1e6ee9fb2616@oss.qualcomm.com>
References: <20261028-ath10k-maint-v1-1-1e6ee9fb2616@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath10k: Add Loic Poulain as maintainer
Message-Id: <179381878943.1666903.15179894702157416272.b4-ty@b4>
Date: Wed, 04 Nov 2026 10:59:49 -0800
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
X-Authority-Analysis: v=2.4 cv=JdQpPkKV c=1 sm=1 tr=0 ts=6aeb80a8 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=vd1Rj9lYTNlzg6lyGooA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: UXf3eyHGfeH76KlRQTnpShFp9y71xg7Q
X-Proofpoint-GUID: UXf3eyHGfeH76KlRQTnpShFp9y71xg7Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA3NSBTYWx0ZWRfXxP0YwV6r9cUG
 vPq978+B+MOeQo+J396J2Tb9VdiSwk77UJqknlcrWT+F0tmDblgEOaVBaUIjmNZOFux33qYnk62
 gfNfTK/vXir2gVFtFOTVrGeNXx1O+QA+vJiusyvhsRCmEC0uLzKM3mqih0Gs3xibHeUN8mgONUe
 VADzhxjHVi3LwtrGPl8EBJm5Hwa229zSNOBzfrpmx6cqZp0iCfCkPfeQ8+MWa3baRkysVOkCqx+
 EZJZXaMweJ99aW0qMuo1VfXT3o8VgcCIz9fuX+6LOMHCeRXdj15NhPypXbVXWQe03hp7T81B2Dh
 UaA+Wja8sMrkFEQUVWDKIJ2TqNmYw2UN1lhGqIU8kGzBYY5CEqQBuMVDbSjMRrqLvR2brijH78V
 SzjXr4JZeLOjExTSPnWK7fhSakQSNDuSRck+6xc9f+C9eZEHVeXqqyh8uzWZbYSjEk5Rd53lUK0
 iMTjdeXH3dJRbpeKcQg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA3NSBTYWx0ZWRfXzGXGw055c1ns
 NaFhNTK8txMal48dYjObeSSi+mm411UumJPPheFn0veBMsHuCtkgYI04iUHjZ3gFwYeTkSkIinZ
 xzaqLSPidUz5rtQP/x+5gtjdNPB+lX0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040075


On Wed, 28 Oct 2026 08:19:04 -0700, Jeff Johnson wrote:
> Loic is maintainer of the wcn36xx driver, and is now actively
> working on ath10k, so he makes the perfect co-maintainer.

Applied, thanks!

[1/1] wifi: ath10k: Add Loic Poulain as maintainer
      commit: 9ab490b8bd5233d33c9e1196a1f967326db51466

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

