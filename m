Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792982926;
	b=V0t+7W5bF73ZgJG2P5VbM0l5fhgVZaiGbhHkldtxhsi29BYWODIMvqdYII9gMGgXNgo7
	 FEkJ6KuHlXUcFRanowXlFfwT12xewgn+dcF8OkbeQCBQpfEp53gqUNYFkM8kNN1yhxpEA
	 1HJARqeSUEWoyCXfutvb4FmKe7mZQiGzQs3CTrVCBuwuwpfS1aIpeeGAsyZxMB/8fFhHS
	 GP1lSAyL4K3cV00PDxSzCXyQ0/7rmd0XfNbwurIAQYRDkd6CP2uPDnCNj3I52eDK7bHxj
	 6Vc9mquIkwQ94SnrJ6PjlzecZv4j46TOmLUpC2CynTYT2hZA4aDM8obpfnOpI7g8U9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792982926;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SZAyvfk7E0t0sVIdE9M1d2Ep4UXPxvDDvaeVcSnvHyc=;
	b=QOOhgtenWHK2zCv0A8J09oxGQf/uY82cvK1yw+iumNrHWirGaOaBLpOpWWzKbLJ7k6Tr
	 JRPgUUev7K+REiBsCZa+pYEWTjO+7eCqC4HSSosO4uKjUfXQfoVVCclFJD2+wHwMP6sya
	 7dPcgH+EgsOcV7tZgvhnAHu36Xn1GM7PPlcyMsb1SsXF4A95toun9htcVj7VtGAmOmLwH
	 rBKn7zAjX5zTY1ckNlsIW6frnTlR1LSLKVh6gcDqP5lxwyfJlr6Y33/pMVLw+ESzZl0Gr
	 lwc+4TXnA9herKcuhRsw12qQe+Ey85WxTV/NqI9b4/j3Ei0D2dHKBBseZoJT81qwlsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HLRZDSJP;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YsUJIQhs;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE588606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 02:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE588606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HLRZDSJP;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YsUJIQhs
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q2Kfkk2520171
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 02:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SZAyvfk7E0t0sVIdE9M1d2Ep4UXPxvDDvaeVcSnvHyc=; b=HLRZDSJPIy2LtPVQ
	EE4W9SLDrqNMi9EC6VvlrZMlaTpDA6UUh2HunGtO8NyXa5EkndAEwrgO8sWw7/Ql
	hultZPO/5f910B6PLToIE9iVnDNOPeBw6DpWZmPNkWa0Q69eBsst88vO0Mt1nZZu
	c+bsji0b4wcgo+mwI08rF836ZzX8tuFYJusVaHRgf0mKeueVQjkcweoScbJ1X9Ju
	VCN+BO7vymLTew54lPX+uvdwjGBofpxKhUGzR9AB1zOlBE33kruPZ6f8Vh3bKf1n
	zi1Q1nyqE7t9A9j1Zzqvdk0NOXXo19htzzu0Y9X2tv6VAYm/M8tpCEfNkiaDkqvL
	w9ckng==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgm8xmjrb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 02:48:44 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso2340404a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 19:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792982923; x=1793587723; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SZAyvfk7E0t0sVIdE9M1d2Ep4UXPxvDDvaeVcSnvHyc=;
        b=YsUJIQhsDPVZynJKrEsTr8k4FOBafpPpbBRRllVEadaSTssDFQ5/6zjqF52fS0/7ey
         lS7cgzccq0x0F2ajAwqtaD2dIDC3cwcuJmJEleArgZu8KIlZ77zc0dr3dponjqJ8zgdO
         F3ZDUOkrscS91DMEbnvyLODUyuQ+XI8mL6MJwtI0eXBlCT2i5jSKyboT7Mf2VjuF7XTB
         8HvfX1UjSS5JjRHxBoc4iU0uzSnvSPqhm3a/XlESFjneG34dupYfTJ3xx5LuHLnyeP+v
         GSDdAM0PnW3KQVk2rueyvOuQBedVa4R3VUXHkD7EcAMc4Hq/Ki3I2dDq49Vo03z1l73S
         sJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792982923; x=1793587723;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SZAyvfk7E0t0sVIdE9M1d2Ep4UXPxvDDvaeVcSnvHyc=;
        b=kjrOUNIXty988gKARm51CGpWa8QAi13vXZp6SMSOwil9Bu+67NOsMs8kF1sbeebg21
         comKqv3oG1qqf0hRddB8rM/s/JPAxZE3oVDsGCwmI34DuENUc5hbqdiWyg2hJCP7UdZ6
         2Crna4yEWsvgrcn9oPYB1LGTFuStliscq48edcLkw0QJ2ubs9e2ivCfR8v/mx6o7Rawz
         vKr8G93S7KKGEWPQn72eOKaSBDHxvm7KXdQcvnNJEBDFQ9nm4AO7YtvDFXNwesVzjsJb
         V+vIsTOvPt4BsSCPQ3i3M5IqDmNyL65bW5aHzWkn1a8qN8ZoiBkhnHDP/wFrb3abZhV6
         cCmQ==
X-Forwarded-Encrypted: i=1; AKwUvBww+C/qFJxlVLZuMkegowi7+XzXgYtaYgM52Kc6bnxdrJNWsFgjYIwWtW0Cwh/XHuK/oNLjJXYnbVx7WQGt8A==@vger.kernel.org
X-Gm-Message-State: AFq9FYJsF12J+Khr3o0mocQMsWthZ6BGahnZcwneoht84RqeBLqffrFr
	t5UwUx3gh2uwT8ovZpqLAaXMMpuy4pYFlSFIJQychPwMXMDSlbSOUQ6DPE4jAmWqZib3OUSiGgV
	csEID22JGNKM7WIQsDYzbLaa3cy5DzoVo5YYeEfkgIAZXof/mD3EDElmC6ITnmNXtYTvLqA==
X-Gm-Gg: AYBFou2+yn3xoMaEjPVtmWT8Zh1w/z7ykv+66xsO1w7hsxpqK/vuZto45n2bjszcBBy
	Y+KyAhwUH2RrsE34OonoAjqmwWLBNmMqCNxSG+7BaD3k01KD2iKZmqXOvX8iy/vt4falJReN/Gk
	f4axJHwrI7UpGjr05u49cCWVp7CmbTuv6cm5bL8vESTnfm6fk+Dj4h4odRQCvFbLwnn5HB5oqkD
	GFlqX2Cr0T+60vYiKOQlHEQ4d6K7alTCDksbZPpAbyXxjnagVpNM4UpSTtMZbTdRqqB69Ycn+xP
	vpTwnkyWoUJZ5xk8zPmLFD9uFcA8rSgeWH/hhVzlMptvNuvT5nYtOTgOMEjYy7GvHGwJuRatyoU
	1aWjkyBBeTToboY+98ZolubjXn1wwkiZUfFH3FV+M1wAbv0Fvs91GoSz3b/mbyUj3opp8Tr/EzQ
	==
X-Received: by 2002:a17:90b:5286:b0:3a7:a463:54c2 with SMTP id 98e67ed59e1d1-3adeae763d7mr4770872a91.35.1792982923352;
        Sun, 25 Oct 2026 19:48:43 -0700 (PDT)
X-Received: by 2002:a17:90b:5286:b0:3a7:a463:54c2 with SMTP id 98e67ed59e1d1-3adeae763d7mr4770855a91.35.1792982922807;
        Sun, 25 Oct 2026 19:48:42 -0700 (PDT)
Received: from [10.133.33.143] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebfa4102sm6430090a91.12.2026.10.25.19.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 19:48:42 -0700 (PDT)
Message-ID: <99323a63-01a1-4c7c-be68-516b3c1ca65d@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 10:48:39 +0800
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
Subject: Re: [PATCH ath-current v3] wifi: ath12k: fix DMA direction for
 re-injected Rx buffers
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Baochen Qiang <quic_bqiang@quicinc.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v3-1-443f9e13bbc9@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261023-ath12k-fix-dma-mapping-for-reinject-packets-v3-1-443f9e13bbc9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: EVFFypZ_USO5ZuNoPDO-7Htu38ZAIezj
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6adebf8c cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=gzkGQ6Wf24K-XPQJ27AA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAxMCBTYWx0ZWRfX4mYBqWzzcD/2
 QzD91DIqarWRyGpV7sG2wYSh7Rrxwip6+Axamq4by46YlaZDMM72yZjB2N/4VN2y25zfklRCEqr
 oc5pOwPufzneA1HFLJfY7VRdMY2K9is=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAxMCBTYWx0ZWRfX0bf1rVpVV+r9
 qp1nNLYJI27vRkf4oRy6BXJdLoRD72prxtc9H7oisdSpHPuJJC9DE09r0E/iv6xGyD8uSu3MOLS
 78oJ05JsOg6wK+XOD+Pi+t30wxD8iCAgDi0BzhJ1tcytaa1MGn1JPbK1hfFAtv4WwDVNpUWT73n
 NQ+ZQ8zmXa2peX26cbGRgUPpC4mdzTGS9IIhPUim+uaXj2FO+QkmzLeyC8nH/kH/tIrLT2pW1XE
 AhYEwVIV4lxG7/ojeYWOn2I2NeVJdNkHwr0+1VCPmVeWSS7Jier71H8D90MVF/gT2EjdhJLFwmM
 xPv+NWsxnYqyq94WXO4rwY8B/eHL0lZ150uvABu63se05Q4x5qlV+vYUm9J8sF7ISzQ9G1sEjKv
 6EpiEwEHy0qDIwsBdyXQTwBrfH/euqGaBk72s/gyF1ovymlyg+DZvS2GTpQVPB8mErUfIFGsIrL
 Pt7lUz9PFdvQ0k3QJbg==
X-Proofpoint-ORIG-GUID: EVFFypZ_USO5ZuNoPDO-7Htu38ZAIezj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260010



On 10/24/2026 12:49 AM, Lorenzo Bianconi wrote:
> Defragmented MPDUs that are re-injected into the REO are mapped with
> DMA_TO_DEVICE, but all the Rx reap and teardown paths unmap them with
> DMA_FROM_DEVICE. The DMA API requires the unmap direction to match the
> map direction, so this violates the contract.
> 
> The mapping actually spans both directions, since the host has written
> the buffer before the REO reads it and the buffer is read back by the
> host afterwards, so DMA_BIDIRECTIONAL is the correct choice.
> 
> Add a common ath12k_dp_unmap_rx_buf() helper that selects
> DMA_BIDIRECTIONAL for re-injected buffers, identified by the existing
> ath12k_skb_rxcb::is_frag flag, and DMA_FROM_DEVICE otherwise, then use it
> in all the Rx reap and cleanup paths. Map and unmap the re-injected buffer
> with DMA_BIDIRECTIONAL consistently.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 33322e3ef074 ("wifi: ath12k: change DMA direction while mapping reinjected packets")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Back in the ath11k days I tested the DMA_TO_DEVICE change (86a03dad0f5a) and
did not see any DMA API warning about the direction mismatch on unmap, but
most likely CONFIG_DMA_API_DEBUG was simply not enabled in my build.

Functionally, re-injection on ath11k has been working fine with
DMA_TO_DEVICE, so my guess is that hardware/firmware does not touch the frame
payload after the re-injection, which is why DMA_TO_DEVICE happens to work.

Still, the buffer is written by the host before the REO reads it and read
back by the host afterwards, and map/unmap must use the same direction, so
DMA_BIDIRECTIONAL is the right fix here.

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

