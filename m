Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5254749C0
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 10:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541479; cv=none; b=b55mbz71WjBKonzwOTCUCZVZ3CaxU1Y+Ut8ksKcUTp7MF/BSSwrHW/f59/8mRptFhVvX1mSRkNiM08K71dGVl8W3rR8m5RkyxXyjllldZG0zoHrMJUA9WaKx1/cxaofv/H9kdk07TzeIj+LWdpGd71P9P/jnzIuYXWnZ+GMm40E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541479; c=relaxed/simple;
	bh=kUjPsBx7+oi1WJxbnVJRHO6rJPTj09mOxFmD9paaNwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jlWhOWNW6Z/4gTD9Wj3XumhznA19Xp1iErI2CKUCMe9WPcUYMud2IXewP/Hx5QvDOmc0GZusZ2g/9J9lF6Wtf0WTAaCk+VatzeecPD+oRGXBwr2Ye/1jIWvvacDzJaC4bDDhgdjK4afFfoe59FUBELVDrxTZ04nV5uIvyI3T+LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DMm1ZaUk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iGM/XbEY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DMm1ZaUk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iGM/XbEY"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KY0f3977979
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 10:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vxUptr7baz3x71Er2/PfT6FXq5ZDR3WhgoVZFSGIcC8=; b=DMm1ZaUk9fAc9DpX
	8ctHnGZVfDUJqczwJuY/KfEsV2mwvX0U6VI/4XnUtkd9Dy3OK6HGIRYTEh48c77D
	qrJltn3WmvuWd4728IiH/dCpz2Nvq+jkcy7kAaIngnB8hEMbTCvOf27ttCTS0uz8
	1qlc4St56NQ5CFDFlhzFnDqMQfogvPuPT2GHLfulBKZ1CGNUpWzSnFVUiDXVAaV8
	8B4K0AtBn5bP/2q7ATPVbqrIqPb4U2VXA5JhBzd88YEDiIPyXGuTqEAK1yAYFnQi
	ikKQSA0i2Ac/6TMxj3IQpH0ro8yLZeZhFmmLtw06F3TvjGa8HX2jeQtTz112pPvs
	gaq/iA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6ev5bcf6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 10:24:36 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3a47a81e70bso6370175a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 03:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791541476; x=1792146276; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vxUptr7baz3x71Er2/PfT6FXq5ZDR3WhgoVZFSGIcC8=;
        b=iGM/XbEY4XnN1e3xwPvJNTQ1+SsHUNQOizqPccMTMGEmPUM76fhOKWOnRRoCDwVJlt
         SdPzXbpI96SW6063kKsxd2zPV2G0fTFUA6u81k3PVYT8jTRIwdO0uIlhK22Oa+TeCd/J
         liiPuynrD8CQ1hlyE+lgPgCS/THb3fzS7Ycl1oNAB/hOehH8tmH0Cqnpt3gMLJuy3wIB
         iBQlwA3/rbS+OoW8Qdywo83GnY/KqUmBqIN13r+9/F431vktQWZcFNGp4JfA+j2zduxg
         Om1xGIvNsndGn1IX3gVEUIP1VOqyd6sBVCpUPzHTR/RBAvMM702rdtv7yOxBCkZ2waNa
         F6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791541476; x=1792146276;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vxUptr7baz3x71Er2/PfT6FXq5ZDR3WhgoVZFSGIcC8=;
        b=pfbSIi1lWqUm00p6+M+cNFmp9/BTmDz5qhxOKdA191ZNLJDg06ZtCdfkYkG5JAFLA3
         SUbWAy523sReHi4uo+Q/9DJb3qFd4HHPdavQPYOZFD6w9cnO+Uqzct+wXPEEZ/+zwnWY
         X5fqJyYTqrp6lLFckQjJ+CiGe36/MB0LR98X4w5HUWti3sjuWPF+mH6EH7XLXtMiKG7p
         xkoMr6VGkucyQQrpJWRVzVj+/S11ZnOFEDJ6AOHkvy28BHlmuyBxwhE0YlXnkFvhgzwe
         9dJacDeOrbxrnosMfeZkGlGAeaoe3eO5ITmIZFcsMX3EavxEAAtEtYV2yL1JQQyWGiFq
         TCTg==
X-Forwarded-Encrypted: i=1; AKwUvByHLQRFu7v64qy3RifQ+VaIX1cNi0gJWN9/u2MbP2qno0CRZRlQQvxPwOHmbXCeIBoDu1bd+/8o2ozJO7kWAg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJzf58jYbZtldtB/53GZuc11ajYzMgvBenXNS5VPs9mXY5V37Wt
	LfWpm/S6/yTbVFJRLxGlfvy6Esvm3dBeudZCOnjkelFyES63fAggedz1ix8zzWKVjqDuJ6ArJiA
	qIIVXnryKAv1vZeODDPK92A+1cbuPIaQvL5jeXgOp2amLq1EdT1rwk5hrS7AtwOXZbYpEFg==
X-Gm-Gg: AYBFou0bsG/BwX+SUZj8CI7SQFpHZKqfDJq9H9ZslCpUFGSiYQ6t69VmK7S23P0Bl4e
	Stqr+N8sFG9EfuuQHjZxbiApa6YxG8kvLqIX3Dx7cs2qJWyjurko3c5cgYb/Ni8DzeyfHBh1Sue
	KV5uCymhSB+7tEhUK5vq5fegDORl33QWIJQzdS0KkWNcEL7iUEfLViEjJKxYja+2+bCDYY+Yz3X
	o8LxlBC6Vxc9VOrymo/uhhu0C7Q0ejRapdK7HCLI0qoO0/1xgnWa7OcoRvnCr6mNlvKGVLqGZ/q
	FrKZ9g/kTg7WVeqMBosWK1rM/ATW5JAu9Za7uH1fRbhRv3ItgsV7IMNHHJu2MqKQISwFcdyT8Oi
	4gWnxKcU+zD9VRxO1v7iLwdXDBiJpWkAKAk6DqiSxGDcvsxrVhC8wmxGFaNqq3tNzfnVtIlg=
X-Received: by 2002:a17:90b:52:b0:3a8:1cb6:9824 with SMTP id 98e67ed59e1d1-3ab3a239c24mr1399461a91.6.1791541476211;
        Fri, 09 Oct 2026 03:24:36 -0700 (PDT)
X-Received: by 2002:a17:90b:52:b0:3a8:1cb6:9824 with SMTP id 98e67ed59e1d1-3ab3a239c24mr1399441a91.6.1791541475741;
        Fri, 09 Oct 2026 03:24:35 -0700 (PDT)
Received: from [10.133.33.26] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab39238608sm2957937a91.17.2026.10.09.03.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 03:24:35 -0700 (PDT)
Message-ID: <934b1a06-48ee-47d7-b985-c3e7221d7880@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 18:24:31 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] wifi: ath12k: rely on page_pool APIs for buffer
 allocation
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Ripan Deuri <quic_rdeuri@quicinc.com>,
        P Praneesh
 <quic_ppranees@quicinc.com>, Kalle Valo <kvalo@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261008-ath12k-pp-v1-0-68f888cd7eec@oss.qualcomm.com>
 <20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261008-ath12k-pp-v1-3-68f888cd7eec@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA0MSBTYWx0ZWRfX5+IanoKQrtW0
 3aua4jWIifek/sZejp0tgICN8mV3Z9ZyHKeiYMjlLCMIRU2QQ3qex3pD6l2LpQtEmd4Q4GBJyGE
 /GYcuP094mhch7YzcsEpO2lIUkjqLgM=
X-Authority-Analysis: v=2.4 cv=MMT1C8Zl c=1 sm=1 tr=0 ts=6ac8c0e4 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=K_aUTmfyJhreUiukWNYA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: N7McDOnoA-ieIf0_u4Lh2G76auHD8uDY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA0MSBTYWx0ZWRfX2GilxACGIBM6
 K0vgyuqLuwxn7hDTFIewdBdfp2yEEeA+jhKl78gSgz+jcRAYGiDh2Jig65DsUvX7GlBe7dsjlB3
 PWVIpm9lBYb5wDpcQqB6/44BO+TrVzNd34rzoEv81yP0qoFh7pxj6nvVR9EO3/fV+AEgAybl5pb
 4Zn1ekBN5fhRr+uBFtS3Lu7j+R8ka2FkMTr4Ag+jsIon9RxX5/qK//hTj3lRbIb4sbKBXR6CZYM
 aCjEyBws9f3s6eRqUaIxhWwxneEbCq/1YNLCVEbNrPABPQElYeijBZbVbzb7ExFUGLMRmRdlDWa
 HoKQV2G5luWZvpZbe05KriLz861J9b8iuEtvhzsFXMhlrHEw9VyXHXpsKW7P3za7GCO/g/p+hJh
 RR/CeBuOSxE+ZwJvq3TxzTqZWLZGFQvLO7+jLYx+j4MePjbBp4qpLmHc0k/cfaVM+F9VS1qwIZo
 U42N03VakU3zMR2/Zhg==
X-Proofpoint-ORIG-GUID: N7McDOnoA-ieIf0_u4Lh2G76auHD8uDY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090041



On 10/8/2026 9:16 PM, Lorenzo Bianconi wrote:
> Convert the Rx refill buffers to the page_pool API instead of allocating
> an skb with dev_alloc_skb() and mapping it with dma_map_single(). The pool
> handles the DMA mapping and buffer recycling.
> 
> Add a page_pool to struct dp_rxdma_ring, created in
> ath12k_dp_rxdma_ring_buf_setup() and destroyed in
> ath12k_dp_rxdma_ring_buf_cleanup().
> 
> Update ath12k_dp_unmap_rx_buf() to sync page_pool buffers for the CPU
> instead of unmapping them, and guard the teardown paths
> (ath12k_dp_cc_cleanup(), ath12k_dp_h_msdu_buffer_type()) against
> page_pool buffers. In the re-inject path, sync an already mapped
> page_pool buffer for the device instead of mapping it again, and fill the
> descriptor with the DMA address stored in the rxcb.
> 
> The monitor, CE and TX paths are left unchanged.
> 
> This is just preliminary support: the goal is to use a single page to map
> two separated fragments of 2048B.

why? please always justify your motivation in detail when the change is not trival.

Besides, instead of preliminary patches, why not just send the full support in a single
series?

