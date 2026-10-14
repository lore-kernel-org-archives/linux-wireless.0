Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F45152FE4C
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986748; cv=none; b=DxDSwnvxu3tpMM9B7jyguSscLl4HT+Mv4+HG6giuqwqld+wQMifJ/T5yvIrYtbIlD0Ldedfon5fFr/W+YmYAlGaa/qaE+4fBwEWx9NyuwlLsykGWS+rwSTA8e73KJV4pv71sLa2NKNvz7o5qIvTcFoHUcCfZ7PEhxYKKxAiKaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986748; c=relaxed/simple;
	bh=ISgqwQwd1WJVQMG+3HZ82LwF02NXekQ8kwdnDHTu7qU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nLH4Noc7oD4RPOn7Ku1LXuaZ+x30HHJol2MknZWE848gO9jmHUpPd0sRGAZCcgccNjBHkPOaVICdEZ7i7hzjkhWFbofWeP0GT4Ib6vwoREtaQg6We2ufElGVIO/+ob/F6F911WHoqVEo/LgifmBQ42U4zzQHyDXx+yN/eodrqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nCe1EvZP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CAP23AZm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nCe1EvZP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CAP23AZm"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EAR4Z4466270
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pVpqOXgKn0VsPxuA6dqYU8O/g3ed5Mas2OnmRjlWtHM=; b=nCe1EvZP/0aHf93I
	BdHU2vT98aD5USlH/P+wqwb22JSku1+uqNnuW6l3q9f2qtOUMjuDDyhS/AKwQ9f/
	YZsVsxjWmMn76m0UhAtPtVVw2OnpgqJrj86RhZrv3D1SsYGwuvAbIDXGTTIjU9aS
	6hIIK36//VRJj3FSeXCdrzcZgAjxwDYT4pQrKcalEL9FlbJYj3+WuAots4Hqm7PI
	m2KpLgQ81UN21xtv0MJ6aRUs4pP5ExZS5S/81C9CgovP1HKAtUzm4iqtzku+GXDc
	GyGD9QLmffNJ4wX82sO2ms12M2t34WgmqIhOLjMtPm5QGX2Rnjt3ImmytdLfFg4F
	ZV+MAw==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha80crts1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:05:46 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5de7ad7cdbfso142098e0c.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791986746; x=1792591546; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVpqOXgKn0VsPxuA6dqYU8O/g3ed5Mas2OnmRjlWtHM=;
        b=CAP23AZm6InYSAFctw1sAFQYMkTE5yhHl6TMDealABrq0zCBhm7miZAGZPuIXmUPqV
         alnCMPysvu2NICh2sUzYoAiUXyzPTvJW7B+6G0vIAdcnSHjDZ0wK3I1sqlcuxne3qe/9
         Ro7zi7yTdShVqPYRK6hAw/CpVi82n25Vb06WMS0OYYlRfHMrtVP1oPi7bJi7YKO+BYmF
         knY9lhNz0Z13ncLe3ADbIRnf32rV5zFdGn0PSmOazRmkNuQFOrpreOnyroxrEeFAD2l3
         H0TjuRF+uqGvBQ/an2lECqH1g7lBkALuEWwNpEmNemrahAPKOQ4vq3TtynRVevzuCyT+
         w4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791986746; x=1792591546;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pVpqOXgKn0VsPxuA6dqYU8O/g3ed5Mas2OnmRjlWtHM=;
        b=cZqtFuO1ketHy16JTkxiPbMSl4LA+AyQleG+SGbzGLibRJtdW8/jRjAwOJ1E8mGC7l
         sG7EcFLlawOAMBxTXgB0WNDrf8LmXU66NR9SO1DcKjN9Yp1zOFebC95Db/eU3gcfpV3i
         YruHxsQAsQsLmm3cAcagzBw/Uap+WfizH2qEXKiW/xD1/3tjk1OBlMZpEazLJcTcNa5f
         BfpEBaqAmTeeGwiPRtkdC0gCN94uDkZIThmooOhcRWTMD3amfU4bXyGOqypAYWzbNA55
         pEvetWw0/RQ7JjzFA83j+AIxMgkw5tTxprSi+HlhhMmExfXZzt28KQiQFVsZk2Sl3gN2
         FIkQ==
X-Forwarded-Encrypted: i=1; AKwUvBzDUaQYSzXUcAgz8/UxEnCoqT5+R8KUElOdaL/2ewQbUB36TUU3pgrNirtvkP1Za5H7eRPC8ZOMWy//wd+zLA==@vger.kernel.org
X-Gm-Message-State: AFq9FYK5+Y4na6ZZKAVlP9LTzfthWohnkanbtc4VRtN46xr3d7tG7Y1C
	8rf/61PHmJY6MOoSWtwRVyiGFiXDhcbkqaypqafTpw94z7mYmGaSepXs2bDo+AFvsoTTEMNXRTX
	mIa59NlAOeyw+D3ArpmJD1WjVIZeW++q+J5ec/W+yMdvkPShvoC8yCZvhDBn/YvNV5Il0fQ==
X-Gm-Gg: AYBFou2+fR4r8qZsYUr5g4dYksM3Pvr4pvl7kKQ2vAQ7ivu6wiEupX1WEvk3SmNDaRe
	jpfIvLH14+n2/X9IEjWgSkIEyZrWC4fI5l1iqtn5aRPF3wSMSWlIPF53h68wAMKx6hOJ3G0eZvl
	udqKBiHWC8Ncj5FW3ebQn+AxDoG7U0biFvCu6KX5XnnLyftEQfdGEz5rQF+DNjS5wr2nHA2zhJn
	swK1GMX9uYNAQgLv1ZYeMTGPuJtkhrP+mxcxnceAftaHMWF5i1Iu4b2qKLWsokgm7fqkcRVIOqA
	iObCAvR1dvc3qCMqqxpsWx3RzNZcqkicuPKIxnD1OmtdF01EtnUJsavcgT5c8ro3jEr0y+fy2rQ
	ANP0SkoGG1IvH96ZlpSN3dA==
X-Received: by 2002:a05:6122:4659:20b0:5c9:f6b0:e5e0 with SMTP id 71dfb90a1353d-5e91f45e3edmr3449587e0c.3.1791986744650;
        Wed, 14 Oct 2026 07:05:44 -0700 (PDT)
X-Received: by 2002:a05:6122:4659:20b0:5c9:f6b0:e5e0 with SMTP id 71dfb90a1353d-5e91f45e3edmr3449553e0c.3.1791986744082;
        Wed, 14 Oct 2026 07:05:44 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b203862c4esm1222206a12.16.2026.10.14.07.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 07:05:43 -0700 (PDT)
Message-ID: <d2ab26d1-2feb-4759-bdfa-7db9b923e7a6@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 16:05:41 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] nvmem: Add a UEFI variable backed NVMEM provider
To: Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1NiBTYWx0ZWRfX+iTtEIo4088A
 1Bg3C+HzSFXIN08wF0KsfyW+6efoQyWQaDy74DPG5o12HVt/9Slp/mc/vkCJmnzYlV777IBXrEq
 uBF4u0tclbZqHbh3pEN5UjF9kVeU52A=
X-Proofpoint-GUID: fg8Jzp7sxSf1gD-jyDncRscin5dhawH0
X-Proofpoint-ORIG-GUID: fg8Jzp7sxSf1gD-jyDncRscin5dhawH0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1NiBTYWx0ZWRfX0h5w79tmi6ew
 QFv438XaPU+T1Ma1WZwxOmLvdQ+32KUDcy9MfmZIHNvdUSYNiA0CrTZl+puVhTiv1jsf9XABfZy
 uLh7u4G1412YlS1uMgElwsImTcJNpCcz1rzc96/fyy90JO1WmS0+g0JFc91rQtlXhfrrLcOFJIY
 a/wQzhDzzHFC+HD7u1Nqmf2uZnV30fnF5bcMuiUrsDfRP2MtmLprUAZN3ckeJuGcYYumolTBe6u
 N25tnb4PHv7R6MKJG4Rg6b7h0+S3xv5EnirglAZYoZoma28tVD41R9WNaFlJj5Q8JkvjkMrUu2V
 P7LOb4vvpu7lS86mRTDsmxTiPruJ1ipJhX1CU9J3WXnNk1fOzkSQPQTasiUIyyPCHG5djS3bahz
 JELTsKejvL0FwRCxjqdEdeCIkrLAr7Iub5te4Od8G7wvOLU6jqHmgUbw8RHamRZ+0NhldZnPTfS
 vmXkOUK3pPFXHf7LMMw==
X-Authority-Analysis: v=2.4 cv=JegpPkKV c=1 sm=1 tr=0 ts=6acf8c3a cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=PngBsCrCUa3bum75zpkA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140056

On 10/14/26 3:02 PM, Abel Vesa wrote:
> This is an RFC: I do not expect it to be merged as-is, it is sent to get
> feedback on the approach.
> 
> Some values a platform needs (for example the WLAN and Bluetooth MAC
> addresses on the Qualcomm laptops) are not always available to the kernel
> in a convenient form. They may live in firmware-owned SPI-NOR storage
> (e.g. a DPP partition) for which there is no straightforward, universally
> working way to read them from the non-secure world.
> 
> As an alternative, this series allows such values to be provisioned once
> into a UEFI variable and consumed in the kernel. It adds a generic NVMEM
> provider that exposes the contents of a UEFI variable as an NVMEM device,
> so the data can be consumed through the standard nvmem-cells bindings.
> MAC addresses are just the motivating use case; the provider itself is
> generic.
> 
> The first two patches are the actual proposal:
> 
>   - dt-bindings: nvmem: Add UEFI variable NVMEM provider
>   - nvmem: Add UEFI variable NVMEM provider
> 
> The remaining three patches are included only to illustrate how a
> consumer would use the provider; they are not meant for merging as part
> of this series:
> 
>   - Bluetooth: hci_qca: consume a "bd-address" nvmem cell
>   - wifi: ath12k: consume a "mac-address" cell
>   - arm64: dts: qcom: glymur-crd: wire both to a "MacAddresses" variable

I think we can take advantage of Loic's work here

https://lore.kernel.org/linux-arm-msm/20260507-block-as-nvmem-v2-0-bf17edd5134e@oss.qualcomm.com/

Konrad
