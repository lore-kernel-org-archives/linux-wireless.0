Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759186;
	b=OBOn8SalBkS+jYncZbcLpj/2jboNbpZ3bcmcQdJGNRDVfbqF9z1J/tPW4fIv6pWzLw/C
	 e9C6utr3BP3LqFcnBOtDVcDwfYY5hjBsiCwOE6w+ElwfPlQOCud+uIABgQm5oCCv6bnoe
	 aEH5jfCIAZVSyISxsgL3i1xV/SEN8E7B3qpU90PS47pPjQ0fU0sYKawFoMU+uDV9pNPgv
	 1/8Kd3lx1vY5ARq5LfCNJr/8I3dvz1PHkqLHhgRTZvS4PM2a+QUvm7eqPK7Loic4Z2D9h
	 DlCfTNA1OOHdNzxSHnYWx/nTshUdZ1hXw/7BHOq5ejNVJNjRhvJWiNnjmVD5VCzSI+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759186;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=+cU716QQkciKLnAv+AvMyJeOWBaGEIckc4N/C6sF0hc=;
	b=TkiIOYsgjwDyygQBTc0gX3fPJ+fZ0TwGPvY1+Q5KbPOU6deDji+lONvcsiVo0PbBIuuN
	 ZMDNQXGD1cA9/9dVBRov/6LjkjiP4fjjE19H2a2yH6lw2D5G7Yb2lLA3dBxX9rk7jpBI6
	 adBHZaDQKvqlDJOX9OUzeWTx+djcvwPYZmwz01fwiENSOxeFyOxDGoRNVPtcGPCPPTPwr
	 uS+gpIv8V5eCjRM1pRQDHwkYVsH+ES2iw6BkRYeRrMsrfsWEXtxyfbjWjO+eodh0sesUn
	 mwcFOAnfjq0bk3Wyvvd6fPoNjqUOUhs3SSIZV7n6nLQglMKz1z/m1CnLyVw/J9lwGyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nuOhRHub;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OZGb5jpy;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B65606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 02:26:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12B65606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nuOhRHub;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OZGb5jpy
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RGwo1248587
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 02:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+cU716QQkciKLnAv+AvMyJeOWBaGEIckc4N/C6sF0hc=; b=nuOhRHub3riCWUWA
	FzZpU9VxJ8prfCiOttOX3kQWvXl0LsTNEobz+SOTZUeE8ZImUlPiGisOAge3s1RG
	7k9DdYNpDy2+p2lWJ1UHCW7xmxRuvbCoxX6HT6x0tDwoFsW26F6VMUSGHbp6l/AH
	kph9onWSQcUv4oE1nAuCihc0mpIIr2QDCL6HCoWK+OUl4QPMdFgd3pFUFjHSUTIN
	wqAxyOSpB+MEKNWlFS7mlQJUK1xAQNiS+2CWtEkeQiSmtTV9cM+cxCiHuPcWpLp7
	vbro/I983LhEELLVNSyJUaGSgYNta3f+RaaLEIYQlqLC/2GzV8cx791nKJk6r1pL
	x7jn0A==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqpuv93ms-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 02:26:25 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1ac19c6bc71so222810c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 18:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793759184; x=1794363984; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+cU716QQkciKLnAv+AvMyJeOWBaGEIckc4N/C6sF0hc=;
        b=OZGb5jpyQAp/Akm5C4y91qCqXhlpIVUNiCtofJ17MOUvo8qcYer7YAyUXlIBtztZey
         gx4d+RiH1xdEZuJ/Nbncwyhxt2o2g+RrGWj9MDXdtT5EOSgWz6qhhWljKdnUsaPaCxqj
         s8HWLfrUXhS88NLFu44lfxcMRHGh5VNN/ElviJ3K5b1eTRUlm7brbWgBZ5yPYQqesO2k
         1/OK0TpqVZW2AoGRYqhO2VJQb0u3s3ludZAEb7vpuwyAPfTKgVw+ZPFGoGPNl4tgRMNZ
         oET31IfXpQfahkuiU4GYKcT3V323v6FhsAHHiluooFQM/prPlgImQtjVgQMsdjCmvlHP
         IfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759184; x=1794363984;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+cU716QQkciKLnAv+AvMyJeOWBaGEIckc4N/C6sF0hc=;
        b=BsSFxAA4OJNqSWJHw7P5eGHo+mcrO+tI6cLyf4pEGkP6AUDQcER5Ovt4WFU6zwtHNO
         dBA3VJXbLHRH+oOlTi/CSpALPn8wkh2N7XJdlsd8rwcrSmHU11c9aZSmdBGzJiqhQU+2
         quhPfWyBy7Xp7sx+JveSgJJbN3ZJ9j4LV/nD5W0qYuJo65Xs0mQpxvB07u3g9Sb6vjf2
         yTbRwUSlQf/3RpJqAPWIXqAejMhg1ccUzQ3JV4CCbsqklV9VwC9qM4OM0+dSb8tZKOFE
         uoB0hMJxbUa24/EKIG21ykIJJmKLDl5jtKzLo7VtIlHkhkkvnp2/nVcZjVE0MS0ukBlA
         69sg==
X-Gm-Message-State: APuU4Z+mUkuWlRYeFv1/VyYqv/SfXoNvRRqM3jihDOWU5Wyhad65Mwm0
	epW9P+Z/M9M+N+wbBsvA9r1zzAEVgWomseTjFLW+otUD4JffGbVXj9rCpXChjje5o3sm5i2ljBk
	ucA3IICD7o3fLGFhPk2waNkSm0y/xQV1KnjTSrReGzSy153NBO7vchiRRfr4jD+f075brrA==
X-Gm-Gg: AYBFou3c8R5v/gprFvFdQjDPtjO+Spd/68CTLA1YmzW/+Te8ReqOOmj6x4gwGqjMa0L
	4lzHhl9TtNp0NwgECu61RPm52FpS6Egk3/eA3tZLP9S+J4o4I9VN0XbBppnInRuKicNpCKhvCTK
	OwuQnWsAi8HF6PkaVfqZLloANzBcm4REtJAN1kFhhak5sd9OCQg15aI6XPly2pVYA72ufWs9GSq
	axi6nUi0Y04DuKuyLu8K2SFoYIk5L3bYTR4F3YH3DVqkWkaPfr9+lXVPgZTFIR9Ao8J1htWehhU
	w0NTIdrmibEYO47HZGK6LX84WxgnwTPFrgDZcqdwX4/G8lYoB8BfTvguU7eClJcapmdKeTXMDJ/
	XQJGvp9QmgqmV3nMwPOwA4NDF1l6GBp8Q73IwADdSEMuRPKfDuDKyNs20SOSo5w4NXXMc8VI3Xm
	UU8uN7om2Ytq4ouSGKtBJ65VNCncwXQA==
X-Received: by 2002:a05:7023:a89:b0:1a8:9857:2102 with SMTP id a92af1059eb24-1ac5f183841mr23414818c88.30.1793759184373;
        Tue, 03 Nov 2026 18:26:24 -0800 (PST)
X-Received: by 2002:a05:7023:a89:b0:1a8:9857:2102 with SMTP id a92af1059eb24-1ac5f183841mr23414760c88.30.1793759183594;
        Tue, 03 Nov 2026 18:26:23 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245ac2f44sm3519573c88.0.2026.11.03.18.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 18:26:22 -0800 (PST)
Message-ID: <ee2377e1-2722-4068-b4b6-44191b1b28dc@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 18:26:20 -0800
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
Subject: Re: [PATCH ath-next v3 00/13] wifi: ath12k: ng: add Wi-Fi 8 REO
 command support
To: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=O6SsLx9W c=1 sm=1 tr=0 ts=6aea97d1 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8
 a=JfrnYn6hAAAA:8 a=VGIz9s3jmixilTPFgOsA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22 a=FO4_E8m0qiDe52t0p3_H:22 a=TjNXssC_j7lpFel5tvFf:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: 28vjc6u0ot3h_WpjqKvrXiI1eds3mRML
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwOSBTYWx0ZWRfX6fpjKYeR773s
 2VWAdFFFkfojkS9otzBwg3qABnX0XJx30+3JhRoJn1fyUFVMa9WjoLFJO+XNNItk9pUmQsIibfe
 LPRTR4VmkTJWqTEAvAUoSYFroaGeORM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwOSBTYWx0ZWRfX+OjFHeBxbx7g
 t6/4XgYcMWp9bU/LYkOTlAbY6st4QCZ74oHxo+SDbA5Gayyg7Ia4lTfvd3h+HevvKRoX0uB6cZG
 r+aDmAQZwXxAsn2tcC5gp7uqCmXfnACj5skTaJAAnOr6vMKi4rq54+GvGB+P/yAUMCQjQTdrcrC
 YARW4/7v5DZ8EMHdlbu3rbacRAw8dqqmtHdy/ULT9wUtPPz7PTlrqD0SSAwAY7mu2NRkF0lHuRw
 H4jsiDtr3wmHDRjv88ikHd/MuWz7gsJbn3Z3V4xGPtnQZzWr5n1oBH2kWBsLEQmvOcEDf4jj1Ps
 sYKHpRRmHVaMcwYqC6Okq2d41qZrjGVi03fvlNaZwMYUb706Ln1TUj/UWBTBa9ODfbRswSHkR+V
 ybb2GC1VQl3YNEsf1+np6DzNSBYCVFTBPsq8BjiFtN2U4aTIkPu/9/oBNwpz6f1aNXOb+RYx5Bk
 GF4/YJIqpj7qSNFnCRQ==
X-Proofpoint-GUID: 28vjc6u0ot3h_WpjqKvrXiI1eds3mRML
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040009

On 11/3/2026 5:10 PM, Pradeep Kumar Chitrapu wrote:
> Add the Wi-Fi 8 REO command handling needed by the QCN9625 datapath.
> The series introduces the REO command and status descriptors, high
> priority REO command ring support, common command context handling, REO
> status processing, 1K queue statistics parsing, batched command sends,
> REO queue descriptor helpers, qaddr cache clear support and RX TID REO
> operation wiring.
> 
> The last patch fixes REO TID setup on Wi-Fi 8 global-peer-ID devices by
> using the host-allocated dp_peer id instead of the invalid link peer id
> when programming REO queue state.
> 
> The latest dependency postings found in local mail for this stack are:
> 
> Depends-on: [PATCH ath-next v4 00/12] wifi: ath12k: ng: refactor DP and HAL for multi-gen arch-ops
> Message-ID: <20261103163435.2682252-1-praneesh.p@oss.qualcomm.com>
> Depends-on: [PATCH ath-next v3 00/10] wifi: ath12k: ng: Add QCN9625 Wi-Fi 8 HAL register and descriptor definitions
> Message-ID: <20261030120743.2687216-1-praneesh.p@oss.qualcomm.com>
> Depends-on: [PATCH 0/4] wifi: ath12k: ng: Add SAM support for QCN9625
> Message-ID: <20260921090656.1575082-1-aishwarya.r@oss.qualcomm.com>
> 
> Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
> ---
> Changes in v3:
> - Update the cover letter dependency references to the latest versions
>   found in local mail: multi-gen arch-ops v4 and QCN9625 HAL/register
>   definitions v3.
> - Clean up the global-peer-ID fix by keeping only the wiphy-locked
>   dp_peer accessor needed by the series.
> - Make the dp_peer accessor typed and local to ath12k, and drop the
>   unused RCU accessor/export churn from the last patch.
> - Link to v2: https://patch.msgid.link/20261021-reo-cmd-b4-posting-v2-0-e8e3f482bfc9@oss.qualcomm.com
> 
> Changes in v2:
> - Use a lock-held helper for Wi-Fi 8 REO command queueing.
> - Document all-or-nothing SRNG pointer rollback for batched REO commands.
> - Use the shared Wi-Fi 8 REO queue-address LUT for qref updates.
> - Link to v1: https://patch.msgid.link/20260923-reo-cmd-b4-posting-v1-0-74935135a2de@oss.qualcomm.com
> 
> To: Jeff Johnson <jjohnson@kernel.org>
> To: Ripan Deuri <quic_rdeuri@quicinc.com>
> To: Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>
> To: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
> To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: ath12k@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> 
> ---
> Pradeep Kumar Chitrapu (13):
>       wifi: ath12k: ng: add REO command and status support
>       wifi: ath12k: ng: add high-priority REO command ring
>       wifi: ath12k: ng: allocate REO command context before submission
>       wifi: ath12k: ng: refactor REO command framework for extensibility
>       wifi: ath12k: ng: log successful RX TID queue updates
>       wifi: ath12k: ng: parse 1K REO queue statistics
>       wifi: ath12k: ng: process REO status ring
>       wifi: ath12k: ng: add batched REO command sends
>       wifi: ath12k: ng: add REO queue descriptor helpers
>       wifi: ath12k: ng: add REO qaddr cache clear support
>       wifi: ath12k: ng: add RX TID REO helpers
>       wifi: ath12k: ng: wire RX TID REO operations
>       wifi: ath12k: ng: use global dp peer id for REO TID setup
> 
>  drivers/net/wireless/ath/ath12k/core.h             |   2 +
>  drivers/net/wireless/ath/ath12k/dp.c               |  10 +-
>  drivers/net/wireless/ath/ath12k/dp.h               |  15 +-
>  drivers/net/wireless/ath/ath12k/dp_cmn.h           |   6 +
>  drivers/net/wireless/ath/ath12k/dp_peer.c          |  14 +
>  drivers/net/wireless/ath/ath12k/dp_peer.h          |   4 +-
>  drivers/net/wireless/ath/ath12k/dp_rx.c            | 138 +++-
>  drivers/net/wireless/ath/ath12k/dp_rx.h            |  20 +-
>  drivers/net/wireless/ath/ath12k/hal.h              | 103 +++
>  drivers/net/wireless/ath/ath12k/mac.c              |  15 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |  63 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |   4 +-
>  drivers/net/wireless/ath/ath12k/wifi7/hal.h        |  94 +--
>  drivers/net/wireless/ath/ath12k/wifi8/dp.c         |  28 +
>  drivers/net/wireless/ath/ath12k/wifi8/dp.h         |   1 +
>  drivers/net/wireless/ath/ath12k/wifi8/dp_peer.c    |  16 +-
>  drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c      | 643 +++++++++++++++-
>  drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h      |  57 ++
>  drivers/net/wireless/ath/ath12k/wifi8/hal.c        |  16 +-
>  drivers/net/wireless/ath/ath12k/wifi8/hal.h        |   3 +
>  drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h   | 377 +++++++++-
>  .../net/wireless/ath/ath12k/wifi8/hal_qcn9625.c    |   1 +
>  drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c     | 813 +++++++++++++++++++++
>  drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h     | 103 ++-
>  drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h     |   9 +
>  drivers/net/wireless/ath/ath12k/wifi8/hw.c         |   1 +
>  26 files changed, 2347 insertions(+), 209 deletions(-)
> ---
> base-commit: a2fa01354eb39e673f3f09e6c1cec39f82f0f9ae
> change-id: 20260923-reo-cmd-b4-posting-af227314a3b5
> prerequisite-patch-id: 49882cc69530a316a86f617b0b8649c3e753fc39
> prerequisite-patch-id: 6fe238c82896b9f8b39fa0f09e32fb72d82ea6e1
> prerequisite-patch-id: f09a16b2b6b388cb3290a14d86f4fbe370929680
> prerequisite-patch-id: f7fab6336752c5a6e2e45221157c05a2845b1057
> 
> Best regards,
> --  
> Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>

All,
This was only supposed to go to the Qualcomm internal list since this is work
in progress.  Please ignore.

/jeff
