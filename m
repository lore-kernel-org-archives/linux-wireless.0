Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0084426738C
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300767; cv=none; b=ORE+dqL2sjxYSJdaPtEFJ1vYubobhgl96EVLjcjUB8OVEBuOSXNcM482QHJgAxbvs4iZ1f8oJjeyXP3+WFZFNOw3G76M818DeCtCUEnJAEJpBkLlRIv57hiAVIiao1Gfz+d0DLq8JqhkbM9WxuQYUpfUSVgVcPeCUEutpPeYuB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300767; c=relaxed/simple;
	bh=NPTgNFPbqWCchHrM89MnoOIPS7vR0SwERYhOD/351Wk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HYecTao53Agfy7jd9Zr5nhELOJveKoaIE/kOWzvhTgEjKeL6NbVUcREPIzWqn0GWkgmJtrCowpi6LB5I6VGZ2pb2tXgtYe1QphQAgkrZKW91Xkdlg8xJoWXkeL8u8PLswyCPj2GpUluj/2S5YNJzVCc/6F0khfdTPOjXRBb5tlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FcdHTkYl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iMO9aISg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FcdHTkYl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iMO9aISg"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7rZA1675759
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AZ8k+2HIR0sWnAIb7M4o9ugipG6/uVcMWV28VfxSnv8=; b=FcdHTkYlRiRCYsaH
	T1UF/0x+W2mTGuuqTJTZRPSZM85x/s7oBTIsZ2lgj3E/Ch/HgfXGvoNkjPQLrYZ9
	p7I4l619uoFYNH6x2d3XV7+jPYiy0qQz6UPQt8e2YuP1ElvEEPXwznHH0bnQLseY
	mbqIZPjpIeDTPg24z0+tNgvyODTRnM56KAReaFu8m56zZVrnz1kn05sT+jz4rWtQ
	T082W0BQ8KC6jHB0QlYHCAVP2p3iqbQsFZEt1DSNpB3cME1jYba5i9dL1NT5VwZ7
	21eXkwYExCXZagxg2JMAwQK3myPDxVUGKzCm8qUuL6FwMDTUEbQmGiJbcxSJfmhf
	vNTyrA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffj78s4ea-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:05 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38127ae6b99so2293552a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300764; x=1784905564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AZ8k+2HIR0sWnAIb7M4o9ugipG6/uVcMWV28VfxSnv8=;
        b=iMO9aISglebOOVcgbKFJz9mLfAlBYKBWRD4FEwwdBcdL7JouUx/vzFrORenxo4Km0o
         Z3/qY8Ymw7RyRiLZ1n/CMUL/ZcGIzn/kI1qwplNVzFG4bFOIt2jHYAhiLdC44TT5ickS
         LPuUuxFaHyq3o+2LCtP/Xm8qvZHerZqhyZC3hdtGXblPgQafaJ7iDEMb1J+hw0uCPOuh
         fcpF0GltNI8zJzEQ7iRwI+CahHK0WKsIhyd1hTyNtoOjZAebrwPHeDtIvYQEj73Zbsx4
         G5Mzw2RvtPvHs7XaTm5wZDH3bDPqb+yZb8AR7FfZoIVLyw3wI5Eg2NSjRzgtxwxm40tZ
         ve+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300764; x=1784905564;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AZ8k+2HIR0sWnAIb7M4o9ugipG6/uVcMWV28VfxSnv8=;
        b=j8u//Eu9oipQGhIlOGh091UXNuV95BEd+l38dLV5y9octSetgrCucmEU9U3QWiAubV
         89tkD0P3th5ygiz2LgUjwH0KhHjXBZ6GQPG7eF9tlQXRYPyz7pUu/iNl08imIx+bMIn4
         duXtdM48IvhN1Mf6UoaQ/ryMCkqas+FBcfg9oLcNXeWbzCewL3y4uih5e96TpNFM9wAC
         KiYC1hWqf7x4UYRw4IKJhAOXXZTRHnkePe7ccJ1ppFmspjL0vb5cTCzvJbUv68yrKLz/
         wbFMepmQcaOhMFixGoE+ekFeEUdsWBxT40zLRmaB7d1ZxKMXM7TUfLRMFwOVWcPsNv44
         qBEg==
X-Gm-Message-State: AOJu0Yy5GjrdAGKpMeE0xb31pgRcbuxi0WPDeaHl7vy/NCKnaYh4eLGt
	nL3Gkoyn2HlZ6cx0iW9SiDkb6p8xV/OgXXbJS6YYIdbDMWueOMpgd8pQ9vRWhz/xOUWYi6ftaq3
	Jxa5P4sYXs2qdK3nNzfONYW53w5b3AQgKoVu33ofrt4ROEn8B2R3YGjOdv2rd/v6CKUsEwg==
X-Gm-Gg: AfdE7cmw+Kbb022roxRXbyGT45fA1vLY/vpgjvwTKoHcmXvR1VooW6ZVAbJqHZxyB/T
	BVGOiP72ahMI/EeQu+ytlHHclOKCxDsav9WX/URBn9+qdth8ROi1vl2I/u/49K7JzVtc1mIoOsM
	hUNSiKMcT3Rr9ujLEqv3TmkxMIDtIs73tI+zYvjM5/OlNHzN76M2BGHfOKeiXu6cPVnW096DrnZ
	cPWWIC6iiHPJWsBnd3A5+kz3yyKgMH8g49lJs9WjiF4RhMe0YENb+IE1ZAx7SdOKhwV6E/6av0v
	rdW2lgyCmAe9dzqf2UJspodPA/VVmnehuaY2oaucfO/1LfTiqaJ+Kd2lUkg6tIyahBEfZsb17w2
	45n1+JjRIEZYL2N4mAHa94lAOTOjPTmLQgZ0xmI70cnHteLz+gbRmikM=
X-Received: by 2002:a17:90b:5686:b0:38d:ee5a:63 with SMTP id 98e67ed59e1d1-38e3d175d29mr8152974a91.7.1784300764348;
        Fri, 17 Jul 2026 08:06:04 -0700 (PDT)
X-Received: by 2002:a17:90b:5686:b0:38d:ee5a:63 with SMTP id 98e67ed59e1d1-38e3d175d29mr8152929a91.7.1784300763828;
        Fri, 17 Jul 2026 08:06:03 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:03 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260622062614.760166-1-thiraviyam.mariyappan@oss.qualcomm.com>
References: <20260622062614.760166-1-thiraviyam.mariyappan@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: Set congestion control max MSDU
 count
Message-Id: <178430076296.128359.11405301359241550671.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:02 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX/kbyterAfRA5
 BMrEgJZaa2zT/zkLe8cROZRorO0UG0Afomuk0w7Kg6EmzkBj9nTXf1rk65M0BZjcFFP+f5Fg64i
 bci1lX9Hl2XiP3tY70N9wL3wZ3rfLpevuBxT/1ZxQv0HdhxYlG5w8MMD6Z3bMNXQzxgDhkMA2Oc
 bGWfRqhG5enObwZpvxgfBVlgnwwrscy0vX0lvTFBM4Sen+vIDXEAOXVozHXf3NYq5F22Bvde1gb
 renPnJeXP+DhAxLczIbGtfk4mju8I+V7jgP8NkSGGvgLRBKmyCMjmEoUPZT4JXNZEp9HEkLJ0oK
 3he2KQlCjXgMU35Cj0wTvgKNmTxeZfKVmVzvtYfnHbEAQ0UIc0hgkCTZDH6I9oVFtnuoQja0KjN
 pv7uuYVF6TfyXLNUCTDY0b8VPcbzuDkgLPybCik2Dr0vrTfzXbwmcaRhHhEzlsEC3eOyBIRgEeo
 vomwBmo5MDL1WxKXejQ==
X-Proofpoint-ORIG-GUID: 7Qi1KkttOAUctD2ywI86YJlcD4syWWOV
X-Authority-Analysis: v=2.4 cv=U9Ciy+ru c=1 sm=1 tr=0 ts=6a5a44dd cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=yr5zLEcqeAOy5eNwxqgA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: 7Qi1KkttOAUctD2ywI86YJlcD4syWWOV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX4mGJ07UPHn8+
 m3FGDQqFAG4Hmy+e+7Ltc5IaAv9/spgZVonf9BF0cPN50OfOlEHWHTxCia2oMEsJedmAqS336YV
 +ZhAzazQVWeocS6N45TQtAK4e4K02So=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Mon, 22 Jun 2026 11:56:14 +0530, Thiraviyam Mariyappan wrote:
> Currently when running 128 clients UDP DL test in 5 GHz HE80 (NSS 2x2),
> firmware uses the default max MSDU count (16K MSDUs). This lower limit
> causes the firmware to compute a smaller TQM drop threshold, aggregate
> packets at a reduced rate, and results in increased packet drops with
> TQM drop threshold as the completion reason.
> 
> To fix this issue, set WMI_PDEV_PARAM_SET_CONG_CTRL_MAX_MSDUS to the TX
> descriptor count using ath12k_wmi_pdev_set_param(). This increases the
> TQM drop threshold, reduces drop events, and improves throughput from
> ~722 Mbps to ~1060 Mbps with 1200 Mbps ingress.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: Set congestion control max MSDU count
      commit: 78ad50d9071d07510e190d858a76b27a8339932f

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

