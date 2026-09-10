Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A044F543
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 21:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789075919; cv=none; b=D6+JF2gzK675QzxqkeDZ8MSltVFvSWnLx4nu+oNnvKnP7vsKGeKLetR8iiD1Swe+DGg/bDpxWaKzjItn93X81x9bWAWc8XqqsOQpUe+K8Pw+8/BHs4w5ICJ0xazVNwtJYVEYbufpGinTuUUHQs//m1tQmOd0RBBVU7iaoUKI6ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789075919; c=relaxed/simple;
	bh=Kc3JhSdxrvdkbldhqqLOCxlB6R9U1FA0j5Yh3dcRwv8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GbIIleuaeUopHJEum7SxUG9kLx4z03PmcSZE4j90dvtDYsLQB8js/qbMcjmzycuDjo0Q/LkPTytZIYk6nfR6csusnXB/sA2yVUFkgxBCXF3boevwO7hHJlzRO579foBm/SAO/hbDZM5NhKh2SBZJkzQ1afZBsNz5PJyQfEGs1sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eGwqbwFB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bbzRj4El; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eGwqbwFB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bbzRj4El"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALU3vS972601
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 21:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	q6Rrg7E4ekU2UrwXZDAmFlaZnGNaCD77Yu/KxI37yXo=; b=eGwqbwFBlCtFob7Y
	dHRIgjtDxLQMLr/jSPWvgl+Q+LjRFyrSv1oOpbN2YK7Nsyb8tTf0rMQjePxXAl4i
	lbLU0ALlNrUo+lsf58zT+MDg0wScPgLzA73bbYPCPn3AAsMq2cSssXBIWvF1q0PH
	VBEz/AT8HzmGPTLladcWqaB5bpxSBHQ0J3enuHeJaI+uAIbHk8BujceCBpUvHAAC
	zZ0n2oj8ancDSarSVflzYeVJ7bF4aYTmByAimKgH8HKupG334l4Va0UxBjXJV6Xs
	l656A/NqoHe8XVtjMLoshgO5AhKEXGXcIGdPmo3WUFLeUAE91u2oFkQn6S1qAxDz
	bluHcA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gksh8u96k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 21:31:54 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso353448a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 14:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789075913; x=1789680713; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q6Rrg7E4ekU2UrwXZDAmFlaZnGNaCD77Yu/KxI37yXo=;
        b=bbzRj4El2gJ+ssB1ZI9lnxMuA8nVEBjncIdQH9rCqF9UXAA6USX1xu32dBw9eRlZGh
         pPaLHwC6cs+GYFmLHTqWyAeItEW98fRfzP3iTw+/uHCQxy3nb6nivRJghgix2FeBCt6i
         qsFmbwIVk4rXN5xdtW6p4O68Kb1pFumYL/bnnB0YgbSvcYZn0oYarodemXNQlxIwBw5s
         /1B2son7n1F6kT2E3a3i3d8UgJBRyae3k4Ny0gTHJgjV6hw7SK3eunEraT8i9Zo32fXN
         2gSoj0Yu02CAWfEjNc/94FlGJtRY3M0wK/YWAeIA7gvBZ38rdONfjg8Gf8/JeWm4LPC5
         QBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789075913; x=1789680713;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q6Rrg7E4ekU2UrwXZDAmFlaZnGNaCD77Yu/KxI37yXo=;
        b=fZg87HfNwJb0nzYixxy9xBxT+iZWONZxe/17SPW5L15ZEoGaeKeJ9kQ3/r6pSpFZcf
         uYKsNULfkEVfEGBc1bWVhm2iotGTNvlc/40jhdbz9jbporMotenGM0AS7dSr4s7WUjFM
         u2zQW1W+g3GaOremZNmkNVFr8lI3Eb1fy4+AvER+K/6IXX1ghQhiFBP0daqngcZbdc49
         QwVTvohuq1MVbtDCDFfPJPaZ1zKZPdAb4EyiY9gXvaEZ1QujiTx9L6CftsxqarqQ0eCh
         EWzL3bMBFfRMxoSTDzfYfKGNK63sVSyAUxLBwpNLUba/AlfySr5ZLW1D0pbAlsrjpnP6
         GX2w==
X-Gm-Message-State: AFuF++m6Abx/LfomFzt9yGF59v6fYSZQTCn/zuO3SEEy12p1oAX2+4A9
	tT93kT1KPxsKLdcc38oKytkKzDzcpUGYwjWRid7IHo3OHT/uFAayRdIL9rtnU00XwdmPGz3xajK
	gDLI2eOu0OhPWAfrX6YxZnlPRfOFFrYPP+fJ/SavdB+ekPrgHhsb+E61yc+lyevf+kWCiqQ==
X-Gm-Gg: AYBFou1mEwWZrP1svyCLOCXO4V3MQb0PsMUfFpMeVORYrwtbTsvIwpwO+DPLd/w0Pki
	WnMBU6wZ0Ht6gDd48a5sCg/zYgeyIO29W536pZl/r679dWdIVUwlTGpSAGftwa2WKarRyawgnlF
	99tjyhOOIUmVks/BtjOKkjK8KOiOtsH7PGOBjJrDh/ea3/2leM5QpPCVEc2ZYCXB0I6gv6dsXZV
	CSAcoD8YOyh99Zj8+OWQVEadKrFOzzQddluCsU/IK9Rt/3ndq18MgX7UCr05j3goz6kkoaOopm5
	nmSHsh/nLzNtBXrdWZRq1bGx+ycfEtlrnrI5kpPX8vfW01mPiqgD3E/yCXwDOu/XdvtU5rCD/bz
	2XCsBEtHEU50xPscFlO6KIOQw0Ctyml8OdMT8hJ0wN8ddJ/7uADONX0E=
X-Received: by 2002:a05:6a20:9191:b0:3d3:aec2:4dcb with SMTP id adf61e73a8af0-3daed3c163emr1483708637.23.1789075912874;
        Thu, 10 Sep 2026 14:31:52 -0700 (PDT)
X-Received: by 2002:a05:6a20:9191:b0:3d3:aec2:4dcb with SMTP id adf61e73a8af0-3daed3c163emr1483644637.23.1789075912367;
        Thu, 10 Sep 2026 14:31:52 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f0feaasm845733eec.21.2026.09.10.14.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 14:31:51 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
In-Reply-To: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260811054316.518494-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath12k: add support to load shared
 firmware on multiPD
Message-Id: <178907591083.684897.6314733930806411528.b4-ty@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 14:31:50 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: bx2Sivgs6KL-C2PJOAgxDADZA8Q_szYg
X-Proofpoint-ORIG-GUID: bx2Sivgs6KL-C2PJOAgxDADZA8Q_szYg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI2OCBTYWx0ZWRfX57gVjdr0IChQ
 9DoDTM2iYLDvbBljKjddDt9oR97g+hDidCIL4aiM9PTGudrWb4Sxk/fOshx4hY9ce16MA91b1Kx
 JhZXuNf0CzLA1SvqTCMGMHgkPtbSBVJlrZZJ8dBwSOIIQa5yHYj44mVh71TAU1X52aR7PIIjAO2
 jI9wxwEN02r2d0/FcixZVMB5gosozkkfwjsqwwCIF+NNTMs7CqNe41o83r2NwsCcJyl8fCJwIHG
 peCCJW1V3+eY5B4n0WldOi/Pcx/kNbaaJv49CdtfJBU/wSmTYAnBauJtXmsOkMjlxMLJ3UCLjXp
 0hNHbxYjBuNMWIoumb1fqlI81m6+rw4jlP7cE0Vwe6YPCvlDpV6Ux0HaYcez7ye6m5KCP01gquT
 iov8hHpr0Cy/c/UIrpxy0cKxREGoSP+gudcJiVgbwbAv2S56F1tB08p+aa8Jd9P34/GQ9kR8ykJ
 rJ1KgyrVTjxzLAZAG0A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI2OCBTYWx0ZWRfXzOugpmMYA4Vc
 1H7dzQ7/J+VzsVHZOhKu9aIhknidtbfxopRycBKxcMOV+bUh/5TfArG4D93xm9OAorSnsZU9K6c
 +YQ4qs/FueGTrKTPg607fUTSHcFXpZo=
X-Authority-Analysis: v=2.4 cv=a56lZkSF c=1 sm=1 tr=0 ts=6aa321ca cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=WD2RVSGR4ZOmZR8fVjQA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100268


On Tue, 11 Aug 2026 11:13:16 +0530, Aaradhana Sahu wrote:
> IPQ5332 platform uses a MultiPD architecture where multiple firmware
> instances share common read-only code segments. The driver currently
> loads only the per-UserPD firmware, which leaves the shared read-only
> firmware unloaded.
> 
> Add support for loading the shared read-only firmware once before the
> UserPDs are powered up. The shared segment contains common code that is
> identical across all UserPDs and reduces the total firmware memory
> requirement.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath12k: add support to load shared firmware on multiPD
      commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

