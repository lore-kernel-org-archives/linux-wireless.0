Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058838;
	b=lobfR6dBTbNqFWZj4vmuiHOfCwwcfwUWXZC8xrbZQMDvoo6XmcDBxjheQpH4UsADqG/+
	 i4yknFeM4WWOQjtvCJ+/GW88DOCzVcYFUqpGAdFnmPO0ZmwUizXnkyg5js4bHM0JDPrn8
	 7DdV5rRlBtxVNBvz4j7lKRctsWSf2BqFOU4YkT+48UASr7ECZo42ngNUBsPOy6wwYFmie
	 oW1CkRzpA16CO28LxkGvOxKlipIsjvwjxqqWkbWEP4r08RWi2Uv5GY6BRPQ+UPRszhY7L
	 4KP5xC5uDy0lNFjnu5d31n9wAJgXF98SB/0FV186+tzNszmG4fOzL3v8erA7sU+On8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058838;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=8/cGJiZ8J7bZat2+2xRGthTnq/s/O1QrCm44JcVVUd8=;
	b=blrMmhMbK6HNAiYLl//ug7L8ZKoZi8p3ertnDtHaYLKf9OpP15Ksz1bLmh+tjfbOlVCf
	 5mqmrBXxxwfiZG1KFmxainACF6XNkcK0WkygvVxzbCr9CcVmzx+mJPqFxdbAfJL5Is8jc
	 +oemppKSA/Pf1igFVHGng0SPgcARkXG0F5ndkQ7sPpkkvMc9j+WeLvUqy0qfQehyulfN2
	 0zaSXuE2s0yX4Ts9RrbbSrzr4Eg9t0tQWDB9HZH53SxbyLdkOqoOeLUbPbCSctLCj7M0U
	 0btQCTjr1E053jXfDKpFGmYdpGJQB0L5mZEqzWmUaP2EhHq5E03Al4Lo8DNDjTAPXpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=W+b7rEp6;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4CC606A330
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB4CC606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=W+b7rEp6
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVgxjBeJ; Tue, 27 Oct 2026 00:53:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058828; bh=nWNVc9Z1ai3UXmQ+AXUVO+y8GzWaTt8mFejXwvTxs7Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=W+b7rEp69xEyccaPt6zSCtCAVNetFYDLDEV9SyyLNqzMGjfdhmYa2Nk03NAsWg5zY
	 kgJqVrnbUWSnNE2ZaaI7mkIdNfxr0FbbxRkGxHbj2x8XPB2SirKwPpaA+OJUSNpEVu
	 +8RtCKSl36Gc2rcsMUesRQSB/KrUxiMdkYZsPzPieYbAqIeS1mrGXKa0n8M/4fd1qk
	 wCiv314Ya6FExdEl0iP041tIAxB4YBeSqec1tdcE2nyxkAWryUcNfrpDqroS+JvERu
	 RB620ju/NEPeJpmi2sl0ynBgedJwe4KWQ4R2CBejGUsWj2psTW8BHJ3ONdZkxAIN2p
	 dD5gR/ALL6F/A==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Tue, 27 Oct 2026 00:53:45 +0100
Subject: [PATCH wireless-next v2 2/8] bcma: pmu: init PLL and resources on
 BCM4352/BCM4360
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
Message-Id: <20261027-bcma-ac-rev1-v2-2-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
In-Reply-To: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfOP1m5cBT0mHWlN8umXGisWkEp9/jgvHoBa7uIoBF1B+yIlT9XDT3/9JKUGr6e3p78sFPjhFb9GXxU/vDEOfN0utpqE6e70Lc67e6Dqp41D61uSKYxMs
 EpQn5B532ks7fjLqa6EYlb8sLi8IqGH0QYntpb7dyRq2S+zGmXppoe6e3+X+G8maAiIPrHBaXKhtHkspY90+lHg+SjcPYqZy7k3QI9JZ4MGg0MgV+Le7JBm8
 CIvo3Xe+Le3oqi9DSL7CPINhRx1MqkcWj7UDIcujgNSpLFRRcVMQl/WYV7GSh4HjuTgiac/6gG8REsrmiZ/WVI0SqUsSUfvlzcxQejDKye4m2ym+jy7uD90k
 3MmkKopY7n1KVxz9wmyunHSTEkQEHgTtxq1IOrTABKqY4GjpJW4=

On chip rev 3:

- program PLLCTL2/3 for a 960.0098 MHz fractional VCO from the 40 MHz
  crystal, except on a BCM4360 strapped for USB;
- set the up/down time of resource 6;
- with chipstatus RSRC_INIT_MODE0 clear, program PLLCTL6/14 and set
  max_res_mask to 0x1ff.

The values are those of Broadcom's driver on rev 3; other revisions are
left as they are.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/driver_chipcommon_pmu.c        | 41 +++++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h |  4 +++
 2 files changed, 45 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 263ef6fa1..ab2b2701d 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -145,6 +145,39 @@ static void bcma_pmu2_pll_init0(struct bcma_drv_cc *cc, u32 xtalfreq)
 	/* TODO: Do we need to update OTP? */
 }
 
+static void bcma_pmu_4360_pll_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	if (bus->chipinfo.rev != 3)
+		return;
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4360 &&
+	    cc->status & BCMA_CC_CHIPST_4360_MODE_USB)
+		return;
+
+	/* Fractional VCO, 960.0098 MHz from a 40 MHz crystal. */
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2, 0x0c31);
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3, 0x100e);
+	bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
+}
+
+/* Returns the max resource mask to program, 0 to leave it alone. */
+static u32 bcma_pmu_4360_resources_init(struct bcma_drv_cc *cc)
+{
+	if (cc->core->bus->chipinfo.rev != 3)
+		return 0;
+
+	bcma_pmu_write32(cc, BCMA_CC_PMU_RES_TABSEL, 6);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_RES_UPDNTM, 0x00200001);
+
+	if (cc->status & BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0)
+		return 0;
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL6, 0x09048562);
+	bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL14, 0x09048562);
+	bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
+	return 0x1ff;
+}
+
 static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 {
 	struct bcma_bus *bus = cc->core->bus;
@@ -156,6 +189,10 @@ static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
 			xtalfreq = 20000;
 		bcma_pmu2_pll_init0(cc, xtalfreq);
 		break;
+	case BCMA_CHIP_ID_BCM4352:
+	case BCMA_CHIP_ID_BCM4360:
+		bcma_pmu_4360_pll_init(cc);
+		break;
 	}
 }
 
@@ -188,6 +225,10 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 			  BCMA_RES_4314_WL_CORE_READY;
 		max_msk = 0x3FFFFFFF;
 		break;
+	case BCMA_CHIP_ID_BCM4352:
+	case BCMA_CHIP_ID_BCM4360:
+		max_msk = bcma_pmu_4360_resources_init(cc);
+		break;
 	default:
 		bcma_debug(bus, "PMU resource config unknown or not needed for device 0x%04X\n",
 			   bus->chipinfo.id);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 0cb6638b5..45c37b6bd 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -107,6 +107,8 @@
 #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE	BIT(5) /* PCIE1 enable strap pin */
 #define  BCMA_CC_CHIPST_5357_NAND_BOOT		BIT(4) /* NAND boot, valid for CC rev 38 and/or BCM5357 */
 #define  BCMA_CC_CHIPST_4360_XTAL_40MZ		0x00000001
+#define  BCMA_CC_CHIPST_4360_RSRC_INIT_MODE0	0x00000020
+#define  BCMA_CC_CHIPST_4360_MODE_USB		0x00000100
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
@@ -500,6 +502,8 @@
 #define BCMA_CC_PMU_PLL_CTL3		3
 #define BCMA_CC_PMU_PLL_CTL4		4
 #define BCMA_CC_PMU_PLL_CTL5		5
+#define BCMA_CC_PMU_PLL_CTL6		6
+#define BCMA_CC_PMU_PLL_CTL14		14
 
 #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK	0x00f00000
 #define BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT	20

-- 
2.34.1

