Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792636253;
	b=QIwz3SozBjiY+mMhkoHxpbaYodj/1tOTHmy5a7T/s9WpVMeKOdzLlIn38YIuz21hRtZG
	 pZslq7eqpQSglioieErP/OnYd+xB4VgUWWdb2/9GI8jfiSeQmyqClhmY6pdXjMGEfBZqw
	 gwRxgawsdfk7DZl7FhcjwhBuCRRlO7mbXMmfmy5EbN16RDr4VWjesuAkAs0QaVoGjDHUW
	 HE9/xfdiZdgUcmcKrMorznkTDV2Zrf6GSd39Yj9MyzZnEWOgXNpPT7pqlPZu4WAJfNG56
	 5Qwo1izmAIeIpNlsfTTIArY/y3IhzYEFWiFrTp2eWStx0o6NdjXMc9Bg2JlnUIpo/LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792636253;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=IgLVMbCOzKB09kz9r2gHIlbpyYX+LS7rt+7dIsfEXEE=;
	b=T8fYx9i8OE+vz5O3/j/aOFaJZ+Zb0nkqPJmx1hMEBidZVdIee2xQ5WBI4jfSGPcLLPeX
	 uskMbJAbToYGBW751oLy9Ol6QRlI1gfaLSqtsVrDo3itPoA+JFIiX3mdtuMnsWpxJjMGu
	 Bj8ZSza7zwlD35S/nKs2dsNUpG9evDxlt/Z6gJypa6mh1nkHCf2rMMxk2GRBEyYuXLETe
	 Jovx6qdpew00wsj/DdkxXr0cbbgNeOM0AfJLGJbpe2DSXPw7I228BZNzkEwc9KwRlLYnz
	 lIqF35JWaX1PATQDSL+WLQ+gNUUQW8gt7eFPtWtDrcwFRONTGst5Tt+1nxrOjaZiDbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HV6SHU27;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=LZLUuHoh;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7FE606A31D
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C7FE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HV6SHU27;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=LZLUuHoh
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M2SdQW3002725
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:30:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IgLVMbCOzKB09kz9r2gHIlbpyYX+LS7rt+7dIsfEXEE=; b=HV6SHU27fDigyi7b
	KHAdGoohXS5xQbTUBCnwvDux5SJ59xM7yBOcFsFjFs/OxhZHKyQqFVLp/n+duK3i
	7V1hcjmj7xgqHk98Gl6YQ+OBM+z8k4Qe3eeuOkENCWAkfnuCIZ28NLLk4WTGJ2oD
	kroBLFPhkabF/YcBUiTwP7LAXqhMrWDLUfqm0EWTWQXz4+0Cd6F+pEc3PA29Y4gn
	v3USmlMommUdx7C/QRlvKGVnpuWQJxaifzi/WthhAmA5lV71hwWyv35Tw416fV2r
	tKfUl3DrHQj9uNBeJP81nA0BA57h3e9VesbvFnylJ3o0ivhoSZk8og/vVoqImXYU
	GoJGng==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93c886k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 02:30:51 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ac0ae43900so1571298a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792636251; x=1793241051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IgLVMbCOzKB09kz9r2gHIlbpyYX+LS7rt+7dIsfEXEE=;
        b=LZLUuHohhi4GUnd1y8CfyX23Rb2NcyEpHQ+0yywHgTLiUPDKDzOb51Pws12wFVhauX
         ujH6HrYraTeJlc9jYCsZZqqPY2uHz+R+5je3VwJDcBFeTlhdt3qP8Jdt6dSDMStN2Mmp
         d1TBESCMFwN5/levwXuHi/jBSjoyDHV/sJVHo/4YUdWr4QhlTdxPwwA6VOwkWuBjQJS0
         1baVqwY7YxP5ZPwks8vpm5pJ+IZhiUyKlKvCd9DqBCWjlijPha2e2jTFE2nyvMiXMZd+
         emAcWKXi4olkYmeNZqgiEUCzCZMq3bx88oeeBbiT04UGA8/cFs+TheIo7Rk3LLuIVw6o
         92fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792636251; x=1793241051;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IgLVMbCOzKB09kz9r2gHIlbpyYX+LS7rt+7dIsfEXEE=;
        b=w9PM73qpGa39XqJe8ju5BMr6KyqmEYvjN/0nIIS6iQZHX7ICB+FXsmwrjyvSKUGPi3
         VwQywt97/XoMX3mAcBWXzZgEem+ThrDpxby32A8SyL5QZaokdX4GeauDJpzM+cXEnVBN
         thP2UEcYbbitfQMthznJb6bSnyfUWIpg8UkIHlurCzQkF92T9qxfrGqQEoQPCIiM1odJ
         n6ButDOePQfz8j1cGyR2djifTVxjShgvlGooUU5M5AeiHZ3tJv7sVMVsF/ic6o3SuMvh
         lnm22g8NBfTMviA3b4edhLBEyLzd+UtCYMkjZVkqnk8AC/3Mx9OSrRaqhAH5F4dRmxg8
         xEmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwoe+zpVIOXpBX/ELkHlR2eXfA+dpYxbl+hYsWeNmvTuoUa/Dg/IzuB57Bapidylv77dF9QFuksnWRobKQkQQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIPa+5QiXpG4UD/mkmoWA/Jr6o3tiQ9Mqkg3Ip1NpQ1sraGtIMj
	EqTqBVunnGp5tRwKtDkzgmZF4LBkOj0QVi7vSBiT80DUHs5h23KhEFw8H/JqWUGarCVq55UcEVU
	IpHLPS1uR2kAmYeChr3+L0VCiYLXt+G9/Am6Hqn0R7rB9RYFvypBo4nc91Ufng32pm3yg+Q==
X-Gm-Gg: AYBFou12BFzmhSSndAhU7/yLqMZtmqwEG2583BNqe8e6ytstTDi15oeDZ8JJdWanHz0
	yOHM8xAmWmFTrDap/u1aG2hA2WwKITw50xAIdZl2vJpbgzN4R3WbeTkplcVJyy9D32Pxa6dAUBw
	NxkcXZTq7Yifr37FgUxS+z8a1PRfreekVfjshbtEwfgSHX+K1lg0KPDAENaI0L01i/HlaC7o5yP
	nrzhv0NGVLo+lOz93avmRNf+0moOoEAgP2TUxJ3UTM1ASMn+wYqaVc1Zl/ydTL6ZBnzOAZP90QS
	DrLyR49Qjv5MRECb2Yn2POtymmatvexW7cWcAxmLBXuxCPrmchKEJ9c95mXTphT4ZR2lWaIE50d
	47+qprRERlnUWlnZWM4shTxP+vwWbNF0p7zQhx5PM654KKmHoFS9ecQRW4egnkgROvVxpwDNu
X-Received: by 2002:a17:902:f78f:b0:2df:9655:fe24 with SMTP id d9443c01a7336-2ea43c5fedfmr29905435ad.30.1792636250789;
        Wed, 21 Oct 2026 19:30:50 -0700 (PDT)
X-Received: by 2002:a17:902:f78f:b0:2df:9655:fe24 with SMTP id d9443c01a7336-2ea43c5fedfmr29905255ad.30.1792636250228;
        Wed, 21 Oct 2026 19:30:50 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b43b53dsm17649855ad.39.2026.10.21.19.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 19:30:49 -0700 (PDT)
Message-ID: <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 10:30:45 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        yintang@qti.qualcomm.com
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAwOSBTYWx0ZWRfXy2GGzJ0St060
 Q8yutgHXA7KD7guNWoV/KUoAtRSK6ZvULrJUK6wdO1UgMBsRHKIwkdL4FfY1KcYJNBkJ0Mj1I3Y
 SM444Ctc1NvgebhgJIkR4Wmbzh5J23c=
X-Authority-Analysis: v=2.4 cv=ReAFmFtv c=1 sm=1 tr=0 ts=6ad9755b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=wP3v5rCdS2J_7y42CfQA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: z7N-S4iDHozvdpeX4h_yXcGlrP9WC7Z3
X-Proofpoint-ORIG-GUID: z7N-S4iDHozvdpeX4h_yXcGlrP9WC7Z3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAwOSBTYWx0ZWRfX+J+NRbPpsIg1
 CKIvjX2mpjoxhoFaJBmRAk70xGHtU3rg5qTzH4o7mhVh/TTtZaoVgYsdHqV0GajlBPShsy6rbh8
 Zu2tsx1VyLPkTP9xWD3SMd7y78fnhm9hN77BI7W2oIMKygltx81fRzvJEQl8GTLfdJoPR2/10xw
 fBF85zjtRcOJGnvCZ5pyfkvPmmqXuP7rAgE2SzAE4tca9xhbKKqfP8hfYuxrqfMyW8p/GRFkwot
 ZYn+NztweUgq1oU7cHh5KC9ZEi9R5STXGIVp4jbpC40H8blrCDN4g2FBEKmseMI3dntPlXtWN+x
 JoCesjiGxvKvBYu402nlZCq6PilvBHfSPP5UWHtAb1rA1KzJKeohgHwU0aN1y5sm0tyOkCGrQXn
 TWDgi9kqiXbdODx8XE2Svc67NDCq1O8zFVMjxSCievKRJJclRh+BInVaFkpcOySiXBqCtiRQq8E
 0jweFoNsI0VoJPB0/kA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220009



On 10/20/2026 4:53 PM, Shawn Guo wrote:
> + linux-arm-msm
> 
> On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
>> For WCN7850, MAC buffer ring size is updated to 2048 in
>> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
>> to increase peak throughput.
>>
>> But during the RX process, a phenomenon can still be observed where
>> the throughput drops by about 30% from its peak value and then recovers,
>> and this behavior repeats during RX.
>>
>> After increasing MAC buffer ring size to 4096, the data rate drop has
>> gone.
>>
>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
>>
>> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
> 
> FYI, in case someone else runs into this: with this change (merged in
> v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
> working with the older firmware that Debian trixie still ships
> (firmware-atheros 20250410-2):
> 
>   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> 
> Probe and firmware download succeed, but every WMI command times out
> once the interface is brought up:
> 
>   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
>   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
>   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
>   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
> 
> Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
> reverting it on v7.3 brings WiFi back with the old firmware.
> 
> Unmodified v7.3 works fine after updating to the current linux-firmware
> image:
> 
>   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> On Debian trixie that one is available from trixie-backports
> (firmware-atheros 20260916-1~bpo13+1).
> 
> So nothing needs fixing on the driver side. I'm just leaving this here
> so that anyone who sees "wmi command ... timeout" on WCN7850 after a
> kernel upgrade knows to update the firmware first.

Hi Shawn, thanks for reporting this. I just had a quick test
WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
(ath-202610191908), everything looks good, simple connection and ping pass, I don't see
any ath12k warning.

The firmware images I am using comes from the first commit adding WCN7850 firmware:

	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")

and the md5 values are:

linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
d3750b67b1013fe82358d0538fb131b0  ./amss.bin
c79c410d585360000c0490f16fda43e2  ./board-2.bin
73056f1d2aff886ce9bff313f455e963  ./m3.bin
d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt

can you share the md5 values of your images? and have you ever tried the upstream mainline
kernel or the latest ath.git tree?

