Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7BC30C15C;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396631; cv=none; b=MbgB8aPPwwrWi4lav4NbwW45uXBPY5LOhKm4BQo9p8aVUWmM60kpvzfwjwlsiZyFND+W2fJRPScya1K0TCl9vWDp/UP7BhxDBaUiUAVkIcLFo2UCkDQUaK/jjtb5ruW2XSwVSXKt9XcgdMM0iMPXhacv2MaHbRaZcznQMwdXATM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396631; c=relaxed/simple;
	bh=O39ws0iMru9hm8TgXu7rNxCKAIVbTXEq4BlFEP3abHw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KgUjol2IVqFzUyQEsG7YpBD+EC7DnAcCYzILcXmZsPkA0f8TVjIkouHD648bzjBTp/W9Y4umGxoZ/4nbqblYChrKYsjnQVKSOwReaRJlA5d4j2N1iMjlXZFV7w0eK1mk7azWXwCUKpHUUK99GOwLAA9Rpbew1dPpXijIZk6jlUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7yi9uvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7yi9uvv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1D23C2BCB7;
	Thu, 25 Jun 2026 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782396631;
	bh=O39ws0iMru9hm8TgXu7rNxCKAIVbTXEq4BlFEP3abHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M7yi9uvvaw76kuzKhtvRlSvxlIOsDdlcqnEsorvKqYVUMAeaNysO4qRlS3dQINjBm
	 xN58K8uBBMPOfw33e5meQkXxSb1Vc7ByxkFLlXJ2nzHUUmtsn6ktLSOpwiEDGarjbx
	 +Uj95jt84ZPxFaC6DOJ6B3GqNGE5PjA+qduv47H/CXVuKeGK4cfc6ChfXA3qNG4cnM
	 vkNYF0B7z1bCgFmMIlIJ8/HLh1FOMhCVZgVSiUmxupGjA8Uv4nlIwa+5E5y5ts6Dut
	 7f3p1dWB0JET1p4qlek6OhuklqCE5htWwUS6O/1OMYydsACjOpCFFp02hcWrLXlzTy
	 h8M4OYaJ4qOYw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8633CDE000;
	Thu, 25 Jun 2026 14:10:30 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Thu, 25 Jun 2026 18:10:05 +0400
Subject: [PATCH 1/6] dt-bindings: remoteproc: document M0 Bluetooth
 Subsystem secure PIL
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-ipq5018-bluetooth-v1-1-d999be0e04f7@outlook.com>
References: <20260625-ipq5018-bluetooth-v1-0-d999be0e04f7@outlook.com>
In-Reply-To: <20260625-ipq5018-bluetooth-v1-0-d999be0e04f7@outlook.com>
To: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulfh@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, 
 Rocky Liao <quic_rjliao@quicinc.com>, 
 Saravana Kannan <saravanak@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
 Heiner Kallweit <hkallweit1@gmail.com>, 
 Russell King <linux@armlinux.org.uk>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782396628; l=2405;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=aASt9ShJzJWACzszmUFOYCQKCOgD0FP+gd6rS7LrksI=;
 b=N1N0fyN6SorxNs2uShNAzctNepCMehbe1sjqld58fbG/kPye64F2aPdTfu+pjaWj+h5Wt5Wr1
 UkWP3yZildXD0XNWruBonDbZdCY2LJC8qZePwmbFxQjRooTh5BB9aaG
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Document the M0 Bluetooth Subsystem remote processor core found in the
Qualcomm IPQ5018 SoC. Firmware loaded is authenticated via TrustZone.
The firmware running on the M0 core provides bluetooth functionality.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 .../bindings/remoteproc/qcom,m0-btss-pil.yaml      | 72 ++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/Documentation/devicetree/bindings/remoteproc/qcom,m0-btss-pil.yaml b/Documentation/devicetree/bindings/remoteproc/qcom,m0-btss-pil.yaml
new file mode 100644
index 000000000000..397bb6815d71
--- /dev/null
+++ b/Documentation/devicetree/bindings/remoteproc/qcom,m0-btss-pil.yaml
@@ -0,0 +1,72 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/remoteproc/qcom,m0-btss-pil.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm M0 BTSS Peripheral Image Loader
+
+maintainers:
+  - George Moussalem <george.moussalem@outlook.com>
+
+description:
+  Qualcomm M0 BTSS Peripheral Secure Image Loader loads firmware and powers up
+  the M0 BTSS remote processor core on the Qualcomm IPQ5018 SoC.
+
+properties:
+  compatible:
+    enum:
+      - qcom,ipq5018-btss-pil
+
+  firmware-name:
+    maxItems: 1
+    description: Firmware name for the M0 Bluetooth Subsystem core
+
+  clocks:
+    items:
+      - description: M0 BTSS low power oscillator clock
+
+  clock-names:
+    items:
+      - const: btss_lpo_clk
+
+  memory-region:
+    items:
+      - description: M0 BTSS reserved memory carveout
+
+  resets:
+    items:
+      - description: M0 BTSS reset
+
+  reset-names:
+    items:
+      - const: btss_reset
+
+required:
+  - compatible
+  - firmware-name
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - memory-region
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,gcc-ipq5018.h>
+    #include <dt-bindings/reset/qcom,gcc-ipq5018.h>
+
+    remoteproc {
+      compatible = "qcom,ipq5018-btss-pil";
+
+      firmware-name = "qca/bt_fw_patch.mbn";
+
+      clocks = <&gcc GCC_BTSS_LPO_CLK>;
+      clock-names = "btss_lpo_clk";
+      resets = <&gcc GCC_BTSS_BCR>;
+      reset-names = "btss_reset";
+
+      memory-region = <&btss_region>;
+    };

-- 
2.53.0


