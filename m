Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31A038E8DC
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791777987; cv=none; b=adgnVu7+0lpBpVLgrRAgsWJDIDJH7Ore6+P5yV77mE9A5153eAgESXLScHa1WrbXKznG6Xg13T/QiJmt3AYUwOS5cBpFtMJmu5R0HYGTYP2RSkCNLV+Dvdj6q0L9L5vffQfwghIpMw8eBLndYFFFMjkY834+B67FFcbqjWvsFVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791777987; c=relaxed/simple;
	bh=c4cVaXAlDS87cM/wzXYUor7++jaoRk6ZsI+CP9MfWSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9IyTLqzfe5YDoHSpWdmhiHVzohURB0OgXktiq4+oZXeY23IudflEmhjgJlhQE48W+3USEbKSDrp6An6GGM2NrQ0/DBgBQFTWdKxG73yyaf9Vbwy/Aa+4XvVusf/2HnIWwdYv0kN9cw6Aa1Q2ZX0wLe3IyOvhKMQ+89y7H9nAbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TWmVzfyw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T+aD1AQy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TWmVzfyw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T+aD1AQy"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C1lIlv2015600
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yiXJLSvdm98OdB3WUsJlN9OAMP1fJkkySa991tcQiQ0=; b=TWmVzfywNBEYXauF
	HfojvLbWDjk+NeHdSBgz7w2jF1aOY9BkmnYAB85MZCa0sauVvVtXXeAt73GUiLS0
	+vuOBRo7X+r20aeY/fTC0o10vP8mVJ4descxthXipc2DC5ReZIrMvOLfM0HRWoOl
	4k5qFhMbtiUe6JC+3XMTHuR0bQ0lLVT998XcSUbV0N+kttOCw55UskNcVJbybE/j
	Y7f5b2u+O2zwF2kcAbz3GPC6YPHyra3L7YCuHQ+wqFwRlxKPQ3oSZBIWEL9W0hYN
	71XWVYSQTcB/Zp3E21Vhx1lBGKu3BzRhY+tpviiGV2wgltsKrAvxscskpqdb9G5i
	vYBxng==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7b2fcyt2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 04:06:25 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-359b81ad4e8so1254460eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 21:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791777985; x=1792382785; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yiXJLSvdm98OdB3WUsJlN9OAMP1fJkkySa991tcQiQ0=;
        b=T+aD1AQy/jc7jGsC4G86fxhE8+gNUKq9oY9qiVIkEaO918Pk73mJgQj5pS8r9vNR3f
         jHc2gzLEnYKQIFkPq9b1InnRloACQc657IbOjx/YNav/XS+HJZq51l79tIxLIdNC5dj6
         3gqe4oCRNjNUeWzZDwrUm8E2Zdwk0d+xEZLGGHaxg8rEUnh01UADix2CeI0pqmfkI3gu
         6AdhdRHr+o16gG9Bx7BLGO4aAAqQWllwpsOJfRR0JGQbylPQcDiCY87NaPAO3FmLTJb1
         qxhAeTB8mQ7wgcTuwxg7zHteMzr0jSLVuOG3k0xkfCGyTFxCGpE3j/ScJYFkaOa+/3nx
         MbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791777985; x=1792382785;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yiXJLSvdm98OdB3WUsJlN9OAMP1fJkkySa991tcQiQ0=;
        b=BG8uThwh8kVGHGJF+cX0jEzCz2MVwdH25C2V/jSjzajVjHe/t0j1WWTT08TlSoW09B
         F5EjzgeHQAP7GqN3E9JibQ8VYc0xhHo4L/8sXfAeK6w6ji2XnHczmeW0R28lSlWrGf6L
         6eo9ah0CjEmyUGT7mAPDGLGkFlnqKdA9stzFuBd+Hp9XAzMnQ/TyXcEc0PWPfkhvDdHv
         +N3HtIMmFFxCQlJOrMkqi60dhMiXP4jMmGFqR8iwaU6XfEbDi1m4xmFTIMRKEVgLW1Br
         k6hVN4PUkoVD7PKVH2yyRvlb+LwK3/k4n56awYgR4C3xLHN9kc6UPmb8M90AWlXg3YmY
         6y5Q==
X-Gm-Message-State: AFq9FYKVUU5vTIv3lzw0epFUSmGBq42In7yq9rQPJbDX7gC5uBFnU1JH
	93nNvNdLHspniWhmx9iflqXoQ2SmIIBQi9lR21NlaLsYN2uvtWsG2ah+nlwCj2CPV0NOp052Su/
	ejxRX15tebWGPUJDHguOfwenCQmD2Uu0XelMHmG6hoLU+QFMAjy7SGoBotfZXaLQk+KGE0A==
X-Gm-Gg: AYBFou3ljn8CtvuJOGKfPclCph03B2P3qxu6g0BcVpxYOGsy6mnoUV2j9p/SdGbwWom
	bn61190ginpB5cdeh8w5EX35A85p3vCrxKWsDFA0AUhj/bVgajLztH7AbUoeyv3lMCIwngR4VpO
	YVNC04DewP04Dw5QQ3ceJhhXVB0jBuDqt7TkT7TMWW6o3tD2jQICRRRpheMmIrxXL/+A5NPcavm
	RKp88ApED2F91KaELv1zd2ewzAaxUtQ73f/eICTbkFMa0QoKdSv0gjT357BHAMPWL2LrFDoVB5m
	u5RFkeuRtaOEN36HkZqQ1I0jy/LPDwHRh9L4kY+sckhThpoUakxwoNHt/FLrlvTwaD3G2BIn68t
	A3ec/woMkkAflKewuqI8AXJRj00Wz
X-Received: by 2002:a05:7301:4714:b0:359:d728:ea39 with SMTP id 5a478bee46e88-359d728ec5amr4221983eec.25.1791777985014;
        Sun, 11 Oct 2026 21:06:25 -0700 (PDT)
X-Received: by 2002:a05:7301:4714:b0:359:d728:ea39 with SMTP id 5a478bee46e88-359d728ec5amr4221944eec.25.1791777984343;
        Sun, 11 Oct 2026 21:06:24 -0700 (PDT)
Received: from [10.152.194.17] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-358ee8a3387sm17229381eec.15.2026.10.11.21.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 21:06:24 -0700 (PDT)
Message-ID: <4b8c6e1e-2f20-49bf-9904-cec2e54ff2cf@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 09:36:20 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: remove duplicated STA state
 from link peers
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <20260925051036.2838210-1-aishwarya.r@oss.qualcomm.com>
 <c03cff3e-b135-4125-9dd4-f9e342a02f8a@oss.qualcomm.com>
Content-Language: en-US
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
In-Reply-To: <c03cff3e-b135-4125-9dd4-f9e342a02f8a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAxNiBTYWx0ZWRfXy1PwZLzUkQAl
 Lyp4i667nsoBpay7EeINhTakgKKohI+RqMbJkBx4FM1yR8qJZd/jvDggwUmjRcBMlvnm/TeIP4v
 kkHT5mGPNqYLQCzKO6TAwQzd1/DwA/E=
X-Proofpoint-GUID: hKa-zJdK2JpZnJD2XaZBalR8GNQzVyaL
X-Authority-Analysis: v=2.4 cv=NddzRGD4 c=1 sm=1 tr=0 ts=6acc5cc1 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=mepA773XGFEojvbZGisA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAxNiBTYWx0ZWRfX+1ZxeU73mujS
 faZA1JgSBihFTFmc8cHRJfbCX1WRg8ltbK4qh31/Zla/1j6SHLBED72xoDYS4wu8WSCqKxHUzv7
 h72FWXIxU2yqCNbToVvwp4e0pqKG7Ksg1tIAhIEBowGePs2AO4gGid1mzC+D8AErFhJf8DGiSqi
 mBUhWpKpGjCdYLTx1hcPRP1iMCVcTDn1NW39MrjAqyqxkbZXc8Sq++E3i0tQ5YRJO/7IFJVehGC
 w1a4riOP6X7e5BrxtNJMSIfUIewGtXnSuwL22JiQN03tSENRU9VpWwSUGGlZKI9ICGVDvTNTq/1
 /S4i1DNZFtdA64nePfP5olOLZb4T5sEWHDHn2gk0JE+ERocCq8GmgN95gzzShtn16exzGwgpvBs
 kvGH9egFaezfCM78uAQHpedHzqXqYRxa3a7BY2AxugVfU0hkaAb9xQASL15/K/3SNBq+jzOed9J
 mXI6c4/lXTxKlkxxUUg==
X-Proofpoint-ORIG-GUID: hKa-zJdK2JpZnJD2XaZBalR8GNQzVyaL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120016



On 10/10/2026 5:17 AM, Jeff Johnson wrote:
> On 9/24/2026 10:10 PM, Aishwarya R wrote:
>> ath12k_dp_link_peer currently carries state that is not inherently
>> link-specific. Both the station pointer and authorization state are
>> shared across the links belonging to the same logical peer or station,
>> yet are stored separately in each link peer.
>>
>> This series moves ownership of these fields to structures matching their
>> actual scope:
>>
>>    * Store the station pointer only in ath12k_dp_peer.
>>    * Store authorization state only in ath12k_sta.
>>
>> Doing so eliminates duplicated state, reduces bookkeeping required when
>> the state changes, and makes the ownership model clearer.
>>
>> Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
>> updates users to retrieve it through ath12k_dp_peer.
>>
>> Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
>> updates authorization handling accordingly.
>>
>> ---
>> Changes in v2:
>> - Rebased the changes
> 
> In my v1 comment I said:
> If the conflict resolution is trivial make sure to carry forward the
> Reviewed-by tags.
> 
> You did not carry those forward, and did not indicate here why you didn't
> carry them forward.
> 
> Please review:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes
> 
> In particular:
> Both Tested-by and Reviewed-by tags, once received on mailing list from tester
> or reviewer, should be added by author to the applicable patches when sending
> next versions. However if the patch has changed substantially in following
> version, these tags might not be applicable anymore and thus should be
> removed. Usually removal of someone’s Acked-by, Tested-by or Reviewed-by tags
> should be mentioned in the patch changelog with an explanation (after the
> ‘---’ separator).
> 
> If the v1 Reviewed-by tags are still applicable, you can reply to the cover
> letter and add them in the reply -- my tooling will then pick them up.
> 
> Otherwise reach out to the original reviewers and have them re-review the
> changes.
> 
> /jeff

Thanks for pointing this out.

The v2 changes were limited to conflict resolution and did not affect 
the reviewed code. I've now replied to the cover letter with the 
Reviewed-by tags from v1 so they can be carried forward.

