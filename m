Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89F1D5CFE
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785476572; cv=none; b=bSrTOOfyKSbhJweU7t0pyhFzG8f/f+/1IXaOJyt5wWIAo2zXaUZxORVWNEp/wTe1QUPGqOieZXWEyPH5eU2uQVYseey2fWihmw9GQSN2m1AibzO2a+oWtT1QsYKyLXAP8xGm3HWyBBcCdtRNFFf1e4vG0Ca/Sb5sq7a82HJRqNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785476572; c=relaxed/simple;
	bh=wGF26iFe9DZTXxFyj9SaDxHkxjgqkteQaAzW3ifNWtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V91vqSz89cK9tOZLpTF/4JkHKBPzXic4DX8bM+nrBkhrsYRvUBRFumXsIXSfpHjQ2UndvFKHcFWhGVKPk4RwQnd/LB6ZI20I78DG6LGuzP1IyJR46dGGN+6oAUgR1v0WpEfalY4Ja03NJTx7qTjyF+JACP/FPn1sEATMdT+4BgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R031ODRB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RGuu0Bxa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R031ODRB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RGuu0Bxa"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V4vGw33260028
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wGF26iFe9DZTXxFyj9SaDxHkxjgqkteQaAzW3ifNWtQ=; b=R031ODRBiW19w093
	T2lZi4ZkGigj/TIUrybNTspufoawfugdXFgcRbprnjwZkop9wSYvUqa6h9CGYoug
	IEw0FoDnXZqribCq8dhsQPjusLcg4YlJhRrGSU2qdp4BlU+qQGTn0wQ2d7OcB1nR
	X+c+h2ZlFp55V0lf1MS9ioPBQtoOIw/AgKxVwe/wt9qujRYjjUzSFGkXl1iwPjKS
	HedQL+ENMBZ/XEZLuZQg8n2r2yenhOoRQhQ+nx4JaZ122tF17dJPrZCOX00U140u
	H0c3Czs4j1MGCKGGdL/ZIxC6gv+rwQMJz0YPwc2HTurJRgSimoNLMzd1k4fTZuet
	Yk6MIw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frn0b0561-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:42:49 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8484f26852dso762895b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 22:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785476569; x=1786081369; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wGF26iFe9DZTXxFyj9SaDxHkxjgqkteQaAzW3ifNWtQ=;
        b=RGuu0Bxa4bxZHWoJAG4WO8EHhVk1ApXYBXRLRsjggkaM5l8U6zZmSC19YbaJICnFXp
         1o3eQJ+cq52nKfyFQNvPJwitCNGy60z6/rJIlpGZW8eTDtDJ4MITHKR+LmzdgSvoOqwR
         e3twXlse5r13VyAWWFN0u99PDQQmthiSXpbPwItFovPF57+iMkuRMrEvLhRC/LUhs0++
         3QXHCilI2j2mZsVG62UrE9TylbwKhxq4uvNXYKq3G72eROChPiIURkx4KTAEMqobfyl7
         5bE8Y6JGHdNO6JwQOWKhPYvA9Z2ca5RzOJHUvDg9j0eo8jDUBQrHTtKfX98OhNOcbkD1
         Ty6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785476569; x=1786081369;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wGF26iFe9DZTXxFyj9SaDxHkxjgqkteQaAzW3ifNWtQ=;
        b=Np4qWsKsS7uDaWBFnL2sANMVdoiPAwqhCvl67XwdJbnv07Cx5DC0e80iqV4tSH0057
         8zsiqL0DJeBk0jwnlczIFL65d5CVpIk+gRtc8czsVNH+cY/045Gs4zSs6WxVAY9saIev
         E0a4G2pIdjg6q22S47lAwZHGjBf7tVZS15vyb4o50P8112QNPB6HWvmXWxt6Z5jQMKD5
         RW4I0O+xRJAo1qSy8BJoLDzJ/YAvQuZxj/4Tv8qLq6W/TaKmp297FAE4HfYFao0OSk4y
         GzzlTCTiSWuuu1gNcScTjF0+L16S0ffWb7mZVnPA5hZGlhKYds+oUair4sKC6Ut4t8PD
         nOuQ==
X-Gm-Message-State: AOJu0YwuLmbrZZYKXrb9e/AowkWlfy/b7aGM9k5RFlfb6Gh2mTxSvb/a
	6dGn7T4KljcPlv32UX/msLMApzxCcam0fbaY7MCnuc7ArMwVd36DQdhqJ8cewxaQqqYU9oxfi+p
	KIQvculHxytaYuHpqF0eI3JenfSWRU/5xgrsUut+aK3Tmk2SkxKTcaAPJNtij60T0rkg80Q==
X-Gm-Gg: AR+sD11LxqpyyCrt8zZ+7VkdtgUBGVHl9p+h4vlpVvjjApwOCrOJmk8sCG8+AUjaytJ
	g8x6bPXKim/gc2vai+72oJZ5Z6plmDadW81lwl6hpJFO7xdEGMZjIBeoX1eR7MCQMEhOp1Ylmqd
	Y4Fg5BU9yZc823L1Pb2cLOJwx2qLUtyHJleytEY8x7lMXsv1F1zqM7lGdr4V6RgSwfccsqlWmNf
	iuCQhlsAHOT6uZGqEJ6KixrKMkKlyxsz7iVIJdZ7/9u1YyRrLi3Z6Z5h4CeaCdr2yymQxT/+PJQ
	AYKCCLWt0oKtkYEQe+SJN8E0CTud5T0IKvGTCNF0KfWetkvJvif7PLG5E9z/Px6aZAlwvBpY2GQ
	s+hylUlrgw9gXUh4sj/C579mvFQI1iZ1VO9tqhYOFvvBVO7/wynUJ/JlINr83UsKPSdPXgmu8vA
	==
X-Received: by 2002:a05:6a00:4f81:b0:848:6447:e0a6 with SMTP id d2e1a72fcca58-84ed6f5427fmr559300b3a.9.1785476568883;
        Thu, 30 Jul 2026 22:42:48 -0700 (PDT)
X-Received: by 2002:a05:6a00:4f81:b0:848:6447:e0a6 with SMTP id d2e1a72fcca58-84ed6f5427fmr559289b3a.9.1785476568447;
        Thu, 30 Jul 2026 22:42:48 -0700 (PDT)
Received: from [10.133.33.123] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ed5dac1ffsm290412b3a.36.2026.07.30.22.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 22:42:48 -0700 (PDT)
Message-ID: <2e0430ea-0370-4439-ab42-40cc24ff02d0@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 13:42:45 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current v2] wifi: ath11k: reset ar->num_station on
 hardware start
To: Nicolas Escande <nico.escande@gmail.com>, ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260730140306.133718-1-nico.escande@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730140306.133718-1-nico.escande@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAzNiBTYWx0ZWRfX02G9OBPzmw/g
 G2Gd79xWK2sWj8ALSju6hyFlapQQuzJiRVDR82ZtF9h5JdNogj5uHTt0uyoNwAyVAsVzmknNccE
 HYPNSoRGePYMUI9OTgsbAf/N3afHYlw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAzNiBTYWx0ZWRfX/xFdg+DQNCkx
 blEt6zWuWIRVngE88BJIjhjC/+IFoQgS+v9q2dONvfxJ9S2qkX7LgrB9Rf1uUq1Y3f0TUscENkU
 IV82pG9kxXfnMEl4iWqZECC2fOaJwlfjxggYxJOwe4CvRs+BChclmFUUxjyshMehBqE4VW4jX97
 S+wZx8mmopUZu+AcguuC3YtM+4GUcp9KaXXNGi50ZxJY7lxvS35uqShFAQ64KP42CwxrZ975ffD
 mEJB9EkmzEaz2MytYGvXhfyYe+ZXZVHcQBj5y+HUq0znvzh/u0CIJFHjvFOMvsS3SkHZkWPcFgx
 jXCf0JWLVYBC8a81gpwYJcNw2osVHqsugRRavGhSLAOp6McrhS0+hqmBRmkYQTdLq1/2LkbIAo4
 XKrhMt4W9cIfzf0si4Gq+/CZskzsraz9u11GYtN9WcnpXEyetQH7N5TmLyts/mKqfjdaTDbqsXF
 EAClegjgdQs8fdfdGcQ==
X-Proofpoint-GUID: Iq1ET6xQDUZuvVnDBlMf0UmcjpjzrF92
X-Proofpoint-ORIG-GUID: Iq1ET6xQDUZuvVnDBlMf0UmcjpjzrF92
X-Authority-Analysis: v=2.4 cv=Tv3WQjXh c=1 sm=1 tr=0 ts=6a6c35d9 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=I__WgQmDEH5XmK3x6moA:9 a=QEXdDO2ut3YA:10 a=DVKqRkKJf1IA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 spamscore=0
 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310036



On 7/30/2026 10:03 PM, Nicolas Escande wrote:

> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

hardware version missing betweeen target and bus type

QCN9074 hw1.0 PCI
