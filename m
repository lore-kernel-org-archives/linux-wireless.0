Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0D374A1A
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 07:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333923; cv=none; b=uf5f1yRbNy+N0J9D3vdvy1TJVf8ElblGAjw0qpXOt/0kY/TOi0wx0w8FQr5BC3H/smfJLOTVuWQhfHuezpnxoaXBj+QcNtZ5+T1hEQSUta9xtJTNUl5Th0CWssnXK90iEJmDTgdDCwxPLKA6qLOHQgwBQ9yhk/v3uA0W2xsIbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333923; c=relaxed/simple;
	bh=eCoJUlNAXw+nzqDrEIqL0JSSvQSn0+ft+zIWkVyolpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AkHYkryWfrcU5VUYxzHHxkATBMfeMP3Brl0alKqhcfV3T3Q5e06cV8uTVEJ5f0u9UaVip19d1HE22Rp51aNoc8dSkEyb/EzM/vIGPKw77J+ecFdMydRb8mxWm/3MuWgmEcQQZrlPtzet+0Pn0H9KN5LftjPMHnlbrAfeiaKHp4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=apWy+54J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BSrqZsF7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="apWy+54J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BSrqZsF7"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6826VVIr1451379
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 07:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bx5OJOE9oR66Z67IATW0s3UqBd7Ug7fmOWgd7byeZ/0=; b=apWy+54JXMRSuAJE
	bVg+E0uSPUwa4KcCpwj1SGUrXuRtrbQnOqRHxduhMWxjuypQKR3IK9AcqPyza9/h
	/Wdjipoc3lqoSQUDOfN95BLbY/tec5X2aK3jh7yIqxkWBvtsxEDDVtvDMXZKd8F9
	jZdZT+jZBikRFrfellibG0yl7Kxsby3foFnwf2xh3QY4idWTJjRQ3ZjWGlKHUrHB
	zLOftwF43zgW17dH1vp+wDKfYGYUE6wiq2b72MIx36gHV64EinFQ5d1+XGaG6w1y
	b6ulBkVzKOPjuqdt/nZrnAIYv5hi6rOl+OkRNqP8hpAbQaxizHIYzYF5neSYGamS
	i7rWZg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gebsx0t9e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 07:25:21 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb467e56aaso644507a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 00:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788333921; x=1788938721; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bx5OJOE9oR66Z67IATW0s3UqBd7Ug7fmOWgd7byeZ/0=;
        b=BSrqZsF7aNXB++VBAVMThzK93eLrZsquWixMIwRz9CW8bOc6Aom6igY9qX5ukWx+Jj
         4Mi8X6IBCBfejQ6M285On7HA0K3tmPdLI9zSgAAWFGDU7AdhorzAwnr2jKdprLzZ0/e8
         gMQsPxH6dCZOtl3fPPhRSO4keIsqGdO2AQz+gxC88IFgpuMjs7BShYcjBmgXqcXYPij+
         y2ehO9adK589fX0XGp3048t/WrjzR4WGSdoB6Dkf/kYh1O31V/b1DaYfmOUCBfqbOXm8
         3oCnCcOPTnJcM6OFNU0NjqmHwgteLWhUa4sTpBavDy3tRocjOL5PIyx7xoo6ZX5lTA3m
         KGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788333921; x=1788938721;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bx5OJOE9oR66Z67IATW0s3UqBd7Ug7fmOWgd7byeZ/0=;
        b=mXkJ7l6h3LIoaFzRmFJQlvfddB/jumNapPXadYFkivHLvusdCom8It2tcojnVXSy31
         ojd/VHAl6RsNeQghtO1LDeZcO5fnuxVyv9Ckj84Sp1NnrSi6SOZO7MjraZ+E6xAQASj3
         o/Sl0OWqhkW9OB6heDPnftd54FGu0Pfhd2nSsLEEs+VaLDOSWejxwFZQSx//TC9NWoOF
         /J76rUdwIBNzw9lfezPUdRplPO6OXieV/lzP33Vey1eLIZrX+YEo9/Si+L4gap6Lxfjy
         nxoDbQ04z9YolcxG7YLv5PSWizCO9zVGwBWVR0txuRQLlw4HLZc0CD87vnRh1nYTyvtK
         8sDg==
X-Gm-Message-State: AFuF++n0qOtLudSoLFQWe5w0+RgffoqHU/1IkEJ7uw3bn9hyx2NUbzh2
	dZM+8neQw07Zb+WMfR3MsQ1goF4MtWtoH8U84Dv6DVfhhejUe69soZUTqTP7PrFqNO9V6WS3knO
	iErmWvJUzPAIYsTZJxTD2TVTXq9T7XrHLzkJGZCLw49Xb/NXg5zCeUM7ZNsM94LxMKeZ0MA==
X-Gm-Gg: AYBFou01Zfh7WDhS6rOgrCSuFNrg4+t8jiFhONYwcaATe9XEDMsCCPhXFalv9OdFAhz
	14clnNShCo6OWIZUVhRda9J1QG0vY4HeNg+bIV4rj0cXWgfAxpGhdh0T3p54ERDnMNq5W0lQuVX
	P0pCylvivB4D4pRwcIlxH4+/RsARHl/uB1BUdKSD4AZT7q3Y0HfRhUZBSeSC+eGkTaa5gn3UKEs
	vRMnHt/B4WoiyOCDCodinN4TwA/JsvVR41zbCRIhgLF4sYT3zHAVQyJd3z5BVkoFaeITq6tJxO9
	K9v6dBBPrsYf4w14nrYW70mz2OWSM/nKFhpG84nMyL+3oxgzMwQwpoz09/jyouZiAyJsFROKr0t
	5AXE2jl0E5gy7i3ABv8T1LxqEieo7aMYDeyMaHw9+
X-Received: by 2002:a17:90b:4c4e:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-39aee0674ecmr3932642a91.12.1788333920532;
        Wed, 02 Sep 2026 00:25:20 -0700 (PDT)
X-Received: by 2002:a17:90b:4c4e:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-39aee0674ecmr3932596a91.12.1788333919970;
        Wed, 02 Sep 2026 00:25:19 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07bb684esm4349165eec.23.2026.09.02.00.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 00:25:19 -0700 (PDT)
Message-ID: <46d36161-5647-40e4-be05-33038f35bb83@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 12:55:15 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: remove duplicated STA state
 from link peers
To: Aishwarya R <aishwarya.r@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: QASLLriITSTfZEc7-XQD6jeYS8OdRny0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA2NCBTYWx0ZWRfXxtrxHiTM5djY
 RnRaw+AZRocBQxAh6/f50+660l53/eRnVDB+HK+1SOPkJ0olQvKld11+XaEFo8hMFRB0UGJ6IHJ
 zt274AalcYW8pZbv5Dj5uop9lHGljhQklwnQKowpjt4E9MMWW64KvSzSg3MPBm6DwYCQZ/VGeJM
 MLYuOc4rRYiW64fFInL3Cie1nRo28NwqsoB9xxV48zq92sBhDEso/G5qerbebaM5l0sg6KY8/v5
 PHkAls72pYbr043nxd2JY5uVXmGVVsYQK0iWpYyGFCVNrlKVMZGZGH1Vie7jbADAINFaRdrkjr/
 O/1em3rXUbRGsbG6aBQWQtGKJmZnBhCQOuHgFcQgVGntmiZye7nE64ewMNZC11PyTxHzSfAEw2t
 ui6g9Pzn8LZNz4P7V94fn872mKctVgCLqESK/KDKzoHTZhBFnh6NWoxBw0wrzk4n8ZBeBgGSIq+
 TfV4qlBcOPfvUQm9QsQ==
X-Proofpoint-GUID: QASLLriITSTfZEc7-XQD6jeYS8OdRny0
X-Authority-Analysis: v=2.4 cv=AufeGu9P c=1 sm=1 tr=0 ts=6a97cf61 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=FAEhTdbA7TVx68QRkYkA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA2NCBTYWx0ZWRfX7AhOSRyX+SlA
 +h67Uv8WFknUd6nBtO47AO6DZ9vz7wDKO3mxTrE4DUfr5hxlnA6oL/ik1A8v9iQ4+Ohm9djqpX2
 TKh5JlFQcj2CD38YSvTklyx3uCARmDE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_01,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020064

On 9/1/2026 2:26 PM, Aishwarya R wrote:
> ath12k_dp_link_peer currently carries state that is not inherently
> link-specific. Both the station pointer and authorization state are
> shared across the links belonging to the same logical peer or station,
> yet are stored separately in each link peer.
> 
> This series moves ownership of these fields to structures matching their
> actual scope:
> 
>    * Store the station pointer only in ath12k_dp_peer.
>    * Store authorization state only in ath12k_sta.
> 
> Doing so eliminates duplicated state, reduces bookkeeping required when
> the state changes, and makes the ownership model clearer.
> 
> Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
> updates users to retrieve it through ath12k_dp_peer.
> 
> Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
> updates authorization handling accordingly.
> 
> Aishwarya R (2):
>    wifi: ath12k: store station pointer only in dp_peer
>    wifi: ath12k: move is_authorized flag to ath12k_sta
> 
>   drivers/net/wireless/ath/ath12k/core.h        |  2 +
>   drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
>   drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
>   drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
>   drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
>   drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
>   drivers/net/wireless/ath/ath12k/peer.c        |  2 -
>   .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
>   drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
>   drivers/net/wireless/ath/ath12k/wmi.c         |  2 +-
>   10 files changed, 36 insertions(+), 84 deletions(-)
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
