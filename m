Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FF33BE155
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557330; cv=none; b=EwSw9TRMoTFG2qUv3mCF/ezyXHNxvqTfgZbveh/8lzs9bFxBv8AbENmn1DLOXspnduJCCOoa5Pkz4yaqk+dL0IsSZOt+dbrGytqIzpYvLAcH3QtcuSJkBL6l5xORff4OODdgkS3xJ8Gd5ignNFG8V/ft+CGi7iW4zZR7v3STiHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557330; c=relaxed/simple;
	bh=jJcksr9WENtV3N32Ym7RIbYwKolG6tWkXcJTQtSaLxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H47ekYPEBW8Cf+myY7NlJlJAhB2V2OVJ+1zQvIIFX601jSDgFeaK0YEBjaIgANgjBxekP2C4uXwfcpTxc/q/i2w/qZ8YvHyAk4t8tEf1jj1Q5ceNOwGUWoPttz0S5N8GMQGUTtsF4n6UH9kMAmoC5O0ED4KYkDZK/i+oMl6Fmgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cUEQGchJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e9JVwJMJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cUEQGchJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e9JVwJMJ"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KDqrbg2965444
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5XCGOX7fJC/o6dy33m46UWinQkqK0SLbXzlqRYjxrpg=; b=cUEQGchJXLDNPKkp
	YMl+DEERW59+QoQouT/GUjclYrztuabB8ZI29zgBHGrR3uDcvTtAv5a8EUMVxqSg
	7jNFZif8PFcGoW7vr7jPoTDKe6iQduOFMCT19UHLm4jXXcKUyAS+TYKsAwk+bjmk
	RYuPldXDzDUCduOHLGVlcPTv4BanhUTUqjn5bR/CzyVkzqjT8Qi8bzwpmFk/PWRg
	rv3ByFVJyeZ5a2xYwYutEpQAqwQ8U42U5OZRReIfGaET8B5EskyxYUEtkTf3e2AD
	3KI4+IbLNf5+A/u/3Yf8ITtBmZnR0QEhNi6Q2mAvCSBMXOJznyivzHztidJ1ItfJ
	i5bvHA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhfdchrft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 14:22:07 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca124bf0189so2555352a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 07:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784557327; x=1785162127; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5XCGOX7fJC/o6dy33m46UWinQkqK0SLbXzlqRYjxrpg=;
        b=e9JVwJMJ5MXs3EeVaqAGd/Zeu3mArW+FlYt36l80zC35zXkvx6BSCsg8DxGgUlFhXg
         f558wh4wuDjZFC+YrGHZpV2GTpNEGPX96oz+oMjYy0sAJsaonzB3ELLicAKg6SW4loQv
         veaqUoQkfWFvddBLPIgnVW9JA1usiu1JGTXmTHKTflXFFatIekffOVZM7tmVeFzZRAdY
         QAoGUov7A5EFz7Oio4q8pHTR2z+8toQYEsEsuDh/ltjnkMoJ2FE4g2BXSJzlpO41CqWx
         EGevjq8sos+1g0RGuXVf4tYv6DiDpAdA43EOPmBg6kdnoqib0HDu8nKiBBTuwLz1SJBT
         /q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557327; x=1785162127;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5XCGOX7fJC/o6dy33m46UWinQkqK0SLbXzlqRYjxrpg=;
        b=n3Gj4tGB9sblr3e/yWLfereyhUA0WmPbdRLdnHcf4b9uBBLpLWEb6sUgLX6Ig3CPTV
         VWc9tq43XBX9T+xli1scq7Fw2kYZdOOEAQVoQ0z79m9Mp6hMm7+mQqiUVrPD0vnvMH01
         Be6QuLWDcIwKD4csiOluriuMo6a/AJDWvo7uOkaXfz1yqoP8zN+qvUlhYlsrpcggzS1N
         PdFwtRePT5J2sOIhRuCEwo6UlWIpQZo77PQSpMyQrcp6M+99V+ny6LexF3UQ8nJfR8J/
         RZLdElPvGxYXuUOxj7k1qMvdktrRYh+F28Vg2Y0bla14O7JoNZPFLjckE95XlV40yJ1D
         epfw==
X-Gm-Message-State: AOJu0YztHJYqPZ7s5g7iAIIyyYNN/1J/lBPvkwXvPTosh5dejWbHoPKY
	EhnO4GMGasQIzw5yjFuE9Yd8gdDMSBj8ZKknlh4dSsp9vhCsbbP11mJeSZgXWJfuhztRZiNMQKN
	zZ1dytgYJ3vbjzMjmv8O4l+3vBrabu27V4vUeDvEM3ifplFQlLZguWwgQA0a5Ck1aMSKG3hOAGt
	iVfg==
X-Gm-Gg: AR+sD11R+HpWs/3Qf6l2jGO/Spr2BvFUiyUhKTjzo61xf0n7HDew9wxXaJhVJd8VP1n
	A/SmZxC4TWa5NUzVMS/leT8sVC7H5G3YuCxADVe3uFTOpVqnfFY8tcJgK0QGsR2gWr52ONhfWwG
	YlCSFuVAvrArwEXnQo6je5ep4WRQkCrEyhTSN6HHW0NSeQzHJp5QuSXNnkHrof3A8VeGS7PaBb2
	8KZK/MNr9f4Nh9UsYmtRo0BZNMt24tUr2EqPEFtnn7vGqcRjzv4UD0gjglYjqPJecBFu1t+XItQ
	ypQLa4EFns202S4xX40cmkqmFQ0q96XZMS98JnSvEbJLg6kaweFW4GR8hOxkjdnZ4smmyTfs01R
	hHsnQKfq8gcgVWixFhza7cijkV+Rdw6KQPWB6ICKb6gPuDehRtYl8kT/3lpET
X-Received: by 2002:a17:90b:1345:b0:37e:1620:dabc with SMTP id 98e67ed59e1d1-38e3cfd30a6mr19437478a91.0.1784557326667;
        Mon, 20 Jul 2026 07:22:06 -0700 (PDT)
X-Received: by 2002:a17:90b:1345:b0:37e:1620:dabc with SMTP id 98e67ed59e1d1-38e3cfd30a6mr19437440a91.0.1784557326220;
        Mon, 20 Jul 2026 07:22:06 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29c2a48sm27471571c88.2.2026.07.20.07.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 07:22:05 -0700 (PDT)
Message-ID: <d81d02d7-e37b-4e66-ac97-3c14fcd55641@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 07:22:04 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] wifi: ath12k: fix survey indexing across bands
To: Matthew Leach <matthew.leach@collabora.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@collabora.com,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Nicolas Escande <nico.escande@gmail.com>,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>
References: <20260703-ath12-survey-band-fix-v3-1-2fb050c2505a@collabora.com>
 <8e4a3842-4fc2-4a05-9142-6fd8f23751ed@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <8e4a3842-4fc2-4a05-9142-6fd8f23751ed@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: YX_VjhYQ4VvYnsWmUeO25nhXvgOhMMFh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDE2MCBTYWx0ZWRfX52o7ueSeodwO
 aR+E2/9usON/AnAvZ6B8NACMIaYNBL4AxOugQqXNkCuq4jc7Cu4bn0fpAOMeRSBFMbUqxcgDou/
 7rkp81veT4N5brgR7oPeCHQoFeUjCGBXpD8HFnUjugcxl8CVIrrXQ3XAURzbaPixz5nSf27RTL1
 pDsd14ocWilH7W+hl02hPM1WXuAKqx8V8drklg9Gc14yTfp6q1z8bQHGFQAZ0+rtgFZUUGprmo5
 37xGT3VCrk5FaXE26EJPDHp6wfqhu3khaAiAplHZ5xQ/eg/bCQ5ui+xBHL6azbrhO6CCmT2IVyn
 9lN2DWDfgaO5QjN5LuiqLdVfDRq3Vij0Gq3kXKSmuwImVtuYJ5t0wexpQhis2jb+5AIeOWeRRzF
 rbf8C7WS9QgLtBfcfXChVNyAshvWORGKdiswNrlvhtkoYvpeSfdgfZ4W03+H1RRAfDKO8LW9T5i
 N5qM38EKNhAK+yeDM2g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDE2MCBTYWx0ZWRfX17AyQqO1o5ES
 2saI8Z71L+4JA/usUhGsHiVNpQz51YRl7wWO4tUFJ+rpbOAqlPfNJ84gigkEt4B3wSnUbV4uaD9
 kuoPxwN75kdVJGPp1rWZJQoU8h99Jlk=
X-Proofpoint-GUID: YX_VjhYQ4VvYnsWmUeO25nhXvgOhMMFh
X-Authority-Analysis: v=2.4 cv=bv58wkai c=1 sm=1 tr=0 ts=6a5e2f0f cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=QX4gbG5DAAAA:8 a=MbpG7XlEKC8dfAHvq1UA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=AbAUZ8qAyYyZVLSsDulk:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_03,2026-07-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200160

On 7/20/2026 7:01 AM, Jeff Johnson wrote:
> On 7/3/2026 8:56 AM, Matthew Leach wrote:
>> When running 'iw dev wlan0 survey dump' the values for the channel busy
>> time have the same sequence across bands. This is caused by indexing
>> into the ath12k survey array using a band-local index rather than the
>> global index passed by mac80211. This results in surveys for 5 GHz and 6
>> GHz channels returning values from 2.4 GHz slots, making the survey
>> unusable on those bands. Further, there are redundant survey slots for
>> multi-radio/single-phy instances.
>>
>> Fix by moving the survey data into ath12k_hw so multiple radios under a
>> single wiphy share one table, and index into it using the global
>> mac80211 index. A new spinlock in ath12k_hw serialises access to the
>> survey array, which is now shared across all radios under a single hw.
>>
>> Band busy-times Before this fix:
>>
>> 2.4 GHz: 9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
>> 5 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
>> 6 GHz:   9, 2, 2, 2, 4, 2, 10, 16, 4, 12, 5
>>
>> After this fix, times are independent:
>>
>> 2.4 GHz: 23, 5,  5,  12, 2,   12,  26,  5,   3,  1,  27
>> 5 GHz:   30, 40, 29, 27, 118, 118, 112, 120, 11, 11, 11
>> 6 GHz:   1,  0,  0,  0,  0,   0,   0,   0,   0,  0,  1
>>
>> Tested-on: wcn7850 hw2.0 PCI WLAN.IOE_HMT.1.1-00018-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1
>>
>> Fixes: 4f242b1d6996 ("wifi: ath12k: support get_survey mac op for single wiphy")
>> Signed-off-by: Matthew Leach <matthew.leach@collabora.com>
>> ---
> 
> my review agent flagged:
> "file": "drivers/net/wireless/ath/ath12k/core.h",
> "summary": "data_lock comment still lists 'survey info' as one of the fields
> it protects, but survey data is now protected by ah->survey_lock",
> "failure_scenario": "A developer adding survey-related code follows the
> comment and uses data_lock to protect ah->survey[], introducing an unprotected
> access (since the actual readers/writers use survey_lock, not data_lock)."
> 
> I'll update the comment in my pending branch

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=pending&id=9ff6ef3b7b33d9c4afa898581a99ca86dc8b5004

