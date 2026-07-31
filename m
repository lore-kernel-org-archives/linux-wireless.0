Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9358C35E1C3
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785477307; cv=none; b=aykFOceDlvRmNDRXyCAkeeUwnfA3k4UmH6gYKaJejzTvZCDGlo0PT5JEXIswULYr4CyBMipPBOjauvDzompQ6P28TOXls/LEP3C8tJv/68RYV9qFGaKVMgAnbgr/QewHpdL8n6zRnBtEoWm07iiCqVaqmjhxPDso91u8Vlf2tHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785477307; c=relaxed/simple;
	bh=gLl1M79R9613beP6buMsmUQ8eYGmOaqMrGkf6Vx+01c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uicdZ7O5Z/RisfHOCqWbtVIw2tNyRpVJxBy2GyJaOwEa2jsCz1jDflfyC/SF9WsAgM2MBXsP47CwGStyFl+/7n3X+C2qQFXh8zbIxJCWSGr/H69Ba6CmnD77Zd1NBtzO/ecwItsT+VQD2R6mLuAryyD+ipBeA5s5ki827Mgsh5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DY4r76zn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y3q57LNB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DY4r76zn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y3q57LNB"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V4usmx3277923
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	n1oxIOxN0g1TGcrg/76HonK4KT8P9WIXK+xAIjQtwNk=; b=DY4r76zncXECck1y
	GdVQkcoMJhqhlrK3mNjI7EewvvlBTaODhhZlRukVSNrqO0UMLngGjlgqp7SR0kWO
	74CWpOOCjKuwtRQY++9Roe39HX5RW6DDqe/f6JEUCEz2vkLu9fYU7cSsLKZWtGnl
	adKsk2lblTMI8x+viHQBxiC+admDF7rNswzjUiL8a06mvbQZaA7OuE1AA1OwV0w+
	i/bCT4Lm0dE+63pk1o16lcDmqoAOeR5XZ/T5l7nXkXVLC0Kbs5ddc/9GG2XSqvnl
	4NOSDlKCSZ57XGCq76SCg9+tlaG9kSFiD7DUucyzLRQDPJFGEonqweIM/dcNE4cs
	GhM6dA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frn0f86hq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:55:05 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so826751a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 22:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785477304; x=1786082104; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n1oxIOxN0g1TGcrg/76HonK4KT8P9WIXK+xAIjQtwNk=;
        b=Y3q57LNBvN34Q+poV3TOEX3EnTvIiqQDZ4lL8MKm/ofRxlXKC9XqSbm22OnLlWOugl
         KwxnPbbT+q4A9ymw6p4tBXdF2hM6nbYELe2hWkoBiCNOZBD2BxPcrGKeomohhVw5Ih7c
         tIMbCYiYy6tKl0pnVdvad//bw56CGRg+QekWhrVmJEjfWsmOX+14I8wtGtvpqBzVcLDh
         z6ecWPKY5IfmwjHhLm/7NrkzjOcM3SUJd39Unbp4zUPI1pv/3rrFn5Y5aAZcuh0IFXMp
         KMWYbc4NtLjUmO6++txI0AL5NU/Y7RLN2UxMxTKcycZ2jS2dkgAO4WxA4clv137Of5c9
         6Nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785477304; x=1786082104;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n1oxIOxN0g1TGcrg/76HonK4KT8P9WIXK+xAIjQtwNk=;
        b=n3jQbV/U0Btg86GO2L2b4bs6Ar1DIiL3tnbLGVFHV/PshRsLfoJzjD+H7W16BuKdDl
         H7WHlGyXJNBJehCn/w22WkNS8zQ2EnCQ4z86BmrhoZ6YXwg8WLoPafUmhNGQjFbRGwDi
         aS28FwEHCvr//OBPAF2nmfLjbBaJn1EZMvJYCEsXYmyiWrkv5WPyNiThAWwSIjE5MtNe
         ba+xUudaGmJQn5+QHbVKLs6L1kmtg590n/NxQDDEzuWPT83NScEW+bdYwtSDw+3gpNtE
         /bHQv8V8/VjhlGXNYrVbHjitWAAnbvAyi4EdKl98vGpK6MC28ELF/DFd0JNan3RKOvtW
         gzvw==
X-Gm-Message-State: AOJu0YyUO+t/siUQ/tP8gl1QiQ1GPJJDkyWecz9sqBa1VGO96MsRWjeJ
	lL+ERt24VowwXis/oWTJGmOkXbBmusfB8w/Mrxg/zRO5n56+DsHU+t4GWrBf+o1Yt1HZfqJnDeT
	Bda6wD/pP1o/bThxxxD0fKoThyJYf7xXNfNuKvgecuOg6gOoaPH7MVuzaQgkLOBsMyuQbRw==
X-Gm-Gg: AR+sD10juDXHtAT0Rz73TGjwa/i8dJAmM3Nq9GdHvyn7ia8YeREfEGNz/eP+b20OV5k
	ercj4vGryHI0G2RB0Aqo17agVWzNrIaZjwubDscTuHZGpUrph/M+m//PXL9IAk+kHZ6RhvidO6R
	GTJlrjLevNfwKRGE85DyDhXp5tcEjhCd5KVqDXsOEL/60DQ72dZMvwvpCMagnvnGWVtco9WO+Ky
	Z8C8k7lPNmzoXlb8OY3XL8imH6/NOxFF6iw6XGnUzHGgZ/AfywG9BfaG64n/rM2a/YtclfsgPRl
	w8dfspn/pCcfyBrKpKUM5UBffhZGzazMxquUQgVtqFIxLk3J+ZO7MNPfggoSWDce7zI3OcCFBXI
	8igd/lBWEp+tN7ADsZywe3DwDPN7D0kvpl1LaEXLJ
X-Received: by 2002:a17:90b:4d8e:b0:387:e0db:bc23 with SMTP id 98e67ed59e1d1-38fb14a9599mr756844a91.35.1785477304024;
        Thu, 30 Jul 2026 22:55:04 -0700 (PDT)
X-Received: by 2002:a17:90b:4d8e:b0:387:e0db:bc23 with SMTP id 98e67ed59e1d1-38fb14a9599mr756822a91.35.1785477303560;
        Thu, 30 Jul 2026 22:55:03 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fa7470c5csm1782626c88.5.2026.07.30.22.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 22:55:03 -0700 (PDT)
Message-ID: <bd49ebde-c5a6-4640-8308-e7b4c3702470@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 11:24:58 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath10k: filter non-UTF testmode events
To: Linghui Wu <linghui.wu@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org
References: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260730023226.707008-1-linghui.wu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDAzOCBTYWx0ZWRfXxXoGH6BRi3Jw
 3vzJ/A+6Nc6lU39Nf7a2BlRyrbvffUPJjf1bItIWLGol5LAEWWoxa5IyzYKwiPUzz4LXCS76xUe
 c8iCIXoHldErELltg2fZCfXzXweHGEU=
X-Authority-Analysis: v=2.4 cv=HJTz0Itv c=1 sm=1 tr=0 ts=6a6c38b9 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=J8ee_osQro5uhysJbSQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: pgpexE0z5ycUbPOJxag3Z8elNn-3AeGE
X-Proofpoint-GUID: pgpexE0z5ycUbPOJxag3Z8elNn-3AeGE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDAzOCBTYWx0ZWRfX+atxxpfGbHtV
 lSSJU1abywrDgioG/XqCaMEiOK16BbzXLZIwkbzyeoLxu2QTBq8jPHI8LSpI1YmD9szQws1B4Um
 xz/Akd5kpsVhOGBW8Z1mP6FiVnKvyJFRb12Msc0kZ1GjPYdGMAK9nfZx7QmBT1PIM2y6l4nMYja
 Je4ADBwmiARWrqIkygt3Tgb6tXXLYLgqzwghP/UQqASmS/F7SZk6ZEQr8Ynzu75J2j2J0Eao7jk
 DoDktclH83KNyNgky06A85tKbFXH/SBaNML9JSIxYotLKJqEk0veGubSgdifTk7mDbv0a8pH0Qg
 IMSRTrzP4zTC1XUPqH2QQWJrmJxPqIrozzgdOairNb49RMrth4cbihXJpuBmVfB/brvgx3pHEp7
 AOWTxFK0tQMyRWEsOrLAIjC9SR5P9DWO6EWlxPi3Y1Rz6PwnIIQTdFrrgMlOp+Mc2L6xrjsTpmu
 VY3+Ed4emGEWHAUS8uw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310038

On 7/30/2026 8:02 AM, Linghui Wu wrote:
> When UTF monitor is enabled, ath10k forwards WMI events to nl80211
> testmode. Non-UTF events can therefore be delivered to userspace and
> confuse FTM tools which expect only UTF responses.
> 
> Only forward known UTF event IDs from WMI event namespaces that route
> events through ath10k_tm_event_wmi(), and drop other WMI events while UTF
> monitor is active. READY events are still handled by the normal WMI
> receive path.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00093.2-QCAHLSWMTPL-1
> 
> Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
