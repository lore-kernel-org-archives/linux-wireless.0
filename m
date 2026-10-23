Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792721606;
	b=Hl/OG++bWJNEbz4nz/fK8muiZmU+LnjQp5gBd6z5Jrw88PFkwsG50rQh0aoj6mEfLbti
	 IwqWcH6ykhNzZ6UwgmedlWiMGVr/X887ooWMHI4/TMw/P1L9NvMN62s6n9JETbWsscCJV
	 GbRIrtyMrbcvn8iWiBnX57zakZ+i7q4xjuceVKGic/Q/MxDmeGZZf93u9oRXsdjCpeQ8h
	 /ryGapNK4EDUTzRcc6b+lW7P9ACA1jNuPRsoNeXyisLxHsAkeQk7CyjkJIWerrCd8Bg0s
	 t9gvmIDNL7pUvyq40x+QgITRdAnGY6qaLY7O++h1MeLELe36ndB6GnSIk1Y3Wemjcgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792721606;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=V81n2l4pcVkf8FlHHSPONhxcDe/fAH8DllOZsnp9LQE=;
	b=UShisGUnIAx+EWn1y3aBju13AJpVRz5xPsLe4OjuZyxaINRQRBX5MkVba0L6kodA6gjJ
	 39aRjk0tUGSH+g7ojYYox2LKfP9G5RfliDj70Xne5ENB14RJB+psQIo5lHumoAoPknIEk
	 zZF7rxyCtfZRL57zAXaBJK0j/IognYEE9mOY5QyO+1WPsoQA5lkGG6EWxby+pMiz/zXay
	 jIiklDwgzWvOCSYL4PHcbXSy3zdwqGZi0f+oohkMMQE/GNV0lSoOMMFu3xD7goPcf7an2
	 twGiV11KbSPCnN9P08Heu1cFDQ8pQSe2swoy4bKD5z/AN5oDIE0X9uI/8VZ89Y0eORw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TSPTnav9;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gJ2visLh;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2F8606A33E
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE2F8606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TSPTnav9;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gJ2visLh
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1FKgJ1317193
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	V81n2l4pcVkf8FlHHSPONhxcDe/fAH8DllOZsnp9LQE=; b=TSPTnav9ABt5KOrf
	MhgzmTWAuIKOiBbmrD8KYGQMPa1VMRoNH3lDvCj2fj4ahX6HzNCqybglxI29ZzA2
	ohGoglDnYYQXJAs1RN8dC3R1LHpCpv9SG+Ne0dU88gQF+X+aBzkQ1+v/eDWdOmoL
	/rfSBWQv3OQrUqq+UMzp8bvmgloYYqsr50+fy9tecjri5VVJuDa0uPJ82gbTOnQC
	j4Cj19ZydWLuhg2pLC0BqkQXCe7+nwodQz8ircYUxEtnHf/Iin5x2+lDw/qG0uXe
	acKXa17PM1XdOU43/RXefT1Tq1pas8kG4fchOZOLWMhy1J86Cm1hE0XfhLZ/k1C6
	Mz2wmg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hftyg8n5w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 02:13:24 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa4e4684bso6421675ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792721604; x=1793326404; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V81n2l4pcVkf8FlHHSPONhxcDe/fAH8DllOZsnp9LQE=;
        b=gJ2visLhNSm5ZVGr2aiHCcpjcHMIfx8mdl7mgS68osQyZMi6Oc77+rPQpZAvGEeM8S
         PsuiUB0CbIx6mzMfm953TOJc+PAC8dxO2j3jfEtxgmASuYKKfh0lH42dPQeDTQlZc+M7
         hutdzKUKUUg/7Gupsi31VXBWCm24u4nA5q8bYp2b2H4+lMZgpdDZUtayLjmV7kQnrzIy
         fgrRwQKWkRHbx4o1T2kCNxQutMl+R5PZncMD5sO+6uO+V87XQG98H+V9x39gZ8zttZrj
         HV/5cvO2itTV+Bmc7vcUNZ9duypIW5A1HkSz/HZ3+G7cWI8D3OHtp2bf32K/VX7+BZeS
         6/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792721604; x=1793326404;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V81n2l4pcVkf8FlHHSPONhxcDe/fAH8DllOZsnp9LQE=;
        b=FEFGycuO5DeO9ZyR3o0zS+eOpJWtbZDS46gUya70pLziyXTtuliHr1b98BpfAzMEYu
         Jslyy0+eRojGnd+7tRFhRo3xrWEJtFYHO0K25mSrYv+MKkruUDL9wIjhSm7KDj+wZdVc
         vdM3U/v3Vc/P7B7Fl/8xFBu5zTR/Dw3Sy0dbssbYLX6E7+3yH3vrKwLO5AA6bmUeyv0B
         ojxLhE8nqg97BqDlrzvt9lruVf5s/HbiOlo+fPvrI+No1t3KFyUXZfuvahcDEeps5/uN
         4rNpgH980m8bCDZa3KJOtYhwLWNxEm9X7aEVZaU/2eUByMfb2oT+6wD2HzL4RWYgiJ/w
         urFA==
X-Forwarded-Encrypted: i=1; AKwUvBzjU9irFuYmU/5t7loMWuiEDxRYodX6tQ0VV3RWMQVKoaU5HcW0Yazu7ehIkLonT0PZgXNEO7wxVsSD6CTR5Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLh3W2eENF2iQRcr894kQ7uRMUuwT3/pcv01s1/SUM1Kw2yc1O4
	g3gcXTjcAWVFHMI6dLquW5rvTUXZR0qIct1BnxYi2ku/XwjRKs1VBXZazLqUDDNnw8oDBbCIn3h
	OFMCVTE1TMjflc8eU230eHV9i1E0DY7tcde5efrmRaOE2rVwOFEAByqgg/cuJCBhhsbV7Ug==
X-Gm-Gg: AYBFou2RjhcWBkDdz7Hym8Sz9Bpxa/+T3iHgXFpkanM2cWFNgp/h8p3Gy9AVwJ4zfyf
	CciJYL7kqRZs9X8Wqkio0RSB6uONNEFLgj2ZbRs3ssjxlXGugZMmfVb4yPRRVykqs8qbra4yb4r
	gRJO168ewiK/l8bWFB+FpNL8CUMLWarmcIIhUDZ53rStjTG86+ZB3h7eT8O8uF7bnuWKzC6+0f5
	ENFoi/q3J+FFDD4QWTdHcqKk+l8bK359pgzWO6Z+mZypzY8JOV/SzjfmupdFPrCJY6BBgf0K+2S
	KXS8lHfRDem8qwQph0H4L3/9JRhT8ZTp5au/qE6/a5N+LodR0ESNNOxGLlcQLQR0RSVRhbsovgD
	fU8zAPgHzYdzhmikQ9KsBqSQh00nUYPdrA+pQIUA87s+wvaFvf6njBNwoKv/bHJagEVPPyy/LDA
	==
X-Received: by 2002:a17:903:2307:b0:2e9:8b2f:3572 with SMTP id d9443c01a7336-2ea7d0e3d95mr9255285ad.26.1792721603512;
        Thu, 22 Oct 2026 19:13:23 -0700 (PDT)
X-Received: by 2002:a17:903:2307:b0:2e9:8b2f:3572 with SMTP id d9443c01a7336-2ea7d0e3d95mr9255095ad.26.1792721603006;
        Thu, 22 Oct 2026 19:13:23 -0700 (PDT)
Received: from [10.133.33.125] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7af6b862sm4215985ad.1.2026.10.22.19.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 19:13:22 -0700 (PDT)
Message-ID: <cbfa35c9-cfa5-4eb5-a203-09c9069e3b0b@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 10:13:18 +0800
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
 <atnVeGiu9Q07HyUq@QCOM-aGQu4IUr3Y> <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <atoTUgEIfkg6b29U@QCOM-aGQu4IUr3Y>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=cZpHPXDM c=1 sm=1 tr=0 ts=6adac2c4 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=GNa4QO3Fkq167Ut2XdkA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAwOCBTYWx0ZWRfX7LFpiAYMrv2e
 fJ6A4Aaaez2WUondotDctNXSAO2kml2TbwLU+8rqhB3dLUteiJD8wsYNdXbmxTHA7k9Cx5NFHPN
 LeS8CVOhE2KT9vFgHhpzrMu2qbfEfrY=
X-Proofpoint-GUID: iLTzdFEY-AAnC3DIXpkOfrt7JnHTXMUH
X-Proofpoint-ORIG-GUID: iLTzdFEY-AAnC3DIXpkOfrt7JnHTXMUH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAwOCBTYWx0ZWRfXz+Kr5KT2Wjob
 wXY3U9eImTkKcELe/4i1KExuorIU5gfhvgZQ7YCksjbTfjp2fubqj5BFsU1pMORKT83CNaFaAYG
 9SPLqB86NXJOeNMp6SVp8pJakxlAMl3MVX94BbkFYcJrsVR4qe4e0QiPoNIsj57Xg1WfjkOPhS+
 HW70aKfMvRCNA3SZu0feGzzp30eI0IyuZZNMxIbRHj195TrT9C0VyY5gE8bwlBgCi82SRkv4ueT
 sAkxT6hsqA9SRO1U5wn3KX+Vmd61a73/YPwLrvXoupfARMjNT36jhuJ1yBjeHxcdHHFf9nk0UL4
 6LTLWd9JHhPt04ntqLHnHEgO4iAEfsznlVPCnklqJblXHs1djTQnGmPeW2QaZcQacqqMyQ84ekx
 vdFbAaE3JzUOmllEXyVFzmWG9OOFAMQHIMGYa9ZZx/8h9+YdwPy+hY8Hyox0GbKjFELi4dZPvsl
 fZtgKI4g2rHZmlfMywA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230008



On 10/22/2026 9:44 PM, Shawn Guo wrote:
> On Thu, Oct 22, 2026 at 05:20:56PM +0800, Shawn Guo wrote:
>> On Thu, Oct 22, 2026 at 10:30:45AM +0800, Baochen Qiang wrote:
>>>
>>>
>>> On 10/20/2026 4:53 PM, Shawn Guo wrote:
>>>> + linux-arm-msm
>>>>
>>>> On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
>>>>> For WCN7850, MAC buffer ring size is updated to 2048 in
>>>>> 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
>>>>> to increase peak throughput.
>>>>>
>>>>> But during the RX process, a phenomenon can still be observed where
>>>>> the throughput drops by about 30% from its peak value and then recovers,
>>>>> and this behavior repeats during RX.
>>>>>
>>>>> After increasing MAC buffer ring size to 4096, the data rate drop has
>>>>> gone.
>>>>>
>>>>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
>>>>>
>>>>> Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
>>>>
>>>> FYI, in case someone else runs into this: with this change (merged in
>>>> v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
>>>> working with the older firmware that Debian trixie still ships
>>>> (firmware-atheros 20250410-2):
>>>>
>>>>   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
>>>>
>>>> Probe and firmware download succeed, but every WMI command times out
>>>> once the interface is brought up:
>>>>
>>>>   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
>>>>   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
>>>>   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
>>>>   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
>>>>
>>>> Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
>>>> reverting it on v7.3 brings WiFi back with the old firmware.
>>>>
>>>> Unmodified v7.3 works fine after updating to the current linux-firmware
>>>> image:
>>>>
>>>>   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>>>
>>>> On Debian trixie that one is available from trixie-backports
>>>> (firmware-atheros 20260916-1~bpo13+1).
>>>>
>>>> So nothing needs fixing on the driver side. I'm just leaving this here
>>>> so that anyone who sees "wmi command ... timeout" on WCN7850 after a
>>>> kernel upgrade knows to update the firmware first.
>>>
>>> Hi Shawn, thanks for reporting this. I just had a quick test
>>> WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3 with the latest ath tree
>>> (ath-202610191908), everything looks good, simple connection and ping pass, I don't see
>>> any ath12k warning.
>>>
>>> The firmware images I am using comes from the first commit adding WCN7850 firmware:
>>>
>>> 	fb04a7f4b750 ("ath12k: add new driver and firmware for WCN7850")
>>>
>>> and the md5 values are:
>>>
>>> linux-firmware/ath12k/WCN7850/hw2.0$ md5sum ./*
>>> d3750b67b1013fe82358d0538fb131b0  ./amss.bin
>>> c79c410d585360000c0490f16fda43e2  ./board-2.bin
>>> 73056f1d2aff886ce9bff313f455e963  ./m3.bin
>>> d0ee61498bf1a205147cdbcf645391e7  ./Notice.txt
>>>
>>> can you share the md5 values of your images?
>>
>> Hi Baochen,
>>
>> Here are md5 values of the old firmware shipped by trixie firmware-atheros
>> 20250410-2.
>>
>> $ md5sum /lib/firmware/ath12k/WCN7850/hw2.0/*
>> d3750b67b1013fe82358d0538fb131b0  /lib/firmware/ath12k/WCN7850/hw2.0/amss.bin
>> 5dacdfbe6c3c25d9e0605be8a9f1f6e4  /lib/firmware/ath12k/WCN7850/hw2.0/board-2.bin
>> 73056f1d2aff886ce9bff313f455e963  /lib/firmware/ath12k/WCN7850/hw2.0/m3.bin
>>
>>> and have you ever tried the upstream mainline
>>> kernel or the latest ath.git tree?
>>
>> I'm not sure what you mean by upstream mainline kernel, but v7.3 should
>> be the mainline kernel released a few days ago.
>>
>> On the other hand, I just tested ath.git tree at tag ath-202610191908,
>> and it worked with the old firmware. So it seems there are some gaps
>> between v7.3 and ath kernel.
> 
> I bisected drivers/net/wireless/ath/ath12k between v7.3 (broken) and
> the ath tag (working). It lands on:
> 
>   15f7603b69a8 ("wifi: ath12k: Increase RXDMA buffer ring size for default memory profile")
> 
> The previous commit, 643f0bf93617, still has 4096 entries and is broken.
> 15f7603b69a8 changes one line, .rxdma_buf_ring_size from 4096 to 8192,
> and works.

thanks for sharing this. I can repro it using the 481 firmware once get 15f7603b69a8 reverted.

so the rule here seems that rxdma_buf_ring_size must be at least twice as large as
DP_RX_MAC_BUF_RING_SIZE (I also tries four times large, it works). This rule looks
reasonable to me, since WCN7850 get twos HW MACs and its firmware setups rx_mac_buf ring
for each, and each ring fills itself using the buffers all from the single RXDMA buffer ring.

maybe I should submit a patch mandate this rule.

> 
> Shawn

