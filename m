Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792764138;
	b=45fJc0BRXYOFDafmHCaB4s/l9aIdQL9HgZYmekNAXdCSXMZxqAna69mHF6vk1QblK1Ob
	 FYAoURqYA6Hwu3DGmMZS3eqtIpU9kXNrZwItnpeIblrCGS6J9SWlIU5BDLAdL5wBdvFA6
	 P0sAf2L4nynTYKKPPMJ+IJZVRG6Xh+Rf82a38eEee0/QSVGjwj59RiaO6uT3dDOQ0UaQm
	 F7aWjhCiMxsfQ9bGPmDIkVLD+VQYtU0I/uHRBq9wm/MIcX5vx9wLoHh2c2BRjRutrbhQy
	 9cq+3duAfLo/k3mwxGTJ0tPZbdHkkG/F9peoARvwswt0iWrmPntMO3e7n6NwdJGxdCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792764138;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=MXyWGToeJHvKTRRZq3XwmlkSnt8Y/hGNiIq9DpWzezc=;
	b=3Jy6YggkMaqrUEA8YVHqv2PtroG5txngtn9SS0usBemKi+YdM3pCSuDaZ+ogyZdG/MmV
	 KzvVq5Yf9qm9SeCWYLvxgxykyPrpEBHlYsOuL2Y9Zz+I4OwboOL1gV7Y+0mbBlmx3qQXu
	 bmYftdoJQ/V1XvNnrkemaxMcfLlmxasBJVqTYUQlkvWJFh0Wr4xULMF5ncL6EK2JWlAEB
	 vGSI3Sw7XRihJ7peamszyRgJJP/TWVA0MLKiRIMqGXHwUav+kw5M6GqBv/AOrcMmcSOKu
	 65HP4YfuPIFCqWgLCmK69f071WBzbE3u2EAbTy+YDd28p6iBWDf+96XFTYDvHq1OGjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Dg6h2ZMC;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ST6mbG7i;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBAB606A32A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BBAB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Dg6h2ZMC;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ST6mbG7i
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAAUpx3550605
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MXyWGToeJHvKTRRZq3XwmlkSnt8Y/hGNiIq9DpWzezc=; b=Dg6h2ZMCLLsc/yP1
	I6qTTMVxn0gHmzaeTvaOGgud5bFVkeJocoTVCav4vqqdigQvcPIuygrlLDH2EIxe
	F+TGw6CKOac8cyTs6zr1XNCYrnoA+aNBnWo5jbsqL2U4MJIguL8QtS4PdAyxXJL3
	tzi/lByzoafs5QJ2whEB/A1L9sd1k+sxRfoQ46vJhdhtOcmQZqEOIjV51vgvE0ej
	EgJYrK8vcdyW/OaHkwSfAIfACEegabPswmbrzPsbvCXm1wt/e9CZkODgh2aTStbs
	z2pJclQcrIb2EWusOmtMfJgP+oYsJGA7HFyXYlCJkpMma8IznROzhB44kzgRqP50
	N9XDVw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmrbymu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:02:17 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34edae32c04so138196eec.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792764137; x=1793368937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MXyWGToeJHvKTRRZq3XwmlkSnt8Y/hGNiIq9DpWzezc=;
        b=ST6mbG7i4M3s7DOpZVaASZUvYLEdViCqEw5SoAQmM6Yn9ENixSn1N9RlYYLBT+sM1n
         OUSc5Q8QBzIgQoHSuewVwox8nf08A9br3eu4ZocwivDB5VCSP0ijudwtzvvFiLI+07Lg
         +ZPPIhJ96tNUjeDDnQqhYSQ+rImFHtPpbkb8MEZALdms3woxZV/pRNNr77ZLzP6cN3OF
         rtVeGKA087k3cXi012uhq35c1oGh36Dfp+5yMbxPMUw9l9zgOkMu1DXKeOKQzX2UN8tm
         PMFJ++tG6CRibbs6QVtw8xPy1qch0crXaOsxxmi26mgf7Kfrvs6dkl27AGAtzTaBrKoo
         Dc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792764137; x=1793368937;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MXyWGToeJHvKTRRZq3XwmlkSnt8Y/hGNiIq9DpWzezc=;
        b=VvHMlrTnmE+Io7JPOBZok9DBjArpYgEZd9i5aazoWQF4Bqxk+WyqzXk+bzAtt4+Mn5
         /uU7WC24Cvjvd+eyqbZwUQwqHVo4KAMTr2VuQhbmu7pV1Pu0bSJCorQWM4zY1PhaVwJ9
         I+pBeYPTAa8/bR1SvKRK8WXVMopZrOwU7VYCLsy15qZe/XAO/NGDEsBnhSlIS+L7DoAa
         kzh9MPMBwbvwpFYwxbLKLiopgLNOnxMjO8YImsRcaRNToKirgJnoiaISmiZhMQwq/2cG
         TViTis3gBaFFG3qRKzF0TVqup0koWLZicUtVJQhI2xFBn3vymNcklfIYlmffvRAtpF4D
         ZDwg==
X-Forwarded-Encrypted: i=1; AKwUvByUFwuTS6V8ivD0rJcjfRTT0NHmSDbWL9mboB91b1m4T8s/hHSC9GMeCSv0BOroa0l5qzWeOW9hgh8Cs1O3lQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKdh/cFiy3lY+lZLBWJ7c0LfkYxXrK1dPl3QR8GinpxXwT+GOAi
	EJ5RCM24BZJteXig8jBX/Rl7s4DfSz+O0jatpO9LSldb1dAseraSgI6zCN0MbHAiZgeYKBT3uCm
	ji1+1NhmC7Jd2/mcHvmmTFBrMbxQtbvGH1Qcii6oU2AxDnNY+Z8dPX6bBZUOp8BBXm80QQA==
X-Gm-Gg: AYBFou1SZjiw2GD2dee+Dv1i0DDlbt3I4zMj6qlWA+i3IlKP//jxHU8OLZdP4WwYE5s
	OapTUWh/r/hN7ftg8qu2ARNJZMpiezNthgfPSOthMyUye6zQ2hoZeaFOsmmTKkJZlqkW09g9v4o
	FIEdps7Zk2V3uUEunu7JnTAkrrtlEnrWRtOVpBg6g6yLUOOak4pTOUsWTDMzcBUJBiz053kIDR9
	34cnE+w8u0YvGIZlus+9luZtrWmHcuw/yJ/gXidHvzZicarEPAi7oTAZ5d+zHXiTyDuWlmVnev2
	DPh5Pn02RUuW5jMok/fC5NRsZaKFbC7HdW5JK/j0FKpXf346kiTS1yy+XaBA/M2sVO0HfNLdAbC
	rRiN3RaYe1mJs2Nqw5vcJzw==
X-Received: by 2002:a05:7300:e9c7:20b0:369:d85a:d416 with SMTP id 5a478bee46e88-369d975dedcmr5567429eec.1.1792764136775;
        Fri, 23 Oct 2026 07:02:16 -0700 (PDT)
X-Received: by 2002:a05:7300:e9c7:20b0:369:d85a:d416 with SMTP id 5a478bee46e88-369d975dedcmr5567356eec.1.1792764135935;
        Fri, 23 Oct 2026 07:02:15 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46b8d3a041sm3976866b.68.2026.10.23.07.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 07:02:14 -0700 (PDT)
Message-ID: <d237678c-9279-4bd2-9d72-b98830db5d79@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 16:02:12 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6
 Enterprise
To: Andrei-Alexandru Bleortu <me@andrei-z.com>,
        Abel Vesa <abelvesa@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh@kernel.org>
Cc: ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <cover.1792761470.git.me@andrei-z.com>
 <d1bd2f947ad986ff3c3fca1ad367aec2f1cec6b1.1792761470.git.me@andrei-z.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <d1bd2f947ad986ff3c3fca1ad367aec2f1cec6b1.1792761470.git.me@andrei-z.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: cm8_o2BTTNI6WQqV9Rx2o5Yogsonx3Uo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA1NCBTYWx0ZWRfX84YE9YvJc/Mq
 CGQs2Qsu7lSOsPwhbM4dGMA3JMcRT91IyzoZp8xTwYCBQneF/KaHZYil2jXUNPse4WAV4Vkj6lm
 ecqIluCV5jJGyOEjepCz2Du800twhsY=
X-Authority-Analysis: v=2.4 cv=VNZIDNPX c=1 sm=1 tr=0 ts=6adb68e9 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=J72pobsmAAAA:8 a=EUspDBNiAAAA:8 a=5oLZaV2ftHNI1lavKEwA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=CEj32ImPKXYnrW9rpEIO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA1NCBTYWx0ZWRfX291BIir57Cmn
 ra1AZNFdIPmzhBx0HDDty6JvFEKugIS5ncPXSMtrrVQONFXd1zJVFpFpvzR3ApJXawWDBe9ZePO
 TEVGF6c99CuBtjgquMVcFZ8C8QITPOJq6sgOvM5ugvPX+nYodrU5YP8qzAAJIi3iCoXiM3S7u0z
 a6DsA8DXJSHtkjhL7+uerL6hZhWeYfDUVk8Cg7ROJxZIWJVaHRieauCotBHzKxFlOCoucdnpsiX
 Gh3np+xEy+ZsVfEz6PEb1X6iFV34jTSCbIB4HkvOqkSdGHbN8M4xGfNIFyR7rWxK9opnjgI9cpj
 qQIbn5eCyc8P/11NHjzV+3m2xlCP0IVZXviSZNhUrtF6zKNAlExf/xtVKP9CDbksCt0NVPQUV2U
 1R/XoduH/U7uweJc1W80ssZcmhU25Vp1bQvZD0a6ZoogJwuOF4blA1gCmSAgltFa+k0mwKe/wZb
 6+h64gq7PvNG+y5qnww==
X-Proofpoint-ORIG-GUID: cm8_o2BTTNI6WQqV9Rx2o5Yogsonx3Uo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230054

On 10/23/26 3:37 PM, Andrei-Alexandru Bleortu wrote:
> The Ubiquiti UniFi U6 Enterprise is a ceiling-mount Wi-Fi 6E access point:
> 
> - SoC: Qualcomm IPQ5018
> - RAM: 1 GiB
> - Flash: SPI NOR (boot chain) and eMMC
> - 5 GHz: QCN9074 on PCIe0
> - 6 GHz: QCN9074 on PCIe1
> - Ethernet: one 2.5GbE PoE port, a QCA8081 PHY behind GMAC1
> - Accelerometer: ST LIS2DH12
> - Button: reset
> 
> Describe what mainline supports today. The Ethernet port and the
> IPQ5018's own 2.4 GHz radio are left out until the GMAC and the WCSS
> remoteproc have bindings; the LED controller and the board MCU on the
> I2C bus have none. The QCN9074s carry the calibration variants their
> board data is looked up by. The SoC dtsi gains the pcie1_port0 label, as
> pcie0 has, for the 6 GHz radio below that root port. The vendor QSEE
> reserves 4 MiB, twice the SoC default.
> 
> Assisted-by: LLM
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
