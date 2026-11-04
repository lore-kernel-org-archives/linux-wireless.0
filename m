Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776541;
	b=R5UL/StFvs7BOJoTlR7WkLZ3aMGpB/Ipiby8L0iPdiMD2v7Uqb1pk4j20oz4s2YJw+Lm
	 tuyEJtt1AhFhMjGvepbcjwCOJxch5RVG/Gp6jVdJqaX9CcEVgXpnlSHF1BMQECPJX1qNN
	 AhkT3mvPPnP4VWK5DojzrWqC5/V5bbWJOmjcNBheTVrqHLN/i1PnVB9fYyzLQlTtZfFNv
	 3phKl1T+FW8SvetvW5XpNiroCXIP2aWfumFjRbva4RWsi6ItnJRlHAtaTR8ELbtGfOkap
	 tmWMFPo4AQ252biSFU5mzj0BjDOka9wmDRFyOgvAl49GYR7f+vOVMJ8f37ALEypFOLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776541;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=/sBFE4JMy7Qqdv4pjAUdbUZZk0aaF6z/Jc6BDucIaRg=;
	b=VefvZbt2Z4eibAuY9zdz25RYU0lTwGXxlBHhagvPGZ4cof4oxa12fsxi6+0LmXs5Lmro
	 VFJuOPcJj3zEJ4WwTwkvT2G8ucKUFCuSkdrcsy4iaDu9ojg95WKK8cUJQob/0188imjFa
	 FXw7i641hCOLdyWJxBrj94k/WdFHvAIzHZkXVL462MwAoMRnSV5VEw5G4CNCWC9WDxzEg
	 d5THtqz51hq3QtZrNgqi4Bg01Wy4VqUPxdPN8YF6RkdE9LCzgU8fA85QaQCmGuRueZqId
	 URu0RwjwFOIpF1LiMpt8w+Rfs78CRt4xBB6dv4FWVnPY5VFgk275f0Nk47O7TnFJ1Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="P5Ab3/6E";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D6gEsGV1;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BB0606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 07:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92BB0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P5Ab3/6E;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D6gEsGV1
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A46qFuc3458455
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 07:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/sBFE4JMy7Qqdv4pjAUdbUZZk0aaF6z/Jc6BDucIaRg=; b=P5Ab3/6E+YOrq3NE
	6rphAYp16tIu7thpCAjY/9Bop/31Gi8U6aZuGyjOQSMtyXhi+6ljsOei263SKfms
	d8MusggKN3GLJl+FvqIeclY6+qQ8iswJJe2GefVk6w1mirYnb/7iCwVFAGhCQq1t
	qh+o5LL6ZsRELRuIHS6wS9dKu7JXjfq/Z32tbjKneCgzQOg5L5NP35dlx5PKvpvD
	ZSqo3OhGmaE1sWT+KXLKOrEiSewaZIdr4VWd53i6gBi42ILfv3VhxX0MPMz08qTe
	RuDeM20CvYKzGnGFq4PTzKEc5CaQrY7aoCoTlp6KoW/g1OSQjn2YjrPUIsLghuAZ
	zDGK/w==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2buu96-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 07:15:39 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a05b68f851so1389207b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 23:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793776539; x=1794381339; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/sBFE4JMy7Qqdv4pjAUdbUZZk0aaF6z/Jc6BDucIaRg=;
        b=D6gEsGV1YPneXaWd8UTsucQ59sYgDL+BMY6FOQrDMwCo+o2nRjAHX56kklyJB7bRsr
         uV400d2Q+ZNA+l+UKUkJgiWF0V82NXyVacdN9wZARPK5HAYazA50/I77NSBpe2kbdqHX
         ZM8ebyUg+xHaFNEQgTYIdxgTRMP2obQYxdMU1PKUNiZPonX+vELiw+GiBXgFu8hElhlr
         N+Q2RT3tdtB63qoQQuhI2A8oeezlU0IqH3yuZoZYyXXk3wYWAzzKm+mI5mP9MxK3i36C
         zy032oHey0OJ63smD3oBCdOTy9JhQwcr8K7fg1dUrOJ8NY5IwkmaA73xiouyV2vYSepO
         y50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793776539; x=1794381339;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/sBFE4JMy7Qqdv4pjAUdbUZZk0aaF6z/Jc6BDucIaRg=;
        b=YzdcwbMJy86zt3AkoNq/lXEF2dlNgXlQqRdpZXry1zkKj/4Wu/ZERm8rS0c/ltUUg8
         yj9n35s1P0+1R1IyfEhN8llwG8eo1CkKCpbF74RiV9Uzr964CqyZsHF5eIUionlQcIn7
         a/so7RV3Ogar1qG7D2U5a5YE6X8TKPSEqWXvPtwyV3XZX5hWwXoxPZnfQpFngyS+qCQz
         9umX0bLoaqQ7/qK+bH2BiGdj3Kl+ASUDm8ImRtKBx7yXeCvzO7H6ccOKwePDYDUdQ74Q
         GW0PcMV94EyEC17RQ8ffT+zfdFCx1KCw75o1b395sJOH9dBnYbBliIsTYkXlvzjoF2Lf
         GI3g==
X-Gm-Message-State: APuU4Z8/hbDNmaaDqRZ+r4ml6PKbZIQ7cZRQF2W8bfjEP8hvbTnAPVTN
	Gq1tOak4bSLgefaW1lFXtKSrOZIltYdQOPPnUT6pWPInrqX0ipCy8PLIoP4ojIMnu6QjPTlbho5
	Ja/30mPPt0oshsRmdTwVmtnxw8RZOvvtatvrMg+Eu4jM3vBf8liHRoI4Jj7jus2PSknfGgg==
X-Gm-Gg: AYBFou2mZHvDbr/j6pNhlVjWQANWBkaF8OhJgj4C90nTcotW7NDdIanghPNrKdIibze
	QH/1+OsHIo++w3qG984d92dHWHrHokYmzpws1YQeKmEJAC2DSLw+IzC+yHqBJ1SaB4QArj9lH3I
	BQB2Hv8mmnZlF3kuYnpJT7NEWLY5Bx0hDvSUj4Ew1H5jLyGDBO5tLggGw2rKDppCkp/wX32JdVY
	aL9t7U2MpI9dHCqA+hMm8iOFeEbJ5ajUrwAQNOiQ04mp/OSuT7OEutiHRkwzlWKRTJvRLWZYV2a
	YMk762YUaSklRChsqZ4JIvBoOReGR99hLF+JC65xkMgTAvKI+fI3PBMdFfz4rUsPVh/0RhTgiUd
	e0ebzSysvg5H3YOhIn9m6m7gVLFXENDB9xZsbD+78Zv+//q96qtvgesnGAvJjudgI4LHqPwQltD
	6ABDaJ80TjuQXfLZLkOWH3FuUUl7CjGRjODqCWrdgD9zo=
X-Received: by 2002:a05:6a00:348e:b0:8a0:7ba9:93ba with SMTP id d2e1a72fcca58-8a8317dd9bbmr11302707b3a.12.1793776538988;
        Tue, 03 Nov 2026 23:15:38 -0800 (PST)
X-Received: by 2002:a05:6a00:348e:b0:8a0:7ba9:93ba with SMTP id d2e1a72fcca58-8a8317dd9bbmr11302697b3a.12.1793776538456;
        Tue, 03 Nov 2026 23:15:38 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b097fe12f6sm507309b3a.4.2026.11.03.23.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 23:15:37 -0800 (PST)
Message-ID: <5e7f6e09-2430-4da0-9d0c-4daa5e91651a@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 15:15:34 +0800
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
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
 <029eac4d-9516-44eb-922f-73ebce894925@oss.qualcomm.com>
 <e05f0373-aa6a-40a4-b778-22f40a4de0a4@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <e05f0373-aa6a-40a4-b778-22f40a4de0a4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyOCBTYWx0ZWRfX/mUbjUb4t/2W
 KanGjYfXjXJZah66HNpkv/uOJNVChsjsxDOUU2cBrK74buFSsowdRiqTq55noXuHE2fHS7uAwvR
 069bvNne14blImSpJ4X5O1Cc8/TVOj4=
X-Authority-Analysis: v=2.4 cv=AKV9GsJK c=1 sm=1 tr=0 ts=6aeadb9b cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=pEYuK4URmlPkE1wXD4AA:9 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: e42IcVpIdNqnDnBYGNUjrVwKAOdmybij
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyOCBTYWx0ZWRfXxII1vrtasTgF
 R2wyqtd8aZgB4Y+a6RHedvmbKNwQFag+ypIpadF+K7aBbzvqHkCJKGdok2laWlOMz+b3zR1jXjX
 qY2YH+Oa1vQdBOeNFwDjwEs6wQMj+pD1s6lOrujix1skrnmOTLi6gQa7m+IuytOe2ii9KIl+yqe
 kCsr2iO4pSUFHGsEHDKDRAegyxEFrZ0DnmgFqoIewBcXTY74Yb8W4gF5XAL0jnmwFFKYJ2P5BV0
 xg9DTh61JDotB0nLvnjYn3WX/wwr8uOdc/YORo913Hb56tp+vM4wx773dCCgfG7RiPOJ5EQiohM
 RnzTWVwa1VgGmUVGdOsBW6EtINfFUEJ+7XOWtRZNo1T5bhpJdv0sJa2Z2nTTazvIsN58JgsBzFH
 9Jp2VmWfkIDpdMTHfVJMhiK5l8LZJu7YMoMRYoLCjdWtsFR4J9aq0x7jBM+RYf/xP2lG3Mkjx/r
 6unaShTWvruZ21CLC5Q==
X-Proofpoint-GUID: e42IcVpIdNqnDnBYGNUjrVwKAOdmybij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040028



On 11/4/2026 3:10 PM, Madhavan Ganesan wrote:
> 
> 
> On 11/4/2026 12:23 PM, Baochen Qiang wrote:
>>
>>
>> On 11/4/2026 2:30 PM, Madhavan Ganesan wrote:
>>> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
>>> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
>>> logic for freeing a DMA-coherent firmware memory region and loading
>>> firmware into it. Factor the shared logic into common helpers.
>>>
>>> Patch 1 is a preparatory, no-functional-change rename of
>>> struct m3_mem_region to struct ath12k_fw_mem_region, since the type
>>> is also used for the aux_uc region and the old name no longer
>>> reflects its purpose.
>>>
>>> Patch 2 refactors the shared free/load logic into
>>> ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
>>> rewires the m3 and aux_uc wrappers to use them.
>>>
>>> ---
>>> Changes in v2:
>>> - Addressed the review comments.
>>
>> this is not enough: you need to clearly state what are changed in each patch.
>>
> 
> Acked.
> From next revision, I will clearly mention what I changed in updated patch set.
> 
>> And I already gave my Reviewed-by: in v1 review, any reason why you didn't carry it in
>> this post? I don't see any major difference between this and the previous revision.
> 
> Based on Jeff's review comments, I have cleared the paddr and reorder the function
> definition. So, I thought I cannot retain your Reviewed-by tag. Please let me know if I
> need to re-spin with Reviewed-by tag.

Hmm,  I think the changes are minor ...

Never mind, I can post it again.
