Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0D48167E
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789401163; cv=none; b=Aqqjm65zR+TSnbv7G36MIB47LGdCK3xRVA9xV//GWk3JGopmGENn97V5lJNYjQbrXGWiBTQZI4ly4/DWlfUP1agi4HX15zifPci0HtQpUchC2cdsJq2aQrz16qIGtIKlDg4xyAHRytA6tuSv3VLWhuZPNXtQ8hkbF4/DOAFk7tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789401163; c=relaxed/simple;
	bh=HIk1IpHMIoS0JC9EwLMBzSzfIUXCdtc0LgtWZRJBnoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxzp/LhHvNrnulb/bM8uCofcwA+BFwwVi1rHRwZ84HK3YbdeokFALEPRCMrBL1loQId52hRwDVz+MqwZ6kdpuFamKSpvEhKXlIYuXKZ/wxJ19KpDYlC92oMp7s6c0L+LR6F/V4OOFsJtjonazN/pz9r4/a3cgFyoTPCy/PjxKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JpKZIH2f; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IeDuAOM0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JpKZIH2f";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IeDuAOM0"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED0PA24090516
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 15:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wVlvxm/so69i9rBF3Qqf6pqpvc/+LeTsxiPPuQMtYXE=; b=JpKZIH2f9DAXQmXH
	2iSP1VdlpJ0jceUw4F13wvvmhwgtDHYwagzFi0IhLy8fWf1EZBTsFWgxC2NtF+td
	1WB37/06bpqcAzlBAvfooguEFqC49IGSvPVLEjjDniBT5Wk0wufQgO3pvEHhA6DR
	vzmq7nW95tq33wdbJ61049JaWHRe3zZQo9rYHgZSTB3t9nBRWzVB7ZtP/fofSiWi
	e7XA9fOcoKAvtOLodW3OMJ5HOzHr8EhHdSiHkovtecswNEkJ/z+6GaUfDWFH6tn1
	lLDJrJtF4D74EaNcKXw610/z4fDiD6TCkV8IMdJyApCyirO2+QUisvflLq/wqhrD
	t9dkSg==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpcjg1yv3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 15:52:40 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-97c3796d17dso458364241.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 08:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789401159; x=1790005959; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wVlvxm/so69i9rBF3Qqf6pqpvc/+LeTsxiPPuQMtYXE=;
        b=IeDuAOM00/7TBY4QejIfQlkt0etxjtGz8s5L3Fi60FTG4FIproGpLTetvNnIjObqZO
         Ct0xn+DOPbmP+v5eAUCDrcgUqQHqBReccvFRyQiAs/3OxDU2HcQK3jfA63wRFiTxKSHl
         w9VQFWc8Qi1zYDePCOaTf0ENibovivQVHzURRnl3gfEUG5oZWCYzsebc9Di8Zb4Cxmit
         aqNETCcPyFJCPc0TfmPu/0WnTJWTy/3+Mw79QIfHMeLxB9Z1gmRXULlk/agTOjW2M+mW
         4HOH+sL0R3l/Ehnqjbj6Nw/qB9cKGFIq2fkEKQd7/td0QJMVXfxzukG/AOJsH8e32JNH
         N4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789401159; x=1790005959;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wVlvxm/so69i9rBF3Qqf6pqpvc/+LeTsxiPPuQMtYXE=;
        b=Kc7iRlzb1nzfbL2wAnjQ0WEUe/WW/n6UquRsRl+xaNSA3H3oqmmivfC2erTiap6lcO
         5gxN9o8h+Vg4n1cY5IaELJ2RfWIj7lZD2BhUeS24SneUuIcvieq+m6sOIWaFE0G3+//i
         LLAefAkMfiA/FHB12xfrI20HTJ2kPmZWZzS3yuhmsyxYqPQGr4eKQ4wkQjgwmsKbIW3a
         +XwGo3DR3PhqosTBqyGvLBe0zmJNaQJeyka2QiWykntdfJfey3MJMoojz3Fvgp2lU9eM
         yTwy2m9XyHsSj2UiwyzU7ylexjfedjuzwaR0N66XtiFvwJv+5Zc+Ia+Di9G1UZufOG9/
         YobQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFC9DHn9kMFav9TvFm3nAiRFHpWu3dAiH6HrvU03XNF4ofmy2/cQaXhW6GUp+EJEdW2H3aAQc8IA1vIiOC+w==@vger.kernel.org
X-Gm-Message-State: AFuF++m+xDGVFQ3QOl+HHHBQDdQ5RCmqUdioS4zhyO7uTG9ca9uniu+3
	rIhAK7rqlyoZxn+0qSUvpMxMVk6k4kaP7DOIoHiXD12nyBHuBrzTmnlLqg0SYgSiKOf6meoDFl0
	dmkQuHo9Zrkcp5VQIGi/H6Llm3dDq/owGo00zRTDGsUg+whfQ2Fpf87RduSnCxrXlCjlEdg==
X-Gm-Gg: AYBFou2+u5Ac315TLE/Ypcg5Xzx5eRhqzXkQLfIStXEsi7fMJXTHDjUwobEvoq/YsC6
	B+0MieoRpIhMOQVQQizovR/dA+LopUv89vOJgdwb6htpIux06Aq15TPlz6p2MQX0MEHJRmKZGP8
	aemS+JE69ryyEfMMGbzl0lIAVWyD5crNh7Lz8IyuIUNbAPBbnG7sgOd8GPto+8A/Ymhr5Bxq94w
	6KSf4e42bA9etl+RRsgfKnN6mmAsqyJ23GF22V2TW/eoBze6nP5oKKnrdTpQQGfq72Nm1mJjIH5
	W+KlX+Jhcu5YkTeqLwOopboLIplUvI8iilrr1d0va6k8zOM2tV0ytnKP+MrOX2Mf3FKt5Nwm1lR
	o9sdI+Q30GpNYQT2aCzCFnScTFxhn
X-Received: by 2002:a05:6122:32d0:b0:5c9:72ea:141b with SMTP id 71dfb90a1353d-5c981d701dbmr3781349e0c.6.1789401157265;
        Mon, 14 Sep 2026 08:52:37 -0700 (PDT)
X-Received: by 2002:a05:6122:32d0:b0:5c9:72ea:141b with SMTP id 71dfb90a1353d-5c981d701dbmr3780433e0c.6.1789401153186;
        Mon, 14 Sep 2026 08:52:33 -0700 (PDT)
Received: from [192.168.1.110] ([178.197.219.214])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486f301121asm22926613f8f.0.2026.09.14.08.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 08:52:31 -0700 (PDT)
Message-ID: <3bda35ea-1f45-4cc1-af1e-7f1513651b60@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 17:52:26 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] dt-bindings: net: Use consistent indentation in
 the example
To: netdev-bot+sashiko@kernel.org
Cc: robin.clark@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jesszhan0024@gmail.com, sean@poorly.run, marijn.suijten@somainline.org,
        airlied@gmail.com, simona@ffwll.ch, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, justin.chen@broadcom.com,
        florian.fainelli@broadcom.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ulli.kroll@googlemail.com, linusw@kernel.org,
        clement.leger@bootlin.com, olteanv@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, hayashi.kunihiko@socionext.com,
        mhiramat@kernel.org, nbd@nbd.name, lorenzo@kernel.org,
        ryder.lee@mediatek.com, shayne.chen@mediatek.com,
        sean.wang@mediatek.com, johannes@sipsolutions.net,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        jjohnson@kernel.org, richardcochran@gmail.com, geert+renesas@glider.be,
        magnus.damm@gmail.com, yongxing.mou@oss.qualcomm.com, rfoss@kernel.org,
        abelvesa@kernel.org, vineetha.g.jaya.kumaran@intel.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        elder@kernel.org, s-vadapalli@ti.com, rogerq@kernel.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org, ath10k@lists.infradead.org
References: <20260913122910.99457-3-krzysztof.kozlowski@oss.qualcomm.com>
 <178939022208.22033.14553895731937911806@kernel.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <178939022208.22033.14553895731937911806@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=CKa/zhrD c=1 sm=1 tr=0 ts=6aa81848 cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=+bKQE0WJfmhK2875HamI0Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=JYzT5DUXXbXYkYiThRIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TD8TdBvy0hsOASGTdmB-:22
X-Proofpoint-ORIG-GUID: MHXVFgxliQZyfOEyVKasXZ7mx5aBhhIa
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDIyNiBTYWx0ZWRfX9Gtc7JzMJoHu
 pw96uzT/KQwHNnrHEpVgGmh6rfnzKOQRnpLUkkZRhgs7Je9HDMEKyrmF2W/njtMRIiRvEec5/5D
 xEYLjElTKCVszPCbcWIZw1c9FTZ1O/o=
X-Proofpoint-GUID: MHXVFgxliQZyfOEyVKasXZ7mx5aBhhIa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDIyNiBTYWx0ZWRfX0rJlysZRjPOn
 0fcXGG6r46mY+HwbLfsfm+egghQQHyn32K38R1LvK7PToKBzzFFFlcyRb1KIYgxOZIFJK5UVLue
 LmhAVdrPwHMk3DAEhWK1XqbXoRw9WI9BMnRNk1fKRPlFUS+buMZNaEU2PaOj06krb44uaiNRt04
 L2fCHW7LuQA2qGnPIFfgh46IOAINu2bJNejf74QC6ITkc52kj7KSnWI9UzVzcSj+htVCchUJbRc
 i4v08/qVdsJ/H141FThDC8um97/iE5icWBDRySwpBBYURWDkIEkOSrh/UAjcRzXI6FAGLl2PWF4
 sSVrav3c51NGDmRfb+JcNt+Inzd8VxK8cCXQOn3fh39ig29iIrqayt2rllNQRVXSdg0EGGvTIQ6
 u+tltdb2TqFeZVnVLHwwnOUuBVVcNdKFH9/WOTb0G+aLWPZflQRGbilY8k3e8/VtTIBJlEvf7Mn
 TQxMf0779tlMVPD/7sA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609140226

On 14/09/2026 14:50, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> - [Medium] In Documentation/devicetree/bindings/net/cortina,gemini-
>   ethernet.yaml the patch does more than re-indent: it deletes the whole…

Overly long, it's like use the most words to explain something to waste
other people time... I really dislike this approach but did complain and
people disagreed.

Best regards,
Krzysztof
