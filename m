Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D050322A2E
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785097750; cv=none; b=uNttULKF/C9fCToRiej8OUcdD+FIfGUMdEu2PsdWS3rQnq0eigJNE4TYWt7nL79R7+HS3dXQm/2cu4Mu38dF6FFfy4myqq+kRtCx4SE1vhzRIMph/p1cbKxMLinTjpTH8ECHzKg48AwkHg0W4otDWIulkAcH0LkIgA2LvRXd+0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785097750; c=relaxed/simple;
	bh=VGy+U0lOAalbyMtH4LqfLgyCJ01CIP7RLm8/iIkHWOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s6Ib7nMIi6jdJjsXymgJFQ3saJZkHPAu5jC8efEAzSCmyBQ+qZacLWQmVU6SuotKZNWr37niEWWy7TJ+ObbUHoxXDFDLc3CW7NXZj61Zb3EH3BNlUxR3zhpnotYsAE7RTz3yTkojPI6XUplxqBT59YrKEgl3v/HKS+fDnD2DTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JX9JozE5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SttlAPJq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JX9JozE5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SttlAPJq"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QJv1Yk1712204
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wD6gkkVOfQLG02B5GEe6OBeics+ZfIQM7XwnWwyOQFE=; b=JX9JozE5gJunWKSB
	y5bO5aNBs5nuJSZApAQ9B7VgCPkDeylDkx24BHj8qALJoHySxCp+qqwPddkAMCr/
	jMbOsTrM0pyLnmqbRnb4W63MVx53/6d4fw6MKcutcVXFJU0/rKZyNkpnMN0EtaHc
	Mf2pnp6/0Zdi8jlvcLxR6qC+jA+eWupDVAJyUXGT4AVnUatDSiMa92hc81KHJ3jz
	Lan52u2TLQqZ3nhPB8Rn4oEFT/rQSE/i0RiJDRsJHCFirAxnWNQ6LegCT9myoE0w
	JCaypzuZBf8JdrIcFA4DPL1P/mAn+/VM00XL3VJbuO6Iw438LTgdyglcxGE0AUiH
	zdBqlA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmmqybpr3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:29:08 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cceabd70f5so57681585ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785097747; x=1785702547; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wD6gkkVOfQLG02B5GEe6OBeics+ZfIQM7XwnWwyOQFE=;
        b=SttlAPJqXPbtkyUes7uQL+1xf91Q6eJNnuGm7qOL8vfmJgbO2Cnm+Uma26bOUlGf0C
         xuXqLC7+flZnE77fkr52H7db/iJOJ9J3Z0/wTZreLQDeSQwCmfCV8lhDbRtPguSsUo+M
         VKxpwVgVyQi+DXflGQctbOA0BiojnCQzO8oY3GNzY3W3KjVFnsd1j9Pf++n7Vor9ab7l
         lDuhqz/ah3FM8ckjOCbSO6mEPWfNvmZ0BMmv39SKuHeL6SX8/sVrgcnuupJPIKaV34mj
         o8TDgQ+2lEgYLkwEagDRMxzpGqZkR4upurZnj5nujlJS6vA8pZ4+5YW54XuIdZ0u2N06
         kSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785097747; x=1785702547;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wD6gkkVOfQLG02B5GEe6OBeics+ZfIQM7XwnWwyOQFE=;
        b=DCYxI5ZZeMyq+1SClWs2xIGdy/fZR+hhhU8JDKd6tmXTKZ9vufyJRFOMfUNEuGX6Ie
         vhJbfSUIrKwMc1YBv9MqPMNs0IzxRERrGux93Y6iRHASTwXYM9s40Wcb3bf+x8ydzsCq
         u6FTDgLqWG9e9aVZSVED1KkJmdZjb7GEBS57Uow8APaY0zYlMDgUFc8mI5fqHs4y4Sq5
         6rAuT/hAsw2psClUQwt7w6VjClY+c25agJsTRvvYVXGDsTUq/zjW6dY+DYoUXOXXzZ06
         f6ptYYgF11+LXUNBp+FD3apXVkMn9LWIi6eTh0pvuBP58eZO0dvKa3W8TdjXqr7A0qK0
         L0uQ==
X-Gm-Message-State: AOJu0Yzn+dm+tNJJKW17tsqdRmwfj3698FtAPFVPCq7tUSH/m6CUEa4J
	rbswwEligNd3Gk+Syl6ZTU0kysl8va+X/6QLu8pTxyhC7mSx6RH+ebADoGcFZO2MCmk16FIWsvD
	UeThjhOcbKizslcb3ffS6kKko6IQcEt/s4JNG7AD8IcCaXNtYm42pzi9GP4b4nIS/FsBxOefiTt
	rTbQ==
X-Gm-Gg: AR+sD135HcS8escIUrwOaRoJHmU/vQwIk4MdbMqUHdoHY/5avwIqRuvH77OYIAWHi4I
	43Is1B9KCJGxvTLToZE1rt1eIG2ClgpfIG98tYWE+W2mgHAx7xhKXIztohdURx5GeETz3D7qIxM
	TI3fk2+OmASpj1R1pKipR09bM4rpQBJ6VlmbsJeDo5SD1pq8/O+Nqrm+udoDeK1Irhg/ha4YCrR
	4Gca7J1O3d2OJxlp6WKS7c2gQ9yOJ+GZHIzzPseoKS3/rWAz/Zq1wB49jVGcrja5SVU2sntHNe5
	j1fZDYLKWpPlxebsA6DzZlWbBFH+F7I4gCY8RuCOZmXmMK5JAY4Y0NoH4QDbHXjwY45D+MPo/hY
	0ZAZxCqd+Wb+gFA6KLrYxBZ3BYAFYWR4wmuQxNAGWEgNVedOBn67DSsFN7w==
X-Received: by 2002:a17:903:468c:b0:2cc:aa36:c046 with SMTP id d9443c01a7336-2cfde7aeebcmr54904655ad.14.1785097747348;
        Sun, 26 Jul 2026 13:29:07 -0700 (PDT)
X-Received: by 2002:a17:903:468c:b0:2cc:aa36:c046 with SMTP id d9443c01a7336-2cfde7aeebcmr54904495ad.14.1785097746931;
        Sun, 26 Jul 2026 13:29:06 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc59cfb4sm23593559eec.26.2026.07.26.13.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 13:29:06 -0700 (PDT)
Message-ID: <ded836f0-d683-4469-bae8-d95bb3e3cb63@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 13:29:04 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 01/10] wifi: cfg80211: pre-assign cookie for
 remain_on_channel, mgmt_tx, probe_peer and tx_control_port
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
 <20260726192541.2816743-2-arend.vanspriel@broadcom.com>
 <9b00d432905facbe0f86556eda6c2986df79888d.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <9b00d432905facbe0f86556eda6c2986df79888d.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ShhMAaAxkuLFlmfmyJsJ7XcTAOKRUxbB
X-Authority-Analysis: v=2.4 cv=drbrzVg4 c=1 sm=1 tr=0 ts=6a666e14 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=J1VZmZ6RygcxJUh0NWkA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: ShhMAaAxkuLFlmfmyJsJ7XcTAOKRUxbB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIwOCBTYWx0ZWRfX0R63P5UzlhMX
 tCpoE17iTG9y33j5ZKILJtpCTzUJddICLn9UT1BDzwO+3N6P9FV6z6EmDq+dIHzqmuJ1HVzfbui
 K4L69pSgSuhes01lG2QuF0/lOCWWtz4nNHXVOUwT0foEKVxQS4oSmbh7wmre+kojdOQz10e0DLp
 Yj2rrNnlitYxtcQSriioqYtQr1KW6SyGwoTDmGNQsz8S1R0WfSxAfg55TqBjWgG8Wds7vNLG1qA
 GM/U8n5z4WzpmSUGl2yj/Cv2zifzHLrbA7+ctOMYPTEe/tZNiditujkPJSc7WH+Fp0CkFatJ6q/
 3Dpmtnk86RN3IQLUHLjPKhFMKnEorROlH2yy/W8uRckwjqyGHoBWWQ6itGSbS6nvJgD1QWWIRYO
 XHIPtpAzBkw9+HO4S/9jEkGprHZVddIZ66kDkF+bp5cbaV4SmO0cE/VeDdixhsTdevjKnBNyHPI
 twvSevhlejSLIeiuZJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIwOCBTYWx0ZWRfX+I08NWuXpBGa
 yl+i/y79wlX4Z+2hDe/au/70diYjQxKv7blMUKAFU62AySSqEKKLoECqooE7W15gfZywaMvaJ1W
 lXnowS86iPEZpremSqrLRcwvNAVbSbY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607260208

On 7/26/2026 12:37 PM, Johannes Berg wrote:
> On Sun, 2026-07-26 at 21:25 +0200, Arend van Spriel wrote:
>> Having a single place for cookie assignment and keeping that
>> responsibility in the cfg80211 subsystem is a logical choice as it
>> handles the userspace nl80211 API. add_nan_func already does this:
>> cfg80211 calls cfg80211_assign_cookie() before invoking the driver.
>> Apply the same pattern to remain_on_channel, mgmt_tx, probe_peer and
>> tx_control_port by pre-assigning the cookie in the nl80211 command
>> handlers before the rdev_* call. For tx_control_port the cookie is
>> only pre-assigned when the caller requests an ack (cookie pointer
>> non-NULL).
>>
>> Drivers may still overwrite the value for now; subsequent patches will
>> remove per-driver cookie generation. Update the cfg80211_ops kerneldoc
>> to note that the cookie is pre-assigned and drivers must not modify it.
>>
>> Assisted-by: Claude:claude-sonnet-4-6
> 
> Hah, I _knew_ it, just based on the text style, before even reading
> beyond the cover letter ... I'm starting to even be able to tell the
> companies apart (not models yet, i.e. you could've told me this was
> Opus). E.g. "Patch 1 is the enabling change: [...]", "Non-obvious
> aspects" or "This means the cookie field is threaded through" etc.
> 
> Fun. What weird times we live in.

Indeed. And yes, I tend to edit the LLM commit text since the tense is often
wrong and the vocabulary often isn't want I'd use.

> 
> But you forgot S-o-b.

also wrong branch tag: s/-next/wireless-next/

> 
> johannes

