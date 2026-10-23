Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720764;
	b=MKslKqfRghQFbDsI/WFq+MgjqazWBr+ofSgdKkAK9a3y6RLrQMEGOlSULHc32lc+Iixg
	 bA4YWZ7U+Bv7+FuJd51rjwyQ0nx4LPcprD4kjzRtVhtZrEk43ahR7ryNJ+ZS4BuFCBQ16
	 FMX/GQiBs3smjvpKrAXLj+kroGScqpNggy29uZHQ2i+eMl4GVv83hq6f+AXePbvjhZBry
	 T60eXTttQEzOzGYKiDNzXK5WEQ5d0WVtyqvw1R56nbiksDtmZ6ie2SgEqVUP/og42OsIK
	 zi1l5YqhwUYDucUm6c1HSC31ee8MGQdz8MabR1AVC02N9jlNE8a5C+UGS9BuoBeuMzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720764;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=wwCEH3UMjVWNpdZ/sPhfjcy7DLhx96UCaz7JYkCEV30=;
	b=4g7DCBuJRSefr+29V8ZxvZcC1CCuV3wGtG0wpa9uX8GnsdGn+5tFrZrePoblavs08BeN
	 peBCFzppZCX/cmDWC2pK2zwzwnZndRd38xlQ7jBqdALj1ScE7xskzaRsaoJqwzNfjfVqR
	 js/FNRv4h7iMRtKuaYghMUiEmAnzRUHMpcwHy6BQsUfT+xijCB2f341YZiaZbtiF4JZ4n
	 QCCYDbB3ROHz/2IWt9AqHbRJaoMwHmImW0PmU8fc//f6U04EhuMlzco7+Fz4ZYjBdA6CH
	 9XZqlywPttlr67/yS2hm4PqURnPW5ayJPjAYpKEJdA4tOpLowbPKqKp6PGB3gTOHkqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XAIVzq3Y;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YS2FxfCZ;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1860606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 01:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1860606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XAIVzq3Y;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YS2FxfCZ
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1F15D1290213
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 01:59:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wwCEH3UMjVWNpdZ/sPhfjcy7DLhx96UCaz7JYkCEV30=; b=XAIVzq3Ypb2t5gbB
	JNSjrpFOj0OeSlSy1sTvXDFdbHyZcTYl1ePCaYYNHt4upOcl9B0fDV5OUpCSvNpI
	8P6UQVicjM3weO5GFr66C6lL1XSuHcL8mp3+AkqH2hHhzYlBrpPbDQekw1oDBHId
	9TxzYE2SOOUtL+2wvA3CMHLP17T28F1HyEzvHNsXEOM/3wOzDnilq/be6wZ7yidZ
	/mxUrqfnDBjwDsKLCEYwmsQF13C3Jp93WBo2bODYq/RTCB7MD/rFDyZ+qYtNp5mc
	jU5QP5lsb0n//LDhpOiNrVoajbCZJ2nsbPzJeJlsr/uJqb9qUcHmNxNwWA4nn1a1
	x0W+pQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfnyw1wwq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 01:59:22 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so367766a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 18:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792720762; x=1793325562; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wwCEH3UMjVWNpdZ/sPhfjcy7DLhx96UCaz7JYkCEV30=;
        b=YS2FxfCZCzIEGqHGuEosMsXkrKxP2BAKGiMX2sTL580WfDSRIGPTRaIhDXLK2PPfot
         i/hJNYqAsei1AlRUh1wAWB9oXbk21fy2IYblnC1crEQkrBwRVn0X35bDo31j45+R2XV2
         EEcYKo4yicjayUiMOP+4ZlC31wA3NrbzqyXiE2rsCx4CAXpuk+9MF6WkgGu5S41vi/QI
         JC99t2iOxA/ih0dMg2wf9t9lEKXZ/nJ/AtKRgprBIhtJIRiWOnT3QsDIiAoWgYmGTuiF
         7g5CY5Te6rZUhDlzXAA8w2YJSuXaauxU2u4FE44XKbmFlvu0r8RFNJGfksj5Q3djp+lh
         bq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720762; x=1793325562;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wwCEH3UMjVWNpdZ/sPhfjcy7DLhx96UCaz7JYkCEV30=;
        b=HNuRr9wq95bODlkMeX2rgGaQHQfPB54XX5dxKzl3H3U0+wion9Z5FpZqHIEVxGid0t
         PZVsiR2Kmt1bRbWwBp7fbNUQmA1wGM+omshAHspK9sy/NwdxpLHcPEfBEHhUuMRXbkPo
         nZf51uiN1ncQMVIRZDJpNk2acjgGBw13tdqMGWDSxLUfsujmVrtDP22GfvU4wn8BUAEy
         tqxA/iTHTZW2wJuIXCsFtgAiZ+vtMHYnwUVdSf3SJfBwmdqVssWSnN5vICLvTFYXWCyw
         7KD5pL1Ny9IjcSaT/Vo0dRqWsVVn6MdFoXUNkQ2WldK/rOHL3NH0lZTzSL4e+cPbmxgG
         /QDw==
X-Forwarded-Encrypted: i=1; AKwUvBxbK8ScfTb2v9rr1yYl/+Uv1gwcGYdlXRrhkp4OAAJFPM+5w9qWOjpbEgH1IkXm+yJlAFsrpV56dgHZikuNnw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJtL745zYDYlHZHiqINd3xuYKAKhFphTvrnEpYKu0Uan15lchso
	1WXLk3B4BRMp3aQ+Ym26cGBZlua2VfneGv8jzLwkaB6ShZhBypRsk7UgdDU/3aWvwVk1+pxB+09
	OoTq5MOAQydhWTGpqlv5wNMXsu/S/2Dnsq2H2Krvn1Mu306f6Ma91AZHG4zgltvd+XolXEw==
X-Gm-Gg: AYBFou1UKC/ZrmA9OrHFsFktTLSaAMOH+KPw58vp7YgoDYC+TiyLhY/O7FDj5SCQKq2
	M5ZLV4LFxA58kB7mzsgRH22HbNxDKdiZ7CpXpPebbcfDTICkvaj7wQxKcwCS+28/XW5MwdkCOcd
	vzJSt66Tokrm98rEn7vxzqTksyLPo8zcEnd9f2tzTdgJjwKpN6iRWV4br2DooMFmY7tL4M5UGce
	DDsDDcPLoFb2jlC19rGJrTw0parj8YYuCFZGlFCUbfo5pXfrIL41Vy/j0n1rXoza9wuTPApiARG
	eAbx7kX2UdoYgYYxhyYdenD2Oalq131Fe/ZH9h27Zj9s6bAZq7SNbPuNKXFsKjomkIMhfbUrMnm
	F00zu/bht26NNUPqAANKFS9w+77dLhjWsvviokuGf0YeXYt2K6OZZR+XQ5NFxmEfxvZtHQJz98A
	==
X-Received: by 2002:a17:90a:dfcc:b0:3aa:fc22:8aa7 with SMTP id 98e67ed59e1d1-3adce7c7897mr585322a91.53.1792720761549;
        Thu, 22 Oct 2026 18:59:21 -0700 (PDT)
X-Received: by 2002:a17:90a:dfcc:b0:3aa:fc22:8aa7 with SMTP id 98e67ed59e1d1-3adce7c7897mr585307a91.53.1792720760990;
        Thu, 22 Oct 2026 18:59:20 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adcb1f93e0sm1232848a91.15.2026.10.22.18.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 18:59:20 -0700 (PDT)
Message-ID: <4fb7840a-27af-483c-927d-f99d33be334b@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 09:59:17 +0800
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
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Yingying Tang <yingying.tang@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
 <0423c93c-8359-4fd5-9ba0-17e5ed3927dc@oss.qualcomm.com>
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y>
 <0d5d36ae-3d65-4dec-98cd-7409ba4180c2@oss.qualcomm.com>
 <atoRzGmURyjFcH7Y@QCOM-aGQu4IUr3Y>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atoRzGmURyjFcH7Y@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: jkPR9uveuxurrQJpA5TeaL_QSnw9sseO
X-Proofpoint-ORIG-GUID: jkPR9uveuxurrQJpA5TeaL_QSnw9sseO
X-Authority-Analysis: v=2.4 cv=dphOmFg4 c=1 sm=1 tr=0 ts=6adabf7a cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=RU906sw5RCHCpFq9C6YA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAwNyBTYWx0ZWRfXxnWRgv2kNst8
 SCxaz0sipdocu1L+Ol1YYMRgGTp8i8oaS0xMjG9BLQDVKeYWhjgb7MGY00gbyKiPgDg6Cci473b
 xC/qPXW7qa9kcCtWDzCEjuVQIJykEKI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAwNyBTYWx0ZWRfX4Khz1B4fnvZe
 Tgmb5ccTfsRtya+BT0EaaVPhodYcVRlmlddP+8+b7pNw1JiiFli6HMpXgayYOumf8oU7B64kBk1
 1F/32VjARB6N0Be0no8RuvtFHFY3m3lbKemcH9UfB9ZNCXNC64TIVwfnE39KLUi/RhWvZ+EHqE7
 Mn9kD0sabu8+Pj5tIhMGUYDSe98nHsHM5JFlKVj32bsrovypd8QA6zWUXZ2IeMC8BsB7Cw7ddp5
 jC3AaYdmC8tMrm7TcXiX1fAjmkKPEFcQngcR+mXi2K70L3K/cu9FNE3SMouTATPRpZhkoaTHiyM
 kcQ4+n/I7huV9JhTMpo3Zc1FuvQK6Mb0HCXJhgpMuo3SPLZZ4uds2X/7UwSr20nuCg4InfJl1Lk
 dFmjwn8CLFz5UHGYf/PHykpYpZqW+3If5pDOEqdRLpqJFc+Ix0uzavgz7nI4Nj5J7cHJfEjulZE
 wHrqoShfUC7z28+qkYg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230007



On 10/22/2026 9:38 PM, Shawn Guo wrote:
> On Thu, Oct 22, 2026 at 07:00:31PM +0800, Baochen Qiang wrote:
>>
>>
>> On 10/22/2026 5:20 PM, Shawn Guo wrote:
>>> On Thu, Oct 22, 2026 at 10:30:45AM +0800, Baochen Qiang wrote:
>>>>
>>>>
>>>> On 10/20/2026 4:53 PM, Shawn Guo wrote:
>>>>> + linux-arm-msm
>>>>>
>>>>> On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
>>>>>> For WCN7850, MAC buffer ring size is updated to 2048 in
>>>>>> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
>>>>>> to increase peak throughput.
>>>>>>
>>>>>> But during the RX process, a phenomenon can still be observed where
>>>>>> the throughput drops by about 30% from its peak value and then recovers,
>>>>>> and this behavior repeats during RX.
>>>>>>
>>>>>> After increasing MAC buffer ring size to 4096, the data rate drop has
>>>>>> gone.
>>>>>>
>>>>>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
>>>>>>
>>>>>> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
>>>>>
>>>>> FYI, in case someone else runs into this: with this change (merged in
>>>>> v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
>>>>> working with the older firmware that Debian trixie still ships
>>>>> (firmware-atheros 20250410-2):
>>>>>
>>>>>   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
>>>>>
>>>>> Probe and firmware download succeed, but every WMI command times out
>>>>> once the interface is brought up:
>>>>>
>>>>>   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
>>>>>   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
>>>>>   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
>>>>>   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
>>>>>
>>>>> Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
>>>>> reverting it on v7.3 brings WiFi back with the old firmware.
>>>>>
>>>>> Unmodified v7.3 works fine after updating to the current linux-firmware
>>>>> image:
>>>>>
>>>>>   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>>>>
>>>>> On Debian trixie that one is available from trixie-backports
>>>>> (firmware-atheros 20260916-1~bpo13+1).
>>>>>
>>>>> So nothing needs fixing on the driver side. I'm just leaving this here
>>>>> so that anyone who sees "wmi command ... timeout" on WCN7850 after a
>>>>> kernel upgrade knows to update the firmware first.
>>>>
>>>> Hi Shawn, thanks for reporting this. I just had a quick test
>>>> WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
>>>> (ath-202610191908), everything looks good, simple connection and ping pass, I don't see
>>>> any ath12k warning.
>>>>
>>>> The firmware images I am using comes from the first commit adding WCN7850 firmware:
>>>>
>>>> 	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")
>>>>
>>>> and the md5 values are:
>>>>
>>>> linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
>>>> d3750b67b1013fe82358d0538fb131b0  ./amss.bin
>>>> c79c410d585360000c0490f16fda43e2  ./board-2.bin
>>>> 73056f1d2aff886ce9bff313f455e963  ./m3.bin
>>>> d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt
>>>>
>>>> can you share the md5 values of your images?
>>>
>>> Hi Baochen,
>>>
>>> Here are md5 values of the old firmware shipped by trixie firmware-atheros
>>> 20250410-2.
>>>
>>> $ md5sum /lib/firmware/ath12k/WCN7850/hw2.0/*
>>> d3750b67b1013fe82358d0538fb131b0  /lib/firmware/ath12k/WCN7850/hw2.0/amss.bin
>>> 5dacdfbe6c3c25d9e0605be8a9f1f6e4  /lib/firmware/ath12k/WCN7850/hw2.0/board-2.bin
>>
>> this is different from mine, can you try mine?
> 
> Are you sure this board file works for my Lenovo Yoga Slim 7x laptop?

actually not, my board-2.bin may lack the BDF for your machine
