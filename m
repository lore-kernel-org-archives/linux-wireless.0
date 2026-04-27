Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4446A362130
	for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2026 03:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777261489; cv=none; b=T6LC00kFdMmI2OnoakDt2DjR1CdjK6Yd8HrF2IHrUu1lnEwh8gJN9Kv7JAa3HqxGyYzo7QWBKW+vs3nnsGZGM5g00si8GydYvhcbk/hLOZXV3bXTDhyBVPJWHIHXqXveiTRnzVXbfoNR4N8zhJ7+EB2YKnL2HN8xofCJggoT6P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777261489; c=relaxed/simple;
	bh=A343E43pW95EP9AO8BFmFQukqMiRwvLdirbY6h+orZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE7qr121vviVz8c/YTDYjZjpYDXmy6oRa3NQgDkytSvnS9cYHCvunu3WjvJzyJI6brNKXd0mE8w2mmcRPcd0xN42c3NvLVsedU1Nr6KGNb8+Hwdxo15vkzx2Az6SZCJsOmWr1jCWVKWOqXLSsLWGzk0dqpLeM4OBszVg9f3jaug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=st20g3eS; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="st20g3eS"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2503753efso101132585ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2026 20:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777261488; x=1777866288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LnJZvLH9bwq8rkIs+Lcwlv8aSN2xQ6iGFhBeGaXxuk=;
        b=st20g3eSaLO4SR5RZZy5U+ro4XhaAUD4EDcUnClaEoStmSW1uzftJswByLnDm2Exzu
         3XGjbTy+s6K/Q0fS7acAUmlQ5milQXKvKIuiJN4/x0PDvL44aydKSyEiw1mu1BERNKX0
         2bHlo5eSMDj4YysrZgg4KJAfxl5stb3grzm9znxCyUP6f5tMdkoRfFDvKo1tqqcC+In1
         4O8LFLX2WjLUrkA1whvNeKHKoDgj7PasfQlE7Ga1Ae6EChPWr0jspMbl0NsWRSTP1mGX
         PoedB1ApUWTkimv7XHUwKuIbCfqJv6SBqQFm5Ffj2I04gAi3jsfzMLLYg0TmpalPRG+f
         Vg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777261488; x=1777866288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6LnJZvLH9bwq8rkIs+Lcwlv8aSN2xQ6iGFhBeGaXxuk=;
        b=DsZK4qusbi8G+RJIkg+HwdOOMqTXeg3Nx+7CYKNpdYBxe1I32YGp2UNbHxPuTZRSZB
         99XF2n2Pt9bsceFw2SqM0UWP9G9UAD3iOg2zoQimuN9aOITZpFkbSIYeivVV1qi9uE+S
         uzfhVOHatIdQ8EuEmOXrLUhrLUXU1D7KmpKrkTm+CbNJE1hXRhhFg/N0lRxs5DVq0Ao+
         l0ad1qZsxvNdrkVoyOxzuAKyhwGNlyLCReSPBQfrUE58pGMf5jIraP5ZRyuOa6hAW2vz
         r9NAMmM46g1pHRB4pdPPg5ZQr0vkYdWKJlxEci/kHfPOaXgTJs0ckM6OjiARPdEdnA0a
         aE/g==
X-Forwarded-Encrypted: i=1; AFNElJ8oDyegIPHO7GaAQZH9D+6gQRzKZKl+WNSnuK42Pui5V8ZyLnM1H3+NrlIsVdN/K9CvoLgbpsc6sACuwB/BIg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp5cAiHvBTJu6paipTp4RgVoCM/1bBaPakC9ZZFA+qMiJUSQiB
	ZhPSaqDOOmSDOYtiTTiIgcvbY6HDBlHDOykuePxZH4l6tjIQmTE5F4nw
X-Gm-Gg: AeBDieumE8tp+l5P68cfnRyay05zIj1Y55w8H4VWrev7eKDo/Fpg0sdvPkE3aSozvYq
	mu9FkEf7NpXGVYZr18CfHGlEraheSri1rW9If5TA27iaTMAgKYWxKDrQnspDT4E/OxZDaka58IA
	XIIi4TVB9ElfNA+rDmGjgOgqr0l6/hn19No4awuzHTk5eezW/mfF/pD7VemEUf0Tb0e5xWgM/tJ
	Ted/RE3N04m2Qb6ph49x2GP/3hq1lzTyv3t+7uqRpidodqFJKux/JSwUWef59AS+4dO0dhblicr
	UvaoYUL1gtVDEaKVlL36w1dDCy0Quz/y4uz1Rg4un2TwGrgE/AEYrVn6ivwXbVf5XzyvRoImga6
	lxpjV4ki/uVnXiBhZPXFdBf6fkBYVsGFGvwg6t1nrUsDJzyn8QvDR20bMyYTeLicbptUNQJDtIi
	7xqnKf08mgT4Kuv8Cv31vnitIVSIa8CxnMbJKKghMD3RSNcleWRl0w6gqAjP5qM2xpVioXssnQ2
	2WQK58ymJlBqNqwW8ck5DczmA==
X-Received: by 2002:a17:903:120d:b0:2b2:489a:f46a with SMTP id d9443c01a7336-2b5f9fbc5a1mr463142335ad.36.1777261487655;
        Sun, 26 Apr 2026 20:44:47 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa4f092sm290610585ad.36.2026.04.26.20.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 20:44:46 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: devicetree@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	linux-wireless@vger.kernel.org (open list:MEDIATEK MT76 WIRELESS LAN DRIVER),
	linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support),
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support),
	linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support),
	linux-mips@vger.kernel.org (open list:MIPS)
Subject: [PATCH 1/3] MIPS: dts: ralink: gardena_smart_gateway_mt7688: use nvmem for EEPROM
Date: Sun, 26 Apr 2026 20:44:25 -0700
Message-ID: <20260427034427.881389-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427034427.881389-1-rosenp@gmail.com>
References: <20260427034427.881389-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mediatek,mtd-eeprom is a deprecated binding for extracting data on MTD
devices which has been replaced by NVMEM.

The latter is already in wide use with mt76. As this is the only user,
transition to NVMEM.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../dts/ralink/gardena_smart_gateway_mt7688.dts | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/mips/boot/dts/ralink/gardena_smart_gateway_mt7688.dts b/arch/mips/boot/dts/ralink/gardena_smart_gateway_mt7688.dts
index 0bfb1dde9764..a8a8efbaf527 100644
--- a/arch/mips/boot/dts/ralink/gardena_smart_gateway_mt7688.dts
+++ b/arch/mips/boot/dts/ralink/gardena_smart_gateway_mt7688.dts
@@ -155,10 +155,20 @@ partition@b0000 {
 				reg = <0xb0000 0x10000>;
 			};
 
-			factory: partition@c0000 {
+			partition@c0000 {
 				label = "factory";
 				reg = <0xc0000 0x10000>;
 				read-only;
+
+				nvmem-layout {
+					compatible = "fixed-layout";
+					#address-cells = <1>;
+					#nvmem-cell-cells = <1>;
+
+					eeprom_factory_0: eeprom@0 {
+						reg = <0x0 0x400>;
+					};
+				};
 			};
 		};
 	};
@@ -201,5 +211,8 @@ &watchdog {
 
 &wmac {
 	status = "okay";
-	mediatek,mtd-eeprom = <&factory 0x0000>;
+
+	nvmem-cells = <&eeprom_factory_0>;
+	nvmem-cell-names = "eeprom"
+
 };
-- 
2.54.0

