Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D8B2877DA
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 02:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784514012; cv=none; b=IxDcb9uSIlbl6Tky5OIvY+nmwcW2ZB1JUzXnzCms0NanX6SEMEWES65mMvfOOB2Wy1Xn4VoN83G32xIiYtfbrsT4z5ufdMyB7b/d66lHsNFNvmpEuNeJgwrfpmPDY7AL4DJlz4PAVhgwIPFlVCUky6YWG5xMyk0tTjbTZ+v86fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784514012; c=relaxed/simple;
	bh=r02G33i1kr5LJXa62aRUqX6Y4MEoDKIwQv61lCt4Li0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R7E5Q2GxyfFrqaHstXksCBfoISZQSxNqfg86v7njbMUJSVeimLA2DfQKJ+O/6utxQ0Zk1Mz41Ca8knmeNRAANbfLVMqfoq/q7nh+gK2uwAEdr/PmYI7IoK3h3Wt41umMI0rvC5zUwpXBVuV+4kjf6T3WiWNPm5hvVMWbuHqTbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MoWD+ea/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qsdf/fO/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MoWD+ea/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qsdf/fO/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JNuM0A942429
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 02:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WwYCea8We6mdjWm+dC6kPkTmaclY2KKsawC/nEua+YM=; b=MoWD+ea/sFbiCg2X
	7GR8vHVuokwWB4yy/3OH9zhziJEkOK9Ft1l32QWhYabo1c0vcPJqAIqOl9kxJKqp
	uKZGHf29Q3l6vFg2sIf7lmcda7shqXnZ9/QQ2gFehvLLho06wKywqZkC3RPhMPIN
	ZZHRoUOT/QzzqR91rmBkcSX7j6PsF2lQZ1mFcvUtaAWMu+sb6vrJ3hybPGgwSHbZ
	xzPjtdHxWS6X/gjGw6MuEEzsk/BWC2m6V2LM5Akg64anM5RBAALwJ7717+yIO8ZW
	Y5697mrbNV7uWxgeCuq54js4Xk6tKIel8jm7WzhwTqNuWOAqJnbocBqUkWVPVx0t
	vNh8dw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2c6c0d1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 02:20:09 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccafc5e82cso86238865ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 19:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784514008; x=1785118808; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwYCea8We6mdjWm+dC6kPkTmaclY2KKsawC/nEua+YM=;
        b=Qsdf/fO/eky8OKwbH6d05DSm/li7QWJr5OQgHxNVdkOAtRczKNnxhBDZKunXU+3yML
         2IWI4gMiGnj93fN75gFJxPNnTuWiGcMfkIvIVMYm3SUupocQH+AVpFqAUqrZnmLCYFBR
         KVKu8rhU+HN+iPWGMAHXcjNdn3pmtPi8Vu2NvbQ4NNEEttB2jYfL0mSRnvn+HALdgPEr
         8PajybjkygW4p3G1jbxuc+g5ainXm4CgKzM22aAwKenfyoDfwVSrLQoWJ0KfLdLreGVO
         h2RJu8LNElIrrld9SjiVg7fvFf8tonOcpgjx+mut11qDi8F8/nleqAzM2A5em09ZcDXz
         DPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784514008; x=1785118808;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WwYCea8We6mdjWm+dC6kPkTmaclY2KKsawC/nEua+YM=;
        b=IcT0dOIYGixdJdvWv8A2IuTs3/sLAdPMK4LleuZSnR9y31etRY/Z0V38RAsaLnfThM
         kr67wEgIIvilJPAozEQxT1xm1AiQmKKE++sActQ7tjIfp/dB0AZHA8cHR+PD5p4JIstS
         0de5yLFtze2uIE9BSBa/HaWEkHy13yPDXyTSnw627Iei9gpe949R3QdHJjuGJ9ycql8w
         QMWNkzBKdYv3y8TXRW1X2P2gvuPYBTIaAR26lRmCvNIV528dL689M/reoWhh0EUvaW8w
         eqGJfjgpSchUr2PPF26lg7pGZG7RBcdNuoU3nOlGIVeJ7Z8+L/wBsiJEVFzlnJlhLU/l
         6U3g==
X-Forwarded-Encrypted: i=1; AHgh+RrnvJXLpnWV+tU7qcrCK63dcVNqo8EjMq8btuQt7J3owKjvjLDOYr+dK0DMUyWcAhl5UUoEoxdFarph7DaIyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRRxH9uv1you+xET8R9onJVoyKEOefMQ5J078kSq1LpoxhWGll
	x/v0ZvrJwvTQDh5w2P3JfOfbyI1UmN/uXGFy4xpHstsYdJjSpQXBssTrFULS2tThop/SNCAEWR0
	mcINQBPaHQIvRHgIbzp/+XGyaFcg5YP/cy2SkWgFHer9y1yESDVunHgKK6ci4goTCh0WO6w==
X-Gm-Gg: AfdE7cltrKi4nNGUnGPHc20u5jMbD3BE5nFEhtB+g6dUvMFiK3PZqC8KdL/FeF/esXX
	/OoJi8up6vXvrBGDOHD6xsNfKkZSoJ/vKKFepg6LWxCKCfU52Wt11xyk6UshdgG+Kk4tVzbDZtt
	TYASB/9SaEw7TTVN7ll7UcDleLsIA+qkGnhyzox2Aej5c5uhAdRts0RMOUxfS4rOj+xanQ8Yrys
	hZ2rWEqYQ7Ttbwa5pEhuGYpupkMaDtMxso2BGXpCxqdpj350YJ0GSCkh9EdhwF+e0csJ1FZrT2/
	IX5LSBldFWRwOl94rnZZ3cFl5xkZ+/3RGxqebUBzozqnB6B32z91eMIsP4bMUS/F+GdWTF1LrvY
	p3dQFEQU97QYsM18PUR9lztdKrtqVs0YdVajvQ599/udle2GGr6jLSbGbkZpBiFyzr10JL9wX
X-Received: by 2002:a17:903:3b85:b0:2cc:777f:d67c with SMTP id d9443c01a7336-2cf3488b0d2mr126545135ad.13.1784514008125;
        Sun, 19 Jul 2026 19:20:08 -0700 (PDT)
X-Received: by 2002:a17:903:3b85:b0:2cc:777f:d67c with SMTP id d9443c01a7336-2cf3488b0d2mr126544685ad.13.1784514007385;
        Sun, 19 Jul 2026 19:20:07 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344b1348sm48167765ad.18.2026.07.19.19.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 19:20:06 -0700 (PDT)
Message-ID: <7d76cc32-5022-48c1-b33d-f16521ab5b7a@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 10:20:02 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] wifi: ath11k/ath12k: release QMI handles on late
 init failures
To: Guangshuo Li <lgs201920130244@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
        Anilkumar Kolli <quic_akolli@quicinc.com>,
        Ganesh Sesetti <gseset@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20260718074026.3085688-1-lgs201920130244@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260718074026.3085688-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: dIANlHIcn2g6CZFAj4zGSH1T-ty93lC1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDAyMiBTYWx0ZWRfX3pLb7K24qRUE
 OxgXmD1XSseZYEUkjR/942JBcU0ElvZszvpK4KACkrgx8FqW7YoPZQmF2lv6yyF97MlMJiytGDv
 jcJYqVNeJ92QxIZBO9bhv7n/3khGYoIvf9piKH/SInXc3ydpcQ1Ccco/QpLJ9XEKjWTQOJqo9nm
 2Bp2k9DGo942OMN5noVcs+D7XuNy/Jw6LrbzW+CRwtDFkyBOj373/b22gKBB2THWX/8X6izzTxx
 i65nowvOEL9ZcpRHtdWAoETWpPvBiAXJN4rB639mzbz5MX2NEkPsCq7MHoPtKti9IENg7uBbkEc
 6fWE2PkI5xVgAYf2d/wK8gnpfn5s7Cv41Vx19f0mQziJosMhqCvQdplUr/Am0Eonf2igcQ0dox7
 z/7NK9BUzKDApVu3z3SzClGh0TSdMfS0s5zm0AV+Q2cWv0phEwN2IqgFlCY5K0MHBzv+Mf7zVc9
 3q/JvUGaF7gs5d+gzuQ==
X-Proofpoint-ORIG-GUID: dIANlHIcn2g6CZFAj4zGSH1T-ty93lC1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDAyMiBTYWx0ZWRfX4ANUrgDdhnmK
 d/d+H4NeZMwaRSMwaEW4tUT9Ldmc5E2Q7WFjpoLooIWEvLSdB2AujV9zLa6g22ctZODSLGAY/ZK
 vckppcHa63f+u9kDQ9sy+CTZaiw0N8Y=
X-Authority-Analysis: v=2.4 cv=CJQamxrD c=1 sm=1 tr=0 ts=6a5d85d9 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=9O-bytELmrVEQ99AJk0A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200022



On 7/18/2026 3:40 PM, Guangshuo Li wrote:
> This series fixes QMI handle leaks in the late initialization failure
> paths of ath11k and ath12k.
> 
> Both drivers initialize the QMI handle before allocating the QMI event
> workqueue and registering the service lookup. If either of these later
> steps fails, the initialized QMI handle is not released.
> 
> Patch 1 fixes the leak in ath11k.
> 
> Patch 2 fixes the leak in ath12k and sets ab->qmi.ab only after QMI
> service initialization completes successfully.
> 
> v3:
>   - Split the ath11k and ath12k changes into separate patches, as
>     requested by Jeff Johnson.
> 
> v2:
>   - Set ath12k ab->qmi.ab only after QMI service initialization succeeds,
>     as suggested by Baochen Qiang.
>   - Fix the same late initialization QMI handle leak in ath11k, as
>     suggested by Vasanthakumar Thiagarajan.
>   - Drop the Reviewed-by tag due to the code changes.
> 
> Guangshuo Li (2):
>   wifi: ath11k: release QMI handle on late init failures
>   wifi: ath12k: release QMI handle on late init failures
> 
>  drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++--
>  drivers/net/wireless/ath/ath12k/qmi.c | 13 ++++++++++---
>  2 files changed, 18 insertions(+), 5 deletions(-)
> 

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

