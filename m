Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD71499F11
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787851203; cv=none; b=g1C4RBhm6dXjzlkYFkOEIGDxSl0kQTI9ntJL69WohS4emKJGW5cC1xWgA95xpvsESy565mNbpDclaCF9rfOKo2nzDvui5Uoa1WQKwhbi4plVWHF38o5mTkRtqjhjjKYhDu8vXhc+4H+L192vG2hYnvS6GvvdR3qGE3UJC2QKdxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787851203; c=relaxed/simple;
	bh=sarQEdrSbBSoaCcKumeb7DKx9O4YVpY+WCIk3ge9e4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYdB6MTn5JJ5Zc6Qf4hOwlSX+cdsaAa4y1heVkuNJp6TvJwrSnEuEmrH7E7azHUladwAhjisvaJfmcxPA2WLLem43BqPuS3cxfPpOlCHnOntyYBFZUs44tSlR+sGyAwxyAYCfHIlLKISEGxvxYrUNLlcFyCsXiyK4RR0szpyS2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tEps2p9e; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tEps2p9e"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so925e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 10:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787851199; x=1788455999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QF2zBpTs1xbQ8vVeDBrFP8mtx1WkUete3RSSn/zfKZ4=;
        b=tEps2p9e7u6LtM/r7j+mxS7RQVGVczPGAZqMWu3/0e5WIi60MLN/cbsY5sMq/zmTKA
         OepblmJnA1Nk5Hbe8HBM0uvzkH4vlY+S9sUgK/HsogUzzVt3C3iPxhi7cIulS9yDUjkA
         93kRClvP1yj3NIM06fNQkDBMQgeMRklqllV/AKuG6L2HZqMtWvu/VvhsGouGUoOApXqk
         1cZeqLWngayNaGavonG4NhReCmS5Q81IEKUm6SfKSYueWEaUHAaa+y33D4gyakgU8DIZ
         8bT7S2+uqnPNDM5y0/JBGREFFYhMoP+/P6rzpHvaev0ccS5kuD0g8+VRgUqoT/rC7sM5
         gYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851199; x=1788455999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QF2zBpTs1xbQ8vVeDBrFP8mtx1WkUete3RSSn/zfKZ4=;
        b=tKjPnj118plOG8pBVWP6UOAQ8aDoqZjpIRsl3qa+pMiXeFPTAFHy/6vqRQKsDQdjGc
         eaa1lRQVaaROstM68o2e5/QjxOMXiZnekD5kjPWiuQu5cu+qW2KzaBP1AoRWV//0y6OE
         MZ2yOkMlqexQgN1P1cepRrPVivyku8aUVPcfmFHZH0MUxHHtlZmIKDmPa8JX4Heor5pb
         4wMp3I3ApYoDiAw6goLESgvVMv+2D0iq9g28bcDjOpZ58NGiW4Mar0NJ7ogRFsc9D9uB
         f7/t71LGS2ILRzOJAcaLtMhmqdeA6acU7/d16781ZtwpZqjevzERnCVMOPZApshe1+Dl
         262Q==
X-Forwarded-Encrypted: i=1; AHgh+RpWPG9uDXS1R7hw9MdXUgIx9R4ObRKYVv71F8SpvDpWVriJ3xrAl75/t13FK1qRNzOXtuXq4jqRThb521SCsw==@vger.kernel.org
X-Gm-Message-State: AFuF++m4aV7+HXTDo2Qb2u6HJfXskH/l7+l+CxoFn09V0iaSqx6SVd0Z
	26B0NG+bNvBgB189fbK5rnBCdeXSdK5G1hchqe7cZSnUNkE4cnJG9NYZ
X-Gm-Gg: AR+sD11ypyceRePRthJhd/cpGbyooC8Fd0SS8FSmz29DBn3UYm+j1IvqQ6ld7sh+t4q
	dRhy3mSHL+wR+a2mVs6ADX2h7UoNOHwlQd4cFZWKGHyyCGl6jWgxfZCgYIQgPXSAa3p8gV8cyHS
	gFEh6wd1zezH2vVPCexOFNaFmgExItIIXkX4uWjek+jqOyyXFRZbHY9WWFMnqZjcEXYDnyuvyjf
	0/mcxPor6jnmjvuMOJ/Ds3t8p/N0sdEmgjkyG2vlykH566sd/yG5veYe1xzsdKeirsGsmmN5Mio
	nYYY1yufPDl8106TZTWUNmhDSSkI8qzg5XMs1QVvVqgM1xUaX91RIlycK9FzeZEYD1fUBZbcLQG
	oRKoBR829ps2Vh3kaFuThfFkwmrN4a1WT4h9YF3wwiV3hOYdCzqJInjff1RvfWKpOuJiR9ggdIw
	Poi4amEVR2I4bts+2fLw9FAad7iq2TfwK/EhiSaKSlXdadJ8n5UENSoeEtOEoJkFokWLxECkMHA
	DgATylnWO6pDF4OddkwOV1oS22KH4qCZcyGm+JObd+GmEOW3wLMoEaCAcQx1YtX
X-Received: by 2002:a05:600c:c493:b0:499:a5c8:c6f3 with SMTP id 5b1f17b1804b1-49b91c20914mr7700005e9.3.1787851199182;
        Thu, 27 Aug 2026 10:19:59 -0700 (PDT)
Received: from localhost.localdomain ([85.118.83.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b4ad16262sm54259995e9.11.2026.08.27.10.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:19:58 -0700 (PDT)
From: Georgi Valkov <gvalkov@gmail.com>
To: briannorris@chromium.org,
	johannes@sipsolutions.net,
	andrew@lunn.ch,
	krzk+dt@kernel.org
Cc: francesco@dolcini.it,
	johannes.berg@intel.com,
	kees@kernel.org,
	miriam.rachel.korenblit@intel.com,
	rongqianfeng@vivo.com,
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
	arend.vanspriel@broadcom.com,
	peddolla.reddy@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	stable@vger.kernel.org,
	gvalkov@gmail.com
Subject: [PATCH v8 3/3] ARM: dts: armada: WRT3200ACM: add marvell,invalid-reg-hint-in-rom
Date: Thu, 27 Aug 2026 20:19:37 +0300
Message-ID: <20260827171937.28878-3-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827171937.28878-1-gvalkov@gmail.com>
References: <20260827171937.28878-1-gvalkov@gmail.com>
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
preventing phy0 from starting on any DFS channel. phy2 works.

Add node wifi@1 with a flag marvell,invalid-reg-hint-in-rom to the
WRT3200ACM device-tree, which signals mwifiex that its regulatory
hint from ROM conflicts with the platform and should be ignored, so the
platform regulatory domain can be used. This does not allow the user to
change the regulatory config of any radio. It only allows phy0 to start
and operate according to its certified configuration. All radios in
WRT3200ACM/WRT32x are locked to the hard-coded configuration for which
they are certified.

On WRT3200ACM, the platform configuration is stored on the devinfo mtd3
partition, which is read-only: cert_region=EU modelNumber=WRT3200ACM-EU

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
index 4ab45f294de2..2bf29981a031 100644
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
+		marvell,invalid-reg-hint-in-rom;
+	};
 };
 
 &usb3_1_vbus {
-- 
2.55.0

