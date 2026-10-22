Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792691491;
	b=OyN99xoC7sfWiaI0KQyC3DnSQEhxbcuWtxVkUFGKKDoDLDwvXCgfcgEMQtePftKVnwyd
	 BXTrL0c55F7sug3QGtt5sBe1ImIODENZRYz8Djw3zMcyU6pv9ymK4XLcbzSfll1EcTzbR
	 STPmcH+32GL58KMR2XYJ6xhNnQKk5nC9EjCJbXPzxw5ipNMeIwqgXsjW84d8OH/3NVdcS
	 tIVyOUhLpB/PKoJtOVB0WyVJ13sDiQ1Q9s6lcvfmreCfw3IpMU4MxXP0W8FdCMBKryaPs
	 EV2sil4Uqfjd+5JY18WeB7fUMSnuYVIJiWrW+FmUF2FssGxlsQvQmLcwl0EdkfgA4ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691491;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=h9mXOpeYpIk8OzuCjqjaf3ach7LHr2UJsWfRjycnpd4=;
	b=p59/d/JV57u9cDtAvgXZt0qUDNOWs6eYl027O8gu9x1zAEatF3d9dikzTR7VQ3ao8RS6
	 fJYjS5RyOaud/7CclM+VwPWRljY6Yi5KN5FhcMEReXRJtwNLOtVj9cuqkptH5wq1SD8E9
	 GwnR7ExTkA/SGOih5NlegHU3kNL8flaiJ00rQ9tMoKwLk+a+NNsbLUoO3OtNrhCaRs/OV
	 IJrJEIJlNDiJ8RVqwyQ01FQjm4Sh8qAJVev928jI7FnXod9RTlF5W0WfCwlFE7iI0Ncl/
	 oFDHsS3Dd+fS3HU/5/MPR9UqDaCMOOsYgdOBI4VJcOD2MO1VgVn/w/dD1y6Nh64Iu/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e9yYA3fe;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Q+yeIjZ6;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12276606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12276606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e9yYA3fe;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Q+yeIjZ6
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEFxf13555251
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h9mXOpeYpIk8OzuCjqjaf3ach7LHr2UJsWfRjycnpd4=; b=e9yYA3fe62mQ9SMv
	109TOAt2CaqagWfmRDafkPSXpaLh2XDwuoUibLZdVQ+DkDKoA1SYJQ5FvdOg4/jc
	gNHJjKENO9niTiRXo/efRTzbItq5KivpAQ4eKkB3K7ZxdyanwGu0ZQ42oL1aVsF/
	ridKCBUZJUuvqnJ1kUi1L189hdgBXjLMCGtQTL+lXaWtGG2NhhFAHdOgivosBhST
	zXVuH8C/Ia1bkr8c/nZsQMxKZYVSrlyq8864YuO3m4bcM6tAEic+X9Kyn1rO2qo5
	0GPeztI6ElRoJAbhsbVcuvGD1gEuO//YA4Kl5a0NyYwlzTuShRKpu7r3EATaAdLV
	U/x1IA==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93acuef-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:51:30 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-18eb2616974so11212c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792691489; x=1793296289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h9mXOpeYpIk8OzuCjqjaf3ach7LHr2UJsWfRjycnpd4=;
        b=Q+yeIjZ61snByeINzw2H4snyNW00a9bEs2MW8TqjgXX+Iff6rl4OnvILApJE+L/YaG
         2A2LpkeuXQRG8kFAK7EhzV25DPQRhkXKmupvzjpkY5pXHWDtOVZR/jkP8zziQqrt4IJr
         GBUBw6wDgUZQ2E8sEs09MmaYGshsgzL6UQKzDUqikkBb8HFW5LZ2woSWIWNkQDGhqPXB
         4wAKN3oF7lT8wOGHUK5j/pOmvJrne0twdUneZIhxM4y8gVPMLIF/K28uYw8KuPeQQKzT
         xVU9q9ac2Pzk9SgSbuTXXzw5JiGUFFXNiwYR34jpmeoIrJxbIt9qTtI24PdqS4Vxyjkn
         uXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691489; x=1793296289;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h9mXOpeYpIk8OzuCjqjaf3ach7LHr2UJsWfRjycnpd4=;
        b=GLabqvti6vvEr4n1gVGXmphgFl6slOktLm/zu/Fx8FXXH6Fq4sMOtQtyVnwl//4FO3
         2e1K0lXt5q5NGfu+PAZJy2O9BqsZ6ICaVc/jKgcMg7sh3lYZhdaVTJckkOwdXwUQBJAO
         koQZY8S8zqwhXPKQH6T5G08Wj3SEWLyvLsMXPyaFz80ZytxJ5nIQ8d6ekK3YS8ub+O5K
         a/758NVLEACDnMMuSC97YHjW3Mk8gxzRlOjvUgmm1AUvHJ1+nenUSMSVh02GO3XlLxNs
         CBFUgy2lt+b9LnMU9tTBxPxvmqBGTdYh/OIxWinE9eT0wb/DAaCwJSvvJtb8l6wbv0aN
         m9uQ==
X-Forwarded-Encrypted: i=1; AKwUvBzfTqjJti9+lZMnL2W2pXQIDhGmgevlukKX9/AhEgDU9cETJRw7Gxej50DIhaKgbO6f9EuI4z9+W2W/90l3Gg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKDkgnOGiqqWjxG+212aIh2snvrHxsItvZCHyrUFT+EUD+hEHp1
	+7Zv06DLrkFGEtxc7E5S+adxJiTU64EE1IhgVA4e0sZy7BCz33Z+MYYaZ4hrX2Gs43gsUXhpQE5
	ur/sYV5FmbBkmQm9nlBL4+FJCxArVG9v3hcdRw9upw47UiGaKmgwwWH6jcdow5J732V7YCQ==
X-Gm-Gg: AYBFou1RC9XOnRFRFjpEG/IMt5Osof+gmPWpfHEt4U1wK/Sq8V1BZkzJNDsnt3ddJ1s
	CX2JvbUN8hY/YqJfXECKtlizT0iVaRteLD+NQT4qA77xopA3CzyLWHeac8/6i45WwIRSfNxt9An
	mqQcfxxh34qT/wfLOOXT5sNhl4wMSGn/cw/z4qZtNpqLwqdBARJrl2Fkc+zK7t1dVFU6rYaVdPx
	YYZZ1niCypKOEtxaPIQHi4d2aaAAaiXX7o0wLg9mt+Q6oedUpx//j7cAq2+RN25kL9GjRizeoH2
	AZLZEV4LIqOxuOjXntqusScC3Y6G/6LG300gywEHMbtxx/6yzJI4G7QdFKpQ9hjf/Rm1sXaVy1Q
	m/PPuOjZ2nMtXboypRYRJ5YHJF1Gbtms87R9SRzr0ACEJmaSX5PpkFufh0Q==
X-Received: by 2002:a05:7023:a81:b0:168:3243:c911 with SMTP id a92af1059eb24-195a0effa19mr244346c88.37.1792691489436;
        Thu, 22 Oct 2026 10:51:29 -0700 (PDT)
X-Received: by 2002:a05:7023:a81:b0:168:3243:c911 with SMTP id a92af1059eb24-195a0effa19mr243809c88.37.1792691481288;
        Thu, 22 Oct 2026 10:51:21 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195aa59ab33sm140790c88.19.2026.10.22.10.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 10:51:20 -0700 (PDT)
Message-ID: <db682798-07c2-467f-809b-693615b9dcb8@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 10:51:18 -0700
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
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20261021
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
References: <51c9bb4a-e86f-47b3-96a0-38288b460bcb@oss.qualcomm.com>
 <tnbl77vafrjvgfyryd4zfyr2o5myg3vg744zglzitnpxpt2uoh@wejrgjjcbfzi>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <tnbl77vafrjvgfyryd4zfyr2o5myg3vg744zglzitnpxpt2uoh@wejrgjjcbfzi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JudkP84C c=1 sm=1 tr=0 ts=6ada4d22 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=8cXpSGzgMJdWOUynBhUA:9 a=QEXdDO2ut3YA:10 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-ORIG-GUID: sRwH_PmdsET3b9oQRHJ4Ehozqmpqxmeo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA3MSBTYWx0ZWRfXyKuM+jemGH2C
 eWBQfHU5eBgpBBDZD3rCDRBUXUkpepj0gI5fse6GAOeL4qt7AcjnodGpfGWRseMTr73J1I/ZHUn
 uRqqaYM1zH1Zpo1M0/6nrX39xp9Ubug=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA3MSBTYWx0ZWRfX3CEf0qV4DC7r
 ko+0RNzjg52FIctwX+9y9+jXIWihAUPoaPDB38Kly69NP4JwaBQaYUl9CqEwyNfPEKR6YYGaUuR
 twUVah63p56bYCI7UX3BxA2SxosqLrXy4PuPmN6moBSMcEwUi8XUBaty3scjIrYtHbH4zhHawZh
 k6nh+OOKo7mL/pvAYATl0hg4J9cN6k6L+V+QSNaVjLvlCj/x/akMi9x+y4X4IB4aNNTkt54E9Wg
 HUuJ4XQMWFJKYkycQpwsZGfMpEGlI6BdZDLDOuijqpMaOzKEGcmKi6JPghwvSkQuSPcDdOvCrvp
 P3YFqNMI0iD1rBUV2pHGDNTMrqCfrM1SzqpBApFCLzrjuYc39SQfpnTXyFKBb1xviGHnP2kw62L
 thN81geYc65uvO1Xe3ubT3K/u53ntfAMECooKikHMDmYiaBKDXtI9NzBmlT1FKJ1vmKPrTnklBs
 Vfsl5lTiLerXOaYU9pA==
X-Proofpoint-GUID: sRwH_PmdsET3b9oQRHJ4Ehozqmpqxmeo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220071

On 10/21/2026 9:49 AM, Dmitry Baryshkov wrote:
> On Wed, Oct 21, 2026 at 09:30:17AM -0700, Jeff Johnson wrote:
>> Hi,
>> Here's a new pull request for ath10k, ath11k and ath12k firmware.
>>
>> There are no changes for ath11k or ath12k.
>>
>> For ath10k update WCN3990 shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226.
>>
>> Please let me know if there are any problems.
> 
> "make check" failed:
> 
> 1. Missing "Signed-off-by: author information"
ACK, please drop. Updated PR issued.

/jeff
