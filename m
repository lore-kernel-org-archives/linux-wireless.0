Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9294255F2D
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043756; cv=none; b=jSIZ0veStELx3SV+bDN5tmpCcMItS6ZeqKY9pMSP0BIXLxcrFsQ4rkiSUoP3D95Vc7HEz1qgDNwbuYhDSFvidvNtAEppUQFtBOoHzv6bLl0Dlsjda1RRJ+FPRvE5NtDDqOF/7/W4vsSz33ouo2LyPP+tMrNJDEGvDwEQRFrN8Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043756; c=relaxed/simple;
	bh=POSD5JRvRWaHv19KVClcisvRnC+h0J9UC8wZvw7DbJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3GRD4hrEJp2QeMgHp2jU9zkNRa9y5yKIRcIf5rrlZNKWu9fJIWNl0vLc/NLu+rzYYZWyuyVYBBv0WFdR/uy0C817Pq0VjyzNyxCAeL88Q+g7tA/r80x6iM+vt5ZUH5oPf/i8M+ly9apExjxf7NgFvKlPNLYfQkmm+XPuynWeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DYHFVvy/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iWxkqeNN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DYHFVvy/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iWxkqeNN"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EMXbM7644597
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D4LFn1C1tOpT6EXzpx/sVjw2jA7YZdECpN5nnDi6rmU=; b=DYHFVvy/G3u1EcBk
	P7BLTsjnjKFyK9oBKSqns1bwaN01FjrJb0ao9ZwRQZA18Qf7WXgtcQqkfDiue4LM
	j8uW1U6K8OrGvpMaO0xCXvExR7OQreGc5F/5/ydCaIHYTEWv80RH+80yZt+JHd9Y
	5z0d33HFvkHRxtwIIyWAb7vEkAbgPt7D8le/dZOQ4iYQvEvjNCo01dOpLyFV9HEL
	BNi5j/RGYyUbVZekLYknqNFhYE98hF+ivXN85E8YEE/WjG1/BIJ9Ku+8TEQsYppM
	ZBSjPjvkgQu4fp8C4wFMOurLXf0shpHuJ7dxtBTU7/fJOXCk7y5saCcpGBEHL9Nj
	fx3Dzg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hajmy9bcd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:55:54 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a4a0017549so7952173a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043754; x=1792648554; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D4LFn1C1tOpT6EXzpx/sVjw2jA7YZdECpN5nnDi6rmU=;
        b=iWxkqeNN+Mz4Hre2F/NAEzago5bRh4pZ3uTjghtJ7uHvn+nXsecZY4e5kgCIif/ir5
         sJfLEqpERJ7Nb/jycAl8J+0qu8qLKu0nPF3CCbX0UosDWEDyL8mHkPWoTAhk2tGZF/O0
         0oj+jtP+27C7ascx3BiEggDpZLJfl2u35ezSU8xTEpxWAev6UEvZlVHoKEp8dTbx0aX2
         pMqz7E/CHL3FV6XGzSuUHnRoIKPe58A3Xz1n1eJlExBeRRFwdhkYnZC5+niAMkjlnNXh
         5pgVJw601xBBF9WGeTqJc+lRXq5iUFh5YmX3LTinUFU1hytNf5TQdVxBu03mbD5nFUk7
         ufTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043754; x=1792648554;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D4LFn1C1tOpT6EXzpx/sVjw2jA7YZdECpN5nnDi6rmU=;
        b=l4Q4fvGAFBuX1lCpXx1WmSLsRCow93yf3l/UBxreXeUFbq9TRuM7fq93XQwF+ja0tr
         ZVZEo7DfAZmbwK66sTLaYwaYFQsrjdKenng+4yHHkZDlgsxwoWTOzlMCM9OMYZ8wdlMZ
         He2D3smTz0QV7WArECNvc98QzjEbpZ0oP2pPLCK6NLhI0uQSr7W3gTzXaoatf3KeP8UK
         MohKoFEOB6RJ/XJb0AUXh389RwQQ8Wyy1NGvbII93/XNTQCFSqe85ev6xbJW/hY+agKr
         jCtFn31bIoxlQ4/k9Os5xOMnQ908pKpXW6+G3c6QEu/d3YsxTDlWOUx8W3B+3fcx9wNu
         g+2g==
X-Forwarded-Encrypted: i=1; AKwUvBwk+kaYtS3dCHG+vIUgzV9FbrbNcXQ2UsOPhbSJXwlU6GiM8LOieD7rcOQ3N8nmVj07QT8z9H398m1RGgY6SQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIhImd2iBB9ykR5KwMcs0ezZ38hl4Cm0V+OhuT7sXkLTlAp9pQY
	3GnXFL5pkg8p6LXL6IAHD9J3PfqLRUmgIFCQZ1gUgZLE6tZ5RMHjuO+1bF+YwJ/wAPFE6j43rUF
	/b0oOhArKW5xxQVIJ3ttsnZXILZshHZnfZ0zYtn6skzUKRJmqOwbqD3M/skAMZo9uNDUqyQ==
X-Gm-Gg: AYBFou1mFt+APl6xtcF3Qzqk+ViEhbq3EiWwsFpVheqnYB1NGEQRW8u/5Sk65Kj7dV5
	3PsDBurRF1xAuywD/tszMe8jR2lQte4P5RjukQmxuJHafv8rn+rNp6zD+eoSzfbCLfYiLLyWN8w
	3uTjk3pRp5ihkn5WUDigijjrkTvWFRcLJVCzl8ata429p1cT4dfDS2aBXL9kXHH3WA27Qs07tpH
	lSDhaGix1lzD95MuqKbgWfDnICcq/NpFdPT4XB2rhEBv7c+jUDruRqrzPRy6C2xhOujKBbPBtjW
	p0xw9OE8afl07TOvxz5/O7R9Fp6GXvEWYfGCOMl7aKFQPpQNLJnRg8dT5xBPeABDfZpDzQKTgro
	dIuKaEizl4oU/fpIVdFeL4Lm8TkXnWZacPz+0a8iRw0Smlik5w6DC2woLZBhf2yh51pqAV4Bn
X-Received: by 2002:a17:90b:2743:b0:3a0:bbd8:5ba7 with SMTP id 98e67ed59e1d1-3ab3acf0275mr16543058a91.62.1792043754039;
        Wed, 14 Oct 2026 22:55:54 -0700 (PDT)
X-Received: by 2002:a17:90b:2743:b0:3a0:bbd8:5ba7 with SMTP id 98e67ed59e1d1-3ab3acf0275mr16543049a91.62.1792043753534;
        Wed, 14 Oct 2026 22:55:53 -0700 (PDT)
Received: from [10.133.33.32] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9437b95esm2634070a91.2.2026.10.14.22.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 22:55:53 -0700 (PDT)
Message-ID: <d265ac9b-a162-4b88-8b41-0dd354179e2d@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 13:55:50 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-current] wifi: ath12k: Fix failure to create
 ath12k_dp_peer on MLO reconnect
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260915080053.918500-1-miaoqing.pan@oss.qualcomm.com>
 <d44a7d63-2540-4886-a709-9fd75cbd4c0b@oss.qualcomm.com>
 <0e12ba1e-82cd-44ca-84e7-f63aff4b5934@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <0e12ba1e-82cd-44ca-84e7-f63aff4b5934@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LQX6PJBTqfP6IeVT-xdq-fEXV9eh3wBi
X-Proofpoint-ORIG-GUID: LQX6PJBTqfP6IeVT-xdq-fEXV9eh3wBi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX43wWsXoIK0+F
 hjHjkATOsJTPrLBB3Xx/c2I7qQ/okWGfm2QAa978tlCqNfrbNnk3cpoMKhlol/a80/xAJV+qXT5
 5mvwDDpyLzmG0lw9w+zEE8owAF09axk=
X-Authority-Analysis: v=2.4 cv=TbQDJhQh c=1 sm=1 tr=0 ts=6ad06aea cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=MPl261hcqzs-rJHzN6cA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfXwClh/y+OQ8yE
 2JroJ6Uw4ZTNxPPBGKCP/BVtQt8eOX9ALe2S0kPQLaLHFaOD5krngZWN2xwPwxBiA8KvUhazklZ
 EQFXtl3iGDw+bJBOYMT6Qss+a0YWVssUOb1yHQWVWLYPdFeHmeD4kIK+wFdhh69/zGNQupFNKny
 tKrr8KslQhUEEcV6eYtdmgTVBhpFUxY4x/mfFvUJJ1exBsPW+fGGEWJdoqdDvkMLiaDXSQNqMen
 VkeJnWholio3YmY3R1BEhA1G4jYIWWmeUwL66CWsz4l/7JriBV9ilKowFcshjZFWEZHtuSwsnvI
 1eg0vFdSgNLmf4+K0MUovtyqBjcqDO5BEW+iOSKqES8aE2UWkyKzU+SDvJcqMmkXMu89CAy26J3
 E9hBxxA/aVHl8/pWAsDgTvOZ1MzYYpz+Zi0oNFufva/2En4D9FMI8JVMmLLffmFbGUf6PUFczSi
 kW5QKXpA122y5L32Xig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150023



On 10/15/2026 12:09 PM, Miaoqing Pan wrote:
> 
> 
> On 9/29/2026 9:42 PM, Jeff Johnson wrote:
>> On 9/15/2026 1:00 AM, Miaoqing Pan wrote:
>>> In ath12k_mac_op_sta_state(), when transitioning an MLO station from
>>> IEEE80211_STA_NOTEXIST to IEEE80211_STA_NONE, after ath12k_dp_peer_create()
>>> succeeds, on is_sta_assoc_link verification failure, it takes the
>>> 'goto exit' path instead of 'goto peer_delete', leaving a stale dp_peer on
>>> the dp_peers_list.
>>>
>>> On the next connection attempt, ath12k_dp_peer_create() finds the stale
>>> entry and returns -EEXIST (-17):
>>>
>>>      wlP4p1s0: failed to insert STA entry for the AP (error -17)
>>>
>>> Fix it by changing 'goto exit' to 'goto free_unassign_link'.
>>>
>>> Also, there is another error path in ath12k_mac_op_sta_state() that
>>> jumps to peer_delete after ath12k_mac_assign_link_sta() succeeds, without
>>> undoing the assignment through ath12k_mac_free_unassign_link_sta().
>>> As a result, the link RCU pointer remains assigned and a stale bit is
>>> left in ahsta->links_map, which can trigger the same -EEXIST failure
>>> on subsequent reconnect attempts. Fix this by redirecting that error
>>> path to free_unassign_link instead.
>>>
>>> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-
>>> QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
>>>
>>> Fixes: 0cd46d1f36ce ("wifi: ath12k: identify assoc link vif in station mode")
>>> Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create &
>>> delete")
>>> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
>>> ---
>>
>> Baochen has a more holistic approach to this problem in the works, so dropping
>> this patch.
>>
>> /jeff
>>
> 
> I believe the patch that needs to be dropped is this one: https://lore.kernel.org/linux-
> wireless/20260815014329.3748059-1-miaoqing.pan@oss.qualcomm.com/.
> 
> However, the patch itself is still required. @Baochen, could you please help confirm?

Yeah, exactly.

Jeff, I was wrong in the internal teams communication. Miaoqing is right on this topic.

