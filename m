Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11455191F91
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 05:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784523641; cv=none; b=tldhQveRmBFpy2IRH42bjNgyg1kWis0yvhhTYC0f0YVnrQANpxMfAInpAUhVwjX9evgR4VJ69uagS1HdFydN3Xkm9qOF1OfOiqQmdlqsI9bK6bJWzBoJSnBMV950w0BVsv2h2dIMGivAVh49lusPCzNX6FRNV8MPJ+UAX60ofKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784523641; c=relaxed/simple;
	bh=XiJIgTsGzIYBz4zv5Ruu55F4esgHb9h0BvDn1/wWryw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WRDk3MWr6YiMOYQ4cVxo5ZPauIt26CpKy1keha9AfNurQiefrU4VASEBAA/LS7qcQNKQRtphvH7qIowtgKjTLxudZBU7MaBvvB2Gi38ayG64dMM+pFXBR41ZsvBeZZxYdg3JBKQJ5EBW+eXC0sZyWiHao4737IqkJEBTT2PUmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=psBYpSHo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VFzapaYC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="psBYpSHo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VFzapaYC"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JNukPO916812
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 05:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Bv1m8uqJ3lf2q6MHBzpIhc2heNfWXPKnSDMAJyTDSS4=; b=psBYpSHoPKBQTzsJ
	wN9TcssqHju6mO5Zz8TnDDPLxkxE05esZs6vXbiVvmQQ8/0QqNWlhZ1mI5KiRtZ/
	KGsCcql0HqzNxNhzGBGBdrW2nwPWJwsmq2jMDZ7NmGDjKRz4p/dJaDebx98GoJKD
	MMhHDPq99arqWWu8iRXjkpm+fXB+aOyuxwNgvqGUgVXCWAFMSGobkASmeB7271L/
	vNwuz0U4letzmt0a57oFzJ7qym95mEENOEF1jXWNWKo2b1RnhNpDGkhdBFlUYuJy
	8K0wEkH4AwaK2WlH53+lGLBoA86loMTMQZmbGHkAC0Vx8toA1S/3opAfn9niYu8o
	C2Nf6g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2af4d28-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 05:00:38 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so3887064a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 22:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784523638; x=1785128438; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bv1m8uqJ3lf2q6MHBzpIhc2heNfWXPKnSDMAJyTDSS4=;
        b=VFzapaYCIVjvadtLP/GMf3cJX22hWceubK7G4+lZAW1Als7n+nrnsklH/ezsWFwLK0
         l5s3BababbNQGvq1pr35j2aQOvkIWXU1v3nExj3MMTN0/G1YvHruYkRc+s8pH4tERO2p
         5AAVJ/kYStQOfun1PjKfHgHnNOrRaLPAk7R/mP6mYCGFEYH2L1bMz0H6s0jdRvJO2FL8
         mdbG5/l3fTIQ9Y/729pazHuiD/cHoJktB+NKqYLGQ+EK1gZyOLBrf2DZ+6Op8GitCaIg
         hlOGLiSapXkwBbqUpHarwnQWOb+v483MiKu//8XYcuQtbGlOBfI7MQZym5Dxg0noDeAm
         v4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784523638; x=1785128438;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bv1m8uqJ3lf2q6MHBzpIhc2heNfWXPKnSDMAJyTDSS4=;
        b=h/ptGrdtm7nCNd8on867iok4IKfuephbZiyyv3YbY9ZZXrRlNxf28BiByzbiHDI4fD
         0F9IgiVUxCmxkmwJzhqa/Cl8fH/plW7oDqOqdZrajlcdYuKj6/v/ghYVvMylHorsDGmz
         y2FUEj8WDnpZmXQuaabdFpXhbp3Hy9N0FihPiMOzLcn9B57C5E7Bm1pQipIFmJ+SV0iE
         BBxuR0px+yboRtM/sII4CmsNTuoHGsoJCqfphRAT0sF/O5ttlNaRq6sBvmWzYQ3jwdBd
         qUKWKHeWHKsus53KRVBuOOedl/Jrg5f8hcio/NqknHea7mcLv3OgRlpkmzS5ga7R9tca
         j7wg==
X-Gm-Message-State: AOJu0YwAOkAHWiEyHiWbr3Sw77Ic1hUOWiRww7a5Yggwxx2QYCCh+sH+
	s/pjaVlovfUC1G4i962+LBNlnQTEqRq3lKQ7R3D7z55UN5fRxYhHGKLJPrUisVF8eMRDfY7zPHI
	lIqXZUFbL2kRcyriKtuw4nXEHJQHggqvtzz5HX14QHbo2j/fq/WY/5jiEb7iN/R7hBV78Jg==
X-Gm-Gg: AfdE7ckqAYj3Ob/xJ3EbMxQ0HpZ/Aw58CPfscaZWCcwHm+1wplSjY0Rfq6Za4GxfVzJ
	ar4f8V245R5Z9acKUs3SUm3gXV8QHQ32Y5KiE2p7MJwjRGCG6o0+GocHd795IvA6ZMNyGVh+WgY
	wimMbqOR4HjVXtmYgu3/nuv0O/1e29qhTpEAD7M8DR5E+0eOu6+ovumBrgsduhZIiJnTQMli5/W
	06nLBvNrW4u2D9//n/AxMv+INzutRYiIAjfHiqBvIbSVKQLDTbbXsaR21KZlUT+HiYrEFgLwzjT
	fHM/mQUU5qhopb+FWfAn2m4WsAAtCBPW8/6Fx7mAc1W824gF4Qe5RngTgpNv/6Nd5WSJcNXf64a
	GfKaGNR3dsLo5NYRFzRbsWWuDnwdgWI9Ml+OzWi3Wyau+QTDu6tzqYmyOlJWLAGZFqvVCalo5
X-Received: by 2002:a17:90b:1f88:b0:38d:f1a4:1116 with SMTP id 98e67ed59e1d1-38e4b537bedmr10975980a91.33.1784523637592;
        Sun, 19 Jul 2026 22:00:37 -0700 (PDT)
X-Received: by 2002:a17:90b:1f88:b0:38d:f1a4:1116 with SMTP id 98e67ed59e1d1-38e4b537bedmr10975949a91.33.1784523637068;
        Sun, 19 Jul 2026 22:00:37 -0700 (PDT)
Received: from [10.133.33.82] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e47fe75c1sm1368468a91.1.2026.07.19.22.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 22:00:35 -0700 (PDT)
Message-ID: <df37460e-f8ba-4e11-b412-4aa8b17cd32e@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 13:00:32 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: restore country code during resume
To: Stian Knudsen <stian@pokerfj.es>, Jeff Johnson <jjohnson@kernel.org>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260717130254.36732-1-stian@pokerfj.es>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260717130254.36732-1-stian@pokerfj.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA1MiBTYWx0ZWRfX/tF0qXvVJs67
 Y+awWSD5B7umH6vZqMJGXeoBbod1PND4Ar2VEDMJeb4SB8Sy8sd7TYvIkSuJFY4Nx7WCXuJVfk3
 B7JuRCQw3RtQBp5p721wmWsp0gXIvKc=
X-Proofpoint-GUID: o34WGqoIY4BRPBeM4QQYo4DBVQ2r2y87
X-Proofpoint-ORIG-GUID: o34WGqoIY4BRPBeM4QQYo4DBVQ2r2y87
X-Authority-Analysis: v=2.4 cv=a+sAM0SF c=1 sm=1 tr=0 ts=6a5dab76 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-SOlkNUPErW3LcS7OYoA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1MiBTYWx0ZWRfXzTGjOSs8M2Kr
 xoOB9pOm8L1R51J2WkbsUVRlk5clhU/2MmDeeTxFV6I4rX9ZnBUvee0V1e9VE+Ct+qbNuNxNRev
 K2t0gqh+2z80uyXJHAF+Ftt2lwNTP0g3RuIdfqQjomYybOxS3RXjukOhUXadUp+jDP0XzJHN9pQ
 DhV9Ize9Nz3lPwn3qLAAe8c5kJ0D0QWOZJXcbYOIm5z088thDdwMOjC6KPpbLcnZBFhpCu/1bV8
 iUpBuqTkfDmSUSmknqeaChY86p3U42rPkAWjZ7xt+pqpfjuiVW0O6RvBW2vAFFBDHRa/bOhF8VA
 7aegOZ4zicJXPzSfnV/Ih6SWohv+PsKO3FFo3Ex6Ys6PB9MhQ6EKkrQSHVPaJoZhBrA1jqyTdSZ
 5wjQlFxjpqxo7q/RGQ844yTkA0AySyxOClUnci35n6nx+X0n9xBfrz6aauik3KL2SzG9qUiPiBR
 cD2lnsEtgwL/VGUH36g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200052



On 7/17/2026 9:02 PM, Stian Knudsen wrote:
> The country code configured before suspend is lost after resume:
> the device is powered down in suspend_late and powered back up in
> resume_early, so firmware reboots with its default regulatory
> settings and the previously set country code is no longer applied.
> 
> On WCN7850 the firmware comes back in the world regulatory domain
> (country 00) and takes ~7 seconds to rediscover the country code
> from AP beacons, part of a ~16 second total delay before wifi
> reconnects after resume.
> 
> Restore it by resending WMI_SET_CURRENT_COUNTRY_CMDID during resume
> if a country code was set before suspend, i.e. when ar->alpha2 is
> valid. This follows the same approach as ath11k commit 7f0343b7b871
> ("wifi: ath11k: restore country code during resume").
> 
> Note that only single_pdev_only devices support suspend/resume (see
> ath12k_core_continue_suspend_resume()), so handling the first and
> only pdev is sufficient.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 

Fixes: 8d5f4da8d70b ("wifi: ath12k: support suspend/resume") ?

> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/-_iDJ_M5RrqACWB0qmtleg@pokerfj.es
> Signed-off-by: Stian Knudsen <stian@pokerfj.es>
> ---
>  drivers/net/wireless/ath/ath12k/core.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> --- a/drivers/net/wireless/ath/ath12k/core.c
> +++ b/drivers/net/wireless/ath/ath12k/core.c
> @@ -197,6 +197,7 @@ EXPORT_SYMBOL(ath12k_core_resume_early);
> 
>  int ath12k_core_resume(struct ath12k_base *ab)
>  {
> +	struct ath12k *ar;
>  	long time_left;
>  	int ret;
> 
> @@ -211,6 +212,26 @@ int ath12k_core_resume(struct ath12k_base *ab)
>  		return -ETIMEDOUT;
>  	}
> 
> +	/* So far only single_pdev_only devices can reach here,
> +	 * so it is valid to handle the first, and the only, pdev.
> +	 */
> +	ar = ab->pdevs[0].ar;
> +	if (ab->hw_params->current_cc_support &&
> +	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
> +		struct wmi_set_current_country_arg arg = {};
> +
> +		memcpy(&arg.alpha2, ar->alpha2, 2);
> +
> +		reinit_completion(&ar->regd_update_completed);
> +
> +		ret = ath12k_wmi_send_set_current_country_cmd(ar, &arg);
> +		if (ret) {
> +			ath12k_warn(ab, "failed to set country code during resume: %d\n",
> +				    ret);
> +			return ret;
> +		}
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(ath12k_core_resume);
> --
> 2.50.0

