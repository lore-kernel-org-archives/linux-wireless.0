Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898304;
	b=Q0Am9KME4syrOWUUMLIwgFSIBMbiJmL1Zpfr5kKdfI4hhm3etPQ3QPAQbm8NjiIJcEy3
	 H2OAhqJKWqvL2DBSbK5KccumDjl/6E2zt/9B0iP1UFGAbdiw7RiaxhNPmXM3HCz3f+lki
	 k8ozvhVORZhIGhXMN0Ga5W09bevsABC5Er8e453X+twvoxK23bdO8LQXbiImK6C48amIy
	 2GL/JWjWYUYCFYBXlMej3dFZ3T2xv9HNvO7M+VL460wk47KKwKVm0qT6woyrZXtwBtQhd
	 dfqdQ3oysujzVwSGVREEFZUfLtuf6ikn1bqbGGFWOYqtQvnlPvFU6OMOAIVIPssKSRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898304;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=BsTZVQ6tUmIbIT25Pss1efYGgm8TLRoF2m6voevDz+I=;
	b=5po1jTlGwwGZ8lVjMWWpoE38D0TseFeEcJCfw+akCcFakRwXKzdE9Jj38KIArrnwMsTx
	 9It3AlTTw2rHp0Mu5YN7CPBYk+bILpp29YYeeyGa7DttFU20heue9XtqOutjP/Kf6RDQc
	 kUutElVAc/JV4/fsCjV9gLFuOLMZu241u9Q4Ueb3KhN8xD/9OKSQy2mjdu8KYEFfVWsV9
	 fNUr68S0HU61bX273Tvg1lg4azGJibK3thGjdHbk5hBq/hltlyvTKA9Q/aGkAtLzTFo6I
	 Wy/S3DFFUaQ4z+htERRuWTfGRAW/4XjWrnMG4rGfRRf/pgnxIYXY0C2l2J2snL5ZYcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="dpyYuB/I";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KujPir1I;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD8606A331
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:05:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FDD8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dpyYuB/I;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KujPir1I
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5EQB4A686819
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 17:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BsTZVQ6tUmIbIT25Pss1efYGgm8TLRoF2m6voevDz+I=; b=dpyYuB/IwZdMjvCJ
	bcWfhr/MRUmjY8yU2kYoWhVoVOSH1IgN5Q/irDeC0zoljT0WO/INopqYXbM10omS
	iz8xkDDw3Kx/q2BPp6aWcYi6lH7V/mBlGZKlihHc8l0QKF00ZOzQPSp2A/Tt1TPF
	vSd4bgwny4JfDEvWl4TVzSM8CXQ/9XJ/RBgMI+rw/FGxFChPaxtDO+/rMBj4JqpS
	FbItxWcKF3vxHqG48iu1lJTzdKqrWowiGeZSJKm5bHPw0nYp4BmAY7QA04BmDlt3
	P1eEQselIm8bSgKAxWiXNjVxQne3AG+6LumV3tYHV2y07kRYWm6oHcsoHbOKn4y7
	0V9jZw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrq1p21g4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 17:05:02 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-16bc6f3fdb1so2274882c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 09:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793898301; x=1794503101; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BsTZVQ6tUmIbIT25Pss1efYGgm8TLRoF2m6voevDz+I=;
        b=KujPir1IzYKiVWFog5dfupUJC0e8Ys3O5p+TvGwBzCYReudncQT2GaOZYalfSkvDMp
         ZFHuQfXor8bkrI1pp2qSwNweINIYgWfMf0zZ9Ss1xrcXur00LrDkO9SxQJVAz3R5cB8T
         KVPhdTbGXQvU7NHjqDwVMyZVnAhArF/+N8fuHgTTGfE7jTC6ujuVRLim41LyBpSjopxF
         sjRFwQphJaabJGAUiCls2rUpBY+F1j+jOuqSaeMhnP8ooCZRVPC1FLIOewsHfKNrH+3h
         QuGflrvn4whLSVP8mz9GlvtFNEtC5Rru+9ee4aCJwBdlC4MsT2KKbufe/qS/qfp+YFz+
         sCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793898301; x=1794503101;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BsTZVQ6tUmIbIT25Pss1efYGgm8TLRoF2m6voevDz+I=;
        b=H56gGWUUtPTBACSqSHU+Fa+Mf/vn++LboEhLicKdwlAW7ny4fbXVshGgfgvARlpfbM
         yZxGj8lA0x/1ScDDiM8H2AnEhTk/SjzD0t/oUnloc8ny7Pw/AVsaW1J9p6L6kdskVWbL
         WvKOlFQHBRPs52wzqzv/EPRzISIfaY+SkGUpzjNNq/8cv27bm7EWbfY9EbqeOlsNhGp/
         eoMuNYYe2/Pm68yiXtoOUH361AGX//xOIGJk/o9COkf+q4NqsCjTorGO8pTVRiwzXZ44
         /o64AVkcvsLiIsu/OMeS2DbR7w6MSQiBlGZ8qtTQjfmFfuviAc5hlvA0W5rL4Ht5Rd6R
         2fJA==
X-Gm-Message-State: APuU4Z8XnlDstULpKzVamR32RElVrzsNEJ2w9dUjoBWmKoRcZvV33bxN
	Icz23+hVTKx49rluPdaiHJO/LM8EevyA0Vx47QIGLS5Uy8S4XetPwCKtrYxERipToC93nNhLoLS
	png2VJP4sTLgZEdDnnxGfUZ72SOu/WU3hJzrifS62ULfdfTXCHNXh1KfhzNrRDOK8iYqE77dQYX
	z89A==
X-Gm-Gg: AYBFou0zl/pS7zmymnB1Vj3DY6VTU/5Uvy8BZZXXvBn1xe8fDZ0pw6+NM7s5gdJiRHz
	U1FYBLQ66Mqnl6VRXe4nI1c31FzFhULoEnfOiskfgc7sAFjyI+7fkGpZjXYPGVqb4OH5hKP78Ka
	RqcHxdHt12etoTgHlEe3ErAlSBjLp1axGA2vfbjrU/Z+0NX8lL7MXWy7cUm01UIp2ypXCSxa8oi
	VrOhgh9yoqCPWYn813fj9XiPYpcFtZaclr7CL6I2ig0OHN4XGmgbXt6UwheU/FTdjDy02VefyQz
	n1kY+jT2WhAOYKJKBD4H8K3m68QvYJUsQZDlqF9sIOO0SneSNYxR7wakiJimBmc9mUnklzOakNg
	JjNdLOe2sLlcbwxXjKyo9dIHzymI7nkFLQChFGvxFejMm3GUi/XDkHTB+knFhsxbt7fFDFyRNeb
	654DgunaHpf1m/ysg=
X-Received: by 2002:a05:701b:2091:20b0:148:bc4a:8356 with SMTP id a92af1059eb24-1ac5d5aae1fmr28881551c88.28.1793898301048;
        Thu, 05 Nov 2026 09:05:01 -0800 (PST)
X-Received: by 2002:a05:701b:2091:20b0:148:bc4a:8356 with SMTP id a92af1059eb24-1ac5d5aae1fmr28881520c88.28.1793898300422;
        Thu, 05 Nov 2026 09:05:00 -0800 (PST)
Received: from [192.168.11.102] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b86fbesm18717397c88.1.2026.11.05.09.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 09:04:59 -0800 (PST)
Message-ID: <b60c4c56-483b-406e-92ab-643b0fdf2dc8@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 22:34:53 +0530
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
Subject: Re: [PATCH ath-next 1/2] wifi: ath11k: don't bit-reverse the
 firmware's PPE thresholds
To: christophergriffin05@gmail.com, Jeff Johnson <jjohnson@kernel.org>,
        John Crispin <john@phrozen.org>, Kalle Valo <kvalo@kernel.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        P Praneesh <quic_ppranees@quicinc.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Baochen Qiang
 <baochen.qiang@oss.qualcomm.com>,
        ath12k@lists.infradead.org
References: <20261104-ath-ppe-thresholds-bit-order-v1-0-0f569106cbc4@gmail.com>
 <20261104-ath-ppe-thresholds-bit-order-v1-1-0f569106cbc4@gmail.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261104-ath-ppe-thresholds-bit-order-v1-1-0f569106cbc4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=AaYkjHXG c=1 sm=1 tr=0 ts=6aecb73e cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=pGLkceISAAAA:8 a=g6HBiduwhlTomHawZCYA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA2OCBTYWx0ZWRfX7VcqRMUBLQCG
 vbmRmPE0aujcTVleBT2mPWwvIDh8GK7RmDOyNit4gQmAwuAw9s3lnHm8QicZgw68vrNFFV0Voox
 8gnMWNd6SlHJLILbgnQvc2Hi/xoksCj47Y6ArDCbDEgTQdePwG8kKEoGscB3hua/kE64Sq8YJ4M
 j8fGFImuB9gho/AylZLd2j9EZQROtWjA1ZoUMcw+aiUT5nrfZUEinRd/q7oVm1NpU/+wwIzkjjL
 eN+lJPKIbQrBzRlLXRSQYcbB156icyJponWkw/83gL2zvsFbUrs/jiLu75QTc+Azr7DUjerBJhF
 CvqvSMkpFXSleWg9cDeqy5VIgn2aKMtVbYBHEK0hBJSOL3m9yKSaTyssm5fU00GwoXzJhWu9Vhj
 zU9d51OJnEkJeAeOFQ2uL/2zNptKEiSZ7MPcllSHDJp8mkANoy7Qad7zg0hem1Pc6XwuAS25Pma
 TlDIbg/KAKqflHkxa7A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA2OCBTYWx0ZWRfXxdkKxP3TKxcA
 oK9GqASZZ9zxcqzBYTsnXNeEWEQPM2C0E3A5ixWZSRHzquDTVEgnH7/b9heYVGzCBPfCnzLgtf8
 T+1/4q4m7Wlx4iDL72tpCb+4xI/GLz0=
X-Proofpoint-ORIG-GUID: V9MB5W4M51oNy4FH5a7ejuVCj7odl4Wi
X-Proofpoint-GUID: V9MB5W4M51oNy4FH5a7ejuVCj7odl4Wi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_04,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 suspectscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050068

On 11/5/2026 10:47 AM, Christopher Griffin via B4 Relay wrote:
> From: Christopher Griffin <christophergriffin05@gmail.com>
> 
> The firmware reports its PPE thresholds as WMI defines them: in
> ppet16_ppet8_ru3_ru0[nss], each RU has six bits, PPET16 in bits 2:0 and
> PPET8 in bits 5:3, each a 3-bit constellation index. The PPE Thresholds
> field of the HE Capabilities element carries the same two subfields in
> the same order, bit 0 first, and ath11k_peer_assoc_h_he() already

yes, but ath11k_peer_assoc_h_he() logic seems to be too complicated as 
well with << 5 and >> 1 for each iteration. Looks we need to simplify 
that with just,

val |= ((he_cap->ppe_thres[bit / 8] >> (bit % 8)) & 0x1) << i;

May be in a separate patch.


> converts a peer's field to the WMI layout that way.
> 
> ath11k_gen_ppe_thresh(), which builds our own field from the firmware's,
> swaps the two halves and then writes the six bits from the top down.
> That puts PPET16 first again, but with its three bits reversed, and the
> same for PPET8: a threshold of 1 (QPSK) is advertised as 4 (256-QAM),
> 4 as 1, 3 (64-QAM) as 6 (reserved) and 6 as 3. Only 0, 2, 5 and 7 (none)
> come out right, so the bug does not show with firmware that asks for
> 16 us padding at every constellation (PPET16 0, PPET8 7).
> 
> Copy the six bits in order.
> 
> IPQ8074 (WLAN.HK.2.9.0.1-02146) and QCN9074 (WLAN.HK.2.5.r4-00683)
> firmware report PPET16 0 and PPET8 7 everywhere (iw phy: PPE Threshold
> 0x7b 0x1c 0xc7 0x71 ...), which reads the same either way, so their HE
> capabilities do not change. Compile-tested.
> 
> Fixes: 9f056ed8ee01 ("ath11k: add HE support")
> Assisted-by: Claude:claude-opus-5-5

This tag may not be needed as per latest guidelines

> Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
> ---
>   drivers/net/wireless/ath/ath11k/mac.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index 1a237adaa37d1..8b4e992b609a6 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -5825,8 +5825,7 @@ static void ath11k_gen_ppe_thresh(struct ath11k_ppe_threshold *fw_ppet,
>   				continue;
>   			val = (fw_ppet->ppet16_ppet8_ru3_ru0[nss] >> (ru * 6)) &
>   			       0x3f;
> -			val = ((val >> 3) & 0x7) | ((val & 0x7) << 3);
> -			for (i = 5; i >= 0; i--) {
> +			for (i = 0; i < 6; i++) {
>   				he_ppet[bit / 8] |=
>   					((val >> i) & 0x1) << ((bit % 8));
>   				bit++;
> 
-- 
Ramesh
