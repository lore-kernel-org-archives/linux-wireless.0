Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F3349892B
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455055; cv=none; b=A7Pz5tndWrFfQ0BqfIbqdbjCEZiGPXAnWIta/SXRE+U3IJ5R9PBDQjBOqovsxX89NuoASbxn5sVlMCsZ/v9S0Yzj8iiOfG6+4kfxLmHNfFQVMrQmdQ5q9ARwhHHic62wwe3BMONVRX57/Z0aqfw8Yb35oFKmPfWPCmmmWObZ/2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455055; c=relaxed/simple;
	bh=yjMWVLZbkcI3yXmuSNBVRrgyEk89YUdkkV8MLwaJ9T4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NwayM8LBV7vMoPphAyuJNMEc0QVwTiFv10fpGcOLQh7KbJqw0dBbmSCLK0DkywOYK2A+a/M7M1jw5cAkKseYxD5KXVf8OBjVbnXkti9Py0ViM2lJJ1VjuyjhtglgINexYVLQ6yLKGRLlwnmN6eACFLfOjex0nlk7QYXFj5UJsHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D4pWKd4D; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ol76Juta; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D4pWKd4D";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ol76Juta"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KciJ2686636
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LfcbPJYFIddideSymHcJE0RX/Nsl0L0ARIs00dcSarM=; b=D4pWKd4DhTVWbkI8
	XFp8wqHxyydiz/+/+f22nCxW/R+IOQA/+lQXYmWI4mKTBiGifCGwmb2kOwEqsIF2
	wC3mZgX1Ve5Dr7StMqsI0Fc/5LTDPj/rZHWfLbh/wXBFRa2SifGwrS4ktnEkB/F4
	zP/4tIw0UFKsnzdSQhVRmOdIoszUaisCeSNX05XuTjrX2rFk3S8gmgBUd7dNC0An
	HoqCzi+ljOfX91sUzbSpQTiQ7Cz7AcS5CuSUiijYs8fDioUWQwoMoWrfTBWsvEAl
	LS642/pZbKmutfRfCgKoLmLYn1TFHkDWUkogvUbGZ4RDixNHqB4XEvdHs/gpmc7z
	+B8gXA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe42f3d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:24:10 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e61a8eb087so19442975ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455050; x=1792059850; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LfcbPJYFIddideSymHcJE0RX/Nsl0L0ARIs00dcSarM=;
        b=Ol76Jutawn1HoTj4kz+p8IsnZNEZRD9ilVlqxRwVJuncR574hmck4J4YqIeuyN15Kt
         zqsiGvRKUJNsfJKE+K4OBkLJCSq5enKip0sLGqAaTn2ozDSr9A/1dtnS5bRr3ulawk0Q
         QXdmvjJmA8ZndmsJ5o0Sx+WSrxcMtaUSgPT90tu7Iec9F6YAjwSDzh2n4meFQ6PFTs0p
         N3pwevGEFDYfmpJv+NFDbCNOxQe4ivTQgYs77K2Ejrwrzop4EE+F3CZmciuFfTPh7Xw7
         ybpgP69Z1w6m0XnxayQdsvbUrT1rQWzPMi3wxHoj0OgReDutMllbBgY24hSuKzBy3+6f
         Xo4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455050; x=1792059850;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LfcbPJYFIddideSymHcJE0RX/Nsl0L0ARIs00dcSarM=;
        b=SMoWq+/So+3YIWxxPhWMgyQwPm2381JsanrFCpPUZUM49oK/YEUhkEb8fqxDyL4vYb
         IgaPeVzSCT/afsouUnHWOl0THR0CncFCV+O7lBf5Wmps8H5NruwaLUTKUCzPKMqq+nO0
         xwsNsu3wgnvMMM/h9I7CHTpHN7lbq9HM+Y5qbrQHf+A2cF4pr1Xn74aDFUkYEQR+qyqm
         vdp+lIjRz9aXKSufEBDZiyf8dBNhIgDI/GY5hetildIcm7dZ6UeU7j8IXiI3I2pQ2aFb
         iLFXbW7qtM1R1jvNb5Md9Nj/u6YDtIos1JNXUi6Aqt0TADoEVQ5KjTbslCfnGpWDf3iy
         GENA==
X-Gm-Message-State: AFq9FYKvybvwV/pT2WgRzILWrKcI6CnEqFXdSDotkDAFA6htsErvOSLB
	9+b4DvcEjJGCZUIo20yXEzU+CHzcJVPR4ahBTv75FHSZCNZsh7rP6U6HztGChhGN2xf7R2L1m4K
	CL7QgTF9A0wnynPCP6ubfFCACoqPafQusQKfOvGiQFqxDCLQRn8Han6RpmqH1VwxTJSJL3g==
X-Gm-Gg: AYBFou1WrjvPuX2MA5jA3VxaGn3WmTqH9CMPctGV2N5dsxecyCzj5KfVto9FIG44N6Z
	+zqMLVWSTHz2mY45zWBDxVAL0lhMtJIDUPqxy+1sFySoXalr4xwUMwSs2B5me18h2q46zpkce+M
	JoyXzXeylwjCaOLLh9sZhUG9n1wrBzysQOV2qGuQxf2qExYyE27tLv5h/UK6O7nYDx0DlAEtsli
	ezNNqPjEUlzWj/SqhHm3wAEXvEKLEM5rPTXpJyjwzlf7MxxoQpp2g37wZjoVKMOisBQfZIWV2H3
	lpns8rAwrOL3adZfFkf7MWyC4SaQnoUfCixheIsKVkAuh3egwKOjC2Lz8lCRbwUk/I3Cg8vddbz
	8Z/4ZV3zEbaRAPMOBqpHw8nOp2g48m3IiLnUNdRElivgr/CttiUKpGKoaIR9yiKT2eEF0V098gc
	VDrlke92042g5CN8DGW8moEw==
X-Received: by 2002:a17:903:4b2f:b0:2dd:40cb:a04c with SMTP id d9443c01a7336-2e5ffc3bca4mr44992385ad.19.1791455049577;
        Thu, 08 Oct 2026 03:24:09 -0700 (PDT)
X-Received: by 2002:a17:903:4b2f:b0:2dd:40cb:a04c with SMTP id d9443c01a7336-2e5ffc3bca4mr44992085ad.19.1791455049031;
        Thu, 08 Oct 2026 03:24:09 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:24:08 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:53:57 +0530
Subject: [PATCH ath-next 01/17] dt-bindings: net: wireless: Add QCN6432
 device tree binding documentation
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-1-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: B7CUfIoguOcJVx5GneTXC2KPU6zaI25C
X-Authority-Analysis: v=2.4 cv=AbwkjHXG c=1 sm=1 tr=0 ts=6ac76f4a cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=gEfo2CItAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Zbx1xPUqErz4vskW_SEA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX6pih76h1jrav
 p7CkU9UHgvkgggCKQFM0KHEVcc1QoCR24PkIFFJsKLiS5vf6rMc+3gZZgMe6Ci77e/jOYYmxro/
 2TcBYWwpnU+yOH2BvD9td7rahiOJnH0=
X-Proofpoint-ORIG-GUID: B7CUfIoguOcJVx5GneTXC2KPU6zaI25C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXxD3pBTsLFG7z
 RbRbLMt+qwb6Y3IsZUjOQJtecq5OM9t/7mUslHDu9dD9zNcwnKZh8iMvcn17kKauKpYzvD8ZcC1
 2Q67OM4mLzAGH0Wh6+vdXtUk2wU6alqX52kyhk/o7A6Unq8LtPbYwMoVDAWiyX/oTEak1l9vRY/
 RhIFHI36ZWv/1ytuRM5wVhbgEr0kXmdg3MfZmqkRMyqUsHl2NdQt4vQDpZG4RakwvMVjTDVxOMp
 aLzvX3NfLsUyMYdEgaCw2ct1kycxd7uejgX/Rkgy4nbYvisbBkOlE6IOecGlbZTFx9l5hIauEHI
 jc8H+qoUZGIiokduZCvZVchjCEYhXZA/vtLhL282P3Pms3YGSlTdTpbdh1yxB+juPdfHhNJO0/6
 dXEN/4y7g9nvx6Vp5D2BJTtWtyl421240WNdLafymQIeeGs+/pq9ECQrwn45IzB5Y6Gq9u2x+Zo
 JZYWXV3akXXLq1Z/zTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

Add Devicetree binding documentation for the Qualcomm QCN6432 IEEE 802.11be
wireless device.

QCN6432 is attached to the WCSS Q6 subsystem and is represented as an AHB
platform device, even though the Wi-Fi hardware interfaces over PCIe.
Document the compatible string and the resources, including the Q6 remote
processor phandle, MSI interrupts, SMEM states and memory regions.

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 .../bindings/net/wireless/qcom,qcn6432-wifi.yaml   | 149 +++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml
new file mode 100644
index 000000000000..97d8885333fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,qcn6432-wifi.yaml
@@ -0,0 +1,149 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/wireless/qcom,qcn6432-wifi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies QCN6432 wireless device
+
+maintainers:
+  - Jeff Johnson <jjohnson@kernel.org>
+
+description: |
+  Qualcomm Technologies QCN6432 is an IEEE 802.11be Wi-Fi device
+  associated with the WCSS Q6 subsystem. The device is represented
+  as a platform device and uses MSI interrupts for its Copy Engine
+  (CE) and Data Path (DP) rings.
+
+properties:
+  compatible:
+    enum:
+      - qcom,qcn6432-wifi
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
+        compatible = "qcom,qcn6432-wifi";
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

