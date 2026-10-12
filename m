Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E3E396D03
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791782998; cv=none; b=G7F+Xi7bz51hqRMwhdiY7J0oat3806ErURlZVHralVBYgJOuNEJ+x1LBBmqlmn+GbosfFoVkyritfXWT7y+LaWgV/vZGTOzZ2Cupxd5nFTF7fcD19basw4Ok6qwWq28y33GjFPUNmdAoXhCrctalgbhixzJwGzfIliM9w0O2Ghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791782998; c=relaxed/simple;
	bh=f59aOPOcbraWpl2EgIj8/jIf9DjGC5XVFOte3tulvao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LcKNybLP0T2zjtv7trGwpKoAgP/TqXbLWvxceqqFPKmmIkTY8WVm+0W/XAaHoXR8Zw+T4VcuUxE39Ue8MlskmIES/wxwrPakoF5Wu3DoAp23MVWBfFpNFN2ykuv9vtD9Ya6zylkNmZfFIJiz43U5kt4eZYt5aRZlkQzwT5E3zcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H1vQINFX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=glwNEaQC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H1vQINFX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="glwNEaQC"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C55qVF1155377
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zSZjEhlxbRcj3QUVbZ7iwR9kQWOUQNpT+xsX/Nm3vFA=; b=H1vQINFX3P8+fun8
	9jdru3hI4pQYT27qYUBkB4m9EFQo+eDE2tlE9b+S8MiorSDWSh9pBWcQDIjdZkyc
	IhWKKXMHB6mZMZLYeM5hpwL2KmMgiV/tH1X3XwOPlUl0eAWqIOrjCK0Ix8Zg7AbC
	EWpWzdsSXusMv+Aossir0oIDj+ckbv4dTMmFj9IHoAjv8fk2RpBhG00Aypms7/Nf
	4FFG1C9jz0RqzUKR+zPGhNRjEhh3Oc11d5Ehg/AyT9p1VFPaht621tj/Djf4KZJt
	xI5RCdm4fyTZiInQiAITkXQnPUHJtbQwu6h3Dk97FiqTL2PxV8j2v8PsgI5JPBeb
	0ItC+g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7aqmw9cd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 05:29:55 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e617b5e9b3so9769685ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791782995; x=1792387795; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zSZjEhlxbRcj3QUVbZ7iwR9kQWOUQNpT+xsX/Nm3vFA=;
        b=glwNEaQCMa2pHrNo+7ldbzN7bDSF5lGsnBjgWwDnx6h4TVfcsi/qp6TaZeltz7xFYj
         9UNO07P9Z2XmT4wGqimFGKoP9wFO1BMr3rgNXgw8jbBfXaB/FgikiyXw4grJgqUvuPv1
         v/oLZRTSdSqKVHOz9js3EU8GQX9TQCFPAf1R8kxQRnMwniCk3xEsG5GHZOAK11vplZ7f
         12K6/JyuazOgYL10rAim9JtaTB41h7TZpf+CUz+nI9zbksFr3cWOkQSJXPY5NLqZOWQE
         uidjITF+76gM3EN7L1Mv+R+z6kupZnXdQ78VJlCNVzbh4tBQ5MsQQz9pif0Yxhsox4xy
         Snzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791782995; x=1792387795;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zSZjEhlxbRcj3QUVbZ7iwR9kQWOUQNpT+xsX/Nm3vFA=;
        b=c1IBpkz9bx80i7qqI2TYIeaW/b27Q37X3XMBrELwiLyW8eCWuV5Ba+G7Yv/ClubXx/
         s7fJjqVjOukSJ47x6upP5eZGVpnCoTpMoyBK/AZmDj2pmiXQdUv+Z+08L0GQszqRSp/k
         wsgtvfjirUvFV0VRqfS0DsEXNpt317b/boiK7R8qOnYO+TQt5AgDWIBoeA1vLDLEMPmi
         tTVU9JTdLUFrB+g3sLOgW6MuvQZQ2O1qUWsSNev0si0B0enuq0eiwLzyndLJJjKpa7rI
         lj+VvjekqguIZk3wWjbCXi3IsJLyKZvnv99knDpUpgP2hVAtN17/NEOV0932fFPfjmwF
         CcZg==
X-Forwarded-Encrypted: i=1; AKwUvBxZ6bJS5los/7qu8cjHU56Xsu8tdnqDWPCIzj6l9lALki/8oBHPcpHMzbqtgL51BbMCikVasZ8/ppA5H4u+0w==@vger.kernel.org
X-Gm-Message-State: AFq9FYIoWlRRv9i1Ucgf4uTQYS9vuYKRctNsfi7eMKWFtA/7o1/h12Vq
	2TmdvVutwregYwzksqbgt2cuV6mF6cr+8btZg+BEeYZISeVBN749ZPsA+YOsD/Tx49369BCq/aA
	bHScgVfYAoGVF4yn7oVPBkfOzuTITN1QIrcBMR2R7MQfUkOBBQIGVx2FJp2Xa3gbly50QSg==
X-Gm-Gg: AYBFou27mtjjkMYMNByD4cTd6L3NrTEsg8vCHNibCE43yY1Zd/gQrSjOYFrI8QhfdBy
	/6Rc/ERy4TIT+SbqqHs3evUMsrMO9gaepQAoyA+GliWIE61EDpV3f1vdvbgYeEnvvZqGpvYR5GI
	bjGd4RsGCeZJ/uPIiKhWVC5ywTetX7I/UMj0ZHKJ7DgfuEyaiwVgOnkoRLDDs7Ipc5z3QzQs3fX
	FKPsgSMzKb9mEIuPHUC9+X7Ora2uKrGOin4K0uyfPWVY713Iy4nl1e7cMrfQXa1GDIm3iDoNGMu
	yT/xck/mybLH5WiiObZ4LlZfr0dEWXH8RNCUPpwJgDTOvo+Bz4/q7fT8zwdfuHyCubFzMwjbxNW
	VXJkLXatE9CgIntvzx81cLu6lOMWle7PJNQ==
X-Received: by 2002:a17:903:2309:b0:2df:3b0c:a6a5 with SMTP id d9443c01a7336-2e8427f7723mr67059925ad.9.1791782994681;
        Sun, 11 Oct 2026 22:29:54 -0700 (PDT)
X-Received: by 2002:a17:903:2309:b0:2df:3b0c:a6a5 with SMTP id d9443c01a7336-2e8427f7723mr67059825ad.9.1791782994200;
        Sun, 11 Oct 2026 22:29:54 -0700 (PDT)
Received: from [10.152.193.243] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e171bsm38699445ad.73.2026.10.11.22.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 22:29:53 -0700 (PDT)
Message-ID: <fb81a042-82b5-4565-9a5c-1a3c038a0d14@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 10:59:48 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 01/17] dt-bindings: net: wireless: Add QCN6432
 device tree binding documentation
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
 <20261008-mpp_bringup-v1-1-2c5797b5e4ac@oss.qualcomm.com>
 <20261009-brainy-alpaca-of-focus-31fbbd@quoll>
Content-Language: en-US
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
In-Reply-To: <20261009-brainy-alpaca-of-focus-31fbbd@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAyMSBTYWx0ZWRfX/rrLf3C3QG/X
 UspaML5FtI3sgeS+TsiiX41JdSfI05F4Am1ZanUmix6T6ogSViLJuPmJWtQlTY1wJs1M704Ity7
 WO9MVtn+G6zf/5JOSuzT+xks9fYAP+M=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAyMSBTYWx0ZWRfX/U9HaRS5hDm0
 MPwWpEmrF2KGC+x9eUV9Z4fSy2xB19Nqu3IzQBfcjxkMUjpV8v2HjZhkfF41Mhu7hEPVw197+Iw
 LVxiJlPNwHPCYOClXlQiQ4Ub36e/DXIMeKqY3959NC3XrTDJesRIFb3e0DWHMSM7JL+AgmbMx09
 P8qV+NKIgy1wpa/qVs/BnybpbvLbiiGdEieV4IL/Byj3gB/V0pLA/LBK/nMB8j7nLGVLj81wWMm
 MIaKWsnNSZzF/qtiXZ5re2yFjTCUmKa0PAqD88XV6EYohypMoWN3j8uptleTTSXq3yIcdoyMdn6
 w6nbZYpG+cPdQwMJFeVWadLD7k5o/Pi3Um5Uhk1A1mPtvhqiJ805wHATg6VqXjuYhq+gzygmoAG
 9hmKz40hhA9/QV8czhlUIsKGbUs3Qa2EisxpGPskEBZIzOIIX08WOtMgY19uiFDQdCQKAhgkoqa
 uJTJ5a1rQDHp9D3COvg==
X-Authority-Analysis: v=2.4 cv=Uq32pOwB c=1 sm=1 tr=0 ts=6acc7053 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=gEfo2CItAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=WLwc7mworHJoPNN1NUUA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-ORIG-GUID: 7gP34Ha11ygYq_3WUEgSJFGl-oU7NSiq
X-Proofpoint-GUID: 7gP34Ha11ygYq_3WUEgSJFGl-oU7NSiq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_02,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120021



On 10/9/2026 4:00 PM, Krzysztof Kozlowski wrote:
> On Thu, Oct 08, 2026 at 03:53:57PM +0530, Aaradhana Sahu wrote:
>> Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
>> wireless device.
>>
>> QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
>> platform device, even though the Wi-Fi hardware interfaces over PCIe.
>> Document the compatible string and the resources, including the Q6 remote
>> processor phandle, MSI interrupts, SMEM states and memory regions.
>>
>> Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
>> ---
>>  .../bindings/net/wireless/qcom,qcn6432-wifi.yaml   | 149 +++++++++++++++++++++
>>  1 file changed, 149 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml
>> new file mode 100644
>> index 000000000000..97d8885333fa
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml
>> @@ -0,0 +1,149 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/wireless/qcom,qcn6432-wifi.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm Technologies QCN6432 wireless device
>> +
>> +maintainers:
>> +  - Jeff Johnson <jjohnson@kernel.org>
>> +
>> +description: |
> 
> Do not need '|' unless you need to preserve formatting.
> 

Thanks for the review. I'll remove the unnecessary | from the description.

>> +  Qualcomm Technologies QCN6432 is an IEEE 802.11be Wi-Fi device
>> +  associated with the WCSS Q6 subsystem. The device is represented
>> +  as a platform device and uses MSI interrupts for its Copy Engine
>> +  (CE) and Data Path (DP) rings.
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - qcom,qcn6432-wifi
> 
> Is there qcn6432-something-else as well? Neither commit msg nor
> description explain that.
> 
> Best regards,
> Krzysztof
> 

QCN6432 is a Wi-Fi device supported by the ath12k driver, and there are no
other variants requiring a separate compatible string.
Hence, qcom,qcn6432-wifi is used to identify this device.

