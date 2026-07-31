Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42B94503EB
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785515504; cv=none; b=NhFwkizSq9zrJTiNO/1eRtjoJu0mCXAcHS0WsImHffPTxp/CvJiXNFNzmuhXOabOaOAcwbnyGQOxRJYEraVKOoY3q19J64Q93q10Hly/7yzCRL6FcqzdIT3mtOMWcDXD2Dg94+dHH6h2QSnA/WN86aTUnjSgwZ9gjA1sqpdhpXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785515504; c=relaxed/simple;
	bh=trrnY2Q7GUQZPHKUXZvn2wuJnHDk+jExPAVhxKBGl6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rQtb6fRqo2amJtq1ygvlzjE7KGLIiwp19UEB7Z44Q0/uBemmdzlin5xR1Ma+PeRL/tt+bOOfX7rWe37oH7I/K+k+LmtKly5bjpmDV/xWg/bj8wUSIYOK7Y2IZDiVPAFu+ge/syuT5hMFOEHD5cOvSl2MFYxa6TzDiCwwAMuFWlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZJWDC9Ae; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bsnc6wOM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZJWDC9Ae";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bsnc6wOM"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFOlgC3880586
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uYiR2iLP4+ZiVlUT4zCyYs7qkRlob5qlCbALPuCDTPI=; b=ZJWDC9AeWjvcI1Ti
	BS79eDWsz09sJ0c3vajJ12Nzp2II/6TaF6GmUJBLwpGFDRTtTQL4KNHse8jAe3SC
	xY6Y7WSquBGvXy/umWPdbhHvzTvMTqaGmKoQDhsHu8lykrYu5SwRVKGmf3ozQprU
	Ik/2a4wZzfFs4hkHRRFXyd9whlMFBP8abXAO9lb12GL2oYBUysru5CefIF58UDLo
	WFlotEyqaZbjrc8/lHTUGCpfuZL6asAGEFpTXl4W6k8zn7lwMovx61urc7f3OurR
	NuMw7kzcVpl7ciWbFkK8n/34jHlpZlXW/6dKGvHwGz2mlWq+wsh8+6aUvUzysVQT
	nDhj7g==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru0y186y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:31:42 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so1106767a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785515502; x=1786120302; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uYiR2iLP4+ZiVlUT4zCyYs7qkRlob5qlCbALPuCDTPI=;
        b=bsnc6wOMdaFNEutQhR+xbEJz5UKvJajRJQUpmBkH8lVJmHhnQaYeb/wiTXAwTAPrCz
         zmu7mCf73Jn7XSF7qMYWzJX6zKXppqzKWcFmQsf7PWSKEoAEYcU4yBqcdGprFrLnq7fR
         ysY8mGLF+ZB6BWC7YUoQ7MI0/IjvA0fDGn/ARJCYLoOU4FuU2qVOTDz0n4g42mF+JQGe
         hceqb+lzCvASFudVw6bi0QqKV016LiA0ZZ/mdXeINu9LU/kXgXN6F17wqtG2kWKOwrXt
         4TaAPRLwMp48lYuLyqkrDrMYUWX/+hsF+rC20QVx/WsDRbTyvhPoeZCPQFKc80VXApw/
         D/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785515502; x=1786120302;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uYiR2iLP4+ZiVlUT4zCyYs7qkRlob5qlCbALPuCDTPI=;
        b=FQmPAWxQkICpOznhIXlGS+JDAmlA6K9f4/5fS5E3/EBaevrNns09ntYId7HTfu1UBc
         T4ey2JlxVJ7U79ysbH3BEdigPXHVjRWRl6ot+wXqktEftaJkb8LMXjPCkRLvChXyMjcg
         6fVqvsqysZxlMMUYISvr0RokUmaBWfraC8KFR1adDuni8usWi5sKUu45D4ABFVVNmfjo
         jDIHr0NoISIHPVaXMELNY3D2WuB+6ECaLvTXjqn7E4wNmGEUxcQvKswhwqzGk+HlxuZZ
         EKWcEu9hWtpmR1Hzb+hd8YjfeU5yUOQqXeHaeB5kzDZI5yfbRJmXo7k9qEtW9UmSkMOY
         P1tQ==
X-Gm-Message-State: AOJu0YysxyB9PLmvhK1uDHfk2ApS0r6iHgIcgjkVccneLkUPtN3Bpqwf
	ri6gVD5p4PkzKBomhXOgHtyvMVilwpmt2zuEm9HPpunQh4ijeSKLde317CDUjAHv/pi4tkEjkg5
	RZThT+pPT8mzQTnqSLhrltRAGHN/yzoxDKU2Icfjy0MoO0+LP68z9RrcTC0oNOvhP1QY/vSlLQz
	pMCg==
X-Gm-Gg: AR+sD12ijFECuj8OA3CZh9qwMoWGM/ZdL5q1/5gHS1VaFwZvg5C69lf7XJPNn6femmH
	l1S8w0lud0iqKNebNVLskNey81Ppr4FOFHUJH6mn7DTeYjK48hhjtBKaCJxxJ2L8d3vEh1ZEybu
	YZNQT+lLCe9lEl46/BrRaC1rJDNqQeXY6g1oPl15PJsTkrVfQkGtSNJul869hSIg9qTUkD1U3Qu
	+UIkSUPBOjpHnRp2EHmgyOhEFKRfpDAtN8NhVScrj89yh1sV3zmE2joL/9PYVU/U8kCnWKhNGDy
	vJK9EqrUfYRVHsDE6K5PfpZjJr2zAzD4q+XjAe92jBQpNv5+wIQjwbw3ywk8W2doDKOnvYNuJUP
	4aTTdQFwNkvhiiWlYsNJ1z5g+pvJfK7OvaDdaTOGC+8jjNcaohlevCeWwCZzd
X-Received: by 2002:a17:90b:3850:b0:38f:5869:387a with SMTP id 98e67ed59e1d1-38fbc3f24bemr435700a91.8.1785515501974;
        Fri, 31 Jul 2026 09:31:41 -0700 (PDT)
X-Received: by 2002:a17:90b:3850:b0:38f:5869:387a with SMTP id 98e67ed59e1d1-38fbc3f24bemr435678a91.8.1785515501465;
        Fri, 31 Jul 2026 09:31:41 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e18e70esm14849573eec.29.2026.07.31.09.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 09:31:40 -0700 (PDT)
Message-ID: <6b7c217f-375f-4126-8f99-44e2a36f9b12@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 09:31:40 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath11k: fix locking problem in
 ath11k_dp_rx_tid_del_func()
To: Nicolas Escande <nico.escande@gmail.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>
References: <20260729085741.3485711-1-nico.escande@gmail.com>
 <387b4bb6-b0e4-471a-9276-211ecdedb58e@oss.qualcomm.com>
 <DKCTYSL53MB6.16YGGTQW1BGDC@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <DKCTYSL53MB6.16YGGTQW1BGDC@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyNiBTYWx0ZWRfX2ioUatl9fmQ0
 AiYCHEi60+zdgyQXCOmEJWUbt3CdvJopmGkCj5MMe1U0q+om+qg0xMuTbrn/Pl/dAsqdX2NzTpy
 nHafagsxP8N8AXF3RcsLKk151NEKHMQ=
X-Authority-Analysis: v=2.4 cv=TcamcxQh c=1 sm=1 tr=0 ts=6a6ccdee cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=AoP2NEjCippIi4usPyoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyNiBTYWx0ZWRfX7oxF4yhfgdqO
 a34OjklkrSM5dAxjgjEbznLhCFLwE+FXQm7SJFLDgZN8Zov3Hstkp0gzyfdRKILS/WySnNs5dw4
 937KjlM0SOKrg8fZOzxuR3JxXUS0w/OE3w+JqV8tKuEHY9cQIOgPDj6GbZ+qO3AVraPgxDzqhW1
 SBDE5RrTR0J8gCCOQveeVu4SBLEby+SJ8ujkkG73sZLFj3JPQi+E1whwtC+YM36KVCXOKC9++2V
 355I3oGqtJRE+HffqqvvPbLQ0EbSys5n9IQCc/HTGvH+Frg8C7hsGga9OkxLYGynp4ToXTz9YNT
 zZSCga+ZkM2hMkYDWApxLrOckfGI+zGWuN/ozs9fZJ6B2hH5dUIXI9i8ffEDv0MC76293SQT9E+
 35g3ikjZmrQbA6TkS+eHE0Fm59oP+ms52VnybYNXCP9hevMPEa+A1XsdWFpuLqvcTek5WQRGjRF
 CMMpYlE1HQvYbpG4oJw==
X-Proofpoint-ORIG-GUID: 3eFGYx46cs055IxAmj3xo-bbtvd9dwlb
X-Proofpoint-GUID: 3eFGYx46cs055IxAmj3xo-bbtvd9dwlb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310126

On 7/31/2026 7:36 AM, Nicolas Escande wrote:
> On Fri Jul 31, 2026 at 8:49 AM CEST, Baochen Qiang wrote:
>> On 7/29/2026 4:57 PM, Nicolas Escande wrote:
>>
>> while this seems the minimal fix which stable team might prefer, how about refactoring as
>> firstly detaching all the expired entries onto a local list under the lock and flushing
>> that list afterwards:
>>
>>   LIST_HEAD(flush_list);
>>
>>   spin_lock_bh(&dp->reo_cmd_lock);
>>   list_for_each_entry_safe(elem, tmp, &dp->reo_cmd_cache_flush_list, list) {
>>         if () {
>>                 list_move_tail(&elem->list, &flush_list);
>>         }
>>   }
>>   spin_unlock_bh(&dp->reo_cmd_lock);
>>
>>   list_for_each_entry_safe(elem, tmp, &flush_list, list) {
>>         list_del(&elem->list);
>>         ath11k_dp_reo_cache_flush(ab, &elem->data);
>>         kfree(elem);
>>   }
>>
>> This fully decouples the concurrency from the flushing: the detach phase runs entirely
>> under the lock, and the flush phase walks a thread-private list where no concurrency
>> exists. It's a single O(N) pass instead of the O(N^2) worst case of re-scanning from the
>> head, and it avoids bouncing reo_cmd_lock once per freed entry.
>>
>> Also this seems simpler and more direct — its correctness is obvious by construction;
>> while the fix of this patch is less self-evident: a reader may not easily grasp why the
>> code has to rescan from the head after re-taking the lock.
>>
>> Non-blocking though — either form fixes the crash. If you'd rather keep the minimal goto
>> retry for the stable backport and do the detach-list version as a follow-up cleanup, that
>> works for me too.
> 
> Yes I remember that we fixed it this way with Maxime to minimize code change.
> But doing it your way seems to be the better thing to do. So I agree I'll
> rework this wit the single iteration under lock + cleanup pass.
> But it will take me some time to do so, I do not have much time right now. 
> So if Jeff prefers taking this one as is just to have a quick fix no objection
> either, I'll rework it later for next. You guys tell me what you prefer.

Let's rework to use the local list. We have that pattern elsewhere as well.

/jeff


