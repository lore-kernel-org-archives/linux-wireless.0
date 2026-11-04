Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777105;
	b=ANjcvqkFqlJ/nUZHEB1B8zo3MqTLmgI+dPI908B3ukcj73VNqVEiSqLYHbQRJFxM+Zuy
	 ZdG9uvYuLZcGqkGN8y5HwlQ7H+QaabriguvugYuoKFy5RhqNxRiqDVlFjipT4coCKAO6W
	 9UqBnxLXdzldimloA33IwHoQFnVadIOn+hZUWW3GdcQDQPIH1JkBDY+UclxX4lJfMKCXy
	 uY4V0ikaDg3OLDxuBHNE7+ToeBHyc6xoKoazXo+r07zuO8aCY5VPtE2CuHUVcvdynC4yg
	 gaQ0tUIWTTrP4BZIHgsYytu5ybOEn7cpyDYxSIv6iBV9o1ToUSKn/ZRFhtn3fJnraEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777105;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=q6oJS16sD1XK509mHnNdi+5JE7YY0ZS6BjwD5nrXrBM=;
	b=2k/28PeiyrMchLL2DWKLkyFgktWs+oAljuLr4HVorRVBPEaHPp88xP4rEZDYYZOVNbhd
	 wpCg35qET/+HvHFRLdMjaOKwpULVjQ9nTytiZkS18SZ4nfwpxgILzmlgtdlZjA6Jp9l2R
	 4U4jKV4REXlqLyO9a0HD/Y/HotCxZh9dYHDFNA15lEFVfoLwrfJOe7eIfkeM8BUveH04r
	 slydX3XwWE/i7QbkXw+xLPvKNxTfkMw57aAK0CjWEXg3B8MxESuMCJFpufhsvD5pkzCGd
	 hJ9wUO2PeRfnNd/QFMu4UOMaL8Ov0mKcXHSMdLrb+wSiSj3rYl0b7XxCSA76Ytf+4Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T6rJ+jfO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZWN66Mnd;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7AB606A32E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 07:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D7AB606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=T6rJ+jfO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZWN66Mnd
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A46kZUi230882
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 07:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	q6oJS16sD1XK509mHnNdi+5JE7YY0ZS6BjwD5nrXrBM=; b=T6rJ+jfOnE2+2j2g
	lr3aTQuYynJag/uX7VPfR4CubnwFXluy40/bUQyDmLcmOswq1o0HLA98FcJxDQJd
	afwP9yZ9G442qTrZdQNpF0APHujlFwwNE4PGiz216t9KuHoI0K3kuyew/6P2QZpc
	DZdU1uAmoyDGk1wHxhaSAMBSm1IH6T9SZAd5lWzscMztnOEnGzL9bhfvbPNIkjl1
	o9tmDSXX1kxk1krwP5Bo5mTG1Q7beYSj4YxXBSp5vchi2hQ+Ioa9RTFl8DA4OZ27
	I05IYdIvmJw3sqySPz/luYhRFtvdovtBHOizM+1g4mtEePQO+4Xqfty31uGh1DrK
	9f2OTw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqhypkrcp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 07:25:04 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso848549eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 23:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793777103; x=1794381903; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q6oJS16sD1XK509mHnNdi+5JE7YY0ZS6BjwD5nrXrBM=;
        b=ZWN66MndWaLT69s5NOiwctWK6XDnySY1pBT0FI+1WVrMU3n8mSxHrA2RTcZnl3kFzG
         F3USAS0160+MjiufNgMMb+RwXtjcLLAUSjh68tWnPKqFFNd+ZasuF6BEARaqteKz5vdT
         Z2F2bFtmXCiR3t/hIYoMyZpBFLMP3CQZgcuqQcqSnfKyAuQI1vpPFQXPcA7G2Vsb7SDW
         hmihzFzleKcxkMGVJLi1ZllDthm07j4UR1hI2WIpJJICQl3wSR4n/0P5hgmrJYGNA0Ou
         Dcz5T8Mfy4LeZDTbfK6yDecM0yj6hIszDr0aVe1LJIIpUjkCM1tilabEMvuE7fEj9fFd
         iMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793777103; x=1794381903;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q6oJS16sD1XK509mHnNdi+5JE7YY0ZS6BjwD5nrXrBM=;
        b=oBRSsBhKEv9dgrG7tlbiEHcAxAq79TiXhDQb9Ib9stgSgUwKe6cuNIOsJxHcLQ8C3I
         71P3qASaGPFddEVaqeS6G3Tz6Rq+c82mKbPTyLkjbTKZ9hfMtfyorPFB/WpTm41koTJu
         SyXIPhAlwJGjxvaU95/NIiV1KmgBskBRZYb+Nb9sgaOvN5F2Jc4Bl86L5GAMDrpWaRFI
         CdktksyZnHC5N5gBZ3MXjDT/tH6exYMpaEpm/8M7Z+o2FDtXGCDQtaTLvD/tP8sSPC3F
         J8RGkcXd3CmvcgYM8l+XHWsaeDnsZcoFNKQKRrfJ8dW5fHPEfkPQ2FZULbuXZWPgTqtL
         xGAw==
X-Gm-Message-State: APuU4Z91gpZs7mTFlwXtOqNMzX5222MoN2Kqu0z/DBoCPoi/S3a2EW9U
	Of1vyUr+Bk0jrqhfEn0AtKf6jEl5t6znJc3auvFdhSyWW5vclQTjxYRSfzVD421pQg8gnjU0DbE
	GR7Uog/dyBeRBGZQZuEx2BbmiozlPNjxI9BzbCu+keWxnHo6ZFF6ZetimCBeY9a3TlhFw/g==
X-Gm-Gg: AYBFou0nAmmP2NQ9ojr5WL1bWVcU6CmUl6LbWnX3sOq5rzVGxaqxNlnuukrZBqOW2iT
	sbRpYwzc8HiuQl1hQb6EO33g6iEP/dG9GMDeQarel57mWWUREQjlxTTVWIZlVTFwz0xt0d+rBpP
	nE8J+5BSulrG52+ZR8/WAaX3PUUHF02JSkA4r9jLG33IMscxxHaCrpPpM3MSLWwBAodcZ+ca7lQ
	ohu3wRaktLvi+uzLaNleI4FBZkKCh7+LOt83tuRTO280lawg8qernkyj2EWoC+fspIPVERydJVM
	T807CrTkEOzyKdmMNgYhf7XX4FqKeJquoRDXxPQiWfIA4ya1bKcSE9YZaTYY+jJX+sZN2k85Vaw
	/YoBzmm7gR6Tse2a8QCo0UpSMb3b43ee4YDt3y1icAiNtvnz1EnND/B3FBTgCS7e6bygQwUy/VI
	AhGW8fnW+rylpMmzX80LOc
X-Received: by 2002:a05:7301:4b0a:b0:369:9af5:7bc9 with SMTP id 5a478bee46e88-36a424199eamr23022303eec.23.1793777102857;
        Tue, 03 Nov 2026 23:25:02 -0800 (PST)
X-Received: by 2002:a05:7301:4b0a:b0:369:9af5:7bc9 with SMTP id 5a478bee46e88-36a424199eamr23022274eec.23.1793777102156;
        Tue, 03 Nov 2026 23:25:02 -0800 (PST)
Received: from [10.152.202.164] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d36a1sm5422435eec.12.2026.11.03.23.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 23:25:01 -0800 (PST)
Message-ID: <2d508cb8-fc7d-4cc7-8c13-4b67989a81e3@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 12:54:57 +0530
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
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: refactor m3/aux_uc firmware
 memory handling
To: Madhavan Ganesan <madhavan.ganesan@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
Content-Language: en-US
From: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
In-Reply-To: <20261104-m3_and_aux_ucode-v2-0-b6c335c14dfe@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyOSBTYWx0ZWRfXwMW0LKeFICbk
 DI4gRaJd/oGWh/nKB4U5/Z6yBSgQWLD9hAnvtmvcGPzC6TFT22D6986kzNoOdmCr30l2tZhxfva
 7C1r09/mGdGA8H3q1/R98PuTjntgtR0=
X-Proofpoint-ORIG-GUID: 6EUhbGIl5_Hl2BUPVB49gjdt1ZccbLPx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyOSBTYWx0ZWRfX0GIBiZevpNHP
 370GhcRI+LPx+uMf2ObSazrL+YiS0s+xMLI/a7iWy7sJJzbvcFV69qIM5jgxkMFNWoSIq2XYJ+D
 Kplj1KLFCKhG27URG1VTdlK/qTOZFRnRBMr2roZgX7Iyhngdaa6I2I/A3aSbzViQqslfmy54DR2
 y1bxHLeOSQBi1PpDWqYuKFLEC2hVoPYBzz1mdevWcTsu7VB1Z2NDeqCeIELdVv/RpCuP+XuUkuj
 ibn2W+3Fwi/9DBg1dQ9O7KqOOB6HMqe1IJI2RmlrbmqyNQfaf4h0FKvodxpFNv70TbUA1/epoTU
 ozSV/henqkxUNevUg6VSodsWMrbMvrr8U2CnAMvBcdbu1Q9SF8bGwELbbflQVXjTZ5c+UQF9kkB
 ucesQmr0rLhMNocjSMsGxAM67pfbPev9uvoYl5zS8lduivwAnxAXmO1gkrYNKtWipJRr1bIKKtk
 pwym6iSXKpMfIzVhQwg==
X-Proofpoint-GUID: 6EUhbGIl5_Hl2BUPVB49gjdt1ZccbLPx
X-Authority-Analysis: v=2.4 cv=T94Z3PKQ c=1 sm=1 tr=0 ts=6aeaddd0 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=WH3b8gmyxz3kVt_5t98A:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040029



On 04-11-2026 12:00, Madhavan Ganesan wrote:
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
> Changes in v2:
> - Addressed the review comments.
>   
> ---
> Madhavan Ganesan (2):
>        wifi: ath12k: rename m3_mem_region to ath12k_fw_mem_region
>        wifi: ath12k: refactor m3 and aux_uc firmware memory handling
>   
>   drivers/net/wireless/ath/ath12k/qmi.c | 168 ++++++++++++----------------------
>   drivers/net/wireless/ath/ath12k/qmi.h |   6 +-
>   2 files changed, 60 insertions(+), 114 deletions(-)

Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
