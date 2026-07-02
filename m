Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EF63D4126
	for <linux-wireless@vger.kernel.org>; Thu,  2 Jul 2026 07:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782979177; cv=none; b=lACTVc9ZT71Xu8sPgDMy6exp0QGD738bQvvxMbFGDe74a5/BXMsv5g9ij8Hd3EvR0r/FaFZSU6dboTR0wN1NjBdd5irdiA/fdr4yaQHOBJJ63mcDuYPcQTqMNvCXC2Lx996T472Yr8bKQbWNNVTTB9da4qBypmG6C8BUk0JiSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782979177; c=relaxed/simple;
	bh=1Jyn9h9ODg4Wd772HjHO2LUsPrZzPPilVUiTBr+haD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FGlLp0ty9MrtpXBYXrus9LswklpjQ+YH1mQkz664DNUPYtZ8WlgCDqhE6H+t6pvJr3HbVnZR69oeyEtxDIqP98Mxp0ZDwWuwQTHqJr2Adrgm4H/sc9xpsJ/0X/qERJFhpaLwAvpRkOOXnMUBQrqtSA9uQ64ne/7YZFfzhcsHhwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pqh7uXgD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ln68wgHe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pqh7uXgD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ln68wgHe"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6627U58e3964737
	for <linux-wireless@vger.kernel.org>; Thu, 2 Jul 2026 07:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hiMsynlwYPMX+3OLYL9rBoij/zRhgqJY9EBMCWUgwjk=; b=Pqh7uXgDBxEX2Jka
	Z+Kz+BflEm36t1yTxBXoZEYyOLipFh2aMgQNR5HZlbPbOQG5Sn1UetVK94wfzzuD
	9ODR/4usPBbKb3jYiKoWwPqFDPfeei+D5iQUMT8/S25MOUF6G5hIbdaRyuK6sEcA
	VKHWG/oqCaRRtaRmkbfEuLgnQo/QDq996YgtMezRxqnejz5vH/LiMyRS4sm7/FAI
	v/O7X0xblvWxlhQYdX1goTmiIjlIEXwqe19dzjIxqTCR4yZxQCJwg/rZoPYcxplo
	9tw1HLfrJReq36mhiP6OZEI/2SPMuPXtopAs2wF8xp4BttdUGOSfaTu/G2RRqsS8
	9PEHrw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f5knc03q0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2026 07:59:35 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-380a0925d7bso2047208a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2026 00:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782979174; x=1783583974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hiMsynlwYPMX+3OLYL9rBoij/zRhgqJY9EBMCWUgwjk=;
        b=Ln68wgHeHq7MM0pX0oY8WBfOPmzs6zSwRAGxMOIqKR3NlhVkst8TEF08RBO7QjqHHO
         DxvtSiEecjrnRWSaze5dZjgvNQRn3lNRRtr7/8wRpWif3O5Smf1FeWKnlv0rh8nD/Okb
         MhuwrbDQKnk5bX33o9N8m59nwxsO6/vDEyBBFRZWaQHjFMWlJaSVHGc4km6Rc0X7bjcY
         StQ1hxbD8uWgmjpKTgSBh+R0rAUemunTVDYJeKpol4pkuxr6kSeJ+6oIU6RBNlROx9MX
         5tId0A6b0tGtRJ7eLPjpvXw6K6KLYSxMHXuq8BeVrmDt5xBQDwUJICjskPJlKNV9hNqA
         k4LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782979174; x=1783583974;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hiMsynlwYPMX+3OLYL9rBoij/zRhgqJY9EBMCWUgwjk=;
        b=b2ymt1HuxwhA7Fno8fH+8UpwjxT9x13vsMK0ubxlGauwUADVBK7d0AC+0TTCArEKFB
         NnIhO4J14q8n/VvX8vhaTwwIoMsIkf8KZhbJFlEf9kl62dkNwHvB2gy9NY54tXvHcNDD
         fe2BKxFGS+ADrj4OCVq86JFOdtY13qyq1koAl+VnISp2HCbuul0X20kFyCdG+kIJdSlF
         SlMSwtoNKpnHMfk7sUtr27ybSlfd8GChFwepodI7yAuEOZT6G4Ktd5XVULrrV0qRoxi6
         evGgR5ggmRNYp510XN1+edbEP2i3IczWrK9Wd7Yt6bfxzsKMBwOe/Tc7MjYP5Og8i/9Y
         AsPg==
X-Gm-Message-State: AOJu0YxFfeeK4M1RdAn0W+YeU9PPSnB/rvNvrf7SB68ejKABKkQUo3A7
	ZR8svsV/JRzvReBdE9agl6wlLjwhB+5rFDrexmFBs0mRSqmDbPJqBWUw+Tk0PTEmlkmjllubnui
	sDwaGIfcAZmyKOoEJZB5hITGJIykyZcIn0MBiw8Nopu01Yfc0iLMPc8WSuU9RIR8KoCzgYQ==
X-Gm-Gg: AfdE7ckqu3T+nqmnyAAssTb2BgB1Q7AiUDSQOZ9DHcLy65iZqH/ksQn+isDdjOTumlM
	QSWZsHrrPmsGkY6ZPgCTMktjPPvxF2BlDzufw914939d6jxRYBrz08Xzg5WV1WBW5WFOm0dZkyf
	g8s1slazHYssf0XlzaGwETcjcxgVFY+DYMyzedWApzfn2Q8q8MHaMAOJZqpszjyzQH6C0OMr+6J
	2Roh5VpmETkvbTYwBnrBrKbhp+6hZhvaADVbpwwxCA4KVARRjej2H9B3jRCeTMk5YZtW5hTGGZ7
	0jymoFi8OtVMNPirv0brczmUOYqFujLs7j75ELm8+b4/Gjt5ADZztTufjteidF+bsKoDpi0TwiP
	tG83z88OkNcIzEhow6FtsanKZaDjXmW5ufxTcqimvGqN8EZqLvJflsOAYP1pFUY01XHgWsE2qhK
	6TQgHPcXp6
X-Received: by 2002:a17:90b:4b10:b0:37f:9ce1:7364 with SMTP id 98e67ed59e1d1-380aa1ee293mr4621018a91.26.1782979174324;
        Thu, 02 Jul 2026 00:59:34 -0700 (PDT)
X-Received: by 2002:a17:90b:4b10:b0:37f:9ce1:7364 with SMTP id 98e67ed59e1d1-380aa1ee293mr4620985a91.26.1782979173650;
        Thu, 02 Jul 2026 00:59:33 -0700 (PDT)
Received: from [10.133.33.211] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-380e1655b2asm599836a91.5.2026.07.02.00.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 00:59:33 -0700 (PDT)
Message-ID: <98748d59-1cc7-42d5-a90b-4d4793d0b157@oss.qualcomm.com>
Date: Thu, 2 Jul 2026 15:59:29 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] wifi: ath12k: fix SPT vaddr handling on big endian
 systems
To: Alexander Wilhelm <alexander.wilhelm@westermo.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260629-fix-rx-tx-description-virtual-address-v1-1-ac1669eb43dd@westermo.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260629-fix-rx-tx-description-virtual-address-v1-1-ac1669eb43dd@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: G7XceatUJZRo5YXA8h3po7GZqNM0weAi
X-Authority-Analysis: v=2.4 cv=a4kAM0SF c=1 sm=1 tr=0 ts=6a461a67 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=N9GNhs4bAAAA:8 a=EUspDBNiAAAA:8 a=gTOcNWQQRDhoJBoYzwgA:9 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=uKXjsCUrEbL0IQVhDsJ9:22 a=PZhj9NlD-CKO8hVp7yCs:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDA4MSBTYWx0ZWRfX+rGMLjeYfA1k
 fT4kliB9tg8UJUVKjlMAhQaQt5Ns3sm0TNWxaPqhv7dyHz1kHt4bdl4m+m+dHFcpR8eaBhqS0z+
 QNC19PUaecc268sQb7o2+1iQj04aYSlUlEuD5O+Ujykbxb9vhjGdZAuuut0VBYS3xI9nTA5Z3Rc
 GZCcRsra6xTnX/9lHdTGCdGqOl3M5wDL5jxVYSBKhMutkGzZOnRHKhSb/YdXIGaHmci+imVRPH6
 QdAuXeKSYu1exhfCqy8swb1ChnhkZ0Ix11Ieab04Fz4tSJTxe6fmeTA2vuAloI+9za4KXIhWR5g
 urOQRxUgikFyLy0bAilFAunmSEiFG9KRcWxZh4uYSK+wIN2jPPTkVVVcYLQkSjoREhgJrKS2FMP
 /37yYfmw7CKjZ9Dbh+6j+V2dkvpEcAe5o2WUwIgHVYQEzzhNvt0HhPTxEp0LnUlirHRHQDr5mQi
 BGG/NiKJEjd7LlOskfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDA4MSBTYWx0ZWRfXzWD7uRTLQlFw
 XNyzwn1m7eHncMx+sRkmgttMu5yT8rTJUA0yWjPRQW0vUxhMjvcKhHyWly+PTSBcNhd6Lv7urOw
 uD7rZgosvNOaeXqRdc3o55gDATITI5s=
X-Proofpoint-GUID: G7XceatUJZRo5YXA8h3po7GZqNM0weAi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020081



On 6/29/2026 3:56 PM, Alexander Wilhelm wrote:
> SPT pages store descriptor addresses in their vaddr field as little endian
> 64 bit values. Treating these entries as native pointers produces invalid
> addresses on big endian systems.
> 
> Convert vaddr to __le64 and update all access paths. Write descriptor
> addresses as endian annotated 64 bit values and load them by converting
> back to native pointers. Return __le64* instead of void* from the SPT
> lookup and translate the stored value in the descriptor getters.
> 
> This ensures correct and consistent handling of descriptor addresses on big
> endian systems, while little endian systems remain unaffected.
> 
> Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

