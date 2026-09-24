Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A948C443E44
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240346; cv=none; b=CjkIaOHCawQosMsyUdsVJOEaWs/r36b1wFyzKQM1vwrwZEpiUArVpQFyWpxWIDRFzlq3FKSWyzECFUNqeefXmMxcL7IYwXJRWDBG3TJ/kvFU51b2/m7dwtUvK/d4uktuN2i6sZV4cdVT34WrP2XWEA8Q54XOFIXp2hCyZO9/sR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240346; c=relaxed/simple;
	bh=MMqkdQEeH0y0ZhZk9H0JBoQaM9eKcyWjI2P43202SHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AyMA+aFPz+p0FlI60yL3eIehhF791JY6GXMtK3/+UTdiASCpIjRmyhesocda9W9ldZ53T3B5KxkxQKPsN33sjELHjy/skVrSYAKJeQ4xyVghNhRWYS+JlBAmt+YBDXiHZq/6ZOKU2OjcEAdS+bPu4eZimxN7ITl4vVc8uyf9PRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JJxPL0jc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UqE0lpK3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JJxPL0jc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UqE0lpK3"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eAuF1531708
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	W2qmIEuI6K9ZfvbWp+8gw4YZugR7p65Nd4cMUpTi15E=; b=JJxPL0jcJI1kru5v
	q6Cs4SWFyAH9PWvEQ7aZVwFmh5S59ChGAHP08SrxVlmcNa2LfF/r1CfA4AOQMp7O
	cUk6to1M5uQ2P9F6hXdelRkQ/jW2Az/C8mMKlf8yKay73yL/RFvzOhMqTn7jl1G8
	KJr1Fqko3frE9HYjbya45M49vK+l0Nan+UTt4yRPwHixcwhRNImWmG7QObrmPRuX
	/5dsK0SdPG+YSOloEMohNQTt9IF+2TIhYTGNi1eWUixY8dAQgh2Grh9CYW/lbiN9
	+fYJHIuArdk9F5tCYNkUwWMszFUo19eFnBzSSc+1DXLabK0ik9P2TXaKCutUUxfI
	cAYcNA==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvsfgskru-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 08:59:02 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1437272611eso2843122c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 01:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790240341; x=1790845141; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W2qmIEuI6K9ZfvbWp+8gw4YZugR7p65Nd4cMUpTi15E=;
        b=UqE0lpK3m6tGfCy2agRKiAUAgP8YtIndvOHB/tzoGJ3svk+oy+1zFXG8UOI7MsY5mn
         unSpVF8QPYr22XvFCQOVJNheWzxXYs5OgSdWZeIVpPNW/v6GPmruvXOL5xVsZa6Vol02
         wQ3ztJxgltVnyT+CKVFFYpVaz3VWa0HUB88Om3CpPXO7ketdm5Q3b4PbiSJvRQl7IzQp
         n+S0u8hL4VmGhfNqNTm4PfQRIwaCnJ9lBa4RvSWJPDLYTc3LrJNJungSI3PwdMVpUcea
         bVXZusbDt5VuSQvL3AmQuoK6XPEjKzffBztZKSFNUV5d6NGTmAJ5VZCDZOtbsdrMCI9D
         SjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790240341; x=1790845141;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W2qmIEuI6K9ZfvbWp+8gw4YZugR7p65Nd4cMUpTi15E=;
        b=akWW2GPQ1VNJz5AoTLdSCHi99oCsjts6tYiaHTORpzjQnx/ycUypzpyoIJex00hwAU
         jWtxF2UtjerZolvFyry61JbK8UolYay8CPqPNZ1d8pxtcu/HfoA3UcAZl9sOUgqfj0nc
         2XmvRyvh5m+tef8DrIIBiSiTbHPqKbt2+shNsx/Z1vHQ1VTuT0tT1ooekyucLvMfYHEW
         ILX86qFOHj2aYT4hlO3+aGDVJIjOFiEuroCL+qE8ozq0aHAVZL1M+B8aYWwqJSwrBxWT
         NNR8Kj608qUxFNdWevwarq6UagqRwe477e/P+/av3H4NuL914tzMLMxh7axXrj5VyJFs
         vhnQ==
X-Gm-Message-State: AFuF++k9kUcepLmsg3xMXv6LMXsVPV6bS0+kQKHOAbHXsek+/Lm1ZYbj
	qhgI/TbaxG7ebwDJDh77mBBNANm+Qu8jW8OQO6mz3nzI/mr3347AjhLx4p+EROqKmCFB/olpqh1
	l+aNlJEW4X3zRG9m4Wy/Pa8Qw3BYVzWFpGAYnrb7OhvcOSpR5xTzy1MNkzmOpTv0goDcePw==
X-Gm-Gg: AYBFou0IUiWidCQ/nuZil9nvhGt4/LWfdnGRuOrSmNAnHPQcaJaWQkMaKwn++ebQJ1n
	DxHPfG8R4A46x3DncOu8Pzm0PtvtnTqdZOOwmWvq1GxMZ6uINDYd0/rwg/TQ4YQZGVQvHTAgRig
	jyuDPFfY8vq4SqPi/KSKFXwTlYoTP8DSqBOO6fAHqMfK7a8YoE6ZO7cvGYLv5zD5KCKKLdRIO+R
	XK7GfW1yMMq76xPK3KSCgepoEcGR6OMCFnXLob2j7VXZVjOmmXF9FiF/e3bPzeCReOdneEGGPvR
	T0VOxMitlt+up+GQjVLQ6VwEWKlmthuS2TYOInbqWLfam6MjzuGDJvE7GTU3Ojg/JHwHtwnqWDd
	7suyICCR6iih7frkPlRBCaQUllotSIVHsfA==
X-Received: by 2002:a05:701b:4241:20b0:143:5722:55ce with SMTP id a92af1059eb24-14503fcdd8emr1532958c88.38.1790240341430;
        Thu, 24 Sep 2026 01:59:01 -0700 (PDT)
X-Received: by 2002:a05:701b:4241:20b0:143:5722:55ce with SMTP id a92af1059eb24-14503fcdd8emr1532939c88.38.1790240340718;
        Thu, 24 Sep 2026 01:59:00 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f949e51asm12621558c88.1.2026.09.24.01.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 01:59:00 -0700 (PDT)
Message-ID: <c9f28565-28e6-46d3-aeac-c78b6d86fc32@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 14:28:56 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Report parent AP BSS
 parameters for AP_VLAN
To: Johannes Berg <johannes@sipsolutions.net>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Ganesh Kariganuru Mahabalesh <quic_gkarigan@quicinc.com>
References: <20260915052923.3300269-1-aaradhana.sahu@oss.qualcomm.com>
 <48ebf25d157b8c12dff724fb1f6a97a0b45849e0.camel@sipsolutions.net>
 <ddaf2702-b33e-459c-9efd-098feba33243@oss.qualcomm.com>
 <ee25d1c927d4a618384eb05a210b0f9b2147d055.camel@sipsolutions.net>
 <66e6b21e-843a-44ca-bf77-30441a80510e@oss.qualcomm.com>
 <b76bad90389aad66d9082428f3c969294c6a8d74.camel@sipsolutions.net>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <b76bad90389aad66d9082428f3c969294c6a8d74.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=YfoodARf c=1 sm=1 tr=0 ts=6ab4e656 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=LQgjkfhuwCsdZD7AzKAA:9 a=QEXdDO2ut3YA:10 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-ORIG-GUID: Wvjz4ne1CBClNnd0_l6_DFCLhz8Sh-Pz
X-Proofpoint-GUID: Wvjz4ne1CBClNnd0_l6_DFCLhz8Sh-Pz
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzNyBTYWx0ZWRfX6ojqOFb8Li6x
 oVlN8h0q/bLUH1vFqLELQjdWFk7gTng2U7OqVZxqUxJVssh4piLUWFvh2fFkNS8zLW3HYaMA85X
 t3Y6bUPTAowZEMlZxWTxzo1sa9IM3jw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzNyBTYWx0ZWRfX2m2kIyA5idR4
 LcLw8YhRNC8tY1weMHkgQDR5h5uEZ3VIBY7Hr4jsmukdEKF6lSBBltL57HKk8D3yS6Z7aVQ19p1
 PzO2X9kakuF6xxQBx1V7HDlSYH5ql1+xKpUKcz74IkvnNQiNMxHv0lWUOpJPNOlmQ2zlsT95QA3
 daLaueBdoyVfVFLxn+mVB4tCLmdbqTo2A1MxGWBKKUO3MrGwI4YIZXbdA8vv/9hG6QAaizvVEmZ
 SqYKM0rHvER12ZRaKRI4Cs/IetbRk7GWBNKWDuHNK5DfA+AxJ/RAgnPA6VV6ch9ErBkyXWnZT5v
 NFuyxn7I0rqcfXE1ipUuQbZPgypaTGLTLJCA6eOpgLaPcL65lpRlpxCreuPp4AgilEfQ+jUc52W
 91TuqA9jd+A/GrgnaqpOV4EHcYUgK50a74QHa2s2/++56L+g/gQ1NmYxAzMbnRfyE0UL5uazCUx
 WDhB2iko4Moxl+scKhg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240037



On 9/24/2026 1:44 PM, Johannes Berg wrote:
> On Thu, 2026-09-24 at 12:35 +0530, Aaradhana Sahu wrote:
>>
>> Would it be reasonable to remove NL80211_STA_INFO_BSS_PARAM only from the AP-side station
>> information, including AP_VLAN, while retaining it for the STA side?
> 
> I think it was added for the STA side, so likely is needed there.
> 
> johannes

Thanks for the clarification. I will make the changes accordingly and
send the next version.
