Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400085;
	b=Zqg6Bj9Z8z09SAiDu9sst3fD3dgeCHMo7uvHuCH3poafeIK9fpqb2wKsq9X6v3NeAVbM
	 5OD7yuX/++VEORzkMiGY5cHDFL2/kTstBOTPP0gKwSJx0ggc2xQeY9VyXoTSB8J3Pm11H
	 rKt42t/KEIXCNpwDMo7SKp0RscsUJNMlOYAGnA6IlltelcJ8kWDdsq3SXCH6CDOQ600y8
	 aLguI+D2bAMVfUKQFTilmRcqwf5WAY/HhsThmJUlrzfiLCZSF9N3A9ID6DMgfduVTmISp
	 GNi+O5IvZY6n1SsrQ+0YsQVw5Myz2nq3KHZisbklEjXCRu8gVkd3abcXQ7KXPcewIEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400085;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:In-Reply-To:References:
	 Subject:Message-Id:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=vsBzW7xqQveqByDeByAFTWwNeMndMEtpm38WVOhX+aw=;
	b=nq9GNSi9kwdjHWV0tW/Ya74aEksfAFL1Pnljxc7hF8NsYTJqhDdkyqutxOYyla5K56n9
	 mk8nRKngEjMxWL58ldvZrXxh7lCbZuUGFTPii/iNam2BLr06ODUdWQzqPerv2jjHeJYPP
	 Nlvtlw2l8euuapc8PjvcsscXhsiKaoru4Lcf8Dv1PEz3MfhoEY/GboNaIHrDmJXY8Wj0+
	 OjoggmWA9XJNC2cvRL3uxV9/C4O04VYF8ZjWJ8ffA88+mPp48HUr44hdUNkf0bL0w2X4U
	 E6Y9VNkP4wzXLRAutVZaG08Kvi36r8JeUxtBA7PeE7eX839xRZnvOoIoPZ3aP9HExMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="FIor1cX/";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WD7hwcqS;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3128E606A31F
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3128E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FIor1cX/;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WD7hwcqS
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ULtgIH300574
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vsBzW7xqQveqByDeByAFTWwNeMndMEtpm38WVOhX+aw=; b=FIor1cX/x4KrRYVr
	JMMahIwHkbazCSokigyudNhapGXQyhnD1JzmKQEF/LJvtvo6oUutN9cwkdX5ImI3
	yNf2fDFsfRYVFD3ft5GSwOg7QHx7T64tTFjXTsw8ClDGMgqkmyNJ0J8GtEx71PN6
	O8D2mtNtYIeM3KZlwZsPxrfJnCDmsFCYbi6oUaYh5G0mMrWU3hBRxVNxlL3GwGWF
	pOhfyQCdNrvqELMZOidIFH/EcTopRp264dv2eWMDMCxhdr81hjOORnEpo7hhFhGK
	Wd23iQWqTztJIcDfEjnP1nkpJB8s7o6qErV3XMcx85XxDmdFwnLlUnS/o2xrLWzH
	XnAZ+w==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn2x0g92v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:41:24 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-351788121cfso5467659eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793400083; x=1794004883; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vsBzW7xqQveqByDeByAFTWwNeMndMEtpm38WVOhX+aw=;
        b=WD7hwcqSV8K8vkhesz29czBynq2xsBgRBkwKwYF75347fbC/lj565lcQd+0Ohb21O5
         XNVE0GZgQnCucirFSxD33ZHVEMewVe8P4bOuWwcpH4GaC108EbMiDjyQefR4vdoxwNB+
         4AvnYdwZyJNk7M3b4iREUjgQJOSeCk68N7H/Nc6JkpwNI5NlVSmVLIBL1TYk+xh0R9sP
         VKptE2eCyUD1B3a4z1eL8zdNEHYOvoqYA1ABW/gubhe7QRPMIzZWZH1XtQg52wx/k9kO
         bWJO72mR6zyoLey3rG0wHOU4lLDHEOQZ/SYqzOHyT+DoEl0m6Aj56YbHVH9mybZASt7j
         yxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793400083; x=1794004883;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vsBzW7xqQveqByDeByAFTWwNeMndMEtpm38WVOhX+aw=;
        b=xAhq0wHeCgOVKMvwuq4HQ195NvDT3XMbMo8zSIqsVQlxsN36kuQAjv659TlFsRLOGb
         QkRxHtoJGZGFOu+oANPSumgTS4Mn/y9ExTW3nI+JLZ0AZ2FNIFFjWZA00ahxgqTv8jLQ
         j5Jv5iygC3i+an1bOEgsdDWfYObKDWmJlpysgt+n18LdvBX10bNBgE//0QSNXidjKvHx
         WVzBbekg0mg3CCg/npJri3EbvSCnIAwxFXx4xoOL9qEn9wXyRkCsFvfGAURZI6MNwGQC
         zSbk2v6b2StkoBb9yIM4eF9ur/UVzzVIyf3hA9b7xsQr5oZqdHXmVojdOOo6gOHS7eei
         ze6g==
X-Gm-Message-State: AFq9FYKg1aM+z5NxN2aH8ljyGHh059N0aNCtUB1bFhRYSSE3vA6/Qi/N
	1vtBxke3kOQG0NsXzMDXVhgOEN7HVCInkCtvQh1Galanra6v6Ros9NONpL2Z8QrbcFEpDljqfMm
	8eXppYvqJYszz9p5KhaX/+ThkJt1U37HG1axqaOpSzDkZgeI0vK+a17tBcUkjEZrRpj3Pobj+p+
	0E1w==
X-Gm-Gg: AYBFou1c29wf/y9AlBZuwu+gtIFUHTQ325SvnA2paLKk0B4iE/LCMz/PYbO34dSbqG1
	LZ7GVE6NtSjbl4Bg0tbzJvWVZx8jy7U9N1QIcqiIjUsMcWgQRySoqrrwIszJ+zRVnJ4RMksFXcd
	1CtKpNoBEGyZGnGSH3UXM4B8PQs5o7Y7zfsTnrAzEEx/1i79hKYuALBy/spBgxbNVj/YVjC/vqf
	u4nIlhoBNpq/4mo3DkiJcibd+hqZAElvm2UyMQ2FecjQi/jToyYKyRX7ib5J17A/jzO+s909PC5
	KKVGkpICoIxlEB62//M3rrm63ceTbNBoU2TbY8ihioAqMQ4OPhZhlsOtw3Vk+uKPXMIdaZsErbk
	dMrY0ToLFYdqCGny00HJhq0mOeK0DLIOwF7KaggTlcOgYQlOw4TSX+W0uknS7QaD5M/Ima9wzO1
	O4kQ61MtAQip8WeiLtKsEJHNbL0sE=
X-Received: by 2002:a05:693c:6381:20b0:36a:1d6a:596b with SMTP id 5a478bee46e88-36a42412f55mr5914690eec.29.1793400083288;
        Fri, 30 Oct 2026 15:41:23 -0700 (PDT)
X-Received: by 2002:a05:693c:6381:20b0:36a:1d6a:596b with SMTP id 5a478bee46e88-36a42412f55mr5914649eec.29.1793400082551;
        Fri, 30 Oct 2026 15:41:22 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42935b4asm14002245eec.16.2026.10.30.15.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:41:21 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: linux-wireless@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20261024053838.3569557-1-rosenp@gmail.com>
References: <20261024053838.3569557-1-rosenp@gmail.com>
Subject: Re: [PATCH ath-next] wifi: ath11k: don't select ATH_COMMON
Message-Id: <179340008113.1790611.5520153588822009643.b4-ty@b4>
Date: Fri, 30 Oct 2026 15:41:21 -0700
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
X-Proofpoint-ORIG-GUID: f9H-_jhNoEMecaankl0EJYQlNJxbMuWb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA5MCBTYWx0ZWRfX2vbJ7n7uvOKT
 OGqnUSNh7isOzD/U18TBFyqehL9l+wJEaCnNR3Ygp1HOxgi8ietAgcCSiqTbWoy0QFQTmkgtZM2
 LAFCgBjDnGX3zKAxTUypIokYQy8aWkI=
X-Authority-Analysis: v=2.4 cv=IpyL47/g c=1 sm=1 tr=0 ts=6ae51d14 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=sFLP4FgJ8RwY3w-QHdIA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: f9H-_jhNoEMecaankl0EJYQlNJxbMuWb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA5MCBTYWx0ZWRfX60XQtdV4Ivbd
 WwbjSA091m4uWpLBUUJPaPP7gPZ8xtwTYrXLz1aNn8rTUxcp2uqUfTnHiDb6SCHEe2BMB88FwoB
 g3TBpksm2cIthU0imomhgEM2Nz89PpNITwD/rljlC94Y74eLlOMkPwLMCrkcTE2rIxjL40skMhT
 aUQG2c8MjQZqcqc8dko1IhRdXloYcRDUe3hWKHIq2cPTIsN49ueoHARj3/w3qJtBy0g406T9S5m
 3EIdJJCjSk/KeKnSCrDJU7vddHkcXtc2JYlQ+4dg0UvWvDsYANfTOydGcvMbSGJSr8MlCcq8SyN
 /F0aP50UCfxTPViVuMPprcrNvXneWbLLxVFKLoDdo3eg6LdYj7eXJR5lc2ZF3AHzZN+5zMgm0Dv
 QAjUrNGrz00POR9z2bgnJ6V7LfBPJKG0M9med8HFEsV3lejKURO+HlVJgctbJ8FQF4wTtTzJKeq
 C9DUQ23x3gAQQN1qK7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_07,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610300090


On Fri, 23 Oct 2026 22:38:38 -0700, Rosen Penev wrote:
> ath11k only uses the header-only spectral_common.h and testmode_i.h
> from the shared ath directory and none of the symbols exported by
> ath.ko, the module does not depend on it. Selecting ATH_COMMON only
> builds ath.ko for nothing on systems without another Atheros driver,
> so drop it, like ath12k already does.
> 
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: don't select ATH_COMMON
      commit: 70f43c2c73df0e769995990a7b330ee56f0e1fdd

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

