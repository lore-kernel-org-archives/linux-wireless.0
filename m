Received: from smtpdh17-2.aruba.it (smtpdh17-2.aruba.it [62.149.155.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AF1468C38
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758918; cv=none; b=X2DQTfPbaDE90Gw/sJbpyfqWnSY1OxSHkQdp+0C4BqcK9ABypcG/rRiTI90Gxa9tUWKGiPYY6iSFLOcXXlBzObc2osTBZvDJyCx1VxQBL2zlB4/mvheBwehvpul1EteVsFVtuNRsy7j76EjLqlc3dXguM0QpUuaAccZWiCDh2iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758918; c=relaxed/simple;
	bh=IKeJyZOjiuymxr65r7tntGqpXYBLk1QNFkGjPfO+gzo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iPViDKYQr0HxCGuH74VJThZIBXB9g183IxFKfQUG7So64eFMMk3B+abDoPjkL2GRg68+aNC/t1Ba5r1djxAn4avkPKmRp7BqdQCEzAfSj4IlnTXnJJhjBypUD+jsVMbL1iPwvQZeq6LwwXFa6NneXJrVIasOJmU+ifR+RrvFFVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=f3Xi/AP5; arc=none smtp.client-ip=62.149.155.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="f3Xi/AP5"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id G2INxu7ww76R9G2IOxOszf; Mon, 12 Oct 2026 00:45:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791758733; bh=IKeJyZOjiuymxr65r7tntGqpXYBLk1QNFkGjPfO+gzo=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=f3Xi/AP5n2XuAR5C+DT6YxQSExW0nZKwRZRSF+li1/jYGy8tHi8sas2vHk3/jsdBf
	 ZIk7hzrOoKTUaXAx6itP2iISQ3xcoduIlhpvjs+a3m+MoC4R0I+vFFRXPZKHzSOXu9
	 T+vn8tFvUydNQlIbIA+S+qe3XHv08nG91y7N5nupesyqaMWAc0YIPrhIvAYaqt2rSB
	 H5YRENiTz5VFimJ9ulSH125A4BuOZscqopzUiqgrhBVCu07LsMnpmWnb53TIAocB4n
	 XocrBBWYgiURF0ZnpCaZWs1JMvf23td7dFiV+QGdDe3pGkxmbiwfyY8ziInz8VofWR
	 S2hoMa0RUb1Ng==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Mon, 12 Oct 2026 00:45:29 +0200
Subject: [PATCH v2 5/5] MIPS: dts: bcm6362: add the integrated WLAN
 backplane
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-bcm6362-wlan-v2-5-4752da7e0982@mythread.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
In-Reply-To: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfP/1Jx3Il+CvHY4LSerOJ/80LHXXGV/Lypmh3G2ykaIUQdN/11Ail4rWDjVDIQBqtsX1XGXhaBUzX62VQsXaak3cwxeCoCn7va8m3uwpEk18mFbdBz7Y
 b5JmiOq4RFfBm0D1g78TBQP6MceT+Py+Ps3qDmhcxIghRxF6ZmM7bs1PGFvLwKoLIUy0jtUiTVLbLd4c4ez+snqnz3ZmwY5BaL/xLOGe3ZuZoHWJlE5o2vLQ
 9bAJOQX0xo8bGvTDJOwvw6I5ZjNBOUaQDUuKuAu9q+II6kWFUKwq1n8de/BoFRvmNXzwp3h0VHqn/bfJTGtJflBFnF3Pa3cD8Ke2J5t0ECloyAzqld27Pqhb
 z7Sx4+EcfyRAI9pfXqnE8WrKJVPQQU7AMh31vSTdqcvzhdTp0COrO/+FJIpY8QQzh4TxQrfHwb04P/RE0Y5YJx2OOGzTFfHat+JlEUV237cWENsIa2khbX8X
 NWczwCnsvxc59vUL4LEFKUQgyKG4PWlLoHpCHvHA8EuD8Q7cECsPqwQ9W7ybQhazQu34YHpaSANl2cYoYkaD4v06Q70lSXAL2N1Gg5e558hS9ViV/m/eEK89
 TUa/Mb0CluLNDKVoc9AVMBW4gHbtF44wrT4AgaTqMXzQGrK1gkykkb4wrTCwThSK/Jo=

Describe the bcma backplane of the integrated WLAN macro,
with its clock, resets, power domain and the interrupt of the 802.11
core. It is default disabled, boards having the WLAN need to
enable it.

Assisted-by: LLM
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 arch/mips/boot/dts/brcm/bcm6362.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/mips/boot/dts/brcm/bcm6362.dtsi b/arch/mips/boot/dts/brcm/bcm6362.dtsi
index d74021925c53..c6de39588840 100644
--- a/arch/mips/boot/dts/brcm/bcm6362.dtsi
+++ b/arch/mips/boot/dts/brcm/bcm6362.dtsi
@@ -261,5 +261,25 @@ usbh: usb-phy@10002700 {
 
 			status = "disabled";
 		};
+
+		wlan: bus@10004000 {
+			compatible = "brcm,bcm6362-wlan-bus-axi";
+			reg = <0x10004000 0x1000>,
+			      <0x10007000 0x100>;
+			reg-names = "chipcommon", "wlan-ctrl";
+
+			#address-cells = <1>;
+			clocks = <&periph_clk BCM6362_CLK_WLAN_OCP>;
+			#interrupt-cells = <1>;
+			interrupt-map = <0x00005000 0 &periph_intc 7>;
+			interrupt-map-mask = <0x000fffff 0xffff>;
+			power-domains =
+				<&periph_pwr BCM6362_POWER_DOMAIN_WLAN_PADS>;
+			resets = <&periph_rst BCM6362_RST_WLAN_SHIM>,
+				 <&periph_rst BCM6362_RST_WLAN_UBUS>;
+			reset-names = "wlan", "wlan-ubus";
+
+			status = "disabled";
+		};
 	};
 };

-- 
2.56.0

