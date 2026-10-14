Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC5D4E9C31
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986716; cv=none; b=qtA40iRFaNbxJ+tYVgTwLLO2DeNtNJniKue3UXGoreg8MDIDWE25F1QWiloJ1NL9PPKi0F6KWhZCI50TjnvifP8YIOzYR8kuLiOqVJY998HTE2dc3vkmz+DTebf0vlee6pW6EkPbv7waGxO3q4xBFBYWluEbsXtawAgueiTcumk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986716; c=relaxed/simple;
	bh=on2PEhB3zQq1g4jTu3KddnrV7cQSAaGoMUS/teguhck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Weytcy4wevuDyDXQxRTO/Ztvl2txWDBD6oIqv7lIfPYZM4jKXiMKr7rTS9OpZ10dWo8+uivZbxCQbNGg7evLk7CapAxBEGJqO83gT9MogR2ozK8GqfvCV8Z83giLrtbpTLJQYPWNYB3/G6BdorHyuhlOK2PdSmDo61thm2Vt3KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H4YyJgJC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gqm+93QL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H4YyJgJC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gqm+93QL"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EDHphj328824
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DXB1+owYQBBqW88XzzY6K4eceuh+GlN0C86aFl0rv78=; b=H4YyJgJCbnABl9nz
	FmZ7sqPp+0OU5N0uI4WwVsQ6BxuZtcWiYZwgKoCwW9E/5flb+LG/sKBPnUMaNxGb
	7MiUv6vxm7rrJbssZja31V8RfPFlrQZnt4pmlMul6VixjbYUpA0WzmfXSmxssXsH
	GexKlSPHb4hhG/zIxIejefUy3VlURerLDXzfPEfZFE6w+E8ycwFaDDvZSLAq7tVz
	Ph5zbELPlNS8yM7v3qB2/zxDXe08DKhDLq2hCDYVlbcyt4Cx01KAMKto9sft7DEG
	ZNjw1b90zrQdHjUPewyxunuqZJHwgsqSU4Q9iiHBK/BDfDVeL7xKFNUXBM0H/+jz
	QAPAzA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haagf066y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:05:09 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93ea8a9cfe6so64603285a.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791986709; x=1792591509; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DXB1+owYQBBqW88XzzY6K4eceuh+GlN0C86aFl0rv78=;
        b=Gqm+93QLsvhXkJGzpMiguhMUoOOWRp47JkJb/vPHAmMuqVmorC5sjrbFdCBfaRWp3i
         5yh6XyFHB01QIV/05mexdANyKCBPLA3hyh7kF2udnQP9kH7v94z6GEamTe+RuzwNrY59
         e7MRyGo9tjbVFHTp+LloYaLEvQAFqFbN8wvMbgUxV5I+gj8KoqFhNOZOpcS7pGKl351A
         MfroU84up89C1p8xQ13PbqfD6m5h1mSgva89+GPg+CicaxXavVZJoxQEAaR87Mq1V7B3
         QXmo6aACGyekZVhW/EBQ+2QCp/ur3XzpfVn37YrnMedZRgj6DlKE2I6m9Fa6GewkYw1Q
         5I9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791986709; x=1792591509;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DXB1+owYQBBqW88XzzY6K4eceuh+GlN0C86aFl0rv78=;
        b=wj/0JrjC5PORV/SapGAes9SCgiBFX81zmYcaX5GrE/4dzhoOa687OO39fj0qE1xSp7
         OYt6COD6utsJwqu9YlCE0w1bYOZpMnOXVgmCuOnioBEB8btwgQyhpmnjqLluzwkF72wX
         U9RXPltfPp1NsHACnM6TcEb8NHIcgRW8ke1USY1nPoIyXY9UkZn3GskVnTDfIzeZ9ez4
         pp3z9viSH34AaGc60nJ6g2oRxaY65oJclpxNRf3rjuayKWJ9A8rbDlswWMDchnYyilUe
         Pb/QfRfm2MT41t5Wrc2n3fdrUcax8BkxGuzg3ZZGBgztpOj0GCKWAlM90BGaupeaaEB9
         UGIQ==
X-Forwarded-Encrypted: i=1; AKwUvBwmRDZuR3Nt91trScMGb0cwhu7J0+8OiOOvrd8tzDBqX1DSiWVe8Nnm92S5G4oO9ZrDhB23gKrSnwKm2lNEDg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK9cGpjmt6qwKlyhBsVLdWg7ERRybpZW937HRAhVzHO5xYHeBfy
	A5aNx/DNK2NjmcPOZbVv7zf1pTNJVpwetshILetsJEaVhOaaDRBL23HjjL7HErUnyJCn742JVXA
	B9B8qsvGU1yK0Pu2+i+aGAuHIGp7waVQRR6Y0NhiPkxwbVLcgCetT6Io68AL+K+sdIQcwvA==
X-Gm-Gg: AYBFou0ZM6IxlltVOYIFLE5UFnONrXBNeEfUA8ksRH2XPvfddMGadW7GVkdtpf3mxeU
	nXqPv3SmrCbwTt6iEaz94VO+aILm1dtVAN1xhOTtYvwYqBu17E+dabiZfEVldP/nv3gWLGkup9V
	yFFOwG7rJgieEKrpCeOBAqhG+DtBo3TTtvDgc8KBeQwj3hFJsYsqd60kxGbUkSo52F855RoJ5JV
	pD2wZfhYl3xQSAsNhk02wAaCH3gNF2EWUEMOMf5krzF2fPZl530lOg02TXdJOl7BWADjSqm58PQ
	AKRrLhe5cOgk3WxC5jS+Bhb2xnSXolOFdAE6dfmHVLJ2voEIxUY+moSOLuNRlS/bXezoaqEeTr6
	E79/R32fmbAShpzCu2WpwCw==
X-Received: by 2002:a05:620a:6498:b0:93e:e111:2771 with SMTP id af79cd13be357-93ee1112d0cmr1775884985a.2.1791986708878;
        Wed, 14 Oct 2026 07:05:08 -0700 (PDT)
X-Received: by 2002:a05:620a:6498:b0:93e:e111:2771 with SMTP id af79cd13be357-93ee1112d0cmr1775875785a.2.1791986708169;
        Wed, 14 Oct 2026 07:05:08 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9c6805985sm38426281fa.2.2026.10.14.07.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 07:05:07 -0700 (PDT)
Message-ID: <11f513bf-fdc1-419d-8eb6-5cabb6220fbb@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 16:05:03 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/5] arm64: dts: qcom: glymur-crd: Source MAC
 addresses from a UEFI variable
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
 <20261014-b4-nvmem-efivar-v1-5-187c85f65018@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-5-187c85f65018@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1NiBTYWx0ZWRfX0uCTaX8SOwxt
 XW5Pcj50hr7leyP6hseDMkmjIA0weap0OOitHAg4eWVtH2mwr7sBRi8vrDy6IEKywQA0gasuREJ
 5OlvSkyRRvADalpFG8svzL7tNATimpxGbIiQHhQGSghFIyxF+CIESGdYZQ8cE5TDXR3Sn7rhXLb
 z817d2TvrZhAJIyUjHNxdGTJyFCoY2/wf2E2UUHjfUwsh3XBYWDCy9nqSL0MZMjfaUeSG4UnY5w
 Lnpz/SfA+VIq0FalsU7j2rhSB8NoMqcWkmYmMBqV07JJthXIX0chAnCB7Fmqd9oqHRuV5FEuyP6
 BXgfXU8GHMISgsDJFRN2vHtCKRD3GLruzEPOMZ9Lf50xo+R9kcGAiE0iPq0H5K6G5IEE+XsapTc
 R+c45fX1UoRowueb1XJJEIjDbKMgydRtir8uHMsOJMzlxCa582xc+yHrT39Tq26GcRAbXF9FaGj
 pt429fAFe9qthGCkbfA==
X-Proofpoint-GUID: 9KMH30lrK6NIME_0O-VrrzUtl5WiocCq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1NiBTYWx0ZWRfX6fnRq011U2vx
 yFDNpqWxAAsdAFF/lYu1IUziP61E6y6VhmYYl1V8bs21s6dC4R9UXlY/tu8MW3gU35f7CBTZye4
 K5k1HohENAVIzvnL/aQsdyHtSVDTYyc=
X-Proofpoint-ORIG-GUID: 9KMH30lrK6NIME_0O-VrrzUtl5WiocCq
X-Authority-Analysis: v=2.4 cv=V/noQuni c=1 sm=1 tr=0 ts=6acf8c15 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=jRqq2JA-ig1rCJpZVWcA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=1011 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140056

On 10/14/26 3:02 PM, Abel Vesa wrote:
> Add an nvmem-efivar provider exposing the "MacAddresses" UEFI variable,
> carrying the Bluetooth BD_ADDR (bytes 0-5) and the WLAN MAC address
> (bytes 6-11), both MSB first. The variable is looked up by name, so no
> vendor GUID needs to be hardcoded.
> 
> Wire the bd-address cell to the Bluetooth controller and the mac-address
> cell to the WLAN endpoint (pci17cb,1107) via the standard nvmem-cells
> binding. Until the variable is provisioned the cells read as zeroes and
> the controllers keep using their default addresses.
> 
> Assisted-by: LLM
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
> index 58158b51fe29..2dd09ab1d550 100644
> --- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
> +++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
> @@ -31,6 +31,22 @@ chosen {
>  		stdout-path = "serial0:115200n8";
>  	};
>  
> +	/* BD_ADDR and WLAN MAC from the "MacAddresses" UEFI variable. */

Let's drop this comment and sort the node

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
