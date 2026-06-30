Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C4C40D564
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782822997; cv=none; b=Hxk8lE4Gy6FzzRXM8TKZBd0B2+etFYiqsVMqPACzYGFY56NapugpUNcROj09ZThigTZfx4JK8VznOpbrS+hyvRsxsCTvHQzDbiG6SF2RukImxJ9HBHESu7cGFfyMD4HSF6wjr2TmZHimDjkMnYauToswDdPoPTgTgICGU3Aa8Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782822997; c=relaxed/simple;
	bh=xalr14ue42EEz8a0KF+uv2BCteqC/Z7u/YTLcm6EW80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAufiFNes7xXG2DYa1Q2amDtUDGOOK+04Kh3QrKWCqOVNlBuheQw9tF3E6G80hdydIh7KOGtBnR4IGduL+I4IqMLCkZ7CVJHoGaof/17FfuO7zcUBcvYXifLCOM1+9fC+pa+5xTA3fYn5q3c9J6nNzbUq7D/ltT5xm5gVM+Iv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hMAv06XB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CyuOJQ8a; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hMAv06XB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CyuOJQ8a"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U9muYO1522287
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 12:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hWECIwdx2FjYu4F2Dv37YsQcOFv1h/HrdIPZgZxYiUo=; b=hMAv06XB7kVL6dKY
	+mHGw3jLF/V8VbrZUImQfj2Obz1kqidz2H33ovgOc19u+mb+yDLaOpPN/kUCihqJ
	VxyDFRhHHF3LE+BMpwV25kokDuysV/+xRDcxCR/nksSgx/Y98VucDYD/N4RQvqAS
	RfzOiO2B+ckua6pWwG5ZmOxuB/BsGWc4mZ8/uTlRsGQW8OZvq0FVIp5Rwvm2/qnM
	rHSsXx4FPnD7merqI3IYjqYhb4n5YQSq2ebVHHhxuIgh4ogpK92nyJAxaWQOyjrY
	yPhPlQTtcEYNELxEP7xiMOsLVXEo0PekJnEHp1ItAwYxkBJailhxbT8YtECLlLUg
	7O5slQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3yw93cau-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 12:36:35 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e57e56ce9so22541785a.3
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 05:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782822995; x=1783427795; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hWECIwdx2FjYu4F2Dv37YsQcOFv1h/HrdIPZgZxYiUo=;
        b=CyuOJQ8aAG8xUVeyvM3TPGSI4qTUS9FXv9stfk8bBFZGV1MQORxD7ofxwlowYGd+VC
         7v3o91fY8mlC7ZL1jyPj+JjnoDwj7yaBeg55nZHPM6RptrMMGTXm8YNRlkmddvP0d7Zl
         OSMy19AdvsL2kYc5wBfOhgjw6N9KCP3yqdE+qkAXc/o6hP+JYI3lZY+Lw6BlKnQCts/B
         BTwvPo7wPAQ5FQl8cvPfPvIbWqCLt6hioKVxKAltV79DXQ1VvxmerrwxwMeh+7FqgEpd
         q6wZMQ2D9MCBJxpXXEYmtUbYW+y5LLISRnjV7VV7/Cb2sssmm6oxm0RkKo3LA/5Tkmdf
         8+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782822995; x=1783427795;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hWECIwdx2FjYu4F2Dv37YsQcOFv1h/HrdIPZgZxYiUo=;
        b=UW2hZYhwZk6RyiJvjNbnCP98EKLT688lbVpxSB6l323YDdiECyHgNE+3jN9r7bNPUS
         QOJi9dZoFVGvJVLIhNMK/Na7pPE4G+hCRCeImxOFZawq+0jzAhbUYE9K64yJ8Y7I/h/J
         aa6RG8sncNM1ieILE0Rpkg4O1bBH+fzlENGw1V5s5cIylf78J/31HKqbDHm03R5PTthl
         zoGTah53y2onfkALk/1iEfyDyWb9Mhy1FBOhabgBipGNIwII/F9zEwP7+Khh+LCg+ux/
         OtkHvMeqDgRPJ+jC3E6SEIwOtAjt+6UWzkGgS06fB52hLTWNzAKbBjRKJUYB2jNqwhkl
         qO0A==
X-Forwarded-Encrypted: i=1; AFNElJ8oGus9C/i3bVAckTFKILMpYPUnSipsJJJ3f3E1ImGhX10itRZ9VwQ9DNkaGBOcEcycOtC3Kz5qTVVfVMde9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFUms/gfCjcZ9YwczCPb6um2SbbeXNvGGW18Go5yIfS8LKU/ud
	FJQ7p0l3oxFZQT0L9H7AC22KYQDTc2Cd7mKJBKcHyj1026YJ9aam//DLD85FRD1DPAFnMmm4ZRe
	X3Hv5NeXKC6/STaT8Y1kl+EHkrfHDz/OINUtVYxip44eIa6asFq3L/3V0la7DDwPv3CcSXg==
X-Gm-Gg: AfdE7ckB27D4Uvvb2xxBS1coCWExqGtBHBfZ5+9nBfl9j77LXHpIdc4/S4qbzXvZn+i
	9GNEqabYHYIjckuepbQCRBC/bjJnqGzj20fzb8YYaKWwGTMwAoavHcbnT+iBhN4/B1g2e+0kiDl
	tMO+T8Mo/PdwpX+ZpPq6BmtlwDMx8+W5qp48bbjyIj2GI4e/l1uoM7hRaTVOFMDQfoG/iDyyZU8
	BKi8WeMdSyrsM9VfzrZCRKMLkAhkXECXXkvLhFSuifTy85bFbqsAFfln5HNu66nH5gmvj2G8epg
	KlH+pgKHkGQInvjsZuwIJ0+nZnwmlVPsC1TdRIhJ7n2Z3hgt/6USVXw7k+JbQetFH+ZDPYTUwDg
	/LKCGQHZ6jTiBFYW7isVSz1hCqEcKN7GYmy0=
X-Received: by 2002:a05:620a:2a13:b0:92b:14bc:7936 with SMTP id af79cd13be357-92e6247af35mr377073785a.1.1782822994713;
        Tue, 30 Jun 2026 05:36:34 -0700 (PDT)
X-Received: by 2002:a05:620a:2a13:b0:92b:14bc:7936 with SMTP id af79cd13be357-92e6247af35mr377067885a.1.1782822994089;
        Tue, 30 Jun 2026 05:36:34 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1288f48b35sm115852066b.46.2026.06.30.05.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 05:36:33 -0700 (PDT)
Message-ID: <6ea161a2-d959-4028-8aec-175b73df18ea@oss.qualcomm.com>
Date: Tue, 30 Jun 2026 14:36:28 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/14] remoteproc: qcom_wcnss: Switch to generic PAS TZ
 APIs
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
 <20260626133440.692849-7-sumit.garg@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260626133440.692849-7-sumit.garg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDExNiBTYWx0ZWRfXwV3R6sYDGI2H
 wUM6+bk89OqK3irn62wnyvV4BC6Nwb13/p14rlLMgWDW8l06FOgTMEKF0Wumdy7S7LtcUpQM5iK
 eRWvuHlG7Vw7HTPqQDcIiqstkRmfk7o=
X-Authority-Analysis: v=2.4 cv=KfDidwYD c=1 sm=1 tr=0 ts=6a43b853 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=jx0KCs2Px1p7SxVd6dwA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: Q-u0Y3959c6pdn09e69WpUWvARbfBFOf
X-Proofpoint-ORIG-GUID: Q-u0Y3959c6pdn09e69WpUWvARbfBFOf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDExNiBTYWx0ZWRfX9j91ub8/f2rf
 LgWC43nhWhB1DoQDZzW+YNzrJ432kJRExuX8NAh9DHf1PkvlqedCQcbW6ZzWkNOCzVBYylDkv21
 B1hLX8HuFJMChts7Lu9nzcmdavTRdD+qP+IHILuWjPCkMaOYWlGDvztoxda+bCgLYwrmzQMlDz0
 BFbXUJXmtkrqXhTV+q/EMKKoGuZp1DRsX4itwqYBxOXidC2iog/2dFY7OW1ri3cN4lyq7KDQYWL
 oq/boIhBEEb2LbhSzJFvOcypvnTVqwvpKnWBKv7do+Qr6LSRVdvwdJfCFz1C0Vjkmv2uwhyPp+m
 vmFRbupN+rgNGSOPpfHcVl1wNb1pochXICDU6+VSE2CA88tTdmD3yc2E+9l8VbRWW4D3Ck/GVCd
 bsPzyLlpV3fCmqQpf1JoFyBSBbUzzZydlvK3PzQsw+srlRwaVJC+uV4BBDTnN5j+JqXEp5anak6
 aVNw46VaJ08956M7Hrw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300116

On 6/26/26 3:34 PM, Sumit Garg wrote:
> From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> 
> Switch qcom_wcnss client driver over to generic PAS TZ APIs. Generic PAS
> TZ service allows to support multiple TZ implementation backends like QTEE
> based SCM PAS service, OP-TEE based PAS service and any further future TZ
> backend service.
> 
> Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
> Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
