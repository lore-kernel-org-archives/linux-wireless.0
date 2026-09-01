Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C782BEC4E
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265949; cv=none; b=iQiVRnoc8WXkUdWZ5iyUg1u+UL8Lc5zi6S8vvTa235Zr4oktaxYyrIMnG+LcaAw9+YEP8IGVUnR64BfIThubzVz0jSfB0BYxjhvOntlKn+ueBWnxnDhOSvjjmt0PnoIdOS/juQUN3YELlAsTzu+WdzM+LbVSt4WcQnk8/uoGR5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265949; c=relaxed/simple;
	bh=L/1GqbI6CVNHTOL+k5Bs8hxag5TXOK8IKP5ljcwCiiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hR/kDgYMzr8UFtROD2LzOlMN6Uqi+pXBVlJojB9tj9A8e0te7PPChrIp0Z5n666wBHfuZQojPiukRqR12cnX0hbihx0WD5ybrAnofK+F9uxhjlYvbnNRXpsIJsQCPEgm+bFaCdsBgG5UhhyEHYkNayZYiWrDN0rFSZDcFOOmjqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=irf9zcoS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c/brrIno; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="irf9zcoS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c/brrIno"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AJdxA2406438
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 12:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UicsQCF2CHWzuvo39HPg9O428ToJvHotIHdRWV/p2dg=; b=irf9zcoSmiDPinKB
	60PluqS2vnI1lsOxUmCHBUVLANxeE5+APsUjKskvpzQEekTcbKXSncLl5oeu6M6Z
	vAUA86FCM7dOMEBoReY9kKpEK07FFOS9ELKOwDbBgObeS8uQWFee8prHRvR96N2m
	r2dLGBV/COzhVJFapfVPAIVKdhNuHx370XD5bS+vCH7kRp5BH9aJRn5jagnWc7Nd
	fQ6TyVfbbJxYaEqT2FfALq2dprYxZa1YM9yhy3EOu8EbRCs7RN3xvoYgy2e3j4yL
	Vgx0oTVGXkMC8gQ/Az8NcwaclewhP83CJv6iIryVS9AxRVTAdbD4wlrK7YDGpENL
	gt98Sw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdp7r2a5x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 12:32:27 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3965ba1ba3eso6187623a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 05:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788265946; x=1788870746; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UicsQCF2CHWzuvo39HPg9O428ToJvHotIHdRWV/p2dg=;
        b=c/brrInoJKxkzbClhPcfhxsegHuy6BKKg3M4YsW2ASz0Q9qfmuWdDkjbpV0dV8E4jo
         c9OxMrcH+ENj+4NR2bwiwEr7DAKOIFWKk2yND9QrO2SBsOV8RQtyDj3bJFXWYZZ7eozA
         t2K4blrQ5sC/ACE6OAqHe8NrZUf06v/gT6pkZWlNK0TFXnvSj9HZY7UTl0Rz/dch5ZBA
         tHlVbZLLU7e4PKbCcVZIu/6xwCiB590VjAnTWexgMSFoOrjF6FxHUoXBe2KPs5gZsERM
         urb85LynfiT9z0r20tPEKDAjUqDhvSIaLuoPfYPLKVuySSRaQ8vuiSipzZSAqwk6KLwJ
         0mUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788265946; x=1788870746;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UicsQCF2CHWzuvo39HPg9O428ToJvHotIHdRWV/p2dg=;
        b=qrVcgteEDVdIjC844MRd0I7n0xcYflvdPGo+igODWJqYDnOuBIr9fsHbovqIl5s+v5
         YHYhX43j8PmOAwGD/Frwt0mAi3N+GP+GfFfT4eKHx5AWOn/4d3sKNQ9yfRnSOAZIz3b3
         QNfmFSSIHDjTMzvwKqsJdJcR3NNPfLaXvHuepovsK/9d8X4gurTp7WoIfcqsLo3tYJo9
         N4WonJFmxCOOPV3UInlpKJszx+dGpSHt9dULaM64Dg4bftrKi5zoZO9Z7iXItw7BjzRz
         pfrZLWmg4evO5nkNwvyxHhrSru6/NMJEyU5Uvqjn5cSN72cE/ubb6jyfeXdG8B6qmOLf
         L14w==
X-Gm-Message-State: AFuF++nMx80BU9NepjxW2tUata5Ii/r1a7DVvrVazuz806EfzFrpLCPU
	9h7JemL4yThjo4S5gWH6rS494qesKqTz9p+37NhcNrDSshDW2Z9BCJLtkwCjiLcRgLYTsWVFDZu
	eXVqZA27dDBgoYTcT8PHi13hIsmrsoTByBxs07/Oh55YQ7Yh0je0TbnyHVpO1v87JZQRnsQ==
X-Gm-Gg: AYBFou1QBuD6vRIQ8gCs9OsP+sQZKqiNmq2ebtIfdcl4yI3JPm44BWear+y0LVU+7v1
	WwPa7WddqnE2doCCkkf4QnTI74kapaXxUPk4QEBCX6b7x35CLKwi1JaJ4n3S2ttcwVliQfQo7nM
	P7FQcyl6RPgNU3pBmZgdJEz/Z4h1vgcAmc5+xggvoxynuaLunc+GWRhG/EvtzzZdY1HwVJ85umh
	t5aCHaitHMglGNidI3VDKpPabNf6kMG1XuhiIuATBTuRWu9kHkaMxPHzl+u4BweBeg/OOzjt8LC
	oWjgpG8apEhXy2LjvWnjXen0hwEpaLwzSb+jFKNX6kkxDXI0HmCCc46HHIS7Eh6y6GWyG+GyCy9
	kwLiPfd8vBn3XZ3CJPP/2VCYRIA4MnsUX2TWMhwBmbGb+
X-Received: by 2002:a17:90b:4e88:b0:398:a145:5d3d with SMTP id 98e67ed59e1d1-39907b17a4dmr12472464a91.6.1788265946438;
        Tue, 01 Sep 2026 05:32:26 -0700 (PDT)
X-Received: by 2002:a17:90b:4e88:b0:398:a145:5d3d with SMTP id 98e67ed59e1d1-39907b17a4dmr12472352a91.6.1788265945902;
        Tue, 01 Sep 2026 05:32:25 -0700 (PDT)
Received: from [192.168.11.105] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d18eaasm39622866c88.1.2026.09.01.05.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 05:32:25 -0700 (PDT)
Message-ID: <0fc0b82d-69c6-453d-bdf5-c51a9237035a@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 18:02:17 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: ath12k: support calibration-variant from
 device tree
To: Andrew LaMarche <andrewjlamarche@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson
 <jjohnson@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ernest Van Hoecke <ernestvanhoecke@gmail.com>
References: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260630133001.1426824-1-andrewjlamarche@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=beZbluPB c=1 sm=1 tr=0 ts=6a96c5db cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=erCTOyO-HGHO-QmL5V4A:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDExMSBTYWx0ZWRfXzKYWOhIafKXp
 KSnJ9YFTtaoJZoneAdzMn9obl3udPlmxosJsFbEtEn5sdsyTM4Ok+p7cZbPkmODvybJn6Xf+X8L
 gliKO1l0BnBgX4jcggj+D29wGlL/FAAPVvZ7x1it6r7z63iMEQ3YE99iAm70AlgsMDD+OEEpXXW
 RE2LMRlO+Xz5qjS25JvRsxtgzzhLdhsbUy76SwvG4CDGPnm4LkiX+07JtWs6Nk1vuCAHAAebZuG
 bkQdP7yZVW6EoHcOb+S9Wfpc63EtA96sqt8F4p5c9raijNLuAKFOF++2uJjVgEjOHnxbtzwAR5J
 gu/O3521sWIhcX9TgCwWn5heccjxQPFTty0hPUdJsLMPdfqRpVgYaDv60hRRzuX3FN0nkojm2LH
 Sl9aVfrI2XY7S2I5yeoPwf7I4mOFDKUB8sUzp9DQ5JEBP0ZesPUUQDoL4gmZ7eREn3AMakoeslq
 qrW9XBR2bTVzJ8g86bQ==
X-Proofpoint-GUID: UNeN4cazuRR1GLe1gbK_uZXfrASms0Av
X-Proofpoint-ORIG-GUID: UNeN4cazuRR1GLe1gbK_uZXfrASms0Av
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDExMSBTYWx0ZWRfX6l+OgtgpWnix
 PJ6pJEz9j/9nNqdZAaA1AYnbFCMzL3WXL7FCg9CzZC+wR3tG2EuQ2FjG6+PrlXHp2s+eesnV4U0
 QZmVVPmMewtmeQk2bN4DFhNVicWU7EE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010111

On 6/30/2026 7:00 PM, Andrew LaMarche wrote:
> ath10k and ath11k support reading calibration variants from the device
> tree to locate the correct Board Description File (BDF). The ath12k-wsi
> binding already describes using qcom,calibration-variant but it is not
> implemented in the driver.
> 
> Many ath12k designs expose all the radios under a single phy, each of
> which typically require a separate BDF. Without this, the radios may not
> come up or will not be calibrated correctly.
> 
> Fix this by parsing the device tree for the generation-agnostic
> qcom,calibration-variant. This allows the driver to properly select,
> read and apply the correct BDF.
> 
> Signed-off-by: Andrew LaMarche <andrewjlamarche@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
