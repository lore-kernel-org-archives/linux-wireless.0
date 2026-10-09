Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8207243712D
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 10:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540947; cv=none; b=LIuOzK7Il9DS3kJU7W6ywsg6pd91LuiCjV9Uqb1SuXbmPGIFgROxR/Brsd5zeHZBYpJOTloO1rw3l4i10iS43QuSvpV/FO5AJ43JRWxEZdPYkolspAe6qhCP8z1hOjUK0H578UQsxlMFJgcAOxRT//YIkmLLsefU4H/Eo+Lk7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540947; c=relaxed/simple;
	bh=+Sj0A3dqq23hJntkp342nTTeMHn15BlSiNgrVR7aHgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fvtBTyQtqkCA7DQa0tez9G2O/s1tSFkdYMk1KbOnY3+cbBbKSWUqvUUJMdmZvWS6Uo4KO9IFNGrge3iRaKhWU7Wwpi5Uf0q0W+u+qeEHkPF2o2XBzwcVPP1xyorvVyteEE69O9Hq/TKscnMrOp8g7EpxupgZRVuEgos9jZ/1WKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E8SxVAsh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AhPAyrgA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E8SxVAsh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AhPAyrgA"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998L2aL643852
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 10:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FL8XGJtRI+7qCtpmGw7qS+GXrTYObKStvKcQdkmFYSQ=; b=E8SxVAshoXRPHfT4
	jDb63xAQnTghMe8wbetZduEsrmsZmmLBcjTKKlWRxC9h8MUJNo7lN9IXAncdS4Ez
	KKDPff0wJAt664nI2RoCnDnWd2QPkRzmTuP76hPZd9pZX64/NLGai55DA8la1RAj
	E2sOq/qmY0bVXexPr0CYEE0ONz9lURWVK2AtDwx53cuhAjrGpSroFcaIp4KUrfPL
	nqo79IwhHPHZmnCY+dxM8rhff3b1N8YvVTXSyWEvKHozmOgiG9x8EAL4S0gOFzPv
	JeC1dQkgmkHoFcnl3K15aWFvuUsVM1VLBeEXBLUS/s5Ij8fF6y6CESgLsgf1LDIX
	EFBHRA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fxru350-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 10:15:45 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8886059d3faso12865463b3a.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 03:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791540945; x=1792145745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FL8XGJtRI+7qCtpmGw7qS+GXrTYObKStvKcQdkmFYSQ=;
        b=AhPAyrgA6X/DcYgFL5jo05ewhjNqJtzOMt4R5wwH+m7iDNP9IDmLedNl3iHvBApH0u
         4Kb2H0veUqiNt8ZaHCOfqJA0R2BF0LEY/lEvT90+47nmtvDnJwPD+AZtqwg1Cq7sC6VP
         qP7CP7GkxVVvB2YI8f9TJgNU+0JBHQPMQhMe+tCL64IV4R38BV8Ob85XsD1Rtl70yRjE
         84J2ds6QkyOAeRcozYDSGGE8jeiUwitbMTrv1OQ9cfe8YBgIwcniBUPWP8yNwAXy7I0e
         MFM9Db3ObDfq7jX+y3ddJjgabFtfPAFYkTZDuwMnbEdkA02piZPYtIIjef1C8QRwIH35
         C3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540945; x=1792145745;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FL8XGJtRI+7qCtpmGw7qS+GXrTYObKStvKcQdkmFYSQ=;
        b=yAQimvckqlguofPbYpJNk5qm62F4KEfvNR7M0DBvnKT6Wqor/J0D5SDqTS1FZdmTHY
         N5RrZ3VZ6D4EHji8YfL5wYkE62pnlMSHEi1RN8BXtuoOwkmdHcBGDZtERfGmTrv5izky
         wdL8XyYkl0BIdItWO/LRkqMgX8z/3DYyi7JyMpEGahTMwsFk86S4c2PLahG296dG+yom
         B6zCix6Mc7qNQkbCRPbjeKOnUUpOpKo4xYRG3pt+HZSa2L8hzzKnGZuKp9uS8tXHuG+s
         hh2ArJLHoeCAxc5gUpvgrlZ49MyxNf9D1rKd3JPEpPXPaALIQBDrxxjnlUz4uk12q/Xs
         HEWA==
X-Gm-Message-State: AFq9FYIvwoF20W53cloAEWNovS/yYlEuYiGflPpMmLTYCWL3pZkJXBQ3
	ncuqZ3OqwhbNJ9HWlrXrzXg5/hFPXdJ5PLK5RbgscaIX0ddZOX86djF/VbstOSMrFNZgoDkoWE/
	HseRe29TIKnrSNL51pIYK1Vy0eoBSZcpID6g7QOY6sF9MZ8UOmWYZmM7QDCtJiWPNw6ZfSw==
X-Gm-Gg: AYBFou3C7mcO2lrNJtt1bCctA3Fa2lOSJtY/vPJcWoDgdWFMrqBI13lMXSKfSsZQK76
	uMG8Gdfb/OcVWsuYCU6R5FrcPMW0Dlu9OlVc2Vj5k8wQuCq3Bl0OimifcSj12Munygd/Pluz8t6
	EjVaOnQYZRkqOmrhQ0bSKpAbt+6nliNNPB7KZdeiz0KhRCsjYb28ryE/Lfo6ZPqBYvm4skPhqmH
	UfhSsFYXw8BmhGewDCQ9a/epl5WI2BepvEtTUEZuNwgGMut/YPdBl8or+VTeHavEU+qu8RPbWhP
	dAGz1GBUiJQi06hrtpTrJUxy7KfxNe/ENuKOmRwTKlsFs+3q/EzqfAL87HofjR9VTiwO6KdPUvH
	pRqYH4zeo23qGIPDI9/aJHy6fSQ93nLtGnn9HIsE9hYYqGHTflkuEhzJceFldGk/6AbgG5dt/
X-Received: by 2002:a05:6a00:4c98:b0:881:8784:95ca with SMTP id d2e1a72fcca58-897c76e1767mr1419932b3a.33.1791540944866;
        Fri, 09 Oct 2026 03:15:44 -0700 (PDT)
X-Received: by 2002:a05:6a00:4c98:b0:881:8784:95ca with SMTP id d2e1a72fcca58-897c76e1767mr1419912b3a.33.1791540944395;
        Fri, 09 Oct 2026 03:15:44 -0700 (PDT)
Received: from [10.133.33.26] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3107398sm705736b3a.17.2026.10.09.03.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 03:15:44 -0700 (PDT)
Message-ID: <e7181ed6-e14d-4fcd-a834-1ad07011b8d9@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 18:15:41 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: ath12k: make external IRQ control idempotent
To: Nikolai Semendiaev <agent00791@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org, wabsie@gmail.com
References: <cover.1791408913.git.agent00791@gmail.com>
 <ccca0d5d087b862c3b41ab4d3c5849ca0dc2d32b.1791408913.git.agent00791@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <ccca0d5d087b862c3b41ab4d3c5849ca0dc2d32b.1791408913.git.agent00791@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=E+1YNqdl c=1 sm=1 tr=0 ts=6ac8bed1 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=HjfokuTOBCbMWJCBPCEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: 39e8xsC8PKfjaxNpR4xm1Ym75iGihDqm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA0MCBTYWx0ZWRfX+tuICiiQko3x
 ccQHzgOnxRHbB5dDGH3dvXKVNQFzEnP7016Rus2BNkYqATlQrDTJ7NzAvtlnsWwIUJ1e9mn5Dj6
 hA5nQ48hiEjZi7YCxRaiwcfHA1G82PK28bySP64toOqv+r5ipaBpYwFzED+8K9nnL0MdyUSdFdO
 CXtLlhmwdkQ42tbgqnhAq8vWIMABJHp2erm6Uh19LnJhURsRhFN5IuuUws9JAbarE3L/QhEehkN
 FYgsMnPJIyMlkIoZzaz35uiU47MAEMSxQw5ninQkcgeSzkPxcvLzZa8cF5KUupUOtpY2EorE9LW
 nNs03brxTfwnbUmL1oo1FYJJBQlUsnyz0Q7OTHOpoEiF12BzDrb9Q4QKfvdXJeH00igSlKmzyD8
 6awzqGjKRFwL0Ov8u5g7u0yalvH0YnnAsMYx2V8WEtPGypoJqjdewoocCtOp7nS5MKmjSoiHgDs
 SQC1hZtpdPJpKk86dOg==
X-Proofpoint-ORIG-GUID: 39e8xsC8PKfjaxNpR4xm1Ym75iGihDqm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA0MCBTYWx0ZWRfXxGorB/qMwPh0
 c8No2qmK1tcO8ugiCUAwQ5g4jKsafdHBj1iS2cDzEgksxudk+uMGqTUl5kh67avSdKe6FHxiXxn
 k0cUDvlF7NUp0lts5vqNN8cpUU9BCAs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090040



On 10/8/2026 5:38 AM, Nikolai Semendiaev wrote:
> The AHB external IRQ helpers change the hardware IRQ state even when
> NAPI is already in the requested state. PCI has a device-wide enabled
> bit guard, but also changes each group's IRQ state outside its NAPI
> state check.
> 
> Tie each group's hardware IRQ transition to its NAPI state transition.
> Mask IRQs before disabling NAPI and enable NAPI before unmasking IRQs.
> This permits an extra IRQ disable before crash-recovery RXDMA teardown
> without increasing the IRQ disable depth.
> 

first of all, did you see any issues with current code?

second, the idempotency predicate is bound to the per-group irq_grp->napi_enabled, which
answers "is NAPI poll enabled?", not "is the IRQ line enabled?", so semantically this is
not proper. PCI already has a semantically correct and atomic state bit for exactly this,
ATH12K_FLAG_EXT_IRQ_ENABLED, why not just use it? The current approach leaves two sources
of truth — per-group napi_enabled and device-level EXT_IRQ_ENABLED — that must stay
perfectly consistent, which is fragile. As for AHB, can we also use
ATH12K_FLAG_EXT_IRQ_ENABLED?

