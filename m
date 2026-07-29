Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD104052CC
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785348691; cv=none; b=da3Kv8SyeCW6mDohniNNlysMmhw6IthAb6wVOgK9QSAJCBEA+DbgfI/jLF4BjyY3INPOQCK6MhuNo2QCMbc4MdEd0lkMx8tpo9beONP8ZLuOZ13lffy2LSnbHSSzMDhkTXixc9Ebyu7nrwS4qA2GczqNKMZXgb/R1E7MK05mJIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785348691; c=relaxed/simple;
	bh=J1YdDOLjvhqgPoiYF88zTnwSmsdQaX2EcyRup2NU+yM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BLliDDiR7sMCjglyAmeHsbrv3pj4ct0uCT2OkXvg/EtW/Zba90pLCRxynSgEw8DItsFMsn2xIi3ZjAskT+SFJVVcewlS/6V5Oi6pf+9UtQngokWhdnu2HaGXI7fRzzPVRXYvIfp+vvbkhG3kS6RxLS0l3WqKPw2uyp9LmtR8Xl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SQN/f4cX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fuX18Dz+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SQN/f4cX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fuX18Dz+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TFFdnj2092386
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	J1YdDOLjvhqgPoiYF88zTnwSmsdQaX2EcyRup2NU+yM=; b=SQN/f4cXddpgRctD
	6W3VavE99c2kl/qVLjwCiEMuxMtDNLGHJFmYuNZLlaOj0TZZE3WdRhnlJBxoi6JU
	HVpKiLXPSrifJz941oYEorDFf67qXEF6y+Z7HIjTY5Xysb54aOKHMqt5j1+G2x1U
	HzeBK4YrBEm6Rjm4Aa0Fijhd3xN3ekN8jSRJHzZfO1hKCsBiVMN8sR6ZE3hfujG3
	wLk2HBJ9fwRRCXcrm7vyHLUEtk78h3tejkWSMJ9tJM2UHqE5TXIhpZjdhVfQcGlK
	2TuktRA2oRTqN4mUcmQdHeANoKqYt7ssLUYPcDEAsp80UILntivxFg1USBoQsu9E
	El/LMA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqm0fh2jr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:11:26 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cccfa32670so13681715ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 11:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785348686; x=1785953486; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J1YdDOLjvhqgPoiYF88zTnwSmsdQaX2EcyRup2NU+yM=;
        b=fuX18Dz+6Ba8BoD3pFVVrE0MeDJ16vzMVW5IcoLATnDtmQWeza/FJfeTdwwd62L193
         QDeW5FTenpANgO3bVKfl4uD9ufL6eyY5jfXcYQSssF5o12yaAmWCPf3jEe9zT/a1Di1X
         vbm+BBIGbLEIfA2FAO6xnattRHwGm1vryM7riT/EzdDp7V9xOsVQoiwVWBw3I5smObW9
         KdGr6VswHC1oMayyEZUSei4PBv+G4EJ9pVDlIeU4VatRb2wC1pTFTcml1WWuKFA1GxNj
         8KKq1hi2qW/lYvAWUe2DWYHjdQGjXE7lDmMQc4qs9qQSIsZPW4TCaNZqVO/TFsrBjMTC
         4FqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785348686; x=1785953486;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J1YdDOLjvhqgPoiYF88zTnwSmsdQaX2EcyRup2NU+yM=;
        b=T++1HYHLF/X2bHQLfVllbmMTOK4+QqTEJcuVGoVo5XHAoxNurfiMKHXYVFzvJ0E4yj
         NOR2deoR3W6nLhAkSQJ1/EsH7PIIoCgPG35vl3FVpesYLjwfd0XinR/amvt6HTnZGmI5
         j8nOWUcea+C1l1ZCuSuQLxMEuy0flLjUv4xMYRAdVeZkf0swgrTWx8ekEWS2eLiuaCn8
         tG3a1SoxKtjiBvCXHpuOxyVHKgAxo5HvOLXvqaDqQ9Klv4QmW3W//XkC8oOcjwnohOb3
         ngaEoF6S/xCrefD/N2eYHLoedm77QxCUMVPZ740N0wZ+KqSl6RYlMHR+MQgjsT9ZrgnP
         jicA==
X-Gm-Message-State: AOJu0YwBChuOl2lq7FIxpqveVvs1QtuTC0+Z0j6tXhHVaP9ILttJQyD/
	tMYahdXwlu8Uw1nN5QXJYYpPUFg8ktfFV9Hb/peDQsyWhZEHVfxRqONiZ4jNOsO0Fv0Ya8K+AzF
	y22n2i9IH9vN4BWj3ktEkYBRv1B1SupGup3uaXUXPtejWImBE2g6+nsS+ldgcqqoewNBIeg==
X-Gm-Gg: AR+sD10MEfpY8/VJaixJL8mx/PIfqdOuO9kX3nRP+SqLYUorEvPFG1CT8zmuLZ8/iA7
	Kp7+K52yMfxhbnB/482//IqWe4qLa+/SyIt/ZGPfksq/X6ijFgGvGFPXzW7nT9tLnnqO3fDz/Qn
	uQxOPWIqn9SknmidPMkMtEfW5geGx/Ks7Q/QQzP8TiIpEgkFh+kM7bbPHocdXQB9cFVt0ggHYdl
	MQo1s5BFvhdF/iZn1ZnTu5yfiON0Hn059Z6ni/6aaZaoUIc/A2IT0+tz7KVNo099ktYlagRkFFy
	PpEKcf6Qt8fLtduE4/jDbMTcwE0OWWlLEBRZ52Wl0ZXRZRVkr1XEBWzONqkT3hYMaQ3KtvFOoGI
	+m4hPmQZVMqr0h4N3Be7mR10k6/xGwZKAyiSU3FQVvJ7hkbSRCdRcCH/If51V
X-Received: by 2002:a17:903:37c5:b0:2ca:e62c:9e96 with SMTP id d9443c01a7336-2d015b0021bmr83034465ad.5.1785348685729;
        Wed, 29 Jul 2026 11:11:25 -0700 (PDT)
X-Received: by 2002:a17:903:37c5:b0:2ca:e62c:9e96 with SMTP id d9443c01a7336-2d015b0021bmr83034165ad.5.1785348685262;
        Wed, 29 Jul 2026 11:11:25 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b1246dsm11149180eec.2.2026.07.29.11.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 11:11:24 -0700 (PDT)
Message-ID: <41a1de7c-5366-479f-a1f9-171d2c0fead7@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 11:11:23 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath11k: reset ar->num_station on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260729080932.3462066-1-nico.escande@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260729080932.3462066-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: baOLl7yNUNAaqMy3KmGIgzlJoZ3CzlUU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDE0MCBTYWx0ZWRfX3niPaXGFf+Bm
 RqwUIZcsEw4NjKCcNlLVujlPM7hhnHxtVmrnRTirONdmzZ+QjICuA0VB4pk2KE5CfmZWcrXFfVT
 cVSym2A/MQ1m2HScPTSqduRxGidsI+8fFWT8nzHTMygDAi6mbrBTj+SFaErnil5LyaPMD6CbRYk
 f0uewAoxX/nJ10XSQg6ua/EgkhqQEB8+T8sKPAFXrI/lHPeANAX8QDhsIVhvlG9qivOfuFNOltf
 R/4YuFGp6vfHoBu1yvpWmDHt0EN7f89/ZotKMJa87b3+YmOpYefH+3a9nFqllP5l1KMqcJT4hGe
 EN4fvkWR4MoP1rNdJSLo1AFsuwjZ5wtY4St3C7tMCz/fYEm4Ar6P3D4bL7LLQkzjm8V6cO7tsrh
 cZXl3Vw2vng7x0BXTvKIWpntS6TD/08Nadd8a7I5FjP4nGU0tEECmFjkmqE0o7Q1m+UWalbEbp3
 A2YBoAcWNLW+mDusLJw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDE0MCBTYWx0ZWRfX+rS67SaBproD
 MwJsb5S51+Oh4rgebChaRsGzlKGtjfM0eZ0Mj8l2Uxb5jLwlKTSiyW9m1sZDt/3vcZeMFflr2Go
 nPLwu/zaksqPLT0pX63jr7aUrKVsHkk=
X-Authority-Analysis: v=2.4 cv=LvuiDHdc c=1 sm=1 tr=0 ts=6a6a424e cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=i2L5d_RL8Kv-G60V4MAA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: baOLl7yNUNAaqMy3KmGIgzlJoZ3CzlUU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290140

I'm guessing I should drop this in favor of the one sent to the ath11k list
