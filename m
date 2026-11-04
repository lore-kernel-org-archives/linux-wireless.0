Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758875;
	b=TV2/4v7jtjBQjEKlDnETr7CmYsOsvHA49JNsSBt3XhHWWwUOXFmDZYtW/0599nmsxbS7
	 Z42u1TiBOMVEy4+eyyjcD7n/NvJBLywe8zUK7JmPG5WpgnZ7Mbd1iDrf77x6Lv8OjzesY
	 KKYV9hcZoRuGsdcmPsLxDGM6MrU1PeBTWdxUepjZuMw/1WOLISOu80jicWaH7M8qZwox2
	 7STqfm2rXEq6KoEXhGguMRykfGR/vtGMy2SPnlOTkTY/XcFaISn6/SfiqdCox92UEoM+S
	 kDIia6J3ujnUrQDnfrAFRF/gJ7BRlWkEQCRzaUI6dXEXp3gFXwWpD4xjpy2zHoFr77A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758875;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=;
	b=NIi95rwfi2/zl9jQa8TbN1rCmvdM75AtcJffxgQE4GJWoDDPM2KY+sCoOjbdzBMsn613
	 43bPFgwabA1RN9RtXiYxu9DhIG2Zi1I1kxvpicb6cjkpLQI6+h9BeRrAQpyd1WShijPnS
	 Gaii81Dr5Nk15kltW2sxFDuIycGbUDajAhxmebCvPzdVx/nIxQJVa+F7+mtnGD/rADy2k
	 TOCE1KUdkROqr2Q/XMcaDXAt8ZFE23Tn6INhzp2l/DdOKflaE5iAUaciGVBaoaxMwO74K
	 RakkkieWBJ78VpshotDk1bu+lBJ6b95LLlQDwiek2+yyaRLnkXPfWiwnS4lxTPLl+fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=EInuwMe+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iwBglPkf;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888EC606D801
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 02:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 888EC606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=EInuwMe+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iwBglPkf
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40REuV2786129
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 02:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=; b=EInuwMe+tcmDXoKn
	pnQYJRbKNMXqTWGePzmp3X0HKZPJdO2F90PZxpz24BKd+tJnSlZVT8SqlS/HvEsL
	ef4x9eHVE11Z+MOKm1EqArug9F8B76+idVNFWzmj2vVDMISXdxHgPf1OqcYd8Vh1
	t+gPAKYV9XYNICWvDE6+8n4o4Q5V20RAiBcpJ2gKej4qL1zQVYiDBOqtfj0tGt4Y
	YnTGxBPLAWsEA5UmhaNyIzHDo0gVZ+nbRyVTXGX3afMC6I5wyQTj8AmvLDyJtWb6
	RlZ+K/ZB4mmU5JOSNdMbhRx9YG6LJbWVCAmWKjW3UtqwSz1lblu59mpCcWbN715U
	gRuCxA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqhyd2h79-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 02:21:13 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so430084eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 18:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793758873; x=1794363673; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=;
        b=iwBglPkfjes2H6hkL8PyONg9lMcfWU7Dr1w2g2cVNJ118Y/pGBDjyeaPa8US9dWwYW
         6fgFcGeJjLZU9kFv3StfUq6Z02UmlEX9ncihEJwHeTPYs2pq2XqMKbbMa31quVGWDt7f
         5beub5AFwFY8cKv7iORUQ6u5KnJoudJga3Cx57ZM3JugMj9dVA3L2C0HXvipQEmDNd5x
         dJqeDgQ4qMFiBLf39rZ2u9N2m6/jrdYNfccRSNT7q4nwcII8jysT5S9HxXwS2gYHf8aA
         jRBzCZoVj6zgyfm38u5wOKC6Hy05JBPsq6JpmDZKlOtUSnwPZuPUy549CWHXq29OPF1o
         gTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793758873; x=1794363673;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v0pavIzPwVymeJJN8l9L4vE+fXYhkgBPa1pALLL5OqA=;
        b=eOYD6ww5cfbaluuSgIYRo8ivIOFW5G9oItNxG9j03qW5rkE8wqDGRs+qGmyOr1Mjvd
         X+uRubX50VhflZ5XGXlOJGlshfvNGA8A0IQA14RVp+pU6YKfqoZNpDTqi7AiiIl3G4y6
         EyeNE8kbsMjQiv/HlH2WonaL9xp9+JDBPy2yyp8ZcFLeKnQjsBVexbEHm22Ri24F4U+8
         Nfxf776TNH+iukQeK2E2ayuPEdk9fbm49+OD82x3SsmcHVpAUR7DiWTPvW63HoTD2Odb
         QYlbELpOYdFptq3dtdWsxXR2tjCMmTvsXQHVoZ7vXKOy4ZH1sNlFm8u5d24KIl3c3fSe
         aU0Q==
X-Forwarded-Encrypted: i=1; AKwUvBw+pkmMW+anTlNk11h0IRpVVBvltDtDIeJkBwrC2vB2h3O63ynZjXz+h5QoHgudx1fhigWFreqc0GIns/52Ug==@vger.kernel.org
X-Gm-Message-State: APuU4Z/cHxVSKP2Z/MIxOzNnFcI+Q723elt0iBPLoL/U80lB/qW6P1rZ
	ZbcaaTbQV9tEGIchRtKCQfod2+2e01AyDHvZqVdZ4zCzZfRttL0hd3ryqe8qHs+eDMBUJYvo8n8
	KGoK2r7xGowqxHGK2cnzuWfbrnnetZZ9TfQRdc4DVDc31ax6rebDms4dR0RyOjaM4n1VGoVQK1U
	/QRQ==
X-Gm-Gg: AYBFou2FGhJ3DGE+wu5Eugycgpedr3NloNRGk1KeYmQUDTmKaD38GOEOrHbGRBJ1AyR
	YNA5hpRxEKIq6tAasv+b3gNFKZL2KMUqRQv0iaxqcUicojtqHAhy5u1A2ySWwuD01a5wSEuaeiw
	iAr2djXNw8xcPav2vzHAKblhCoLah2pwJluCoC/bArI639xxkSP+AqKrgXWS1HJmHGS/bufQAsG
	YU1GemmKXIC+eRjveDEMSGM3T/3RSM5t/lJ5b+tFpkpZBKm0mKHHUV2+Ne3AfKe6AFHnhQQ3zuJ
	f9Z+6HBNRck1RHs5GvlCdaIUBdghtcYmOXnE9nu6mHSYC1uNI9HAskXfdle3fWAYyIOp7uQ3UTu
	ELaak0deSOZNXAfW4I4m3QHPloz9JvQZv2Y+X8vL2TGQ/3pRpSPXJdSMypDJNKoj3vXX4anfuTx
	9Aea/WMFbS7nHyuXLFKVTmcfVleqGx4g==
X-Received: by 2002:a05:7301:d594:b0:36a:16b1:3f25 with SMTP id 5a478bee46e88-36a42225ab2mr22016432eec.5.1793758872924;
        Tue, 03 Nov 2026 18:21:12 -0800 (PST)
X-Received: by 2002:a05:7301:d594:b0:36a:16b1:3f25 with SMTP id 5a478bee46e88-36a42225ab2mr22016395eec.5.1793758871997;
        Tue, 03 Nov 2026 18:21:11 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca3958746sm2464840eec.22.2026.11.03.18.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 18:21:11 -0800 (PST)
Message-ID: <a5bf19af-9376-4dc7-8703-f4e7ef7bbe4c@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 18:21:10 -0800
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
Subject: Re: [PATCH wireless-next 4/6] wifi: ath12k: register regulatory
 before wiphy
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
 <20261022101836.148512-11-johannes@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261022101836.148512-11-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=bp/Zl0ai c=1 sm=1 tr=0 ts=6aea9699 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=10cwVI0W7ijM4euAjnoA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: _TSzigWdO76c0uRvMXYw975z-9Tqc01P
X-Proofpoint-ORIG-GUID: _TSzigWdO76c0uRvMXYw975z-9Tqc01P
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwOSBTYWx0ZWRfX0BRNWiIXTLOR
 8YfXHPrE2Au46juQS6rWj6pqqTMHtlK7Xc3VJYRmEEbeZDm5g4ET2/v21N63zDEQVyjB65oRhBl
 +zrjpgHKaPYrI7vpveCfS4cZh/VfeBk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwOSBTYWx0ZWRfX8jT7psfA9Mvn
 /fGCKgGQhjlraWZtAq6ynXZa58I8vb/epQFZDXScSFJ28uOrxMf2cxfBQb1RZuoEkE4QUwQSS9z
 XLWAgnhhfP3tkecDn7xQbQfyJj12Fngk/8jT780sLU8DN0Rxz9ZQfZhf74EmdhVE+uTT8CQl75v
 UfunF6QpZbkzYDXuxrIciP8x+a2nSsyVXCYh7eYlMENzSnsZqb99Hs+fPtSZCiXJPb7Y60YVFw1
 HFcLIUWhUw3jsrwES1HenSFWKI2RKyR66m8JSAb0WiNC1fBkltHAtSHxt7ZyrMdcS5mRc5tteVz
 /bhQo37+XbIamv/o5lIEr2IYp+VMn8s2RZFxBPr9Ju9R/Lxmlg8eYi/hLmlFeBndaEyBYV6j7/y
 WwdoDfdL3Es/SHfDYbx3EilUDYRbbg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 bulkscore=0 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040009

On 10/22/2026 3:15 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This order is going to become required, since userspace
> can query the regulatory in the window between the two
> registrations.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

