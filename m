Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D369336895
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790700375; cv=none; b=q/Ae6YGrBE8ZksxRUpfKEQOHEmLCY77dddT3ifwOANLgV6x7yQOWUpd8BH+s0ZG9UKKgIuUf265Nhp+8EGq4Gy4HHr4IqsM3dTgcXTfZ7JLXxDCspkkoV4yxXUBOux1L7N9d1SQK67TWkO4rjRsyrOFkAQdhYvsuqAHKJMpHb1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790700375; c=relaxed/simple;
	bh=LiAihPoxkqZdV81WngRsOiNeAPyzqkFVESOlCfUvRLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IhIlAGDny70ElbIgxBcbt7QUlOrzq6iyM0rDkBUhm/n48TIjqccBKqAndyWni6vLwm7N5P+uZR+W8RtXy89gjYdSM+Fr/ruKEakb8VigDGqaBmliGrCwnMQVifKdAEQG46BLGOXMrrvxok3gW/wJaB9sqP3+H3t7eZgWzPwkvJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dEBN0i2t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bl2pSz6y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dEBN0i2t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bl2pSz6y"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TE660e1649664
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0skssNQvXHTm92GRJQRQsimYFU/uUs18xsPOZJ94ZoU=; b=dEBN0i2tek0zDky6
	2xI8SRkTy6muUz4dBIrz5fe7jg4NsDeBcPu1fmFwmFPism/3Mve1tUgchm9vVWiy
	rbGvcFEEKFcZj7H+hBGqfrNwUVs0WLk17xz4pfc/afWR25wAD6QjogN1PTTGx4zw
	qeD7XSMnBp328oah9kwACp33yA6E075kQbHQPfJlHPBLA5JD9V2yTLZ/+QlDGCCv
	g1GygBe2FclhSsPSm7KcP6DP/Yy584l0vcAVGOXzvdreTAF7Eado4xpA9w+2QJXH
	/m8beGrThSCMXvlWsajxYKXc2ig1azBaBspMBFo7EgC+CbiLC61r5+ZhMM1aQtjs
	yc1JSw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0et28rb4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 16:46:12 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39d865b11b4so4987193a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 09:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790700372; x=1791305172; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0skssNQvXHTm92GRJQRQsimYFU/uUs18xsPOZJ94ZoU=;
        b=Bl2pSz6ya2GNjjjeXJTauTZP1ZdPbAZSLWkEX08hFUEg/y2o/TuIQUuz1yl2sfabJo
         ZagApknKBgb5oT05FOIagGA8+8oCJGOq571RwryE4ft5wV80aJlZBv8Aiz84U+BoPklb
         uLPv2FWE9QImk7BU5DwCDcxwjxpscRHzUbgh/tx9mwsrJulykuxhCTjdQtmoa9wgfzze
         ZlzxHQJHRZudYC24Y8pg2ySXSiyGUI23bpEjko7KIvGf3OEtSSvxPGIEyeXT1i8HrkuI
         rWObMcJF0p4TRb4ui2lCP1+vaMCFO4nXc92Is1vcGDokeBQmaMPRWGR2tEyL7oYavOoj
         xSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790700372; x=1791305172;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0skssNQvXHTm92GRJQRQsimYFU/uUs18xsPOZJ94ZoU=;
        b=lXe52VHoNLCYk25O65hacv4oCFAfocedydFvmt4VmKrEGsAAMStstF5O7Lt6wR43Z9
         1ZmTRfg0HukujWlemvHzrbisuoRUfIezCBaPEXw6aoNAoREhiAGDFPU88EAVRyKbgJqe
         02Yxn2g1P8iAxblMvvNCLS5RTdEOGxCrfnrtsDTYJamlXkWQDxPFEWcIzHs4lRZgdAjN
         ZucUAtEAt2E+nSTl6IfUxQzRsgWtR1SJweM/+5YHrs92MWaPoUOX2BR5Pdtv322XP4ao
         XTgYBdzJS7Txja+2ucioTplxH68bMrjignlkBBDMZOj1BviVzgm+4zZmfsSYReFwmF9R
         XC9w==
X-Forwarded-Encrypted: i=1; AKwUvBx+NMgvPi/BFEKyOgDO+NsB/BifE9d/aDIJSCvF8fMgv+Z8SGyUAQLTJ4BdhkFPQtK2tZBIcmsifWofwffFVA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLkfgg6OFNel1C/4tAtetJNvVG288sR3kT1RU28wcVlaUFCjh7I
	8xoaWVNu2MQ6hlYuyRVdaELEkXtKczgh0rTKmKpj3Deyq43qhhAweG8bnD3J4I9l0Nzz8QGbD2r
	zCBdujAdU3bsJFOOdLycXi19CzMTx7JsqepZjzgKPvSRKaLTUqoIxfd+9PdZBbgi1sFOZ6Q==
X-Gm-Gg: AYBFou1nBwzr+W86oi7KlPdsY4PutxFg8AudKyjFWc4vD+M0thgSCLvLooEPu+PWqZ3
	6iM5u37sBBO3RP7Ny+5Gxr2gMJhm++4AKaNRP9HagYJhb97BFvu/+UDjA3lpAxYl+mqwAQ8/FFp
	7ErjYsRSeLGlvOeexM72BZX9kUxqd1YDAGoCx3lraKGDKTVzgFxfFfX3HYWzypHXB3KWzCnv/tG
	nKuMepoTzf3izZaiWJpkxw44rCUmSG+yl3QSRNXOvHDQ0DNPuI0rC6qoAU6ruW2uVgIrkFcAU6h
	34jFJHqoHmsCxZ/iu0qAf5CahTipw1OwZKVnLIShRzzelNtJV/YkT+Ha28fvaNSyZUSXl1B3T+K
	c4lyh1ZTq/MNer8L6
X-Received: by 2002:a17:90b:384d:b0:39d:fcbe:fe04 with SMTP id 98e67ed59e1d1-3a0986eb55amr14369935a91.2.1790700372111;
        Tue, 29 Sep 2026 09:46:12 -0700 (PDT)
X-Received: by 2002:a17:90b:384d:b0:39d:fcbe:fe04 with SMTP id 98e67ed59e1d1-3a0986eb55amr14369900a91.2.1790700371572;
        Tue, 29 Sep 2026 09:46:11 -0700 (PDT)
Received: from [10.216.29.115] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a49858bf27sm6367683a91.4.2026.09.29.09.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 09:46:10 -0700 (PDT)
Message-ID: <7aed969d-0868-4c9c-967e-7766dbba427e@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 22:15:52 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
To: manivannan.sadhasivam@oss.qualcomm.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
 <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
Content-Language: en-US
From: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>
In-Reply-To: <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: U9gGhok6ErhdePsmQo85VYP0TkEHk5CU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2NiBTYWx0ZWRfX5pvim9YixHxi
 3CIss6b+zEs4Q9oeCewVfvlrnaMl/vsKb9V+/o0b+yAo2SanMG9pEfvM9oxt2QpoucODBbNg/i9
 o0jaQFkQ5TLDBf+tDogMFkYvei/LIu/gb38YTM6BOTv8rSxVLofZoayf4yWJA8rCt3B58LRTUm6
 7DupQL1SV8D/1YxTbm7IduXHSXVHbMxY/tcaHxs23LU+ER1EbZfQ8Ernem9a0SwqxTLtQ57k7pQ
 eodbsu5kkoi5lwWbaJ6+vajSjvSTUJ6HJfQsmeHvmIpVtDarzRp6DeQveZUEWXuzbRiC24ieGKW
 RiPypXri3DNWZsbnw78wEF2kO3BZpBLgJz3VF3rw3PUe/f8O91UhUmZ9EPBKv+26Otocnh37e8y
 Lo1BxzJvKyiesgskE1yLiUxMzmNg5lQBB+cWD+D/P2R+lxFiaAJfGEExWZbUO+Ae6lWHNcYEMkD
 OvmvCaCb9AfrxSnL9fQ==
X-Authority-Analysis: v=2.4 cv=cokOAF4i c=1 sm=1 tr=0 ts=6abbeb55 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=4CdhTua64AM6UaT4niYA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: U9gGhok6ErhdePsmQo85VYP0TkEHk5CU
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2NiBTYWx0ZWRfX9XpyhN+5raE0
 0TJL6YiFAe81yAu44kWmW/+SNodI2YBbeoHQongYJB26f0snQ81RADF6LW/q7i08/WG5IyXOSVn
 C30QxDGNK9FHNdYsAMbW7zhrB9dD6XU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290066


On 9/22/2026 7:11 PM, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>
> Now that the QRTR driver allows using the unique node id for each device,
> which is different from the node id received from the remote node, compute
> a unique node id using a new API, qrtr_host_node_id().
>
> This API takes the 'index' parameter and adds it to QRTR_NODE_HOST_BASE,
> whose value is outside of the node id range used by the remote nodes (0 to
> 0xffff).
>
> Finally, call the new API from MHI endpoint driver by passing the MHI
> controller index as the parameter. The MHI controller index is unique for
> each controller, thereby for each MHI endpoint device.
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>   MAINTAINERS        |  1 +
>   include/net/qrtr.h | 21 +++++++++++++++++++++
>   net/qrtr/mhi.c     |  4 +++-
>   3 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index df8ab9b82402..9c8bb086be28 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22511,6 +22511,7 @@ QUALCOMM IPC ROUTER (QRTR) DRIVER
>   M:	Manivannan Sadhasivam <mani@kernel.org>
>   L:	linux-arm-msm@vger.kernel.org
>   S:	Maintained
> +F:	include/net/qrtr.h
>   F:	include/trace/events/qrtr.h
>   F:	include/uapi/linux/qrtr.h
>   F:	net/qrtr/
> diff --git a/include/net/qrtr.h b/include/net/qrtr.h
> new file mode 100644
> index 000000000000..745d51b4a6ba
> --- /dev/null
> +++ b/include/net/qrtr.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _NET_QRTR_H
> +#define _NET_QRTR_H
> +
> +#include <linux/types.h>
> +
> +/* The offset is chosen carefully to not collide with the node ids allocated by
> + * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
> + */
> +#define QRTR_NODE_HOST_BASE 0x10000u

Can it be exposed with include/uapi/linux/qrtr.h also. There are user space clients like modem manager
which need to calculate modified node id to distinguish same service from multi modem over mhi.
This is same as wlan use case.

- Deepak

> +
> +/* Compute host node id from a per-device index. The index must be unique
> + * among the host assigned endpoints and smaller than QRTR_NODE_HOST_BASE.
> + */
> +static inline unsigned int qrtr_host_node_id(unsigned int index)
> +{
> +	return QRTR_NODE_HOST_BASE + index;
> +}
> +
> +#endif /* _NET_QRTR_H */
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 3990da1a65dc..c920ab61f848 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -6,6 +6,7 @@
>   #include <linux/mhi.h>
>   #include <linux/module.h>
>   #include <linux/skbuff.h>
> +#include <net/qrtr.h>
>   #include <net/sock.h>
>   
>   #include "qrtr.h"
> @@ -127,7 +128,8 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>   	if (rc)
>   		return rc;
>   
> -	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
> +	rc = qrtr_endpoint_register(&qdev->ep,
> +				    qrtr_host_node_id(mhi_dev->mhi_cntrl->index));
>   	if (rc)
>   		goto err_unprepare;
>   
>
