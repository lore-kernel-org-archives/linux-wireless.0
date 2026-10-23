Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738944;
	b=zq+JFWQdON8kKzFRwGFf2xuR2cjEghsn+mjtogn9LSYZDQSjCv9woln3wE4t2lc4BXu9
	 XS8Kj72woWtFlFGn4zl0vSOCkcz/ywtUj6IzwZ0cIVvqsqUwcLktajwm+62mSgU9tKaNP
	 3dHuD1ZIjh+zkAxCM+4VaLtsVH7do68KpfvrNWWLWETx0DG884CZ7DE2yCuC6bxCBOOkR
	 kG+F23C0xV1MCOall/zd4oBEtXwJpTv9Iw43kBdY1IOjskugnmu/uX7+0TFgMEwhjV9mh
	 W9xAnGxQAOtAK0gulJrF/L6y7iE69sRWOzf4Kcertk0Rab3//qXVtJY/moP79iIhi7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738944;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=alOZNhc/hBycopSj6aablVmFXgtwQwPhX17D8dTQR5Y=;
	b=orMZTUZ5CxtuHZuQk1hPT9gc/VeQG+qv29N9yNX5K8RmsK7W94oAQ8lGYbw1r+y5Akqy
	 xuaOwuMSiC/plnoRdMBDndClCslqYxBjO9Ze2BpFopgjG4Jo1b/GcVqxfnUC8BikGSi0a
	 L00cVhQWBFpIwFhnpkAM8MUCYGPMptTDABxovQTUr365M9hFjVuw8WaH1p40j/sartg+8
	 qkshe7dIyvzjgP3odWDJlp15jtV+clavSEjqYFTI+EGO+Y7+0J99++rfsTe5sC0HCBaKk
	 bEHjwpsbfJewt19ZF5BIsP3JpQaKJE5scCcIh+DpnYH6Wm4+ZUhuNqCJJV2IDAPyVAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bI6SmZwL;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NQUNnZo8;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D2D60A381C
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6D2D60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=bI6SmZwL;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NQUNnZo8
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1Evoa1289952
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	alOZNhc/hBycopSj6aablVmFXgtwQwPhX17D8dTQR5Y=; b=bI6SmZwLCFk7Z0ok
	Sn9qNsE4URzMOnntz1F/3GzPqys+FvgZKSAGJwNa1ILVlXQfEhArYnOwlOdzpLv2
	XKtvkoQD05IXAzIUrHEWk0sSxR5iiwDC13s0t5KrR2lmZTXltVJMrlMXv1j10H8x
	N+BhvbiaBgvyxFIG3o/G3v1DcUUlhfwWVfCAxN5z4XGu6/LLMCV6zUmfw66Ia4dl
	O6Kdf8VoanQdczSMZ2fCp09LmJHa/Q2PTQk5aIsdxHFzYzCIiFEnU9BQR2G+A/C1
	HD+rGp9Y/KWl/NzbihKqmyAofU7E4dcthGXOCvw2MTvyqbg025WAVbfJQ5TuAkwu
	A4wg2w==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfnyw2vkd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:22 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1cdfb337eso424038a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738942; x=1793343742; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=alOZNhc/hBycopSj6aablVmFXgtwQwPhX17D8dTQR5Y=;
        b=NQUNnZo8HoyxyBzGS2dq/Ehl3XUkGPXAiD6y3QhCLFrhfEEcKaNkoABV439VkhmLtU
         +xGKlNUSfR52JljCMwrALS7WWsFbI4E2V2kMBT5K5pJtawc69wf7vFi+J93dtZGuEKq0
         pZHiV/6xIYl7GBfK2dpFS/uiRIkdyQVuijtnWJgGADkkQGy21VHb4PKskmLtFS5U5LY9
         8IMp7lgSFvDAXXNlM4tIKIBHS1dgMOm26psXym+XbchqsVJPupq9rk2fFTk8p/EpDPDq
         kmTDuK7YLOsSF/PwkeI2/ec6u+StRCTf/JRYwNaMvtMxgeZuWp6KrogtdSxxXh8Jf0Qz
         SWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738942; x=1793343742;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=alOZNhc/hBycopSj6aablVmFXgtwQwPhX17D8dTQR5Y=;
        b=x3T2nJT/miZzy1clEBt/xr+/CLNJJooH3X9mHuB1BNa+KnlQWaNabg9wecUuMcDIlY
         kIVYMhQY2oy9xJxgrVV3KxzW4plasPBu2GvHc9DGPwUtNjz47Koq8OhGPp1L828/RMy9
         DXYg5H3T8tazeoc+hX+bvto8dsiNjiYzxA3R47vtTSJG/b6aj48M2WMuhc/sh5pVELz9
         tHhLBifFLXbCaqiWlqEWZUS9jTkjORvXqPJ5VCphMx5vsgH43Sbmziurq1JU0aPCpb+n
         2LTrz9T+zi9nAPrvISVKrXg+NCEcx7thZloY77FFeJ/bXpokGA+Cyzkg78skJ9WxRh6b
         f/xQ==
X-Gm-Message-State: AFq9FYLXYSVg7Xh59G/JPNBPuj79SBSLfKfUMh71wQOxZjTb15UnVt4x
	Dt0pgWVCkog9gIWlBuyAFbZYSrpGtEKjTHVSkCoMb8xqu/nCjycvbH+nydu8gePih0M/2b/ZKZ/
	B/qY1SPeJFj/hSWFF9hTRcpbGnv+rRghoIojIhdzfSOq7MqXE44sOwEoxAmKNX+OUVcgEqw==
X-Gm-Gg: AYBFou2h6x0GAcGRrrpmxS/fvHUGbrQ3E8yjCZCwjQlFIkj2GyadeEWoZr0UNJatFe0
	idHwqdAlPblqO6qXrQtFyy1Geu3wudmijM+ozvk4BwFU6RHRF9L7ZhSFaSxyf0CfLdrdDu9exQk
	bGd3wEsH5d5ILb5WPBr8oOmzyrbN0mntKp1dBO3CIUC+7iFwYKxtnYYyb16A62NMjmCSF0FICpY
	1WcP/k+fIbqGDolcNZHO57JM5wHns43KZpAPpWogiV5KgnilZGIJE0V5BZ4hCyZqkXOSnqZk10z
	fT68+omUgfLwJctTW+uul8DGMOMnX0XsOUZvUUdpgwAln9J4zfPT964QzLf+OIDUSWjHPlBKxr8
	vT/HywK05h20TVTrVXNNBGOn/7W6DpPoUv46H7VxWIwot3Bf7nOzCzurup81/fVMGk1Dnxs347+
	0zHraVHybTqWPHoLpO+VNfiA==
X-Received: by 2002:a05:6a21:7e03:b0:3e2:57b7:4d7e with SMTP id adf61e73a8af0-3e359a4a06fmr983847637.10.1792738938947;
        Fri, 23 Oct 2026 00:02:18 -0700 (PDT)
X-Received: by 2002:a05:6a21:7e03:b0:3e2:57b7:4d7e with SMTP id adf61e73a8af0-3e359a4a06fmr983816637.10.1792738938254;
        Fri, 23 Oct 2026 00:02:18 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:02:17 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:18 +0530
Subject: [PATCH ath-next v3 15/17] wifi: ath12k: Derive QMI service
 instance ID per protection domain
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-mpp-bringup-v3-15-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: T-rYhL9EOE3xP7j1-yzZsJC6sKxvbobU
X-Proofpoint-ORIG-GUID: T-rYhL9EOE3xP7j1-yzZsJC6sKxvbobU
X-Authority-Analysis: v=2.4 cv=dphOmFg4 c=1 sm=1 tr=0 ts=6adb067e cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=1lU9L7Y0PnsvXye6yGIA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX0q8mV9WYltCF
 OjdEE0T5sYyALd07FJOI9GTIbuYzF6LNCdDQzMJ1ybydoaAiIRJK+3BXml07wFyKu2vzZLGa2k0
 GP0r+nqrXKE/g0Cb8F1IuR4lNTs7Md4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX7pJ/79Wkm85s
 cqCBt5QJNqphwoigePOU/GRDoWya4rATtBqFuE3SayWNWGIuJlaLNWbrBoA/Y0pMMrYgjtl+lQx
 0sAMEBE9LN8kyS/qSuamLpGJTh8zSAVz2/+4OV0NMsLO86qu1ytO4dUvYY+8uh/4Yl3SAH/pE8U
 ehPCq+chQDn5koUu1b9f6ZiRYskxhlss0DcVsu7szI3h+5WWuR4AaEos/yXZAyfp9ldfjHZ7+aJ
 VJwAJyKhrNxDWa2tWsItcjVlOO0iLXD2bXp03ab6H9zyNjtXE2nU5vhX2Yp5EiInwHAus5wP6wN
 1dc4T9YHBEsrSMtkFuDtt8xNTZ283/mBqO2MO6yD4oq5JcPHd/Yg8T2TdDxjQuEGHe7cc18d/ZV
 J2WQr+H0kS9gQ+9ImalDu1HF3IVHt1O/hVkJ/1Iu4g3kH/AOBwZxQX4U9AB0QgVw+08MjcGT5qB
 5xxOm6rQToU9TsF8Leg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

IPQ5332 platform variants are supporting multiple Protection Domains
(PDs), each PD exposes its own instance of QMI services. The current
implementation uses a fixed qmi_service_ins_id from hw_params, which
results in multiple PDs sharing the same service instance ID.

Update ath12k_ahb_init_qmi_ce_config() to derive the QMI service
instance ID based on the user PD identifier. Offset the base
qmi_service_ins_id with (userpd_id - 1) to ensure each PD gets a
unique service instance.

This avoids QMI service instance conflicts and enables correct
operation on multi-PD targets.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index b9ec14e86def..cecafc12e8a8 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -567,12 +567,14 @@ static void ath12k_ahb_power_down(struct ath12k_base *ab, bool is_suspend)
 static void ath12k_ahb_init_qmi_ce_config(struct ath12k_base *ab)
 {
 	struct ath12k_qmi_ce_cfg *cfg = &ab->qmi.ce_cfg;
+	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 
 	cfg->tgt_ce_len = ab->hw_params->target_ce_count;
 	cfg->tgt_ce = ab->hw_params->target_ce_config;
 	cfg->svc_to_ce_map_len = ab->hw_params->svc_to_ce_map_len;
 	cfg->svc_to_ce_map = ab->hw_params->svc_to_ce_map;
-	ab->qmi.service_ins_id = ab->hw_params->qmi_service_ins_id;
+	ab->qmi.service_ins_id = ab->hw_params->qmi_service_ins_id +
+				 (ab_ahb->userpd_id - ATH12K_AHB_USERPD_ID_0);
 }
 
 static void ath12k_ahb_ce_workqueue(struct work_struct *work)

-- 
2.34.1

