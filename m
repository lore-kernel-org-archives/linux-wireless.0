Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0669647604F
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785860879; cv=none; b=VTdACDmImZULuX35MG5zOODq2SSubR51mikx0Wc7YF71TOPehtFv7ACJYg4yAaLwR/lzS8VDb2oedwuXS1G64evOG0YY9S/Nf4pRON50r5VYlEsQpalwPk/cnKOKjv3eNmgEq3FbtUNsziBPaSIvhVhD4gYfOBuy9ZCPUbkufHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785860879; c=relaxed/simple;
	bh=ru4zq74HTo4cd7cPddY/S4zAPUVpXVVN7sk+kWI3yRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttELyYSBsvVM+I8UtjH8JtGNEmT5y189Qdl3XjhZQ36HlyibVkfF1qhyMYIOH1dJRfLj5Eisj5UG99JFQfQCCWdhnxivbXWNDs/ki0O5rdVhNxpY1V+1KeQpy7CAmokbJqL/zL9zicognLELcA3TcVrU2mHRN1K3oe9qlMxn2jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dCJrnxHx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PIyddq7r; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dCJrnxHx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PIyddq7r"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674Ffk9O4051410
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 16:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rT+BsLlkR/V58zorm9wrpxTZPVaRDittlmHkMjcYSLM=; b=dCJrnxHxJYm92/tz
	70aOahKT8FaXTtQNf9jIEKsvVuHrEwBxNrz7S+rJEoGUFJEUh7oGjNwn9SWYfk3j
	7KMq7FkgsgWbblADVzXhrfdG8e2FNJRHj/Qm74uWj6bg/peV4ocE3b+A/dxL3BpU
	RUMdZ7D3HT5nrbb4z+lNIagfmIznKU2nL0ZxvnkR6FsvGc4ibwvIVEgHKojLJbwV
	00Dmm9PcucUs0ET3JRHdl4BxQcRhEVrMQLNADktrWMFnSmakoL2UBo5YRvELsAY2
	3NYBjQSiyLUwhwfR2w4xS1eY/mr6s96In6cUlVhXmL5E/LNy1JUcCNbOe9JgpDdl
	GiVmcQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fu7273g3x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 16:27:52 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso1504a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785860872; x=1786465672; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rT+BsLlkR/V58zorm9wrpxTZPVaRDittlmHkMjcYSLM=;
        b=PIyddq7r5DmvsseDGEu6udPLFgQfVb3yrFC+HpZsSSg7kwRB85jwywuzsIVPtwyKJl
         xAB9bwnHZ1bNU5IB3RLf7bYkmLC4+rNVEHGDV/nbEnSyehX/Vgef1J7XaLmXW+xyqW6U
         m/WcJEGjhHC81e8XiaAF6qu0DM2PZeMW3VWKXulzZIZoxWVF6uNPwkQPXboGeAulagIr
         hTvaNN0L5c3a3bv1uZZnLoPV1ohE8qa4KtR82cFcQq9QzCSLRDkzdwL6LLruufR6xuM7
         srXyFjoQGvxo1+ryEdNqM8DIsAN3UXJc1YJLbVVTpN+76k/0zcont7E+gmf+y8kGaWjZ
         ckCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785860872; x=1786465672;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rT+BsLlkR/V58zorm9wrpxTZPVaRDittlmHkMjcYSLM=;
        b=YVkJs5H5RFJa7c1nWU1MNKlkdHv8KKgB1yikAgim+yQFI5zFG5EzTi1zNpk7yo2pn5
         SWFld019oazaI/LsaC4oYA0id6lSR67GScIjVLBGOKyyow94Qwj38ydyyp6nYG+u+RkL
         yBRErosk4Uq6LDNoJmcsOds015RnA+Ahr2tfYDvBApuCnVpJmccQTOU+9DlQaRjih/AA
         RVX0Fa9ftKnPU+uF62oSxhLIG7G/xVm+YHRKmFee+z/g3BmnEbK+TDOLxVL+LHxdp2wA
         rbPxKh9LSpT9+6wZb4O5d4lT16RXUpE/BT/G8Hiw88kX6hfa8t5Z2vUOmvQ3kSUhbx0Z
         UKjg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/2fS0cQXwgohNP1M6n4FBEfhqSk7o09p3OjIkFJJClelV9IK0jiINqs9YxP1CWSCEeEzRv2/rBIh6P/2I3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRd+ONwt2AkrZ8RmoGGHyZkWETlSd2CnmcjJGbvtnP27RXB7kI
	IbE25fEk1hUfEe1supeY5eXv0xNcoesPrvp3dZO6GPEGRNmLL7tRFAYsm3P9Qgm07Aa1DQna31z
	GqR5NBNnm6mxyy1V5Q4JEmd/OikP6hT745B5QIEAT48Xa6B3gqQ2zi8U/s0oQWQBPRJmMTU2DYy
	XqsQ==
X-Gm-Gg: AR+sD13Mk7TP0rvPGZ8s+1gojPXWdHmefRQrG+sW7jo1mDE+eC8bjf2plGcYSkQFbML
	c+jPxk5bIWnLonOALVjR6GnukQsEO1jSAgMut8z1qwntg5vP0VK8Mq1iPGYoCne1lPpr2un6WsQ
	OMXzt2QTatDn/yf7ZFcga1dq6+C4lfs1dSjuFN164ijLsoGOD7uvJRG09t7D/IjawgO+ArsXd78
	0HcPv38UfhdmhNHI8Rds0lRZTUo0cKjbkzIkq2tFTdS/cnkJ/kwwUF7Y6AZ8GA9Ux5mDry6/T3H
	bIvOLb5TdPHxuI8wdIutuM7eyR4hmGP8z5z/wpxkJ6/ap/IbkbGJcbwgP+E+wR19Z28jPDqDJ5L
	9HzcdOlZFfgshaj6ZdFybZfW6COP6NtUVRoK45m4=
X-Received: by 2002:a17:90b:1b42:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3903c5433e5mr263026a91.1.1785860871718;
        Tue, 04 Aug 2026 09:27:51 -0700 (PDT)
X-Received: by 2002:a17:90b:1b42:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3903c5433e5mr262987a91.1.1785860871212;
        Tue, 04 Aug 2026 09:27:51 -0700 (PDT)
Received: from [192.168.1.5] ([116.74.42.160])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867a68fdsm10301595eec.25.2026.08.04.09.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 09:27:50 -0700 (PDT)
Message-ID: <d32c45b3-f430-4f8c-9d6f-724d95ec9c29@oss.qualcomm.com>
Date: Tue, 4 Aug 2026 21:57:43 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ath11k: modify null check logic in
 ath11k_ce_rx_post_pipe()
To: Mikhail Lobanov <m.lobanov@rosalinux.ru>, Kalle Valo <kvalo@kernel.org>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Miles Hu <milehu@codeaurora.org>,
        Sven Eckelmann <seckelmann@datto.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        John Crispin
 <john@phrozen.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20240909150824.28195-1-m.lobanov@rosalinux.ru>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20240909150824.28195-1-m.lobanov@rosalinux.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDEzMiBTYWx0ZWRfX1I2qBtNQGrE2
 4bVA6jT8hoo+afmiuH4NHQl+xJeeW4qE9nTZk3iZOxxYWHxhY2BbmPuLEqnCBei8SiGm0iJV0ix
 QjVI+OHyfsHHPIERPCFh64Md7icDMeI=
X-Authority-Analysis: v=2.4 cv=Z6Lc2nRA c=1 sm=1 tr=0 ts=6a721308 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=1uVfqaZqOROvog6V8p7mZg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=HH5vDtPzAAAA:8 a=he8YDqbjAAAA:8 a=EUspDBNiAAAA:8 a=eE1TrZLfpK1Q4X-vsd8A:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 a=uKXjsCUrEbL0IQVhDsJ9:22
 a=QM_-zKB-Ew0MsOlNKMB5:22 a=lRF3faHqDRKgy28aj_NN:22
X-Proofpoint-GUID: _Q2KlOFsqkZwATLw8w96ocsp2wPGLFtl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDEzMiBTYWx0ZWRfX0wWiKFsOpkcC
 /7A4d9T8VUHqDx3ehXebYBl5GKJMZ5vlMI2h9brg6h+esk8TYH5tlTZqjPJvT9e/u/mEBAQqc//
 4xW/p+LC40yKe6eUJTmOKWAoBStdPoTlSj6W9J3MD/oTjDKleB7FdClXx4xpnKCy6AUTXLE8cHM
 XHEQUCsrFq/ZEXgcpMR2jOnFayD6hg+SKSSkkpDXzmdHLdxXDc6JGD38kdrE9evpzv100rpCVQc
 GjJD59si4hyfDAqiHZIV8vz9nVWS/gWPORKjMKu3bLuWEBiQUCvCdwhHCdpKuJMFUX0yKmbXv1F
 0BLgpIihnFgI891eQtLRMcrt8WezyTq5Q5yRd8VvCqma6yeDn7YGVqELg3qJGeaJeCpxqZ7Tl1q
 LPEYYXNCxiF+cIZASI/FetTbezVxSwsCSVVhb6CPb2Ype5lGHXE2ukDwbMFba1grexwUZnjZGaD
 E70YwKJ1riaMEMEX2Fg==
X-Proofpoint-ORIG-GUID: _Q2KlOFsqkZwATLw8w96ocsp2wPGLFtl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_03,2026-08-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040132

On 9/9/2024 8:38 PM, Mikhail Lobanov wrote:
> The previous logic in ath11k_ce_rx_post_pipe() incorrectly required both
> dest_ring and status_ring to be NULL in order to exit the function.
> This caused the function to continue even if only one of the pointers
> was NULL, potentially leading to null pointer dereferences in
> ath11k_ce_rx_buf_enqueue_pipe().
> 
> Fix the condition by modifying the logic so that the function returns
> early if either dest_ring or status_ring is NULL.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

