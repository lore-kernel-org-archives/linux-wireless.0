Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792559254;
	b=mHJwInyusQyrxbCWz2RGm5QWTzy0szgs320DzhduzlUVLM56gYDXjF6IMdUVUOLuN0zs
	 y4elfNGozELeobLFzAJgXg/5KBK5WdHF3IOZsIMxIkDeSL2mAje0ZdfXE0enZEbDbkxGi
	 VMMNYdVtaICejCZXBkFPZ3i54CEzQfOdEudOfNt78XzstpxPWahWGqoIBdKmlx1Vau7uI
	 CviiU0zUfCDGF7i7VgdkMxWz0FgAred30y5iHgbbGnqJsS7CPgS/6OXc1+ltAiNqMRSRi
	 VTwvkgEg8SZpNlJOTwQlDr2fMAhqaZA3xHSEUfWaNaf3vN9fvseMIrZpcddUGesF6QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792559254;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Cc:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=RR7noHyIfo5/8QXZlZ8gXcIfZnuMYnQ6Hpfmoc848ck=;
	b=ORt7SWoJ0QYhDhWyrcp21iweq3zl/1pjRC08iGTaDBiPEP+Wb2VDs2nkwc1OMEuNOo88
	 K73oemSaUcRxD9WKdoQOu6oaeV6Axn/TaSNcesR/yatvC3G+xgxVkUW/MYJ4D9QEB3i73
	 uxnnohpo8W1anpNJMXZuuRnZlKQAEOxUd248qNLG++Fy1vbMhin0mQsQiTHzJSws+MzHl
	 HeRyZDMIU90W+U9ObW6m1NMYwq4edUgSSKlurvKdOS9s0auJ7Vb5cTTJYmMFbI0D8J+ZS
	 fSD1sQwnJC+frE/5SWaGwrtiHiIfJ+z/YBPRiLqHSRLGFVGYjXsPffU5Rdj9+P0ar4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C8mqyP3a;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=axOPoEsL;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7BB606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:07:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD7BB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C8mqyP3a;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=axOPoEsL
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L2EsuD299864
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:07:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RR7noHyIfo5/8QXZlZ8gXcIfZnuMYnQ6Hpfmoc848ck=; b=C8mqyP3aFOlSYaRw
	N4yN1D/ZXROODgGUWfRkLKq0KJKTmTdsq1d5LFyN1lW0dBUnhUm7b9iVApgkK1Nu
	NkC3qN21betDJ2Rrm8/0IFVdCTD2Smdv+VA3J7w/j6YiEY0FmB+QThzI05viiWvI
	51r8V4Gsi4tdq1M2pVHkg57ww25zyPLI8n6NtORNWJamZsBBuEeCTuu9s4+3zlUS
	yKrQwYu5YIyj5v+NhpiyH6cdNzDpTuk2hNP1v8nxIgZNicRXhweoZj7n9gc2yzxR
	KoksNPr4audnfogWcqNrsBXRDA+9X2Fk4qcgXlaq7sJ1RYjQRylelUFxV6fSHWoC
	ZcG35A==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heda4t1hc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:07:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36637676140so579710eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 22:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792559252; x=1793164052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RR7noHyIfo5/8QXZlZ8gXcIfZnuMYnQ6Hpfmoc848ck=;
        b=axOPoEsLzD9ptQj8aMp5AW881hoLrcHVehDzBY0+R5rltCRJNCjRrRGTgte9EVDzlj
         BLQx35runVBOCfdk+IWMFE9qTooCK/CwnOoZqcB23yc67FqP9e4gsFWAyb2tcSqFiNpU
         YXjPLVAPLovjcgjYZ0diBWo6UlvJij2heuNKJhHypg2HmRAgCNI2fXkoOSXqQbTzFaJg
         nS1WZp5JnMC4PfA0I0mQ0ng8cMFMxUn4BTyqAuni5JGG0iDa/MSNDAxdW8xjEXoubh4k
         w855Z4N3Qr7uFYKT90i1NZBe7Q1jOtXZtFshJsp6apyWeOvczDBnmxi01Z//xChG5RgT
         +aHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792559252; x=1793164052;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:cc:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RR7noHyIfo5/8QXZlZ8gXcIfZnuMYnQ6Hpfmoc848ck=;
        b=TsQCjGw/MgNMpec+LmtUyvCHETSu988cldU2Ca8aCanxK4zwqTw8Qeo9SdD03diWa2
         YEr8JiEN2r100QVHZ5Wm1jkg2kiB5Qntnhkn7xE4mT1UHwW8cGtpOeyGfWlPR9JBJEjF
         A2hStEFoqLjR88ia/4ocXWFKyQthtWsLohZErnB5NuR7Vk/okTLFIztH4+g1EA0qb+/2
         9vYNky4U3twEqKqxq6N6oQ6ScFzIzMPPqBzvvDre+Bg5lbp/5lZy+aDFIKguvsqRo/9q
         CVlsXTqM00hOlD31RaoRpj1aHHe1Jw+E27Wp+VM6F6oaHMm3w1Y5FJEhiG+b112MTSe0
         uwjg==
X-Forwarded-Encrypted: i=1; AKwUvByWZjfgiqv0jnf8lUda21O7Dq0Fjbz5acgoIEmGM5+LFiXX+92xp9cwpqOGJ+zP5s7YalcjJImOVSbvotkARw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK/2HPYapgFqbpaXAeLWNOlbtrOBbJ/fxApM4l0z/DqG+5qqB2s
	Dr0rbzXvQBwH1d6KSAPcYGS/xJv17DmM4W11ZvUebs75bPWZkjEpD13Nj9c2kwKjYYWJmSV3pph
	ew1BAM2ko3pIqHSgoU+hbJAhvlwJ6m2dUIdS/rTX0ge4g13bsnneXgu0ci2v+2LrQL8e+rA==
X-Gm-Gg: AYBFou1W98A/9mWmINLgpA8R2X9lSP/d7jAmBB+xMFncE8YseZGYl1gnE7gcRAVff3s
	CqO4YhySyrepq+TtFglBntqeJWQfVyMuz7un6twie0VXb8MZkng0sivdWykt75TFUzkynBKqsHw
	fVt8gXg0sjWKuEbm/KkZsikJ16RyTslSTyG9ZmlGfhRy4WByeqaNisQ3FTtwE1sHJf0yT3EkNdl
	E97TY172KrLF177JrnboxRhbrseMINJcJfUp5fAYtAz5KyV5hLFUOOjOLgOL22B0U86RTYsm8hA
	tWCYX4qEes+92qtSIL+xpGumodcaTTv1sVeI2ErF9h/YLEKoQQpt9ezkD0axhP8oGLxVdINgPCY
	lHzwSpb4v3TLY6kZQWTBR1HBtx61HfpH94IU/ZjlTydiv
X-Received: by 2002:a05:693c:8105:b0:35e:f4ac:5f8e with SMTP id 5a478bee46e88-3674866f3bemr1899130eec.0.1792559251680;
        Tue, 20 Oct 2026 22:07:31 -0700 (PDT)
X-Received: by 2002:a05:693c:8105:b0:35e:f4ac:5f8e with SMTP id 5a478bee46e88-3674866f3bemr1899088eec.0.1792559250808;
        Tue, 20 Oct 2026 22:07:30 -0700 (PDT)
Received: from [10.152.204.133] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36741e71eaesm6905961eec.26.2026.10.20.22.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 22:07:30 -0700 (PDT)
Message-ID: <5e64ab52-c8b3-4b42-81b1-dea844bea6d9@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 10:37:26 +0530
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
Cc: karthikeyan.periyasamy@oss.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH ath-next] wifi: ath12k: fix IRQ disable imbalance in AHB
 ext interrupt handler
To: P Praneesh <praneesh.p@oss.qualcomm.com>, ath12k@lists.infradead.org
References: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
Content-Language: en-US
From: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>
In-Reply-To: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nA3A3arXOWIkCx9sHj2g-GeRfa1NGd7T
X-Proofpoint-GUID: nA3A3arXOWIkCx9sHj2g-GeRfa1NGd7T
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAyMCBTYWx0ZWRfX12SfA9G7yxpD
 v3ECMHcrdP4dQ3BHSZAkYExoaxpSgvjmUm7sOv6thVMVL+XEWGo4fDKTaLOfrpr0zMBvOZLDMlt
 W9z0xx2YFb0PYCu3YL3/nFRxSYrguSI=
X-Authority-Analysis: v=2.4 cv=R7aWitRX c=1 sm=1 tr=0 ts=6ad84894 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=zjobiHJbO40lojGx9g4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAyMCBTYWx0ZWRfX3sW+iXka5fVK
 u+gLalzeUYFhw1kfu5VPaezW3kpSTAyEaRVKtyHExaiZlxmw2ANdVH9MbN3cEvWBI5r/EPIN32F
 BP428f5tYXicbgsRpmkPPk2XzI25HPAnQI36CSVYwo8lMbhAK1hmFatBXP8sZKexdXDbDq+ViA2
 PvezVULci0zNDxQwUIO8WvMHjXS5yscuSyYlffa2hZeeZKxoHLV86kVb+jGd5BwmrdBMozvRFJL
 9gPhflJgNUip1p3KOVUdJ0shvJrjhxLGxpvQcaCFmh1liTOYNbq7M9N6b/cXwdQa5cWi/G3soBH
 gDa2Zh3+WN2vzz3167KVvG8wf9p1bDvrot9bspyMILTJ+eZaBcsiE+I2GQLPZ0Cv/3qiiQ47XlG
 QqFIwGuKWGqbhsaRv5QwMRVgM/rcWPunod/s79LJFMdFrf9rZUFgrNlVjNqmD2xUUPHM4smmHoH
 J14pMQSweJmXUY0gN4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210020



On 10/15/2026 2:14 PM, P Praneesh wrote:
> On AHB platforms such as IPQ5332, IRQ group 3 maps multiple hardware
> rings to a single NAPI instance. Each ring is assigned its own IRQ
> line, but all IRQs in the group share one napi struct and one poll
> function.
> 
> When two IRQs from the same group fire simultaneously on different
> CPUs, both handlers call ath12k_ahb_ext_grp_disable(), which invokes
> disable_irq_nosync() for every IRQ in the group. This increments the
> interrupt controller's disable reference count for each IRQ twice. The
> single NAPI poll that runs calls ath12k_ahb_ext_grp_enable() once,
> decrementing each count from 2 to 1. Because the count never reaches 0,
> all IRQs in the group remain permanently masked by the interrupt
> controller.
> 
> With no further interrupts, TX completions stop being reaped from the
> WBM release ring. The pending TX descriptor count grows until the WBM
> idle link descriptor pool is exhausted. Once full, TX ring allocation
> fails and no new packets including management frames can be enqueued.
> This causes stations to disassociate with reason 34 (DISASSOC_LOW_ACK)
> and ath12k_mac_flush() to time out:
> "failed to flush transmit queue, data pkts req N pending N"
> where N equals ATH12K_NUM_POOL_TX_DESC(ab).
> 
> Fix this by using napi_schedule_prep() to atomically test-and-set
> NAPI_STATE_SCHED before disabling IRQs. Only the first CPU to win the
> atomic operation disables the group and calls __napi_schedule(). Any
> concurrent handler that loses the race skips the disable entirely,
> keeping the reference count balanced. Guard the enable_irq() call in
> the poll routine with the return value of napi_complete_done() to
> prevent an unbalanced enable if the NAPI instance was re-scheduled
> before the poll completed.
> 
> Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.7-00587-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
> Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/ahb.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
> index 2c55aae06dd0..e5bbfca2b2ac 100644
> --- a/drivers/net/wireless/ath/ath12k/ahb.c
> +++ b/drivers/net/wireless/ath/ath12k/ahb.c
> @@ -602,8 +602,8 @@ static int ath12k_ahb_ext_grp_napi_poll(struct napi_struct *napi, int budget)
>   
>   	work_done = ath12k_dp_service_srng(dp, irq_grp, budget);
>   	if (work_done < budget) {
> -		napi_complete_done(napi, work_done);
> -		ath12k_ahb_ext_grp_enable(irq_grp);
> +		if (likely(napi_complete_done(napi, work_done)))
> +			ath12k_ahb_ext_grp_enable(irq_grp);
>   	}
>   
>   	if (work_done > budget)
> @@ -619,9 +619,10 @@ static irqreturn_t ath12k_ahb_ext_interrupt_handler(int irq, void *arg)
>   	/* last interrupt received for this group */
>   	irq_grp->timestamp = jiffies;
>   
> -	ath12k_ahb_ext_grp_disable(irq_grp);
> -
> -	napi_schedule(&irq_grp->napi);
> +	if (napi_schedule_prep(&irq_grp->napi)) {
> +		ath12k_ahb_ext_grp_disable(irq_grp);
> +		__napi_schedule(&irq_grp->napi);
> +	}
>   
>   	return IRQ_HANDLED;
>   }
> 
> base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709

Reviewed-by: Karthikeyan Periyasamy 
<karthikeyan.periyasamy@oss.qualcomm.com>

-- 
Karthikeyan Periyasamy
--
கார்த்திகேயன் பெரியசாமி

