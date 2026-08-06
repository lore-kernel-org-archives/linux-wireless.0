Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704C047A86D
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027140; cv=none; b=ljUV1wLpooQ7nfy9L5XUoAIW4C0BwZUvQHfDSfkmKraXDeClqyqUbcJYn7EZ8qsXD3KrORAlR7Pa5q8mimP2XePv7JIGFMomWquFwz91PVs3Wt+Adr4kjptlSyFv4bTUop3r/9h0Z3BnvcV9/Iqsd/icmQhv0GewIfnAAXDRY78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027140; c=relaxed/simple;
	bh=xh4ucig5hPRkaGw1GggCAwEU1pqdfnGTPbj3vUFpt5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jAVH+A4BiFsITYFuDH6Egi40gu64aY4P4hMYHgfniWgA5MkwTm1oxpRyy/+eS1tRkKFYlkSC4fcixXCT6hhR0g5lRrzYZopDOvNC8IUclQNca8cy/Vd6W4kIZKTKqkMyiEHrSnRFzcujPn6anSHukP9kOKOXq27D7C3j7proeyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d6ElbH6P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fx2dpWx6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d6ElbH6P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fx2dpWx6"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nl681580810
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 14:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=; b=d6ElbH6PPCz9QX/b
	BLbUMMJyIPdBUt6nC/OUVYRJu70FjQUJAa7LpLyG7zhEwsScwo1NGcXiHmzKgeSg
	DYU8w0xqtmCJIWKYgCXBfDx/xfUTJCdzL1u29j6IC+sObGK/yHh50oe8eSIAOlvk
	976M3BEoKD5MoE4SNLDq7BNxKXvDUfxcaK1YJAd6nzdZwvKiZFSXQ9vzebS9sYel
	KFkMqqoT9+O0OtQNIpNFVm1w692AacBXnc1bZO2Net0oojLqeyRhN74XIV1ZKHFG
	Axe12rUOHhUNYN1nxi/bgL7bUO6lLRce7AcRCt7F/rgvB/jLDwlU3Zyh+00QU14W
	HuUzJg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvmrjj8nn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 14:38:55 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e52306621so217812685a.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 07:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786027134; x=1786631934; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=;
        b=fx2dpWx6Ffu/uTDPCgJSqlfPHnGG1eN3KFQd6nA+4fyZFOsBVdAgkw83aFZeif3AJ0
         MuJ2oWCTWEQMeofGa9C7v2WQr5wtDON21MiruUOqmoHyx/ITIhiW/XztE3eGtRASRuSZ
         M/FcQyIIYXT1hNuvTbIM3irO+h3CLPqmU6xSbC++9Z8J9yx2Nws8p8k98W+zthfU2WQ+
         BQbFyxY8pOflaKkqn8Pb9Zw9t0+gjsymdO4nslE34xgInuFchglxWMLmxyDe94GxNmB8
         0S16i0SvnEKUfzU2JkEabDIKa/B7eKore6sL3dTQbT261cA3hKCRRSZQlpeEDPoz9yc5
         ge+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027134; x=1786631934;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=;
        b=gvjj0ruUm1Vrctdp9OTcaBMCC2SJlIFhNHQr1JKz/39BW3Y7O59AYQOK2fKCF1Eorc
         gsMlu2eQkoHGVXQkVTH29Wz9pa2ebpXljGSWYMomvn4Z1gqXx5eGttrUNl+0eU7UWh2t
         JlwlIxOHSOuREEZv5SdRSjDPbjIoOTOq+PShfrrox1YpHg482gMdaVR5mhj8o21E5jVH
         kw2iX6iMOJP3nPm3iAaxc6dkI6cCDajEz8S1nDL7bgEAcIFWsSWlLnUipCNo+j2swYk0
         /1utRTGOB9CLXeuUYfkqvAzJGPMY5VTxJ7IPZDTRz1YpXOCs2XAH/ftc6j1ZmO115d/s
         fddw==
X-Forwarded-Encrypted: i=1; AHgh+RpJAofhY8Fscac+TK5lb07DSzbqssLmhjs9Is2sjPY/zZKrxgwEniXXDEr7YXDAlQ26U+FXLcm7HDKcnk0oGg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2H11emvUaeAvuRw03wRm1ArePcLnp/sYIVEhsyHZCE1XUhBMA
	vQakkaMGXnn2b+H7XNoZQxLH1EJbwbwkCuNRM8rQAWjb/G/Bkph4V7OllS1hnYF+CbHV3EkVJSn
	JE3P+8qLts074otOxmF+WAtPMxtrBsV7+Ygj4XPWIhpFNg5BVJ/folPRePQrqI42Ct+k7qA==
X-Gm-Gg: AR+sD10ss4cWWYEEAfT7IAuAXLcOEnxnbcbo74+B6mJ8D+tGkkuam/smPpoDNoPC1g7
	SBjsaxqMuWYEV7YZeCiUUADTPiG2tLtlnwI9Z04gyKLbnLIPn+jDuxWwKolj0JUbqcqyvo3OZTh
	u4H8xSPccH3cXPgs4GDIS6Nww/C6A622HOQRc+pD0nVrH2D4tmHu4/KWasf0zWBU8ITitLM+iJp
	VN9xsdlCoEDr9mqyqO1I93wztV+oVBd+f6UWjTNrnnNV1eYZq9ehvcLu2olBki8jrFSdwP1WZ6W
	ER4jn49jZfRXeBzhRhDeXdzp9LRWlLub57FlQxsepHjxXuxVc1BY2e3ehYohZcLMfJPi/3Lepyy
	8dqjWEcuz7fAkYvDkJmNNzL6yKhbxtCPjizoWR4lyvL4ZcfK3fqrjTP5t6SMTzVaUsXI+P1JVNn
	B8YFgYIrYKGFVPh0c519/EqMcIx0NdpJ82xObTMsvqsFZCctjRRQ==
X-Received: by 2002:ac8:5cc3:0:b0:51c:1532:ae93 with SMTP id d75a77b69052e-52ce6146122mr164305691cf.26.1786027134350;
        Thu, 06 Aug 2026 07:38:54 -0700 (PDT)
X-Received: by 2002:ac8:5cc3:0:b0:51c:1532:ae93 with SMTP id d75a77b69052e-52ce6146122mr164304391cf.26.1786027133693;
        Thu, 06 Aug 2026 07:38:53 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([90.85.108.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036276e58sm270552166b.28.2026.08.06.07.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 07:38:52 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 06 Aug 2026 16:38:36 +0200
Subject: [PATCH v10 03/10] dt-bindings: bluetooth: qcom: Add NVMEM BD
 address cell
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-block-as-nvmem-v10-3-be598b2a5606@oss.qualcomm.com>
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
In-Reply-To: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=VNPtWdPX c=1 sm=1 tr=0 ts=6a749c7f cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=JDRa4Jy4r6/BpSpxP2cCow==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=jFERsaRKWwo8c2z-USAA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: YhMN5YQ_OEYIl7podPDk3X4e_Of5mrq5
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfXwIqF3wTYiAaQ
 jr+V90W+OeBE8QGFBpXhgUuydViwoOr21b474YmRh2UGaGq8hNciJOvqrvfdrUaDuYv5XQifxTM
 OXSPRvhhHWyg4e/olmJ9PluDgwUEIQw=
X-Proofpoint-GUID: YhMN5YQ_OEYIl7podPDk3X4e_Of5mrq5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfXzFuYlqJipAbd
 2g0Gw8mrzTEcoRE46HLaWcXgLCurT9LEfq742h7P1X+85Zx4c1J+QRympwBArdhnSN7JwozYCIM
 MUxqBZfR/Mp/lzqJukNA4Lfz3ZPr3EpvBjaM6yhXtF+Mh/9yEejLJQNtun24e95z/PIKj1R94z2
 soYIj/tJICSlRmmoAIaIPNLMWSwv/NLlI4BRRLsdZvaVQc5mspNuuv6mhinNKl1pozk9jC17s3K
 1Zhx7N9cjEIaNBDKJsCNKxda9ZREye8mYkDhbdKcbXjCmIAnkidQEtF0AuBsSm3W22j3GMS1MHc
 6ZECzZYhj4WmzqeXn+HZkWcvlQk7rbArp2KCGwYoTPcoFm82uFfCrfE0K332V8KZyQeSqyvjbZT
 lrPe/fAdJXD3OZZ13tPgxff9fDRb8fXgIyc9uQ/8p2xC3OY8FqeZQ7x2S6OYX9NoodcYw8RnwLq
 aWzfAcVn+yycmYd+vOw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060114

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

