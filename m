Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428416;
	b=eKcFPf9eg8h9bAvK9JJUc+Bl46hjnnrm9H3DCZSxNIf06JxGUS56Bl51nyYfEWkM57wy
	 UN8yxitefr5meVMtf5hFDcRt7S19DXHQ/EFvrDa/9KWkD98yRtZGTjjYEGDPkN9GoIzz8
	 khnJKIaxyuyIs6Wz+0BMFNN32bENhpLksMr7dQ+xii1OsdwwQ6KVxTcsJ+rhcdJRcZwtL
	 MqaOlka36ckVzrbepH/hgb/D6pNrr6759Lu0ATGEeBmuBhXU7as4gzBToXdOvBmKksz+a
	 0sQRnA1MiiZFCqZ6aN3uaRpqs+zcPNvvc0C+M0jO7TD+JZ697VKKVadTG4fO67Ggcow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428416;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=DrHjVs3K5knpICGJJRURjLir0JgH6n3UDboXHBkcEBg=;
	b=fG693kQcZFhKBZ6Gf/ZUAD5QXijHwwwLQ83gp/JL2k4Kdob2fnCIk85TTUEfDUvErA1j
	 y3vH8KZMblOGc1C7o4hC+Uib6eh8GTk4Ci+E1a9QF9zhAFD9HKRelKPfx8hDEjsGPCbjY
	 fqI66dxHtd9dysQnw3HN7kJXPux3IP9FByFhFq5DphQg3t2m+Yst5ZrMrKDLBR6hEvfKU
	 K9pLcY1FPKBV6rSi3kSOTJg9YZHAhpQHwSbkSFt0N1A1utEy4wKrDlkIAb5XfI+y/xCrN
	 cPIlNktssn7SmRzXy0k8pXVUVR6mn4xnYilmADvOdwtEAldOuz4K125vXIeCkCIEwGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nfWXGEn2;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CHWP5igC;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2E4606A321
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 16:46:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E2E4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nfWXGEn2;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CHWP5igC
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JFOvYW035959
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 16:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DrHjVs3K5knpICGJJRURjLir0JgH6n3UDboXHBkcEBg=; b=nfWXGEn2NkcNVPpA
	Sapb6Al6dKB6XBK/E7Wc91YrpmFkKXGO6OidMfRTzWW0xmPq3nrdhsKdgyrlEsjt
	8XcTKHuYqy5FHI3vermFeKBj0SCDdpxGyQbasIr7oeeuabDeBVVV7RD/6czWALvA
	kea82WILN2a96XvK3mCrgJye36wgVWic902BlxvJcPZOarHUuvx/CuWWPgEJLo7O
	btWw1tscYss9RtGlfejcDaNkkW7/wKHMh39LBXHtXHK+JVB5mTNBS79sAtAdGuy9
	Lk3Vxq6IqiLAjOPZ/TAyuQ0uS320TXv7b089hyCVGfmYfbkdChj6UqF6gC28olhq
	D4fEEw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdf47j9h2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 16:46:55 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35a04491c56so2677309eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 09:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792428415; x=1793033215; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DrHjVs3K5knpICGJJRURjLir0JgH6n3UDboXHBkcEBg=;
        b=CHWP5igCF7r4OrOW+phaamMMD9Q4SRSkPVOC3zejvfcZsAf3Z8a7fZfdR6d9brP91N
         SnlQgoROSbr+qgBm4UtMRwL12uRNiD7FXbADf5ZLSvnLP77/9OSHiAJpwYFrbWlfP6xi
         tsmAU7B8HEbg07sh1ThrAGHyPHV145j+jLeEieYJM4HG2/jCauQWn6U4PJJB7c/tJBr9
         pglUzCDL5cwpCHxOMf2C/whtlBUJlEwe//10xXmejVyycYCwdX+sMqfDaAw2psOatgAR
         wrd9/ZVnZtiqRTZigNGyE1xhmyCi2OKbU2lbpi9fp2YCXE1PgQx0yW3VL6fkbAxdgMnw
         najA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792428415; x=1793033215;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DrHjVs3K5knpICGJJRURjLir0JgH6n3UDboXHBkcEBg=;
        b=zhiqGsVIFRtLdQazLEYRuF8Xpw8Jn3+BfskFOr8LMMZs6J6R5VcA9x225eQh/tVjQ8
         v/m0uw0CpxsFPsSRIrtt/rM/UXVaXWWzmuB9D6O6QOEYJ13mZpdm3sGjbWRh1PCHSn0M
         OhPALorh7jo5yFr7H/GiEdWV2CrT3Wy4SPdvEcFHZv59wc+Ni8wd9fLn4Ne6qKU6GBjD
         dzcISXbKVP76yafHDIVG2I8k/8/UddR7CoQTfiqhLCMA6kGJyy1hw2aoM3F7LGJaGnuS
         7PRBdYAnMbsiTgKDc63gSDV4Ez80eSH+gHhgrJciS4LTwGdRbEArNrqVUiWyavYMNJCH
         sJOw==
X-Forwarded-Encrypted: i=1; AKwUvBwkSNuJuVqSzIPS+tXg1ViE4NusFCaWUq+kiMjjaY7+ixYAcJopTiO99cGceqClOaRNzUf242espwUYinjP/A==@vger.kernel.org
X-Gm-Message-State: AFq9FYL/CBTMWW2EOr7S1f7xu2+2nkJUgx1fkBEmQf+7SjmaJwtrNvhk
	Bj4jb8fzPI8eD6+Dd6Ou8k4vSzrg4NE4O3zcFnZSK5Owz6WThKGK6SJamTQobKPI+5uwamkCOBU
	aExCWs4pNaZB10uIjh9KtdG4N6TUAuM4ShSBXSTt768kC+yBi8+1G7u0kw0sZEW/cj6PsAg==
X-Gm-Gg: AYBFou3A9nkNJpi28Ui5SpJ1QsRW16JqvZy9qFhE/H0UfaWOETnQHlcQdooOHtfRpK+
	JCqv6qTYmfFnyhQUg1+33C+BnZZhuYj3uffy989hA+n1ZEBthxW5BVt09brmmlgK1fRw3xbCPK/
	TulIkIAJynDcrmFyCrLPznQm6K3Ht+mb73Sev65IIj9dkEmzj6j+IGV7F0AYwneLRJ/0z27egDw
	zNlwp+CQOx5w4rZRf28gjDxpL479LXggD7piprTErfxUGif0o++HhD33fZJFm43jWmt9mddGYZU
	i6jFJ8NyaIgEUxWuy9aMUxxrYONARsyt6IoLswFXEvOH7CCJZpg9xg1E2NAptdvOhOfYbW0Upjt
	tzFhivAbs5JSK1c7IDTiAe9xMBMLviWbhfGaGr8/T91ktoSzGbZCqFQsyvA==
X-Received: by 2002:a05:701b:220e:b0:159:d448:dd1c with SMTP id a92af1059eb24-1825a67565cmr13293192c88.19.1792428414343;
        Mon, 19 Oct 2026 09:46:54 -0700 (PDT)
X-Received: by 2002:a05:701b:220e:b0:159:d448:dd1c with SMTP id a92af1059eb24-1825a67565cmr13293157c88.19.1792428413560;
        Mon, 19 Oct 2026 09:46:53 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831b75ac0fsm29699093c88.15.2026.10.19.09.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 09:46:52 -0700 (PDT)
Message-ID: <e98854af-f5a8-4c8b-98ad-9af673384f57@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 09:46:51 -0700
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
Subject: Re: [PATCH 0/4] wifi: ath11k/ath12k: validate firmware array lengths
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        kbuild test robot <lkp@intel.com>, Julia Lawall <julia.lawall@lip6.fr>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org
References: <20261019100506.1915181-1-yaojiale02@163.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261019100506.1915181-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: yT_6CysW13L9dTs1PLvrzRbvMHTm73TU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA2NiBTYWx0ZWRfX2hblBDIxekFi
 VbKcDHtA3xi4+rCFGt9DIPEezPjaBPpYUaT4A1ZMB2e8MIgBA22gE/DOKwz8CM+1qVs0mffI4nL
 j7Z4bqtPWuztydhcrVZMqWX9bxEz7p2A9eV5m2Rk4EoQvdiHZ55ibsInHMtqc/PeDnVt6X/bwpP
 vRaC0TJiKgBduQqnWnMkXZkHwOxINumGhDZRIc9K3AqJm0V0C3CeNx2N8HUJxKc0sWV5YhVWwTO
 qxHtyIod2+m2VXkE47NCIy0ihSFHjnKD0nlz9u3l9CauOQENvfT1D+Jx0a22E0tAs9mpfArB/Fv
 EgQRrP8mj4j7ZGifU9TLNzPyZtBM1dsCMRg/Ol4GxBv2mzPhY1WKnZ7OLjDUSJT0WBQiX6UYqsZ
 ulrKaO2sk9CpyrONM1S424a1W+uT3JQ4stGivHPy3pLLjmTjncjrkaFKLBVLgHGVjeyf0OkDhVI
 FM++ai37cQ/spAV9U3Q==
X-Proofpoint-GUID: yT_6CysW13L9dTs1PLvrzRbvMHTm73TU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA2NiBTYWx0ZWRfX4Z1uGFc0n4oo
 7a15p2Y03vcbKTcxgM9bsg+5wgYuCPqUFfDYdWsdmVmiLzTl86Bqh8g4qSgHURGmOwFCN54+eO6
 HAHcBc47duxauE/A9JCIwNxF6zsnb0g=
X-Authority-Analysis: v=2.4 cv=cLt1IVeN c=1 sm=1 tr=0 ts=6ad6497f cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=SGwW7hRdeZfZbUOxcl4A:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_05,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610190066

On 10/19/2026 3:05 AM, Jiale Yao wrote:
> ath11k and ath12k consume two firmware-provided arrays without fully
> validating their lengths. The service-ready-ext parser accepts fewer
> extended regulatory capability entries than the separately reported PHY
> count, while the ready-event parser trusts the reported extra MAC address
> count without checking the fixed-structure array length.
> 
> Malformed firmware data can therefore make both drivers read beyond the
> corresponding TLV arrays. Add matching validation to each driver before
> the arrays are indexed.
> 
> The four patches are independent and each addresses one parsing path in
> one driver.
> 
> Jiale Yao (4):
>   wifi: ath11k: validate extended regulatory capability count
>   wifi: ath12k: validate extended regulatory capability count
>   wifi: ath11k: validate ready event MAC address array length
>   wifi: ath12k: validate ready event MAC address array length
> 
>  drivers/net/wireless/ath/ath11k/wmi.c | 10 ++++++++++
>  drivers/net/wireless/ath/ath12k/wmi.c | 10 ++++++++++
>  2 files changed, 20 insertions(+)
> 

(dropping obsolete codeaurora and quicinc addresses)

You seem to have sent two separate series. Which is the correct one to review?

And more importantly, where are the Tested-on: tags which indicate you
actually tested these changes on real hardware? There have been numerous LLM
inspired code changes lately, and some of them have caused regressions, so you
must test your changes on real hardware to be considered.

https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11k/submittingpatches.html#tested-on-tag
https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/submittingpatches.html#tested-on-tag

/jeff
