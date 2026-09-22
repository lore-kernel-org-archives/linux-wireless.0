Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F74D539764
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790074942; cv=none; b=flNjX7aa0xHR2E340kj2UycBjpTbOiCB3n1dD2TrU16RBtdLMjaPcgpWAn0dCV4TZHtyvZK8bLoK6Dr0myscNCW3gF/shgTA4t6VU6+8sqLaxanHoiOHFTJzjcv8AjjIl9MtC9eqfFdKclSvJJJetGhKs2Ub2UD5DlsaHP5o8mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790074942; c=relaxed/simple;
	bh=c/gHB78b+REkg1KShrJuw/VfjHzyhX5Grd/Q9g073SQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TBzZQ8vl7Gdid3PnnSLEkB2HpHWtLe3T3V3EmiuFThjgon5eRY7/Ql1KuGKjpaOlngr52Hqo6IIazLPpnZuGjFgjBntwtK4VL0WTZu+svSiDyp1rghxvtBemNE0g8nygyo1A9TM6TjX2WdW7iaNYALoRsxyA1O9oEa0b/+HviLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O/9/FtWx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WzHD3OQv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O/9/FtWx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WzHD3OQv"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MA3BC9801568
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UG1NMm+Qs5qSxVwFob/kretHVwJFEGJ0GkvM3SFCL+U=; b=O/9/FtWxxKdesNdn
	X+jhngUM6a2s+f8cRg9BnTHs2IB1PNnBRiC1xXp4TMMwDFbYjqQ/N3TVfUQJW8sk
	zME2nth6+gxZpgbZ3yvB2MeeqBAD/tYgO2iRPyrrbkFNoGL8sq2Y3s4l5jgI2qX/
	uUHppnv09sG4NdpeT5LckSjZU3vI5z6hwxhRw8QYWBawGSRVF+v6R51JZFtrOV++
	3lByHLhyPB8ufyRl5Eh5sry7IL8HqFOTY19Y1dQHC3g0rKiW2An1/8k+OYB3TLSD
	rrVbvgu1cGLnMQMVey4MDWaNNa42OakQEYZLFaQ5C6rW7crCZ5Y+qfEXn5g95DVY
	8PSBfA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guqk4r77m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:02:19 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39533bb224cso6991084a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 04:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790074939; x=1790679739; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UG1NMm+Qs5qSxVwFob/kretHVwJFEGJ0GkvM3SFCL+U=;
        b=WzHD3OQvKC0zI4V7IUO1blIfxQPfNlMXC2Q79THxGS31lrY/yHQ8EzVmRcijsowtn5
         TTrQYbZ3c2NrHBb71VZT2+pIQhlQeIvr5S6xPTp+fgFF8nD3+VBu+o2tCnk5EAvDGli1
         Wc7xq5Xdfgf1baPiZzjbRAdBReUGAfZ357TCoRHXTRRfJ4UYYCm0Vc/pH3vCPUomOjPS
         4/9PmeeadTMTvDAzpXI3bfJjKHhJpojdw0GQLzc7QDFmuAZU9v2mM/K+PtEYfyq72nDo
         rcfEBj+yfSw8MHciYrYsyqYffMMvZCi1UdJOdYQRE8Rg88Z9b7MQoAPLjLSL5gfY2/3z
         SfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790074939; x=1790679739;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UG1NMm+Qs5qSxVwFob/kretHVwJFEGJ0GkvM3SFCL+U=;
        b=phvX9xEqTxaAv4tXR9crbKdUDzfnK/haF1RE3K+jxWGhOGDbBxO4u6FXYii7tjocqM
         491gz1N4bUS0TNMMRAvLPMllgwdax1uxcG+q+VMfyBht8zpPMuMG59qycJ2/bcoYxqcE
         1mQfIaFJ7K4zKINlGJM8gtCKm0suQfcoJECAVDQodYhMZdWKD++DHeaUVNLI4s42lc1H
         OIaWSH+UHVm/4o0u2d2wont/xXUuEuCQXJDw541LqjawKna3F2YUmyTx2UcnNi3swpFr
         HW1FcNxLsb7fTRC+nulFjzRykW6KuUF++VZ3QWvuwGO1jPHNhNQdyCZGqkowwiTE5TjQ
         1rYw==
X-Forwarded-Encrypted: i=1; AKwUvBw2PVi95BBCEmQdHWJSSUI57mITFS52UzPf8O7Z77JKnBN5v3DKCFLxvrSxBo7AlGJmUoIkQbuOR4mli4g5ow==@vger.kernel.org
X-Gm-Message-State: AFuF++lGqh12Om2sQ8kt5Ldy0zf4StugsS0dVu9YB0FYUaxYjD6nq7UJ
	Bu/Q39lfn/1o1choSBCgF06N0ovW6UDX43mz8ku0VOiB52fDCNJFlNQuYRprESfH3Btg+hi4bqj
	2lLKi/NWnAcb24W1IrbV9iWoSKk14uSf+Aw2mrF5YUFlR6dhTSY8G9+YpToSrZ4DM+zgv5A==
X-Gm-Gg: AYBFou2AgshShBRLzgKwLFXUr+mK3WTk4yFMSjjZexe2wcw9jYJvlSRgSIco67mAJ7A
	1t3B5Ci1uOmbpkZ5KY35dzRjybx7Axu0Iqm+vYXu7bP9dZ0n33CkyOsbK2yISHLxuFPTMtVp1pk
	4YoSoOLG9CzNWCU6r2aahHkqfVAIggCwYdQd2MJYgnSNjCNQWJirV74p0gWuINxUUGIscQN2/vq
	U4Zf6hQmJxf2RHOZb42aaIHWrpiffQG90SO2kNtr3mWa4Hbbwne+SJ9FY8sahimDssQ1GBtrYHT
	BtQFYRa3TXrKyWA2QDdWTR7oC/mwRFW9TR2SqeymhBJov8jmnsvphrZG0X1+1hjUnEAorgsoBTy
	Jy5HwaYt//a5AEYM2Sfvd/Afnt7i4HnphyGUmhGGR0XN3T0Y=
X-Received: by 2002:a17:90a:fc4c:b0:39e:6c6a:4b65 with SMTP id 98e67ed59e1d1-3a073240acbmr919776a91.47.1790074938938;
        Tue, 22 Sep 2026 04:02:18 -0700 (PDT)
X-Received: by 2002:a17:90a:fc4c:b0:39e:6c6a:4b65 with SMTP id 98e67ed59e1d1-3a073240acbmr919631a91.47.1790074936903;
        Tue, 22 Sep 2026 04:02:16 -0700 (PDT)
Received: from [10.152.209.53] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f294d894sm7775851c88.2.2026.09.22.04.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 04:02:15 -0700 (PDT)
Message-ID: <3f31a185-b7ba-4ae4-a3c3-874bac0d66b3@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 16:32:07 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] wifi: ath11k: Connect to the QMI server belonging
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
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE1OSBTYWx0ZWRfXwpk0CqqNVtvG
 CqGOAa2G3lhQ2+L5aBT9K5DMrQ02GX3EgA/8lNC8MuuhuLDKA8pKYVQVkB/OM4iZZZ7VeOrG24E
 Heh/CgxIYj4fII7wCfZKvNyid2VsvJqJa7SgTdfV/hR2kBlI3mTaX+MhgLWyoUq/3r6lyuoNAjZ
 5aH6FbLoh2KkdtfEBL0auVVBEw4AunMO8BZbEyd9oKIG1EsUx73M/XoTHSdaKHehKDSddkyO8KM
 tfYL5shxciCsTc9qfeRvLVE/Byv/ps2V7Q+5l+GGDZfWAghtzV2mpzTfJE/jCRb1E9fKYR7rL3T
 FCW+BiKPsgA8qawROslexdbQ1CHGU97DgVwGszkjn5MheD6v8vQcOuO1VTVCH5bJeX5CdEWIy8L
 9WkAVe0To7X1ImygZL4V6WGnsMWhUwHAZff5zoXNu/Q+sIUgHLUxT3Ij0jSQ7IUNFU+MkQ+1jUL
 K10w3jJ8RAjUhzbObNA==
X-Proofpoint-GUID: T70YY84fjDMvEBn4h3McXgmNwDRrImG7
X-Proofpoint-ORIG-GUID: T70YY84fjDMvEBn4h3McXgmNwDRrImG7
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE1OSBTYWx0ZWRfX/ue3o7oyZ45h
 K9aWx5JbhoezOoXCYMJKDX2TMmchF0FyzJhPyNeBCUoEYPRvJ0sOS6SVPGV3ZpUO7cBSRbqqM1g
 fnrznWejYs//vEejBFzRYJpZZQ1rWgk=
X-Authority-Analysis: v=2.4 cv=XrVvqlF9 c=1 sm=1 tr=0 ts=6ab2603b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=bQg6oyjaoxrshYPP:21 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=uJV0Co7Z9vYWId34oq4A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_07,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220159



On 9/21/2026 4:53 PM, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath11k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, skip any service whose
> node id does not match. A node id of zero disables the check, so transports
> that do not assign one keep their current behavior.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath11k/hif.h |  9 +++++++++
>   drivers/net/wireless/ath/ath11k/pci.c |  9 +++++++++
>   drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++++
>   3 files changed, 28 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/hif.h b/drivers/net/wireless/ath/ath11k/hif.h
> index 017fed1b4bd1..0da9025c7ed8 100644
> --- a/drivers/net/wireless/ath/ath11k/hif.h
> +++ b/drivers/net/wireless/ath/ath11k/hif.h
> @@ -32,6 +32,7 @@ struct ath11k_hif_ops {
>   	void (*ce_irq_disable)(struct ath11k_base *ab);
>   	void (*get_ce_msi_idx)(struct ath11k_base *ab, u32 ce_id, u32 *msi_idx);
>   	void (*coredump_download)(struct ath11k_base *ab);
> +	int (*get_qrtr_node_id)(struct ath11k_base *ab);
>   };
>   
>   static inline void ath11k_hif_ce_irq_enable(struct ath11k_base *ab)
> @@ -159,4 +160,12 @@ static inline void ath11k_hif_coredump_download(struct ath11k_base *ab)
>   		ab->hif.ops->coredump_download(ab);
>   }
>   
> +static inline int ath11k_hif_get_qrtr_node_id(struct ath11k_base *ab)
> +{
> +	if (!ab->hif.ops->get_qrtr_node_id)
> +		return 0;
> +
> +	return ab->hif.ops->get_qrtr_node_id(ab);
> +}
> +
>   #endif /* _HIF_H_ */
> diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
> index a163168f3617..4d327b5cc98a 100644
> --- a/drivers/net/wireless/ath/ath11k/pci.c
> +++ b/drivers/net/wireless/ath/ath11k/pci.c
> @@ -10,6 +10,7 @@
>   #include <linux/of.h>
>   #include <linux/time.h>
>   #include <linux/vmalloc.h>
> +#include <net/qrtr.h>
>   
>   #include "pci.h"
>   #include "core.h"
> @@ -900,6 +901,13 @@ static int ath11k_pci_start(struct ath11k_base *ab)
>   	return 0;
>   }
>   
> +static int ath11k_pci_get_qrtr_node_id(struct ath11k_base *ab)
> +{
> +	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
> +
> +	return qrtr_host_node_id(ab_pci->mhi_ctrl->index);

nit: since qrtr_host_node_id() returns node_id in unsigned int,
may be maintain that in the return type of the callers as well.
Mostly harmless as it is unlikely that node_id is allocated with
an extremely high id. Either way is fine with me. Same applicable
for ath12k patch as well.


Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
