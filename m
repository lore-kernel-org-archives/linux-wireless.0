Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A5A332628
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784942803; cv=none; b=rU8RZPOaaUAggHXceOxYRX2PSoTnL3xzjX1mULwYrEm1MHcNhFVkDz1vlMh9P2MY7yzOHi+yE30AgV4at79YkkODojOJSwkR8z8FtbETotEIXyMyOoqQVH2q1Rpu/PmGlf0CjUiD/oPwL1d0S4GPZDk+tj7d7B1TGu8d3byO0bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784942803; c=relaxed/simple;
	bh=64KUqgkYNU35EHXrXmG51HVSI9QiSbNGrczWOLMpfrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EnMt+ZGMMIxZ1FeYPeRHv/NtqRMNHZ+TgGBTl+oGGwPWlNP49SXbJSKhEuTLv1ZfPXMOL2wf7R56uxtnxm0V5U/dAHhzoclHGyJ35EtEToqAiJX/S2caeFqWC7u1Tmhx/JmuJx/rEQ7sWeVqI5w/MJT4hWEJChmeeZxkQ5STviQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BJ32zGX+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eAg2hCLP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BJ32zGX+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eAg2hCLP"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66P0qPTj354457
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	64KUqgkYNU35EHXrXmG51HVSI9QiSbNGrczWOLMpfrw=; b=BJ32zGX+j3pWgHVm
	M35gSjnZ1BuP0k4JJY2HrEbQfo2uAF0QgEgTc/DaK8TtnQaeFKH7Q08OpWzbogXm
	K8+6jkZaeXQ7eGZfJcv6ysUp9yIvv9HM/t0xSYHd6ZIgHummXA4WTfhZZMamX/AK
	9cOA3yfXVCULWjQHKXBYaIqyowAxkG+dtisloww86UIv0krE7ntoRkfssq4WOa1W
	yPdXlsmg9KTmiVZGQgo9fELIbk2x5svlccXudIkKBc7QvygX0tGWSyZT7VmTCGDR
	sTvoZ2/tj4OQsXljiWc3/GiRYFlbb/HCQwMm1fdi8oO13reFVqUSVP51QyQneJU7
	9lP1/g==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmhwg07jk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 01:26:40 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cce14a21faso13113875ad.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784942799; x=1785547599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=64KUqgkYNU35EHXrXmG51HVSI9QiSbNGrczWOLMpfrw=;
        b=eAg2hCLPS6BlM9p4JlArjb14BQgQS+J3cWZ2zcDLn4jwxt3yolzMUD8yY6EWHi8qlt
         hd5qyWzVlpJQwcp+jxyrk+2Hdj78BNJ7lxAfOnZwHI3Fwp7kdmLD8a4neA6jHMqB2PXc
         nM7aXQpaXbsMLU6CSIL/iGNuQshcxNmiw3i+Gk+i5SyU4KdRWlaoTfQVRzo1hdXo9wBt
         d2rx6xm2ctSm+/K7DhGGQDShue5OtgFGZnEjJyYH1ag0dk+yNsFy4xXe0obXZEKAG49O
         L8RDm99Plc3pZuY3CFoKydGGdNHa3JLyQJqXVLjkjovofQTfMOyx8WG4gLh4lRjA+MkC
         GTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784942799; x=1785547599;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=64KUqgkYNU35EHXrXmG51HVSI9QiSbNGrczWOLMpfrw=;
        b=jySbsefG1/V6joF5w+3lpO6ltzUfE/Pgz0WVXkSLg6PT7ZheC29wUSJlGlDZcSFSkC
         PKEoWieQAMK/xoFesXg13YAnArtYXMAwe2BThFkXrVucLPg1b70eQR4rzHgHLHvAR542
         ExxMIKPVimb6VgUJJwChLxXdL8WSrjSelyZnQtovxi634BBvZ1CgY7pikq7PytBef332
         zt9+toLbX9mm5E/tNFvJjNpIFCrhJbeuErj5DZhavrojGAr3URB3YqBCclBAQ3AGLNxn
         H7pmafTJ5veoHRoC8oBN5Z4rjpVtwFVovoOaEP1ZLop4eRXEuEWcNIsg19vatjIIqIy9
         F59g==
X-Forwarded-Encrypted: i=1; AHgh+RoMvDqhpQCh0LeCTmtVck4NLVNnBlxRh5i4gGgSLkpAxrcokr9yg7Ra8m8R8mKbtf4LeUg9KSaY61krFuuIYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YycX3/YcFhndbjsFDaBu1VW4SN3OBF7v/3FMxo4nAfeW7uPap7x
	dm4qHjXqfaG65KqqrItWyRMY/gBLWHDs1RT4hTkJgVf5i6pFYddp9XrLYcS7xRIx9Y/iU+Tcyt7
	H8h+2RL57v0/9KF/X20JS2HNIsWB9RK6saL8VQz5pIjBkqqowJwMzDN+sOuFMkgSDnoqOog==
X-Gm-Gg: AR+sD11D9nfc12oiG1ui82UB54Qf5vXi0jEt4GfATt2TAO30w8feYbvqFXcRZ1KJQuT
	BfdpPcPOz/dsTbPxNqk5nBJNsDgfYh4sik2RarHgZO5X2oEN1YmYbz9CGBq7Z3KRD4xbDlKP8uo
	+khf6ffp056RYfH0s+sR2hDbu9PF9cPX6PA49IO8G3SPV+Y91VK8WLeziKLiNRA4lOTGzpOXsWC
	C8tA+tm4hU0L9cRS1kuALAayiVzIYSrMmA84pLN/c5hpSAn70xzKaz7LDqiRSPcwHRt7fSAASHp
	IvrOjJzNovIFZ2KxRo5u12yCFbJKrQdE3nBB5hcF1mgtF7ws3BdWZgMP5l9obBLpjgssbeBNEyK
	gI9p1E6NfOIHCHYgzWq7R0/futh59jRrTmLguoTcUlitrNJ1Q8H0xWkfAgQ==
X-Received: by 2002:a17:902:cec3:b0:2ca:de3:15d7 with SMTP id d9443c01a7336-2cfd7175b32mr24890055ad.16.1784942799487;
        Fri, 24 Jul 2026 18:26:39 -0700 (PDT)
X-Received: by 2002:a17:902:cec3:b0:2ca:de3:15d7 with SMTP id d9443c01a7336-2cfd7175b32mr24889835ad.16.1784942799020;
        Fri, 24 Jul 2026 18:26:39 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc447f6bsm4309682eec.12.2026.07.24.18.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 18:26:38 -0700 (PDT)
Message-ID: <0f5b698c-6edf-4d8d-bc8b-a77af4be42dc@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 18:26:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: short description of GeoNetworking
To: Johannes Berg <johannes@sipsolutions.net>, Andrew Lunn <andrew@lunn.ch>,
        Simon Dietz <simon.dietz@plantwatch.de>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, dietz23838@hs-ansbach.de,
        edumazet@google.com, kuniyu@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <937e2942-3c0d-4583-a741-8a96c4e0bbc4@lunn.ch>
 <20260722213437.3593569-1-simon.dietz@plantwatch.de>
 <70e14ff7-fa2f-42a9-b880-a6adf5713c10@lunn.ch>
 <127c720f9ceeaac6ec3872bfc7732ab27d968dfc.camel@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <127c720f9ceeaac6ec3872bfc7732ab27d968dfc.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: a50H9jJEc0zxvYwb4L4HtdCAZ6ysieq3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDAxMSBTYWx0ZWRfXwyMuFZDBJ6xw
 rid+oHK98TaBZsBnB/9Deep/g8MB6C2w77WIfqjHpBKMmSDtIMerDs9k3t8kRCzLf7DwlLf8RiX
 jd/Nlr19Q5Evu0bWGvEZxm7s8b7C53Vse1NjyCJAEbbVOhHxTkSTaTT7YPZCw/iofoY6TmhPd4X
 SsDwkPVZOcYmfQ0CG2FUK9cP7FnA4II3THgqw4v5RkfDim/7+52XJVg5XSTLqYN4BltaW8j0DYd
 ddzo6+B//vEONYMYx4p0EbJsiUjEMCcc3J7V9NOrBP6gS0PLR8u/nGQEmzmREy4FXJMPEE/R/xb
 AIb+snNuXY/xSbPSmG1GuU0JalVnKxRl2Y4GEE0A5GZDnmaklNhv8ct8ECTa9pWhKGb5Eaj7+h3
 L0WjyHICAx2vdV4nUBlC041eaxdRI3QVpygCw9DDigdP0eE6mUAdSCaQIe3gQlBrRPWzSJV6SBq
 MZ4UImx/g1cnIxZywYQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDAxMSBTYWx0ZWRfXy0Hf+TmR8K2+
 xfckdgbxPfATAN33OGG3GgqbBwPi0MJ9ihqTjJnDnv8AeVHBXRm16t0dUu2ZR3q8gnA31BN/gr3
 TYeqKLMwquXf8AVLMCadh15vF07OuDo=
X-Proofpoint-GUID: a50H9jJEc0zxvYwb4L4HtdCAZ6ysieq3
X-Authority-Analysis: v=2.4 cv=H5vrBeYi c=1 sm=1 tr=0 ts=6a6410d0 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=p0WdMEafAAAA:8 a=051a_SxtAkDqf0A2yPkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607250011

On 7/23/2026 5:37 AM, Johannes Berg wrote:
> A bigger issue with this might be that it's clearly a small piece of a
> large overall puzzle - Simon, you mentioned a modified driver somewhere
> I think (can't find that mention right now), which may be using the OCB
> support in the stack, perhaps, but also isn't upstream.

The ath9k driver is patched per the information at:
https://gitlab.com/hpi-potsdam/osm/g5-on-linux/11p-on-linux

/jeff
