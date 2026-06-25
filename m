Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A635F180;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396631; cv=none; b=HLxASLAsGj1pYY2cJnR/88lMcHFq4Wrme32QxOAazsG4red+plG0H3qpDBVdDwBweTB/Hbwc0VYr+Jb1H+umfBoQ21w+lZ8gocsgtWb4Xr9gKSv24dT0I94hSnibLFE/ZvC0co486iunEHDlW54N7751k9+Ii7EV3wNn6cutus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396631; c=relaxed/simple;
	bh=cGlrzfrVFE1P+AOMseHD4xEMCebg1rxM3TlgaPrOlmI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AbFZRXFpQstpe/rfFXcRUHFpKEzIRtv4ZyIW66/+co6jcTKV9BQv//dk4IWwAOvPO8PWCM2nFM0NK4N2MKFozsbJd8soeUOhpRvpd4JN9n9YcGCXWEX1s5nZlmtmJfeTM7Qao8TxPvRkhj9XIvX3kgpfuSUsIw0s8lQp3xwHT5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q3CQaR0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3CQaR0E"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 878E7C2BCB7;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782396631;
	bh=cGlrzfrVFE1P+AOMseHD4xEMCebg1rxM3TlgaPrOlmI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=q3CQaR0ECmYMzAv/aPi/BVrstYd6WeM2zEXiYExYNg86sPm4UqraFh1n/0T25mqAw
	 mEw5tlsPGUi5J8K3Td9gJICJaeiczJAjphybRefGZsD9WGnumFeOhCqKy/gP8lvxD1
	 QzvXhSY0S+DpRCW2JQFj1grtR8/YHvHXNCJDfdOR4WbbLw8yAiqLmR2ko2icZQIOAO
	 ZY1MNOYgOXVgnIDcUSUWUr61VPRLdn8pzyCz7mG7JPKzcm8dROOo63T3VitJTspEtV
	 ySNn3aaz032OLsWDxWky/Bk1wWLCRgkUeGH+Hfz4s7m8UaGK/PTsM08umuOqow/zj9
	 O7PODHosRHzWw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3F8CDE00B;
	Thu, 25 Jun 2026 14:10:31 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Date: Thu, 25 Jun 2026 18:10:10 +0400
Subject: [PATCH 6/6] arm64: dts: qcom: ipq5018: add nodes required for
 Bluetooth support
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-ipq5018-bluetooth-v1-6-d999be0e04f7@outlook.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782396628; l=1962;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=ojtleJtDhQce/+XX9j6vq/OyHIn9zWr0G+phOI1scMI=;
 b=mB7Kl8oo6p9qGG8S83k1i8WmNveVSPly3y06IvufkwdoKbpyKrwO16ajhuW3SA7lgpXy+Ip47
 WLniTF1QpjgDlYPL6e8t4RQt1S+4CsO7tztDkEfprQ0UCWrbZxiEfmq
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

From: George Moussalem <george.moussalem@outlook.com>

Add nodes for the M0 remoteproc, reserved memory carveout, and Bluetooth
to bring up the M0 core and enable the Bluetooth Subsystem.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
 arch/arm64/boot/dts/qcom/ipq5018.dtsi | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5018.dtsi b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
index 6f8004a22a1f..4fdf20c87b0a 100644
--- a/arch/arm64/boot/dts/qcom/ipq5018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
@@ -17,6 +17,17 @@ / {
 	#address-cells = <2>;
 	#size-cells = <2>;
 
+	bluetooth: bluetooth {
+		compatible = "qcom,ipq5018-bt";
+
+		qcom,ipc = <&apcs_glb 8 23>;
+		interrupts = <GIC_SPI 162 IRQ_TYPE_EDGE_RISING>;
+
+		qcom,rproc = <&m0_btss>;
+
+		status = "disabled";
+	};
+
 	clocks {
 		gephy_rx_clk: gephy-rx-clk {
 			compatible = "fixed-clock";
@@ -131,11 +142,31 @@ psci {
 		method = "smc";
 	};
 
+	m0_btss: remoteproc {
+		compatible = "qcom,ipq5018-btss-pil";
+
+		firmware-name = "qca/bt_fw_patch.mbn";
+
+		clocks = <&gcc GCC_BTSS_LPO_CLK>;
+		clock-names = "btss_lpo_clk";
+		resets = <&gcc GCC_BTSS_BCR>;
+		reset-names = "btss_reset";
+
+		memory-region = <&btss_region>;
+
+		status = "disabled";
+	};
+
 	reserved-memory {
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges;
 
+		btss_region: bluetooth@7000000 {
+			reg = <0x0 0x07000000 0x0 0x58000>;
+			no-map;
+		};
+
 		bootloader@4a800000 {
 			reg = <0x0 0x4a800000 0x0 0x200000>;
 			no-map;
@@ -647,7 +678,8 @@ watchdog: watchdog@b017000 {
 
 		apcs_glb: mailbox@b111000 {
 			compatible = "qcom,ipq5018-apcs-apps-global",
-				     "qcom,ipq6018-apcs-apps-global";
+				     "qcom,ipq6018-apcs-apps-global",
+				     "syscon";
 			reg = <0x0b111000 0x1000>;
 			#clock-cells = <1>;
 			clocks = <&a53pll>, <&xo_board_clk>, <&gcc GPLL0>;

-- 
2.53.0


