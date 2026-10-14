Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C68513546
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982993; cv=none; b=eyF/qiR3iRTcRGUcuBqsCgJydffrrpRGuZiGMDPDCyABEG4Gt0dHpdG+ZlJ8LlcRPHIGJoBGcYua/DS9+Ek4I65iVePe87+d6VmogYKvhVhHJrWn/2Sk2oDQsbqmhFH9lcvI7FLcDmnsc/GNRc2JDhns9MzkdQHZnuvKSvqmzB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982993; c=relaxed/simple;
	bh=ASWIqLah/uFWvhZywA6+lXlXr9BhgVdBiskjUcy96bM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a0Jx4NGj9pAWzIjoS03MQzDSMMJYTx+Pne0UIVf1fR7wmXAST/ney8R5nRPFbXg8iZzIIctqkAM1fQK0da7mwpMdxkoAQJ4Quyp6kf0I+4ZXKgrrXfNWEJF8DFd73KhXBYMmbnSNe8NEw3uZLxcve+hOLzFHw98MmHmMvg6B/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kFx36s33; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NWP3o/cW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kFx36s33";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NWP3o/cW"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E7ObMk2874017
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HDwwf2nnDOaoIDpnBdokHTTm2gc9B8Cwgq888y5WJ0A=; b=kFx36s338qO6e7pE
	GKWQhHpV1WwW2PUWaVNWiJaGszUnYv+PPw/btR4wbwwT27k69Kgwkdug5rAvNmmo
	3UOyrAzi3y6bKwBwhx9g5uFUAgCKrK/77od0sfSCfyCAtgUHWSxyC3F/8kLAZNfH
	LRoNdQdrHzV+dXEZ9LVdHT7U/lsJq0RFTLvEN6/Uv7uvwzj+IXMGTbGdZzmse36f
	LHWPNrL4VpShSh6KGv14ME5G78fcCOV6mMRBggg0PT++ZWjd1c/UP1A/Jdwl8ZUj
	E1hcEP/Wis/DybvzUYPq7SPauE6elkG3K2GGh+K06+ih9S962pD1mFufkkld6zyh
	pMoqhA==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9yphjn1t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:05 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5e95ef10aeaso358282e0c.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791982985; x=1792587785; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HDwwf2nnDOaoIDpnBdokHTTm2gc9B8Cwgq888y5WJ0A=;
        b=NWP3o/cWmgvbNYcE60HvpzgTw/47YVg2RSBno9Q/mJ3ibrO0gp6NSzGk4XUWmYxcJK
         UJtEbZz5a98YyWOf39dJfdKN8h8TIFxxUznXkQvTJSf6XNHiANsiIfqk/3ynrCAroH3+
         K4k+fO8kuuwOW2b5Ij8MfcfDyrFJa3aXzcaHavPdbyBEZ3CpkyKBroHrBeqQi4WAkpi1
         QYNMt35Pk5rQ7EXrg43OqRBAfJ6keQUv/ucZLN/fseie4m8flLYwCCV7mEb7mNVPBoAH
         lytSqF5aqlAe8edoy6Y29IhY/Y2A1plGN5qPepynQucdkeaNepArHY3TkTLf8tPl4kqg
         RfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791982985; x=1792587785;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HDwwf2nnDOaoIDpnBdokHTTm2gc9B8Cwgq888y5WJ0A=;
        b=IW80K7wN0EJHWwdDNvapJRvHfwU1xkoDFXPDdEzE7pn1uoMUaj+M+kbMSg68dQmGCH
         3cA7w3imJPdrlnuuMQFiyuzflQubASuHQLzxSoozUO4TAoDneF5Wuu84CsL3Ex/aS5GO
         f8Cqc8BBnHTTrbIOnjlW23AOCwSDkkR476zq1ZH6PIDk9jjYT8kuRrVLpTi1/3h1DLuX
         544pQmB0EMMpBy9fHRpl18Jn9CwtyMQ0TTcdkaOD1AMFZauxMhqC1hVsVCWpDF/z/h7J
         BAyBwaMzJwKJp6lvyM5YI+SopvEo9OLGXIdaTK7hKWMxDK7T+MzCEMHvGoZ7x4qqHH7w
         HsQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwp/86wh2TTqeovMCxFTyqLjUxINQ8xsrqqAol8GgNbC2vBXg3e0WFQBd/++KJZATVk3SqBoIZLMOOQgDl/4Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLwtUEqujf2L4cOJV0bQ21ZQuBN3qziFRm0SShHVWHkyc9cQ0nc
	YfYK0VzZcQxfNamBtUESHYYM9l7XT9gcCNAzlooxTcfUQ1wBfAR/xFEL2D+5/jdaO+0AouFIAmA
	t8zC5JEZ4TCvSmrYjFLgyk459Ai34rp2lCGz78Z9XlXD2h8b5r3Ik0IYLkqTHJj5DtY6cqg==
X-Gm-Gg: AYBFou0IUytpJ02Cq4AmnWO3/j4f2/ob1DdS4k/0x5c5HTaUD+IcULUukJzWa8hkl/O
	WEBr47E+XwpN4WIpgEEOdra7fOrIDYzxE9YlI9ypMwv/UaCZ4VwmavaFWrU+FEEh4ef5txkdrAQ
	wfevbTPd/0tDPYx2F73+gOmlFFD/4IwC+L/sjfS3L8sOi9UCKhxtJqz3MKEiRO1fHgnX2jQmeEs
	H4r4OF9bIgafeXRL0PEBOWFprkCK/mpJPU2bKnii+AfW9xKS/SGfscOMUjcFg7fPlz1mzQGgbsr
	KZ1QPLd1l7TyruVjBBnV8lXVijiMbQUftY9zzNB71QxTan2E/2yN+212cY9ZFCFb3MeKFcJcXW2
	r5peuEqhQ3g==
X-Received: by 2002:a05:6122:3c4e:b0:5d3:9fc0:7885 with SMTP id 71dfb90a1353d-5e91efb3a55mr5467828e0c.0.1791982983596;
        Wed, 14 Oct 2026 06:03:03 -0700 (PDT)
X-Received: by 2002:a05:6122:3c4e:b0:5d3:9fc0:7885 with SMTP id 71dfb90a1353d-5e91efb3a55mr5467671e0c.0.1791982981490;
        Wed, 14 Oct 2026 06:03:01 -0700 (PDT)
Received: from [127.0.1.1] ([86.121.170.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bcece106sm567795e9.9.2026.10.14.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:03:00 -0700 (PDT)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 16:02:39 +0300
Subject: [PATCH RFC 1/5] dt-bindings: nvmem: Add UEFI variable NVMEM
 provider
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-nvmem-efivar-v1-1-187c85f65018@oss.qualcomm.com>
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
To: Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2957;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=ASWIqLah/uFWvhZywA6+lXlXr9BhgVdBiskjUcy96bM=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBqz315K2FLP6WGMZnegKPCWuqzDd6D0ByEMRQej
 ElIqj4tpuGJAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCas99eQAKCRAbX0TJAJUV
 VnNREACdYf4Y+MuvkYiPeu9661Rm1nFDv4WC9VsnQ2JyiHsKSkNFgewOd29zaZAI+oGnufkrwux
 4q20TvzLeLe/3ozRF/ewkO1jTitV+irbQiLIWhFWxwgxr8N9w3aOgS6GGhTms/7K8HaILwEzDUH
 J51l2sflhfQN7E+Rr0ag/mkF1MH6j5TJ7vgT1lPQyiJr/p0xkKhVwdPA6bxituaJ3yvuIod4Sav
 oEhYmLeM1NoO9XyIqM52YqVC5BOhjphdMUnKrAcmdwEmG0eghPzp9DmlJ/wm+N/7lzmWxwABcYN
 Y1fGMYkMBh0ocx1JgAFsXwzxeThIyQWecP6O6tbuMQLx1LJOJDEjNT0OdmDMqWORWNbDzG/CW+8
 0/iKIXL/1+K95KzogmOLoZN4M70UC+IrceawLhmvBCPf6QMQRueJColiSzpwN3M+wPSkeIokodg
 5Um34B2se0rms/Zi+cqCHDyPX7c3wtXkgA1dl0DcKyR+M4J1pJAWYg2a0KlYXUaT5fsLR5DX2sT
 U1WSvL3ZUPGVL98WQWAIltw90CLW0nkJErc/4YWg9vwlOmo/nmgECdOjlcvVsNyw6PAL1wtr/9x
 8++nDWbqmg8oM7ymG/zp+Fbjgawn5hW7lHwor2LUfNf6N624O84hSOvFqgNkxaAly3BpgO6rmHw
 jv+lYCtivt/cgLg==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Proofpoint-GUID: 5iBD_qKkl4ivbvfdXH7NUu1ZpLKup09I
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1MSBTYWx0ZWRfXwYV7962F/gSk
 YHmsUCGmKiB3d/b2gldAL2Y6w1HTOL9ZfDqIC2ri2jvqC4GUJjJfgnLuVwDBebsAjrn/zUKyMg/
 wMjddBGK1BC6aVSENG7RPXgR+JvEV54=
X-Authority-Analysis: v=2.4 cv=Uv72pOwB c=1 sm=1 tr=0 ts=6acf7d89 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=Rt3kCFFBWhWisHNmluDamg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=gEfo2CItAAAA:8 a=EUspDBNiAAAA:8 a=t4Q5Td2Vxm9WVIIx0qwA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1MSBTYWx0ZWRfX8ez91fWsvqIM
 rfUXdLarpUJ0WHs/TmxFW0y6SNmqpUeoSWrS107oSxSZ2mXPdX7UjMauEcdUJTp6zovfsZxWB5n
 Lrl7GSi/AWYt+jqCUMFygh8ulWuPrHW+ebDNjrpt4LmfcdBuKexHC9c7X7dJfBouVMAXpBVBloj
 ZiXOuwPhmxHkpSdXkEH+1ge7Hv+Am9ik10oOY3s1FCdSplBPrxDVjYSmxTe/nDLdeyWsD2SSFYa
 8OKvcGsICsRD203M/Ix7FY+5xATKof6uObsdIu7M7mt5USIfAnnMsfTTw4vJJijdczTa1lLSTDM
 33GuFf18jWUjZ/rtPKLCvByOMBB7Oq2Ph7Vlb1QMDzUvBaCDbXvwd2+WypCBMPN8pDOo1Ggue32
 fIb3uE6OW6doOgmPOj35Rl/lKAgpgQ==
X-Proofpoint-ORIG-GUID: 5iBD_qKkl4ivbvfdXH7NUu1ZpLKup09I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140051

Describe a provider that exposes the contents of a UEFI variable as an
NVMEM device, so data provisioned in a UEFI variable can be consumed
through the standard nvmem-cells bindings. The vendor GUID is optional;
when omitted the variable is looked up by name across the whole variable
store. If the variable has not been provisioned, the cells read as
zeroes.

Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
 .../devicetree/bindings/nvmem/nvmem-efivar.yaml    | 73 ++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/Documentation/devicetree/bindings/nvmem/nvmem-efivar.yaml b/Documentation/devicetree/bindings/nvmem/nvmem-efivar.yaml
new file mode 100644
index 000000000000..cdc10bee3c6f
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/nvmem-efivar.yaml
@@ -0,0 +1,73 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/nvmem-efivar.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: UEFI Variable Based nvmem Device
+
+maintainers:
+  - Abel Vesa <abel.vesa@oss.qualcomm.com>
+
+description: |
+  Exposes the contents of a UEFI variable as an NVMEM device, so that data
+  provisioned in a UEFI variable can be consumed through the standard
+  "nvmem-cells" / "nvmem-cell-names" bindings.
+
+  The variable is read via the EFI runtime GetVariable service, which keeps
+  working even on platforms where that service is emulated by firmware (for
+  example the Qualcomm uefisecapp backend) and where direct flash access is not
+  available to the non-secure world. If the variable has not been provisioned,
+  the cells read as zeroes.
+
+allOf:
+  - $ref: nvmem.yaml#
+  - $ref: nvmem-deprecated-cells.yaml#
+
+properties:
+  compatible:
+    const: nvmem-efivar
+
+  efivar-name:
+    $ref: /schemas/types.yaml#/definitions/string
+    description:
+      Name of the UEFI variable to read.
+
+  efivar-guid:
+    $ref: /schemas/types.yaml#/definitions/string
+    description:
+      Vendor GUID of the UEFI variable, in the canonical
+      "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" form. Optional; when omitted
+      the variable is looked up by name across the whole variable store.
+
+required:
+  - compatible
+  - efivar-name
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    nvmem-efivar {
+        compatible = "nvmem-efivar";
+        efivar-name = "ConfigData";
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        cell_a: cell@0 {
+            reg = <0x0 0x6>;
+        };
+
+        cell_b: cell@6 {
+            reg = <0x6 0x6>;
+        };
+    };
+
+    /* A consumer references a cell through the standard nvmem bindings:
+     *
+     * &some_device {
+     *     nvmem-cells = <&cell_a>;
+     *     nvmem-cell-names = "some-value";
+     * };
+     */
+...

-- 
2.54.0

