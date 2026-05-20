Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6013F9F25;
	Wed, 20 May 2026 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302400; cv=none; b=T5Gf1NRTXF7bymaSAUrND2uoaWTOzBl1qf46shYE8m0ATCWjWHqfv8U9OeMDADWzhJ8+vSjaHfybG+23I8DMqDOm6YN/ZPv4rZs+gi/QqfvpiJsTPGv23rH9COdmj3uculJ5LqM7u2QDPN2S6Zy0Y+l8Rl0JPBJIhr4fUCOlf3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302400; c=relaxed/simple;
	bh=nx6CKUotEXycIcA4vFZIxP7wYoL6UwIjQA6phycHux8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SuuFE76elkLqdw0nEp8T8YeyBgY+bZzwFw89ZL3Kb2XZ6+ALtnOvZB03pyNisDdkcLNdGfsSr2hIWwGrpro8mP4lY5uIc0GFId+U2uUVDiqiQ9TvB0W95NA3VfAJ0tcGJ3o77gl5T0IdFu8nD7gDqTPi0bAyJxB70t5ilmxDtfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fxl+zUsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fxl+zUsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E881F00894;
	Wed, 20 May 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779302398;
	bh=xNZ6LFpDqSiliRDQZffjOR3z3XDTMAtPwuRo7ubH7Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxl+zUsGxVFhG/PBg4Zy8jA+vL8kZdsM59y/NtRfPOp7u/r/LABun0NFwYqtoCLxJ
	 oItN3JvNyGnPnk2pYUmY0QD+rpHJXhT6IPSHV/0E2KWzxkSoGcqjFsdapG3hn4TS5i
	 cto8atcvmCtdhnYhh7qxKXci7nMrRI3qeqwHmZF70tRPs9PkleaVlOEfDvFQs4HOZC
	 kpbbjeYFjfO2xROIXOd5Yvej42l57BYPpRoSGk1wyCzRLl82f/cP2fNGrvjXdAsSyQ
	 M3wcIkyvpYUAb4VY3eAlV3sRxNwRfVLyLh4X10HOmxql3sXhmPVx86tuyiCD8y+BA5
	 6naBM/eFbkhuw==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Roger Quadros <rogerq@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org,
	linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-input@vger.kernel.org,
	linux-leds@vger.kernel.org,
	netdev@vger.kernel.org,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 09/10] [v6 omap] ARM: dts: omap2: add stlc4560 spi-wireless node
Date: Wed, 20 May 2026 20:38:14 +0200
Message-Id: <20260520183815.2510387-10-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260520183815.2510387-1-arnd@kernel.org>
References: <20260520183815.2510387-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Converted from the platform_device creation in board-n8x0.c.

Link: https://lore.kernel.org/all/20230314163201.955689-1-arnd@kernel.org/
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v6: no changes
v1 through v5: adaptations that correspond to the binding updates
---
 arch/arm/boot/dts/ti/omap/omap2.dtsi                |  4 ++++
 arch/arm/boot/dts/ti/omap/omap2420-n8x0-common.dtsi | 12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/ti/omap/omap2.dtsi b/arch/arm/boot/dts/ti/omap/omap2.dtsi
index afabb36a8ac1..fdc1790adf43 100644
--- a/arch/arm/boot/dts/ti/omap/omap2.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap2.dtsi
@@ -129,6 +129,8 @@ i2c2: i2c@48072000 {
 		};
 
 		mcspi1: spi@48098000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi1";
 			reg = <0x48098000 0x100>;
@@ -140,6 +142,8 @@ mcspi1: spi@48098000 {
 		};
 
 		mcspi2: spi@4809a000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
 			compatible = "ti,omap2-mcspi";
 			ti,hwmods = "mcspi2";
 			reg = <0x4809a000 0x100>;
diff --git a/arch/arm/boot/dts/ti/omap/omap2420-n8x0-common.dtsi b/arch/arm/boot/dts/ti/omap/omap2420-n8x0-common.dtsi
index 63b0b4921e4e..fe9dd8bbfc85 100644
--- a/arch/arm/boot/dts/ti/omap/omap2420-n8x0-common.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap2420-n8x0-common.dtsi
@@ -109,3 +109,15 @@ partition@5 {
 		};
 	};
 };
+
+&mcspi2 {
+	status = "okay";
+
+	wifi@0 {
+		reg = <0>;
+		compatible = "st,stlc4560";
+		spi-max-frequency = <48000000>;
+		interrupts-extended = <&gpio3 23 IRQ_TYPE_EDGE_RISING>;
+		powerdown-gpios = <&gpio4 1 GPIO_ACTIVE_LOW>; /* gpio 97 */
+	};
+};
-- 
2.39.5

