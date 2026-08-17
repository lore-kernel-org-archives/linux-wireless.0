Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3CC3D8907
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 21:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787003728; cv=none; b=PzthcOffyeBu2e/A+hJ5D8FeE4/rRoefd804H4L1+zHeSXr5CsRlh3Ds+OoIifExao2P5iDghWnuhla5isVsXbnNhcC3Tlw7d+dBTbROA+GEF0VWts4iVP67SGi2jiXh2t1MIqI1z9lgv5Qbw1PPonmIt0srAsRSUKdooMAklbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787003728; c=relaxed/simple;
	bh=ZpKYehF5OAFiXqHvT/wU3yvfoAZi9NS1PO2rZIotS64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1B6o3QsIkkOCQcRFm8X7gn2vQ1mTHGWuTek1t1UlyXystWxOocdUNhoMYoTNi8w+IrqZNOE9XFSA+Xg7XejI9xQIlOZEe3RIQ1XbksNboHtLrTErJtUUFhB8BY11xGmerv/P5QnLuioLKgX1mXL8eeOwTg6FYcyhWTQ4zL1nOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oQp6dC75; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQp6dC75"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49954b88fffso44553605e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 14:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787003718; x=1787608518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y756HdfLaSb69/zEjo9fJeL8LylUgwNNsMBSux8mExc=;
        b=oQp6dC75qRa2FkcTl3XEwGXcsV3BxKsus7qy4vfWOzhGpJM/dkEod7qKxosm6YBtiF
         dEbO+7KEJ10cUAVABf171SMsjaprVFb+L4c0Kto0KR3qcZg92bOaadcI1D+TybE93pSy
         +psaxtXfk4V3ApCumtVA2vCnzLDNRQL00DpoAfUT2fhEx3XUgQ9LNi8DVc0KnM6f/STO
         h/QO2vRlVqqoba6AyeZCM9fgGF0yzS8hUbjAJEh9QA3B5zE8fxaCeTLBnAvrD9Pf9k/U
         emTVvi0LTHnw8kTHdrsAVbiWs171oNa2kO8pi8MDZQD1wUDHWhBDtiyGgvbf4Aa1n2kc
         mC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787003718; x=1787608518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y756HdfLaSb69/zEjo9fJeL8LylUgwNNsMBSux8mExc=;
        b=OH3QAhS0ANBHC/PLyhVB1Qkmj+c6nVyXBge4X2PmJT7X9NHptMqmTsgisD82S6smgf
         ZpnwSnLH4Z7Vkxtnhky8sSAJ6myZP1KfcZ1eQMyVLwQ7Xg+3qMGZ3ZzcZ9GlNin6nAMV
         tVr52PcjEIddWX1Qj6VdsalRF4nWMdQOWMVHCLGzabRfljwDdVJEbmAj0xhqxEXNs7wE
         aX5/KlOvlacSJwNbHjiz0bZpARQAG0CMpz1gC3z9L7bcnFA8RVGUwB9/SNLNZ87GNmAO
         9nxns758c5MMnwajSYT51MbZa24+hURBm0h96O8epipQHsLNc+p3DUdVb9SzI5j0AU8E
         8ZmQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLU+WkkLXJHTUs6FsHobHrS/qlAqtyK26Ekn3CByOsxeJITJolW7hUyd1uqsIpf9YIejh0p5E1u176wj63jg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZuFMZfAXOo7wg/7Wugg3RTD/mP9sRd36uz2XEHL7i9wHx2ggu
	8Fm5B0HYdVMjlpPZVZZ4wn3chBUknzU8SOwcaJ3Zx1HootPi9UnQVPes
X-Gm-Gg: AR+sD112GYL37LtC2XK0K4Ee8pTzId7A7WdccthwPwncQvC0qWyarff1tcN1U8TDXrF
	2eqaeQkPxhOBFbfMlqihHN1nD5u7x1Fhpdv2Qzw+aaGM1S/vEumAr1TQ07s8EckDqfZZ9RitM/s
	y9r6LTF8VBpuyy16g+6XVk6ukwfGW7yeWDS38IRENKg4xwZ6pBppHGK3xiAdJYhTeI/3hmp1lq/
	sPgYOTWmhvvuEDiP1bRtRNZC84P4xxdNQj8EB53p02B4crZjKFHn6pFvHoYCtFM1MhYMN4Mz0Kf
	VmaXgYOWngX3LoP/plw0mixPCbCl24+eKjmUZyVAcMS7cTgRiSt5Id5W6bJ44EN9cyO5S788IL+
	RbgHImKgzEFcgjR1LOy2EPMNWe6V7Xpzw1yeEbimlozGfNfo6fEo+Z5Huojt9D87bDZEFBCS9RL
	PojJcdDy4mgCC0bdiRUkxtLzXMin3EMS1rDi45/ReKWUNunKHYVHvVERGkUeg36H8qqCWaQpzdO
	+KOb57VJg+hkZxOJvlCXP1vDCrsFXfEllejaHHUcFNkXGz8pmtvgL5mmLG3tcZLLdGZrOeDh/nf
	pH3AZI7Jbw==
X-Received: by 2002:a05:600c:3485:b0:499:726a:a017 with SMTP id 5b1f17b1804b1-49987938e19mr460386255e9.1.1787003718146;
        Mon, 17 Aug 2026 14:55:18 -0700 (PDT)
Received: from localhost.localdomain (85-118-76-205.mtel.net. [85.118.76.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b2a176sm309622525e9.4.2026.08.17.14.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 14:55:17 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	johannes@sipsolutions.net,
	andrew@lunn.ch,
	krzk+dt@kernel.org
Cc: francesco@dolcini.it,
	johannes.berg@intel.com,
	kees@kernel.org,
	miriam.rachel.korenblit@intel.com,
	wenst@chromium.org,
	rafael.beims@toradex.com,
	avraham.stern@intel.com,
	error27@gmail.com,
	s.kerkmann@pengutronix.de,
	gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com,
	robh@kernel.org,
	conor+dt@kernel.org,
	Frank.Li@nxp.com,
	chunfan.chen@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v5 2/3] ARM: dts: armada: WRT3200ACM: add marvell,ignore-regulatory-hint
Date: Tue, 18 Aug 2026 00:54:27 +0300
Message-ID: <20260817215428.84740-2-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817215428.84740-1-gvalkov@gmail.com>
References: <CADOrJmbTyrGGkq+9OJDXCgTa2HvNo8BWxoE6yjafcrOq7WNamw@mail.gmail.com>
 <20260817215428.84740-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
from the mwifiex ROM, which conflicts with the platform regulatory
configuration on units sold outside the US market. For example:
- phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
- phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
- phy2 mwifiex 2.4 and 5 GHz, hard-coded region US

When the system boots, it detects a conflict between the user selected
region and the radios, e.g. BG FR US, and applies extreme restrictions,
preventing use of 5 GHz and DFS channels. This also affects phy0.

Add a flag marvell,ignore-regulatory-hint to the WRT3200ACM device-tree,
which signals mwifiex to ignore an incorrect regulatory hint from ROM,
so userspace can set the correct platform regulatory domain. The radios
in WRT3200ACM/WRT32x are locked to the hard-coded configuration for which
they are certified, so the only impact is that the region conflict is
avoided and the 5 GHz radios can be used.

The Linux kernel sources do not have support for WRT32x. An equivalent
patch for these routers has to be sent to OpenWrt.

[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
[2] https://github.com/openwrt/openwrt/issues/9956

Cc: stable@vger.kernel.org
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
 arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts b/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
index 4ab45f294de2..b93c5c419962 100644
--- a/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
+++ b/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
@@ -165,6 +165,15 @@ &sdhci {
 	wp-inverted;
 	bus-width = <8>;
 	status = "okay";
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	wifi@1 {
+		compatible = "marvell,sd8897";
+		reg = <1>;
+		marvell,ignore-regulatory-hint;
+	};
 };
 
 &usb3_1_vbus {
-- 
2.55.0

