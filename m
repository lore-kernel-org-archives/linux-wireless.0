Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D7B3F074A
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345809; cv=none; b=Vkl/BvuCYluh8Cmqoi+zrLL3VfMUjmsdBfv1iQRwrjmwodirjh5G6Lg4nJi+ZomIsFJWZXeILPPT5Wb6k51wQBmOB55Sxbo1ZWl3l6g2xTca9hQHkuWb8el6tS+12T3bMGRFTZbgSF3ucOnAoqQYv5k2i5mYTjI2QrriEV/1JF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345809; c=relaxed/simple;
	bh=oCuFvdGN7DuQjciD2mN+c41GNVnVdH2+YvNRw6JD/Fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bv+0ppA4GRXlXzJoUxJxLM9vy2svsgiQMdzLRaaFDkkYDYCsxb+lhLoTXr0Fd5xCiLxZgQKQbCX/JxZ4aqcWYzGOypAQgow+AUEPfi66s7YCUe22R5jh44puwUTnLgZG5UNjExpfXSHEBDY/fEymWQE+b3AonFrKDMfmfZJ47Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=esnWfu9O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gs11hWcI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="esnWfu9O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gs11hWcI"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6829N4hk1080308
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 10:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sF1N73AUgFMEsW3Z0Jj1FP1jxQJauSxNOYM2tnE84rU=; b=esnWfu9OYalq6NeO
	HeBcNeN7XV0o0FKpcMImL+vAMi3WXNIijbL1kI0Bv7hWsD8rBfEMXJSFnOLTJIVL
	G8YB9tI8FDFUOqp1pY8Zu1X7lxj561UApUjwZfTLmze4dc87iY//fwiTRzGIMUIc
	CePSJAdZsOnk7BOxYVSpO7Bw/JYdW9Fy35j9bNhpzvztsTrI1yimCDicPhmKRSsw
	SqvX8uYvaTIE+MUcOvxziSIUrpM7Fm7CrSFtE05mNuNDj0ALNaP/tgE0c7QVznrf
	Y/BuFXkQcZH2VteLN6JGkSb3Pv3qtFE0GkEtijOiKq8isaGXSDZBD/oWZlmcBsmZ
	4tIIRg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4geb561r2s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 10:43:23 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398d0010cfaso1811755a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 03:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788345803; x=1788950603; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sF1N73AUgFMEsW3Z0Jj1FP1jxQJauSxNOYM2tnE84rU=;
        b=Gs11hWcIYfMnkOuNW1ELV7HD4bTSufR/c7Ph/PYxxAVlpWM1qLaWKSl2jvlFJ0oR+Z
         VDQ6j0UMAIifpY8ndBclEADZ9RGFbh41ph/SrbBXafaN6QrjtINRwx54u1Bzkj0HB/LA
         qbW4AcGRhakI9JOR6PQbiwfZwBvNWgo+cHXZbQigGpV6C7DjaHqMbNbl9e4YBJaS/66T
         gw4Yq04UudwV42Jeal5Uvmz0hINgwhebjkcc4Ot7LRNrfVEinwZ/SFdQD1YscuNffCxd
         TEtIlpOaPDbYeJYcGyW+71/9kkIKwkpUwh+tMqeOqtNNRvJ9kMN5aA298XI9yiiSR0ki
         qK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345803; x=1788950603;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sF1N73AUgFMEsW3Z0Jj1FP1jxQJauSxNOYM2tnE84rU=;
        b=IWfPycyVDCXAzivFTcoZ61iSbW6GtmmFnbUuhpw5s9v4KCLAkz6I27EzniBQY3XUos
         8/ZLgLN+TSMqsmLDcHFAaqkzOWl3ZqAXeV3+0PC6+V3ygi/WCV3m3oD98OHDiBAmGlvK
         0ZPWjBVaNupv+0+XwR5N8FPHFrnWWtOs+EnEnnsKn3JR2SGjKCwLxnw7KfG3/NIo05gm
         ShBUBpneYiQR3ewh1idIRKnNB03uMHmOple89sO8NU+Hm5BNUJcdu/7dPmzoOGj2HW61
         bXY+KvCtgR3nmSO7b8bEyX3vD1gpQ4WRrhR1nWuYItrcZUSkSn5AScg2f/SygeOrCzjn
         acvg==
X-Gm-Message-State: AFuF++nAYIdegt5FXl/oLcMu8d8RFG+5bT9HVJzSZ8sKwKi3mLrtUynY
	Yp0WMwQKyq8cqf33+TFhzljFAjLgXyySdFuUr3gKMKysTfH2FN3us1uEIhEYR1If2IVS70vmALz
	u7VCHvgOND7Vc1sg4ay71OuSrELGk6rOPEslNeMEn8QPwwwHsMBsKrxOrYE/1JFSeCJv6nowiKg
	ntuA==
X-Gm-Gg: AYBFou3gRpBL60nLSKjP3NaNV8nb6GwCczPcHOa1w3M61sVNzqN93EYUlBsddAZSZl8
	sx5xjKcRFoxP+d8uHHcKO0ZklpCOjHAb5S2dI5zRFrldhsftDtt7MANcYeRDttk5Bp/TaZc341S
	Su6GXf8TcGKA5/mRr9U+PSmGBWOD5/iTM5HvT6QVEMyX5s5c0jOfKCr6/s/kkrse5VFqvBDqvfH
	qMd2RngQK1JaSAKFjfEiAgybTmzcMjbbytDLzhAtntZbXiN2Wx0tOggAGBkfWnvSSFp3RrJXRpD
	KNLDd4WQabvqunqQnTF1m2DppEXWnkfjxDWkjIJidMb+WoOEWn4K3nAuBV5nkCsPSNlwwJep1w/
	P8R0R2FxoVGjevOBi2FmUO1GUwouz8eVhIrAmqh2XNTiqrhn9VNWmmR6zkHTB8uFvTY2xc9U=
X-Received: by 2002:a17:90a:d604:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39aedf5e124mr6070975a91.2.1788345802672;
        Wed, 02 Sep 2026 03:43:22 -0700 (PDT)
X-Received: by 2002:a17:90a:d604:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39aedf5e124mr6070916a91.2.1788345802161;
        Wed, 02 Sep 2026 03:43:22 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae62cfe43sm1139160a91.1.2026.09.02.03.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 03:43:21 -0700 (PDT)
Message-ID: <99c5ff3e-c1e3-4565-9226-27bb1c5ef299@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 18:43:19 +0800
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
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA5NCBTYWx0ZWRfXwuUVkaW2ns6/
 pYrHXCDhQO22X7RZYUZjbiG0SZ3F+B7UNtSz9I1l4wGuIEt7rL0/0b6QZBlNtRMzA/+l7Sc+uBb
 bC0N3bSjW9/rpPsc0mfktBXHQ59+vooLLKNwR7/DFgmkqMFhTQOPWJgJOXPPS46E6CDPGZstJvV
 yG1KN/+5IbkI/EOYN/ISj3r7KM0rJSr+1sySJyERfEjEPTmUSDJXiZejHjcbMDwVrmmMIV2PtsF
 /vGJzOvAVONGkE/Z8lF3a4aQzw39CjposVT7fiYNYLMf5g90C/iZz4Yi16NhZ4h2NFuS9bpw4by
 dQl0qzwxiXmKvhsX5UmxGfMskMYywMLHqilts9xUHtx8gYsqXWon0iL+1hoCx5u4g9aKI5W0o6r
 lCVvDAuByFHSlqFIZqoDakD0Za1OqvYuwITDZr8rtTOJ6bqq3DdKFTkiPdZpbkaIb5uLZYzP2G/
 Wi4zIVaXdpizwuHiemw==
X-Proofpoint-GUID: iJ48l5qaYP7cIQVqtQTRpmx41hGj6c7T
X-Authority-Analysis: v=2.4 cv=D8N37PRj c=1 sm=1 tr=0 ts=6a97fdcb cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=ZJRRAzY_uXNWia_j-uIA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: iJ48l5qaYP7cIQVqtQTRpmx41hGj6c7T
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA5NCBTYWx0ZWRfX6Y697pQ5/Omy
 JB2quqxH+U52yqxwsbmFugfloPvJr8idQlXUpA5DTbFGYgdyVanZjSlwc6KrDMChsuLyIF1pRF/
 LF7xorfUJtnjNvcKyRGHCWZh/Ev1F0U=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_02,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020094



On 9/1/2026 4:56 PM, Aishwarya R wrote:
> ath12k_dp_link_peer currently carries state that is not inherently
> link-specific. Both the station pointer and authorization state are
> shared across the links belonging to the same logical peer or station,
> yet are stored separately in each link peer.
> 
> This series moves ownership of these fields to structures matching their
> actual scope:
> 
>   * Store the station pointer only in ath12k_dp_peer.
>   * Store authorization state only in ath12k_sta.
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
>   wifi: ath12k: store station pointer only in dp_peer
>   wifi: ath12k: move is_authorized flag to ath12k_sta
> 
>  drivers/net/wireless/ath/ath12k/core.h        |  2 +
>  drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
>  drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
>  drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
>  drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
>  drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
>  drivers/net/wireless/ath/ath12k/peer.c        |  2 -
>  .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
>  drivers/net/wireless/ath/ath12k/wmi.c         |  2 +-
>  10 files changed, 36 insertions(+), 84 deletions(-)
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
