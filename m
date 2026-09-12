Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736CC2F531B
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 12:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216370; cv=none; b=dnNtaYQ/6QB8f6bZdpEOjYwLUOiQNAXf1p+GL/RvCDgtoS8sTycff10JDe5Tw+xtmV/7hMmJO8xX3cSlY4qQIEosiNGFJiFM/KtaAp9P6iIqiA+S86slTZ8Na1yQYvkuwSgT4KxxM2xppeyxL41IGqwFwCJL/N2apVoMC/Qifyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216370; c=relaxed/simple;
	bh=KncDjwULt4+oqGpVz18wHOV4kK69IfpPK5DAySVEO5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgwWf3Q3JEzEmWGxO/aGN8dBisrPMuJ/0U0yRRx0DnP0A25jNYvPgi1Kr5wWrla9B1FfP95dR+ID2laGaKbI8I2kOvZkq0mkpQIdMDANgyJqgkPE2fxikm+JSihLxZHisWzvV+cLJIsjP7HBLmhSO2GSf4cqP9yL9ADTyZdkzr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=F+PC6Egr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O0MIQiTN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="F+PC6Egr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O0MIQiTN"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68CBddkO3273014
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 12:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=RcgdAk8cNLto2WtclY2UGYFI
	DFDob1kxiwZg+puCrSc=; b=F+PC6EgrUXIvrub8LFoqBiF5YzmN1QXuT7rQP3tk
	ZA0uwmesH0s/X/ZsQi9P84xajxiBBklR4qDf9QDwjMQJAt4uMqFzzOnrfDhy1iwq
	81eXGIbmjIzHJh80sYY0mRAlRfjL4jS9k0WwQpgM5opYI9pfhuN3L3tMK5VfL985
	iA3K0bUFMGeslRGe/F3VC2k74v3IHobU5rrtYl6Ml8LzbQTiCbFcmAp2LyA8ciKc
	0aaqxvm/wnq7gf9JcBI2xMM276H3dS5mxmsids9ukF9qKwUm9ijABp+Yo576GrM6
	I7Ddq/gi+1ztTLFPvlhDTqIEubdEbIK8ykPJ9bUpWfKfgQ==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmy9dgxy3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 12:32:47 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-791463ed29dso1492350137.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 05:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789216366; x=1789821166; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RcgdAk8cNLto2WtclY2UGYFIDFDob1kxiwZg+puCrSc=;
        b=O0MIQiTN2Lvjp1ZYyss+tI21NwVBv+vKU+IkPAfXofBVNAsD/GaEFTcPNk5qrYTYTV
         l1UKs4QvjUeBB8k3wgTDI2Wd9vpyjkYoEHSl64NDlhcvy//DRL/ckEhoKFhcEN56GGiz
         /m+dlbidmb8kq4CBhvt/SJ42boTIXmg8GEOoDBOrznQkT6u/T5Dw1IvlxvKCTHtltReS
         VQ1cUkWGjNFn3jSqGK7SaHwWzpUUk9Z/JF7adIR6uJI17X1o99eSjxBeBe/PKeufL1xA
         AHFscFexbM490vcP0Irzv/CgfmiOk92wzpGvQ98Tgxk7UsXxAWe42MYcU91J8WWPuDTg
         D2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789216366; x=1789821166;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RcgdAk8cNLto2WtclY2UGYFIDFDob1kxiwZg+puCrSc=;
        b=HO3bzxbRS10SJmZO6IhwB+2PmBt1rTr+De1HHDxX+DOP7EWn1AF6s0/EUAMDLf2Cr9
         FWiLCu8KtWgoRmSvsiY0Ux9dYcOltJrsgUn13+OlccCDLxhcGq8Q1NbJFmAJ6ogaBBhS
         MWjChlvpe2KkE6gweriK+ZeIwvRqMKEdo6ohXV9xF4XfpbZMtnAW9nGjdO6JOdYNHrPX
         1g+0XZSuG5Loxxq7aE+1s4TpQVrXrb/ZvdxUaLBa2KkAWIcrNO7Xj7/b4W+QaE8LC7WW
         9NdfAX3PV21pHNW1YtMreTr+ZdP1DpHNwKJQnZLcswn/dNN2+l6al3vGlKN8G6Y0zc9g
         aZmg==
X-Forwarded-Encrypted: i=1; AKwUvByz+rFh7cAfoj0bSkhJKAoJr3/BKTPATI9NypL429QfjW6SBQ98UjLhfUOLr3Q8BkHDk0bokVgCazsxKGAXog==@vger.kernel.org
X-Gm-Message-State: AFuF++kPt7u8J/jOJ1hUFxcPdqrfPomswQFABRO45dCSdyBfPbxmvo7A
	Z11pr0rmmoP584Z99+l9ZJhfkL0diXvaa9RF0/CmhoyQTj3B3AaZXN2KrVlhJuANL52vDtaczQZ
	Tdm+9KAHxZZcYCoQQpETk2QUQIQopgY5zL2xSHErfIf/5JgsKPTRXw1F+eS9Hv0br2lEIboq6sx
	LB2w==
X-Gm-Gg: AYBFou24TclEQqEIbdVjewOx88Hezfm39y3Mo7lzqBb8oXPObkEWDAQMTnNa2DjKXfg
	52sgl54BBxLleAyprqLTy3J/9UT62XJJbwYylQotB4hbVeYZsvDw8hfAU4iFnN530i7oH9itv6t
	Gzt9SvQ0DRqjpUMbBCOkEF9AFvtb0GQyynckSGQBK5cCBTTw0X93rGWKv//nxEQo8wOhT6Q+4bP
	3jkVIf2VZO2jJzAEz7IYDvfHcAT87/5nDs7qC98JQwRxHJOKeG0EWiVHQAWUGrWDDWkE3q+GDqg
	bOm10+EHuZuEw824SedBJGIPRJb2L9dRGRBDIthWSiYQ11NpwDgztrePFxqv5H9idwXeWMuwS5J
	XCUsdWdDecxD4HQ3RoyHyc1P/DQQOqItDmLZQfT7ETGd6Hw62eOQiT3gdvaQ811akCeZWa+9+2/
	dXzKb/+Nu/71xb
X-Received: by 2002:a05:6102:2ad1:b0:784:b882:9567 with SMTP id ada2fe7eead31-795a7e2d4d4mr1504281137.6.1789216366551;
        Sat, 12 Sep 2026 05:32:46 -0700 (PDT)
X-Received: by 2002:a05:6102:2ad1:b0:784:b882:9567 with SMTP id ada2fe7eead31-795a7e2d4d4mr1504270137.6.1789216366126;
        Sat, 12 Sep 2026 05:32:46 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8a047a643sm1202626e87.70.2026.09.12.05.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 05:32:43 -0700 (PDT)
Date: Sat, 12 Sep 2026 15:32:41 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: Re: [PULL linux-firmware] ath10k, ath11k and ath12k firmware
 ath-20260909
Message-ID: <n2imuih2huckb2r6weqfydj3pygw235egmmsm2ug7gqc7ud7on@jwh66v3csydn>
References: <766a6ea9-f670-43c7-bafb-5c91f49cb451@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <766a6ea9-f670-43c7-bafb-5c91f49cb451@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEyMDE4MCBTYWx0ZWRfXzr6wSipYgd8k
 5aZVVpdP0vTy6Tg3bBkitVu6LGtnKNOmw+KD1Ewgv0W3E8AFSTOubMAbf01Nekh4xQB70lv/Yut
 Pz97JKe8BDsixFEFxcoosLyfcJfyZBXU3RvRX69zLaVy44fCHfgfIdC4I/4gnf/XUqPlX1KijJZ
 kfS3zPQrv5bluu+4rPj+d3CUGT6Q07jCCXdSEtm+KbfdSaLrEVw/RgLsuvoG7Zni7RjSqO5E/aL
 cZM6O+T5SeECFk9IrIoSHamnwiMPDzdqdXWLjaCRi9KGfggWJWLW11o+zIHCLOr1jMEglhvEVns
 wC603ZY2CYMbxzUIIzA+hCkL/AFU21cb3dVflsX4QYBV6lIt1G1ZYC4Xnd4nteTEur/sHizlWXQ
 ULeC1DQ66nkfjWiXzuc62XDLmWl4q4CJTXZodTerXWlJM1wKQYoksxwJfMCoT6BF3Ua3ntgfZCF
 XfqsOkCv1RPo8pE2q/w==
X-Proofpoint-ORIG-GUID: -0vzNO_39OhP-MvWEFhVyFLcpgcy_3cJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEyMDE4MCBTYWx0ZWRfX4A1uF+yfFXX8
 GnCq/xb0CINodEq4cwyIEUeHqQZyPtR5HKE609GxWvl5cvxR+mWV52ftvkhhmsasMYG/UGxjvoa
 SHa8qq/+3KXToICRABTNMj7sOacgQjg=
X-Authority-Analysis: v=2.4 cv=Y6htIReN c=1 sm=1 tr=0 ts=6aa5466f cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=p0WdMEafAAAA:8
 a=Cll3ooqCA_IsHNaTrZ8A:9 a=CjuIK1q_8ugA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-GUID: -0vzNO_39OhP-MvWEFhVyFLcpgcy_3cJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-12_04,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609120180

On Fri, Sep 11, 2026 at 03:13:14PM -0700, Jeff Johnson wrote:
> Hi,
> Here's a new pull request for ath10k, ath11k and ath12k firmware.
> 
> There are no changes for ath11k or ath12k.
> For ath10k add firmware files for the shikra platform using WCN3990.
> 
> Please let me know if there are any problems.

Merged and pushed out, thanks!

https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/1238


-- 
With best wishes
Dmitry
