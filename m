Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9D544839B
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427253; cv=none; b=K+ID4zfM5GZjI8Q+Z+oBIRCYaZfQqr2ctE6LI7o/Fn+qmLnB+lmYzcZulWe+HlQ4ADB9jcsJd5iQI4nHHe7ZTmvztRmd1YyzUhbnsTxWX+mqdiyxxfknmfKsJ4+FklKiViCaAYOQd6cZIeHK+NVZyetbA3x2xJ5ksWX70g6MSMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427253; c=relaxed/simple;
	bh=xh4ucig5hPRkaGw1GggCAwEU1pqdfnGTPbj3vUFpt5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GQ7HcNrNrFF7Q/27UzwqaFLDsYGaU10smKxld2OntB6blcMQvs16FllTXuVxTY7mmEz9ZFjrciKo0J4+hBypTuuoQLr1ktCFmif0SpYkHTopITxL6EP6V7KxZ1HCaLQxWMQAsJaC3sydqyYSQ6oXxS6YW5b6iVAZTfKsAVr4Fto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Mdc2lZTP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f995O6V6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Mdc2lZTP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f995O6V6"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQksT1680374
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=; b=Mdc2lZTPtt0S03NT
	RZN2LLYKd+6xXhFCtur9/pn9KUxEL/qAs2gSangnk3Eojs3/CX2/U8oIu1o6fKhC
	XroQfXn6jyxAvPOItfTXBxB6a8IEK4aVhaevupkro8jYPxWKsqEiumETD82FoNCv
	zojIrPoVqqom+od2/ljgKcP6kfMDX5SNaauAqJvwDWm2OmxejTT88jaqRV8dhhuA
	+pBxJQKtP7NAOOE4f5RoZyu1f2FUpYzK3pNhCbkmi4s+mx5iJ+i1z3qg4IrYqyDX
	v4V16C0fVnXQTebHonIJ1OlzTzv7K4oWtrb1v6u6WZahOxMwVdixSMnVEx8rgQet
	SXIImQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8gy0fps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:51 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51a8db414c7so34147521cf.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427250; x=1786032050; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=;
        b=f995O6V6+l0ZkTnatqochmwWKk2TqvvIo25KbncSpPzX6vAL/qZLk39A3xv2u8la/i
         Zt4REh5JjVxWhTeNByDVVqZ76ylrsJVeXnjeCS4j4PIchyKUCmJ+IZqvQiaVki9tA5vs
         HulSow84e7BYuovTKejSUnOYW0HCDhYGrJaU11gKEX25pLeJWIVweKHTJSg5gYY7WCno
         EyAJsMM2Osl7b8ThXJn93hOjn+p0mCtzphUju/vHYE7MtINnLm9P4bAhMP0UeL2pk85b
         MbkLiE/HGRX2C5cJg6HrtjH8txlroZh/wFvMIMilqiHs/ZFy74Il+6YvwFW7nmSvNAS0
         SuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427250; x=1786032050;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=;
        b=bQmYgnQYWe0SiM5wflugPmJU47YqWg8eTRdAPjPCD6sq2orx9ojyykn1Vazx3pipIr
         C23r+MwNrcAXQKFdVqC8bCABfPm6fLA+PgbZyIIgg0z3Tx7AhD57trQMj1VkqHBgG3zN
         m7JSevydwoi7LcFjtjURSdzyhiJQt6ZzbhCrAGC4WNSa0H67ulK0BjIytGJcUlP0XgJb
         umgdStZHYcu9cWpmaKr3BHVHXU8/oJ2exKVITOAuT/KFgdsNnp/sSpSRCAGudkETlw2e
         Ex74VAWrKscd0CNLLyjpo0ksTIqTM4WsNFXOLr5bJvsB4qrWe5FzZTW2qg6cUsH4vkZS
         MWaw==
X-Forwarded-Encrypted: i=1; AHgh+RqUWVtPQnWbpYtKE771SXU6I9KgrSsh59edFeKDn/yFDdKtsTzyXrdRlwvwZE3RSsOST0b26deZ2zvppj9PlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YydfIvXzleS230H7FkjzNgc4a6SW5crW1488JNNR4PDsUiQWoQ6
	6LCKRDsg9eoNKLNm15Q90Cn2aGXKb+jPtZcDyAfckk06/43SKCTjcAz+Hd7kSO2GjbNQExWXL62
	tUgbTq7uQ0cLf6Y+dzzC1KWly+NSA9+6OFhOqNJFuNDWqTguF3B9PJmKdToLWe8pwRCIOkA==
X-Gm-Gg: AR+sD11FU+OsUBlnTvpzFS0mK1ui8OIiXj++HHCLU69RloKeDyidx3EyF65iZDz7Hlc
	bVCZYPhiqazJHuOx7bi9jwITxsDdMZs2NGLuyJFzZzMCVYnmJ3XOd1zsqgVQUuMKIYI3ZhSWJpR
	jmwoL/A/BlpM9HOOs8JknAN/Cvd+o3FcZxDio4Q8NpYSo8Ltj3MqYTp3tH4EdrwJAjvTeui6yb6
	2iDt/MBhKE8QdjhWNbeNXAikNmG8ZTsTt/1i/CsgkI3xpydGPV3c+aM07Yu67RfgGzyHrf0o6oh
	5sON7VVVqJUumP/owSzU5FFtP71FeqgVA9ViO2KX+2Vvrr0yBzxhOcZL8hMfcVkuXMXD0vCdqko
	paCo7TegOt6Mb3UpTz2m4Xu9FJJTxv+irwXyeKq/voNt48b+WKTGuhktiNyOltUUu79YST36eEb
	MaqPehzYKTaY8CfSUAE6eW4MF4dRSKz1UFM75S8A/2V0NLsTdXFS0e
X-Received: by 2002:a05:622a:1e12:b0:517:736b:e0c2 with SMTP id d75a77b69052e-52b384c7d14mr37919861cf.27.1785427250199;
        Thu, 30 Jul 2026 09:00:50 -0700 (PDT)
X-Received: by 2002:a05:622a:1e12:b0:517:736b:e0c2 with SMTP id d75a77b69052e-52b384c7d14mr37914671cf.27.1785427247300;
        Thu, 30 Jul 2026 09:00:47 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:00:46 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:33 +0200
Subject: [PATCH v9 03/10] dt-bindings: bluetooth: qcom: Add NVMEM BD
 address cell
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-3-f72935817dbf@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: rU9-JY-Day1gxe-BWyLjriZugYj_Sn3C
X-Proofpoint-ORIG-GUID: rU9-JY-Day1gxe-BWyLjriZugYj_Sn3C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX4DcRVIk1FkDD
 9U1Vfmbl59AMfnYS8/CjkQsPfNodyhuDVnU8UEB/HS+ZhpHRd4UpSjh0CrHkhz3eXphayzxmryj
 j39WAUQ+yz0NYulQh3pRcCgRUBPl12CnF/zCW0uj/4nCRQCFVmawZMXXdEIleAu88FYQS/qRZ7J
 ejXiiYzShSd5pIre7BYDNdV4oMSK+0st4blgCIArxjYZO37sSdoBbXG5r+GKGxqLihGfdpmzF3N
 7j+lsj6nL2UkmhMtHgjq0718eiVGnK8ImwFLT9TK9PeUHOCwq+tOtJkjo8BS0yNIy/qNutMJKzD
 gKWlG61O2r4TZgxo73Ng3D3W9+FuK6Macnfm3eNH1+uS0dNqapTCA/N6eEy5NqrtIvM9WVqEWwp
 jCOxYPfDntNGmXfFyyUgJCD0DOeR0hF3tz4acrE/Vb7V/3pTOgXr37Ry/FR71fWjJ2esyU/ldBu
 j9Fr4e8kkbgZfEpnp6A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX+SmwL/pfJsSx
 3i2WYkCc+2ubRc1aJWgLDK/mCaewIwIdj0CjXeFxRaGSIT13zNs2I5WCcBNMTlWb5A0X+W1dNs+
 nZ4xUzAGkQC5HnCArA1D0nG7ALfTTOE=
X-Authority-Analysis: v=2.4 cv=MuliLWae c=1 sm=1 tr=0 ts=6a6b7533 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=jFERsaRKWwo8c2z-USAA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300120

Add support for an NVMEM cell provider for "local-bd-address",
allowing the Bluetooth stack to retrieve controller's BD address
from non-volatile storage such as an EEPROM or an eMMC partition.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 .../devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml b/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml
index c8e9c55c1afb4c8e05ba2dae41ce2db4194b4a0f..7cb28f30c9af032082f23311f2fc89a32f266f17 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml
@@ -22,4 +22,13 @@ properties:
     description:
       boot firmware is incorrectly passing the address in big-endian order
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that contains a 6 byte BD address with the most
+      significant byte first (big-endian).
+
+  nvmem-cell-names:
+    const: local-bd-address
+
 additionalProperties: true

-- 
2.34.1

