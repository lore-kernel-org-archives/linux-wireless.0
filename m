Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6734F38BF62
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853581; cv=none; b=aR1fZwapzGGE0zlu5BpPgAMnUho+wscwx2INB3QOrpDhX8FSLTv6/aNi36xrNdkhPWOoZgYjk/CuHyBsALSoDi4UvDrgSPo0nxPsO+AEcg63QAPvhO2MDuHzhizmHJs/RvSimfd+zEFagUXqzN1LzxlEFBxjjpZHEAX/bqNhOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853581; c=relaxed/simple;
	bh=fvwOjzjb68iLXfxjnAH+3KiPR2+e9W9RzpwuwKdgZAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTKGOtPAgsvC8Lnla7F9HYU1IS5lqBPpt8E+6THBOBxIGQ0EJc2xtZ/KhSmScVy9SbbGVSIc8yHkkyfhnPBklV4+iidMDPcjzueN1a0fhYGD9bZu0PgbO5A9XDZilAh2DrHl4fs+6mbv2vdrRfdoc3DK9oWCDRrqztgqyzzQyjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qIcjQZMQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qIcjQZMQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f633e6058so93479f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 10:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787853577; x=1788458377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=18Tf5eq7c7EPz0T/T046bTiRGn0IVK3Q1r6G0x0NgoA=;
        b=qIcjQZMQ0vx+2TabnJY5Y8eTuKK1pBLKBGWNvqR9x1q+mP5JnT8kaCCJnwR78j2pL+
         VPSdNgW9TvbY2IO7xQ7nGaSw1ke0ScDC3QxfE6KZk4j67MdrLZ/VEbxV429jIKyulaZY
         UGUBRBIsOYYAU/Ga9joJxFq5dT7CS4RcIda3kqJHIj7NKMMHS9NFCpUZLkX9vXuqJBJq
         FP9BGZ1XyHOznnG30eIg0Oc/FPKbCBYxQkmZ1cbEzF99JE28hvAAaqmHLDGVvli2IN7N
         k2hvHWis3VTwuAioiDSBrD1+na+6hJbevqkpOl+E2ElyVlkIaZyPQl3rYNlZVkOz/8zj
         0cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787853577; x=1788458377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=18Tf5eq7c7EPz0T/T046bTiRGn0IVK3Q1r6G0x0NgoA=;
        b=sVNPd6LJ1O5mN68BjUZhhNgSjAbrZPKiQSn92JeeQ60M7NQQU6LN00gg8605mQGUCO
         WykZX0YxR+iPySCo4Gdwiz43dSYByJhE5p6GNosMF0gYkA6xc5IvtU8eiiYQNjh870Cg
         muDrF3AEsfuGCzQLEL3xe9rlDO8SAGOF3mor5MA70gDnN3EEGt/tDBUCmZYjnkIG3JrJ
         18J/T3Ngn1qpnNvCXYXS/eYFHhZ76WxgXBSoYUoHmfuIsXurkVEm0+OTa8w0wxg/UpD1
         RPVf82gZyzI6/vn6ao47OrOTu4+3sJFW07Yrgq5ZJ1ZT4QSSBqTahh+cKLGnn4ElcJ/S
         lf4A==
X-Forwarded-Encrypted: i=1; AHgh+RrA3T76k+G1y2zjAsb+6wZiXFRseyG9EDduPmjbhCmNdQqM/QU4eYUwep0/FxKhumA21GWeWRGe5BZ4xwTZ5A==@vger.kernel.org
X-Gm-Message-State: AFuF++k2Iyduh9kMX7VMGG3fU9frY7CA+iiS4JBtiCGlIrFvKLnSTdge
	V+l1qKhmaOeh/ImuE24CBAFbrK6CKSsIM5yFiTz0YKUbNUhCjMizul1E
X-Gm-Gg: AR+sD13grq/UTuu6HUNBe6z8IVaaRQ4IbLopOt+3cXbc+sRnBQ8vQ04Qa5I8VlJ2EuD
	jCbjG4Gejt11a79h29GvghQwaLqFSbigNo8hks1qkrDlu37UjA4TiJfEtXAWJf49N3GJNsNa/xQ
	m8nqnp2tTOH2qglGAw5EtzU9BiHCEOJgscRYg4P+hhN9ODCZLm+3+ZJlan43fscUN0n3xPTPuQb
	zRd6oq0QM529aHeuzO9Pdfh173BaI3MOFT7ofm0iBFEIdK109IcAmSAfYelyRxWWFStD5It3vAR
	8icc/WsJNdmPw7TCT5YiD0nja5UuXBVCIjtDCIbLf/gi0vqws2azXsNnReCVCw+pzSZPn+aQqXu
	OQgGglU2JpDh9cgkySsM98ZTrFrvSr5rdleVXHMelq6dl4LWB4P4OboxnBDHSvS3eriH+CgQbvt
	1QnYaNWbAqlYx1+S9UeruNAvVQxTGgx9SzW53TpAj++81w/HNM1WDZ20s53rwfLY2tk/cBJKPoN
	T8aiAK1ssEDc3wsB/y3xxdhd1WNfTox6buTZilW9vvqty7YMGjl8AAYxaotHbMv
X-Received: by 2002:a05:6000:4b14:b0:47f:5ec2:d54 with SMTP id ffacd0b85a97d-482f799da2dmr823346f8f.5.1787853577114;
        Thu, 27 Aug 2026 10:59:37 -0700 (PDT)
Received: from localhost.localdomain ([85.118.83.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e27a9945sm10272342f8f.9.2026.08.27.10.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:59:36 -0700 (PDT)
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
	gvalkov@gmail.com
Subject: [PATCH v9 3/3] ARM: dts: armada: WRT3200ACM: add marvell,invalid-reg-hint-in-rom
Date: Thu, 27 Aug 2026 20:58:50 +0300
Message-ID: <20260827175850.89395-3-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827175850.89395-1-gvalkov@gmail.com>
References: <20260827175850.89395-1-gvalkov@gmail.com>
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

