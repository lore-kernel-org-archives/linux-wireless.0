Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A224C3438A6
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784943881; cv=none; b=uiefpkAONWNMB97tsKQbpeJm8pj4MCS7YsyFJWw6jMc7Nyc7tR6NnRdZghTdjP9DzEBeGEbWDLmFsnNXeid1HlmAzlkwBV5nwsYpXJRlmxOzqf7wFA9XYA666YWoY0WKMdVWaRgSLvqBl92/mZVbHz7epw7Cs9ApV+uprCxuP6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784943881; c=relaxed/simple;
	bh=IOcelKOBSM0gxgZsfOf3HFgQTLEOn2f28Em+Lgk+IlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=if3ZHM2tfYuel1hfzGdXg+8UH4NOnwYBWx1Uzg7ExT2h9etbVzOsIuHATuTsvsbGKTHVF3yK85ZuJDb8g2BBO5fTfjhycohelStS/UFUFsw9y04sDgY3QsQCOVlxVitoDLPrVENTGd3yagOUk4FFBXaFz3mC9t3W8/SAo2UNOAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pn3hkBT1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jblj0lkR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pn3hkBT1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jblj0lkR"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66P0qRd1660241
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wEhSsyZ5VkLfCaY4mr94Ip3RTnMNE5khCZZZxAwLa74=; b=Pn3hkBT1k/jf5WHy
	1FtTlbzyxivH+0Wt6qEQymUj1IcOIAedUAgODBSxrM/dmUCV72KrOseoufu7WJPq
	DhN0q+429sItcYjnT2lviQ2u0IK9+6WhfI7CoHVWaSvvFgaIc1e4fZDgvaadeVtC
	u8V7Hv9fBdZ4de6H8Ookqtg7QwWAobgKRDHJMaP6Txz3mecEupvHEDYwfJdwohVl
	F2Dqf38UueiXyUZ6xxh8s3fqz9xssqQ1Vo7jy8s4nz1/LhAnyqLR6ltiCVBmS7lR
	dlUxDbj2StuMEICWtQAOc6UaPOqzIu/3E/qIhqenrJxdIc87baj44r/8VFubyvBT
	dmJ9Iw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fm9pd29eb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:44:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb6433e9d4so1246313a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784943876; x=1785548676; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wEhSsyZ5VkLfCaY4mr94Ip3RTnMNE5khCZZZxAwLa74=;
        b=jblj0lkRiOdFa7eGieOw1gQboUe/uX9khh48Tcp7eokr8pqhZ+zvY4s/CWKQGS4HPg
         tUDXBWhs64tsm98yaGe4p9QCdhOE1xNAXxc2cR7rBCOxbMIllCr4q0JxcSAhivyNpDeG
         Nc6p1G/LCYGz8oX/e8f2OMJyfxEOfaP7nxiRXxB5VT1T74Mgus0CduItmH79fxLVpA4g
         rTsskb+T7Vok0sAmaVCFopFWZjOVT0Zdy+aQlDn9gKyUTi1u0AruK9HOgVFISe7U7GEa
         ySbB+3Mh8oPabKrNEHrVgEqj5BuTyjwUZRPPrRWM1Q/wKGhb1PVksFqadSxxsVk7Dr7T
         o01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784943876; x=1785548676;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wEhSsyZ5VkLfCaY4mr94Ip3RTnMNE5khCZZZxAwLa74=;
        b=EcawrLtok3kU8BOWWrZ3IeyrlGWD92kWfNRwS4gv3/3HN/X5qYMoWjjOV/xuBJ/QDP
         PFFtQ5l8eXXefJqPt3/Nml/Vn59loChrkO4oE5RqftAlOuESS99fuuotlle0YbHxsxlx
         aMFoU7ZnbHDU6vLRE/QyaRKtNJKEBsNMca8TE57AWIowENtVwrIBbmwU2RS+N3wKWCjn
         /MNSMHiymaMhcLk9HjYaD0xlO+0WlNbJ3gy9255L0J8YiVJPZ9y1kRZNStUw9HORWkWr
         ieWGn4mNILofrI1w0XvxLRRjE/Yu+nGJdnQqlRo0+AkktoWj78P757VcXaEz0NxtGhVa
         cJ4g==
X-Gm-Message-State: AOJu0Yy6DeuwSQYeBnwpcJbVanxgn0+5mKj4aItn+S3uOf7e6+sSXGGv
	mArVm3KK0rhctsQdtBaop15mXGvO+SWMkTvJWpYcOmdrzN5JGMYYPARAutazy+nwWapCI25Jo35
	j9X6XNnosjkG/cHcPFGdTbznsDQDfm5uQ8pIYi4m1g4s4rWvk9KJ5RmvG0NsG4tPRx/Lxhg==
X-Gm-Gg: AR+sD10ctYG6oVjjQpdwkFShWe8BJKEOmF3znUIjX9RLcaXBuaORMIKUHUS9jjywrnV
	2bRtFv4x0FqAMcYusCxoSw+dx/WXEK9zZ26zvV4KtKx5SBc8Q1cBGUPBlXPmZEc/qWfxZdiCLaw
	GGbmbaOk4b/dCvP2aHDx6L87DXPIYyiB4Y+8Kaq1uIRREWB0Q5RMwjsUNTHDajGj7dmneBS1kPZ
	ux138r+RZ1MhqtEvcvX0b+93wE2Otr+EHGorGMI/7aNHeP8+2q5EiRMMEtiQz5IkaOg60433IEf
	Xx5L1c7yYfQxfR5eryPQ26EhGObj+DELrkUZDMfG28kImBmYnAEttA+fjsOBg39M+HU9TFvqgnZ
	VZiKFdykLHRFlwPTDZ5IJZ+VeRMsJ4EVH4WsH8HQ7yiJC1wR0oa1iwe/BxA==
X-Received: by 2002:a05:6a21:3983:b0:3c0:9c19:6590 with SMTP id adf61e73a8af0-3c67e3bc33amr649611637.74.1784943876119;
        Fri, 24 Jul 2026 18:44:36 -0700 (PDT)
X-Received: by 2002:a05:6a21:3983:b0:3c0:9c19:6590 with SMTP id adf61e73a8af0-3c67e3bc33amr649584637.74.1784943875574;
        Fri, 24 Jul 2026 18:44:35 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a04b2sm3989098eec.28.2026.07.24.18.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 18:44:35 -0700 (PDT)
Message-ID: <c085eb61-6b2d-4556-bc38-4454959466a6@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 18:44:33 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260723013818.393470-1-zhaojinming@uniontech.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723013818.393470-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: SkUCQiJJqBMWmwJgxKcraQp099c7v9bz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDAxMyBTYWx0ZWRfX7Y6r4B3WcD3h
 XoQbdrr0SAuKfvI0EeUC3u3Dr216Byj6Fz+F4zqx9ZBlv9Kj2KWvaaRcQSlWM+s9JqG4t9wlsBu
 n4ZvdQip53j1qlHRbTh9hMOWeBH1KpL8fAB20iQWCNA+fbDRis1jrz2l0ZMbxD7IQPfa1aphisi
 vHBJ7uJck3WR+ZmHbwsK+s64boTSGY9uig7CwVT4JDvba1WUu3XT2DHSTPgXlrPzUd5ohKJVwTX
 6BHtQTFqCAsYcPztYyP2F6UcAmhhty4hZ16a15Ml/RN0ci9zrZIKp99SXNU6070tE73uwEooTZw
 q7MNSGM+NrHjh6lg+E8o60OaTUuX9lrhVizGfzfpZz6KTTb+1GnlhQGSXLamFRkjJjQIPE30w1q
 w/o/W14NWPPX/hpDiIHSTt7iKfXcJHL/0+NqNoTPxZThoutW11Y6d3ZbDhwlEFVrH5ZxpMXFXRW
 MF5gaaO0AQJrlYXXong==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDAxMyBTYWx0ZWRfXwvP0J5L/B+w+
 lkemt1C92DeozUeRwFbbis0ed3Lurif1hWdOfx2UHHPtv1ptuHvL8X1wGx2+ojWAcLKgd2+SIxV
 AZFJkR4/ZjmFY6BSeEFdyMX/KSuLWfw=
X-Authority-Analysis: v=2.4 cv=DLW/JSNb c=1 sm=1 tr=0 ts=6a641505 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=blo6l0yq89oDT-NQHXUA:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: SkUCQiJJqBMWmwJgxKcraQp099c7v9bz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250013

On 7/22/2026 6:38 PM, ZhaoJinming wrote:
> +static void ath11k_ahb_free_ext_irq_grp(struct ath11k_base *ab,
> +				      struct ath11k_ext_irq_grp *irq_grp)

checkpatch says:
CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis

No need to resend for this -- I can fix this when I pick up the patch
(but if you need to post a v6 then please fix)

/jeff
