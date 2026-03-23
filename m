Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BA938A298;
	Mon, 23 Mar 2026 10:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260517; cv=none; b=UH46TihpSlmB/3L1nQMpecjTYl40eYtk9z0s8+1wKgB50OsYOEiL5b5Jh/9UyCI3KaRbaoBsc191X6UtX92Pix6pckjvE+ZqtrOVuC68U8MvKDNwFXuuhvqFmoV6F2/svqCMZG2CjSxGRL6FDqKTtcRcMWrFLo/QBNYblMO3KJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260517; c=relaxed/simple;
	bh=nLzHsr5SRGXnJ4qXDllE27wn5dbe27jEjWThdkARNK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TzTvzRzbMoZ5u0DlbryLWPIiCID319LG12FkeehBObuqfK3T3V4s7XbGxyF/I5zsINb//b8E9+vURzm7IM4P6qnkgkvsNzyRXBsHRpajfq75JaFd9urLwQR4imuok8l4TK9E5cJwin8UwoW17fKSJkgC8Pvea/WCkL8lBlD1p30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=bnx+U5Wv; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="bnx+U5Wv"
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774259899;
	bh=nLzHsr5SRGXnJ4qXDllE27wn5dbe27jEjWThdkARNK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bnx+U5Wvh/cA2SipleVXznvvZVQWW756NQ4xJmu3oUEWx1cwUj+J8T2Yh7+JIgeuQ
	 w2znGpMOumy7zO8w4twzLcxCDKripDH1KFUkDXRghWRWxryKp/iBBhDL5Gb6E4Sf1D
	 ATTw3BzKDRbzjDKXLATkhU4oFZIw3yjTIdRiFZRY=
Date: Mon, 23 Mar 2026 10:55:28 +0100
Subject: [PATCH v3 3/9] arm64: dts: amlogic: t7: Add MMC controller nodes
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-add-emmc-t7-vim4-v3-3-5159d90a984c@aliel.fr>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1774259894; l=2309;
 i=linux-kernel-dev@aliel.fr; s=id_ed25519; h=from:subject:message-id;
 bh=nLzHsr5SRGXnJ4qXDllE27wn5dbe27jEjWThdkARNK4=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgMGec55oxeeisqykQiUedekMYyOnR9
 BG9E/7rDWyqdNoAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QG9MimcCwQl3IDkrclTMocdwMakL26xqJ0ECX4klkPvSWc4HTeiBQxRZHQWAOyPrBYwPLHfbpf1
 eeQE/zuhbhwY=
X-Developer-Key: i=linux-kernel-dev@aliel.fr; a=openssh;
 fpr=SHA256:kch4osYZ6A1BrPps5AUs6KnfdE2wm4ocMtyTc8TmZMs

Add device tree nodes for the three MMC controllers available
on the Amlogic T7 SoC, using amlogic,meson-axg-mmc as fallback compatible.
All nodes are disabled by default and should be
enabled in the board-specific DTS file.

Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi | 39 +++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
index ac8de8e9b8010..b3898669c9571 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
@@ -374,6 +374,45 @@ sec_ao: ao-secure@10220 {
 				reg = <0x0 0x10220 0x0 0x140>;
 				amlogic,has-chip-id;
 			};
+
+			sd_emmc_a: mmc@88000 {
+				compatible = "amlogic,t7-mmc", "amlogic,meson-axg-mmc";
+				reg = <0x0 0x88000 0x0 0x800>;
+				interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+				status = "disabled";
+				clocks = <&clkc_periphs CLKID_SYS_SD_EMMC_A>,
+					 <&clkc_periphs CLKID_SD_EMMC_A>,
+					 <&scmi_clk CLKID_FCLK_DIV2>;
+				clock-names = "core", "clkin0", "clkin1";
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_A_SEL>;
+				assigned-clock-parents = <&xtal>;
+			};
+
+			sd_emmc_b: mmc@8a000 {
+				compatible = "amlogic,t7-mmc", "amlogic,meson-axg-mmc";
+				reg = <0x0 0x8a000 0x0 0x800>;
+				interrupts = <GIC_SPI 177 IRQ_TYPE_EDGE_RISING>;
+				status = "disabled";
+				clocks = <&clkc_periphs CLKID_SYS_SD_EMMC_B>,
+					 <&clkc_periphs CLKID_SD_EMMC_B>,
+					 <&scmi_clk CLKID_FCLK_DIV2>;
+				clock-names = "core", "clkin0", "clkin1";
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B_SEL>;
+				assigned-clock-parents = <&xtal>;
+			};
+
+			sd_emmc_c: mmc@8c000 {
+				compatible = "amlogic,t7-mmc", "amlogic,meson-axg-mmc";
+				reg = <0x0 0x8c000 0x0 0x800>;
+				interrupts = <GIC_SPI 178 IRQ_TYPE_EDGE_RISING>;
+				status = "disabled";
+				clocks = <&clkc_periphs CLKID_SYS_SD_EMMC_C>,
+					 <&clkc_periphs CLKID_SD_EMMC_C>,
+					 <&scmi_clk CLKID_FCLK_DIV2>;
+				clock-names = "core", "clkin0", "clkin1";
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_C_SEL>;
+				assigned-clock-parents = <&xtal>;
+			};
 		};
 
 	};

-- 
2.49.0

