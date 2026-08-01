Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF1B48988E
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 15:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599741; cv=none; b=WyjnAVbGQYVT0TIy1fi+zEl1IKSoVHlHv0MajC5766jy248flzIEwiKLBNx0Xq/rUEdk7yj82f7v+XbFStcegJDdxBJ+LGEELMBlxzhb7l9EQpQpDYB+6k/ZJelb5hNpsJaS0iiWNqS7wxmQdmSACOAl1tyigu1LCqHJ5rgaK/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599741; c=relaxed/simple;
	bh=V8XmPe7hdCVpGxjtrqXVwZJxotbB8ia5qb42SCDsZzs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y7Vxtx6xsph1Adj2XuRqt4/seKh/fan1mnAbwyUQ+CcmDG6nbDFecl56pL1ZgI7JUAngQBd7PjUDDfPKHyJShVVK1w1IQSf06DQOXN9gu82P51FXYJgkF7U8R8ShXkv6Szo9V1vwC6j3z3Psl4AoyLu0ixZnPPEjtzbnyd9eeJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VVwvU/d6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F/sUaz8a; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VVwvU/d6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F/sUaz8a"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 671FamVI3317154
	for <linux-wireless@vger.kernel.org>; Sat, 1 Aug 2026 15:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fCu7aUSRdclcGJwFqNfq0oOCaCdjqcE/IxeaapxTTOQ=; b=VVwvU/d69V4MTpzh
	xMr0XCHveHrzI5nBCgLlzDrC9X8Lmdyot5eWWJRTps0BvQp72WB0FZe1NwaEkXDs
	G/e8FKm3pmoinyfbVLA/hdvslBaa28tZLkOgxXAWQu7pEANzjAY8W5JgpNFL3/2O
	JQy/a0iVxaUE2tSg33krCclDm7AMBgqUtcl9YiygAaMqj+OFCDU/BGs7JF6XbaiA
	LGlGZMpMn+MeF2bc0xNe//S6kUpgc6VYH3AGrJAjafg0grfX3mpvjw+Hc3oJ3cVO
	hY/pYSdg5iEzxaR/ThmiTYaIcdQgFgq23ZL62rDpPVbE9neEYxqIP5jqFSd4R24v
	NlSr6A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8u997r5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 15:55:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cca3673560so35427355ad.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 08:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785599738; x=1786204538; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fCu7aUSRdclcGJwFqNfq0oOCaCdjqcE/IxeaapxTTOQ=;
        b=F/sUaz8aKRBk+JZEvxeTNjdeMsldj2SNSW8k/mTLnookoC0c0H3YNa7uq8azH8qchB
         UXLoVEcICzhVgwOMg4uupCYAnZ/G1nGofBG9ULJmoa8+J/8LCTpW+w+FYraopV4gkGXL
         4hljY9Z8diKCpJ3WNXeFfraCNzc2esXdmfcaJ8J3IiM9TP4NNq0VveBBMg25Ig9ZwUiV
         Couxt1xQjZaQeI9HpEfBpqOZNRVmQlmlkqfUGcDEJvkQiwLETkrPMW4QefrKMKdcsexN
         2Hf8bqJ4SQuDmT5lSfRaJUdGlbJPVMo4Aai9JSc2F6htIwxKFnWYv9zuqtZZCn6h8HEm
         OO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599738; x=1786204538;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fCu7aUSRdclcGJwFqNfq0oOCaCdjqcE/IxeaapxTTOQ=;
        b=oE+m42QZwa3L3EicM7RrvJWtuQYZiVOdRjVwf9lX7lJ7Ile+U2DKqhsAPvP9ZAQ4QU
         JXDcthcc6HHyQWD0HQXF6M0825ZbGaMLdcTbidvY3G3FfMuzCNNo9Feb1f5A+QmgfpWp
         zpLqy6KmGObjiAmwOLnbN0XQRIwSb2ctD/vyyeoIszoHA/YWIuxme842r7vVzoJMq5n6
         2I4l5j7+q1LceHOwo8yoZPEJNUO6QjQQOVi4Rs9UzrQzrhI2VNLjemcY6czVhlnxfj18
         nMsvkczeszUrVuRES9oGNp54Wj+3dtq+Ygf4ImDGBJXCsguCwBN0pj971zUXQETnOuc9
         RBTA==
X-Gm-Message-State: AOJu0Yw+FcC0jOzgC4690PG4pwYfz5tasd7ZYeEGCRiYelKAsStN4JzX
	tdSuP1ku1j13P9oDqcl2nvTZW0gSYLW0AqSvIiFnIrMteakni1EicmkG69iZR1k7mMqrhNOstiE
	VCxpObHfyzcY8LDzpx5K4TYVqqjQXLNFvbjBR24ZOXOzOzYjNd+yAA3Sc/iVK9gI8yr5+glDXCg
	ipew==
X-Gm-Gg: AR+sD13ZeDNczvKasReKDWC6YDGompCXMINoK9Blsfq3HYtZobMF1BzAKLZo8iPWMiy
	wQvsbG0GiBI6BZKD0RnZrA/MDm/rn0+GuBhJ3gpsTnHAmBLe6LxljWCG0ZAEu4EAvjbbq4dlG2F
	dU9kbZnN0UEfUpjgzy+GJA4sN4mGLOPwhYTzVyh56ypsXd9NZ4P2sI5Uy2gyLwG792E7tI1VCNG
	n6H0c2iw2aWEKIl2Eh4h2B1TP5ra02XrpFZrXyklQYiwANxXPwuWxx9vUTFcO0CaBvTuaohpPgr
	Yinrk7joDJckxHuJzQY4ByLBgJrtj1ohc5Xw6Poov7X64OX6kXOfRf3qW0vWr0YA9QyPt5SARla
	+fZ9Gty0HRej1EE2dHVcP08XUAgEKo4G9KDNJaTrGeS+BtFO1CtEhVYI=
X-Received: by 2002:a17:902:f542:b0:2ce:88d7:a233 with SMTP id d9443c01a7336-2d052428c82mr36192875ad.33.1785599737843;
        Sat, 01 Aug 2026 08:55:37 -0700 (PDT)
X-Received: by 2002:a17:902:f542:b0:2ce:88d7:a233 with SMTP id d9443c01a7336-2d052428c82mr36192665ad.33.1785599737383;
        Sat, 01 Aug 2026 08:55:37 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e5b0sm17110636eec.1.2026.08.01.08.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:55:36 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath10k@lists.infradead.org, Linghui Wu <linghui.wu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
References: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath10k: snoc: use memcpy_fromio() for
 MSA ramdump
Message-Id: <178559973596.3865089.1821995582192910761.b4-ty@oss.qualcomm.com>
Date: Sat, 01 Aug 2026 08:55:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: l_xIeXPWwfjCeLS82MPzW-mwVZ1reDIZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAxMDEyOCBTYWx0ZWRfXwIUTTS+E85ZO
 tqQiAPEFwnr0Z6yz0hbGI7qOx4XIccXQlQKoE2/GX7QOeinjmweAeWP40FB4nRNsV2HAqIL9aax
 oAffgnv3sg2o9PGbBjYHeaBqag78Wtxu6mF59VrSCP2KfMCZwAVb8OdGThstNGtJ0QJ7OyOvh7d
 RiVoHCQFbueHVi2mNJpwEydaza2JIJUrdKk9TcUNoRkMadKHlXf5H+GmDfAeJW2Q1tT8ddYAwPY
 meBKgqpqLJz+LIka8y2Jul/IcbXieE5b5KAcZeXpyKzHECrBn+bhZ1I3PEnQ5Kb3oaUzBTkCL8L
 7RsWooI81QkM2ZL6i0i6cwR5DYASCtKbgZdVepRZVWGVwG9+pY0VSnuSiOFzwOt1bdYaC+leTlS
 i3qzwcGJtRHO5XT6XzzYoSsDqJQgPOYrbk3MOfXqS0YQmcIfaVX8znuR4lmFeqYxvakBnfsuk6L
 ZNK8pT3j11kPf7YTgMg==
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a6e16fa cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=js4kd28HrUIP1rAYZOcA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAxMDEyOCBTYWx0ZWRfXzKVZ6NG9Nkwl
 uKHYnR6xFtXUakiBX591b00w0SZe/5jSGOHhMVqZWJb2Vo8SZ4xXxe01UsILZgCX/qjI3XVOxbs
 RWPp1Yq74ZKN5OGFNxiSZaLWMJuN82o=
X-Proofpoint-ORIG-GUID: l_xIeXPWwfjCeLS82MPzW-mwVZ1reDIZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-01_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608010128


On Mon, 27 Jul 2026 12:56:29 +0530, Linghui Wu wrote:
> On WCN3990/SNOC the MSA region is mapped with devm_memremap(MEMREMAP_WT).
> On arm64 such a mapping is not Normal-cacheable, so unaligned accesses to
> it are not permitted. ath10k_msa_dump_memory() copies the region with a
> plain memcpy(), whose optimized __pi_memcpy_generic implementation issues
> wide/unaligned loads. This triggers an alignment fault (FSC=0x21) Oops in
> ath10k_snoc_fw_crashed_dump() while collecting the devcoredump:
> 
> [...]

Applied, thanks!

[1/1] wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump
      commit: 4f25071afe9218aaae1c63fbf75e229aa6405319

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

