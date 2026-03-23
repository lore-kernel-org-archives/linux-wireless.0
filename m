Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0411FE44A;
	Mon, 23 Mar 2026 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259909; cv=none; b=iMxPhxvNZpBTl3/15t5iI/Vhsl01e4hUp3B+KPXfPUDPbbdFWVt0Xwn4gGy2AvMXq+vTxgJs3sEWoOJ/A5tV+eCdfw8o/mpQx67JbAKH6/5HRtym4ON3L8KcCxFcp6edOges2Qwd/wprfAH4apgVSJlcJsmHfwuLL79B0KOPisI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259909; c=relaxed/simple;
	bh=Ywdd79SLlnG+5FuD1iPwguAxNCDzzkCuTsJrgYS9eQA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RTZNfk77soAMYJIZuD0cgIdmcmeOWbbUBTasBkF56fVK4E0qB+KPMz/65lbrFGu89LF7NmdmNdhzszIEtLk2a/aMTiB5lVDugohyfDq7I4EVQkWpT+PK3PtX5KD4MVRHMmCa+hsxPxjMxo4gSWbB+sofpqS7cS1kNURl4/unek8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=Bb5vBKKc; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="Bb5vBKKc"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774259905;
	bh=Ywdd79SLlnG+5FuD1iPwguAxNCDzzkCuTsJrgYS9eQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bb5vBKKcHrQrCUXjhW2Cz4IuM0XNMePmeixn8P6uiZR8waRm6evd9CVlZrjJHRbyE
	 0LbIbSka2GyYZZSOzRlmOnx/m+WdKAk3LQdNCrmS8Zv3itmdOZjYug0nU4B2ZupeGF
	 n5mrsZDuQ6PZ6Kisc2yV091ZAQx9UnuqYgD0AJiI=
Date: Mon, 23 Mar 2026 10:55:34 +0100
Subject: [PATCH v3 9/9] arm64: dts: amlogic: t7: khadas-vim4: Add MMC nodes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-add-emmc-t7-vim4-v3-9-5159d90a984c@aliel.fr>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1774259896; l=2817;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=Ywdd79SLlnG+5FuD1iPwguAxNCDzzkCuTsJrgYS9eQA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFYi+0Gd/+Zfbjizr+3GvRz83PiMYVaWwRvNHIFH0qMDvp4p00u17IJJSA3FSShpYkWVFarxAJD
 yjScxsu/shAU=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Enable and configure the three MMC controllers for the Khadas VIM4 board:
- sd_emmc_a: SDIO interface for the BCM43752 Wi-Fi module
- sd_emmc_b: SD card slot
- sd_emmc_c: eMMC storage

Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 .../dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts  | 90 +++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
index 770f06b0b16c7..5a73ae081036c 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
@@ -14,7 +14,10 @@ / {
 	compatible = "khadas,vim4", "amlogic,a311d2", "amlogic,t7";
 
 	aliases {
-		serial0 = &uart_a;
+		serial0	= &uart_a;
+		mmc0	= &sd_emmc_c;
+		mmc1	= &sd_emmc_b;
+		mmc2	= &sd_emmc_a;
 	};
 
 	memory@0 {
@@ -159,6 +162,91 @@ &pwm_ab {
 	pinctrl-names = "default";
 };
 
+/* SDIO */
+&sd_emmc_a {
+	status = "okay";
+	pinctrl-0 = <&sdio_pins>;
+	pinctrl-1 = <&sdio_clk_gate_pins>;
+	pinctrl-names = "default", "clk-gate";
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	bus-width = <4>;
+	cap-sd-highspeed;
+	sd-uhs-sdr12;
+	sd-uhs-sdr25;
+	sd-uhs-sdr50;
+	sd-uhs-sdr104;
+	cap-sdio-irq;
+	max-frequency = <200000000>;
+	non-removable;
+	disable-wp;
+	no-mmc;
+	no-sd;
+
+	power-domains = <&pwrc PWRC_T7_SDIO_A_ID>;
+
+	keep-power-in-suspend;
+
+	mmc-pwrseq = <&sdio_pwrseq>;
+
+	vmmc-supply = <&vddao_3v3>;
+	vqmmc-supply = <&vddao_1v8>;
+
+	brcmf: wifi@1 {
+		reg = <1>;
+		compatible = "brcm,bcm43752-fmac", "brcm,bcm4329-fmac";
+	};
+};
+
+/* SD card */
+&sd_emmc_b {
+	status = "okay";
+	pinctrl-0 = <&sdcard_pins>;
+	pinctrl-1 = <&sdcard_clk_gate_pins>;
+	pinctrl-names = "default", "clk-gate";
+
+	bus-width = <4>;
+	cap-sd-highspeed;
+	sd-uhs-sdr12;
+	sd-uhs-sdr25;
+	sd-uhs-sdr50;
+	sd-uhs-sdr104;
+	max-frequency = <200000000>;
+	disable-wp;
+	no-sdio;
+	no-mmc;
+
+	power-domains = <&pwrc PWRC_T7_SDIO_B_ID>;
+
+	cd-gpios = <&gpio GPIOC_6 GPIO_ACTIVE_LOW>;
+	vmmc-supply = <&sd_3v3>;
+	vqmmc-supply = <&vddio_c>;
+};
+
+/* eMMC */
+&sd_emmc_c {
+	status = "okay";
+	pinctrl-0 = <&emmc_ctrl_pins>, <&emmc_data_8b_pins>, <&emmc_ds_pins>;
+	pinctrl-1 = <&emmc_clk_gate_pins>;
+	pinctrl-names = "default", "clk-gate";
+
+	bus-width = <8>;
+	cap-mmc-highspeed;
+	mmc-ddr-1_8v;
+	mmc-hs200-1_8v;
+	max-frequency = <200000000>;
+	disable-wp;
+	non-removable;
+	no-sdio;
+	no-sd;
+
+	power-domains = <&pwrc PWRC_T7_EMMC_ID>;
+
+	vmmc-supply = <&vddio_3v3>;
+	vqmmc-supply = <&vddio_1v8>;
+};
+
 &uart_a {
 	status = "okay";
 	clocks = <&xtal>, <&xtal>, <&xtal>;

-- 
2.49.0

