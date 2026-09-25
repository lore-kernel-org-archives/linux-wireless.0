Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC394CB8D9
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350024; cv=none; b=SbfabfR3zM/Xg4scF6Fk9lnuJa26aTALiiKjP1A4GavabkR4OTJ31qfQJ2DGadep1jZfVrR0NRQKaagcaAyDV4TVMoIkR4YH42AV++OekYO9X9N6U8+mftk5SAUTvj4Ftuqh4ZcZ84yFRFHsHO06c3sjQaE0mnRhB+kP2TrM2Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350024; c=relaxed/simple;
	bh=Rx5oXbj/sjIk4O5huy9Ku2hytV7SJX6OZ2gnizf03WE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nUZCrCXGDhBydTgdgLiVhkycxpDKRu0sq14aGV8uXel+96FKqd85iQURzBneqy6VGmMcGABloXiAXNWhEx/eykOLzwJCOOpvzE6uTpfwGY5P9zwVM11Dd/hU01aSdc9KUEiYAjqNkqjJJ/QLZgzpvj7pufJrgmo1u+ZROVwwh5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OOndOLpv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XlAkR05W; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OOndOLpv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XlAkR05W"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PBLdcC900282
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Kalpc+ehVtKWOvpdmZ6pUsBPjWV9oQ3vkA7/FsaCrhU=; b=OOndOLpvVZsDNDm4
	S1SMM7gbaddjt9qB6LQ/dfn4b58+sQKw6H7j7MS8W1A6tG6iZcu4hyosSBPb08ah
	Rz+Qk1vTA7qou19IYgDXouO+FwQvzMZ+elLS7Q3/I+na5W2e4SGyE8R9T2IYKF9b
	wezIOwPYeOWI17bEeP0CxjHttQL4uBeOZhepmD1NkDdk19RJ3umZrxrT7ZGPuWiy
	jUfWsyqIqpzfLUEtz2vVXPu0eIasvq6RmMb4qbtIOmFtUc2uEGoLuuEWt5bamLr2
	4inNgL7DZ7QzYlDhnkf2HiEviR/pEjLX58Mb7cyvG4zIe9Hb6hDEf6KLsGR7NygR
	/mNYUA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwr100spb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:00 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3a0ad137e87so1430799a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350020; x=1790954820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kalpc+ehVtKWOvpdmZ6pUsBPjWV9oQ3vkA7/FsaCrhU=;
        b=XlAkR05WHl0WjUkjLMXuFI6VSXo1d1Q0nnUT6fljgZnT/yqAlIikTvdIVZF5N8PfEd
         xspI1N/B+SyKiF98lpgV8atMj8lWGs6uBR72ycn0NgzntLeb62Vk/gOeDygN9ufcahh3
         sItfrvOYtZMtu1ZfQor7mc6dxd11Wkzk0ZlzWi8NQfM9fk6Au6ZVq9Ii9mOAqfmudO1p
         I+P5niETMcFfnZFReqZucEOV6IVf+KDMNwkf9NDU9Q4MEI4OCr96rQDyU4s+x0KjBpQa
         pOfImMKZMhyBKPbT14XYbo6gGgB33D96Ag7KLwP/HUvlLjrYY3mLFwOO2scCyjNPixDt
         5mfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350020; x=1790954820;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kalpc+ehVtKWOvpdmZ6pUsBPjWV9oQ3vkA7/FsaCrhU=;
        b=twOJfsKO/HDQqZQlBbYSv/gbc3qmB8s7FqXIywYhJvNXNv/z/4a9OUFvj+HZkc2zZh
         4t+JJZrxzFToli7FuWA4xm8xGdE4vqwMpwWvXYBJNA0fFxdQmT/dLN8M/IyIHmJ4D5io
         kNZ05xTd/eAmQaGWbX29ulyQwwpLpu3/rPxNeZWZRb40ocYnCF1Vkuy762jMI/MhptWi
         F++DWbv57QRzYe2Su2+K66BIQslG+WxUufsxlKGCxLV06dCDR6BVamN1sM130lhWSgaJ
         GCRIP/UzRxNTjVBxkcI5MyGZb2bELq9CwhKKHCoGeUHyF5GaBr/DihUBRSmxrFR6Et7S
         sOEw==
X-Gm-Message-State: AFuF++lFm7bMeZlelRgJW8kR0Jd6slvncJkTZLi/Am3seL6kjmoHff3R
	eeXPKPWlEBCESIADZjB0KC/XkkCj5BmomAoSfPO4/NiDnL/SmfDNTbIiXajzUvjhE9CXfqDAqdf
	qSqkNaH533zzdOraBSWc5+QxOcOz+NyYmLLWzDIk6HergOKJ0bXIN1dpjBOqcKgdeKnphuA==
X-Gm-Gg: AYBFou1HedtXoMS8u4vuSGKVjRXUXpWHbK966AcAd2dTVoD8l+FqLj7fwP3o864FNE9
	7u3nhu5+ebrSsMYViPneTcIuSwa1RpKk0I0otISK9z50wIl7HfEhOhKMVJBaubQLuTVknbcFhcg
	u6qyAcdioKWc0pIT6afmElBtAfdU3H4mH9DtsY4rlVQW+EUWRzRPVK7+KsQwQGVhqQKFHp7VZBV
	jUFqsua3xmgntJaiKpttuIiv8ELCWT7f03VdOQbXkGK9t46dyNNf5tw8CcMrOlF4JctmWhWLkxQ
	tCRyLfLWWtLHrpRo8k0uI9XyKf4ujgBIp3Yi1zoH1FgGYvwSPvtH95PZPnjlFqItpBpicvgZaf/
	pCSr8/2QPjsut9gjp211jQ4xl8k66vfclgVMfO3LyQrbYbVwrh/3dpiw=
X-Received: by 2002:a17:90b:53c3:b0:3a0:4668:4cb0 with SMTP id 98e67ed59e1d1-3a09896a5a5mr5397996a91.47.1790350019605;
        Fri, 25 Sep 2026 08:26:59 -0700 (PDT)
X-Received: by 2002:a17:90b:53c3:b0:3a0:4668:4cb0 with SMTP id 98e67ed59e1d1-3a09896a5a5mr5397862a91.47.1790350014332;
        Fri, 25 Sep 2026 08:26:54 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm5320405a91.0.2026.09.25.08.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:26:53 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, Kang Yang <kang.yang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/6] wifi: ath12k: fix monitor RX buffer
 lifecycle issues
Message-Id: <179035001295.3875741.9230088597686770620.b4-ty@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 08:26:52 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX3BgkR0EFDP0D
 tDQKL6SSHAp47kkynfeqJZC+VdzqcvzFO4iCk6oMsEBYoid7a5NPQ3sebCb/JGj9JpaKEelo2Ag
 lmernrIQ4HKJcsg7+EyR//6gqaXndYBX6BsB/813UHHEqa1nlXeq4zsObWF8pOL0Wf+AP3uc4aj
 MLAVULmYzzxhIdR2/JgzOJitpQDR3eeks3CpHTitkUKCEAd6IKREYq/CBbJ4DGzwsL1CZ71BPdR
 8CEx/8EbjSQg20inIMTbsMv1/36nxpMgQsh28TVPWhxZa0khtoE88NJIsLPiMVKqysqnKghy9Oe
 jtFlfIOQPh2MZP6B5uSNodGyOxq27Eo8TAkzcJFJNNeFaE+Aoh62vdSPf41MDdxd2m1JHCfbgbb
 Qmj4n9WdPQa2wjAUoLFdoEa+Cy1FWyhAVYO3rCQbPnkxGemXtM/t+1oW3Je8GlSm1FxQFpy15RH
 oHGDMXlTzOj1AFfFFRg==
X-Authority-Analysis: v=2.4 cv=ZfKIpcVA c=1 sm=1 tr=0 ts=6ab692c4 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=jeZ2dEGWif2cJ8v1hNMA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: 0rOsJA5PjlGfimh3qGcurwBILnFO14U3
X-Proofpoint-GUID: 0rOsJA5PjlGfimh3qGcurwBILnFO14U3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX8XWSePIWxmOx
 VsM3UYv8C5aEFMGbi3tYfNWPic7NGWlLpCyyaLByAMLCfDrBkANY+6k2P2+dUdXAAZr/I241P+K
 lI0ez2vrMgd7LFbf4Vv4LvuXVhhBF3k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250061


On Wed, 16 Sep 2026 14:03:19 +0800, Kang Yang wrote:
> This series fixes several monitor RX buffer management bugs in the
> monitor destination path.
> 
> The fixes address leaked skb buffers, stale monitor descriptor state,
> object lifetime issues, and incorrect DMA unmap handling observed in
> various error and corner cases.
> 
> [...]

Applied, thanks!

[1/6] wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
      commit: 4dfe8e3ac731c3372b5c1f1f73b0676c301c3916
[2/6] wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
      commit: d8e8eac3fcffc114a79f7d07d7cb73cc16645381
[3/6] wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
      commit: 1a10a558555072dba8510ded23a9174b2a00d079
[4/6] wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
      commit: 8b1d2f4c3805b9f1bddd5dc3bd241edd1f9ab2d9
[5/6] wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
      commit: 97b144b82e2388efef1f78269626d61de0480feb
[6/6] wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
      commit: febe1f8cbccc3434790bfc4d94d40c9dbd803065

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

