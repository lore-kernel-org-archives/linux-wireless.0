Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738881;
	b=DS/jGVbuZKBevzTqqxjKkKKyJ61BWF1Zf6t+fsJjIE9mSe10+jxfQBSkCr3JItGr/llR
	 tBCw4ncTXckJqSdzyKvZ4JXo8KfDqMoeYB/gHNhK9aNS5c6pQ6DJsVhJCCcTvxIAm/U4M
	 dvhWwveXbMIUmQDoret1608Vp4pYrhUt6skOJqU5K2o58QlyJrtMMZauT2WUz+MUImYIc
	 fkYBTO8r/oEItnWjMsEKgmLXdbnYinoobOfV2KoHIw29upT21MZ3Md3vzXM4sWQFmYQKl
	 gl6x/ZXHi8gUkYA3eSF5FL2VUqOz36tr7MJdQHSvI8P7vuHN1j8nW/qyff0bYl63ynA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738881;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=AACcgwhYkC3KUc2WR3EDrO9YGPVQuZ9/nNSNkiIADP0=;
	b=L9tAajv8TQDO/RjUu21tqRjll8H8p4X+63BiFl0ndxSCUqIqiqxgxEdvPJE7hev1eUyx
	 FrrgKX6IsHraqxhxp+IKFmTySC7ocpoxApHPydCMe6MYxjiivOTdzgdj3mCxOZKReHcLf
	 8oi/HwxfkfTHgJF6EF6zKmHIg+qTd9R0c5xwQD7BfOekJ5qMDntAUboMgOwQcewaWcGqb
	 dRY9JVrA6W78y5yqUoohu3pFTpVnnirvnwigKTa86Ffil63CpRpnTAJ1aF0DlfmTkdc3v
	 cr2kcSpBtpGEdq6G/TTF2gonqCVme01VXbPiQyTqQuRZQbemy3X20Ndh7d1P2wA/FuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C6Pg3Mau;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Y79/S83c";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8DE606A333
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E8DE606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C6Pg3Mau;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y79/S83c
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1EsN1772842
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AACcgwhYkC3KUc2WR3EDrO9YGPVQuZ9/nNSNkiIADP0=; b=C6Pg3MauuJR9m3Rg
	nM7VfMaqEJnktOK9ECURmTXmZwy1qnTPK/9EPKAV1PD13LVVc/Phq8BW8a6P1z79
	1uqInJF79LacbA+H0OqSa1r2RlRE34e0ZYyUPNcvnE4cIBo/Rpmu4urJhiu+eHBV
	Uw2GQvx5DdasfZmtwgDWEOI53T1yOO5b/nE656qItGg45sfQsCu+JDIsRg8h0pnP
	qe00nF7XqO9EM1Q7LmpO2QAYnpoaJRYIKuFbb+rpD4Xf+iBLEvi+TbNXobD2hv5K
	74Bh78hlIxnofyin7/AUFPbRX1GzPBTGTR/PCrM/81eIFsRV18TSbC7rpVRasjHc
	j9bxpg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmttbkb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:20 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ab7f1efe5dso1117358a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738880; x=1793343680; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AACcgwhYkC3KUc2WR3EDrO9YGPVQuZ9/nNSNkiIADP0=;
        b=Y79/S83c+Etak2JGKrCtGIHq1Cc0wM8+AsfXd3r1f/tGAhdKNQ/ONNsCEbcI+5xQLl
         HEoqI/wCPPUfYpMBFgiWCjlYqy4Ce/ZDEsvvnRLvqQzFfLhMb33clgOgDb0ymEltrrxB
         bPOb5Kd2/FyN7wmL2IYHfydSSEh7raBqLzbK+G90Wr0N2WBYwV6ypyzUFtM0+17kuirv
         n86la8TupqytR6nDDQyDhDAgbErDEzBe5+0OWsoutLkCKoA6dXckoHFTFg5ywqlRoJxT
         TaEKwQbGCBfFremg71QrOSU/NvBMhOvaAn4+mE/woO43FHmxYfENUgmZ0lrp3Hkul3Jr
         S74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738880; x=1793343680;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AACcgwhYkC3KUc2WR3EDrO9YGPVQuZ9/nNSNkiIADP0=;
        b=UefFYCI7zuZSJCBfoZBLSEkNZPNzZMakD8yNVEQJkq3sJoUMtMaEJ2Ztn0SmeSB/4T
         37rziyC3uws7tq0kD0vs22dUuyRod8Aii8lGHPAP34lDbxPJwXZp9bo3NihrrW9oNmjr
         v+QmdcYPJcskwLGch6Q/ox3ET9qHeRfwzZRj5pDcH3RvdT00w0lcqfNAinCUT+giZ1lT
         uUC0SXQj20gbcYIy/2+r50ibaXjx2z9xmvu88gW4pb4XgW4SGVEsxIvgBO4zS6ut/XFn
         zzZK3WP+p4VvI1+NU5tUWkk5uXLrVjLZ+Im6JvePSsfuap2cmXeI7qxJmZRAG03wJI6z
         jWsQ==
X-Gm-Message-State: AFq9FYI7HRuh6/IUxLv48SHegZHSOFyQYv3tzDtKKinc6OCgc/sXGjeQ
	RAA4/HIVZxpIwVGYOC3acNvr/cRyoZxHCrD9Szn/BQWPYZSYQgDan4rR30jntuf5wChnvoDV5b5
	fjW/aGXebDrSEkAWvBg87o1POVPgy1NJtzAIDhAtZcIucuf0MhjMdEjAEHmYrBzH1VcsxnQ==
X-Gm-Gg: AYBFou1oqsYMKFB3dbvRuCuCmr/5jnEdcn+p0sXnYPPKkBSlTTTwGrDrLPGN6wc3Dth
	qIUl5csskNe+A/GJRfnaobuOs51TYnQPwxC7wF6nphtcsHVq3kFF3bFmoNGf9iJn+RgTy2Yw9wL
	LM28djJnLl1OLr+P9Q6lXOp64XVhxwyJtioj+Ia5HzVlRGwXO5vYSybCT+Md/PHd3s5ksd1KAzJ
	JeKfbE8xx3uj4kX/1toi6HBZTb61BI58OSG9rGU2NUvbi5w9Ht7Zde+2Am6R2MJcABYfZ3TJTF4
	YQRekaFjaPykXBeJk1W1JYkT/rYAAIHPmgZUfZWeqxYfPoK7ya8plO0OfRJC6JsK0Pt9XQuQa2x
	RVANnO019HNCGD7WRelmUi/wSKWvTXeaEC+Xl3axT4eUokMOVSsh8JN0rIP3r4Q6l2WqmH4CxQe
	nn7HGYT2QRiPjYwUD5qWFcHw==
X-Received: by 2002:a17:90b:17c5:b0:3ac:86a0:5766 with SMTP id 98e67ed59e1d1-3adce0cfd32mr1195290a91.63.1792738879286;
        Fri, 23 Oct 2026 00:01:19 -0700 (PDT)
X-Received: by 2002:a17:90b:17c5:b0:3ac:86a0:5766 with SMTP id 98e67ed59e1d1-3adce0cfd32mr1195233a91.63.1792738878394;
        Fri, 23 Oct 2026 00:01:18 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:17 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:04 +0530
Subject: [PATCH ath-next v3 01/17] dt-bindings: net: wireless: Add QCN6432
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
Message-Id: <20261023-mpp-bringup-v3-1-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=Gt3XaU1C c=1 sm=1 tr=0 ts=6adb0640 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=gEfo2CItAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Zbx1xPUqErz4vskW_SEA:9
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-GUID: 6awVTnkYMhqSErjvHjRTKqVoLyJdXUOj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX4H9SsYRXRm/f
 NE8Nnp6p8uloBYhrMGTxJmS5gQVoZkUhNiVHA5I6yrg68SLj/RswmcZQhxUQchCTcOCo74rqwYr
 wt/Xih6RXfJ31tQgP3CZ9XYTB2e1Rn0QKwS48tvl/IYEs1vuF8tNGhsfpReOE/M6sp/hXxXnS3P
 oG7baerLMQrOGGJXHdRFAxjQBfVP70ZvqhAK57b2zX8vwBBnIamfN73lUjkhMPaXHAKNUSerY7s
 JUXlJgYQYWPWt+wxMaLKTCRlB3MgivSnesQuO3ls6jU2pE718x1Nb54krVybAu+rfPmDVtMc+jX
 /I7a4iFiP23rAAR4A7BgRJwXoOtX7Y5W9JStZx+X8scpJfVzXzXYBcc8AN/oJ0ppQmTr3535Va5
 X4IaAhU48XNPCG3rCJNxYYZaGuRXlHANDttrCfq7iUcWnGcLiohxLPzULzJ4YnNWtg2gH3rnYpL
 5tx3mt7ERdB7BP51iuA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX0Xby2FqFgQpm
 vr3OmbO1dbmirMWPEJHLoSA0821Y2NoO9d296g5T8UYPR1itOiJbErC92sn0Kfh+DmEb8O3o9lI
 xQCDyCAwDEswMfKywrr8mJOOy2gpnv4=
X-Proofpoint-ORIG-GUID: 6awVTnkYMhqSErjvHjRTKqVoLyJdXUOj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230027

Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
wireless device.

QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
platform device, even though the Wi-Fi hardware interfaces over PCIe.
Document the compatible string and the resources, including the Q6 remote
processor phandle, MSI interrupts, SMEM states and memory regions.

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 .../bindings/net/wireless/qcom,qcn6432.yaml        | 149 +++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432.yaml
new file mode 100644
index 000000000000..96e164620574
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432.yaml
@@ -0,0 +1,149 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/qcom,qcn6432.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies QCN6432 wireless device
+
+maintainers:
+  - Jeff Johnson <jjohnson@kernel.org>
+
+description:
+  Qualcomm Technologies QCN6432 is an IEEE 802.11be Wi-Fi device
+  associated with the WCSS Q6 subsystem. The device is represented
+  as a platform device and uses MSI interrupts for its Copy Engine
+  (CE) and Data Path (DP) rings.
+
+properties:
+  compatible:
+    enum:
+      - qcom,qcn6432
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: Fatal interrupt
+      - description: Ready interrupt
+      - description: Spawn acknowledge interrupt
+      - description: Stop acknowledge interrupt
+      - description: UMAC reset interrupt
+
+  interrupt-names:
+    items:
+      - const: fatal
+      - const: ready
+      - const: spawn
+      - const: stop-ack
+      - const: umac-reset
+
+  memory-region:
+    items:
+      - description: Q6 memory region
+      - description: Combined firmware data memory region
+      - description: Multi Link Operation (MLO) Global memory region
+
+  memory-region-names:
+    items:
+      - const: q6-region
+      - const: data-region
+      - const: mlo-global-mem
+
+  msi-parent:
+    description: Phandle to the MSI controller.
+    maxItems: 1
+
+  qcom,calibration-variant:
+    $ref: /schemas/types.yaml#/definitions/string
+    description:
+      String to uniquely identify variant of the calibration data for designs
+      with colliding bus and device ids
+
+  qcom,rproc:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the Qualcomm Hexagon DSP (Q6 remote processor), which is
+      utilized for offloading Wi-Fi processing tasks. This Q6 remote processor
+      operates in conjunction with Wi-Fi.
+
+  qcom,smem-states:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description: States used by the AP to signal the remote processor
+    items:
+      - description: Shutdown WCSS PD
+        items:
+          - description: Phandle to the Shared Memory Point 2 Point device
+              handling the communication with a remote processor
+          - description: Single bit index to toggle in the value sent to
+              the remote processor
+            maximum: 31
+      - description: Stop WCSS PD
+        items:
+          - description: Phandle to the Shared Memory Point 2 Point device
+              handling the communication with a remote processor
+          - description: Single bit index to toggle in the value sent to
+              the remote processor
+            maximum: 31
+      - description: Spawn WCSS PD
+        items:
+          - description: Phandle to the Shared Memory Point 2 Point device
+              handling the communication with a remote processor
+          - description: Single bit index to toggle in the value sent to
+              the remote processor
+            maximum: 31
+
+  qcom,smem-state-names:
+    description:
+      Names of the states used by the AP to signal the remote processor
+    items:
+      - const: shutdown
+      - const: stop
+      - const: spawn
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - memory-region
+  - memory-region-names
+  - msi-parent
+  - qcom,rproc
+  - qcom,smem-states
+  - qcom,smem-state-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    wifi@21e00000 {
+        compatible = "qcom,qcn6432";
+        reg = <0x21e00000 0x200000>;
+        interrupts-extended = <&smp2p_wcss_in 16 IRQ_TYPE_NONE>,
+                              <&smp2p_wcss_in 17 IRQ_TYPE_NONE>,
+                              <&smp2p_wcss_in 20 IRQ_TYPE_NONE>,
+                              <&smp2p_wcss_in 19 IRQ_TYPE_NONE>,
+                              <&intc GIC_SPI 33 IRQ_TYPE_EDGE_RISING>;
+        interrupt-names = "fatal",
+                          "ready",
+                          "spawn",
+                          "stop-ack",
+                          "umac-reset";
+        memory-region = <&q6_region>, <&data_region>, <&mlo_mem>;
+        memory-region-names = "q6-region", "data-region", "mlo-global-mem";
+        msi-parent = <&v2m0>;
+        qcom,calibration-variant = "RDP442_1";
+        qcom,rproc = <&q6v5_wcss>;
+        qcom,smem-states = <&smp2p_wcss_out 16>,
+                           <&smp2p_wcss_out 17>,
+                           <&smp2p_wcss_out 18>;
+        qcom,smem-state-names = "shutdown",
+                                "stop",
+                                "spawn";
+    };

-- 
2.34.1

