Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929665;
	b=KYAt71w9NUhWpKZiSPXfOpvGzotoFDfDx6MxQEa/RIiXBBwHVT8krT38kO2euX9Gswq8
	 CcpzkXMSaV0uaqz9CHSALwD7G8BR6XwUKNY9AHgA/VfZZHsCkVpxLlA5vCCvT1h75ZleA
	 9fje37/K/fMoOSB2PuJ+srV0KdhYqklIjYt1Nuei/GkOXi0LtUzj42Rb5bK4XOkemqMIW
	 BbS0rI1BKiTgBECW4ga5eiukCtL7xMPXgrDirFfT2e7g2YXPCml9lQypEG5uQ5YKEJlA8
	 WBvlK+Lzrc5O30IFSGP/jW1veGHwdlZOHkhH7igBKuvYKVYf1HRD2ogHQDxEIz0yeLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929665;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=APwff/4lOA6lQf98tIGJwKSeLdMqiBGJL1c6dl82img=;
	b=a9sUaslnrEB1B6SF+fLRUewT0hnSe6dlsh6Y5G7VXb46QXzpN/Eot7KV1VH+DUZeOiuw
	 k3geZ3zarKJVR8FoGhghHhjZAtXxn4gHfOx93GPF7EmTuaUsPyBwWrT4nXMWd1nUpGgSL
	 FsrxrEtjIOreEemy+Bi+XIN78ul8Vj7m+uiWvq4mXjg+GoL+wpqT3tDu9etGyW3ow7vJZ
	 CSuAGloxBcma6F4X72ChbVlWqaTgLVtp8KnBau7zcGumrp0xJdg8oy7q6PXk0uZQbrnoi
	 O9+5UasPyAVYt4r6HHxV1okGK2pLehgD/9c2DFpO05hLWAM4SNkZ64OE03cfXbuk9Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=O3JN+smT;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hEG91ZUo;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA88606A31B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 01:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CA88606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=O3JN+smT;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hEG91ZUo
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5Ngk9p664764
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 01:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	APwff/4lOA6lQf98tIGJwKSeLdMqiBGJL1c6dl82img=; b=O3JN+smT1WJQqKw+
	h0JvABzW7yFbgbjE4Oev94p0x0/YgPCN3CGpxBpX0re/J2mBHqgP5B9TjFEjjX+O
	3AXjLTTY9U2AjMgdehKIwfA6yl6nT7ffjqTPKqkevgtofg8IdmK9Eqy3mMZdXaRP
	qCVInGDNXNYvI+ps8UOxcrFiixvy+hlAkvLOaFxBUA6jntJOK/EFJTX+Jv1Uqj0O
	vb+wEBY4X6Ikj8W/swoHnMWKPp48cayAKtSqVqbqOFp6nXPFNnCKdk1O3spvWQEM
	nxddD7S8+VtUM80H/4XF/QstMC4SDI0tJ2eJ3DfnIeou6/cES3n2PWhzf//s+DiB
	VYoncQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pc8ca9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 01:47:44 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36d2d353a5aso178124eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 17:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793929663; x=1794534463; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=APwff/4lOA6lQf98tIGJwKSeLdMqiBGJL1c6dl82img=;
        b=hEG91ZUoefrE9V9cG60Ywv3nEO0ed/uHjHz/8EKbK9k7y18SIyB6mFdpvxO8/Qc3ft
         xadEjAGGTFUTjfFgrc9+EtBZ1sMIlD1BQjCFU+Of7pIH0pgeJ0MR4/8FLVA5y0QI8B08
         re9TVN27Myf5SYHOMFYQKYnR7bzJw/URdXwJIkv1j+rMnByfZIuPN4k1ZADdulBJNOoT
         xxuyuOJz3S/+EUvVoE2CfWLlHG+RNoyWyb6+KWsX2CEvuKRFmK7l+SeAEcAzHr0BnpFe
         Q4wQPW8ARQEMkvasaKygW/rszOdw53nbWr+wZVUyA5FDuPSkGnBYJjxfPvLN2Q0CUcLp
         aEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793929663; x=1794534463;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=APwff/4lOA6lQf98tIGJwKSeLdMqiBGJL1c6dl82img=;
        b=cYPYanFP8G62OY/cMoqbNZTrgim6Kf3G4B6liljAWlq6ks+RWRtd7VHFq+UvEbamqH
         J6bdM+8fS1LPbiJD+QymM1zlUwl8x2pLEDgHFtb7tuijDFLeMfYOdehOy1xSASjVgPRu
         L6c+bCpK6YZg2on9TVy1lK7p8E3Dbok9Fn01ItPNMXkWqnCCbEaHxhnWE7HtWG9QrWSp
         pMK8oUYxujgIJ+UVLLpkba4ct7i9mGGJaFarInNSKqbyDWToh7+14qKU6u4jiD2VWGR+
         vbNoea1Hm9KT22mJ6GrIpBzXoPKjjg5XLHgZ452JY7yMxTjC31wedp6zddfTUbV5cf5V
         xZvg==
X-Forwarded-Encrypted: i=1; AKwUvBw8yvCzo6osrc0HU3Cs2CYGjKx2qcJmWsT0kOWhHXV9jgoTHmpwN2G7QS5o5+wUMMNMqNGu0slXn6FGE3rRgg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9VpEXpVZG23ydRCuQdN/oUxH2TW/NfSVMlZyU+YOswb2odzt0Z
	Oix2GHXgnBUZ2JEJ3rgYKj0vS7vR6I+RGZhQspG6EZ3/rCnPfgdYvo42MT6Ms1AAeNdAiLj10j/
	rXF8WaOpIArR5jLYmXK/tzvhl0ETB0j0odXgkQIYYWhTAsUg+rTFxc8ULtEBrzsBDTJapOg==
X-Gm-Gg: AYBFou15A7QSlJI9WlwphlPnBJkRIg+1peOnSZe6r68Uxfri57P8P1opO5eFm3wb6t0
	WvJEf/wM9Xi8mp0vN8u/zKheIxxZbZgLe9uv9hioLloAN0inItLEOPzrb5siHLl7KiMD+0xnf3J
	/KhCKV9S6Jz72Hr52KC8YEh1BBbVD3HxtqFZx84VR5d0vHew49YjRSFln433dMcULgPy1j1nHRW
	7S9QdkfU9r1jE/JJOI6fW38I7RgW51ok2HaFR0LB4dd8hv1mbU6otwg754aOMSpSZvQGxiQPYc9
	lLzi38r0YmJorI0RLCRET8l22YO1S8Ue7jLch3wj7oaHht4Sr8mQaQ0gCZZKrXKE6TXjsxgyFF3
	FD72ASru2ANR1/bk5lH4B+MCU10NvRV4Vxn28joAc6PH7WSkudBdZd/2GpqUEz3Uu8CVkXY7IhZ
	2sVV66hKZI0z5Z1+WlzYJJQ4fr5K5G4g==
X-Received: by 2002:a05:693c:8945:10b0:358:c5c9:2661 with SMTP id 5a478bee46e88-36f77edb6b5mr1197448eec.10.1793929663124;
        Thu, 05 Nov 2026 17:47:43 -0800 (PST)
X-Received: by 2002:a05:693c:8945:10b0:358:c5c9:2661 with SMTP id 5a478bee46e88-36f77edb6b5mr1197415eec.10.1793929662450;
        Thu, 05 Nov 2026 17:47:42 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa9fc92fasm1488703eec.19.2026.11.05.17.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 17:47:41 -0800 (PST)
Message-ID: <b879a6b0-4ca3-4937-8bb0-ee3586d60c1b@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 17:47:40 -0800
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
Subject: Re: [PATCH 3/3] wifi: ath10k: don't arm the scan timeout for a scan
 that did not start
To: Christopher Griffin <christophergriffin05@gmail.com>,
        loic.poulain@oss.qualcomm.com
Cc: jjohnson@kernel.org, kvalo@kernel.org, quic_haric@quicinc.com,
        quic_vnaralas@quicinc.com, quic_pradeepc@quicinc.com,
        quic_akolli@quicinc.com, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        quic_mkenna@quicinc.com, john@phrozen.org, quic_gsamin@quicinc.com,
        ath10k@lists.infradead.org, quic_wgong@quicinc.com
References: <20261105-ath-recovery-scan-timeout-v1-0-99a70d89e114@gmail.com>
 <20261105-ath-recovery-scan-timeout-v1-3-99a70d89e114@gmail.com>
 <CAFEp6-0O=cPYKndr9hen1jvX==ot2WP4JpGfNFLokVvxUEbxiw@mail.gmail.com>
 <CAKobHXCMwjAHJOkibPbpDByLZmAKkszZ3WaG6soSDaCEGRQjgA@mail.gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <CAKobHXCMwjAHJOkibPbpDByLZmAKkszZ3WaG6soSDaCEGRQjgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: VsSVx-eFRcxthqpT0t1uAP-SQ07rkbZw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAwNiBTYWx0ZWRfX9I7sUW7Yr2xP
 5nSrMw5aE6GI8ptRsEcmcJeEJLLY5cxcVdWegbBE74Jy1fC9f611HhjAOwQFPAFFzC/LyfzfHy7
 1QXp7rjbXte+wwSXYmZWgDWvAmOlCbsYJOnkSbUDH1RBPofTfvZbaIiY9lA3GZETr3XJqbpn6NU
 6sz3cWFUAFjEiMiLlaMYVsWehDQoRmc9+dpPOk5xjFKwLNvzMwzyc84D0t9LX0bJt0+jGdUmIxm
 jpEmOkjYxnTkCwukLOFlBEQc37gvbTGufY1wGOFHXAiOw+R9lEdFHYpCpM0vntjCb12cPJhk2bG
 8xTlB3cSGHg0JsbeChqELwnsiJoJlOFIRDEvvWVf6nBTOGc/wwyTw3uN3vm3pCBGbM5fYsvwnVK
 gp2CGWmktgiPmQiHbNcUu8R6tWILkeyXeIwPvH2CHJc35Qfc8SpnCKifukJLqVEM9UCq7wCfF+x
 3j40OePya2QaB42OYrA==
X-Proofpoint-GUID: VsSVx-eFRcxthqpT0t1uAP-SQ07rkbZw
X-Authority-Analysis: v=2.4 cv=TI3Q2Fla c=1 sm=1 tr=0 ts=6aed31c0 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=vn0ihEsipxsDDuCNlwwA:9
 a=lqcHg5cX4UMA:10 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAwNiBTYWx0ZWRfXyk5KMhFXzOL3
 /NC3v7cdO62hWIz3Y9XVhLjUqEUfEVsLn1/c66JzfTQC+yux7Gg08S80XH9g+oO64r+waWl64h3
 T3INm335CEDVBYXKn0xm6rnyXJXsUWw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_06,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060006

On 11/5/2026 5:09 PM, Christopher Griffin wrote:
> On Thu, Nov 5, 2026 at 9:53 PM Loic Poulain <loic.poulain@oss.qualcomm.com
> <mailto:loic.poulain@oss.qualcomm.com>> wrote:
>> It looks more like a theoretical issue than something that is likely
>> to occur in practice, but the fix looks good to me.
>>
>> Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com
> <mailto:loic.poulain@oss.qualcomm.com>>
> 
> Thanks for the review, Loic.
> 
> We did hit it on ath11k, and it did damage: on a QCN9074, a firmware
> crash failed a scan start with -110, the timeout was armed anyway, and
> it fired after the dead radio had been unbound, ending in "cannot queue
> ath11k_scan_timeout_work on wq" with a garbage workqueue, and a panic
> (that is patch 2/3).
> 
> Whether ath10k ever hits it I don't know, but the code is the same, so
> the fix can't hurt.
> 
> Christopher Griffin

Please don't send HTML e-mail.

Note your reply was not archived or sent to the mailing list because it was
HTML. I only received it since I was directly addressed.

You can see it is not captured in the thread:
https://lore.kernel.org/all/20261105-ath-recovery-scan-timeout-v1-0-99a70d89e114@gmail.com/

/jeff
