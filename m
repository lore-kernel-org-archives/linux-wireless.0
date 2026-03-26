Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0123D890F;
	Thu, 26 Mar 2026 10:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519323; cv=none; b=Y18UN5X7fgGfIk7nif9PLY6aCFdRpgx/k9wXA7TiwXf0K9OvsLCO0w5E4k3ydK32tV04tzxZHTcQKA/9xnduVzDhc3x8cVGq7CEnx1DQ0LmLuB4ZljRB2y679KBWT3nBn+UctLMA4lMidObdJeqXl8Ali0RtHRC8ELRfukcmaRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519323; c=relaxed/simple;
	bh=ni2vmmGzstUniZCBMjYnzV+M4JL79GFjzwahbMGhrNU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ILFtOluaPBCG/MeT8Iyj17L7eqSygBXdG4TBFjPuolcZ0vIQexW88IIjQFdB9aQe1frHQdrsigBEH3SsZ35wdtefs+qirfyVYOy3asmQAy4d6TSWBci+gsK6Rleoh1zRN21VSt158FIZEjyiutO+C74Doz1vmXSPLKXZ7sICCrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=s4GZQSwx; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="s4GZQSwx"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774519319;
	bh=ni2vmmGzstUniZCBMjYnzV+M4JL79GFjzwahbMGhrNU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=s4GZQSwx1scCJOq3L1tMWMUjiewiIBhYu6e/2yKzx7C0jh6q5fg11taTjxPq3rxcc
	 YzOeZs9dsu/nPx3ZISfo0y15CKTQ+gqv2AhgkUuP7nhC+l9bsZyTopCsDy30iQEzE2
	 FJoeerh7G2ZDmrpnBGhQ3fCxGkhUwVhZQwnFPVio=
Date: Thu, 26 Mar 2026 10:59:16 +0100
Subject: [PATCH v5 5/9] arm64: dts: amlogic: t7: Add PWM controller nodes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-add-emmc-t7-vim4-v5-5-d3f182b48e9d@aliel.fr>
References: <20260326-add-emmc-t7-vim4-v5-0-d3f182b48e9d@aliel.fr>
In-Reply-To: <20260326-add-emmc-t7-vim4-v5-0-d3f182b48e9d@aliel.fr>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1774519312; l=2925;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=ni2vmmGzstUniZCBMjYnzV+M4JL79GFjzwahbMGhrNU=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMwe+nhC/VqJvJcXTCp4eVxrCml9mJ/6Y1zPxa3ZmVjcmMtoBs6yC+JyzVJALZo/iunlpRQ/Gtb
 hY7YkxjEYsgg=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add device tree nodes for the seven PWM controllers available
on the Amlogic T7 SoC, using amlogic,meson-s4-pwm as fallback compatible.
All nodes are disabled by default and should be
enabled in the board-specific DTS file.

Co-developed-by: Nick Xie <nick@khadas.com>
Signed-off-by: Nick Xie <nick@khadas.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi | 63 +++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
index b66b3d10288f6..02a303d4ec39d 100644
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

