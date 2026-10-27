Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090612;
	b=CXYWJfFVkhB4Ig9rZtxLC2KQi2KeveoBjZ30/1FCMpzuebVLYUspREea0ohuB/+qAE+y
	 irQ6Frp44RofO7HKOYMnPTNdCUOD4wqW57pFViXOloawGeCvJOPvOygHSbEKD3HEo8bk6
	 6K6/YjnDpGu4Vzds/oFDJRUx9vh+XgJZ/X+AvtC/VVZ/f4Vc1iAiNROiMl/efeOOBZ8AV
	 VrHwUB/gWrvDgYwlgh2YKa5e7SnApR9P/BHzjd0NzM7fEIcbxxz6gKhBRpxUD1JPeOO1j
	 20DiJTp38Y6Iv/TeSrSoih2RsB7/Iw9sk1ciBFaTtB05tIAiWV5RqvBBHbi4w7df7ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090612;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=c2bGMudpaK2aZNt6kTu3J5N94R+G75Vmr5rgSyaEFHI=;
	b=SEU+Z/XcPHH/BVYxggS0JFLTHDYJxqebDC2hWxsP8Ot+dBm+SJK+BEo343Ffm3NLqCey
	 1Y8w+r/WZtKhsx19uRPWxfyvN8uFSeQPlS11x2mHDfyh2X7MufzEKik60nIfyYdqtckAd
	 J4Bb/LYnb3rtYmEnMvaRD6o21wjFbTJnQpP5MyBHbuG3MIvC/Oe7Fgys0h0p+pXOjDR91
	 BZtcUL1tFXBhI4zD6ncB8RFe5lK5yVw5SdB3fCeX7cKwNde+7QbykI87ktPM5KR0Wbh8y
	 v5nu0clvKmlgx4SIIjpxNyGciYyuE4p0b4dK3UpXRSyEduVPlM9xHArHRCzdrJ0GwKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gsc1r04c;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Gioif8fW;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63A6606A33B
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D63A6606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gsc1r04c;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Gioif8fW
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R8g6An2761008
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	c2bGMudpaK2aZNt6kTu3J5N94R+G75Vmr5rgSyaEFHI=; b=gsc1r04cOnOpORqM
	xk4ODxyDbtGeNphBJTIDGKUI7QCo5byls9yX+I04lQ5EsvhRmUUaLKI/4EFFAGvC
	z38lJ1WRxcv6mwO1T7HM7hFXYr50KdMGeE+1ZARM1jWuPrz8OMFUEn1VvaZnFnSg
	KeAdcBAfC+95gwL2QdwEhYdgmw7Q1X5oxymCq9dFQMvclSAI8I8rWxz14UikXlWG
	e98Cw4vYCnjqGXyGe3KD59KPqazXoxoXo7yhJVDE7f3/UR8uYPxb4CaEKb+xEV2j
	ymO1Q0DurbFdH9Twn2R5Cx+cyxABf+ipbd6/kszZ7oh6wWjjhTN+nYHqAQ/r3q/+
	0ECsWA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjh919jqv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:43:16 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd8b299b05fso3966596a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 01:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793090596; x=1793695396; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c2bGMudpaK2aZNt6kTu3J5N94R+G75Vmr5rgSyaEFHI=;
        b=Gioif8fWXxA0LDKL+d168GVkWk8FPBt666GN6diTMR3fCEGO544wfUCQwbf53WCyQJ
         6a7lRnoKvxTHPkErbHHRg2zB6hkomhF+pY8T3iKFFC+ikMp35n1j2oz0qAkYRtjuAE/B
         KroBdV77AVq1r/gw3Pz/WUsxMCr7T/sOloeLAS+Iv2O/thGd/PPVFWhRafWokL3n84ht
         VKyUsUAJeRG5poUxncOdrJqZN/1CpuMY9etwg/Ljxy90tsvR2FXYEzvn0kpbF9rDyNDF
         /+xMydZZEsaMQ+H+JV2LitRByUuR+mdVFV9aaF0W3soQSabZ/MWrMnqsSvC4TXceuXKN
         WwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090596; x=1793695396;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c2bGMudpaK2aZNt6kTu3J5N94R+G75Vmr5rgSyaEFHI=;
        b=haYhUHL5Vra1//FBjDBxTA0ENWrewnG/mzgcLrqhvM0MrdHL5mwdG42lEiW5k6TWCI
         O48+6tkP9KIe+Mz84VrCsmgPOUJfiMmX7OlPExbU4rBX3tfpEr9bBBmCXNA4JeoiP6IL
         3tsSVsWfvHc0Ijn2HDwV7GZ5aV12uwEImjzxZGNy+X+sOwx34+tXZutQ/CwZq/as3hDB
         BmwFiMFRtkXDmqUSVVjGN156Y/k32LIi78cj68btLdGefw4Bvq0byEdyaqRp+6N0EcCs
         Ac4j3/dhqisp8y3fdeklLEoe8Fq9gOyqzyAGIT8t1sDpmkunKOTXuCSCXzatQPnI5r1M
         8jCQ==
X-Gm-Message-State: AFq9FYKUBgkMwqbo3NYk/FQRtnjEE0lFJyzSiKXOtI+G34vIitnuodyx
	hLr1dstKm6Db0uQSFJVeVIahOIX8wQTP8QxTY08qTCIk76F1Ou3UjbW9p4poQErUjIsSoo2W7by
	4Ki1GyusIUBlO3CpaUOJ5l//hm46zqr0tqxggJZH/0J8QvR28iY4yor4/xLVmRKz1+CESBQ==
X-Gm-Gg: AYBFou2jYT/iXnK+Tnh8qMNfkIvyiJO4x4Ns1nIwuAa1YYH/9A25PNjMiCagLlWxACr
	YlfUQXVgITtfabBnPsyxZ2AryIpmx01KId2AxjufjAOqeEub7ZsyVdBvf8yIkkTEg4/xcqm0FbN
	Ru7T+5/c/Io6FQ+CldQ85yHYuvuqi4lX0MI2nS0Nsxrtcwxxn03ofhR47GaxY8KUh1RFbh2VKBt
	MCx8m8i72b4lKjv29sRAf9c4RvNpmtCzCd4DkCnJ03TXeTJuGNXk4Xlt5Njck0BuXY0di9uwGr+
	squ9nsPhSEkQcNZi9ty10wStYPSGhR2s4fkUo/qAgiLYvajRX2amvrqj3XZCRup07uhtlTbzsdT
	dcriX0X7jCX5q5pd0PU64AF6ALiB8la7RZP9v/B0fITyHF9E5pap3c/LGjwbYypB4SNaGIWoD
X-Received: by 2002:a17:90b:3dc8:b0:3ac:adce:60c5 with SMTP id 98e67ed59e1d1-3adeac07ed1mr7831738a91.23.1793090596255;
        Tue, 27 Oct 2026 01:43:16 -0700 (PDT)
X-Received: by 2002:a17:90b:3dc8:b0:3ac:adce:60c5 with SMTP id 98e67ed59e1d1-3adeac07ed1mr7831723a91.23.1793090595640;
        Tue, 27 Oct 2026 01:43:15 -0700 (PDT)
Received: from [10.133.33.161] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40651560sm2801592a91.13.2026.10.27.01.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 01:43:15 -0700 (PDT)
Message-ID: <4af7e2e8-c0d3-4a2c-b38d-553406920db5@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 16:43:13 +0800
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
Subject: Re: [PATCH ath-next] wifi: ath12k: fix IRQ disable imbalance in AHB
 ext interrupt handler
To: P Praneesh <praneesh.p@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261015084445.3045925-1-praneesh.p@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: LbX7c3nmYHBLgrHlNsLx1Mguj3D5MecV
X-Proofpoint-GUID: LbX7c3nmYHBLgrHlNsLx1Mguj3D5MecV
X-Authority-Analysis: v=2.4 cv=TuxzFzXh c=1 sm=1 tr=0 ts=6ae06424 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=ZlGgcrqJOETN8L0HtcUA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAzNCBTYWx0ZWRfX1qiAfioIXie2
 eSoqyjkyz1SRC85SDG7grciESlooy7PcqPnkW6Ev5RKm9rABZi+28ohEvWGqXMVq3Lk5YO0AwCE
 cmi31726TYD2Pg+N3jSPdZrsNxjQBBUlHWbksC4xtH5wxCSapE44TMgcRxev1aCTGmpG4B3kSEs
 gpJDB/E/l310hMdBhaK+uwQMrDpweg0EnIKz9f5A8N0QjN8Go9+Iz1S2dbReHuLjKEIzfHQ0aSb
 azjpSn8yq69ovz4oTqninXXNPc2X9Dqz9b6xSrGos8xmn0LdBaEtG6FGNBh7qdxo9rQb9SQa1Z8
 G9MS0bdeIOuS78geS/9KsKaIdDcpjHVTT7C3aaBuo4OOB7f84A3YvBSkSLoCkvum3b5JXnCW7DH
 5Bb4M8ZzG6RAm81wIvoAFHgahjU0bHiAAKTzGGk016SdgMDXMDuT9sDDud4o9p4H60LQiVabt0b
 YokYCtCx0xCS1KU/scQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAzNCBTYWx0ZWRfXzSgQtpwCz8rQ
 myhWw4iPJP/oLrIyv13dhHAjMv49iXy6IiUuLcygBiSGC3HjTy1Pig3NVuSjSiPRYk4n1rcOi/I
 HhCdj3P8aG/IluubmsoxvYZJPXtKed4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270034



On 10/15/2026 4:44 PM, P Praneesh wrote:
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
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
