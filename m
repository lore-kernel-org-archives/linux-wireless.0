Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE15137B032
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791642025; cv=none; b=jWSmwbfTvld/f/KXV2A4KeN6RAYFXm0uQFWLlSVBR7PbADVqgpe7/QRha81/Kez7Kui8qLUVuDCxwksASof48BQE8QglF+VRB0ABkohdkKGWNX8vx9HnCnXsHb+3Y0ztpabroefliutsvkA+Za6GSXGzt0fxfTlbimhWVgTimCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791642025; c=relaxed/simple;
	bh=LgCaoq0Mq7bOoSDD0CneHZ28v5XxRFf2k2HljvJNgic=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZfMAAS7NV7dDUW0d7I6QTPmNsFTnvMdkz1N62YBV9Otc/ET4zQ6Pq4rpDK1U2LzcpiWpSRHRZ+3kesF9UlzbeqwazUQ5t9yYYGN7ceyGPhJEx2BWmtO6LsaDsEhl496wSXpqBQJL4Z1NsomquZ1CeiybsuWpNgGHtu0bmT5NlDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aaTvxilx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PoqJ/k3y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aaTvxilx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PoqJ/k3y"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ACUiKZ1630225
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oC+rCB55Y+ms9o9sEXz9P3I2QSJAwssjs+A+Zu1eIcY=; b=aaTvxilxZMQj8/Om
	6iUHA5NTX8zkG8NDrpJ3pKq822a+k+ABRfoeSZ1IwluD5n5iiatC7OC5ZzWX+f+A
	PVHYDHwG/hyzooBswj5MUn5Pg8AtcaUL7TaGz5+3j4tnehz2xqLkbHQG8M/2URmr
	ef77SsYAF52z4oWP4ZhPqcyUBJjfLSxvAgR7oYKuVcShXLvgRTTGOQuAtCFf9pQ5
	29Bj/rrGC7b5fdv9kUtU99Y7ngCXdwdxQD+ckEF1ixnjbCN7Uv7YExyiFqoZaJFz
	7LSPmPGvV5fHJO016gvGPsM06Qp/l2qoq1rBT0EQzwVwl3IS/PDKbAUoQEsejBGS
	phyQLw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7cas9be7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 14:20:23 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-34ef0362d95so1667592eec.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 07:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791642023; x=1792246823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oC+rCB55Y+ms9o9sEXz9P3I2QSJAwssjs+A+Zu1eIcY=;
        b=PoqJ/k3ya5McZ3As695h40QDUGl3Hg1JjsVP8mKW3FsfGptLJvE9v647MG8fmpXECm
         4QSZ0fkP2l3cMsWfqUQLMt1fp/43mZMNVkYUjIWCRJ+3K/AMoHYsTfwL6xk2i5KOukhe
         fh1krbDFnpNmfFy32VZy7quoeD0HTonv3KUqVLGme2aXzDCGMcMg/oWYHkXc5ataz2Sn
         qCO8a1WGcYMRykXxHmHPbsxZhOaAGbPb1V/q81Nscu9V0qRQLCwOxOhsrKACGCTYNQ+v
         3QcXB+nhXrz8TZjl6kzed6OjYNXt2ZV/9/dPX92DLrqr2r9xGNPRIpIXxgI4HEAv1LvH
         lJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791642023; x=1792246823;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oC+rCB55Y+ms9o9sEXz9P3I2QSJAwssjs+A+Zu1eIcY=;
        b=qyvUfsgftJ+cU/gY4+dJxw9lxqNs2BSokm9wcb/kHL/Y/gcuGcSbpbJFerr5HZDM9m
         EJVN9jOxrCD9vgomzc7ix/nhtfd08PFriQU5G0RZvRbDB+r83qux0i9VtVihsJHsPWE4
         eADykZV4/yTkpYbJFtlsvkqlwo74M8jPnZheQN3L/9t6m8BqDjR3Sa4sHEzULKsq637L
         C6kP5bU/jY/mGwUURspUb5fknrak3ay6iCZBA1GBRGPO8EmoP0PAZKTfEH+jOOk/T21q
         f0CQ5O6ObzfgCZoFXznuF6umINKFmAsOt+oJ9DJ62GO+TVd/mkcZEFMR6Zk3iZvNwY2+
         TuLQ==
X-Forwarded-Encrypted: i=1; AKwUvBy86UQVzUNXrQAXxvwv1r1YXOUJl8RTl9WctRNtsmtDe5VfDrnd2H8VXKPUup3cKPvA4uvbrhQwygOBHcxmDQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLKsOPmpzMjBFg3J9tiq8YZiHjS+nX5/73/qbHVdflJeana5Z34
	HMmYp82PD8D2Ur0CvTuT3i94phvHOjAZZ6v1qUgnkVGb0ZAa4CYwpsV/2TokbcPW1Ggi56rlC69
	F35DMbpWbqBUl0TsqPT8z5fZzE7Vjz/JD0nMr/ylgqBCNmoZ65RJ1V7X9TQv0VTC8498Ojg==
X-Gm-Gg: AYBFou3PKqPgvX9219E3+l5iqsFGjMUdfqdNJAC8kXnWxHkNDBhC1LlmpUuAoSdQBQ/
	jazsf2jOuxy4lOYfkFOwXCqFsPYQITED2g6/8kIELr+GlELq8Wi3NSY/cRwSNxWf+ZvKDcbDsJ6
	I8drIZwxXsRCgXQGb5X7OOQC8O/X602ByITuahs4/s6qBrsJ6ZK5hch1SLml7P1M7HX8UzYLu2l
	SwC/fLbekV95WygtWI8MVGP9H2Vry4oN8yDgX7EYgpijI/OSTvXyoN+PV6xM8x8a+mUospYgjYp
	3ttaCbAnlFCBVumu3EusnEAKtubkEvdfJPzOgdjYvxMHDaYLIAUKYl0SkUWMZWTPT+U92JvYDXp
	pDRa/LnYhXRQtoNH/jNZJkdKPKsIWcf9E04n4cuTBBRzxO8HakPNWRYuZcg==
X-Received: by 2002:a05:7022:e886:b0:151:8280:2c1a with SMTP id a92af1059eb24-16a630994cdmr7542091c88.42.1791642023063;
        Sat, 10 Oct 2026 07:20:23 -0700 (PDT)
X-Received: by 2002:a05:7022:e886:b0:151:8280:2c1a with SMTP id a92af1059eb24-16a630994cdmr7542034c88.42.1791642022406;
        Sat, 10 Oct 2026 07:20:22 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a6021e49sm14807311c88.20.2026.10.10.07.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 07:20:21 -0700 (PDT)
Message-ID: <a589a7aa-bc52-46fa-9975-a20b6003352e@oss.qualcomm.com>
Date: Sat, 10 Oct 2026 07:20:20 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] wifi: ath10k: avoid IDR mutation during TX cleanup
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo
 <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20261003092104.520135-1-yaojiale02@163.com>
 <20261003092104.520135-2-yaojiale02@163.com>
 <2e271ffa-99b7-4c1f-9d17-96242a51d22b@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <2e271ffa-99b7-4c1f-9d17-96242a51d22b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEwMDA1NyBTYWx0ZWRfX9VAV1UGuohUJ
 xSU6SYX9ju8fRNXgJpDO1L4CDWmFEsVvT9W2Lw61K24QZfj/yZXdrOzcl/nr9/8A5TmxvrxBc16
 tUJlbeza0nD7ORxsAaCKFOZezLpT+QY=
X-Proofpoint-ORIG-GUID: -hw-Lv6h3bYSjw4UKpo68LmECUzWRB9T
X-Proofpoint-GUID: -hw-Lv6h3bYSjw4UKpo68LmECUzWRB9T
X-Authority-Analysis: v=2.4 cv=eMWGH3p1 c=1 sm=1 tr=0 ts=6aca49a7 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Byx-y9mGAAAA:8 a=o4UwFHox3xQ5qkXPmxIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEwMDA1NyBTYWx0ZWRfXzZ4m9/s0NaUl
 VBi7ktDnsJsZAruxH2sKOM+wpiX2j4NAy6EqB7ePxijvaBcSqACa3OgSmSW8gyZGdVIZEr5CfAP
 EqXMLfAfwxGE+EuYF3+Kp5v5xrnGOiVqjA4pTbkrvaJwWTlcxHk7vNZ5xzhaoKTWQT9+Q1OhxsW
 H4pblyW+Nu4y00NmsG50+8XvimJ8XOkjPkvjeKsXoNhov+58MIsyHROhXjeVN+G5uV5V96+goHl
 yW1Na169PSMKml5mcMp52HcxUGin9Nd3X14zP4cEkcAyBI+iQhouW8qHLp5iQpQeFZeQpi8AbNw
 MBL90jTcO8iL/wWJs9/lmVNlBiOO1EvqiE4ISEp1gXxM2iWPBxgt+0MagLc0JtAfJJrtc6vuA7M
 vDSFJoVC6gfBS+uwFsMwUR9kNN5UCjd6UaapntpWP2JVuW37Dg2PWv+V14y0Rt9w4a81O9kDHEB
 WfaeUvgEbc8AO4cw+sg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-10_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610100057

On 10/9/2026 6:31 PM, Jeff Johnson wrote:
> On 10/3/2026 2:20 AM, Jiale Yao wrote:
>> ath10k_htt_flush_tx_queue() walks pending_tx with idr_for_each().
>> Its callback calls ath10k_txrx_tx_unref(), which removes the current
>> entry from pending_tx through ath10k_htt_tx_free_msdu_id().
>>
>> idr_for_each() keeps radix-tree iterator state across the callback.
>> Removing the current entry can therefore invalidate that state and
>> make the remaining walk unsafe.
>>
>> Use idr_for_each_entry(), which starts a fresh lookup after each
>> callback.  The current entry can then be removed safely, while the
>> following idr_destroy() continues to release the IDR itself.
>>
>> Fixes: 89d6d83565e9 ("ath10k: use idr api for msdu_ids")
>> Signed-off-by: Jiale Yao <yaojiale02@163.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/htt_tx.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> index e46f579d745d..9993c5a2f96c 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> @@ -535,8 +535,13 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
>>  
>>  static void ath10k_htt_flush_tx_queue(struct ath10k_htt *htt)
>>  {
>> +	struct sk_buff *msdu;
>> +	int msdu_id;
>> +
>>  	ath10k_htc_stop_hl(htt->ar);
>> -	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
>> +
>> +	idr_for_each_entry(&htt->pending_tx, msdu, msdu_id)
>> +		ath10k_htt_tx_clean_up_pending(msdu_id, msdu, htt->ar);
> 
> my review agent notes:
> **Actionable issue:** `ath10k_htt_tx_clean_up_pending` retains its old
> `idr_for_each`-callback signature even though it's now called directly:
> 
> ```c
> static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
> ```
> 
> The `skb` parameter is completely unused inside the function — it's not
> read anywhere. Since this is a `static` function no longer used as a
> callback, the signature should be cleaned up in the same patch:
> 
> - Remove the unused `void *skb` parameter
> - Change `void *ctx` to `struct ath10k *ar`
> - Make the return type `void` (the `return 0` is vestigial)
> 
> As-is, the call site `ath10k_htt_tx_clean_up_pending(msdu_id, msdu, htt->ar)`
> passes `msdu` as a `void *` that the callee silently discards — confusing
> for future readers.

BTW no need to send a new version to address this unless reviewers have other
issues -- I'll make this change when applying the patches to my 'pending' branch

