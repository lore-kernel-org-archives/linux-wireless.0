Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793050494;
	b=TpG9wiRdZ1LozBeTDPzsUv4RmK0bmtxmfLzUNnmiQljnUd2M0mwVDOzdV3s9AXObMbml
	 KWUieUAvxKAZoTE8t/xJF32IGW5iqjPOQ38VpqjdB/63e6EMVeC1g+3FUO0FTfeUysJUF
	 mgsV2V+zNH4isJGbeMoO7mvEpDxTIldMn576YhFi+3NuhdHIxzFWgPmHaQlULhL2s8tWq
	 aXKbte+0Y9Qoz+YgUvZ3qIDhuyYbYmHpGGKTUV1cf6uSAG3wQ2tCRNbxiJWV2apxkNAAo
	 LKtxdRs6SiISlWI+TISH/Bi4qoPJ5o+LwhIXKUl3E2k5QA29DH4gTOqLXyqo1GMtq3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793050494;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5AZPPtzzlblW2grqxtek7t12IpTUi7Y5NH5yRWBx6eE=;
	b=kmmZ278HA+N91uUQH4Gd9Qlz3EW6puyq5A3Q3praHqRI5XCUhd6u8UJo3UDxSSiv33Jr
	 ISQSvEbJEYPv3YhY5ro83IFIInTJwec26zc9dvvBuogke3D2UQnj2OdeZ8K8iGJ04H6At
	 YV6N0B1x8+tauEyuetPDAbwxao/a7qa7ZUgmhF/9TYHgqZZj6h+sgufaBbpgFWHPSSc8R
	 QeMRDyca94MwppD+0w/ndugj6eOazCTDu9ZRSZ1VMhKjp1tU4Sy5Kem+g6tRanU/3T6IB
	 GuYjEyJchrAHRFQ1tXnCwlVi8naNQn8C2dbIONRPovhjMeRY/YNxBemSI7Vuk+foPTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HoIsvugY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="N2kH40/0";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C95606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 21:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C95606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HoIsvugY;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N2kH40/0
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIo2Op3585133
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 21:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5AZPPtzzlblW2grqxtek7t12IpTUi7Y5NH5yRWBx6eE=; b=HoIsvugYpfR2kurM
	7moKV8A6qIoWdgk6vO62Y0XvO2l47gFJR1mF0uNBeuvfXRzORgBKfHL0XK/kqgJv
	g0zMTPxc4P3OOV32SQxh5Hw/E003SKwOWH4tii7T984lqbzRljK3qWEyL2efPXVF
	mLAo1yJWXCtMuQ6phXfb9kgT9wsuVpIH/l4KHx53iuiGH9tIivuVKCCI9WkuA5XZ
	9zmROKtzWhd1nItZuwG92blqd8o991q6HOQ1yu2dVTP71Es9+R1OSPlJTexdoHih
	UmVmpzCColCzIwREDs6C/4bq3eSk4tjNCiYrIaMAtZ2c6bX5Kdhv+AdwfnfET7jz
	ibpUHA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjbmm8qx8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 21:34:53 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-351788121cfso3181368eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 14:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793050492; x=1793655292; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5AZPPtzzlblW2grqxtek7t12IpTUi7Y5NH5yRWBx6eE=;
        b=N2kH40/0lXNgyn0/nx1znHabA0rrQd/JY8AJmXwDNMkxf0d1ZxwxIgCyNGrVH+fhoC
         JwupQL7jEsmMLAtELSfuXFkm1Sd1hTaGip5YeAuewwfBh5dGeytogq8je02dT1C7ro9j
         accDQ0KhnTkvP9eanvBDwtgdjL2zlS8mTv3bjHSSBzqScuS13fb5qNeB5Tbw5iWzGch/
         Si6Xf1QX1qlS3ckn6Nf/c1Sbh/23XzrJlVdfXPu6KA59RXqkAFKUm1LPH9iGWczcHdFs
         bqIwekfKmklbfSNZWYVw1Tj66rjIOU2Jjydh5pe3tob1UpFPy1QsJZ3omm7BuTshS7zV
         LcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793050492; x=1793655292;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5AZPPtzzlblW2grqxtek7t12IpTUi7Y5NH5yRWBx6eE=;
        b=kBR0CaLizyrniAxfEFzerqwGi7N69cRU3Q5U8cCioaYemjyl9Gh2CmIlBXVMBMbQ4z
         6hoqOfFXTAKnDWa0JM3p6QI+HzQn9VvNtBWUHsOWKg/j+T3R/JelFeEPjTfTVywaBOEp
         MI9M9KhvVhUc9IZa1dZICk67OeTxhixQSzvGFOqNCTWvCNj6QZdYGI7NqTQIP/lZ9iT8
         YXeetTYOd3wO0+Ewp5BxC8LPslaP2BP4sSe2tyvcj286Y3tcixDhirL3rL5j07SJlhmo
         6nMthUmn5hryrMC0GpsOOYv9neJ/+DrXUHQiS4YOtrLAPu5b0lIciVT4DhGRgS/FFf27
         1r/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzewhMxlS2jbQS+JRvgTuviKnsIKbiIyr+B4TeGi6IxnBXtHnPvGgdyR84TTT3MoOs1I/yIaN69G7tTkMYnmw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJT2EDllvjBNJyKDI305BXS3wOwSrXJdp+ogOu6lyiP3f3I/Pyl
	KFr8NR5AeDEgoPjkkm8xPv9kdkmvrpTggXaUF0k6D1bzcqhrw03/Jp8jWjsFRoYmDCwCUxRt3TO
	ZijRxkJHu2I2U4JRQsfvvSSboop97U5RA+NoaTs1m419lh6ciXgSnoaUDNN4g82Dm7at+BQ==
X-Gm-Gg: AYBFou1Pobp8VYgU7UkV+n1FeLV8y2DEDRzYmoJDqgT33A/x2ff6szyQ4q0lv+NVVcp
	BFzSWNBAoYEwgkQjqVg5MEqmMqFO64IQ44o5dBAaNZ9CPsxTRDmUt8WWMv1DaE2kzbi1ii5gD25
	eHEON+oP8u3VpFilCxwDni77WScoBb65/X6BmCNHNwl1Kg1WvXt0a/DsE6M0BZ+XfPRjDRs59dL
	DHMq6NEDJrpksyBT0rCu8eWMjolqMfd2kl3YEPMx22u9Xv6RW2MQ266Ip/bkX0iGlCrZDRa9fUz
	RLw/wcTHqqaLWRwMLrt/eGPkgEYQ/8ArlmFOSpgcwm7pGVOfV2Gd5E1w0l/no6sNF719EiFyAPh
	dO3bNO0O7wWRAmThmi10P3RH60a1tQpSWshx3GtQ8a/y5LTZJ9Hg+WcTkuw==
X-Received: by 2002:a05:693c:42d0:b0:35d:4185:5395 with SMTP id 5a478bee46e88-369e845b094mr12574871eec.16.1793050491953;
        Mon, 26 Oct 2026 14:34:51 -0700 (PDT)
X-Received: by 2002:a05:693c:42d0:b0:35d:4185:5395 with SMTP id 5a478bee46e88-369e845b094mr12574790eec.16.1793050491179;
        Mon, 26 Oct 2026 14:34:51 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d93663sm32084643eec.13.2026.10.26.14.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 14:34:50 -0700 (PDT)
Message-ID: <4e206a12-1796-4179-a72d-cf33f0864819@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 14:34:49 -0700
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
Subject: Re: [PATCH v4 4/4] wifi: ath12k: Connect to the QMI server belonging
 to the device owned by this driver
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
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
 <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NiBTYWx0ZWRfX/q4kZw8KvXT7
 FHXnUBbXh6a+moCNWqrvLmFtdoRvvikBxbRCcJOYj/uZmIC99tjcEADSn4e5Ao5pWKrhkTgNOrQ
 ZjEJ78uSNXxOepUh/4pFYDulKKsh+PU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NiBTYWx0ZWRfX+/bX3yfDKJSo
 YHDO6H7HV3zG66HqVevS1xyOqOxstSBqjLMmeJ/ONQTLVe3wQGtmfglDsfU79z0dRR/o/Xkd5DX
 Yzu2V7PAroTstFExMWiI/RaZXEUnXgHtKnzUtpZHQsb0hmwB+ToRALqqnj5h6bOJoLXC+41AcLH
 KYhROinJ45UUk2HsxosgijLew6632NAc+uYh5xIXndZbBWAq4fEGpg7AOhdgMFvP/FpHdcZDJPG
 c7Bjwp+aMCUcePnPq+qxs4PHE9DgRTK45SfN0EYucxdMSryXHWPFSg2nu44mrty1nIGTtekGxR7
 TLcqGQCzCBGQva6aeK34PGAJGXyTSi8vM0vZuvqz1Z5bnfskkBcAhc/vAxSnU3Ge6NvYMNBR6Go
 Q5G1q4EWjEP06oNCnXl/CVN3FFJ7bgOXhyVJUtkBj4C36jR6jTaTdH45XncpGLyRFGRIDBC0ZjN
 OLjyeSwFm/FWJQswZEw==
X-Authority-Analysis: v=2.4 cv=PrkG/AM3 c=1 sm=1 tr=0 ts=6adfc77d cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=bQg6oyjaoxrshYPP:21 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=HQsDcwHZmgEkHUxyrjcA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-ORIG-GUID: pyqIfMTAOWKFrS4y8xiRlZ19K50ClCJM
X-Proofpoint-GUID: pyqIfMTAOWKFrS4y8xiRlZ19K50ClCJM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260086

On 10/22/2026 10:43 AM, Manivannan Sadhasivam via B4 Relay wrote:
> diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
> index 6441927b5382..9b6108c1abdc 100644
> --- a/drivers/net/wireless/ath/ath12k/pci.c
> +++ b/drivers/net/wireless/ath/ath12k/pci.c
> @@ -10,6 +10,7 @@
>  #include <linux/pci.h>
>  #include <linux/time.h>
>  #include <linux/vmalloc.h>
> +#include <net/qrtr.h>
>  
>  #include "pci.h"
>  #include "core.h"
> @@ -1491,6 +1492,13 @@ static int ath12k_pci_panic_handler(struct ath12k_base *ab)
>  	return NOTIFY_OK;
>  }
>  
> +static unsigned int ath12k_pci_get_qrtr_node_id(struct ath12k_base *ab)
> +{
> +	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
> +
> +	return qrtr_host_node_id(ab_pci->mhi_ctrl->index);
> +}
> +

note this hunk has a trivial conflict with current ath12k that landed during
the merge window since the ath12k_pci_panic_handler() that is part of the
context has been removed

>  static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
>  	.start = ath12k_pci_start,
>  	.stop = ath12k_pci_stop,
...
> diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
> index 280e50a1f31d..507062068f8e 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.c
> +++ b/drivers/net/wireless/ath/ath12k/qmi.c
> @@ -9,6 +9,7 @@
>  #include "qmi.h"
>  #include "core.h"
>  #include "debug.h"
> +#include "hif.h"
>  #include <linux/of.h>
>  #include <linux/firmware.h>
>  #include <linux/of_address.h>
> @@ -3940,8 +3941,18 @@ static int ath12k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
>  	struct ath12k_qmi *qmi = container_of(qmi_hdl, struct ath12k_qmi, handle);
>  	struct ath12k_base *ab = qmi->ab;
>  	struct sockaddr_qrtr *sq = &qmi->sq;
> +	unsigned int node_id;
>  	int ret;
>  
> +	/* Identical devices advertise the same QMI services, so connect only to

note that networking code no longer uses this block comment style, so it is
preferred to have /* on a line by itself

> +	 * the QMI server on this device's node. A node id of 0 means the
> +	 * transport has not assigned a unique node id, so accept the server
> +	 * unfiltered.
> +	 */
> +	node_id = ath12k_hif_get_qrtr_node_id(ab);
> +	if (node_id && service->node != node_id)
> +		return -EINVAL;
> +
>  	sq->sq_family = AF_QIPCRTR;
>  	sq->sq_node = service->node;
>  	sq->sq_port = service->port;
> 

Since the requested merge strategy is for netdev to take the entire series:
Acked-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

