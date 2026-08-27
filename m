Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA945361670
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 13:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787835854; cv=none; b=LDqHi1NRwhyDOLTFGLc9zTwifL1ataBhWR7+xfKTu+pOQTF8x9fEUqaBDo+5CbGizOWwoY31r4y3SEhRrie0ub0FfmgS4RHcORAWp5Q6n+/INjSl37iV+1SsDnvv/uBJVfCM7yQ6R1URpU4lUmB9zQ8ozBmpMxoXyH/eN598PaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787835854; c=relaxed/simple;
	bh=sarQEdrSbBSoaCcKumeb7DKx9O4YVpY+WCIk3ge9e4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OL92FR4A3GFnF+wnK7kR4y32ksjV1YOBoAfYlCXhqL5O82751pvMbftNkhzXHjiS4ckcMx9aadZxrhWOU+hvdOqQK9yT7FoaNUgeRw4Af+cas8Wc4Xun6Qw9siRuih0zxr+l+fOSAOBECDk3re9JOYo0spg4HisgtVKOOjvYbr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bNPf7GGm; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNPf7GGm"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so7794895e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 06:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787835839; x=1788440639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QF2zBpTs1xbQ8vVeDBrFP8mtx1WkUete3RSSn/zfKZ4=;
        b=bNPf7GGmSpoJPktSQVABQMu9LCAv6xK5GX133qC5CGLnd3z+AT2DgV/JkxWpUoRJna
         wlordsXPLq58Gd3FZgjC+fOQkKVpyvpVCZDVGxudjOgElTYPfZvau0mNra0SFK7SNuLn
         o27Q+CRBeauJJ2NoDSN3pSW0El/GEEGijkkGGQ2Q79jJ77V3x8HQ45DDejPelIjwmu5K
         oAGiK+dJlICwQiL4O+oFdrx+eg5qks/8p4lNNygI+o8M07MwTiR5ICFKjYBTxrQq4Ty9
         4gRNzTeW9nj+Xec2OoAhA2KNIjZ6s0XaTdkEroXNdnx1j7DJgbE7kozY98uOh9KYsJ0s
         91Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787835839; x=1788440639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QF2zBpTs1xbQ8vVeDBrFP8mtx1WkUete3RSSn/zfKZ4=;
        b=CslEzUFK0VA8WOXOWPqblzS8akcFi1Yb8yD2i5Ch/itOzxyuLEbXdEN86t77ZQrs0r
         FhjeO2uZHnfJ9EE7elZoOM05q/LmS1CjHOi0pxfl2WcH6eP8O6yH6H/FjxtVNo78y8MH
         COGhG6cWLMNFTyOTYwXarZt1xOEffjsVbchvtD8xqRRLPGfpL7Ah4ovTMGQ+PdB4s/8v
         CS6/Iv5QfC4bPQgncimVRzTB4j33fy9vozvOaxH3hJ4iXw207OnF14XI8mWA0JLMRSMz
         85H2MU2gOK0kOyio8jNXeatRB9Fmm1ZPWa+0JATu/jOO9R+fKLbwWN7IOH2t/D71XuVV
         ulXA==
X-Forwarded-Encrypted: i=1; AHgh+RrvOpeaSL8W0tVKb3gj3Eq9OGwXVpVF8bv9kaFDCiRucm2fT9JjnGaZw/kF/Gk8YkDgKF0ETyT3NptlvkcJCw==@vger.kernel.org
X-Gm-Message-State: AFuF++lvlGVMj7oKaCVHkxexAUHEvINCkSoHb5+0bTPn1jC8TKGthhNp
	+diEOUxuz8hxr4aIcpeM6hXPqwgBqd/4GUC4ZM2Xm0mxrEZyiccY0VYg
X-Gm-Gg: AR+sD11O+rh00zcOYDoLmajbh58wtaLenEyOf59ASi4LWsEOvV6OJWhEzv1RsnI4LoL
	dumRVO2CC8bHubt55Ulcl4+C7C27IxSnKnToYUQNoCjjA9GWQVZ3WZpcUeXxhDfczRiuKIrf4Pm
	75e3DZtX0nbJcUXI5/ZSh+8wBeBwTJ2hmV2Q/2fOXczhTihkRN2mkCi233sSkMBW0psHpSUn5io
	LVx9CzSPRcBp50gDdNLjaWIwyenUBbaLibr61PiGZevS3vMQqofU2b4CkFnor9qp9o5LjWXxKSV
	r+Rb1JGQKN77dAvV3AKo5lWJfXCakaDBmsN+toiRVr84syhKjDXWu4OVo3xoc+86L5oskP2mU7T
	Jo2QA7enHPnxKaus8PXp754teojRFn3B6nWVxl3Kfj2+Xk20sUvc3eij7Fz5Jw1R2CcBiZ6t3fr
	TtK8ZOnJN2IK3g/ouqUhFrRTv7U70DvFinF2E4UkYKAAUtonkx0XGAfU8B21XCemPZdRLuLi96j
	0yUH6JqIvfC5MEAPP22WVpWxj3A5Ilrwa66rtHs2PdkOsi1zrFkDavw4Bz/AyWBrN2se9gjea4=
X-Received: by 2002:a05:600c:4505:b0:499:593b:a15b with SMTP id 5b1f17b1804b1-499dc6e9935mr159659955e9.1.1787835839294;
        Thu, 27 Aug 2026 06:03:59 -0700 (PDT)
Received: from localhost.localdomain ([2a01:5a8:737:d4a7:e53b:30a6:3c0f:1dad])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b49610170sm116081285e9.6.2026.08.27.06.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:03:58 -0700 (PDT)
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
Subject: [PATCH v7 3/3] ARM: dts: armada: WRT3200ACM: add marvell,invalid-reg-hint-in-rom
Date: Thu, 27 Aug 2026 16:03:35 +0300
Message-ID: <20260827130335.6606-3-gvalkov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827130335.6606-1-gvalkov@gmail.com>
References: <20260827130335.6606-1-gvalkov@gmail.com>
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

