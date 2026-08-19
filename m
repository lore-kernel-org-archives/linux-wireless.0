Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87E03C09EB
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787138332; cv=none; b=MCWA0KyhAl3DHZ+iEE+dtki+mN3Pzyhj6D1Xar4DgQRUze8h9CrYrZr+bw51uk4oTNpjs5Sc68RD7n8dx0SCiwnjj5CwvhigOkcvhe77LFLbOItOViw7KmzoROFrAKjolFqZSE9ltPTN6cyuEQ57EzHshnH/MJ3Rj1vxTVNd4x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787138332; c=relaxed/simple;
	bh=oti+Yo2lvKfP0u9zXEkitVC/3ze8NZWI+NvEiBomGNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TU1SIWcgkZnYmEig2zaEI0AtNS/6mvXT4VOXlskNmxKw1BzXMJdaHGk+xWT/XhRgHZzZBgWRixxgOes28MT6MJqvlJA62Jb8Os+54S/rGyZFso9jhwgKVH2XjMA/1bny+J9R0CdfZJVtI2r8xBtBZ2t/P0nCwBZvPSErAdydZ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cTLGZAVW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CIw0mSvC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cTLGZAVW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CIw0mSvC"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JA7wXq515986
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xJ6o8/EdTRaliZzL1cFz7i/XG75deALTCG1BEst//Cs=; b=cTLGZAVWo0rVSeLE
	VTNSyVOTDHle+iZ/XHZPW6e3pSWRQWWcyRng37ToN+EZ+yVUiHS7UapFYj3OAhwE
	f3g6fMJqjvLkSQNua2a93cPx/m/sVaazA6Ont9dwMafAxn8kax6cF5k1AxI54oSx
	zshjW/C3d32C1OHsuNiGZl9od9dK+0oCX0C3PS7SNpdTqKWdHEkNgr1kqRHJO+JP
	WoNKEU/sr4yq06lhZ2f1BhewFmPxJkyNI43BTMLN/itEwixJkKPWX94zqf/pjca+
	VqIjkosMRGkFDQv4C9Dlxw1U0Q/Cj5wUxsBX6W/XINE87WUqp5ZGcxwEq3VcWKWQ
	f7VX7w==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfptuye-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:18:49 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso1473523a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 04:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787138329; x=1787743129; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xJ6o8/EdTRaliZzL1cFz7i/XG75deALTCG1BEst//Cs=;
        b=CIw0mSvCxl8R9mFDpfYA0qNEbmYyLlUPdPipz+Hwnhg1XJwQ3qVzfAhEiqNrrm68wZ
         UEp0KlqxE4U4NEIV5MT0mU/XzgyGQcf23N8MqJmhN2KhpqVEtwI1L6Y35XG0skgyiFKu
         1xD1Bqo1R3XTq3DORMmdMvYYojJEMvF2pKWyrkNOgvLaMhfcILgqYPn3RreUxSU8aLZL
         SJUKJ+g8D5oh4jo8PULDVSUjcztwF5+EMfigmIDZ6eb6gEP+3Gxwrl5gRYvWc0Gn4mjE
         TmSDPrt/4+NC0hmrSwAHCkM59JremS1ADg6UAJCz3Wx75YT3ZKwmdmswWxtLg/lGw3hu
         35BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787138329; x=1787743129;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xJ6o8/EdTRaliZzL1cFz7i/XG75deALTCG1BEst//Cs=;
        b=GLn8um0451u/Be3ufeJWv9bO1ioIWeZ64YHWsDxAl49eYuhDBbycGOa0Ji/gmWBi8h
         +0f+eZlkA8M2Txlmx22MT265Hu8U9WQRQc/4N1NVWPdFLMHLMkwY0RKfQjMQrkid6sZa
         DTRs0wQBglI17oEA6wS3/6K0EgCaZmCP2ALHJ1FBigC9BTGbB80atjGiCwn3vAom41rA
         AtpRqAeFbm443nlIDSOWYQ2r3tWXr503mk5ZB2zhcHU104QPl2MrzlvtOjOZ9+2uAxWT
         CEG1YgaSGWmJ87Up9+pS/vrUoZ8UuvbAOBVtPxXzOpjZkN1OIlhq6jze78U0ZI3BS6O3
         gxug==
X-Gm-Message-State: AFuF++l2Lp45g+/IkktHVaBBTrSbnMGkVSfYtQmVz2ighuPwXmBLB97A
	vEd5+11X1zDZwdzkk1sCuCiJuO9UHWf0fOdhsylMfPQD9XRIIvrCWfsyKzTW21VdWweHhzdrUTA
	cqnzqJvcjslWQ86w9PmufVOZU9aZwPDxrcmUiZF26vF9qm2DqB9Hj46eNXsFDlDh+dBid/g==
X-Gm-Gg: AR+sD12Pcf5IUsO1hEre5Jd6Lz709UDDc+WdMolkPT7RhbxExW4rzn8g9cgMGyfl5mb
	obhYTD9i9ExkI3ySntgpN8EqlfqzffUoOBVYpgbz0JBxupT2G5JrmnxEgFLD0PX+tv1mdWiQLMa
	b7BYIQRtc5/dZd2GOv4APlgzoYjIFoIuw1yVL949Y8fDlXXWvtelvE7tB3DaFdri8HMNIMJmEnm
	lA3xifGn6TLmk6uI4A+8DVYWVZLAe11kvArWh+Ps+Ei0mcnI+BGeIeCvz96VHTpJqzD4d0oXW7R
	bJMI5H8WxruZTTlpYEsqrbflTDSNINKhHus/TM7WESjruzbz3uSqCBOTmgjdogVFx/fy1Bglx3L
	cF8UmIJi0De1mOPZrh+XyqlFMMePJWGmLsL12cJHMEKJu69VVKDJzWYRxoQGiaIjh5COdfuSumw
	==
X-Received: by 2002:a17:90b:3a45:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39580aa1085mr7913847a91.6.1787138328977;
        Wed, 19 Aug 2026 04:18:48 -0700 (PDT)
X-Received: by 2002:a17:90b:3a45:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39580aa1085mr7913744a91.6.1787138328510;
        Wed, 19 Aug 2026 04:18:48 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957f96cb6bsm2388371a91.2.2026.08.19.04.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 04:18:48 -0700 (PDT)
Message-ID: <25c3101a-294a-477d-979d-423e532cc6a5@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 19:18:44 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath12k: Fix IRQ cleanup on PCI IRQ
 configuration failure
To: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: I5wyEj6mfZH6m4Lwr2CLwg2iFPahT6Qf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA4NyBTYWx0ZWRfXyGepni73Yw9w
 tXfdFvm5LsHpcnFFjznx/WTGNYUDaEeQsNB6M2ltyDL+2U5qKg56AkfvUE+oWFuIXyGTRsPsABC
 GOxwX3nwzgNczgD6uCrKW0nM2+vKmLwZIYzr6XkiKIFmUGOf2u4gkPhQ/z7WV3REuo5AFVSzpAQ
 5UMG4FiPQ06E4qn8Rjofxdx3clxsV/jx/KEq28D9WbPSeE8sn2Kf/L4yrsCEp3ztJDj6n2oZcxV
 oVeeYokeJ0fVZrzkfRj+zlCMd4bE1p0czXdkSL6hi2wJLOlKG1BDxEOid98PIcspdDcOW6zfs2n
 H8SwYIuffejVR9XvLerNID5yfU3GeVTeCE0KTdLrtrzsNzho57F5B7jfUQIPZPEiI2D/ioYY9cl
 iUVu+F9XP6ExyS85w0/p7NJaLSI4Zi328OaHxPERfPKaTdnRRkizZu74lbQTrNNBuO/iPPxrBhX
 Ba+7okLg/CdIux0EZKw==
X-Authority-Analysis: v=2.4 cv=aMrAb79m c=1 sm=1 tr=0 ts=6a859119 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=JJR71pI42961Z5K6J_YA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: I5wyEj6mfZH6m4Lwr2CLwg2iFPahT6Qf
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA4NyBTYWx0ZWRfXxmzS1L4Y/AKp
 0JQxrGUGdyK5rPiM1emscNx1/lx4v++KiY4hqtW4NoCCe8ibFEzGB+7sK5Bpd10qeJpbBbB6CP9
 cv3FaW6MpBn61MbM//Vk4p7WEeJ/Qzg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190087



On 8/19/2026 7:02 PM, Aaradhana Sahu wrote:
> Free partially allocated IRQ resources when PCI IRQ configuration fails.
> 
> The first patch frees previously requested CE IRQs if CE IRQ configuration
> fails.
> 
> The second patch frees previously requested external IRQs, stores the IRQ
> number only after request_irq() succeeds, and cleans up allocated
> resources on failure.
> 
> ---
> v2:
>   -Used ath12k_pci_free_ce_irq() in the external IRQ config failure path.
> ---
> 
> Aaradhana Sahu (2):
>   wifi: ath12k: Free allocated CE IRQs on request_irq() failure
>   wifi: ath12k: Free allocated external IRQs on request_irq() failure
> 
>  drivers/net/wireless/ath/ath12k/pci.c | 55 ++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 23 deletions(-)
> 
> 
> base-commit: e07447e654476262558bee570f4cf456e2b32565

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
