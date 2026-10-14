Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAAD480DED
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010658; cv=none; b=FYn42KhpvISZVnASunbAfUb8Brltp2xU8gUVlRtMd93VV7MS/p9d4yld//+S0V3yVOmkSVkqgeyz2Na49dbzHlDFI+Fr4Z5llKem8fVUkO8tuUGO2bSv7dvGsvmJPkPzYLyg4bMujiJALk6v7efeFsQ4/nVTluX9Hiv3GWFLe0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010658; c=relaxed/simple;
	bh=0j05rvcGU77iKVS4MWt3ZAdBh+zvDWdwhsqiZaT/GaU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PK+2G51anbxTH4/jB86KGv6VcZIQAeYeRlJrZgApSNdj1dWKA6ph+/WmyzYxvcmWpaB2X4FXInVSq4RQMySJUx13IZ2FHDcGYJyQ1uZ23HhE5UzgUy4Xh5cJZ9YR7ACJo2yHUZStz/ZifWPD9j0Am9CnH5UOIkdJrdCLuXC1ngA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=lYqnG0SG; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="lYqnG0SG"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mkxSpDU; Wed, 14 Oct 2026 22:41:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010474; bh=0j05rvcGU77iKVS4MWt3ZAdBh+zvDWdwhsqiZaT/GaU=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=lYqnG0SGsodhiHkhNGZMra3i0bReFo4DA7IiSfQ7UIt1HIVuBP+tU4aeIbwOshCZy
	 /rrCap+AfpzzUX6lCJAWJsDdtEY1sSqWkeGpxrg11tV2EPXK2lOHaspy086q+cKwWq
	 2AhdlNVb96T0hYrajQV0gjHz9jr6xxuMjPoTK/Wd1Nev8CQxdoEt7C5o4wdWmOto81
	 akEB/v6H/TNo/Ch0QPs/uTfrBpLzSsYWWw3MeO6YL2csrCEFNQqoJiH01LDwSj7jvh
	 bqPE+vQHMNJ8Z7blbcLpfcnQ5Dc+KG4XNxF1hivJJIhQsmTVRu0dNBWPfzte8LqZk0
	 djhyL0Ks61/XA==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:07 +0200
Subject: [PATCH 6/8] firmware: bcm47xx_sprom: read ledbh4..ledbh15 from
 NVRAM
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-6-b608e99d3f56@mythread.it>
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

Add gpio_ext[] for the LED behaviours of GPIO 4-15 and fill it from
NVRAM ledbh4..ledbh15, both for a SPROM built from NVRAM and, through
the new bcm47xx_sprom_fill_bcma_nvram(), on top of a SPROM read from a
bcma device. The bcma prefix lookup moves into a helper shared by both
paths.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/sprom.c                      |  3 ++
 drivers/firmware/broadcom/bcm47xx_sprom.c | 86 +++++++++++++++++++++++--------
 include/linux/bcm47xx_sprom.h             | 15 ++++++
 include/linux/ssb/ssb.h                   |  1 +
 4 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index c98b6fb66..ac7622512 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -11,6 +11,7 @@
 
 #include <linux/bcma/bcma.h>
 #include <linux/bcma/bcma_regs.h>
+#include <linux/bcm47xx_sprom.h>
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
@@ -841,6 +842,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		else
 			bcma_sprom_extract_r8(bus, sprom);
 		kfree(sprom);
+		/* Most hosts have no NVRAM: ignore the result. */
+		bcm47xx_sprom_fill_bcma_nvram(bus, &bus->sprom);
 	}
 
 	return err;
diff --git a/drivers/firmware/broadcom/bcm47xx_sprom.c b/drivers/firmware/broadcom/bcm47xx_sprom.c
index bca03fd85..75604cd70 100644
--- a/drivers/firmware/broadcom/bcm47xx_sprom.c
+++ b/drivers/firmware/broadcom/bcm47xx_sprom.c
@@ -29,6 +29,7 @@
 #include <linux/bcm47xx_nvram.h>
 #include <linux/bcm47xx_sprom.h>
 #include <linux/bcma/bcma.h>
+#include <linux/err.h>
 #include <linux/etherdevice.h>
 #include <linux/hex.h>
 #include <linux/if_ether.h>
@@ -172,6 +173,20 @@ static void nvram_read_alpha2(const char *prefix, const char *name,
 	memcpy(val, buf, 2);
 }
 
+/* Variables read from NVRAM whether or not the SPROM itself comes from it. */
+static void bcm47xx_sprom_fill_nvram_only(struct ssb_sprom *sprom,
+					  const char *prefix, bool fallback)
+{
+	char name[sizeof("ledbh15")];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sprom->gpio_ext); i++) {
+		snprintf(name, sizeof(name), "ledbh%d", i + 4);
+		nvram_read_u8(prefix, NULL, name, &sprom->gpio_ext[i], 0xff,
+			      fallback);
+	}
+}
+
 /* This is one-function-only macro, it uses local "sprom" variable! */
 #define ENTRY(_revmask, _type, _prefix, _name, _val, _allset, _fallback) \
 	if (_revmask & BIT(sprom->revision)) \
@@ -209,6 +224,8 @@ static void bcm47xx_sprom_fill_auto(struct ssb_sprom *sprom,
 	ENTRY(0xfffffffe, u8, pre, "ledbh1", gpio1, 0xff, fb);
 	ENTRY(0xfffffffe, u8, pre, "ledbh2", gpio2, 0xff, fb);
 	ENTRY(0xfffffffe, u8, pre, "ledbh3", gpio3, 0xff, fb);
+	if (sprom->revision)
+		bcm47xx_sprom_fill_nvram_only(sprom, pre, fb);
 
 	ENTRY(0x0000070e, u16, pre, "pa0b0", pa0b0, 0, fb);
 	ENTRY(0x0000070e, u16, pre, "pa0b1", pa0b1, 0, fb);
@@ -647,45 +664,70 @@ static void bcm47xx_sprom_apply_prefix_alias(char *prefix, size_t prefix_size)
 	}
 }
 
-static int bcm47xx_get_sprom_bcma(struct bcma_bus *bus, struct ssb_sprom *out)
+/*
+ * The NVRAM prefix of a bcma bus's variables: pci/<bus>/<slot>/ or its
+ * devpathN alias for a PCI device, sb/<core>/ for the SoC's own core.
+ * Returns the prefix, NULL for a SoC bus without an 802.11 core, or an
+ * error pointer for a host type NVRAM knows nothing about. *fallback is
+ * set when the caller may fall back to unprefixed variables.
+ */
+static char *bcm47xx_sprom_bcma_prefix(struct bcma_bus *bus, char *buf,
+				       size_t size, bool *fallback)
 {
-	struct bcma_boardinfo *binfo = &bus->boardinfo;
 	struct bcma_device *core;
-	char buf[10];
-	char *prefix;
-	bool fallback = false;
 
+	*fallback = false;
 	switch (bus->hosttype) {
 	case BCMA_HOSTTYPE_PCI:
-		memset(out, 0, sizeof(struct ssb_sprom));
 		/* On BCM47XX all PCI buses share the same domain */
 		if (IS_ENABLED(CONFIG_BCM47XX))
-			snprintf(buf, sizeof(buf), "pci/%u/%u/",
+			snprintf(buf, size, "pci/%u/%u/",
 				 bus->host_pci->bus->number + 1,
 				 PCI_SLOT(bus->host_pci->devfn));
 		else
-			snprintf(buf, sizeof(buf), "pci/%u/%u/",
+			snprintf(buf, size, "pci/%u/%u/",
 				 pci_domain_nr(bus->host_pci->bus) + 1,
 				 bus->host_pci->bus->number);
-		bcm47xx_sprom_apply_prefix_alias(buf, sizeof(buf));
-		prefix = buf;
-		break;
+		bcm47xx_sprom_apply_prefix_alias(buf, size);
+		return buf;
 	case BCMA_HOSTTYPE_SOC:
-		memset(out, 0, sizeof(struct ssb_sprom));
 		core = bcma_find_core(bus, BCMA_CORE_80211);
-		if (core) {
-			snprintf(buf, sizeof(buf), "sb/%u/",
-				 core->core_index);
-			prefix = buf;
-			fallback = true;
-		} else {
-			prefix = NULL;
-		}
-		break;
+		if (!core)
+			return NULL;
+		snprintf(buf, size, "sb/%u/", core->core_index);
+		*fallback = true;
+		return buf;
 	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+int bcm47xx_sprom_fill_bcma_nvram(struct bcma_bus *bus, struct ssb_sprom *out)
+{
+	char buf[10];
+	char *prefix;
+	bool fallback;
+
+	prefix = bcm47xx_sprom_bcma_prefix(bus, buf, sizeof(buf), &fallback);
+	if (IS_ERR(prefix))
+		return PTR_ERR(prefix);
+	bcm47xx_sprom_fill_nvram_only(out, prefix, fallback);
+	return 0;
+}
+
+static int bcm47xx_get_sprom_bcma(struct bcma_bus *bus, struct ssb_sprom *out)
+{
+	struct bcma_boardinfo *binfo = &bus->boardinfo;
+	char buf[10];
+	char *prefix;
+	bool fallback;
+
+	prefix = bcm47xx_sprom_bcma_prefix(bus, buf, sizeof(buf), &fallback);
+	if (IS_ERR(prefix)) {
 		pr_warn("Unable to fill SPROM for given bustype.\n");
-		return -EINVAL;
+		return PTR_ERR(prefix);
 	}
+	memset(out, 0, sizeof(struct ssb_sprom));
 
 	nvram_read_u16(prefix, NULL, "boardvendor", &binfo->vendor, 0, true);
 	if (!binfo->vendor)
diff --git a/include/linux/bcm47xx_sprom.h b/include/linux/bcm47xx_sprom.h
index 40a7da3ef..47e9922ec 100644
--- a/include/linux/bcm47xx_sprom.h
+++ b/include/linux/bcm47xx_sprom.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 
+struct bcma_bus;
 struct ssb_sprom;
 
 #ifdef CONFIG_BCM47XX_SPROM
@@ -28,4 +29,18 @@ static inline int bcm47xx_sprom_register_fallbacks(void)
 };
 #endif
 
+/*
+ * Fill the NVRAM-only variables of a bcma bus whose SPROM was read from the
+ * device. Like the SPROM fallback, only with bcma built in.
+ */
+#if defined(CONFIG_BCM47XX_SPROM) && IS_BUILTIN(CONFIG_BCMA)
+int bcm47xx_sprom_fill_bcma_nvram(struct bcma_bus *bus, struct ssb_sprom *out);
+#else
+static inline int bcm47xx_sprom_fill_bcma_nvram(struct bcma_bus *bus,
+						struct ssb_sprom *out)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* __BCM47XX_SPROM_H */
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 0548af664..02e6c9054 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -76,6 +76,7 @@ struct ssb_sprom {
 	u8 gpio1;		/* GPIO pin 1 */
 	u8 gpio2;		/* GPIO pin 2 */
 	u8 gpio3;		/* GPIO pin 3 */
+	u8 gpio_ext[12];	/* GPIO pins 4-15, NVRAM ledbh4-15 only */
 	u8 maxpwr_bg;		/* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
 	u8 maxpwr_al;		/* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
 	u8 maxpwr_a;		/* 5.3GHz Amplifier Max Power (in dBm Q5.2) */

-- 
2.34.1

