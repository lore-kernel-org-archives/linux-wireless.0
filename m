Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E97519CCF5
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 11:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782299722; cv=none; b=pTO1nLQ0A6td1XAFin390ZQOFBE3pxuGWJoXQJZE9MK1ad+rijALws1Kc0lBKXIBee5W2YHykCBxCr9IhrLhW2V4z/qvc5gyguC12xcj2eN8uPEcae6b3whv4eAtyZ/dz8csaQfVybrjhsPCVJ3HvFojcWTgfPd2v0sfDQV0oSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782299722; c=relaxed/simple;
	bh=6sjpscYMfhd4p8HS7u6QeSb6lBCzm9Kx6807olSYgHo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=qXsNHk9YeItkYXfHmiTodRDaYwY7VzohfLMiQzSw9NFxwMyb1yobuJinzRNI1ltg8/HMHODgzQuxpayciplST+sDT5jSSzGixdPyyjgOFC1KDHN7mMfZ3C2ZX5z7Rt0i+hxvSiUa8Zoj9d55kJJQ9V4hi0lkoHEyCKQ7Ip9jb10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Mtu0SPrg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XGqY6GZc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Mtu0SPrg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XGqY6GZc"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65OANjai2585811
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 11:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=6sjpscYMfhd4p8HS7u6QeS
	b6lBCzm9Kx6807olSYgHo=; b=Mtu0SPrgIq3VDTtcG6Vk7xVeRCZC5+9uzofi3T
	4eKvOkL/KM4wJi2EZmBE8dmNP2c10Y8iDr1Lr4xmnF1ZW2atoMDl0mCGvdprklK5
	EPkImIOjkH9v0/e/SnLqkTLYYMo3hgqN74bJdF5XYO7ZWzlnLx+BG4jf0Mordi1z
	gqL6ndFK5MWgghC2zHPKmZQoFgz1U5do5EBEjYBATtnHl8j9AoSaMUI8k++BXgmw
	ys95HTabOlglLsv3K4vCUtrIwwe46etq5A8rgdjvAW8TTLWUGyNh9J9/sRmSVGAX
	LuyCBgCjFZ6n9hleyWwun9SaqsGRirasDe2K8rwwrNPco+3g==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f05aq9wtk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 11:15:19 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-845317fa7e6so1327586b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 04:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782299719; x=1782904519; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6sjpscYMfhd4p8HS7u6QeSb6lBCzm9Kx6807olSYgHo=;
        b=XGqY6GZcMJld5Nr1iy7k4aW7EeWeSF/3fYAb7W1LiDXuM9cQma6TywUF89QZXDGqK6
         Av59t66x4lLyBc+pwmm5kTorZiGARG4KLkQNKj5/wzXr9eKqBmskn0P0/w1DHr+DUyiq
         xTZXrrcYts6fAWtLu7y3ZKflivvyO0DWembHRr/Aj0ZjPqlTNfxxlsNRVNoJ3cU5F+Me
         yYf4Qg8zOPy1uIb5e/ksNllZGt/fakz+gmYiaRK95l2ExMRBNu46jbOt4e1cVM+cQHhS
         dUkFAVds1I8C/YoEfo622+Ctgrix92gS2Y3FQqa3ZZixJxcqt3NtdV0QE1yTsYyRraMA
         4NyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782299719; x=1782904519;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6sjpscYMfhd4p8HS7u6QeSb6lBCzm9Kx6807olSYgHo=;
        b=OXrr47eimyEMR+VUlqIh1m/Et8VDMpKRuf6iXqUn0yRbA1lnNQJcubcAo+QWXelc7l
         UEp4+nnKtxSmkBG6kaXTwaAAmyHezkL33wYqx3zpqp4haS/QUcUFlYaJNW6A17o3CgGl
         5T1pfKlrLtN344Akob/o4r+7VK75hbZcNUo/5X3DRisvZKZEXYoiy2GggoxK8TEFxrnj
         YJ+uerKeBbeyEJVCVdmJbGnFxPR4iFlD8Kvo/eeQAg8JqRMxxbdjhNMp52KZB/EFx4/9
         6p4292B+L7IRAOzmAv5iY6uKQhOa+j+ee+mz5136bMQXU+mnsSBUW5FY30wZSPP2t7LL
         W+dQ==
X-Gm-Message-State: AOJu0Yx5WcRTOomZpZyqSDDoaasxBNnyjy+83WNEqrHbWJrhbwKDTcit
	0ZdWnfvP9rgVSLP3la/5gaVyHqS/oEDit+Q1Nr0XTTWBnDThk1A2ST9FfKDpXWcrGAavs7wm9H5
	tf2K1r6QzuoKR7iCT4CvKPAF2l2S2ijImcJpNIYY8CFUy4Z6xd37ObVLBffi3H1zOxuZthF7Jjr
	4bn/45
X-Gm-Gg: AfdE7ckx5hB8s5xrZZy7n3ESM4lRjVdydZphNtRQ0s/IcFBWjyWvO50XrYXIUoNJX2z
	dHm6SGEAZagc1oWvEJHJoFsPsOhJ13UD6lLdYIgZVjUXKlEc7CmK7qIQjcuWzBIG7bblNswiQ3U
	5Fo8pTfShhnXNPPGf9O0HdT7HcthuAe9ns8TUHGsh4Tiq99CvBLwulRMupGzXv+fQ+XaeTNIQhl
	s76E4t7xK5f1xIAsT4CGvGN2l1m0w/ls6Cd5Fg+SvUsjml+Pzcc3HaDg5IcwfWZhLcvVCKKDh8F
	aJe+1hKtzOXDyuPIpv2cz36W0Ip4f0+rP8IaQUa4KrbjjQfeEw58RH1t3IBtH1A5SPKm70TdM9I
	nKvQ4VvPxEUUlN2V/JLNM5vHMvT6aix4hRd8=
X-Received: by 2002:aa7:8894:0:b0:842:4023:42c9 with SMTP id d2e1a72fcca58-845a27b534dmr3969750b3a.41.1782299718764;
        Wed, 24 Jun 2026 04:15:18 -0700 (PDT)
X-Received: by 2002:aa7:8894:0:b0:842:4023:42c9 with SMTP id d2e1a72fcca58-845a27b534dmr3969706b3a.41.1782299718204;
        Wed, 24 Jun 2026 04:15:18 -0700 (PDT)
Received: from [10.231.194.159] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a3fedaefsm2520547b3a.23.2026.06.24.04.15.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 04:15:17 -0700 (PDT)
Message-ID: <52c268b7-4eec-40ee-be03-608c8d3154a3@oss.qualcomm.com>
Date: Wed, 24 Jun 2026 19:15:14 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-wireless@vger.kernel.org
From: "Yu Zhang(Yuriy)" <yu.zhang@oss.qualcomm.com>
Subject: subscribe linux-wireless
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI0MDA5NCBTYWx0ZWRfX9M29mvf3FRqd
 2V2/P3g862vLeiU0BQdEd4Pup/BKOqh+lrN/NepBGBxLKLn7YSoujfk8Hc0/e4RifRd3X6E84A4
 TUacibUoryu9p4xEmyJ3QIvc9sDz1vs=
X-Proofpoint-GUID: ys3bM54HQWCPR0xrA1d4EibH4_LWVzff
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI0MDA5NCBTYWx0ZWRfX68oosROlpSTO
 hQ6HGkPDryZwD8Q4DxuEGphsrQSjWmbn5vEAQd3pZOIfynj0kT+1lFkqlc2W0gTAwS0ilnTTWEG
 aFumJCubens04+t2dV5P1yhCl2HuFcjsOMj2NyTinXdgavSAwuQNNr/ElPSJ4JsuSfviNFSn4Ss
 I6bgFwFcjWpEawBrvWKEerE01A8kyphBHPnldIpJohPT1aLztp5kLYpmc+wQbI4K9hJbs4cHTBS
 UyEC5IaceyXcZB063kwwmKAHrfB2JmRjkfDttMVfLhBMePC+KGNWa23h3+Sk6PYPeZdQ1kyrpTy
 0aYpv9286GwRPWkP5bJOZ+/zYM/f3uvxLR45BH+WOpAskUZPGFuXI+uB0F1es4/XzgFeNLS+YYr
 b4upPfMetrusGWrtsipLiX1XvCCvHg==
X-Authority-Analysis: v=2.4 cv=UphT8ewB c=1 sm=1 tr=0 ts=6a3bbc47 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=pHFJKYoGphnQKblitikA:9 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: ys3bM54HQWCPR0xrA1d4EibH4_LWVzff
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_03,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606240094

subscribe linux-wireless
