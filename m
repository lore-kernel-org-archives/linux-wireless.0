Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792764123;
	b=QziOLf7qDYFl0aYEsGtFzWJhQdmCUphoyzETWS7vp0SJFj52XcAvTxGDPSciVj8hf7P3
	 jg5ziwp2atRt3tAK5glYwY0Hh7n05bs6lddxTaGQuUM0Ir/ecaCUwBCojzhZJvxh0Ptzg
	 Gcw3v/sRZlaJ8ajJRvztnPJh0Ay40C+4pJeZdR8c4OU92xhmWSHAF7ZdGtbIlPh3GO5R0
	 vnscrHiY8yHC3CW8pXP/uEJiW6X7AX9U02CyC1ZGs+CoKwVKWhARRsdDn6zORegL42b1R
	 AAfUCHsnc8r8MPUKG2PA9fiZud0Qg8YvfFX2Xtv4wD3cbVJuEQP7xNPjM1r154UQWWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792764123;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=epYwqKMMUenq+YYIVdJN8Y6zhWFe4Mlrmgte2eBFW8I=;
	b=e6FM8WmUTjsl91v35YTeXHwgxxjRd0+pW6A4rEra4jyj4rDuKx2OK1Dyjj1GS/KyIKLz
	 EHBIo4+4B+9SuIfFClVfyljns78zp4Sm4uU1Zi3zhWMMcuTPI3MtkYjd0z7bqFrEg9xmr
	 bdVg1lUrhjPIl2Ejby6ZQhWN12Hm0S7IqIsj85doIE1jM5rm6uvaJC/Z02NIDOfvHAdhi
	 Cu9bI6QWb8aky6fvcNtUwJxH1DTiKA7JkaPknNvObTXH93F5AEz68i6LXMmXtZkk/uqjd
	 Dirt0UmNbpbkdblWDsemqa4/xEiRL35HBOgiXnCqlSN0Y7fBG9uGaD8rRp9GtGxZxQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V6nvKYPh;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fhLjwkIF;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE8F606A329
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEE8F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V6nvKYPh;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fhLjwkIF
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAAvNX2463880
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	epYwqKMMUenq+YYIVdJN8Y6zhWFe4Mlrmgte2eBFW8I=; b=V6nvKYPhgn3BRCsH
	D+C4GKviWCHFhHRvrWqZbfTSyoaccLWj0wcjxpS6eOQ12bl7O0A5goNu3khwVj+U
	lYgBlX2I2XYnRSiUAtxrh7qB35vyAKAtWAiX0BZHJMzb7fe1kCZWzzPLRJt+XQhN
	4v8CZjjjHh1R3AsC1hhI+YzGrYDtZFuUToIRyZqSpiL/6xonmm1c7K828ozce/Nc
	w1fTshVF/33gH1E9kjj6AIymOINqWv/9syM/Ss0Wy3kkH3KxYtdj0w0AKLQ0MR1N
	sHj1IVLK4RbYwa/IJrl7YkqZdaWLci4hNqJ6S35glWV2op8uiaFoI5pdVa7sq0SW
	yqEMDQ==
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfnyw4fmb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:02:01 +0000 (GMT)
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-49e39a34b44so45120fac.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792764120; x=1793368920; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=epYwqKMMUenq+YYIVdJN8Y6zhWFe4Mlrmgte2eBFW8I=;
        b=fhLjwkIFx861UZ6dl9umO8DVjLgZwxtS9LtftenNVsb9DkxSEskUKuqy2v4A+/WTps
         2AhQZSDaYXIODhMVc/0YcfQfWOCTHlteIFMstF+KHDeIBqYlKngb3QfvWIrwy7DTEW4M
         youil/+WGNyIO8tX5nJ08OmLedC0e6JMmjdDxDa1jNDVyDfCx5QECgdFaoZBijAkDBSq
         scdTARabAl69AqCQ4FXFEwieZKV2NdNM8mt//OdsUM6KRbgBTuHw0WR1GbZum73G+DGe
         MDQ5Pgbnms2AHuIcY0Tyzv/FdLM4m8Yhw55af7uSv0lrxd0qpW653KSzqkzMwyFaxS+3
         Dokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792764120; x=1793368920;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=epYwqKMMUenq+YYIVdJN8Y6zhWFe4Mlrmgte2eBFW8I=;
        b=cPdz/yU1xnRSnASuXdOUZrQf7yUa85ms15zEmX9oqOMox2z0VKfJaJaxnQ5xl1mZdU
         wmS9dhipMKW9iy7bXKkAVBJRWiZRywJZZuw6+hrMRUjGqF4IcOapYfYKvWMB/7Ug8t/V
         i1DU6adja+pWwuDTBpJKMKsFutczpDdsUrh4FKByjlYemXeLenBsQQZU0AgCzQc/QMvK
         Nw+vaVNmQtAuUeNLLxh/0XvBO12eoOWOqxNvQoLb1DJ6IExJmiOqoiCqkP5TR1SQMqAu
         wSifYzI1ztgeMcN0LwP53GY5AZTOzNFnSZn9MXv8h17Oicb0qKagKHRPIIIMZc7C5y4b
         HrFw==
X-Forwarded-Encrypted: i=1; AKwUvBx5wy/guLXAlcDX5+8vizC/MqDxGsg7UeIrHB4lOJocQJwXJXOTVx1ILETi76dMlN/LZTbtzZSNsh0om3JycQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIRldP5lls61tA31m5fHybz5Whd5/lBfWb21l2NBFN/xyC3CaJv
	RFk8MeUKWtvtWJis0uty7oMDRDadEWbDCPqS+dzQkO1tDj9l3vipYvGoB1UsgZ/TAabxXLu/lnY
	KaLiEHOrnuddMf01MJE+Qs4+Zjq9BROR039URcF3gguIedS12U3vZnkSnWGcXvDTvwgGqUQ==
X-Gm-Gg: AYBFou36TN2pERteADOqRwFOcqi6+mMwIwHALbiDogiTI47eM+GBTtl9y/lMEr1wPDh
	T+clJssXwOWorYETZ2nqRmHZ/qPsSwJgWIiX288uUaMiBHh3/3/PT0FGtB8V1WX9eFq/K/CshEZ
	MHc+qQV3SUBjAHKEsnPBu5FAJlRoa8nc2/AnlGWOHXjhEXQfAjfKs0CkxeeusAdIaO/HR/PZioF
	cKTZlAfJ8Y30ty/kmFmJFUwzSzt+OAB97kqHui3VzIXVjrMxSAIeVBl20b9Y4fMN7tybMXRNvMQ
	tQ9ih1P9dEvegu4joFje9qMSqQNPLPcwdwQMXIzB21dSlSzxBv55gIR+DIMOXK5rrftZDceohHY
	QOiEw1nSxi5eeUbaFeBlecw==
X-Received: by 2002:a05:6808:1386:b0:4e8:b729:3ebe with SMTP id 5614622812f47-55bf88f8b08mr793493b6e.4.1792764119624;
        Fri, 23 Oct 2026 07:01:59 -0700 (PDT)
X-Received: by 2002:a05:6808:1386:b0:4e8:b729:3ebe with SMTP id 5614622812f47-55bf88f8b08mr793350b6e.4.1792764118501;
        Fri, 23 Oct 2026 07:01:58 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46b8da9019sm3783766b.78.2026.10.23.07.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 07:01:57 -0700 (PDT)
Message-ID: <071fef59-9131-42b8-941f-d7fbf5f57ba1@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 16:01:54 +0200
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
Subject: Re: [PATCH v3 3/4] arm64: dts: qcom: ipq5018: enable the PRNG by
 default
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
 <8a595ee4a7facd53a25f51790500a642c78c2e59.1792761470.git.me@andrei-z.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <8a595ee4a7facd53a25f51790500a642c78c2e59.1792761470.git.me@andrei-z.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: NSS0jMCxyQLyrJIwqRrAoNJ1tYB9QSM9
X-Proofpoint-ORIG-GUID: NSS0jMCxyQLyrJIwqRrAoNJ1tYB9QSM9
X-Authority-Analysis: v=2.4 cv=dphOmFg4 c=1 sm=1 tr=0 ts=6adb68d9 cx=c_pps
 a=Z3eh007fzM5o9awBa1HkYQ==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=J72pobsmAAAA:8 a=EUspDBNiAAAA:8 a=pjGKqCRHFsEXOSBd6YcA:9 a=QEXdDO2ut3YA:10
 a=eBU8X_Hb5SQ8N-bgNfv4:22 a=CEj32ImPKXYnrW9rpEIO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA1NCBTYWx0ZWRfXyMEHlqopg6dJ
 WJ/lS/bCW6ftqlRQbsjmvsMdEY4yEAPDjt5LdTOtx0jhymrU1zA7qpq/XNzVNqS62AH4urkmoVT
 TcoTTiX7RXnoMPdEC5fm1mYVqT1JUls=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA1NCBTYWx0ZWRfX7wF0PV5GV02H
 V78FyXpw8e8K0yQL3FPLjXm+6oB4oELNNIqPxNZMsPxfwdl79WzYLiXbWovpon5RInwbcdx7CD1
 Ecu5ZrJVuEkTbagdrI8SlVgZhQkraW62aT+oflfuoPCy6fqyIHeLvc22jBm7pjeXBeFca7YSg7+
 FUVRpXb4JDPjx50OKYiJEW9oso/cnHeVzoPGICpA2dw2A2O1MFkswuYjzwBKVRcpAnA+ENzi51g
 tOL2uUWTM7F1CNOe1pOnYLrYSmMi90d8UeaKi/5HLnfnRwhWZMyt53+mf1KAQSZU+KuHStmdxmw
 5GBwppbqRkR+uFAJNRZNnnWG2FSDdySanUjKanhcHetpj/eVNrHtiQOoiulWDZ5i2duKsyMPRzm
 iuMjcr0FxAd+U3LXD1Gyghcz2spQSFn49oWH/ozjQx75RDlwaAQ/zyv0ongFmxz8YSjjWzZUMaW
 4MJ5+T7r/+j8Da426Dg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230054

On 10/23/26 3:36 PM, Andrei-Alexandru Bleortu wrote:
> The PRNG needs nothing from the board: its only resource is a GCC clock,
> and no IPQ5018 board has a reason to switch it off. Enable it in the SoC
> dtsi, as ipq5332 and ipq9574 do, rather than in every board file.
> 
> Assisted-by: LLM
> Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
