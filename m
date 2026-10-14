Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951144BE42E
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010665; cv=none; b=ITzTS0VSr7q/VKbdwsn+Rzx5E3SrNV0BjC3WDopUvogDl+Y07KVjcqD/lGRQso9+awxXy+S9DvBu276Xv+fhR07e7GPYcKvkHoVBWx+1qf9T9YrQKAkc5iLRgyengI2y+rwaoT+QVbvVdg/ThRmvYONan1IWUHp29ZuW658zEpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010665; c=relaxed/simple;
	bh=nWNVc9Z1ai3UXmQ+AXUVO+y8GzWaTt8mFejXwvTxs7Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WrszuexK9jxR5Wu8OiW+2t0DL7d81oNMJtV8nEOnvNBaYjyfapjcnaDqwirTx92BmleewMxwcTVAHpEUBMNOd3/XmV9O9sTV3HFaGs/I7Du4WMQDO8b5IqpnD3+WZvmmrSmP4+WwnydIsVx9Y2NhLy2mMW4gO+u1YyVU5Ns1w7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=blIXOl0b; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="blIXOl0b"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mjxSpCb; Wed, 14 Oct 2026 22:41:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010474; bh=nWNVc9Z1ai3UXmQ+AXUVO+y8GzWaTt8mFejXwvTxs7Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=blIXOl0bCE2DiEiuQfd+BQFkt3g+APs60iUXhTTD5yR39ZL8XL9ms2XBPLeyxJgGo
	 LQOCExwBaOHBtacr9O7o/qilXv1eyRxoXPm0Q2aJIm/RQphfcGUAzWBBK5BX5NOQnv
	 2oPaJnc6DFZV+FId+/jEVCZHe+rr8+kZc0fuhWbJ8agI0zIdy1lVbeJVKf3/Egc8RD
	 BkbMfayFuo9Ctz+fxauF65g/uje46P6w6Ifx9bzhCGJhDuCYUzazxbnYIikm9F+l9C
	 tfSEvFSMC0fXYpDWxbBqRUkEIoTjL0DcG2uXXyOf2eK0oTLpshKF6Cnkjv5+5X1jhe
	 G42o0HJwMa72A==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:03 +0200
Subject: [PATCH 2/8] bcma: pmu: init PLL and resources on BCM4352/BCM4360
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-2-b608e99d3f56@mythread.it>
References: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
In-Reply-To: <20261014-bcma-ac-rev1-v1-0-b608e99d3f56@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfN6bvGWMrM3C7O32slcQTgHJbTXhr2UxDy/TzXIa2DcooUo5kdVgvXe81fVvf6wzmSgSnOaKHiSGsKl2IllWFyWYWr/hijrNkzps/zICNVKcY3nYBTr/
 qohWDO37teboALBM+PLNp4cyhwEYJCVBkZX+nlnxek2EYYk/UIzYQdW1aVIuQJshedE/JUNXq1wuPENeRXXERG26Gv9OEmrDXjpAmN8vkoGnRu3RauHZg1au
 mKegveVIEqU6Z9ZhYUCDrKIlFKqPkPus3gTD2KCcHzV44gbRmNXv/6A6JezWhN1EeQmgRQQA1xeFymDzEBLiExMyliHnRB89fiyCxQW1qSlJK6s1s6syT9/C
 kyZf+2ow2FchGDligTtg4DZwV/2Keg==

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

