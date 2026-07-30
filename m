Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E083876C5
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427250; cv=none; b=TAF9S/HGjff8ibuPOtENlKXoFpO1fvX+23pIb0R/DX7ad7kQDBQ7eCWmnVmeFKbERhLLVwY49oNu3JrvqaC7VW7oPxeSNhgeJhI+QORievzk/MXGNqxayM6RHyjnwDqxMD9SZdwCt2s1vLUu8M44snSoCad4z/OEctaRKvGkgwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427250; c=relaxed/simple;
	bh=rFLR77CJJYP1sKLFQ6gl8hLWfcBFJvASp2MjESWcdt0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iePG+x5wbJkvqkXkPCoygYP5wQQd7f2CH7zyBCWPZvBat6qsQS0l856+C74YHF+kupD4K1Xwu7RLACq+PUI4MxRcz0aDGMMNZXQIOJCuwOMmbQurO/gbw9qA/W5ip9Nz07BXd65Fu0SFnhkWxNrA57TUtB95E+EqTRAUlnoUZhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dv93W4+k; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YIOWY5gO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dv93W4+k";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YIOWY5gO"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQoJt731353
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3Pq53qNpO4Cl13XpVwNXOs8IgmR52etnko+i3TUslYQ=; b=dv93W4+kq74ezcsn
	PoGGxoSG5/baz/ImVuFoETwH6zagLZ5tCc+ntmZUwNhu9mrDn5l/aWdX+3RqR09k
	+qqDCr4MUFHFy2rPZp8wG4vW3hoQDx59OoBFCBpp69kYIrO8bHxv/0uRi1U5GXdv
	Ugw5LFDYcP/hHdAAxrIGONk2mCitPtV6mJXd0G5bL21EoMh6yhU+rkt+32uAL3GO
	Dx7bQgk3HLRrtq7QxCpVI8QG6nyEWp9k4X+OwJ5slZ3KmwCUAiAv1GCKNM0WAkR7
	cis9ttgsPcKrpB3KBWV4g004u3i7whUdRwaCue7TVmdnnOT+NKRa3xMNbpUtrbcO
	bY0fdg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8j7rf8w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:47 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51a8b0a08d2so19749961cf.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427247; x=1786032047; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Pq53qNpO4Cl13XpVwNXOs8IgmR52etnko+i3TUslYQ=;
        b=YIOWY5gOzu1U/uDhVWwIJmU2+KPPSYcjOiWij/RYVyqK9yat2kV1e8x1y3USYhLEIX
         GQlAbhiOWz6s2GXrhWD9630pPMKKxI2xXWLuk8AIGn5uKINEviPnvXFIbzI2rijvxOZu
         4d9AcdaSk89aB3//sBviWO3jKRtZUXs4eBN8NSkTSrHwiBD/zzEbhTpNOhclQfslP91o
         uxil1kW2UShaxlPUxSwuvBBZpmt5F1Gco13102Io2TYurq/lQWdfc3c+k4REW0jbBnkc
         cHZek+9jBjqqLfRYAC+bCMsguOyU2oEUg0wEM5SXbQndaXJR5riWEW305L+sgdObHmfN
         GbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427247; x=1786032047;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Pq53qNpO4Cl13XpVwNXOs8IgmR52etnko+i3TUslYQ=;
        b=g8hiL5n3c7Xm+f12XorNB182RiPi9SsAm8jnoPcXyL4vKiMOcCS8k1odLw6rMlqLNR
         28F6WYbC1+c1O+fqYAhzplY7GdtaELFtRnSasedVpz4cNYUy7EWWv+aKURxH7+r96+LH
         RfmnOyLSoNpQAH+fXhzLO9PFAL8MBxnS69f/m4fk8KLXupxehANrswMcaMUq6PFdv4i0
         WV3DV2prvInXAU8kfVo9UNAzHKtzIVK0RWBZmZj6zithxXR36z4Hg7QpvVtyY95tK2S/
         /AHOv4rFKiG9KcaVo7Sw/JhSR2dk5D3L5dD3PzSIA2nlvhJ1BYbfbzcL6CBjg+j4BXci
         azgg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6bpL97k/TqrQVXX/8eJYNQ3Efjyok0ee1rV8Pox9aA+ITRZ3OVUsrkj+EtoigacUQf1t5j8RIWM+d2P/T9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyE/FlsIHWS3iIfremNacHVkPAhYgC65XTk+kO0eOcB2xk3Va8S
	Onqx9tcFf+Ncof8C70UOlA/L+7iqB5R4EuIVU198Tx6t+mx8D1AeIoDrGcwFPSEVRR8C8FIJIif
	r954oMZQfQCQtZZ2u2pUfTClh6C8dWikHxL3pGRjlzU03Q4JOEttT9nqm3QX6qSrALF4fRA==
X-Gm-Gg: AR+sD112s4b69NKpPDl9A0W8SvDz+gg2MRk1+OmFWs07SZSsniVQtz5pTf+DMRvmVTp
	wrL1W1l+0wCDwSxjLTTUnAvuU9TjYfBHGdsBhUD8MVawreq/P4z6UZTLgelO6cMCS1+GvvIEz3f
	5cCcg0YpEppMH5oyW0pb1W+aJzuc1FMMBtkXmBEIl5VGEZ5pAWOE5tFQorhyyHXZhdZKsDjT72A
	hH7i3eRIGWqEPdpnjMACOSv9QaVTt+Cm5tp/59Xa4dydX8PWKtnZt1LsWp99IjE55nMgsVMpya6
	CGBAoIN9wtcyI2rkDn1hYVdc0uK15xP9SdjK7Bd1mw1rR/TONVtnNZBdJzqn3JKoQ3lx+bKp81W
	vLRZjOUmQisdxIP83F15skwWKRab0/Vyx0vYnLCpUHx3IUWQVdpMxkLXCTJSuh5nNYR57ixWKEv
	RUlYR+ecaba2QEQZ/DmwrYlIazkPt1hoECn84v4kNWe9vES2GUXtV6
X-Received: by 2002:a05:622a:511:b0:527:6d4a:192d with SMTP id d75a77b69052e-52b42cba100mr8221021cf.68.1785427246467;
        Thu, 30 Jul 2026 09:00:46 -0700 (PDT)
X-Received: by 2002:a05:622a:511:b0:527:6d4a:192d with SMTP id d75a77b69052e-52b42cba100mr8218291cf.68.1785427244656;
        Thu, 30 Jul 2026 09:00:44 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:00:43 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:32 +0200
Subject: [PATCH v9 02/10] dt-bindings: net: wireless: qcom,ath10k: Document
 NVMEM cells
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-2-f72935817dbf@oss.qualcomm.com>
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
In-Reply-To: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
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
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, daniel@makrotopia.org,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX6pV5UhawtqLD
 R3J8MhCXk01RHmkFhHR5Uh5E2Tn8OJ4kLjstONQoWOAE6nWL0eqzk4IkD+Pe0yh6AqC3o2CiMk6
 lnUVklVMAxQI6NCSj7l8Z2LOciHTXAliVML+2ebMxnAAZso1FtUE0HKQdlOEiMfoAV7P1EHcSJc
 wxIe30wUjoywx2w/N2lPvMjNB+avU2n/mQEFYOiRh3Gy99uJPTBrz3AgtwsCV14KGKlBOx9XGDF
 BhZ9yA/RLGqWJU8GQC4N8NwlhLick/271CWH1JAvsV7fboZW1OzioqVp/g+hEjKxHUGBqu2lxkX
 Jp+XWMfJhE5bec8mf0o26XbkX8ttaalSk1go/LU8iFTt81921Gd5ky+h1UWn3ZHazHLOdaNi3qj
 V/uO+lzxWBSZ8r7jTEDJxPaCBWYAv1XGLICr7i1WnYUd4GYSqYj7fYcwk8OVMMumasKnVvA6yAF
 2QFWn7P4AAPNTY2Ux4A==
X-Proofpoint-GUID: DycyW-RKf4-i3iCsUzRz_1GpA6fq1w2t
X-Proofpoint-ORIG-GUID: DycyW-RKf4-i3iCsUzRz_1GpA6fq1w2t
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX1aqLi591uOVv
 kqcqvdltWmBV0/LqT0TpuYWBOZfczFD50scoaPcBTO+oE/qDU9UyPeRqyOv4boi76i43Ok4JBDM
 TlM0jY+pd2cBJOd2SH67MWis/TxsMi4=
X-Authority-Analysis: v=2.4 cv=LraiDHdc c=1 sm=1 tr=0 ts=6a6b752f cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=Xy7nGJaRzBGhkMsTZAMA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300120

Document the NVMEM cells supported by the ath10k driver, the
mac-address, pre-calibration data, and calibration data.

Since such data may also originate from chipset OTP or be supplied
via other device tree structures. All of these cells are optional
and can be provided independently, in any combination.

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath10k.yaml    | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
index d4f4d72ee0d388f43437fc5a3047f90b464a5274..7f9d16cb7c14330e11ce7d567d585b5e47793bd8 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
@@ -92,6 +92,22 @@ properties:
 
   ieee80211-freq-limit: true
 
+  nvmem-cells:
+    minItems: 1
+    maxItems: 3
+    description:
+      References to nvmem cells for MAC address and/or calibration data.
+      Supported cell names are mac-address, calibration, and pre-calibration.
+
+  nvmem-cell-names:
+    minItems: 1
+    maxItems: 3
+    items:
+      enum:
+        - mac-address
+        - calibration
+        - pre-calibration
+
   qcom,calibration-data:
     $ref: /schemas/types.yaml#/definitions/uint8-array
     description:

-- 
2.34.1

