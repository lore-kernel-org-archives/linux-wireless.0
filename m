Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39433093D8
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784771744; cv=none; b=GzYQ6GmympTRy2/dChapB2sHb94DSsmjniSBIFCPG5f6bGS9T6n4QCOCvcxWAXEFOCX8ya5LgvJe8+9NZepeBQQ5GycV8cGnPUf6gfaVSiAC3wFhwNW90i2YQjbUfjCNxuREvTJk5GpD7ccXsi02FCuWZGAT+43djBCfkYeS4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784771744; c=relaxed/simple;
	bh=3dQZUn8xvzR98YcqPSB5KMC/gDhAot6zFCiBVtfhGDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gIcr7QcZEb2jsl8nJjA7AOoNTX3ByPkmd0IHi9xumSSaGxlXkf2amhtexRztSrB7rQx4fKnra1xd1lwUhDlTEd3yjWTE8txLiCuZ+uWuCA+7M5U0gcoftLgWfk+QGbUh9VnZkqIkTgbc7G8g4IGb48wyAoIXRD9XH0BclfC2TNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HfnjD/f7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gJmRIu4b; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HfnjD/f7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gJmRIu4b"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N0X8fq2658539
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:55:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VwPIGZg61RTgdC0tQzXgf9LKpmSLanNFlteoC875wdU=; b=HfnjD/f70xJcThNO
	s4g6NGmWiANPgx8MMCSlXRCRjPSUvBu+Wv+0x7dinURcoPwRUchRtN1bQz1XyLAY
	cimgrqUE0f1aWVqk0jUTQI4rKnYPxcjtIiXO5z3Oci6vyr3x8h03uQRYDzlrCley
	9CigKc3yD0quaxa7bisBXd7AYrQFJ7iba/suVC4SxD77aEF9Ttfe7V3mHXxpB89P
	LCauTscyIhqHpcJ5qvQNEAFlXk9olgvspwzLncML8+7DZo9Lsy/l9JdDMTAFQ6wv
	e1bWPkITuRvKetqMwHzd/VaSugKN6m0AwVu6FH1A6oU2k2jT8Nof2x1VRYvw1fmJ
	de5euA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fk7b50cr4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:55:42 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8485b7e18b4so254256b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784771742; x=1785376542; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VwPIGZg61RTgdC0tQzXgf9LKpmSLanNFlteoC875wdU=;
        b=gJmRIu4bsRi83d37Js1P53ytkbB5HZU2oyQ1pODtFERFEP7D/WLKFVS9UlUUxUFlEk
         78mXKcMIRSH7wfkf/uK8SvSuYXtoFHjjcurn86y4lK+3464MfHp+Sb8Yeb3HmCXugCb7
         772b2B2/BahjgT2upJN0znL9tMtQcu0MNWzXAYykdZTS25z5RKdG7Nl7kb8IP09D3brR
         KA9i4nLhO8COVn6lXwHGGv776Ij7yr5376wTmuz8jEnycz1vLvAQGu8yUKLw4SPh/GBz
         Ec73aqh/QmlGsYyeQKnvvUUvvBZ6GaGVr26g9tZs1KDmp28i6Vd4yKdHSWtXobSVS8VT
         Jsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784771742; x=1785376542;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VwPIGZg61RTgdC0tQzXgf9LKpmSLanNFlteoC875wdU=;
        b=DvG9KFncBNQTH3NyK0LI9OmI2moBV6/zb3T0MhtcyPjHhEFRA7leJ0f++8cg3qvcHt
         1G6EKxcBaf7LkcsLNgwG+ZWwpFOy3hBWPL4Kqs+8QD7kisuV6g5ai9PT6DlowDMlFwgQ
         9O12HE4yeBWywMb/Bpn3ausEHxYQXSUS7oIoMuOVO54/vkUsEcF3IoWuSnezmPiHS0vK
         YxWnYz9yMeVgLbWiNgbR0/A6lYBgwdR/cTqZ9AUvrOyb9I2Gq9mgwCDSv8jAn8EncBwN
         KHqNz3JeguGEZuVw2GcNw5UCSizH5sn1wmyM5afhqZcx9Sd/Bpd9XKDXlBpK7AQfzWTJ
         AjYQ==
X-Gm-Message-State: AOJu0YzEAObOMOj7RodwTNspAyZC4xqzDXL/20cIgej+xS23HfIyfh5r
	ZxLmScCNLzWTq55esf2fS1VVIavY1s6I1OX2QmcbnIHs52rQBHDCaXyQ2pbpobijvRu0L98SQzQ
	yawj/9dbyzqj38sGCnoPROPOUJ6GjQzwwRSN+X/tQFV0IXWX8zR91rO1dVZjbFjWVAxIZvw==
X-Gm-Gg: AR+sD13JOCkMELqsuWWkwUkkmjVP3OCzwQaLMXy+Eili1TyqT+c9hCVZwNgTxWpM8ZR
	KCX+T8uEpbRXJpK/gnlqOC2r4QqaaidUOLmHc85uj+r9MJRdMVGLRf5c8rewj+Cf3+HxbxSCTh5
	AGvvTO3EVJpCcrNrFnGeswSbqiccS1lYAYXUzbz8re+0DZiHsOnkKHvlpYyxG/pzBN4gcAukwqr
	oTIzr3IZFLuny0cJu1g7WBbd+9goiey21OfabuRRwWQcG1WTVkwmz2uy6gbOIX3CCJGs8bk6Q+S
	A/BR5T4UPdVpAzOsai//prt023tt/Sik0TBrYZTDSjIVeuFC+sR9guky71Wyb0oJPTUQEfuHiUf
	u4+NW0aLUCzH+s+TAjTfZj4A8ri2asprnb3e5yOLaHzLMZtlsL/ptOUDxXYzFI7fdlIllP3+X
X-Received: by 2002:a05:6a00:2e8f:b0:848:4190:ae72 with SMTP id d2e1a72fcca58-84e2bb54b03mr1442304b3a.46.1784771742137;
        Wed, 22 Jul 2026 18:55:42 -0700 (PDT)
X-Received: by 2002:a05:6a00:2e8f:b0:848:4190:ae72 with SMTP id d2e1a72fcca58-84e2bb54b03mr1442276b3a.46.1784771741671;
        Wed, 22 Jul 2026 18:55:41 -0700 (PDT)
Received: from [10.133.33.45] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17604a46sm2154683b3a.60.2026.07.22.18.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 18:55:41 -0700 (PDT)
Message-ID: <8f82a267-aace-4007-8fc1-c31d9065d059@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 09:55:38 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260723013818.393470-1-zhaojinming@uniontech.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723013818.393470-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDAxNiBTYWx0ZWRfX1TjtoAPQ9Mus
 hdCk0uNvGUqabvGhMIrbuTD9d63DYmVoSGNwn+drEO342zN4sHroGDeMyAyktasMUQl1D3qIc9V
 JWgmDxQhAYTNv4iRLLtGb8KewlmDhMb+W5pwZoryJYeQsL8vHG/VYDR8Lc87fXY+f0GMPkSp/Rp
 1+yVo/oY2nAZ3cVi6lu173h0vYzX0gGDaaX1ZaikjImSavlACzhuYe2SAHtmFegcUNbLNgAQxMV
 5N/eplEuFcuXAyIeeV2CX1yhuNBL0K3A+msF0jPEW8i6QEwlX0JCJJgaqGx0FUNWVdCf//Wb9My
 TZEhPwq1yCM1tIzCVZ5v76bIeTJeUggat83rU94rUWcpH44lW1pe91LbRJ4E7dwzyzHob1ekN38
 63i9nC5N8x8vdKUqHixica7UPyLYIxWoI4eeDeCFmLYQZMCU51FQX6i58V9tp6aL+E2MR3KRl87
 9LVBg8oLDZDb/XS6/VQ==
X-Proofpoint-GUID: 6FGg11WouBEyu8Xe_IdwkpPyub0mYjav
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDAxNiBTYWx0ZWRfX2oviuhz8VDpT
 VDmSTsWey/mYYkm1H+6wQ/ZculvkCUcH/So85OOJXnM8GOiQANKIWvPO+csOO++rsXStat9Dkol
 iTyVI2y34LUemHbJLvOHu4mbySZ13Ro=
X-Authority-Analysis: v=2.4 cv=btx8wkai c=1 sm=1 tr=0 ts=6a61749e cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=iHwBjlyiAAAA:8 a=EUspDBNiAAAA:8 a=MOnjC4vlygQvvV3irVYA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-ORIG-GUID: 6FGg11WouBEyu8Xe_IdwkpPyub0mYjav
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230016



On 7/23/2026 9:38 AM, ZhaoJinming wrote:
> In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
> returns the error immediately without freeing the CE IRQs that were
> successfully registered in previous loop iterations. The probe error
> path does not call ath11k_ahb_free_irq() either, so the previously
> registered CE IRQ handlers remain attached to the interrupt lines and
> are never released.
> 
> In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
> the error is only logged and the loop continues. The function then
> returns 0 indicating success, leaving the device in a partially
> configured state where some external IRQs are not registered. This
> causes enable_irq()/disable_irq()/free_irq() to be called on
> unregistered IRQs during runtime and remove/shutdown, triggering
> WARN_ON(!desc->action), and missing interrupt handlers lead to data
> loss.
> 
> Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
> function returns -ENOMEM without freeing the ext IRQs and napi_ndev
> that were successfully set up for earlier groups.
> 
> Fix all three issues: propagate the error up to the caller and unwind
> all successfully registered IRQs and allocated resources on failure.
> 
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>


I have given my Reviewed-by: tag in the v4 review. Since v5 is identical to v4 you should
pick it.

once again:
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

