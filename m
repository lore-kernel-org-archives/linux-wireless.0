Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02B43DC878
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 09:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810415; cv=none; b=ipaDXq0hcyd4MBh+sx9L8dAit3CiqjrIaKfrT6vzR83gVg4Zog08L7kNAAFuppX2tvBey7Vic1Ka4xkbY7FtxowU+QpNpXvnPDP/ObaavQU5wQY7Bw1B1Z57uXFN8C5+1eXhMhoKvBpF5cVfvre00ZQ2MOwwyRGyOGFwYlZeCIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810415; c=relaxed/simple;
	bh=sfshIF0RhF/xtW9nVefxWAOalPUL9Z+YWrGdIhMX47k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jV1vEx9diT2+c1LrBwYY1gncWyfvHLfPskwj/Sv75Y64oGD7LvtqjGr/Ql+rUvb0agW7gETTZun7AIWZMTqiPkD0dt80g0wrBkT7dtOZfM3xh6VUw9Ikhr4I2EQdd+7ubRPqeLjhv07gMxV3dCk/38GGvv3sRX22Ye2rqKyJhuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hlf84YcY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TjodovCt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hlf84YcY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TjodovCt"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U6CMdV1088682
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 09:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ngPOQwjwk5Db6ClM0CyokY5GomZFoDsLXDPpDvOhZEI=; b=hlf84YcYkWaYWPot
	W28s5AjP/9pYWQ03Susl9ECzqPRyWDSPCRq2r5Bnyp3gOMLMRUa/CyoFL7tp6lHO
	YdNXuNXfIPn7EBJOkUvdoY+3zhpmtZF0T7LG2jhic6IyMulwJHEnoucZQ3/RpTpy
	3N51YYHPlLqkfQpLyFejn40i0QS1Zur7WfilZKKtg7BD+5KYxjx9obEymXNnKKiu
	JJ89Pc/4KSlfd67r4NnTODf1iIoCIf8KVh9FbtaKy1CwWKn7Gaw7T1UbDymYhEw8
	6BfyN0pBnsDqAa2pKeRNwWmGn4hx8LFnNW01tSxOzw1g6PJYJuULOhu86O0/Y6vd
	ntT7AA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f462fhaty-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 09:06:53 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e5e21552dso29646685a.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 02:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782810412; x=1783415212; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ngPOQwjwk5Db6ClM0CyokY5GomZFoDsLXDPpDvOhZEI=;
        b=TjodovCt40OfuyckoZzNNktsjQlJO62VOqU/zaEOmnW3UceDkNlfvUcR5murMNzJze
         fjFOqpG75hkRAqYmZ2g3PelzNfcs0O2XK4wzEdI2V0jIr1lxtWQBncjByP7NiGDY7xx1
         gB8NRtL78AjKVRKk8rfeYzn+j9HYFRlGKJkZKpbDVh93S/zFN5Las/S5Q5BZ9lIw4z44
         vgyJtpQ/MAk/B8o1oGVHBXARhDITBRsjCj7L/1q65eKJLd6J8HpwaBOgZBBJsMJEnxyX
         MwGnjK6DXgVNh21nYYECNMsg3hTe8o6hppLnMWM+FvnJcp6/DzkVSqLCtndUWESWhg8K
         WuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782810412; x=1783415212;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ngPOQwjwk5Db6ClM0CyokY5GomZFoDsLXDPpDvOhZEI=;
        b=sovbc/bazBVNf0IpUL1ZXeBGl0zlDmfGycBfywt6b2Gmm57m+TE/sU3Xx4PnQDrWc3
         fmVBFyT9PPbsnkJzofUQYzffC+BgczB+7y+4XLTUujIvR4WhErz+Toi6YF6NCqaqCITV
         MTVwemEuwuN9NYjSgR/dCu1VvVGUFzDoMKkVLIz8nUweyWrrO8qwkzPMhVTdjrppCIaU
         6mB1wMixj0ILyOx5oCZrr2/+tlEQaLNgJ42x2EOWIsJ9cG4K5yWaBFQ3tbK0BO+TF+Q9
         M12R3KMP2ag3ttrypZ5g7Ht4uGxI172CL1zg/zCZd3v3gTKEP8C5u3nkrLSsq+lMn9vy
         JkBw==
X-Forwarded-Encrypted: i=1; AFNElJ/KaliSFwRRWZz5VOu165ZwbZkmiczYGCGmto/tysrxKTqADJwfoPYMF8rqtKxO4otDeMypC2hTfRYQzLV5eQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLV2V8fUtbkUIyd9Guz3R9gpszAV33otKdrCwBcSYrVMC5vjRX
	/DUXEI9a1TNKHHYfb26GdtIEqenlW5W6gfbXM6+xEeabdR0NAxRj/NHc6qBqPWlw6hmri4mpX3B
	Ur5/2g0ebPp2SDXjHmt4goh54LYF5MJ6qRn2cLMdpvU1q0ckN2lEZwafisKeIo3t9YG8Z2Q==
X-Gm-Gg: AfdE7cnSCJSZUUqiDci6AAJL7ZsAWiba9ttBnFD2j47rCIsGEK0iMl/6o3alh1Haorr
	jeDDfNGyvcoOPsok5qNtrs1C6T9vhofPa9YLYRmQUJTuYu5OfmSg5eDfgY8OWbvMjupnkO4Yeqc
	/py+qRvQqp5JuVHYEYXhj5GQCrxZ4eWvqYAw03vUoDNohNDVNMbhYZlUPkmIwngFol0mvTNGZ3h
	IwbiXxjqv1rzC3DOmH7Qr06IvdKsqgjIVGJ2SvfdzwB/PjJ5FaOsl9mNTSJ19bp92D8ajFTizI7
	mCWuVYlBTVEP7AzFR3RiJKoTwWZ+4DmcekLPhDvheiRB0QzxV2s/X2HLmjATCy4XztFhpRTbA7y
	SnkGYU+mrMHlfQ/c3tq199Ht5/PN/E6RUXK0=
X-Received: by 2002:ac8:5909:0:b0:517:5e32:f3ac with SMTP id d75a77b69052e-51c104ee712mr23691451cf.0.1782810411994;
        Tue, 30 Jun 2026 02:06:51 -0700 (PDT)
X-Received: by 2002:ac8:5909:0:b0:517:5e32:f3ac with SMTP id d75a77b69052e-51c104ee712mr23690931cf.0.1782810411352;
        Tue, 30 Jun 2026 02:06:51 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1289176ee2sm88818066b.58.2026.06.30.02.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 02:06:50 -0700 (PDT)
Message-ID: <7348d7e6-18b3-4064-9fb2-932cce76816e@oss.qualcomm.com>
Date: Tue, 30 Jun 2026 11:06:45 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] dt-bindings: net: bluetooth: Document Qualcomm
 IPQ5018 Bluetooth controller
To: Krzysztof Kozlowski <krzk@kernel.org>,
        George Moussalem <george.moussalem@outlook.com>,
        Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann
 <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
        Rocky Liao <quic_rjliao@quicinc.com>,
        Saravana Kannan
 <saravanak@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King
 <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org
References: <20260629-ipq5018-bluetooth-v2-0-02770f03b6bb@outlook.com>
 <20260629-ipq5018-bluetooth-v2-1-02770f03b6bb@outlook.com>
 <20260630-wondrous-lean-stoat-be0b9a@quoll>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260630-wondrous-lean-stoat-be0b9a@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA4MCBTYWx0ZWRfX1rGIXlT9BMAN
 P7BeilRPfiYCtZF/r4YNk99xKfpgSQftGlQnfan3MccZ/nRlIXDIuFAz6lHk0tKtN84rHekbRaM
 RV4HDEDiZIHLKGxAw4FhEo/nDZztcYLVQQYg/5qO8V28g0JHcaCy6eWOYEHcpX2ueA34OkBqA64
 xRObdnvSutThppsNHKnoEV8ieC6wbj53T0nhDrs/VTJoEOM+ZTtxWYmOj0zwIRE5ZuLVdR6A2Mm
 PAO+SXO3WW+ZLwO4fQ1T4PdN+lXlGazS+q/nr6bY3AxWql5hI9ScMfd1jBbsvJIqDTrXZ5pl/mc
 yqBV4j6zT7vLb6WVIWwrYpE4u/5OfdownxRvv0IqpagLbn5kq9XHTvFSbjfc/gRHUGBgTsEj6Xe
 nW7T2quUOZTWClBr4hYAFDZFvcRXpjxWLB3gN4ZF4XWxhxyXvmCIEOiNPU98z3nlL9VENAgb9PF
 TX2WaIBGUG0HXbNktqg==
X-Proofpoint-ORIG-GUID: QuD5wc4wktO5pmtpVsHTMLWtFKDx7PwH
X-Authority-Analysis: v=2.4 cv=JqbBas4C c=1 sm=1 tr=0 ts=6a43872d cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=oV5YwiDV2Nt2AUhp6S0A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: QuD5wc4wktO5pmtpVsHTMLWtFKDx7PwH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA4MCBTYWx0ZWRfX7k4kH6EMykyD
 Blko5/oivio2pNQzVJTiLQNH3PxeXJE6jxM1biux6eB1h7imuEI067hTxfuQVDpQ2d5NTyoMyeX
 nKrFoS9kz0SIeVjtr97tUXPgZI3qVfI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300080

On 6/30/26 9:15 AM, Krzysztof Kozlowski wrote:
> On Mon, Jun 29, 2026 at 05:01:44PM +0400, George Moussalem wrote:
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/clock/qcom,gcc-ipq5018.h>
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +    #include <dt-bindings/reset/qcom,gcc-ipq5018.h>
>> +
>> +    bluetooth {
> 
> Don't send new versions while discussion is still going. I need to
> repeat my question - what bus does that sit on?
> 
> Device nodes represent real devices. Real devices sit on a bus, usually.
> Do you have here a bus?

+Kathiravan would you know what the remoteproc-driven bluetooth is
connected over on IPQ5018?

Konrad
