Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4847717AE11
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129096; cv=none; b=Rpy6ACRRP6tvuu3RFv42E3KYB8kMeTAWofZXtEL8PAZnpYFq7LTZ6IqbzcavnCIu8rkDO//OktmqqqvofBg4E/KbkMH+yYRlGb+SqDu08d99axZbY8sI60SRbexD6S9pUhCqsqYPQXCByPKqsIiHBncnXBFgsBBgY5WAgmNRSWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129096; c=relaxed/simple;
	bh=kZBidVZjmJGoApIJ3GO2Kz8d2/QFXB37Ii82Hw+ccag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aw7rIwjU7PMsRkFihOtqXU+PDvgrY/Q838AmPDSbn6jfqQB63ib4TsLr/Zlm45f83Y73S16WUdSFF+F27Dmpk7dqLOWh8JGzuWFewiVbNBRH0/e9DQhgd5zCLOpi3TJw+joKigQOisUY4MVgu4ivmcT6mLCDYMa9qT0HKdhUREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EAyH5Qza; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R9O8noX4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EAyH5Qza";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R9O8noX4"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1gPOC2139207
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sUXCyPbow4yUif1Oge6A2zcHD6lU8y6rMl8bk7t7NqE=; b=EAyH5QzaGI2fH9Ut
	Ph2NuUUAOuniSdcOx9XDSjaHG9CZygSCXWhA6LKC7tQwW0TRY0J6whesX4q3PIVB
	VQ/kNctBjfYv3SRoBvbFm/XQThkXLQtIZo+UwcFz5uHnea2QEr4jA0l6D+IZ/ZqK
	G/f2qhmzEtoqxK1PbadmjJvqRxLKashN3muMRxuP7RFnsJjr1YcR9Uq3D4z/j9Ey
	IrijZHbgYV16WWN5eu2eVhaZd+LMkZip9831/mMTwElV+ARDskvCwZwPAuyvrXGM
	458sKzHh7LDD9gZB0A+nMBbse3roDSdf6K4Izl0AcuxUXJwac3n406dosso1Kz8H
	BebRqw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmnh7vj8k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:11:34 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6dd278512so1457993a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785129093; x=1785733893; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sUXCyPbow4yUif1Oge6A2zcHD6lU8y6rMl8bk7t7NqE=;
        b=R9O8noX4RQZdWzulXw/qCeywij8U8XHvKgzJ2seVkQPzzHCV6ompPqn8Q6agr3euZe
         RFITvrANuhHcUNsrL0XkANqTNe5OI7R6YqlD9I0fRBzBgo4PaQ8olGICGUc+7u2LEGMQ
         YVahpmL1DjI0TZMf1t2X8/3VxJaQ7YGEGYJQ1jMMbH+YVyCnruFmGrrQIw4dBm7Ci0B+
         i+ApcK2DQKzXGN9Uwf0A0yPvPPqGsvu1dUMNpihrJAew9Er1YGmlL1NOVzqgeeCGBEo1
         1eaiNrNFM6y2UUQ9rivVGeh0yJTPTszYRcuBXRq+XBu2wOTi5dQXX7qKhlqZLD8yq3Lv
         RPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785129093; x=1785733893;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sUXCyPbow4yUif1Oge6A2zcHD6lU8y6rMl8bk7t7NqE=;
        b=Ua3st1niEVZ5RdghpuBYs3pC+13olT8ukNeqioknhjRK8fUjNK+tIgIhN9hmsYfPB9
         Eq5I1X0QkoarjMqFLEZWvDE3lI988mc2OFd5TE3qr9LxeZF+VcA6BWQMOT9gaDgFCtYV
         ijuV3BnsmO7g/a2eSADXX72mdr3U0vH4KunnX1OxFzI/xQDjUn3dtX/QkmxTW5lR9qLY
         izzemxNcIFI1Ojg1ZfrFcEon9QwAI30QhKTHRSVAlOen1nAP9v7eHWR7WS2Zc2fPT/nk
         FqNBoiAQEY71wXv9Mik1VCnRVIYOTD2pNanPUt9xE9aEqpj4INQ1sXulS0N7c6k4D7Z3
         KKDw==
X-Forwarded-Encrypted: i=1; AHgh+Rp9la+vpV+SrO2xWglYnPVee4xgMWt7K/Tku57f1w1oI5jZ+7Wi2ZKgeFCrBvMurLlFwMq6fTJSMnBkTwmA5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzC4Th1dp1hBRZQ7cy1UYuEQCNz50sXPLk4l9GubM/dKZ7hAcex
	PyUiJnpACBM/3is/u2E6nG+J8uMendZZlSBMuPx3w983aimQrQu0ZuS7VFdgCL2Hsy4/iiraRNW
	vBXa3GUEciWHGNQRqpiQZCpPlm2oKK3IWbEnzquO96e5fdEH8iWiiYUvRotk5QjQ0nKU5K4TIxi
	9M7Q==
X-Gm-Gg: AR+sD10vIwmNlWNQYeQXRwajIToEHSmqdDuFYnY2i0UYJswEzdrnmFEk8JJDq0oBSUw
	7zav0QMe3y1avu6uGnx+spulOvB4OPjg8dQ+S96sawb/GScqayart9KNjYbnmj5fwHztgzRLnGM
	8JexMJnzn2E/4C/BsF0BMS+Otsyfjogch1Mxnpp5Gtnedj/Z2DpzyGM25MSqDObD56HK4WP8ksc
	0EVWHzKWooCMIJQmgM0E346tQ17yqNhz48hs56fbE4ML6K7s0R07T9dzhBvHB22YChFbOPeV39z
	qZtS1cib8mr/DzYz+QDqG1LZCkxZUto8sjyoq+mVY1MyBfBjbkvdHQHTtWk/LsLijh51rEoF/yy
	2V+AzNxM17X7c/0t+f86TB2sxPDmy0nIkJiMmhS7i
X-Received: by 2002:a05:6a20:d52b:b0:3b5:489c:7bb5 with SMTP id adf61e73a8af0-3c67da7901cmr6999992637.28.1785129093016;
        Sun, 26 Jul 2026 22:11:33 -0700 (PDT)
X-Received: by 2002:a05:6a20:d52b:b0:3b5:489c:7bb5 with SMTP id adf61e73a8af0-3c67da7901cmr6999969637.28.1785129092616;
        Sun, 26 Jul 2026 22:11:32 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e1255sm41470321eec.4.2026.07.26.22.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 22:11:32 -0700 (PDT)
Message-ID: <5e1c8d1a-ffc7-43ef-8285-c1c002a36e3e@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 10:41:27 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: validate TLV length in
 process_tpc_stats()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260726-ath12k_wmi_process_tpc_stats-len-check-v1-1-c4ba2f84d9c6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: JZ7Tk_qNigmKXiCXjvBZ6mibwjHkrbPy
X-Proofpoint-GUID: JZ7Tk_qNigmKXiCXjvBZ6mibwjHkrbPy
X-Authority-Analysis: v=2.4 cv=f/54wuyM c=1 sm=1 tr=0 ts=6a66e886 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=XkCbJFFJNXZGceBJsBQA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA0OSBTYWx0ZWRfXzBT+o8lCOoL/
 MXrhESxpZtBmBDqs3MaQo/NrYYsr6khqGjqxn/tx+tDm+0vB2HdMs0Ssc6lSaV8lKfkvbpBM1tY
 ieajZUur45rJeq9Mc51XVZCwy/V/55vrHZdqolpTgKmX6Fdm6Ot3CxZ57SR9HJPAlrgl/7XmmIL
 GgOL07lYljXePhl54EYWlcc1wz/VtiaPfMvuRbQkuwS051IVLR7arYR6SLp/MoG4RSo203lDbpQ
 D/oJNKLTd+AiMD37gZn2tiylIxExA48BWh5cFph8RDwaHVtbwEHERRRiAK0Fz9TCW4BhO0+mawi
 GF93sTcbN7cGVSuga6FW8umgR5hdEVUGy+UsVtABZ9GR+iTyLH8IFp/LETFZlX6A9FcurQsCX+9
 klk4dEHRN/a1UER7jPHSQegYBA6h7BY7quE128XZfTESG5bXlmRdrkg8Wl6HgVwY/BCDXmsR32i
 OHuAeG8vNpjZgQ3yOmA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA0OSBTYWx0ZWRfX+7GYXSOO2JnQ
 L415NACU2EGJpUCnyCeTg1tp+VIkscZXNHRPye6DUnb+sgmmkvTIvgHKSa+f3bjWs5FwGgHQ03Z
 +UzsjXQmy+oAXPWjQwFZzYTS/XwoCMI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270049

On 7/27/2026 4:32 AM, Jeff Johnson wrote:
> The outer skb->len guard only confirms the SKB is large enough
> to hold the full fixed_param struct, but the TLV's own WMI_TLV_LEN
> field is never checked. Firmware advertising a TLV length shorter
> than sizeof(*fixed_param) causes reads of pdev_id and event_count
> beyond the declared TLV payload.
> 
> Add a check that the TLV length is at least sizeof(*fixed_param)
> before casting and dereferencing the pointer.
> 
> Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
