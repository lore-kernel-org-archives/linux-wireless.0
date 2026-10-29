Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793314569;
	b=up2AMYqiR5Z0hr5nH9qVgEXahk3vN6tXctPmbxiWcbeeOuOl72F5WUXPBMLuG0aqt8+6
	 bZYMM4G9OrL1ojG7drFHtnPGHv8DV5jEG70a0vgicjqyWZ+0mV2Q39fpOtNaenfWB0h+R
	 Cg8W2oVPnqiwiOUPHFPhZ3JWOCotSHp0n2oMB+PiosCXIFkCt/f24Iiw4KrD4vdyByXTb
	 dCxuMUYfA6VjAcr3kZkX7JhIEy5GBVe7mw7/2LFBpiAISOlnRrO1cI0U1EvI5Cu/3K2O6
	 ipWXUi4BHqbd3fPsFV78BUyn1jda1zgZV6rkmG775IVfJ/RNx4iDb9+m3MYFwG1aTmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793314569;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=XMQ4UMg22/RflarQ5xSdQ9z0hCdWnlJwzEMCsHMdtVI=;
	b=XnBqqQBWAbONI+NhNa6BrLjGU9KtjHx6ctsVfZyaYMG93E/POh6B1Vja8tW3I3ag9M0L
	 PfFN+KZdXYjEt9l+8tH0TsUH4+eW74TCpBlI9Tsmcd2TTmy/on43i4VX3KPIU1BhMARw+
	 x3Zmyue3r1N53WGs4aCksCD/GDzSkNLM3e2uKQ0xmXmaRlK7tSud8ZVXzaOHkHFWwCFEO
	 6Rp8HcaIeaG7D1fFkVGrCjFCBRArC4Vi/CsK1Mc+Fq0gCEwiyfPRHoFRq1/93k8zrEiRx
	 CCDAvSUT/99KmIKXB27Hfwgvnp+Ap5PIFp33ST+RW2S6KkM2Wlj3rLB0O4lRSbU7qcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=m9byPvLY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KZ80xiz+;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F86606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88F86606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=m9byPvLY;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KZ80xiz+
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TLbG1b1893688
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XMQ4UMg22/RflarQ5xSdQ9z0hCdWnlJwzEMCsHMdtVI=; b=m9byPvLY6pqVhV5O
	e+4RT/RyiYe77pl9POU4xpdMonnIkfOYMfY6+LdynlLzlAqvaGyWa568g6JqUr25
	6tmmlhou0i5FpkHTH2K4zTsOyeJ96DUjhBmEng3wkZ8XxG2IMzfTWjQ5fhMDWkHB
	qz/ILmBfnTYSNeRcniesWN4VB4SKO+ob85cBCO4vAqS0J0lWxZFblyMxHssoGEIs
	e+5+tfbDY3IFtjo1rv9DQ3bKe9MCfxHrtD/Do9Th+lRhxaFFMvY+T/L5B6ZFUQAD
	Pevv0W8tst8rPCGKzs2gBzur2PyfALeKeCTfYKttSzyqVwer8UIyKNK6xoddV2CN
	rFur0g==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qg8a6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 22:56:07 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3662e7a9299so630671eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 15:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793314566; x=1793919366; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XMQ4UMg22/RflarQ5xSdQ9z0hCdWnlJwzEMCsHMdtVI=;
        b=KZ80xiz+NEpZSvJ+4hVUPBfqzfcbXnVAu9bIvG9ZRozm8nknCSJCqQl5UXsetjfXOq
         Ev5UiMukE4TnsVACt305K1h0JMS+DysVaol2DMqq89d1+9h65ntnAUCKWfa6FHn2d8/D
         00WSRlpExqf6JSAozD+7ITdpyYz0ACIoGz2khaCUzxdHshL2AeitZtMiS6bOpsaaXSHB
         DZcIH5GS03vGUouaXv1uXJMCPSrj/A/qzQtKWxfWTKGQbIk+p7xzTliTNhNScJqLhbXl
         bTqC6JP3TpnTBZuoGEeqUQ3X3NtxMJIm0b8WXoYOEnxxiOLJr+QdtQkaVGNy3soXXGTv
         WTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793314566; x=1793919366;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XMQ4UMg22/RflarQ5xSdQ9z0hCdWnlJwzEMCsHMdtVI=;
        b=v62kaP5/cTJqQDBxvhPRYNp3VqDUniXR8MeO3YbZIQXnmfg/VSQ59DCseZdFFW25bH
         xA+H9C937Z9QVWVyV0yCMfXBZhoOwJumGTDiza9Xwd71/9Lhkx0zsTcrDAhCu7xLmUBn
         6QEpLi5z/Ql7GpKmRn1vpHnenx7A3tkU3demkDeR4x5WYy44XjovAFnqCfV8QmKMg/ri
         aTDqQtIX6MMGyqqm4iGkV0+16eKb6pKPgKzx5ksM5xvfycwYy1iO2ZlooM4ObHADiILu
         xTm7w2UbGXYUsvLp5LN+FOPcg+xgZAIVIjlXXMkFlY1Fg8B0Pb4e/JwlMWdjk+VPkeAs
         fdUg==
X-Forwarded-Encrypted: i=1; AKwUvByHP2hOolRfR3aeIvwBjfvTSO7vo20x0Lsp5bw1PqiybDjARNd6eh94WCLqnMXL7W3vLt0NCTWUuaTqHIjTEw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0pujuHGsvIgwCO5aZ9Lqg0SScEls7vU+qr0ulk4+nCihIu799
	eVDY7pNXRzIj3o9CSVkppJnQsxyYrWRwrXyUzrevngwVgzhltPCslZDhKQsSQQ4txw/Hy4DEcBV
	8DQ/0t02W9PLZEyTtDozh8F6MWoxq1f9onMTk62R4KtLwQmaIyYOcaqJxS8Find6LqA/h1TDRnq
	u+2Q==
X-Gm-Gg: AYBFou3N8AQ9Z2adKlSPCXe/0MqS301tQV9CPfQ5fliEYKq00iuQgBkHEUzzIsixdCH
	uq6Mw0oK/zSVB+7qL4DwQzQzQs02Af01StpmVsF/qfH6baYPD9Izy2id9SqIAabXK/Ezei+NmZ5
	T6GvBoieKB2AElOu4RfMwKnFnL9m2YHoX51i0W1NvbUgE4VTuDuaLTSmXJ2rcDj8NO8aw+lPhGC
	pr6iJDHiJBhX+NvExsosimga4z5vrZN9+wAyzoUE9qhyGkG7DNTVvcvR8ffqbIzNqoSt5Ci6SZQ
	2DqwF1znnoh7rn9QDK7zZml93iWPdb4NMOtn0Is5lmDShjP2FptKfEc9Oxq6IrGpr5rAhXqmKU4
	cDIHRDZmER4emDL1bYeEzNPcu8WzOQKdL6H9Snuv8VINBgieC3ahtxvUY/7dtOPnOjvuRyi7ujN
	SHLHCx+veL47uBmms2Z2A0mHJE+JIV
X-Received: by 2002:a05:693c:639b:20b0:369:f2f4:b227 with SMTP id 5a478bee46e88-36a4238e9e4mr1139182eec.18.1793314566132;
        Thu, 29 Oct 2026 15:56:06 -0700 (PDT)
X-Received: by 2002:a05:693c:639b:20b0:369:f2f4:b227 with SMTP id 5a478bee46e88-36a4238e9e4mr1139154eec.18.1793314565493;
        Thu, 29 Oct 2026 15:56:05 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af91bsm1644278eec.8.2026.10.29.15.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:56:04 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Filippo Falezza <effeffe99@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
References: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
Subject: Re: [PATCH v2] wifi: ath10k: Stop unanswered temperature reads
Message-Id: <179331456469.1083805.7983060076518551936.b4-ty@b4>
Date: Thu, 29 Oct 2026 15:56:04 -0700
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA5MCBTYWx0ZWRfXwInRstb8DRvB
 tSGIAJmcnTBLaFOt2kKWRdTLPKDoiU2MMBj8nGB34BMc4wpgIWObaZpckdkmm+Qf+Dxll/MPAjn
 nvWhrdYGkBpZm4eydZuBljPdQDSkgoq2X9Bin6Gw7GQ2GEoh0xfaTV2U96EcC+3x/qBkUEai6r1
 s9Ic83e0VXBLF/KQnXpKO9OfHuoYusxWrMIgwKNc/kKmmiaqvAK2LP0VjmQU5T5QoeP0F1PatjQ
 uq9IsV6PYi3OuokvMGO6V0t9gifbb+PJUomF8snHa2Vsqlf9BZOXEMmSsoVXQ/a9aPmV3JBnPCD
 piZx3L8Peqq25mo72fwkYXCrnv3lkr/5e6ldpjIql8YAgRNce3HKabeDvsEY8cMNhg7XNOdhT3M
 jSauLfK8saLxkuRXk6TydhiumnyJhsv5c3nP3MKB1FM+p4Ivsm2gxCvtRqJ/AWKCdsQqUdhW6Pq
 f+Y0NVRMSpeCfJL/ymw==
X-Proofpoint-ORIG-GUID: LzqCmAvtNPgdTPTZ-HpR39X2e4AJbna5
X-Authority-Analysis: v=2.4 cv=IeoSymqa c=1 sm=1 tr=0 ts=6ae3cf07 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=DdSAyOQbr8Fa4xelbuYA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA5MCBTYWx0ZWRfX7gYhY/zABopY
 Hv70UUXIKXgG3QPYDevTy97q1xaFJXil0OlENnhgU3omb+/938dUqW0CmQbe/heSRcHYwg358Tz
 H7pncz1q6M0NZ697bLX8UUZOu+d5P+A=
X-Proofpoint-GUID: LzqCmAvtNPgdTPTZ-HpR39X2e4AJbna5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_06,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290090


On Tue, 27 Oct 2026 01:56:20 +0000, Filippo Falezza wrote:
> Reading the ath10k hwmon temperature sends WMI_PDEV_GET_TEMPERATURE and
> waits up to 5 s (ATH10K_THERMAL_SYNC_TIMEOUT_HZ) for the reply event,
> holding conf_mutex. Not all firmware answers: the WCN3990 firmware
> WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1 on a Motorola Moto G 5G Plus
> codename nairo (SM7250) never sends the event, so every read of
> temp1_input stalls for 5 s, logs
> 
> [...]

Applied, thanks!

[1/1] wifi: ath10k: Stop unanswered temperature reads
      commit: 2a87e367c62856b87a90f745c6b7d2eb91e0c51f

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

