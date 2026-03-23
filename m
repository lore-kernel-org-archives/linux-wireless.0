Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8E938655E;
	Mon, 23 Mar 2026 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259909; cv=none; b=fLDVs9dORnLtulhvaKD244YpBPWwlaux6K1N2vWhuuF8TmrgrChCbr48xR7QbWCE+9csiH5NS7Yn15kCenP+5lKZidxMLtXA2mZ4ZfvkohKm5hYa/maxI2pCuY2WPfeaoLb59DLaldo6jGa2R6EFnav8goWEUDafu2MyU6SBo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259909; c=relaxed/simple;
	bh=OHhaocqrcyvsfcC4nwRCQzXz7HSpal5P8Pl4jRGYs5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V9kzwHNvLoohKLDyg9UC1bTbK8xE9Nh0f0F03z9BbiPLPxV7EmOgYCoq5UgLGOycS/PR7cgboy26Wj+4xrwubUHK0ara8VJ8DDN7jV1F1re6mA/iWzIiOe4FKFt/lTUzFjaCEweNMqfRbZPDQs22l8rxAYfom2mUhrtOY8ErKQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=OUTZmbQQ; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="OUTZmbQQ"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774259903;
	bh=OHhaocqrcyvsfcC4nwRCQzXz7HSpal5P8Pl4jRGYs5Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OUTZmbQQlN/RqGWdkrOHanbOL8AdBU2wDAOdjiUgc/It7IDE4YwAAr7QokoV3NLR7
	 p2P/PM8l+pXNMxPkqnOBglk/Supq9KRFLr271a73gZQ0T4PXBcVUVRMdXqvS9OZxht
	 5nfc0l1InUaIBfb1pu0xrWoNYCK1pNatSSJ8Y4oU=
Date: Mon, 23 Mar 2026 10:55:32 +0100
Subject: [PATCH v3 7/9] arm64: dts: amlogic: t7: khadas-vim4: Add SDIO
 power sequence and WiFi clock
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-add-emmc-t7-vim4-v3-7-5159d90a984c@aliel.fr>
References: <20260323-add-emmc-t7-vim4-v3-0-5159d90a984c@aliel.fr>
In-Reply-To: <20260323-add-emmc-t7-vim4-v3-0-5159d90a984c@aliel.fr>
To: Neil Armstrong <neil.armstrong@linaro.org>, 
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>, 
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, 
 Johannes Berg <johannes@sipsolutions.net>, van Spriel <arend@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org, 
 Ronald Claveau <linux-kernel-dev@aliel.fr>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openssh-sha256; t=1774259895; l=1444;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=OHhaocqrcyvsfcC4nwRCQzXz7HSpal5P8Pl4jRGYs5Q=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QA2+JhnbgwDiwkQMZUUK1kdfqFB6gHx/VO/wHVQT2TwQo4rpGN3NvKqU74eiBj0Fbt6jWjlYGAc
 Sh7XzGYO9TQg=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add the SDIO power sequence node using mmc-pwrseq-simple and a
32.768kHz PWM-based clock required by the Wi-Fi module.

Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 .../dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts  | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
index 2450084d37642..770f06b0b16c7 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
@@ -67,6 +67,15 @@ sd_3v3: regulator-sdcard-3v3 {
 		regulator-always-on;
 	};
 
+	sdio_pwrseq: sdio-pwrseq {
+		compatible = "mmc-pwrseq-simple";
+		reset-gpios = <&gpio GPIOX_6 GPIO_ACTIVE_LOW>;
+		post-power-on-delay-ms = <500>;
+		power-off-delay-us = <200000>;
+		clocks = <&wifi32k>;
+		clock-names = "ext_clock";
+	};
+
 	vcc5v: regulator-vcc-5v {
 		compatible = "regulator-fixed";
 		regulator-name = "VCC5V";
@@ -135,6 +144,19 @@ vddio_c: regulator-gpio-c {
 		states = <1800000 1
 			  3300000 0>;
 	};
+
+	wifi32k: wifi32k {
+		compatible = "pwm-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+			pwms = <&pwm_ab 0 30518 0>;
+	};
+};
+
+&pwm_ab {
+	status = "okay";
+	pinctrl-0 = <&pwm_a_pins>;
+	pinctrl-names = "default";
 };
 
 &uart_a {

-- 
2.49.0

