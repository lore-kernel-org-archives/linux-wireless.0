Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7CA257845
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792162070; cv=none; b=T3xJiJE1JUt9AEzXC85jf8ilY6GzqxvNRdFTjJ0VI68o8zcuwh6X97t+VM04dFAInPQgu87LnN9JRAv3mfiw3G1VOQ2Eke0x3E7XNDUGQCq2sLGFefb5vF3+7KXuQR6LyqOdUosnpOxVg0PQIoslicUayCiZWumuHz/LAOPz58c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792162070; c=relaxed/simple;
	bh=zJykPjNNt/Qv89uetzsGR/WVnuA6XWAGLYSuqrN/iz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqWMo8ZG8KwXnFY2q0B9PzeduRS+JrFjhcbu+iCou+U+5ssFdo7DCnnLO23RyAcG6v6HqUc5XeQ2CFhAtG1n03vWp48m12fjWCnx7QKTAauC8f2aihaDM8/lp0AJzt48utFst/mhQz6O9KMTmXMbkgtn1lLc72U24RtzEz602Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JNYyJN1x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hzavLcIq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JNYyJN1x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hzavLcIq"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE6Ek03006511
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 14:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KGl0xn96Tc2EEaoKMCvnPTGqKsWYtdwEFfVL1zKeloY=; b=JNYyJN1xbbTUsV4B
	omIpO2ajXQbmKYVPNe3eleOKNePbhfgE724k7TNqaBhVJ++JJY1hJy8WGS8YrsxP
	JOFbyPbEYmxyhgmrjs/vZDhDUvIu7JlIV3ywaKkxl3mBPMsIaD5FYScGMx0IZqLr
	suQBOayj9rfFKYLzAjOMgA+Z8dFxX8J6rmRi6k8vj9l/CkPr9bG5eoCCUqRcvO4c
	YQ23K5jrI0zWi6wyKG+JESLeWReD0i9dWRt1oL7IowkqGBt7fNY6kdy+qm9C8ZQH
	d/mCO3FjzjoxMRUAcIqBV32/+mTuis0IP9vYCtaV/fZlfA96tOIbzulx5V/96WvV
	06xb1Q==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3sa46x2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 14:47:48 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c3c370b17so8321400eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792162067; x=1792766867; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KGl0xn96Tc2EEaoKMCvnPTGqKsWYtdwEFfVL1zKeloY=;
        b=hzavLcIqOAXt4CqYUg4wDbrp2rciIbM+hM+DZhtew9grOYDR07QFQXqvt/UmkaGDXd
         Fs6k6Hba4wUyG5buOmAEGVBx53tNw6WRcNcbwX1Rn6EJbNST/thdOFoJa28gEiLg4U0R
         6CXFUXkttxwGMFgdApxWdf210kpFO6iJry2+z5iI6+5xObi8q+eRIAKpkGZ4qlOl8m59
         hqilFnig9KOodwGT3E0tmvfP/268w4+k1C54pp9Gf4hApyL641+xpZtB8bMA9Xfd+n5m
         85Afx51jX6MC+vihqpJk4gR2SHzE2fEahMZ7TGoShWgLLvDrS7XA2Jnty0GDrfwJKbSh
         cqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792162067; x=1792766867;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KGl0xn96Tc2EEaoKMCvnPTGqKsWYtdwEFfVL1zKeloY=;
        b=xvI1QVxE0z+aV8G/1+VryDjSKkKNVnlhxuPVrusP3TDq0ffi9fRed8xN6ldbNcOfv1
         1jOx4LgNtqL+X2c/jAETME5MrD8q81QQYdDfD6jauPNQif7zlYKi3UkIPad0Fz+QM5wC
         LqPIYkp76CyTydrtIzCBpKokAtPF0p3cU3Jy6VvkxIYX5lkctxSwqhYxyNGJpOfy4ejO
         92PN7lnXgW983U17Dyuw2xWxFe4l0rnxvTJpW1BI/hOpmicUbKLnFwgVWhlTWMQ76z7o
         qweywOJq4OrohMFmVv3Et54Pa6/V+89KyM2U01aTQeFAXkCvLLVRvSyzq+gOjaKEudFq
         MHeQ==
X-Gm-Message-State: AFq9FYJTlXWq0cFxUaao6SY0wqDB5jHmJwj8BR96OJuOrExGSI7T5vIa
	E0+maCb46gsjQFckrZ5Pfyu2FK8n40A5EjaY9q1b2b62wN3q/fD2G5oAEQgAlY4WM8IOhGGTmW6
	zZMTSYpUD1JUv3kbs9o2h18at3OOTr0l8HzP67oEoAHo+OQfibR/gmgkUj/8K63gUN79uHY7Xd9
	FK2A==
X-Gm-Gg: AYBFou39iM48J3qBd5cGcF/jUHeDQX+1kTjbaEE8kx0vld2lfFkAKLyzohLdH/7aY9m
	c67SWnAMQupmde22wdnL/ZteRchFPIE78Wr1YndJEldmOqLhOgKBYHp7yJl4uAsBKiKvI8AM/HG
	NgkWEe6p8gJyM8BQhB2wCi5jWrtWAEk7jLi1z2MnvCaETLj5gDhcvE6BEkhghldPAMhenpddWbH
	JM+WHIlW/www9Sk6LYwhZzLsju1bDl39cwOunbltPXs+hUQnHAjnuDn6GsJfjQQRRA78qIcfYSz
	3hmCTVYKJvYUoiSj72fCZLdbBFcPyqqCAAolwf6a4vntuHYTdZlGtiaf64Es5IL7K48fRo0Ivx1
	7GsHy9x5e2XooKxEvwaeE/x0NtovxZ+BqMGSP1LSTZM800NSWjMxHiZIPqa4=
X-Received: by 2002:a05:7301:4305:b0:35f:227b:f8bc with SMTP id 5a478bee46e88-361a1465355mr44211eec.11.1792162067058;
        Fri, 16 Oct 2026 07:47:47 -0700 (PDT)
X-Received: by 2002:a05:7301:4305:b0:35f:227b:f8bc with SMTP id 5a478bee46e88-361a1465355mr44160eec.11.1792162065731;
        Fri, 16 Oct 2026 07:47:45 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608297f4f7sm7670706eec.23.2026.10.16.07.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 07:47:45 -0700 (PDT)
Message-ID: <5495071c-8255-4ff4-80d7-9d9f221935c5@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 07:47:44 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1OCBTYWx0ZWRfXy5qrCoMFckVt
 hwOAlwYwm9upjq5oT9dXfLGjuHH370ZW01D3OTgonTPOg3eNp/yPvQ2uE3vFWBZ03YK5XvfUeBm
 kN4oDJujJiL7SNZE7KESojhAefdqvAI=
X-Proofpoint-ORIG-GUID: pfUXQcUROlCkgY3GEOSpsg_g50MI7gYV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1OCBTYWx0ZWRfX5Eo68rqp9sZT
 O0k6XGTb5CWuvlMDiDxzPED8/9gMTCq5K0v2XExztD8AG09/vCqrRu0lfJfyeRU1ZDr76C1R9sn
 1VobFHZMqy2RsoeQILN16BIB6xMbLAX0emPW8vHAUNiQZOBYD4oxuDEQfdPTDAfC1aAODfz7ZqI
 IXAywRI/fv0qUyor4dmOxDaPl9eGnLPQsluzItcfDPJBptsNsM8mxnyL7rwsNdFe7M+Sdf29/wh
 OxEjxYIUKzJ0Y7vHdXSj/VwWtzItcoigD+yBQV2jrdZ8eAiyFoNACD/SK4HwFc2DXWW0VHF1uzh
 azCSwW2ZlJRFZb16u/95T7Ra7Mteng8HSuZ6K0O4ZPpqR7PS7QXDU6apJR+CoeAYH/LSED3Rw9g
 pQhvofqN6bBoAckzGQ7NF2Xbb2vOdrFAqBkg3Ac/ijgpyB2JIOES1K3M/7hp7MbQSATujukbgIT
 bJlBaNMS+mC9ha1YIMg==
X-Proofpoint-GUID: pfUXQcUROlCkgY3GEOSpsg_g50MI7gYV
X-Authority-Analysis: v=2.4 cv=AN0XGc5Z c=1 sm=1 tr=0 ts=6ad23914 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=KqLv8SHy1QZmO2OOx6gA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160058

On 9/25/2026 5:26 AM, Kang Yang wrote:
> @@ -2536,8 +2537,11 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
>  	if (!atomic_read(&ar->pending_recovery))
>  		return;
>  
> -	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ))
> +	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ)) {
> +		queue_delayed_work(ar->workqueue_aux, &ar->recovery_check_work,
> +				   ATH10K_RECOVERY_TIMEOUT_HZ);
>  		return;
> +	}

Even with the help of two different review agents I don't understand the above
logic. Under what condition do you expect the above test to succeed? And
if/when it does succeed, why not delay for just the time left between jiffies
and recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ?

Or as one agent writes:
The early re-arm path is only reachable on the first monitor firing, at the
strict time_after() boundary. Re-arming for a full
ATH10K_RECOVERY_TIMEOUT_HZ there creates timing-dependent recovery behavior:
a worker that runs exactly on the expiry jiffy delays failure accounting by
another 5s, while one that runs a jiffy later accounts immediately. Use
time_after_eq()/remove the branch, or rearm only for the remaining time/1
jiffy if early execution is genuinely possible.

/jeff
