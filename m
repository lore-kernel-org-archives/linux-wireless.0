Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4CC344D86;
	Thu,  7 May 2026 21:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778189126; cv=none; b=EWnFuB86YJBSbUUnZzo1dLM3DwMHJ+X0faWGPg8KUm3ng9y/qfB3qv6U1Y0d/H9RudAEJ7WNageuMu/lkKTrhTfipf4Pr5IV60q3M8ylMzqRnKFopx5MELoZf/n9Xs2mEygY1rCo6jwuSIrCXECwKxD4TjG1vhhXbSzFr8F8lCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778189126; c=relaxed/simple;
	bh=967SAUmoPk5dGwXhSfxFZoiPaIjGZ3mUvj6JEmqje9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AmDA5liwiDC7Fnyg992mRbbK7VfqsCFOuQBqSX77pis0HShvHFK4aPTR+HcHDJ7R8N20EAN3D7ErLjNeRAp5mxQ7Kfvc8Lbg4irJaintjNhAQJ8u+P8dY6m6VgMz/BY/c87cZGGPvol33MvVWFNuSWBSpAvdNXoYzvyWPnjxeK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlKD61xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlKD61xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2A3C2BCB2;
	Thu,  7 May 2026 21:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778189126;
	bh=967SAUmoPk5dGwXhSfxFZoiPaIjGZ3mUvj6JEmqje9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlKD61xAhMKu5ZX4Hq85D9ZIRD5bUHdYUyYrpi6ltiG1xmOgkZUNm9Z3tfQCmlF32
	 aO0RZBr8JX+eaDtVy8fLCDuwx+MUFB8ho6nDxSbE4eSU/8SLrsNAgfe69YkkaHNN6N
	 d3FcwoN81brfqvtFtklJvFf/2dzcGqKGcIqcuPsNJZ8Uwvjco1CTmEbn81joVF4evN
	 KMVouQY80ASy9nYs817jqoEnSMIkE8dx8qunj4rsUfvU6utz+5t4t/9En9bgLdln5Z
	 +a+DyTNNU36AXLx2NBRAmu88SdD9s1UD1BbMkzW3nOfj6sPq7ur0m3l3lnov3huPGd
	 qgffZ3wGsod/g==
From: Arnd Bergmann <arnd@kernel.org>
To: netdev@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	"Aaro Koskinen" <aaro.koskinen@iki.fi>,
	"Andreas Kemnade" <andreas@kemnade.info>,
	"Bartosz Golaszewski" <brgl@kernel.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
	"Eric Dumazet" <edumazet@google.com>,
	"Felipe Balbi" <balbi@kernel.org>,
	"Jakub Kicinski" <kuba@kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Kevin Hilman" <khilman@baylibre.com>,
	"Krzysztof Kozlowski" <krzk+dt@kernel.org>,
	"Linus Walleij" <linusw@kernel.org>,
	"Paolo Abeni" <pabeni@redhat.com>,
	"Rob Herring" <robh+dt@kernel.org>,
	"Roger Quadros" <rogerq@kernel.org>,
	"Tony Lindgren" <tony@atomide.com>,
	linux-wireless@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org,
	linux-omap@vger.kernel.org,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/3] [v5 omap] ARM: dts: omap2: add stlc4560 spi-wireless node
Date: Thu,  7 May 2026 23:24:51 +0200
Message-Id: <20260507212451.3333185-4-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260507212451.3333185-1-arnd@kernel.org>
References: <20260507212451.3333185-1-arnd@kernel.org>
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

