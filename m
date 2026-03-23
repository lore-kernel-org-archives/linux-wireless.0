Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5D827AC48;
	Mon, 23 Mar 2026 09:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259910; cv=none; b=YbfmL2SxfocRAv6PTGRmiBp2oUR+ZGxZFWbOlLg/w0IG6+IRY/G4BlJkHmxdiUYQ1kvOshGrOiHv8if0m4sniY2eVGOLDPR1tRCv5RE6tV1nSYHVTxFfykvmrqZOfK5yQOyRr0Zxk0BZhzZR82Fsi/9JIIxiwXbj4s8Mtg9VJzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259910; c=relaxed/simple;
	bh=AO4tgBsQ5yd9Qo2dDaY+wcNu1us7EFs06fTrqRlHBYM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QKTH8OxQapqt0b9nNLG9hZFT5PASAled8DNISUVrdXqv3rdVTtEP2e4eSq+afjlAtirJ4gpu6px1X6G4FaNkpNw5HgraagSOGE6TmoS+5lyz+r/u+wVHkgvK8ggrmNHU+zIEUN11mrzGVIBmS9QuaBFWmJ0AVmGqQzU7462OAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=Jh2jvney; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="Jh2jvney"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774259901;
	bh=AO4tgBsQ5yd9Qo2dDaY+wcNu1us7EFs06fTrqRlHBYM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Jh2jvneyE74Am2thzy9WlW47Gi0DtfluNkcEjr7ZRHfcR5zVN/4audqf7fagm2pxO
	 FsV+ySupdlB3PiRryb3FNbCKtX9bgfEE5kagpR0auZ9JbbGjMVMYz1ATDj6yY1n611
	 4tp1es03xYgthWOnCQsMmdVRobzSMAH6yIb/EltE=
Date: Mon, 23 Mar 2026 10:55:30 +0100
Subject: [PATCH v3 5/9] arm64: dts: amlogic: t7: Add PWM controller nodes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-add-emmc-t7-vim4-v3-5-5159d90a984c@aliel.fr>
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
 Ronald Claveau <linux-kernel-dev@aliel.fr>, Nick Xie <nick@khadas.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openssh-sha256; t=1774259895; l=2868;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=AO4tgBsQ5yd9Qo2dDaY+wcNu1us7EFs06fTrqRlHBYM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJZSR1SMHxPM+6QdLs5pPY8OawAIsaGLhfGtKLJB4Nlbb0tJsEL5bhXobDp4DjYkDd1IsmXRpDo
 CrkA2mHLA/A8=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add device tree nodes for the seven PWM controllers available
on the Amlogic T7 SoC, using amlogic,meson-s4-pwm as fallback compatible.
All nodes are disabled by default and should be
enabled in the board-specific DTS file.

Co-developed-by: Nick Xie <nick@khadas.com>
Signed-off-by: Nick Xie <nick@khadas.com>
Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi | 63 +++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
index 6d41de6f895b4..a0261cd8eadfc 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
@@ -511,6 +511,69 @@ sec_ao: ao-secure@10220 {
 				amlogic,has-chip-id;
 			};
 
+			pwm_ao_ef: pwm@30000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x30000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_AO_E>,
+					 <&clkc_periphs CLKID_PWM_AO_F>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
+			pwm_ao_gh: pwm@32000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x32000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_AO_G>,
+					 <&clkc_periphs CLKID_PWM_AO_H>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
+			pwm_ab: pwm@58000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x58000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_A>,
+					 <&clkc_periphs CLKID_PWM_B>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
+			pwm_cd: pwm@5a000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x5a000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_C>,
+					 <&clkc_periphs CLKID_PWM_D>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
+			pwm_ef: pwm@5c000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x5c000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_E>,
+					 <&clkc_periphs CLKID_PWM_F>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
+			pwm_ao_ab: pwm@5e000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x5e000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_AO_A>,
+					 <&clkc_periphs CLKID_PWM_AO_B>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
+			pwm_ao_cd: pwm@60000 {
+				compatible = "amlogic,t7-pwm", "amlogic,meson-s4-pwm";
+				reg = <0x0 0x60000 0x0 0x24>;
+				clocks = <&clkc_periphs CLKID_PWM_AO_C>,
+					 <&clkc_periphs CLKID_PWM_AO_D>;
+				#pwm-cells = <3>;
+				status = "disabled";
+			};
+
 			sd_emmc_a: mmc@88000 {
 				compatible = "amlogic,t7-mmc", "amlogic,meson-axg-mmc";
 				reg = <0x0 0x88000 0x0 0x800>;

-- 
2.49.0

