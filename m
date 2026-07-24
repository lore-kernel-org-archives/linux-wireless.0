Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45004267B07
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784883502; cv=none; b=gxGs2OOCnPlobkIpmxNKlx2M6yw1TP7aDkwZZO86r0FaepQuCLO0xsOcYF95a8SOOtd36I59uBuSN2kS1jxOTGCtkN2l+2G+AWwUtZ3Pa7WSlb4diU6BkMs6Chu7JRye1E3Kyjlpks7lpAWxEpMnhOnh+fNQoERjAW463nQmdkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784883502; c=relaxed/simple;
	bh=Xel7gz10TSqlNh+4Jbx2bPNVgo4xT1B5fVaUumuD0bU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJh6rIm6/ujk2RgptiK0b/sulFz4T1wqwaR/oTF3mhxEwCOVRLX+liSDzK7onuSZB78OR9LaEJMYXQavQiC25Hkjm1qGHotJVB5oRRrPDfu95+4eCG9z/cwfxffS0niSzvu1bRtzyzA6F8/yZ8iyEe+qSqtCzXgCYM7JBDKikRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TxQbhnMp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KLMMoDXK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TxQbhnMp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KLMMoDXK"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4l8l53139416
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:58:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bGyLS84ejhioARWgv/P3/vaYmUketyVVUtz32vhbnB8=; b=TxQbhnMpUqsVpjRG
	mFvUcf6XaYBElmCrd/oDLhOCcs/PW9oRJS44lOPTQLpXPSl+2PWldttIGYyUV7Xp
	3emNnbLc27/VZPLMG7Ls6PXbDF5Eoi57/fSCWVWY22hIe+Atyq5sxknussYDtBWJ
	ZeOxCr7Bn4xlDDwS7zqcTV0iQHltBGZBOMwS5oSWx7M0Kfp3fRq6UmJkVjWuO/Eu
	sMBA4/j/8VBiz7bq6OfCS67HboOQLo0QBpDOQNmdqBBqzsfmFLU2Zfno+MziIHLj
	lH+36YXi9QF4E/yPCW9/1Y+9SymmeXpHVVYdVbLkfx2IfdFZl1d58bqzwqq8VEQR
	u2UeVA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkn9a3peb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:58:20 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccb6f6a3f4so3791805ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 01:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784883500; x=1785488300; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bGyLS84ejhioARWgv/P3/vaYmUketyVVUtz32vhbnB8=;
        b=KLMMoDXKQTGXSvH12pdeGEAzsivzsSQpv1Y/Qyve1cj/p3p7Pf6G0KwTCwI0+3Br8W
         qKSljV7h+NGhyVPBddffTkHKoxTf0jI7/RSGZIMv0cQmO6NZYdAypPSj3mJkV1fSfM2q
         J//uLyPdHxu9vnnclytEFKUS7AthEGt7Mkb4/XPGGaVWUwHFejXOXuvf85wvO3Oz1Fgi
         NO2U6HqdkRhid0swJJuiC8gFF+Yn6vMCJIS0P1V8+eqlvu1dB/A1MoqYWlZ4KGPaue5V
         85jiMoxNYd8zh+vRoO+VNJ0Ft67buEOATcsamAzTN6GjCgy33E69FFVI7sgvo4DYFsax
         nmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784883500; x=1785488300;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bGyLS84ejhioARWgv/P3/vaYmUketyVVUtz32vhbnB8=;
        b=CqIecP+3wvBwszz8GkSEqhKtbh7GuKVybf6CB3W45JGuY10MaprnEPgwufQNUaeSfR
         P50hG2r+NTvEFtfo+1TfL4MlYPDLy7uNWctLhtwxp+bUYJZ8Aigft+D211k2oC6UZUBE
         YeUlyw82MU07FOn3jMqyfrP1MGscrrduOL9fW7PTdefvaYWNvqasYO8S2zjwRDrf0EE9
         f27yWhy7EO1OaOKKlO5QDXPnVS6CZ8zOGE1CbVAUbfbbTa5zmuZQxQS27Fml7uS7iuHs
         mf1cxWuxPFpZ7UZ3y3jgLrljhr8Vmv2I9+fdbXG8jJwYuMPx5EtncSRn/3nq8/cwYk8C
         b6Pg==
X-Gm-Message-State: AOJu0YyGcFXl889L5DintuenqdrdM5GpHaWDDyuzzTU+JsO7qVazjKKp
	OhGSrz32GtHdcFEZRQ4+27sv1alD9CZ5PIsitCxvipJCsXTQEUhT6IlCfI05SS2shbzBE+RR4Wp
	Rulm4oeKDjgnMIjRAy5A5T9VgGf7QjVLA+bof24wejiyARIIrFq+rCrWJl6QYa+KGzcC7aA==
X-Gm-Gg: AR+sD12BSzvSkPxSHfExwmY/Xm0//BDYaJLPnvfaSU77vsakt2rS/OavpMpGGzOSxT3
	jrJUf6RmwiqMUiUo2XVLh4eI9/uWssCn8avVBmsHp42EJTDKYXzZEYSsC5SQzH0iANE/GJnBj1w
	E/ZMeMl5Dw9OitD/k8QmT+DIyTh1XuTGDjIep7RIGe6a4u+XpMtNG+tHeJVnfnKwP6p/m34shPZ
	izhqi6I58EUFc098kp8w8ddB6EkIKU8icSqiBhognipo0ROZPB2I10H0Fsf+g2qB6VvG0vbTY8v
	Hujf+8e3pr7VsuLUsk3VapacLB1/5TZDFQOJU9+sPohzACPBeIP5zp7Ffoo1jGZ1QAtTWfPmDi+
	WCUN7g50me3X0QhT2/5NnmMrykJFpkNrMovJiOZ4C
X-Received: by 2002:a17:903:2306:b0:2c9:994c:9a5 with SMTP id d9443c01a7336-2cfa9588d7emr72917175ad.30.1784883499733;
        Fri, 24 Jul 2026 01:58:19 -0700 (PDT)
X-Received: by 2002:a17:903:2306:b0:2c9:994c:9a5 with SMTP id d9443c01a7336-2cfa9588d7emr72916955ad.30.1784883499326;
        Fri, 24 Jul 2026 01:58:19 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df09ac0sm25150652eec.16.2026.07.24.01.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 01:58:18 -0700 (PDT)
Message-ID: <a995ba1a-1b16-4a83-af2d-51ee25adf6ff@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 14:28:14 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: skip MLO multicast links during
 crash recovery in Tx path
To: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
        ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723054653.2794550-1-pavankumar.nandeshwar@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA4MSBTYWx0ZWRfXwecwTSZfBCxe
 SR7mbVy9lXpitU9lBNwn8iNQ4nbA5SVInjxiFKA2383agTg0E7sAUL2SMEbSOudO50cAfZE8NLT
 yM8k+m8xl3EWiSpEFjBzbcRCo6U/sofEFQlytN+i/wsqP1qu3WjoOstFfZ4Jd0mrZV9t8u76zkW
 EQ4ou0O4DvpTFqIwlQSJVnAt1Vdbdi/yNJJrUebaDAKXZg8gwDXbLv74Nyq5ox/mqttfKGnNdvw
 XrG3b+t3gFsBcF5XhTcSUXvvVN+U6hyIcisFYMpTstHA83MmYg5sSirJYOXwEqMeBDsjysOyv9e
 d7L0BZhv9jIr+rsZTFsBv91MMkNElsVtn6WoQVhkkiTGhmxZ6FBhPLgKso8go/MfPY3bn5Fu5Xq
 CtygIl+0RKvQTJyrYCtJJ0haYogZPksmB2HVlJKsKP5MtyFRzjPbP+DFHj/UW3K/HZblDmrxFDA
 R9zI/XbtX6LQJRZghoA==
X-Proofpoint-ORIG-GUID: QPNiKxFwIkdgysVIMk4m1Ry46Bzt3IZu
X-Proofpoint-GUID: QPNiKxFwIkdgysVIMk4m1Ry46Bzt3IZu
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a63292c cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=_N75d0clQG27oq7jPmMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA4MSBTYWx0ZWRfX4yTYcjqxmRYP
 f+HMWlXZLmTkiVijdEHN5e6sKNzNX6gq3zLcqVR+pVnjfUqaNJxK+5hIX2lr6fg7EuKKpxmANU5
 UfInt9Oie+QGmyfHYC3jqseWUROtUyk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240081

On 7/23/2026 11:16 AM, Pavankumar Nandeshwar wrote:
> In ath12k_wifi7_mac_op_tx(), the MLO multicast broadcast path iterates
> over all active links and copies the original skb for transmission on
> each link. When firmware crash recovery is underway (ATH12K_FLAG_CRASH_FLUSH
> set), the per-link copy is allocated and partially processed before
> ath12k_wifi7_dp_tx() eventually rejects it with -ESHUTDOWN.
> 
> This wastes GFP_ATOMIC memory and produces spurious "failed to transmit
> frame" warnings for every active MLO link during the recovery window.
> The unicast and non-MLO paths are unaffected: they call ath12k_wifi7_dp_tx()
> directly, which already guards against the flag at its entry.
> 
> Skip any link whose associated ath12k_base has ATH12K_FLAG_CRASH_FLUSH set
> before performing the skb_copy(), matching the behaviour of
> ath12k_wifi7_dp_tx() but avoiding the unnecessary allocation entirely.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> 
> Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
