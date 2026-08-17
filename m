Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E978A3C4171
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786957021; cv=none; b=fFTg7C9G6K2Z/ZuL57BdObkMIhm4SsctCaesbMqdscOtudUerc9MbzA2ASk/2XyKgbvzcoCO1LRcE4EtiCCi972IjrWgSvvyyJ5WjMPQynWzbYzYmiqmBG8lHyqtZ17zW7QlQIdtkhlhCDJGzlAFl0ZQuOr1eYz7T7MZEHw+Cbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786957021; c=relaxed/simple;
	bh=chVjGrHi8hL8HNAXLsxf5LC2Xz/3cL5h8M1X7lFBoOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1U5J7lBUKF/jpAg0blXHqwEO/4p11m13c3s5qa43d0YsVZF4KMGy1m9GuscCRuUB0kbB3Wk2wNH5QJYtvIE5XDJ80GMV0QvuQTZzLBU0Z4LOkJjHy0gr0rmBF8vfVmeMFUcDBGKiz3S4zw0jk6B7njtLtSdXJtcNnPCiPPd7BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ewkuABWT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fXq5S7zJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ewkuABWT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fXq5S7zJ"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67H8tugk2890891
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aDIikrNXALA9ripEZXovggm49pwZypGzDJlATaT0TMg=; b=ewkuABWTflNhPX87
	6fMRiZKezTyGNsZObxtxnmEZeoHT5ErVFZRjYO3RLfo3oU9ZJIBcrdBjmV1qatt6
	FvUGFX41945jfTUdqZ6aaVvBTw9VR+iGGjRCOh7GiPv/d8Qv0DeLPqLyBCDecWud
	a3OpFr1MXYkIVXUyl7ma47FJgU2cY4p4CUsrAy3h5uyj7htIB/QSFqcVhqxBBC26
	MFrzMTwhGGQ00cZKHctZ9RqzFB00YJq9WL4PW2VuatxM7ridAJoftDbhwhNJ8CO0
	VnKUhcKsZN1/WNKejR+136rHhaPnRdbib+mhFz0gVyYUXT2UNE2KPqw7T8dRdefd
	KTE03Q==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g3y7kr05g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:56:59 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1e777a15so8855651cf.2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 01:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786957018; x=1787561818; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aDIikrNXALA9ripEZXovggm49pwZypGzDJlATaT0TMg=;
        b=fXq5S7zJwaB+1s0gNEHmjocZ+amlmJV7B5b1OO2Z0YGTjE2JMEjspjrB5qewpa0GgO
         4PRwPAXFCseO9G8/WhP/dJMhaMgrjmA0hU7rnZgK4lSY7/+BTgLC4K42bmnSMOWCFIvQ
         QMKbQ/t35uQcjlojEA53qaiXXy01l34PUOLvGkp9hUdPX/kQ95MxJlR8U+opRGtft3eF
         j/Cn30bPofkiZgmDDj7eO51twpyxtCpvA/L8Mm/AYrl2PU9SUlLE14wjBzid5D1WHs/s
         rvI1TcLLUxFZCTlryc4q//BmOuk/6XRtEYEGjCV21mwmKWuH6ETlOIU0qosAil/vktoA
         tRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786957018; x=1787561818;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aDIikrNXALA9ripEZXovggm49pwZypGzDJlATaT0TMg=;
        b=PMCneBlfX9pjvoJP9VmZfmaEqnJNQZ4mCqAhfBeg1AaX4CZyS+oxpm/9Jt7BrI1V7d
         jkn5DCV9V0bFpsNmxCphQczqxvQIk9+2lwCc8MZRn28bjTk/3HKaYZm8H8JBmdcpWuLS
         5PMR+JATnUAiZA7lwMTih1S1pD68ajNG4r14yF1Spv/qFmyAL7JfX5XAQJ2kzWOcMz7R
         d3OZU4YZ8sWDZ7Zom0qPIZeB9WT1v10c+rSJg7kvy3JkfgcOxOiRkBK4jo4+82irfzNj
         H59i/PkNRFWdgsoGotkILyUw2qP3fxC9F5jEFrN3cg+gOLAXf91L2XB1Bd7wmB0lExzc
         WRSQ==
X-Forwarded-Encrypted: i=1; AHgh+RoahTepqDTrUVvXgUSgOAhkZaVFvn1ntOJ6/MqVzFyzYeU+XVo1WYRbi1vWdtUcbtUztwy4N1X/Tie8qybhaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo+OCtP9BkCucdqo0plpQ1GniP1fYLt8VVa21blfu0RyLg0FOS
	iqzEEt9wMed4V/88YgIomjlT/Kf94zRF132cWxNauUb39TFTX8QMCfCUgx+PrtSjEEOHt93XS6h
	bmESJcWfoD38hiZvIsB4KNOn7AsknMODQzcskTQfsa1XUyNj8KxEhbhfFjryJJxHQITbhkg==
X-Gm-Gg: AR+sD13qv8+HxWnVXRvQpOcZsuO5s9UHRbGtYRGo3doW9C+tSTT1inIBga3zD8bk40J
	rOeWos1sklbOFAvPrhadYmVNSrOT9t+us0YyHumhzcWZCJ0TvnEw4/HSvDTkEX4zjO3j37hxzst
	YmNLRWE1bhlCmmpxvBvfxucsCCgbzIeJQstkNtWyfl66UycoacB2XpmMvkchqu7XeQDfcAg1vJM
	YKjQchTiq3vb58Zyuf0nrVjWZiBBW981jocFFkdD9mmKQdYOR3EC10u7wycxpv3BocvVdIgRkZd
	UKw7Iynd9fgSIi5gnJjLnT6W943FZ6IClQj4SxaXnHDPCLOTyhFuG1d/7Ml+t+RnD08CKbaRfC2
	B0Iv3CcnXvBnmho608jnRsyhA
X-Received: by 2002:a05:622a:118f:b0:528:1ea6:eaee with SMTP id d75a77b69052e-52d852b4f2bmr159908901cf.1.1786957018210;
        Mon, 17 Aug 2026 01:56:58 -0700 (PDT)
X-Received: by 2002:a05:622a:118f:b0:528:1ea6:eaee with SMTP id d75a77b69052e-52d852b4f2bmr159908721cf.1.1786957017840;
        Mon, 17 Aug 2026 01:56:57 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217fe7c8dfsm25074266b.8.2026.08.17.01.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 01:56:57 -0700 (PDT)
Message-ID: <c6f35c66-a489-4404-bfd5-506174b49b53@oss.qualcomm.com>
Date: Mon, 17 Aug 2026 10:56:54 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] firmware: QCOM interfaces should depend on ARCH_QCOM
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>, Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linusw@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: d05h5rymSiQZoZGZuA9gx8hK7NjcfQDg
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA2NiBTYWx0ZWRfX5ZTwo3+zqJL+
 mWL6T+mET/ZBhIIYxEUgYKhcVVpe3NU/8R+gsukwDrO1dxNewZ7nJaVKypYBTIVtFGCOEoh9gLA
 6PCvOT2sQX+hE14e1YRpZjUEtkzq60A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA2NiBTYWx0ZWRfX0sqaK/B5Xsr3
 h4jr5Quxef0aT5iNOxb9lI81AZUhGeliHDR6EgqclnwzHdcnA7Fnt9REkGiHQ5CAUR9aJww6mKM
 M1X+acr1aXFvPEt3PpmmmHhblW9D46pLjMceGre68h3hGSDIwjmIbGfPJk1nAejVxDtF/XY+hnB
 nO1p6rw2gu1kCJUCQ+KQeO07XU6E5Fu7a790va53vgiNuTnbc0aI1IsPhyOba8qUYRKHS7V8bms
 E2zbxLEQzZuzOT0T80UkNfNe5A1uNnCVKjZYYRuNkWd6HCouWnZW2hk1NiMbbmAwuBsT55q8YAd
 aUuzgs1c6Hx1QGBpPBzu6DbMAffwhG0OU+EBHk17wT7k8QHjeQPOzlYh0UTC6fGIp4rgvo6ZsuT
 tj7hslxoHxsJc416H5Evzllw3cZeBPqBTQi9JNSt+Ebp8/DCzUcS4c3IvSI0jMtpxs1c66I0bjA
 K1JB6tWFtizFtMVlW0g==
X-Authority-Analysis: v=2.4 cv=HYEkiCE8 c=1 sm=1 tr=0 ts=6a82ccdb cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=3ImISe4MDvEodWLrb7UA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: d05h5rymSiQZoZGZuA9gx8hK7NjcfQDg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0
 spamscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170066

On 8/6/26 12:35 PM, Geert Uytterhoeven wrote:
> The various Qualcomm firmware interfaces are only present on Qualcomm
> systems.  Hence add dependencies on ARCH_QCOM, to prevent asking the
> user about them when configuring a kernel without Qualcomm SoC support.
> Make QCOM_PAS invisible instead, as it is already selected by its users
> when needed.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I wondered whether QCOM_SCM should be made invisible, too, as it seems
> to be selected by its users? But apparently commit 5c1a2975d23c51c0
> ("firmware: qcom_scm: Migrate to generic PAS service") in net-next/main
> and soc/for-next made it visible on purpose?

For some context, that commit was part of a series that introduced a
second back-end to the functions that previously only the QCOM_SCM
driver provided ("qcom proprietary TZ interface" vs "what TF-A is
going to provide"), and the author's intention was to make the
former possible to disable

Konrad
