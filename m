Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793757814;
	b=Z+fgYecZJHFleJrV6vTWrl/F3PDlYJVO/+ebPCjDbtSMLXevEosAsFh3KoqIjkMkVSHX
	 8df2YYA9KNqrpHTdBrQ0PN4S7IgOv5r7GmDDqVicaAlnZ3EdOmIhA+GQ6LwGVaqLFT3ec
	 5mS3Av3k2GMZ0Hi1L8B+ob5vG8guY+y94Nj2EoGsIJmmeth22QdR5B5ANB3JP5ZwEPqUX
	 XKTRR4qh4n2yx2EShfP8Uw2QvRBRxjYwIe/eGT20Lbon8CuDuyLg9JA74ovaTxHmY0Ys0
	 6RQ4eShqy9Lp4dykEBbBzb6vt++fptskv19qDMqzaqI2Da2btM8OtKuPwQ7uAIhR+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793757814;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=hwhJsiEzIXGjwpPakaRIHnm9ygQpg1JZVtIO5uyoL+Q=;
	b=LdSLXbArz6uGOQrULaoCD8gxRNflPW1a5A8VDNJ8Tsw9IaJkwzDTt8PgojJvWPeI3OWe
	 D6aLPa4tDCgQiZtQrq5+PYzcrQsuucFFBBRnyK7q1wzppJApvk0u5Plyge3tcAakbtUCA
	 YgErtOSgFbIJWdjf0kdPJl9VnIPY9C/6dGcxEQdPdFw7mf+xY6RmRJfaxR7DdY4R2lTw7
	 r/J+qgBGw2hTavY5mGOs8I23Ksg/gc60o70XU14cES0059qM3TNZ3ws2lDtE8HvM6Vc/+
	 gyIhkX7KZoueAGRDVkQE/pMwR810t6QUToh69PqqB09h/5WZD6qG77fh6kmoWyxhp/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DR2Zp73I;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Z+7wXJVX;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03628606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 02:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03628606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DR2Zp73I;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Z+7wXJVX
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RC4O2786045
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 02:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hwhJsiEzIXGjwpPakaRIHnm9ygQpg1JZVtIO5uyoL+Q=; b=DR2Zp73IPUDPFhle
	R/u908IaGmSHqIcsvhe9LP7WfmfVY/6wruAH8KtbYjByIiAHXp4lrBpd5AVsXjXd
	zJohM6E9JwUTjHjU0a9lqo/gSHzrFgVhVQKVUhsnV4r+pIZcq7lE3oYbC/k1vVBL
	RzA7vWRCutLUkK4HxN0M8fDFcB3wRaCW1ZZakQZTUgeoxtDjFW97yQk8LCxRio7Z
	dfD49Q4WrOao/pvF+G9ef4YWBh3Z/JnOjYYkH9qPQkqYlP4mPfydnVStln52f4lO
	Qx3axDFfdp6+I0McXTVGxQx+0V/1UqOdrQfZvrrRoLWXDPAoRToZFz+wvcB1hAYc
	E3qTDg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqhyd2dqg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 02:03:33 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso362588a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 18:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793757812; x=1794362612; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hwhJsiEzIXGjwpPakaRIHnm9ygQpg1JZVtIO5uyoL+Q=;
        b=Z+7wXJVXt2nwrK4slAbpc6Nl5ChKi/7qVZiL4bOiizYB9UQ8Nqxe+erWzPnyvEe6AJ
         rI6dO2RN0NcOPrQeAcQE1vRJf1OTf0OmTc+2HCOuCKZS5j5CNJmHDMmfpONf6cu57lqi
         d+y2XkKzPBwuWFqa0D7Rq14PIlXEcfgx1F0lsBb7cqFcO1luyrmhWOQTIsc8ozQyAzg3
         hefUuShYLKabVshHvb1UlgXMPGKv/veMpb6QpKU0hIbitVcwsXDP2c59FuRjO93ZuYUb
         ZnQzdDF9s5W58P8JQPVn2InrYXvDvSYwX9n56iGkbL8csbRvP0zj12hZHLHZUuFcgTvZ
         oEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793757812; x=1794362612;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwhJsiEzIXGjwpPakaRIHnm9ygQpg1JZVtIO5uyoL+Q=;
        b=hCqZ8XXcPFyIEenDhFOd4DmE0/Oxb9we8z1j2iH6jf+k9nM3UmNCimMo/2wNQ+liu2
         9AR3oVBtLh+l+pVm11mYGw2DTqg1IF9NZr9b+Yx1LFGeQQBqi1dn03Eb7xArBxWBlkq+
         1EBFcM7Wn63q04KHWGKxJZpsm+QuJJZiCrkiEHEXX12EUWnwnkPApwWAYZO0voDOgxbU
         v8k87FY+vfh3dmU8EJXalMP1jkCkJQBz8Wnh5r5p3LL9Jy+nzdh1SctQqYdfyu4RyJeR
         yPKFAPwo7xsKMCF7UgzogBvc4U0KAz9RutWW4KmS+m6uQZWlEC5keBrnwLvi+VPCX403
         YZ2w==
X-Gm-Message-State: APuU4Z8p1pXU1juInTkxC+ri6ui7LYO2AwnnBmru9Gt4nOqnYBm+qqOB
	2RgukDF2CBBR2IGveEocoedH0pTSMgsEc3XRk2BtH1Qp1bTY+R677r5h3K4Lvn8DBj5XfauU9OH
	x9YKb50rEnTBZTlXcSegHeAm9D9zAy70v1x6LkDyyR9Z7p35N1JHPn+gBS06NbxHHINOo5g==
X-Gm-Gg: AYBFou3XjJla9tI04jtcux5LKgW5GhPn8E0KIThNcqraVj1NGsDQT/bXFjs3ucsXtC1
	0d/TWWmB1kQcUJyRAC8YYbE963dOhGXv+tv1f2+ux56dor+XLsroznsjCo7JV32FWQ1CeKs16dA
	EbX3bOinoZd5N+kqShhVQvAFWaeQWefUb09QcMsXNc4+fk6Kdb/Yr3pDAaZcNRG0V6euXEmsePr
	usSOtzLpDW+3FmRGl817p/2oCFHaXs8N8RIGg2L4iTUvBTVGJvKrGBVfST4E4/dOBoq6WXDCFNx
	ULpjURuhtYzVU7Dk77ttuazB0CDxb1DZi0MLtw1ErsCR5oyxA9hwu/G8xdc6YqL7MH6xrbD5Df4
	V7yj07h5NzGhjtjqoLxD5dkd47l7LvjZU/ttsu4YzYySIUSbgrWTmSGOcziaZBzsBhoqBGrRh03
	gpKkocnRGFChu+O2I2cG8TIz7cNNUsfvOcfG7BYMqTtF8=
X-Received: by 2002:a17:90b:534d:b0:3ac:ffb8:183b with SMTP id 98e67ed59e1d1-3ae898392e6mr12644638a91.51.1793757812410;
        Tue, 03 Nov 2026 18:03:32 -0800 (PST)
X-Received: by 2002:a17:90b:534d:b0:3ac:ffb8:183b with SMTP id 98e67ed59e1d1-3ae898392e6mr12644616a91.51.1793757811938;
        Tue, 03 Nov 2026 18:03:31 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c7e087csm6716710a91.4.2026.11.03.18.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 18:03:31 -0800 (PST)
Message-ID: <df59854a-b10f-4997-86d8-134f62b73799@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 10:03:28 +0800
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
Subject: Re: [PATCH ath-next 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261103-m3_and_aux_ucode-v1-0-e14f13fdfa41@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=bp/Zl0ai c=1 sm=1 tr=0 ts=6aea9275 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=WH3b8gmyxz3kVt_5t98A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 50CnkHTL_rkI1-dUR7J80UpxRvu7oTTZ
X-Proofpoint-ORIG-GUID: 50CnkHTL_rkI1-dUR7J80UpxRvu7oTTZ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNyBTYWx0ZWRfX+P6TtGB4hXOW
 OcPRUNrQcSvATmB1Ht6vihrLAV1TWK4OrWHpW/4g2QRWHoWy+6aY2IAr/yf7XWz0WSP80yaE4Qt
 OoJnqXbaIx0RKW7P3IqJKvdpyiLY2Fw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNyBTYWx0ZWRfX1CDim419KFYT
 XEXK6R09UgOwZboX8tTGN3r3oFniqRZ0Bn33RMrd2CbCk6S0xFSjbJ691XOMNAriXfwdHOtv+tx
 XQ/KKGP6zVB1AKCQHgRR7TDuoBGCUYEdKh73G/hXQPOKSBM1XzlqCLUrzJKE/eJ2aRNm65Ltu1Q
 ItQLC2a8BB5IYNOFR7R1jyCpSxtiwkkYRSeOSj5rUrkcdnuIwDvrY+eQmg3xaZpjoqqoDhgcKIb
 lf4HliFR6fu/s6aDwkT/R/5KKpmBDE7Aa3z9KqllIsyE7lDW0GsGqfAFo27fpIoYQsrq4tISxme
 O0hVgfGk9xIcuG1nYyBENtOeib9MqLEzK+wJTXrHX7dlJuOhvTAVQbE5sHc+dOGlbSMFqPQTAys
 /lMBRmRINFqrcf5wVyyHvFAFbR3AMDvIoGl4pKCmkwM7KkI4Hq1RHVDjnmPzXG9CNuB/VJWiwzZ
 D9nhoJP80mbXZhWECVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040007



On 11/4/2026 1:25 AM, Madhavan Ganesan wrote:
> ath12k_qmi_m3_free()/ath12k_qmi_m3_load() and
> ath12k_qmi_aux_uc_free()/ath12k_qmi_aux_uc_load() carry near-identical
> logic for freeing a DMA-coherent firmware memory region and loading
> firmware into it. Factor the shared logic into common helpers.
> 
> Patch 1 is a preparatory, no-functional-change rename of
> struct m3_mem_region to struct ath12k_fw_mem_region, since the type
> is also used for the aux_uc region and the old name no longer
> reflects its purpose.
> 
> Patch 2 refactors the shared free/load logic into
> ath12k_qmi_free_mem_region() and ath12k_qmi_fw_mem_load(), and
> rewires the m3 and aux_uc wrappers to use them.
> 
> ---
> Madhavan Ganesan (2):
>       wifi: ath12k: rename m3_mem_region to ath12k_fw_mem_region
>       wifi: ath12k: refactor m3 and aux_uc firmware memory handling
>  
>  drivers/net/wireless/ath/ath12k/qmi.c | 163 +++++++++++-----------------------
>  drivers/net/wireless/ath/ath12k/qmi.h |   6 +-
>  2 files changed, 57 insertions(+), 112 deletions(-)
> ---
> base-commit: a2da7677eb9a12e7860814b70a1f6f5b0e347d7d
> change-id: 20261103-m3_and_aux_ucode-8337b881155c
> 
> 

with commit message nit in patch 2/2 fixed:

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>



