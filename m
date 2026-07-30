Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED533F5B1
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785376404; cv=none; b=m2wzMmoSLMLgPDAsypmY63DDXgbIkGMIfVF+Yh1KDifytofOlhmfnS0bNY+EMJRtp4Pg8CXpLmJcTUSe32Z4mtHtRpUeqXbbVHua/kgneqBN3QmXVZkLSP1EXUiFK4VgdckjI0L6wTU/EHeRLIfKifu8w2/iskQRxR5Qc6Yhet8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785376404; c=relaxed/simple;
	bh=l1qmpOfUAcw+5uVwQaUf8YL+ljdwyXYtfuPlud4dqik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWuDdxSnuR2VHlkWH8I0LUEXh//w5OlN2Xmnv0ckBo5t1q9ennHiANr+yCWnFdB/RIM2UAEeo8r0iA2QlW8n0i6IvwA+WkngHoGhUERblvgwNNj2u2MaN6s/96KdXAbrk4cCgMvBpsFq83p5AlSAtYnvfXGNr1klkrbt4ccHWKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MZE1RnAR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QZuZLi2D; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MZE1RnAR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QZuZLi2D"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U1IJwV3306267
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	l1qmpOfUAcw+5uVwQaUf8YL+ljdwyXYtfuPlud4dqik=; b=MZE1RnARuNWjWpcD
	joGo50u69+vOarx4Kq8btM7Asx0HhfHtbblvT1GHmpxnRke0HQTLJdV05214La7Z
	S1PBabfKHSHb8S9m4q9alvspjuaEUSBeLtPU9YjVOMaSAxFIMeBxG/4K0/8FOTof
	O5uWf4uP+tsckCHuoHxcUXkbrNaX6sW0yuZ9eIl581r18/aSxYiOAFyMSNTJhEXz
	LHTdsrA3MiU7KxfUAP42X4MSGVzfKHpIVJfxR00WN1icAt04HOv3jFfqgKf/3Sd9
	hrJVHCNX5NvkLQpJM/iHmj/EP9cd98R7g5Okm1oYzeZtOWgkaDOaAAFDMMBOIYUS
	VhtrPQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqvu403fb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:53:23 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e4ef9a74aso3227783b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785376402; x=1785981202; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l1qmpOfUAcw+5uVwQaUf8YL+ljdwyXYtfuPlud4dqik=;
        b=QZuZLi2D8sm4fTtybXTJXaobNuTI4EEF62XU1K4jNLXVCzs4FFs1Fw7JWokUger7qk
         OkpwuUXVBj5ErT8v7LI0G5TIchVi2NFeaXdN5mYoO+8oj7W16VfHC4XgqT6pkstxzfHr
         qgwLAMzfg3Bgt8mmcnwe/SFAKGf0V1lCJuwwXNAHPSPoR3HHaEUh2uZDQa5ds3k7zNYz
         6QVyY06uTlgCo3PLwuKTgLEDiharKE3lOsJP8OJ1ok2EOQxqiJRvvgaRe/Jsk5QS+JBm
         /FIo58RR4uhrCmfBvXC0/mvBHYn4iE50LzjrDO4fUgQ7QSWb5PVOitT39M4BLZJmcyAk
         IFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785376402; x=1785981202;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l1qmpOfUAcw+5uVwQaUf8YL+ljdwyXYtfuPlud4dqik=;
        b=Ht+ud33sSjFqel2p35xOsgFK481TTu8WK5ffdwiDonn0kstUUbuhhx838BWQOF4NKQ
         vyqXO4jD7VQ5hSTaxCmOtnASJ91THA6rzybaNDAn545CIHm6ITIILO+W5qRgNVJHan5q
         mBojlCWOpPvWLd/2VsUUq0YA+X+OpAGcg29ScynUp0gXOF25hK3oPQzVfC76P/y0dDCs
         nwcUmWqYYT77PWyE2xJKEziIplz6/9HaBu6aW4kXa1oq5omeUS8d6uj/dsCReXGCrYmT
         ars1t4DVSatzBZBe83oCrL4+M0EavJQZNcHk++L1uY3ixtPuGS3KRhR88B/+jGfLd7Hm
         dZtA==
X-Forwarded-Encrypted: i=1; AHgh+Rp0I5dWYNotKV4WSzOC3caHOCu0W+VsQlNV3QO806IVkVHhjOrSnnOy0GnzW1PwSbWAd5G70jTI3/tFKHpH5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwteD5PchdDNBaDV3A41SM5aS7Vv/TItbKHRrhSUKqQgV8DH38x
	AZ2a5bv3K4Q/eZmogwpEWu9gsqN39YNqN3NptRLEkMWuUvjJqLbDuOSKW4NJXx0JV5SUKCGmq+g
	gDrHQYPQubIqbVIHPoA0dGVtM4Lgiu2Jg6dGgjKinaQUr+D42/MDPvC7S5rm/wcQYUzdqjg==
X-Gm-Gg: AR+sD11JcURemRPhsxCjQpNWTlC79HqW/5UPTf1ZRz9Q8AMyMhZG7OguCAOUYLPeKhQ
	EXbkZfgViNv55Gy+HwvbB1eJ+uf4UBtbrOxHOwb0ZyPChkq3DMwT5ldEEY+bzGsqFQauIIlVZrR
	UwfLMTh8l22MDL5miwgbDhcTSZzm0c4Li+dvk9Y/rNgRF0tTuB8/64w3ScBuPfsNxjGNn0AbymS
	BYvihTi5V6OnhGbQYk6WTju3d7oDAArAG5dzjGeScj+xZh17iF6vkpYfiodhdFh3XebmSNfybOP
	vdueDuZykaHPz267Ju6IIQjyn8ZoZTBEMassPl8tgfg0zBMxjjRS/SWR9eEr2W4VXev72eQDLoS
	ceI6/20eV+X2LmzCBmzgaDCvHmPGlFAcfLZ0McbFGn3DPpoFX1xNbXtmsnciYWEvgeyjkmhI37A
	==
X-Received: by 2002:a05:6a00:10d3:b0:848:4faa:480b with SMTP id d2e1a72fcca58-84ebc217d06mr753744b3a.12.1785376402435;
        Wed, 29 Jul 2026 18:53:22 -0700 (PDT)
X-Received: by 2002:a05:6a00:10d3:b0:848:4faa:480b with SMTP id d2e1a72fcca58-84ebc217d06mr753713b3a.12.1785376401976;
        Wed, 29 Jul 2026 18:53:21 -0700 (PDT)
Received: from [10.133.33.108] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0374c15sm2130159b3a.51.2026.07.29.18.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 18:53:21 -0700 (PDT)
Message-ID: <ce9e9251-8b92-44bc-9807-a527524d3415@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 09:53:18 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current 0/3] wifi: ath11k: fix QRTR readiness related
 WLAN initialization failures
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxMCBTYWx0ZWRfXyC3i8sCHhosq
 d/tMTRdBgNPuobEtvX5w+2BpeVdWSkFVzudqu9h7+OGy7j7YkKfsJtWXgXWkVgH5t8IM2/PgXFJ
 1Pq9GvFszoXfY8RebWV4leWcuh9r5X8xvRBqs1KqK9lOYw5aeRrSPhgdJl0g7UvffUsopzI7zgU
 Vaaf1gpm/RFVUN9DnLW8UiCs+kgDkw+/EjpY0PEcpu8aXeh4W6ceCzzo/MRPtG83Jab96oiuJL0
 jLr3BfHt1jWfXl2QTdDJC1llCFo8lBHRQC0XlW1lCrkfyY6ou+A8QC6aCxDxHpJL6QNJ3wBA6i7
 k6Rzt2aEwnO3gDfQsPpZQdLxwP4MY6t7idLLYl1kA119CY9htmrbB7heY+EjpVUgA40oI0ZNMqq
 zz8XZz19rIVT8pP/C77szvmIOGo055xcpdq0SWANpLVJZqxQLC+R3rqU9pxysFLYbvZzAvr+u1L
 HhDGT8bcO5RzYLeR2Pw==
X-Proofpoint-GUID: hFEsU3v1JZv3_7OmRn3p5Zn45A-jvENK
X-Authority-Analysis: v=2.4 cv=CMsamxrD c=1 sm=1 tr=0 ts=6a6aae93 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=T3lRSWXN8vyyytrHHXAA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: hFEsU3v1JZv3_7OmRn3p5Zn45A-jvENK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxMCBTYWx0ZWRfXzA+lLwf/Ysin
 0kyRWKRZrUGLj5AcYOzRoNIkXMiVSER+DuT2gsyVaShF9/D5cokQKW7ADcz54jv71/3y9ARxo2a
 KwIJ58BOJyechBZxrMM0cfWzYDuUjlo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300010


this is ath11k patchset but you are sending it to ath12k list.
