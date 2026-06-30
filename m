Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9813A40E8D9
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 12:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782823563; cv=none; b=kDIReeLx5a/HrQmy36rZgKONVi6cJb6PH1S1CkQ0BQHFHBJdj8PeU6lfWOKlvsZsrVGGvWNVSEVvt1ei9kuyk86mepoJYUJcs2wFd4vEwl5hjoZpC6Z01R5rnZ5e+Oo6f0DfyGm64f3DyROxL6OXElL6XydUg+BZ0N3EGo8Xuqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782823563; c=relaxed/simple;
	bh=chBZiGh7yrHmSBv8RUwYVeMHSTVTeDhaR08RhaJsvHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T6F8KAtm6zZ53JeKxKH2UR+RUrGCM2kE96S/ecr/70jbynjXHwcn2pwnstY2YPyO6KVv9mTQqI7+29h4ae0DOtlh9w19ol+CCxv9V4q2f5oVZmmgNTmGtGfbTJBoYOlKfZ5JGZZWL36lUR3BZIhhghqKT5xnsPdndipSZRLuDkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UT9LN4wv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OMntgcYH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UT9LN4wv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OMntgcYH"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U9n1N81573393
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 12:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pY1T4mB/1x/HK2e6EPQsvZx0ZxpL5KScVB8u3NbiQqk=; b=UT9LN4wvBVpM64j3
	F2jAsfAILiZjYRi/KlD2eQ0MOKeqL67WC5X0+CrsUEriaIWFUiaGoLlo+n3Pwl9J
	uHDa0/8eFWFat/YWYLfcEJwEd5QF6bX9Z4OwXSJPbGg0GoMUjJkAUkQYMeCuapko
	T5OrkD9h97gJvlQSqmdsZWKCDQzeVfYFjItUkRfQjt7L4093O0XaIj8fw+CsdQzC
	6IzFQuULY5XFAu2s+/EvblbwfMuHoMlkrDqXKEflaNf/oL5S1uzyQqnYyoqrWkwx
	yTqAI/l1hiSsDIEpN5kwtUvgfTLuPIyzfTdhrgxG+nHg7+1/Cl2Pv2f0ACbtuBXG
	VvR2uQ==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f4686289s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 12:46:01 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-7392d893428so165978137.2
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 05:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782823561; x=1783428361; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pY1T4mB/1x/HK2e6EPQsvZx0ZxpL5KScVB8u3NbiQqk=;
        b=OMntgcYH257QLHSh/HIJ+MQFm9qsxmm+XmK+Y1Iq6ecUdmdRl4MZ3YIczrzS3PjRAl
         nuPA4mDk7ypqSrDazuV9ooVrxfe000mGjsrLzycfo+mB3RY+HB4q9nQij/+7MdUj9EYi
         DLrtStZzR9y4Os0O2O743yF/Co305KNLT1ISNQkhatnLYHe9M5DE0ANeGd7l0KeYf9CL
         3fnCmc2ceLz411iWiVhw35irUmLGswTpGXWTAsYJouw8yevd/ew9gPhCZ6u+b14/vgd8
         mUxUmxLFpL/+4RPffLMX2grQQ5dgTt/3hniJzM4L+pCD3AZHhBhcXN7bt+SoSQy8A6nx
         aPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782823561; x=1783428361;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pY1T4mB/1x/HK2e6EPQsvZx0ZxpL5KScVB8u3NbiQqk=;
        b=H/9qbOVWuVeBAEPNq28kS2Pq8NP5zoXKrwqCYV+9ZGtH8y/9aaj2w8KFWOxw4cjysb
         PJofnz+GgJhnkuYD7+5vz65NN7CcTllRJftHCQ+W4JiekwamsOG/OX+55JT/ggP4tDSr
         Pgj/Y6t20nn5RX7U2t7gVXUX6xuxNEXkhI3VKd6n7vwUmYtRNNQSFRQLD3Xf2r7sOgvT
         C7J9KKbbnyjHqm8pp+TRG6+kSleYEJK8TaPM9zoSm/UCNURKmcEFBKJcwqVT2uvpLnHw
         XJ68eiGiZjCnUXSE6TNYFuvJYmAZYyAoco9To7YxOxKLQxjgDzr7PeWAurVru3ziiVNM
         2OwA==
X-Forwarded-Encrypted: i=1; AHgh+RrTpGpccrvVGGrAFLi7w1WsMzMslmAsADPU/1KpTnqObNmcbq9iB3x4AQ33d8NbxuYSY6YV7JIdD90wAZc1iw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ/4qYYnyCQhjoHTn9121LHpprlmSPRlwvotlJ+hrv7xx/zX6Y
	R7/5oLyacJx1I8rflj4hKK/sALPV+W8cn8T32Cgtejaex6ztltA6GblgEXkdPRzty2gYCYupTeM
	nwG6/j+bgaOu8KOLYAMBf8GIw5BKAxdGmzGHF5AKiirSRpORQzg56oYOGFNPt9ZW0jopI5Q==
X-Gm-Gg: AfdE7cnMNHra97gvtXUFqSyiGJk1OOVYuGQ/wsGnKq5QYTqIe14oCUsHkCCdKNMqIxd
	KICCOmwzdpsB/aG2LhuMyt2h233uJCN4TrwPGyRg46oUOtx5dGfV4iS1UzuyrM7JLWsRLJ3OTxD
	42R3sIhOONJt9cUnLKuJIrKT/a2sel4D/ds6G3XUndXlUtoK5774R7goCxZ+y8e/FF7Mt2dGcqS
	MCCqS26yB7JQKzgSe1uKFAP8aJRVvFFpEWOUrdFaCNOLAe5+5lop51RisA+aaBC0Mj7FQQspnEa
	VxrsQnLjNkPzOHeBmzXoCDemoc70DwWvStgxppLy5HS856X7AHrDl4KZqoltNdhxa+4UJzzIhJv
	DAHB2I8MI5uMcbbhtmOkgy6ZTYV4FyJXFCG4=
X-Received: by 2002:a05:6102:5802:b0:729:5cd5:8cc4 with SMTP id ada2fe7eead31-73a38839d2emr587889137.4.1782823560943;
        Tue, 30 Jun 2026 05:46:00 -0700 (PDT)
X-Received: by 2002:a05:6102:5802:b0:729:5cd5:8cc4 with SMTP id ada2fe7eead31-73a38839d2emr587855137.4.1782823560577;
        Tue, 30 Jun 2026 05:46:00 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6987c968400sm1131274a12.25.2026.06.30.05.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 05:45:59 -0700 (PDT)
Message-ID: <b14466a5-a064-4723-8ea0-98239cd50437@oss.qualcomm.com>
Date: Tue, 30 Jun 2026 14:45:54 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/14] firmware: qcom_scm: Remove SCM PAS wrappers
To: Sumit Garg <sumit.garg@kernel.org>, andersson@kernel.org
Cc: linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-remoteproc@vger.kernel.org,
        konradybcio@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run,
        akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jesszhan0024@gmail.com, marijn.suijten@somainline.org,
        airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
        bod@kernel.org, mchehab@kernel.org, elder@kernel.org,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jjohnson@kernel.org,
        mathieu.poirier@linaro.org, trilokkumar.soni@oss.qualcomm.com,
        mukesh.ojha@oss.qualcomm.com, pavan.kondeti@oss.qualcomm.com,
        jorge.ramirez@oss.qualcomm.com, tonyh@qti.qualcomm.com,
        vignesh.viswanathan@oss.qualcomm.com,
        srinivas.kandagatla@oss.qualcomm.com,
        amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
        op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
        skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
        Sumit Garg <sumit.garg@oss.qualcomm.com>
References: <20260626133440.692849-1-sumit.garg@kernel.org>
 <20260626133440.692849-14-sumit.garg@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260626133440.692849-14-sumit.garg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Zl7c6QyEVNRoTvgzfyhHhq2aeRcjKlRl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDExOCBTYWx0ZWRfX8aCsZrY7+QSR
 cVA+FFQiDHtQuIzMwxnSUsGbQsrsfs6K9rxSJnCHXuucfMbz5YsNyepq5wPilJ1fYqMeftrR7k9
 +/1fgHkVOqfNwkfvXR4hUNgdPaviilKesEKRKpwB04O1j8Mh/EakdRYARV2w33aDAGziODTll3s
 gicvRUtPeMsQdC1iLK9PzAH4UoYud86UrSFiCmwJ9guf3muBdrvWgjIW3ThZ406gXpBb2yRz5EM
 Ug5oWS8m2n3sFFbaEYvhz83Qf4J4n24GXk+7pd6YHheUc7ffnap5DuAkj+f13wdTi1OnlDct/P/
 4C3KHc7CoHymVMT3igYXqxFgC6Y8gRYBZuVQsxYXw6K/WwuDuz48nyiHURGod1CbgAJNWHbiQMV
 Z4DIHGnvJ9af1Ni6vAlZfux6dfcfJDhupXtwTodgTqgcofJVuftuf/YjAZUI9K9twMQwii0aNMA
 4ldkgA1d6B5DGeB3ICg==
X-Proofpoint-GUID: Zl7c6QyEVNRoTvgzfyhHhq2aeRcjKlRl
X-Authority-Analysis: v=2.4 cv=FbcHAp+6 c=1 sm=1 tr=0 ts=6a43ba89 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=n1VOVlC_Xzu4QXtT9DgA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDExOCBTYWx0ZWRfX6T71RxQC58Op
 pVtemrnTdZLQYA14qjzKH7ethi3nZLXrw2B9zeMfYmluSu0f+Sapmjf7H4Q2FnsIqZNkQjhxhjf
 9gJa4UGOFVcJdJmT4xcN/Tp0jEe5R7c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300118

On 6/26/26 3:34 PM, Sumit Garg wrote:
> From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> 
> Now since all the Qcom SCM client drivers have been migrated over to
> generic PAS TZ service, let's drop the exported SCM PAS wrappers.
> 
> Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
> Tested-by: Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com> # IPQ9650
> Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
