Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898785;
	b=sRBA+9x33OLGaPeyVXMsS/KcaaPpE/wBNPqmKK/1Fh5R4bLnyAFuy5FK3YUKSiwZYjLJ
	 3m/G4gJ50iDSC6UclWE7CQ8pWzvJ0gVJPqCsEcneiUPKWQAirG9JmSUZ78hYgNJ8uQlyn
	 Zw6OnF9PK6ZySfze2UZc85Pcq+tfSdGIVu0vga02SxEFJKtUj0kzEs8qjvmF450c3y8FX
	 2PHbngqnZmZmv2kjpmXyVskadWSqgRu9f5GUnAYrXu2h3ANN7ECeb3tnIOQzqpXMQDaYX
	 0/pelZmr0QIFdV4baQORbKd/esZEmnyKzLIRp+yDfVl4MTNN01LaHZ4XROjGKx4/2sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898785;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ehX13o344Xe731l0KfqPE4oN/274+YlSgpyXzq0Egc4=;
	b=4mmRVfCxRFq6FzRGhCOXntOwyLwP0D1ngOultK+yCxQipXktsalLdCHr5o8jFpNpSCSb
	 MfXJqjfBBSW+qheY776EHN2qZazxGBmF6VsvhHId3CnlpVzvRtuB8mgDTFjQS+/WRZK3L
	 xf+FK7nxbN8nLzL7bXs4x6ltfFnh1AeMY/wIaQA1e5UOUGuVsO2yTdA+cQUc3UrSY01o5
	 LN2KdQ41tw8mwUFJTZ3+w6XzUGAV+i9rmqNHI3CYuxtJgLaCe/dI60FGEBT43tzpSqS7T
	 ZgURY7a4VAVR/9StzYQwGsub+h6ZpZUXV1hZoyuh8AHWLE+yAGZnWPplqe5wQUsLLbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fL5Qr21G;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GbyPF8Tr;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0616083610
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D0616083610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fL5Qr21G;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=GbyPF8Tr
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5EQ7HZ1008639
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 17:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ehX13o344Xe731l0KfqPE4oN/274+YlSgpyXzq0Egc4=; b=fL5Qr21G6LvfgZjW
	zB71fq0ilSJSJDDYmahlqNJAn47iJ4Q8KOAoADIZWv8ENVqZ0QHoNeV5gpcotNkK
	BQogGF8D0g5+09WrN4YZQrsq2MkGSvrkCmQ6CWWR0h69y3Wq1qizJWXI5qoXWBTH
	Z/qY1NGBda/BhFm7uREiIhjqOn5LBlgcdgg6BSZKpvl5aHNf1G+qcHkvyRtYEp/z
	IzGN1QiTNkniGgw2Woc2olaLOVXXEK4MJKTQB4wl29N4k0+hpncmdDpOr/PN755q
	l/ya2RNKt/E4gBIAMzwpIN+MbjuuraIyGodoxxEXyFk56/tGv/miyX4jpdPIoNXm
	1mNeFg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrm9v2st3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 17:13:04 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1a71dd190b0so7076875c88.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793898783; x=1794503583; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ehX13o344Xe731l0KfqPE4oN/274+YlSgpyXzq0Egc4=;
        b=GbyPF8TrF1MkxokA8PydVZjgCOzmxIJMDUvnf29RGe9KiLgmfxiSxTQ/mKBr2NR+pl
         kcwFGVEjsB/3FtKZcaQpDys9yBqW6hMleCVx5xQrpBlvdOxinvhrrvKNKz3tU3EW7b6f
         BrYlNQo5TO5mUBs3j5yfxMdR/P8YBNFBI/ga23RZijeF1fZT7e7XhvdxKcY3+FVbiVje
         nz5h+MYpMM6cQU4JoAOshtDlo3pMBQRnMXASM9d1FEFO1Y2eZd/kOpEay7zvhqVFPafb
         aOCgW7gylh5JbM97F1FS9/NCWSRsXdOB5OGn5cYeciz10fxS/vFaPYLb8nbjqTbqeuqT
         hHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793898783; x=1794503583;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ehX13o344Xe731l0KfqPE4oN/274+YlSgpyXzq0Egc4=;
        b=G1wmn9iPD5mRXQZ01ts4pqByMS0UV/30QiAf1jA1OiUSyBLiRld+ZYKdX/NzNLa3jB
         oeYvforwHZnAkIrQKCv65OPW5nLS6CCx0ABm+19CVBbHQVOnoj3kXTJIiLbiQQ1iAED3
         p8xEyioJfkjKtod7SVix8YoyPigI3HE1kDB0I7B0+NavOcbXQEiSTXx2oilmLCBn7yZz
         TA40hfvxZN3EbRwHRzPkLIT0W6SQSFsOA9gwZR6IsVjDW0Ru2tmn56reGSOXJLiPOC6U
         xeUn+Tc5yiX7x2px3WWery+n7FNPxu+aEVwXQ16Avq21DRXqhRN8U/ZaslWFrm3i4eIS
         WtCw==
X-Gm-Message-State: APuU4Z/EzqxSd0bhQThAAUhh6b0KwfuONlLo+JacJRRSJDvSfjMYXsg+
	FFKa36eA+in5ApidXYzevMx5WVrFzdLXNFtOLNasLeRIM72ELH0ZUefKmtLcYgxLub4QHYwo0An
	52Qa2sLLYobOuqKAekpRiw1z9eV+R+Qvu/I5d9/dxMeNERG5uBNr1l4MS7QaPdhOPdlLqWg==
X-Gm-Gg: AYBFou1GjqypmtgjWhAC50G+coxoAtqD785qror5vndZTteFYKit2ehq14W5j/yunei
	Ql/9xw2f1Twi5uQN2hsd8kc6WJ+XMY2UhbbaUUN6+Slmz2hCReqiLANIbRFm0wux8J6lIHZrdF1
	dKPoWDK6+3KNAV/pt4Cm9J7BeCIp/QcGqlJEFcPSxYYLjnsOGv622q1anayqGaNNy7QxYn1EgWz
	F/g7fqBswPqA3Lv4+Z0vT36SyGDu8yvKzKKpC8OEhDRwtUy0YmrMaxcSm6V59qLtejxumpy5o3P
	exMxnc4/Td4/k0VrlGZbM6mwPTK97+G4Max9kpbIwcnIA7XnkEetiVa/8e5zZaFgCKJMnYuOy5X
	1zlW/cr9pb0dYjtVh3xev5yBWGj2Mb2bWUDX806pY+5wJG5YXthQQJljL4G+x/Iuj34LLV2G9ba
	n0iwaef0xAbLcZS5A=
X-Received: by 2002:a05:7022:ea51:b0:144:c112:5f24 with SMTP id a92af1059eb24-1ac5b028d82mr27782437c88.25.1793898783348;
        Thu, 05 Nov 2026 09:13:03 -0800 (PST)
X-Received: by 2002:a05:7022:ea51:b0:144:c112:5f24 with SMTP id a92af1059eb24-1ac5b028d82mr27782388c88.25.1793898782603;
        Thu, 05 Nov 2026 09:13:02 -0800 (PST)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25100667esm9541181c88.19.2026.11.05.09.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 09:13:01 -0800 (PST)
Message-ID: <d9da4f14-4f13-4cec-b519-2c848894c35c@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 22:42:54 +0530
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
Subject: Re: [PATCH ath-next 0/2] wifi: ath11k/ath12k: don't bit-reverse the
 firmware's PPE thresholds
To: christophergriffin05@gmail.com, Jeff Johnson <jjohnson@kernel.org>,
        John Crispin <john@phrozen.org>, Kalle Valo <kvalo@kernel.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        P Praneesh <quic_ppranees@quicinc.com>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Baochen Qiang
 <baochen.qiang@oss.qualcomm.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        ath12k@lists.infradead.org
References: <20261104-ath-ppe-thresholds-bit-order-v1-0-0f569106cbc4@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-ath-ppe-thresholds-bit-order-v1-0-0f569106cbc4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA2OCBTYWx0ZWRfX3oxR+zH70yMO
 NP3hIgge6zaVxtSfkKlZjSjHXEG5pe6Ln3XgKCAnwe5jmd3ECbkCS+2TEujuFRmVxjHe79noVGX
 zDSxw5UIpu8qGhXUirqyqqV3muM+lVQ=
X-Authority-Analysis: v=2.4 cv=KrHYSmWN c=1 sm=1 tr=0 ts=6aecb920 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=WwoKhXFDXbz0SCtfdboA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA2OCBTYWx0ZWRfX5LlICZAuBYvL
 QBQaFjEQe9gUL3H9pIPe8Ki4Jw9SqMneVCTkqhtww7n74CtymKc69pVxuFiS+mFyb8mGg1iCnIQ
 7nM5cztivJ3l3jOFA+uTTvW8oK+5LAbzweg6KnKghQ8kIyqUqPrNxzcTtk3fijTOY+5sbm7EAlB
 X7fqzNlCGorImKgg8zzQtkaKvpMpZdFdU2U7sFuE+PvphewXAO/UFTQS1YDZZo2n/9EdjRbEEsi
 yhZb1eGjodKYq0u/kArXxGAOexvniE3F18uUS8AUWu3ppbBr/NvyJBpe4X+YCfvillLKmSCqx4d
 g/fBTFr4JSsQQUFkL9wiXEO382Umwbw34too+Q3tTUJ+5CPRC8o4Lec7i1Z7RR9tHwbzDHrB5wU
 KciBJuLZzkTecnKw7GP81NWE4GGO9aKiTWZavQ0vURi57rko2e9qOnGDq7DZWhisOppf8WC++Jr
 c0e4S+fCdMSr7e5tOxQ==
X-Proofpoint-GUID: SffTivnJogykw3TnZQ2p47kbA3SGGBOR
X-Proofpoint-ORIG-GUID: SffTivnJogykw3TnZQ2p47kbA3SGGBOR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_04,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050068

On 11/5/2026 10:47 AM, Christopher Griffin via B4 Relay wrote:
> ath11k and ath12k build the PPE Thresholds field of their HE
> capabilities from the firmware's WMI layout with each 3-bit threshold
> bit-reversed (QPSK and 256-QAM swap places, 64-QAM becomes reserved),
> while a peer's thresholds are converted the right way. Firmware that
> reports 0 and 7 only, as IPQ8074 and QCN9074 do, hides it. One patch
> per driver.
> 
> ---
> Christopher Griffin (2):
>        wifi: ath11k: don't bit-reverse the firmware's PPE thresholds
>        wifi: ath12k: don't bit-reverse the firmware's PPE thresholds
> 
>   drivers/net/wireless/ath/ath11k/mac.c | 3 +--
>   drivers/net/wireless/ath/ath12k/mac.c | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> ---
> base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
> change-id: 20261104-ath-ppe-thresholds-bit-order-436ac99c5745
Apart from Assisted-by Tag nits,

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>


