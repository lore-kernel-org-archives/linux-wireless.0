Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792586681;
	b=WVizVSyxLEL6xqAC4X/zH8bP8nra2Pc8kznaCbkmQU4DxigkB/UhfINfNpqNXlQesiMb
	 IXAvNIVWwAhVz3HcLhd5nMaX/qwmGI3l9It4GtyZh5ymuAOoIcdw4IY4Ew5C7tR1vUDYG
	 5ElHkBJUA5qMHmO1ZT10ptffh+C9D9bOHz10vsVVDVeQ7GWDhllEXFqfcEbaK4tAebIkZ
	 IjkaqcvPPr0P1eWzwzwh+m47le3uqzvFNwf4VCA11U6KG/56wvOwANj4IluRL8RPIVDAG
	 Und2Tr3lxHN9nxYpRoW+DHBm1rcB1okWT0aWAsnJsMqT2qECb3qB4/fZ5C5wDNOAMFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792586681;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9v6oR379dNMSxnj6f20WyQOZxHY2i1bJNgj0/16ZZec=;
	b=n5qPjQJNSfwWjgb/EEBgmQeoINhJo+5y9oQxRjGT4ybkKBJWGMUlm5y3Qm9lecY0aEe7
	 90YLlDiQoL+bbV9GvZROQCu3TvG8Nd4WRd1pXs12iNGEcZjBhKTeXxR2Pwc0ALwtXalti
	 8sMtPVhbQ3uu1how3H8n3kkyAqaSzIWxgZ9wKH9EMYluMsX8f1M42/GSVSi1vYXfyz1BI
	 ePNaIgZv92ifb5R85CtNdRMpSdadwyUy3Xb8bzUPxsGW0rA+AmCpAVxDG3JX6EA9rU7yZ
	 JQ2UxQmdrM4FGMXlY4Ggjrx7dU5kBAloDqgcva3e2MXNTGoN4K6LfGe2I+yxiLEYPSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=temperror header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HvFTPjd+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WoRvt6om;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67668606A321
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 12:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67668606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HvFTPjd+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WoRvt6om
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBfxHf1599796
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 12:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9v6oR379dNMSxnj6f20WyQOZxHY2i1bJNgj0/16ZZec=; b=HvFTPjd+5tzhkrlG
	7tXsJCR2/O3mAWZ7h2hp6jn+zv0W6eCR3Vu16YG5UzuVCo/JRDpLLRIKQh0YaEMf
	XnsRkcglg9E3595WkeW3fm4sqG58CHHn3Ocq86Th+SalS0XWHTov8xxxYqDupQBO
	Z37QIg840FeaH1GbhlKM67zscIkfuc+8q0gOxCha91031OHGXcpcdCD1su6oiPn2
	80Bi7guepb7MDwMxrqU78fLUhDsbqn6w3kXrYF2OhFApvfmPtKSiV2KFIiCobVWo
	RwOxobMGx1bXOHN7v3TuB3USZGqgKfUCF3oMRNgD8hTbcbggp2zGoeTVlc4FEMTR
	BzV7TQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heuhugf68-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 12:44:30 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93ea8a9cfe6so18715785a.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 05:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792586670; x=1793191470; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9v6oR379dNMSxnj6f20WyQOZxHY2i1bJNgj0/16ZZec=;
        b=WoRvt6omIiQqA38QNDkE9sWDfmIk+L8/YRYbylevcOsfS6MQhZVTCBv9URWtIIKV1R
         OlvjAAaTVRJs0WNUx3r4TxgV5DPg8dKRrtGQyWmz/QC5EPMd6CEN9igT4m/4G1SYjYXE
         aiTm6J8lVfpHK2xcCQ0CyO0kLM/lYfU19Hkd3C2RBfHd1gmzU5Q2PTdClWoLf04GWvaM
         Fp8gzCqu9yY0suEJXX5mM+l7CvmGoM9ohRLD0jSYyH6CAGiIxdFuC18Q/0PvfhqQtHS8
         USndWLbW5WkhIJFjvV7RQh3rAQiBWSLWggwjUCPoepVzg2cS/TZnVoQLGRq08ce74Uce
         7gYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792586670; x=1793191470;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9v6oR379dNMSxnj6f20WyQOZxHY2i1bJNgj0/16ZZec=;
        b=1q4DsOtX7JKKKO1JaNaaezrg6rucoRKFpvSPArUf9lumoQPMzbwcSkNxHIgHuk3fqc
         FOgEEHFwNk4XD32evVMyZDTvB476EH7zWiBnQ5irStkwWBoHBWQgxi21dPEaLiZrmYDx
         /+nktyBP2ArFXf+eUv8NBYkEZdsxwE5d4ub6BNrHS9liGn/kQjXCn2hr7U84FrPU2vcU
         9tCSMypFYGe4+CovyhLvNl3kazT6LgRAKoDKmHb3QQL+B3ioZ8OUeXGTlFiHEn9vrpcl
         /IcOrMrunXfs1ysHzc4Tj+D5YHssBrUOrk7i4Q7TaOxdKImR88Nqsdj9Akh26tur6o83
         IMww==
X-Forwarded-Encrypted: i=1; AKwUvBzeX8P03cqpc9ZZFH2GsPa6hLHXbbAVkNCwLCzJCt6djkNoOwkiqo2Rb8lGGglKFIH0Om/jIRXruK+1WtL7iQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIPCBcKFF3Rge0Ot+dVpRJ3i3Rc1Z7/M/CZ/GT+ffBfsxGkj6qQ
	eeKFdlWPB6fXIsRyvMKM1hBCewjInIMUy9/yj1BvIRkDRchl/VB+QTwgrbu07oXuUp8ZCFaSnOl
	PBy3mqG2ti2nqoecUJTKrc5e2MTJ3RtSRhY1l7T3wiCoqiUYWFo7QV6eIm5TAHG19Rq2xRQ==
X-Gm-Gg: AYBFou1XHzR0f+BD/Uv/tmYfTgeElp9ht4o+VGXt1bdu+GLJVZdMd1y+ZjZbhfWKoXv
	A0hSfd8wu0fuJ3rYx8XH2gxrPuT8SSTXGo1UWs/ngA/rmYWwr6qmantGtUzGAYc5IZta5zDi06K
	jyfrfUqKHWbu4l7gppRNGnsW4PD/iGvziXgVpKwthCetPhUTe/uEGGwTf5Bm9/pttT7eoVkymxX
	MucUU9LHG4u1AIkUlg9feBnVLAqE5L/tholFI3ZnwQAAz5C2Doxg/DmQA1mqsdBaB/Ni1PY9ci5
	oc3bf5TFFCmBe87Aeey0tK0jyLz6JQhOZ5EK4CXMiEHQxjoK7zi5A00+ROZxJmmGcNNizriDYnr
	ww8+UrXS7fYht0TQxZ/wH1A==
X-Received: by 2002:a05:620a:2b91:b0:93e:e111:2771 with SMTP id af79cd13be357-93f57e9331fmr466829485a.2.1792586669530;
        Wed, 21 Oct 2026 05:44:29 -0700 (PDT)
X-Received: by 2002:a05:620a:2b91:b0:93e:e111:2771 with SMTP id af79cd13be357-93f57e9331fmr466824785a.2.1792586668992;
        Wed, 21 Oct 2026 05:44:28 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4678f78660sm72328066b.17.2026.10.21.05.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 05:44:27 -0700 (PDT)
Message-ID: <bd062ae7-74c2-486e-9413-15ca8c943055@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 14:44:25 +0200
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
Subject: Re: [PATCH v2 3/3] arm64: dts: qcom: ipq5018: add Ubiquiti UniFi U6
 Enterprise
To: Andrei-Alexandru Bleortu <me@andrei-z.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh@kernel.org>
Cc: ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <cover.1791110510.git.me@andrei-z.com>
 <ddbc631bb95ae5fcc6498e083b280ba2b736181f.1791110510.git.me@andrei-z.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <ddbc631bb95ae5fcc6498e083b280ba2b736181f.1791110510.git.me@andrei-z.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=d4JgWhjE c=1 sm=1 tr=0 ts=6ad8b3ae cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=TO4f5atleJ8-af2fB8MA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1MCBTYWx0ZWRfX2wkFQ+aYKMb5
 TnxULJ20eU+SOc9qZLfksHTs1k6IR2KzW1DlEsdvnTplNTT6YbvvZqpnR3786rlfOKcoLUoqTGf
 GwHn35x5vVt7/2AieL+TCUNzazAbYhg=
X-Proofpoint-GUID: 3JMpk6dMQlEM6V52m1JdsolkIOMoRz6t
X-Proofpoint-ORIG-GUID: 3JMpk6dMQlEM6V52m1JdsolkIOMoRz6t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1MCBTYWx0ZWRfXyv03CenKfhj6
 hM3rI1WVNjDd8jJZSLA7hM13dj4HWQPgFoFiz6coeXUDMJ0WbTinzOslfUiq9aFceQ5i5aPy+up
 eoGONPyU0xSZm4HFCaSkfkrcxOClvtemozhX1L2Oz6UGFimh+Urd0FIuy2ELTMJz/j/YmHH2s06
 qvqRCJsLQVJ8/V5crCKVGtoO6G0s7EOWxnWXwPwK+zBUntKqgMTk8K4DcTU5dHFaoj32s1A+606
 X1ftvxST4xtEKRi0UgGDfn4xmTPOOjDhgrAj/e2rBGRN/vP/YUz0m/RDHvt+uzCTmyGlI/OWrHr
 hWam3nTLvqAdntAAHkvWE36at+5IjvK2g+L1kdNat7n9S37NP9YruXZgjJNqznd9FzwfLXJhV8m
 SLZ4B7MsL7iXBZuqDC8HomEf4wBMAtM1uUByvCEWlhSU8LcIRqewBAir07VoX3xQYve+7PlwKl+
 avWHFoLsE4qk+l0Jpgg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210050

On 10/4/26 1:10 PM, Andrei-Alexandru Bleortu wrote:
> The Ubiquiti UniFi U6 Enterprise is a ceiling-mount Wi-Fi 6E access point:

[...]

> +	keys {
> +		compatible = "gpio-keys";
> +		pinctrl-0 = <&button_pins>;
> +		pinctrl-names = "default";
> +
> +		button-reset {
> +			label = "reset";

Normally we do sentence case here, i.e. "Reset"

> +			gpios = <&tlmm 24 GPIO_ACTIVE_LOW>;
> +			linux,code = <KEY_RESTART>;
> +		};
> +	};
> +};
> +
> +&blsp1_i2c3 {
> +	pinctrl-0 = <&i2c_pins>;
> +	pinctrl-names = "default";
> +	status = "okay";

Please keep a \n before 'status', file-wide for consistency

[...]

> +&pcie0_port0 {
> +	reset-gpios = <&tlmm 15 GPIO_ACTIVE_LOW>;

No wake-gpios?


> +
> +	wifi@0,0 {
> +		compatible = "pci17cb,1104";
> +		reg = <0x10000 0x0 0x0 0x0 0x0>;
> +		qcom,calibration-variant = "Ubiquiti-U6-Enterprise-5G";

Does the same calibration work for both radios?

[...]

> +&prng {
> +	status = "okay";
> +};

Please add a preceding patch to enable it in the SoC DTSI, this should
never really need to be disabled

Konrad
