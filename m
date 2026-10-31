Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438139;
	b=EFwzQDwoME4sEUqOVvJty+Vbng1f7OAxNyBv8bMnRByzxdxm9VNNDUXvUmlEot7+mtyq
	 QHkpkbBf6rT21k1EHdiWbEk4Y5pgAj6bUHX2ykJM3kXI1Vx+OgclUex+W4XNi2TkQ0JyR
	 8svhFDdN+OWZyihQoLgCTRYnZBXZJ2k5xQURLksASX2O+BkC9zkwUx1X3cGZ8SswevGE2
	 sh34YgUSuqkHZCUcMox1feKeE64TSLuDRWU2uHDTejhnvXce4iY6Hc4sLkrATlqSaHBvw
	 30l2P9X8lFelomBN5Sw7W3e7SQ07KatmsCLlIOCESvza917XW/tSWBd7F9lMFxuboIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438139;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=0UQFTxkw/HfIqjISqbAkKNzK2A8OXExXXoUPu8/3b00=;
	b=PdSBASIVERfXiBHSUxC4Zpt2Ufc53P7R9TyG6vZFVL5WUtz9XpYZxSghdfeeZ5nQNFuV
	 CIgo7LqbPuDOLh1TNqPtxceiQIrPqCqFucet0dYXYcAJG6Wx+nG1YVNN9qmar+FH/LLls
	 p+VC5niK3aiA3ImRWArQs+bjD/kNqk99cQT9XWsBz3zge0HNPf4howvUQFaBDOyq4Jnnb
	 ewx9/3PYIMOwZtxTmuVAls/KFKMO2YlHFfioteFlwHS/1Xgps9dYzmrW1d1XtUw9eb3CV
	 VhF2566PqeOl9c6PFLRVqrccLM1m34KdyiiSPcDdVpgmzX0Xcw6sUfjMdmClUN9uojQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=efmgdCLF;
	arc=none smtp.remote-ip=62.149.156.86
Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C05606A323
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40C05606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=efmgdCLF
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id N5BMx1hYL6q8sN5BQxVoTH; Sat, 31 Oct 2026 10:15:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793438128; bh=M8e1E3AFMBy9iSve8rW+kLzKE99lCoOKdT27fT8i/1Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=efmgdCLFM8wYhEdvq7smM4gI0o6HuRKu2QD4FChSzcjR3CCI9RTDcQuGDRt7S5l1o
	 a31yvkR2o1dvrgIDRw5IcD0+0Qj+bNzMzj66vT58NJrxGyvEghs1XjmS86a2FMkv+b
	 5kDvMYEc74BZk+F3xUa21M0Mq8qpxsXCZUyqqvTbyTZuwhoQzX9g7X50hSBEYTB6eS
	 l6XZDMmmJ/Uco+ibUDeqTR8aD53LFrbs8aP1uYOehRzHZHTfWqxDC+gasUFoEOdXS+
	 xFVLiz4MmtMg9vFY/5rJviV7pI+ZACJ9Pzq8JC7qZNEoj7Y+RyCWCxNx5r88gsyYY8
	 cZ6Ro5x6qX9Mg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Sat, 31 Oct 2026 10:15:24 +0100
Subject: [PATCH wireless-next v3 02/10] bcma: pmu: init PLL and resources
 on BCM4352/BCM4360
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-bcma-ac-rev1-v3-2-1fbe38e8179b@mythread.it>
References: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
In-Reply-To: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 b43-dev@lists.infradead.org
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfLXXc5T4eu0nzpLMSWy+X5gfVikXSiNlEnMUR1sGQcqxa6SVj1y5a5wd0dIRkGGZoqwr4hPUxi5I4aohl7w1Fu6FJI/2ZDNSe1Yw8QD+5xrg5es9zSJq
 bG+l3GjKmx7dKTLLx7M7sZ5GB8o518feW0DT5e1Gbqh73uDSat3ZS31rlwytDhnVIuz/dxTbmbY1u4PXnwAWDn/INFjf9kjwXgPedXc4p/k7acy9mAhR033H
 SDXhXP/V5eYCEg50yMUi52TFaydiMm7Xx46MXbDqHcmG2OQ9Eup0t0G5MMnN1ooBkh2IkNMS9DZg/FMEN6nTP7nJD/fp78DT+kp96s0AXXHj6ZtkxVcJi4Il
 NnoIGNBrsJS+ImjydHvTtXFfYTb6w7/MKLrrg75LPB+xXp4AV3u+XHLYiJZtY9f5ULRWNX0/Pm6ox4B4yPuRQibKbgtm6A==

Program the PMU as Broadcom's driver does (hndpmu.c):

- on chip rev 3 and later, set the BBPLL to a 960.0098 MHz fractional
  VCO from the 40 MHz crystal, unless the backplane runs on HT already;
- set the resource up/down times and, on rev 4 and later, a min
  resource mask of 0x103;
- with chipstatus RSRC_INIT_MODE0 clear, program PLL controls 6 and 14,
  and on rev 4 and later 7 and 15 with REFCLK enabled in chipcontrol 1;
  on rev 3 and later, set max_res_mask to 0x1ff.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/driver_chipcommon_pmu.c        | 81 +++++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h | 14 +++++
 2 files changed, 95 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 263ef6fa1..7a226fcd2 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -11,6 +11,7 @@
 
 #include "bcma_private.h"
 #include <linux/export.h>
+#include <linux/math64.h>
 #include <linux/bcma/bcma.h>
 
 u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
@@ -145,6 +146,78 @@ static void bcma_pmu2_pll_init0(struct bcma_drv_cc *cc, u32 xtalfreq)
 	/* TODO: Do we need to update OTP? */
 }
 
+static void bcma_pmu_4360_pll_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	const u32 xtal_hz = 40000000, vco_hz = 960009800;
+	u32 ctl2;
+
+	if (bus->chipinfo.rev < 3)
+		return;
+	/* The backplane may be running from the BBPLL. */
+	if (bcma_cc_read32(cc, BCMA_CLKCTLST) & BCMA_CLKCTLST_HAVEHT)
+		return;
+	if (bcma_pmu_get_alp_clock(cc) != xtal_hz) {
+		bcma_warn(bus, "No 40 MHz crystal, BBPLL left as is\n");
+		return;
+	}
+
+	ctl2 = (vco_hz / xtal_hz) << BCMA_CC_PMU4360_NDIV_INT_SHIFT |
+	       BCMA_CC_PMU4360_NDIV_MODE_FRAC << BCMA_CC_PMU4360_NDIV_MODE_SHIFT |
+	       1 << BCMA_CC_PMU4360_P1DIV_SHIFT;
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2, ctl2);
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+			      div_u64((u64)(vco_hz % xtal_hz) << 24, xtal_hz));
+	bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
+}
+
+/* Up/down times of resources 0-8 on chip rev 4 and later */
+static const u32 bcma_pmu_4360b1_res_updown[] = {
+	0x00000001, 0x00000001, 0x00000001, 0x00000001, 0x00860002,
+	0x00000000, 0x00020001, 0x00080001, 0x00000000,
+};
+
+static void bcma_pmu_4360_resources_init(struct bcma_drv_cc *cc,
+					 u32 *min_msk, u32 *max_msk)
+{
+	u8 rev = cc->core->bus->chipinfo.rev;
+	bool init_mode0 = cc->status & BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0;
+	unsigned int i;
+
+	if (rev < 4) {
+		bcma_pmu_write32(cc, BCMA_CC_PMU_RES_TABSEL, 6);
+		bcma_pmu_write32(cc, BCMA_CC_PMU_RES_UPDNTM, 0x00200001);
+	} else {
+		for (i = 0; i < ARRAY_SIZE(bcma_pmu_4360b1_res_updown); i++) {
+			bcma_pmu_write32(cc, BCMA_CC_PMU_RES_TABSEL, i);
+			bcma_pmu_write32(cc, BCMA_CC_PMU_RES_UPDNTM,
+					 bcma_pmu_4360b1_res_updown[i]);
+		}
+		*min_msk = 0x103;
+		/* The max mask must cover the min mask before it is written. */
+		bcma_pmu_set32(cc, BCMA_CC_PMU_MAXRES_MSK, *min_msk);
+	}
+
+	if (init_mode0)
+		return;
+
+	if (rev < 4) {
+		bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL6, 0x09048562);
+		bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL14, 0x09048562);
+	} else {
+		bcma_chipco_chipctl_maskset(cc, 1, ~0,
+					    BCMA_CHIPCTL1_4360_REFCLK_EN);
+		bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL6, 0x080004e2);
+		bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL7, 0xe);
+		bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL14, 0x080004e2);
+		bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL15, 0xe);
+	}
+	bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
+
+	if (rev >= 3)
+		*max_msk = 0x1ff;
+}
+
 static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
@@ -156,6 +229,10 @@ static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 			xtalfreq = 20000;
 		bcma_pmu2_pll_init0(cc, xtalfreq);
 		break;
+	case BCMA_CHIP_ID_BCM4352:
+	case BCMA_CHIP_ID_BCM4360:
+		bcma_pmu_4360_pll_init(cc);
+		break;
 	}
 }
 
@@ -188,6 +265,10 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 			  BCMA_RES_4314_WL_CORE_READY;
 		max_msk = 0x3FFFFFFF;
 		break;
+	case BCMA_CHIP_ID_BCM4352:
+	case BCMA_CHIP_ID_BCM4360:
+		bcma_pmu_4360_resources_init(cc, &min_msk, &max_msk);
+		break;
 	default:
 		bcma_debug(bus, "PMU resource config unknown or not needed for device 0x%04X\n",
 			   bus->chipinfo.id);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 0cb6638b5..525155658 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -107,6 +107,7 @@
 #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE	BIT(5) /* PCIE1 enable strap pin */
 #define  BCMA_CC_CHIPST_5357_NAND_BOOT		BIT(4) /* NAND boot, valid for CC rev 38 and/or BCM5357 */
 #define  BCMA_CC_CHIPST_4360_XTAL_40MZ		0x00000001
+#define  BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0	0x00000020
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
@@ -500,6 +501,16 @@
 #define BCMA_CC_PMU_PLL_CTL3		3
 #define BCMA_CC_PMU_PLL_CTL4		4
 #define BCMA_CC_PMU_PLL_CTL5		5
+#define BCMA_CC_PMU_PLL_CTL6		6
+#define BCMA_CC_PMU_PLL_CTL7		7
+#define BCMA_CC_PMU_PLL_CTL14		14
+#define BCMA_CC_PMU_PLL_CTL15		15
+
+/* BCM4360 PLL control 2 */
+#define BCMA_CC_PMU4360_P1DIV_SHIFT		0
+#define BCMA_CC_PMU4360_NDIV_MODE_SHIFT		4
+#define  BCMA_CC_PMU4360_NDIV_MODE_FRAC		3
+#define BCMA_CC_PMU4360_NDIV_INT_SHIFT		7
 
 #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK	0x00f00000
 #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT	20
@@ -527,6 +538,9 @@
 #define BCMA_CHIPCTL_4331_BT_SHD0_ON_GPIO4	BIT(16)	/* enable bt_shd0 at gpio4 */
 #define BCMA_CHIPCTL_4331_BT_SHD1_ON_GPIO5	BIT(17)	/* enable bt_shd1 at gpio5 */
 
+/* BCM4360 ChipControl 1 */
+#define BCMA_CHIPCTL1_4360_REFCLK_EN		BIT(11)
+
 /* 43224 chip-specific ChipControl register bits */
 #define BCMA_CCTRL_43224_GPIO_TOGGLE		0x8000		/* gpio[3:0] pins as btcoex or s/w gpio */
 #define BCMA_CCTRL_43224A0_12MA_LED_DRIVE	0x00F000F0	/* 12 mA drive strength */

-- 
2.34.1

