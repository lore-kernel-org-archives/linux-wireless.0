Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA0753F690
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074406; cv=none; b=SbBOCxqdZgJJ4vYiAUcaJuw1wsJaHFm7AjW/LDb1eOVEMCRx7OK6JbNbz71JKnj/E2M1sF+LV7s65+gQlJErTh+JxnVBKUr3LbkWLTN2Dtu932HlHG6Ij2d0VTTjho1Pd4nTkbK2hXw2LhEBosXBcCkP/MuNNtx9KsafISinq3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074406; c=relaxed/simple;
	bh=7oRRkiyidCwIvpqmvaABEOiBgTKSng/ezBEoQKDR8V8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sznD5t7kbmlobT1L9xF9uxRdKEbGPR5kAnLiITjQ43/3yHRfTwE0SJf8snpg0HCfk9yrJDDvaIJZQA5dnBb6RrfQNeYeDpa8ruq9FytDT9S8tsLjLtS3oCLwExegzbN5jjpJH0hQN75Xmi0st5w/O7XRXIS9Fau3PD+mfvXArS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sogn1RWg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Eb4uebjz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sogn1RWg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Eb4uebjz"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FAPdOn4100190
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nX8NHCdH1mIPZ8Y18DIA0kViNrTV399Gnyrkc+b8WE8=; b=Sogn1RWgHxcxg1pp
	Z5d3c+Qq0Badn10+/9vMC4yk8oGB1T2GgMV+HVF/RGEaiARDbqSQc6+IZ8kU/Srg
	GLK2I2DEsUTqoMlfy8P7/T4NklP6q/Kcq6EKKBeGDQYceqVm1t/V7j0ZaoHQ9632
	EKWx7E5wIt+32amyoGkpGOfKAUzIF1rNnBk20DsiTLyMZLh1YsYACbJlpVBkYG9l
	/7gNO5sshWnNACTslxvYFPwdhK45MjbXkElGzxMJ8FWt/MNrVYb7ecyYi64Sih9B
	W2JkRBskDaJY7IEMIVOBBAVtEYtxllEZ8oUAVcFZQFc3GVN/Emp60S/9+XOS7T2M
	RT1nJA==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haw2r8wnd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:36 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-7cb6dd9d07eso411055137.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792074395; x=1792679195; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nX8NHCdH1mIPZ8Y18DIA0kViNrTV399Gnyrkc+b8WE8=;
        b=Eb4uebjznzcbjSOlmxymYPJ7vcXVF2DGDUljfX3M7VK4FnL6J0HHMGvl1xRRfFoLnK
         KvjWJhU1DnfOIdiIKvnRkG8MO4v//kFWlqUOmRY4bn7pxbh36XhoOZfHYqy3XWfA8sHj
         T1KDO2mVi+64XMa9LbHMOGj2C4J4sCPjhoxxojem3dt888Se9LaOPJppoZFk0Xhs6KEg
         Fp2wN//7bhr6FTWlMFFn/+1aLPYfAexEfyFuBpfKmu5ZqMhZH0roAhZXb4hnBzuJjMHL
         QIg2x/GGTFga62MKRfIobhD5ntZGAL2ZQ7L2gME0OcJyKtCO4C/MufTwOHRg1XuafFPH
         aghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074395; x=1792679195;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nX8NHCdH1mIPZ8Y18DIA0kViNrTV399Gnyrkc+b8WE8=;
        b=qHv+1Kq6rpccvMyxKadY+f7NCTnvBmvCRbeHeUbNdy6UcDzqLiCkrtZi3g0wjn6I1W
         jSz1at83xYRscE2AH+Goa+RxKkgEXdRcbhVyD5lzJ6H4X3b6JI8bjkj60aDwcLQUF2g9
         5fU0Oi9V2Qv3dCshZIW+vXiAQe3wWghZpC+zFVS5sKW+yFjqWBg78tuwO7PDE33kj66V
         P6nHJOJtiWcuzvLTRzMLfl0cijzEtVjTnDy1V9JiI+DKfkQYk8HpPncHRwxgivaZ5SRa
         G+qvrgyVbodLCrpK2/T58QoZ6Uzta4WFuPNINR5EmYItaezrX508Q238dh0RSDEt3qB0
         5mKw==
X-Forwarded-Encrypted: i=1; AKwUvBx5BmImhILlGXGGyHml99AUXsipzahWVJ9dIXN1U5376Z1ntBBmT/2Mi+ggaRLdNcnXf5PqkfMVsniNFx1nsQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKr25ieTJKNJSfnZOtz8GFRBlaxB16yn/i4n+1KTzDhIJjJa2LP
	ZUkYMUuNocUCFotJ+6uHFvQtQD3snZIeaHZVOWuI02zhr8a76LSPKTQTwzBccrAc14j0C6PuC5v
	FTs86A02/AunnL6EODThgJryKR2zHMc/tmWI9o0DRWLEXNCla8QmSY6ixl8mTCIpWzRuxBQ==
X-Gm-Gg: AYBFou1KCsvJ0sfJWAKZSRzpE83WMY3d0NzLFj5zR27kTbJextySbmEU7khsFzh6HBG
	PhpiorBmlYkxspnmVmI+OfRrT7XpYtlx2G+AnpUW8FMtkEA5FtddN9UHg7VUw/J+GWR6y8OpCyq
	3/kJ3R7B03ugBBg05ySyFy8UuhnsVhO4EnSCFiolp6iToBDVVoQXVnUeSwZx+4Y4xkXjQpdNqdw
	3V5LKdC1FNyquzHpIr5JOYrrksInSl1t/ZJyBKu7MnF/70Lp10dXJNvaP0r4z/UfnBWAIcaVdJe
	ZxE/LIzt3a6c/KJRseoZSVzzhD1yh9oKewdSCGKoy0ZFVQqTHdZT4U4rhoIBi1rf13EP179csnL
	pBUBTxv5FFqKeoMjOznKLRX5fXyMj0dZ6lknJb/9NCHwDPEjrI2k6coVtf0s+qF4hyvTrm2v4tK
	63JW7ygv55w/5FxNeiAOOiyL23hHPuTfVvO0OgXVPySwR/xh17HCU=
X-Received: by 2002:a05:6102:a15a:b0:7cb:bbcc:e52 with SMTP id ada2fe7eead31-7cbbbcc11d8mr1668747137.0.1792074395079;
        Thu, 15 Oct 2026 07:26:35 -0700 (PDT)
X-Received: by 2002:a05:6102:a15a:b0:7cb:bbcc:e52 with SMTP id ada2fe7eead31-7cbbbcc11d8mr1668710137.0.1792074393563;
        Thu, 15 Oct 2026 07:26:33 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:5402:5e0b:9ef0:9b5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd6428b3sm69083145e9.1.2026.10.15.07.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:26:32 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 16:26:06 +0200
Subject: [PATCH v11 7/7] arm64: dts: qcom: arduino-imola: Add NVMEM layout
 for WiFi/BT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-block-as-nvmem-v11-7-f890ac74f87d@oss.qualcomm.com>
References: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
In-Reply-To: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
To: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
        Rocky Liao <quic_rjliao@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
        Eric Dumazet <edumazet@kernel.org>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, daniel@makrotopia.org,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX82Xwz+qkOarr
 JZGdj3fApVV/PjJ7obwgWrDVkp1NoEosk3DKCMZvXCV5d2Vj63HZG7IE67dJ4qACPFKMczShVA4
 2Bzi3ttkUFDc3jIIlRqjRjPWAPUgGys=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXz5MhvUGtvBCv
 nrruF9d9gw0mzJNbKhyCndEMed9rMyrM9Ap44zdTNOi8fzCNqSo0WQ04CrN3HAIlOYA2eeJ1xDG
 K2CYqYp7cVS+wnb9C+BjucWJA3DTnlnFfQNfKm6q03hsz5vDlQVuDWREVToGkXVLUAS1IRLUzZV
 LQeLUMS61TjqEiBdEVWzQjgu44Dug0A058XVlEvnEW8KSmHMUyzmGRvVvWZYd6v34teoJwccLnt
 HsAso3abhRXZK9XZkw14OTC6OKJR7QNs8Xzkq9iUb8fOJpb36UO4IJlMCNcxHbX3m3Fvdb9ERkH
 oGpMW5HY/UY20uxL+uEgudqEs8qJrSH31LH7kUqFtqkXp46izdlTD2m893aV3iAvkWb/ut91nVc
 H7S22EDx4zVEtnzlGf1NDfqfNn98/FfwyFNXAdWBpwaq6MIn+z6TcLHLH0KujnYKQGkJAf649jq
 LtMUrSAVcC81fXxsIcA==
X-Authority-Analysis: v=2.4 cv=BNMmP1QG c=1 sm=1 tr=0 ts=6ad0e29c cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=1BEw5LmG3YzgyHxDt7YA:9 a=QEXdDO2ut3YA:10 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-GUID: gDcQcW5mhEYpF7YYr78W7s4vtriNLfjz
X-Proofpoint-ORIG-GUID: gDcQcW5mhEYpF7YYr78W7s4vtriNLfjz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

On Arduino Uno-Q, the eMMC boot1 partition is factory provisioned
with device-specific information such as the WiFi MAC address
and the Bluetooth BD address. This partition can serve as an
alternative to additional non-volatile memory, such as a
dedicated EEPROM.

The eMMC boot partitions are typically good candidates, as they
are relatively small, read-only by default (and can be enforced
as hardware read-only), and are not affected by board reflashing
procedures, which generally target the eMMC user or GP partitions.

Describe the corresponding nvmem-layout for the WiFi and Bluetooth
addresses, and point the WiFi and Bluetooth nodes to the appropriate
NVMEM cells to retrieve them.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts b/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts
index c472e13fceca4eb882a59af3be9f45022a923ead..582542c16f6c0ddd8e6fef3ef6b301ef33c5abd0 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts
@@ -409,7 +409,33 @@ &sdhc_1 {
 	no-sdio;
 	no-sd;
 
+	#address-cells = <1>;
+	#size-cells = <0>;
+
 	status = "okay";
+
+	card@0 {
+		compatible = "mmc-card";
+		reg = <0>;
+
+		partitions-boot1 {
+			compatible = "fixed-layout";
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			wifi_mac_addr: mac-addr@4400 {
+				compatible = "mac-base";
+				reg = <0x4400 0x6>;
+				#nvmem-cell-cells = <1>;
+			};
+
+			bd_addr: bd-addr@5400 {
+				compatible = "mac-base";
+				reg = <0x5400 0x6>;
+				#nvmem-cell-cells = <1>;
+			};
+		};
+	};
 };
 
 &spi5 {
@@ -512,6 +538,9 @@ bluetooth {
 		vddch0-supply = <&pm4125_l22>;
 		enable-gpios = <&tlmm 87 GPIO_ACTIVE_HIGH>;
 		max-speed = <3000000>;
+
+		nvmem-cells = <&bd_addr 0>;
+		nvmem-cell-names = "local-bd-address";
 	};
 };
 
@@ -557,6 +586,9 @@ &wifi {
 	qcom,ath10k-calibration-variant = "ArduinoImola";
 	firmware-name = "qcm2290";
 
+	nvmem-cells = <&wifi_mac_addr 0>;
+	nvmem-cell-names = "mac-address";
+
 	status = "okay";
 };
 

-- 
2.34.1

