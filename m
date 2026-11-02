Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634072;
	b=4kLZxgoDgXn7E5HzmBtM8emC/6JH2yOKu2+Ke4vK6N6WD1ZzDG1OQ6hIbXyb1iAc0I0i
	 PPpy1lIO/J0PV4uQ+wtYZOkCtK5sCzF8zwAayaUMjgzI+R+GMdEdzBBkOOMiagc0AoAkx
	 QPbc9muR+zDYqZHcI5kwyX+y+pPpUr+qxmMad4FYBFXCOuWG01miVC9Nkw20G3ltT4kKl
	 Nz5z8sUVPwdte+FoJ7PLLQzWQK3JlKKjgd8qgHG2ba80XBgnLjUaFIL4CXXjXZK5coGOq
	 lau+dQ8WIJshSLsrzhpjfLql5QVnQV88k9Okf5idaTSSeFVy7mEpbrNUWPo/m7lSQDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634072;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=KSM0LPJ/twbzspCAfiN0Ld78WI3u57X0mIKF6RhiQ68=;
	b=nwyaSbAyeMwYBEg/JTRQUmL3LptdqChDf+ENBzSGf4QrIdNROSSR2HGt7Lzn2WAgS8Ce
	 kxjcrCJjvfKCy9LzfHnOH4nF9oIsHkvelMqiVtkfSym9ngsGKvcWe3S8S5+EhoqjRvAF0
	 UipkMuf3r7fKJ9XYA2vFoLV0Lum+7o25LtZvmacYM0z0MEG5xyUug5egACZQK05YwCThC
	 CvgL+g+cAncRr/kd1RUal1UL/F8J0PaCAtxbkyqM2Xcz3jedkeosmEhQyAb1NTqI1jjHh
	 NxbqHQUW6NlSUhdcIGMQyFZKR30aEcXqqBEjPbgwNL6itPSYuyL6WqAoFfdkDui6hQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LMVBN3gn;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Frz/jIoP";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05FB6072C76
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:41:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B05FB6072C76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LMVBN3gn;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Frz/jIoP
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2Dp9Nt4033827
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 15:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KSM0LPJ/twbzspCAfiN0Ld78WI3u57X0mIKF6RhiQ68=; b=LMVBN3gniK+oKSaj
	8Xe12UZ6/m3EG2h7l3iypzlJP0ERKiJSCUZHi0Q9i5ohZwbTwuSlamv621hqQkEk
	vTM7JvYpY0z3jj82lIbfc07Lu6OXQBAKsb1+b74FLVCQMI1d8NEmimlDgq5lR+kM
	WPf9F/8Mgui5us3FLRxAK9QqyXJoaH1YsT/7ElNtX8zTfJ08/bRnRAcW724Ll/zx
	bNkRKQlzrUp71VtlWy1LFZNdPxyU58XnI5NiZ0ETa4JMnGGAg1SBH/oSJLfCi0vc
	eDziGlzs7F9x0yh75wHQisu35ZUb+6pyBWl6QGIbF6UGqqzCSoTHpLBJylLrocwz
	jgHIig==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hppfe9w74-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 15:41:05 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a3451ea93so5018674eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 07:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793634065; x=1794238865; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KSM0LPJ/twbzspCAfiN0Ld78WI3u57X0mIKF6RhiQ68=;
        b=Frz/jIoPcvowYrQr4gnVw8Pac2Q/a9vn0ZEW8ljO/2PO8b4+0LwDDE78vlYxp+TJCd
         fmXHaVGc/xVcdRyWg6ARtasiOtwn/bxtIXTZ1jFqf0RKk8d637C6cMpFhqHdbVyWdLu0
         +QYld7Nu7PUyRNdq24+TozSMIDL9WVb5XWdrGTlE05Xs0dqc0nsJ4ea2xTyLrDcILQUG
         aaGN85kqKolD4/kgD4hXwRNHBZV+O0tzF7ZnyCGi+1wngJ2lSe/fF3NUG3u46yKOq+/K
         9VI6zl6ukMD/UyEcU9/c9FBR12XG+BpX2XWfLiiNj5/F5cdznnsXeUintiTfgMgEsxHG
         aUJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793634065; x=1794238865;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KSM0LPJ/twbzspCAfiN0Ld78WI3u57X0mIKF6RhiQ68=;
        b=fQdLk9Yfq2mpQQFxeMZmIfbI7XAbP4iTZsKMJEr+aaE4Jr21jDTqjFDQdRjEF409Nt
         cbrgi2pecYqGX4bEhPxUBgC/NESZqNyrkXccoig7S+Jsp6+mAdQrUvCJxdxeZJxPzXQB
         lM2A9/4x0KQDPu9QBkLtDSaxU1oLpEhbvmQ3hVzYy/knSgIeleNxi1t2lHmcuBc1N5Yn
         EAjuvaHz06+wLah1dZX+HG1mPU6RRGTLfFo2vPAVfQa+N0/nHPmhVBQyAg5aJKafbm+U
         xA28CsJdCYa5lfU6i0ebw4xuKM/qMvVcSIUpyrT9anLrbUdJROBKkOOpnUQp7Di+Vu7U
         DS0A==
X-Gm-Message-State: APuU4Z8R6XA1AhjAOVdZRtgP5BGj0yW1qxeUTuySAMlih+bfCmxD/ZtN
	i1tpg/2IR8OSRTEqFw61MWOs/YpiL+eebbm3S49QKYg/MMHO0dDYzRd2VhnOROdgyUfysWzL8WJ
	lR1nk+rPgkQ1hZ14xuAaBXaP/TDj71sAYriTZmWh0hVNAkcQjABFSmZhfBGRbb7hrrx/EPw==
X-Gm-Gg: AYBFou11tFQ9es13yuw68nh7ieuMxHiLHigfV5ia2a9NfKJbQ97/eTVumMRPDe27uvp
	az464M42ZC3Qc0XuzuNgBGYPFhJ/TYTozrGY4MRYzQAGWnD/B93cl4e/pD1qDR5ziTz21eZuy6a
	yxmPzP3WQvUMGlFTnBFesxCJYC/PEi74NY42vE97LIzK4l5dVbTqj/NrtJmK9ZJec6+eqzRQX6p
	11e0MGVs2Auwn9BRvrmge7jbBr1IKNj1mtThGD3jb9y+T6f8CqvLPiidoW4thIukwfI/+/ECrxh
	BYyMCIp4ymIyLQnJOT0j9rLHnkRm7QqqGYNOET5FCXkV9gALGKaaI94Qyrk5S6Yn49jXScVinkk
	zPqMqc+TOKoOh2ynbULUKu+AWW5bAw38b4k9KkzBmfVKbgfYYHKS3zMddb/JHqyAYPi6wAZ+kln
	/RAEjMx92DmhiOl/OmvEUK4TOyOydseA==
X-Received: by 2002:a05:7300:e9d3:20b0:369:fe81:a575 with SMTP id 5a478bee46e88-36a4243ab94mr18693233eec.35.1793634064880;
        Mon, 02 Nov 2026 07:41:04 -0800 (PST)
X-Received: by 2002:a05:7300:e9d3:20b0:369:fe81:a575 with SMTP id 5a478bee46e88-36a4243ab94mr18693184eec.35.1793634064211;
        Mon, 02 Nov 2026 07:41:04 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42a5fb97sm42243509eec.23.2026.11.02.07.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 07:41:03 -0800 (PST)
Message-ID: <936d7fdc-fd79-4869-b39a-7219d2ce4979@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 07:41:02 -0800
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
Subject: Re: [PATCH 1/2] mac80211: move static function from header to
 referenced file
To: Omer El Idrissi <omer.e.idrissi@gmail.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
 <20261017155509.128114-2-omer.e.idrissi@gmail.com>
 <b60d12eb-dad1-4482-89ca-155dfcb410b9@oss.qualcomm.com>
 <2070cf87-bc38-4237-a58b-6554572a8842@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <2070cf87-bc38-4237-a58b-6554572a8842@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=SeZi5fRu c=1 sm=1 tr=0 ts=6ae8af11 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=Jp9NQ60Tfon72AT0SvoA:9 a=QEXdDO2ut3YA:10 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA2MiBTYWx0ZWRfX+NH085lfBOve
 N9kcGUjHOTDuSggqZh14LfZTmm3b4/iGkVVrq8kV9AnfN6IxCltQmsd+W/Pr2L3Y6ew0Jrx/DaY
 BJq0zasCbFGxfZs493eG/ExZ2lcUhNREaP329AhEiHwCVLe9y+GY3h3gVCmBVRC0yxMIhoFY/fm
 V/xbYcSLQxWe3Cb74AIYCroVvnfDfKMa9ZZISbyfJEUkxWR7FMKZen5qu2z9QLrNoR7+knQuQUE
 wT6DnoeXWI1xSGISzpxqruHSd64X4SQ2bKqxqq7giFue77eriB+j2zjd396MDYCka1xUZnsc8iT
 v5qQAD2+pl3dERMx/g2o9WoKEe8cGoz9Qn7IexwKYWGc9PUB6yOclYffQO8hwqIsptobQ4X2caU
 r9yn7WoYfCmFYdCMIu4AO+3SqOT9IIIJSQQ61p51M3jRXYXxyb8ND7MoimrV+/OFKfjKDCyMkdz
 jLYe5qUnU1H3dY4uX4g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA2MiBTYWx0ZWRfXw1GQ2+eOUSFc
 YjjHAIqB6JOxfG7w7ubm12iA2Vx2ZypTzSvs45AVQE2y3AQZurm6UmiTIocakO7n+HdH61wSVv7
 5QHazQhvxMCiQ68K0L49Pk2lT4o8s7A=
X-Proofpoint-ORIG-GUID: zIbjKyCGVQXBO5QM39pEMao3vNii8Fgg
X-Proofpoint-GUID: zIbjKyCGVQXBO5QM39pEMao3vNii8Fgg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_04,2026-11-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020062

On 10/30/2026 6:21 AM, Omer El Idrissi wrote:
>>> Move static function from header file to only c file it's used in.
>> why? all the drv_ inlines are in driver-ops.h
>>
>> first rule of commit text is to describe the problem you are tying to solve.
>>
>> don't add unnecessary churn to the wireless code.
> 
> i moved it because multiple files include the header and when those are 
> compiled they don't see the tracepoint definition because the next patch 
> ifdef guards it under the same config that enables the only file the 
> static function that uses the tracepoint is called from.
> 
> this static function was only used in that file and i didn't see any 
> obvious reason for it's existance in that header so i moved it to the 
> file where it's used.
> 
> commit messages are kept in the git history. should i send a v2 with a 
> better commit message? or is the patch series problematic otherwise?

I can't speak for Johannes (wireless maintainer) but I would not accept these
patches. There are thousands of patches active in wireless, many of which
solve real problems, so the maintainers usually don't have time for "noise"
patches. I have over 400 patches in my ath.git queue alone.

/jeff
