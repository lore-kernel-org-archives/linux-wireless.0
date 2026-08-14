Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9316045A28E
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 12:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711893; cv=none; b=WdfiInv6CSOES86mwxSe2RlJNB81gXDFWGjmKSnY0kSaA99bCkYUAsTuexeupoIzBKZeQFm09krEpYRBQuO9/LAkzu0Lym6HqsOY0UPaIhKmsjmscPOHhmd/+ZCXNUZ5qw/h7n/FLQerlDGO7HX2O/Jo3yPffbLlpwT/C4Pyeqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711893; c=relaxed/simple;
	bh=OHGL18JNsV6IVQVjmPUIlUU1PvpdUGkcQSXTvXzb80I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtpDpapx/y/wMviSnhTK1KyWS08emM/hHPbZ/PSPZGJO6n6MrvPeCedbjQDak1L803aDwxCUEYmj0XF3sbNDGjb1zHWK2+9ybXvVxBfklzDXDkHWf5EfZiQCy6s0lILWZU2opUEA5DEmlihGqvUgzDl/Tj5Gte/V9/DaekVo0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eInI9stt; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eInI9stt"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-472326ca506so641845f8f.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 05:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786711887; x=1787316687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zb0qDDFJvzSa8yRML0htKvOY5KPeiSCo7J7EimJJcYU=;
        b=eInI9stt3Ss4IoDLZ0szqWxobNxU6Tiyj3adcfyE5A79WW6v2s8aemQzlRiouL8IIL
         5phKI0ClCTyGmp5hLrZBv1JO1jbEGw3pNmddcZRIjHNDHm/dZw/bVCeaRK+U6ICHEkap
         +XbWNMF+xDyssj60OMt3s+0R5uWmmJ3329kXJwwsGxyEL4ZqAfbi318Yq+Ge6MDmfPtO
         J19rGUV2ptv0qcO+dIKSuRPRJl0WgbiQzbvS96jsShnXxhyWoW+wUOj1VAqefeakTZJv
         aiTzt3fV144racccmADSWSfzuVgDaKIS274KRa5CdTfTGlf+0q0CnoIV6wTcr76qF8Zd
         y2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786711887; x=1787316687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zb0qDDFJvzSa8yRML0htKvOY5KPeiSCo7J7EimJJcYU=;
        b=heX6O9gSthEASjAolHeMGBBfesZEwSTOPAxyl+jJpZPsL3vkBMMf7B4VOq2wgPZXxx
         cu7NQ5FUq/wRh+eiMjpsedeGQuVorQzPhtiJu2Oj0r8X5JVMUqoXn7gZ+WQTh47n0jXM
         XgiWqiYTpnIqL9Z1d1DCSVNenya4Rr3xA8V7DmEE+4ft2Dq/yWM/OonHAfafShGgEFu4
         wo7vQSCLRZsOacbkr2dhTQzsMAcDg/lZkWzT9mHbac/rzDkm1XXps2m5HgQ5SVREe9Sm
         j80a2NmvZBcwwdEDeK/2klm7X5YMAC01CRHLOa4dPeyPDfmdy3fZtPmEOK+UAEEKhiMU
         mofQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr9DME0BDz4nOE5dXnK1o6HRzk7vpJ8qLI0dzX4Vrvc5p9KfzY6o+NE7UBzgM0AtJTPDiwsbmfFeVOd3tkYSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzugjqWI/GDlxm0wA2Gb1AER/N/pzeFRheaoFMzHKYRRF90bwkT
	oY77BIUHsN/JxBfNMZWZENhQep7lvWmDL/kTJ/og4WVqktmJQ4tDAGWm
X-Gm-Gg: AR+sD11kpqBK9MARrIh2zooWYTSTowjovj4Ie0PPGS08gX6ez7HFeknKOhV1z0Q/9qt
	TuU38iyOjg/tJQ+LNL6JS6+S8/aqK/nVyQ6U1t4loVwRMIIC+wvQxAbxzp7vqxTU+yXVLr6qBwO
	TcpUPqW59vaC9KS4khbueSR4lhG8euakIknpVmtetAjgNFlWZDiWoQk+hTlPey7fMvAiVdDWtb9
	kCULEAdY1xHbSK2CVuOO+QSefIOCreAftOIQIadIN1qnPCk7+zAHE0zMkm/cy/CR9s2i91WGpbA
	s/F1t1EiSBf/laiIbeuX9OKWTvAGXZPLdQmqUJKlZoNu6Tjew7ksPaO2LVXQWkVkK9sJ1I86hFK
	BmVDBNnngyoMUnz7E8vfUuFApyCI18UyP6M9IftkYrwPSjKmHzRQwlQ4EIHnowog4cW/PkzEaa+
	6B8iUsOVcHfVjHVYnZTY7zY4O/PFqRPT10vISFjXHREBH/anXxgLdAH3ge7KYff50/EbIP7JK2U
	B5ciBHkjTluyaE2+z/IRLHolO/VbUOW3zLYI5uAY4z8FJ+i4czofUl4qIPCqdM5fA==
X-Received: by 2002:a7b:cb1a:0:b0:498:519:e660 with SMTP id 5b1f17b1804b1-49987935847mr52299035e9.4.1786711887107;
        Fri, 14 Aug 2026 05:51:27 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988ae8b62sm49727315e9.5.2026.08.14.05.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:51:26 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	johannes@sipsolutions.net,
	andrew@lunn.ch
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
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Frank.Li@nxp.com,
	chunfan.chen@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH 2/3] ARM: dts: armada: WRT3200ACM: add marvell,ignore-regulatory-hint
Date: Fri, 14 Aug 2026 15:50:24 +0300
Message-ID: <20260814125025.90522-2-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814125025.90522-1-gvalkov@gmail.com>
References: <anoYr9H4KojJv-aZ@google.com>
 <20260814125025.90522-1-gvalkov@gmail.com>
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

Tested-on: WRT3200ACM, OpenWrt, make dt_binding_check: pass
Cc: stable@vger.kernel.org
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
---
 arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts b/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
index 4ab45f294de2..c5f94463ef71 100644
--- a/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
+++ b/arch/arm/boot/dts/marvell/armada-385-linksys-rango.dts
@@ -165,6 +165,12 @@ &sdhci {
 	wp-inverted;
 	bus-width = <8>;
 	status = "okay";
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

