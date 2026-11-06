Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929456;
	b=BZKo589keYdhB9S2HKLRbwGJg87SjwIqdPDoEcYEUu5XJl+PMs1x7Pk8kI1bF/aq9rGG
	 x068rTf18FEbzVJ/lxqYw/nBt7Y0FoqO9WgvCPuCngse/n2zp6U7aXp6SOlLMGRnXqJ9m
	 w5LBE47eOo2/68v6ZoyiCq/naRvcWLtu7iTZzHokNVuSFX2mm+3McpfTcKMndDHxoUtLu
	 Zf/jnA/h1pZJzGQUFFUvCURYWMWXjRvvIFSb12klyPZjzzEvwAfCIPhC2azyvBQDQeKHN
	 w8NrDVsviw/vhF32XB/kiJx6fFdgWzi+HuJALNYVYM7b2REKYkho0Anv6N2XtaCh8jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929456;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=XZ0doRV82V8OV3xBv1Z9iF7gsEs3UjmD7j7kB7eOe54=;
	b=BNC+8NBMMQhF8fU55yjfNi1aQnVHP6nky7mHCgiE62/vvCgR4p0czdsTWKGs9FE/2rpi
	 lXsSy25WvfuRQ/rbJM7Sy4D+DfMNWShb7f1jYEqTCZtwAzzQImUFhA1Y/iMoyG3Sti9I5
	 OhgIMfjD/vFpbEjSL9/84qgvKZLF4PCB5iDBFk9iZIS7m6e2xqsESRO76N0y5iIlgiXTC
	 MX19BMXdeja2ZgPezclJKVSLDJ0YoYBeQrIrdjVQGPCYwIeXtm4bEido7x3wAUi3D0CkE
	 eseAhR4AbfRIuaWX7pmpa1G3e04CWCqXPMhXtAof4ociTTJcAsi8FHukAEMxyj4yW2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mlUPnCan;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OTJxQSdj;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E7B606A329
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 01:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0E7B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mlUPnCan;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OTJxQSdj
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5NeSj93295494
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 01:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XZ0doRV82V8OV3xBv1Z9iF7gsEs3UjmD7j7kB7eOe54=; b=mlUPnCan/3t3mFdM
	XIvjGzAN+I3x1qdwJJQx+3awsqILjZuI1ZghcbCCK66tgFHEObxlulzBTz9NPYQH
	SvCHKGVWsV3O+subaeoZ3c80z9481k6WRqh9gFQK4Gt4F6ZKBFLhPp75QCnfqzTK
	eECytNZHny7X6i0DibGwbSqQrjxcO2VqDByUT3zkmVUVUvw/JyYez2iEIqM6VGIr
	p6cMOMhFp3xc1tz6KxN8T5RxyLtpd5HU7hZBeuTa+QiO+3SVfkuXukkgNsPZ5gv+
	vATTggsAnapLKdi/KzWnH2hUIlhIsO32X80zCnn0VGP0rcWQ+cmz/H2VEYR97sWa
	laZLdw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9rbuc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 01:44:15 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-36de26cb4b3so166053eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 17:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793929454; x=1794534254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XZ0doRV82V8OV3xBv1Z9iF7gsEs3UjmD7j7kB7eOe54=;
        b=OTJxQSdjyd3shV+EYriLSqDhtWZLFCRKnmh0RLabt4ofnUWO96+zc6NJp9xh+znvjp
         SCnH6ygOznyub5Z8ZLyaJPbVrrhALEJIgCuRgjZW/v1EJlYR+U1q2PwxWna6hIBO/uLF
         urjxs3wcMZgszsFAmczbSZIDXtBDyc1/pXAI0b7f3p2smplcSOvMbo9nqOntpN3+mruH
         mcAQ1+7x2LCToHNgCUgJH6WG1UbaKNTsUb7AdjYqcG2d/UtY024/G7D309hXPMcUnCsn
         NOhunyLUn/m0SpnBea1dEPryRFQ5lStBzD9zcKJkWFXLfyaPxjPyIgPjTRWv4MJiTwru
         hKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793929454; x=1794534254;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XZ0doRV82V8OV3xBv1Z9iF7gsEs3UjmD7j7kB7eOe54=;
        b=Yu3Q4ZdML38tcPeBqsDGtnKXyv3UKiknqZWKpMFW7nNvKn0DNdpZDJe2f2QVDXjdus
         IeEfx0y/C/kAJvur0+NhBpSpMqk1LcBJcEbIpv9eimbuzMrYZIY01otpwG17jjQofXuD
         FYFoYvKLacrKLHY+2nTLYy3t8V2jDrWNgK5alf4rlwnJkEwjEWIJSFWFsVBwHDMqeZWn
         4e4+saVXrUXeG8az86vbiAw0hR+5WDexhmaSgKHZxivF9cvYX4LBMROUivOZBMr+0ZoF
         Lz06YwCxX8mgm5PMLiaWC6ApbFGps6+gzfTYPSWuAdCFs5PUuJZNAr0r0nFbfLvSYnUN
         E+EQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYrnyt+j57Vz3CHZSIBbnF6aob9igQYVRPhcG113+xeu19I/mWMSEdRp5qocb70SJXNpe8KLxBk+L1pWFTwQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9DhSaYlZRtvWdEPNzOtbh3XXMEIEWf5JYDuJjWInc/ILBQ7g/Z
	jjE1ovOgFc8mVNxMigFhGOAUewtzJKsQ9ALZPG4gefsTLzqpp0lZbyhbOMU3uTJzeuif1C2R3Cd
	bxc1Yrq4YB3UK6PpIc6TswYSULNK1k2fVccsM3GlpTviVQze/SO5LjgyMPtuklcFCPVHFbQ==
X-Gm-Gg: AYBFou15XmzWvuN24uXCTgVEyU5jme7lUbpX9hIH1hLFu1Q+2bGA/cvJk7GFshJs2VR
	wA7rwjRxVSzvqSkAJnt9utfjgc8iKHJgFiV5Nj8ZCXXhCxShcbtWCitguD4y9nf7+7RpddqUCrY
	bs35iCrLw4GA4cqvDtAaetPMsqs1+1mGrSskXUkQ/Vvx4moTO3MwJKe60J0WEB0MQL1iKNJmvf2
	snFA4l/GO6ZuhIcDTji+sb3243KUAHxX5keRJOyBWzHv2YHkKmjSOAgEgGCa1Z2/LconqhIXDeS
	Xdisi/gFRSUmRr8tcMPy3CPHdrV3S5qLSOgg2wL+AdT+7ibiHQwasq0k4TEI38iUauBa7gc7kZf
	nx0wXadxxCLf0A34+RC3Y1Jx+H/yMmjn1floyIiONayWO8IMfsB7H0jPay6aNkZ0a2tYDzMm7km
	aUTTw9UAXtvSmpTIhVGPxNDH1nYeCBIg==
X-Received: by 2002:a05:7301:9a8a:b0:36a:7b3c:4e0a with SMTP id 5a478bee46e88-36f772fb22bmr1199233eec.24.1793929454232;
        Thu, 05 Nov 2026 17:44:14 -0800 (PST)
X-Received: by 2002:a05:7301:9a8a:b0:36a:7b3c:4e0a with SMTP id 5a478bee46e88-36f772fb22bmr1199203eec.24.1793929453503;
        Thu, 05 Nov 2026 17:44:13 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa97fbb54sm1338870eec.13.2026.11.05.17.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:44:12 -0800 (PST)
Message-ID: <5abf5019-590c-4ea7-b732-d50a287b4c43@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 17:44:11 -0800
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
Subject: Re: [PATCH] wifi: ath10k: Fix potential CE configuration leaks on PCI
 probe failure
To: =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20261104-db9e3c75b3-wifi-ath10k-1@mail.sdu.edu.cn>
 <CAFEp6-2xed2JR-kX2a3cbTTtTF3nUX7rNS0hKMew=tn72Tv1Og@mail.gmail.com>
 <AIgAAwCVLF71acoERh*Biqob.3.1793862443170.Hmail.202321181@mail.sdu.edu.cn>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <AIgAAwCVLF71acoERh*Biqob.3.1793862443170.Hmail.202321181@mail.sdu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAwNiBTYWx0ZWRfX+X8rJNcZ3m0N
 AGv48RTxH06y7MOxS7IKb6k4IUQNXNEsYWF05aDxkynk9SwmZ3dK29vo7/iLSEKhmoPBIOo2i78
 jQ0oDbHJ0QkOOp4aolsNEaTclSBH2QM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAwNiBTYWx0ZWRfXydRFzZofl/bI
 irsIGNwz4IO6BkLiYJF0rAb4WIBkXyXUBBwhx72inGpaFo/Fqv8VSSJsWdjJXMEhG72hBSsErJ8
 E2mNCUxyY3Zhm2r3ctZEYbNiufLmoJT/epU+HAFQHRI31zN1AkXIeTHRMRp6mSp3L+ELHLYhZ1B
 WW7v8y/Jdl7Yx4Z7k5BuSK+zC58wzWdk0/DBsjkoCTBm3jh0YJSOSL7SmiUR4Cvrp5QgPkEiKAb
 vMzLVlUQKjJcOrcK0NzwqEupGdkIMq8qOOkrA9bi7mn0ZlVCGQ+FhgEh5V8etrSR9aliOwZ+mts
 48lSYHVVIijLFv/3eaVWvnv3hKepAnuGLq/S4d4akbh/kzW7Jq2rWXuLbG+QNmzfPGA0dZ3KcM9
 SB1vO1JCB0ijErYYGDMxU+UWlfzo04MiS+BoOjc1iUJHuA0EYIcr2/z/t+jZwj4EjQqjsFj4/Cq
 mvcWcEQxmbd5cXIsiuA==
X-Proofpoint-ORIG-GUID: rj2TmZM0I0jf-zNuF8ErO3GyQsZBvp-X
X-Authority-Analysis: v=2.4 cv=f6Pdl+yM c=1 sm=1 tr=0 ts=6aed30ef cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=LnX6OugqW4TfWTdhpNgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: rj2TmZM0I0jf-zNuF8ErO3GyQsZBvp-X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060006

On 11/4/2026 11:07 PM, 李广硕 wrote:
> Hi Loic,
> 
> Thanks for the review.

Please follow linux kernel e-mail rules.
don't top post
don't send HTML e-mail.

Note your reply was not archived or sent to the mailing list because it was
HTML. I only received it since I was directly addressed.

You can see it is not captured in the thread:
https://lore.kernel.org/all/20261104-db9e3c75b3-wifi-ath10k-1@mail.sdu.edu.cn/

/jeff
