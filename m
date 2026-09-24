Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192023CCA19
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790260535; cv=none; b=W1EnnDVrlRuPaVNvPGuNt2eozTHBF13ygjmwhxWkEDixyL+Qr3OMF8pok21LbVc6I/gAEOlr2FbczR1fwzagku+S+9rTnJXAHc5DyBACcPkMm5U+BYeSAkReFlI4x49lOtmrxZGS8Aq+3/XZFNevBNtHBi9Jj5qHEGIuP7BYmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790260535; c=relaxed/simple;
	bh=ENCxgWKZJGFB3FtCJJXQ3ZqAjO+RfbOaq4vgpfaytgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gbgoyZ7roset5K7SnCGYsKzEvLt+OBOYb7lhyQEAnkHkMNca9MHc+PT3uj5aykAnQxK7fgtJ/u0JGBkK77NCJ9tXFqNqIlhoDAcMo/qjf76Imsf72zgjCpB61+J1lM8yE+ONJmWhDow4pRAQqjU5+GkPKEbFvakkeExj2+/FCHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a8Q/BM3p; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Zn7EUDfn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a8Q/BM3p";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Zn7EUDfn"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OC4fte2594257
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 14:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uLM/cJ2VYwTDoMAQGqaupkr95A99pRG3YltmItgb86E=; b=a8Q/BM3p3xQ6DK+5
	aJKbldloDDKyBW4VnPWd4bQQsuzZyIhqTCa1zVVIzCN+R1kDZNp07ZzKrhd2zfE4
	GmaPPGVXMrAKPxZybeGwaj/uWTzHejSHPuPBvwVMqneB4i0Zhem1k1q4Xxmz32Mi
	23Y4dbMTRBK4qRwOr6lXO7hF1C4cjtUCGYA2D5E5Fn0jbbbmLRKI6XLF/0X6Piuq
	AD9VcK8m+4XxTDZFm67IKLPIJHyEIhdWnsCbrT8ldM0Um0NNe9rrHnNO8o6if43G
	NvB23V0s778wcY/a5O9FVi2V210f/u2JOboIRIj50ESPnG3SYIAMR4y4utvg5KOH
	D9mpAQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw1tjh14v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 14:35:32 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d7443e0f0bso28522245ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 07:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790260532; x=1790865332; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uLM/cJ2VYwTDoMAQGqaupkr95A99pRG3YltmItgb86E=;
        b=Zn7EUDfnyWJVdPdU1BRSB4Nc+dzQTwGew3CLPe2SvSk8WsB2GSmUvv3RTj93DR356b
         NWAGpTdFP02zLBHem1dIF7x7+0F0ftDC36ZXeVpfo13yZIAVXW4E+enxyi08KszM6n57
         rHPWGiDxo/2Bbv7I94ann1CwoeOs3cAsVBGSmE+AlVrasrP8l4nluvMSZzeLTcRs6V/b
         e2QWEJuZoiktgSrhW04r6SgU9sGE/d4GGlr2kGgHi5uJSJp3P1ft7v0sSPKd4KesDEA4
         mAd4uIifThd6ccmEXVlzypS3N8WAiN87NSGTJrxUWJTFSsNJwJtCHUAkRYI+kz1YFnIA
         2ySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790260532; x=1790865332;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLM/cJ2VYwTDoMAQGqaupkr95A99pRG3YltmItgb86E=;
        b=jCgVtkgLr2I1rrdaOwi4r5XXwTx8L1F9m/eOH6Z+vBism/ySQMPeASj1hcr7J0yxvF
         h57wJUy8eJyjksesfbRvJk9Wonqru5kXiWIJuCIVTPSmpgY5WHprDjvyWtyxBHp18/e2
         +Flzxjon4HWqOJW6pf1Q3WyVbWUMH3I9In0xsBRsDLTeW4Ax7juxGoPcjF3CfhiqGP5h
         o/kxLQqpQnLLrPjrsetFR/TiRhrrB8GfO69CvPog/3Kvmit032CGP6uVOimkXu8xya74
         12A39fgfNyRpEWBpAJV8UlIHNberSnineekfPcr4xykgFUoeROQ0RFkFRSdfM1DKEZcB
         fo1g==
X-Gm-Message-State: AFuF++lw/AiDLGpxVsBl0Vt5Y4ubrB1RddDF0/kpunP0tobe6NT5IQCL
	XT0hnZcdbdKAZHWe1+81f6EF3d/4WrjWAzT26y85OI/RRbmriq4CGqSf7PMdKIv8xi0lRkHLtfB
	aYQhIEj6If3ghoja3N1Fn/47S8oerykX9sekEafJj9xhbwn9tmMePF+tjHnOZUV4I/3FZUHJDqN
	agNw==
X-Gm-Gg: AYBFou2laEsGloSaFAkLaz7cUeh/JfT3Ee7sBqde3n6Dc3tC8lWozaomhrMeNnIgrd6
	qlEjnfTQK0UfkWnUe3hbf+5cfSkY2NMCJZ6LLVCRfdy4L+psSVXbExZRYaEJPnbSsZAE8LqotyS
	3jpwEAmW96N8hBRhfcI71wu/T5LVxw6O/a4Rw1qqnUkklgslHBwwBXrzpJZK5N7ZGugSXC9kTwx
	up/buQUjkhXZFiShZSKBK0i82/oTPYcOQnAnPtuszl55Q7CsnFREiqPtiKe2Q8lsruzkJR/Q8NT
	8pYaP76GNPAieVtP3SNz5fuYjai9hjuMNn0ksK52Vge6Vws80MfEZ+s91OyaroW2qDm+HIY18Qz
	1qJ/tpMT+YluhxlgyC7iKCpKbVPW8dY3sbaq++eLCXlloWdNFNuiq1XS+9Q==
X-Received: by 2002:a17:903:24e:b0:2dd:c100:a5e6 with SMTP id d9443c01a7336-2df7dd8cd88mr22612865ad.58.1790260531402;
        Thu, 24 Sep 2026 07:35:31 -0700 (PDT)
X-Received: by 2002:a17:903:24e:b0:2dd:c100:a5e6 with SMTP id d9443c01a7336-2df7dd8cd88mr22612535ad.58.1790260530774;
        Thu, 24 Sep 2026 07:35:30 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516d8asm28253165ad.9.2026.09.24.07.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 07:35:30 -0700 (PDT)
Message-ID: <6de23f77-4090-4093-94d7-0f5482e4b495@oss.qualcomm.com>
Date: Thu, 24 Sep 2026 07:35:28 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/6] wifi: ath12k: fix monitor RX buffer
 lifecycle issues
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
 <c55d15c7-cbdd-4301-95c1-650db2a8bc05@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <c55d15c7-cbdd-4301-95c1-650db2a8bc05@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SLUgAy0C-aQzIeGESEQh4wVB3kLxVMvz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA2MCBTYWx0ZWRfX8kKEqwrJazyS
 ynh/aEfXc3UGFwEFXO4h3HYrqgXZiFk9OUCJ34UpRAfmGajDUVwVDurt5qxadOGgxAArBaCM9Gu
 aUq6Dla/RLkiIryrLzqsAu76K2c8+tFO8/uJryqLWxUGNxqqlvqbD/f+aC5zw1o4vXO/hQRu+29
 7d8HTIb9amcZttBA/dl9gm3q5Knu49UP5r6qgEgAe9jNoudSia/dHGZZ7Rz2xxigfz88Pa88lsV
 dina/MypHgeKshttwATIFwhOzTcwZxA1b5IXBqIlYg2qlWppebhmPgPp+QJxnaFTGnAksXXnwfn
 y+6UwlJe6PoRRMSzF52IesSLFe7j2ltW7xzn5DDFX2IenBA/M23VCC/vE+El2iqnyQorQNxBlEM
 vSnJxqaq9JDBJIKAQsEUT1lJXMD8Dfx/V9f047RrkX8jIGgMZBButSxWhFaiFYQo4K08vVNQ2Wk
 rmZKqCgR4wyJn5OAO4g==
X-Authority-Analysis: v=2.4 cv=cK11IVeN c=1 sm=1 tr=0 ts=6ab53534 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=HSTN1gPS3U9pUldlOVIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: SLUgAy0C-aQzIeGESEQh4wVB3kLxVMvz
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA2MCBTYWx0ZWRfXyWhZ3MokhCAw
 vbkcyK5z90UfDvSdkoI84LBx1Q6mwHyj8xdkxQcfnhC5o0adyf+M3OChHB3fl+QQNXdJyo/K1TV
 RJ3fDFhvbhKOl1Alz3B7+Sz6XaQ3z3s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240060

On 9/24/2026 12:48 AM, Kang Yang wrote:
> 
> 
> On 9/16/2026 2:03 PM, Kang Yang wrote:
>> This series fixes several monitor RX buffer management bugs in the
>> monitor destination path.
>>
>> The fixes address leaked skb buffers, stale monitor descriptor state,
>> object lifetime issues, and incorrect DMA unmap handling observed in
>> various error and corner cases.
>>
>> Kang Yang (6):
>>    wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
>>    wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
>>    wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
>>    wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
>>    wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
>>    wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
>>
>>   drivers/net/wireless/ath/ath12k/dp.c          |  9 +++----
>>   drivers/net/wireless/ath/ath12k/dp_mon.c      | 15 ++++++------
>>   drivers/net/wireless/ath/ath12k/dp_mon.h      |  2 +-
>>   .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 24 +++++++++----------
>>   4 files changed, 24 insertions(+), 26 deletions(-)
>>
>>
>> base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c
> 
> 
> 
> Hi，jeff, do you have any comments? 😀

If you check patchwork using the Message-id of the individual patches (not the
cover letter) you'll see the status is Under Review which means it is under
active review. For example:

https://patchwork.kernel.org/project/linux-wireless/patch/20260916060325.854-2-kang.yang@oss.qualcomm.com/

Patches transition to that state when they are placed in my pending branch.

For best results when using patchwork you'll need to create an account and log
in since anonymous access has been severely restricted due to abuse by LLM
scraping robots.

/jeff
