Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438190;
	b=x55HNTq2faspV4XMNnJmeWiJ19dBKNL488ZKdPAQV5592hukCgjSP/2EIoW4j74vsdLT
	 3sctMP6YSuwKeclqlPujYAk3CnqlevxA2bGyhZ38+8JL2MBapQ9gew5/43K8J01/kUEPe
	 2qbzUuPZmiNB/glUcO3LDJ8SqFpZCLovBI3CfjQW0tPgH/IAb2rZGUy88dbnJql4SiHGg
	 ajNPq9rqAl4WzNt+JTbwzlt5bl8vrc+CsO9R02ycH+5ULsu1Lw04bazuDGF0onvi7nQTt
	 wghv84Ts3qwTBo0JdkS31zo9lEi+7qaDFNBtqqwUpEkLGJ83oyBaiblWqIKYsxuCHJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438190;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=cF8hsAvh5NU0If2PiCZvQf2hA4O5R/M+iBgL1iW34Tw=;
	b=iMweMqKB5J9nJVV3OI4wEJKZ/dsWa7yp5hfldkZSqmjOn+Tiqa7aGP9MnGyb7FJC0VRo
	 ReOgdT7+Ipoa/UrU7YBaWQrLkRcHqKguO1cY+kBxSU8cDYDKO4SK9+O0zoyThP68Wa+kT
	 84nfSSA5nT5lIWXMOttF6lZRkZJUz7vDByvA8kmxGiXA8oagjxk+MjAGRzuHrKizPVQB3
	 /0HHOL+vp18OT5CcIgAiNTvMgMs+N/j1tt9VT6J82T/RdJX8RfSKLMhuHuJIaOAKgNdMe
	 d0o9ESn0Iv2bUdXIomWg4fEsB1FqFl/3FXng1QsOfm9Eo3UQZ7DpxxT4lV063thossQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=L3Op+E0b;
	arc=none smtp.remote-ip=62.149.156.86
Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE4C606A320
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BE4C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=L3Op+E0b
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id N5BMx1hYL6q8sN5BRxVoUi; Sat, 31 Oct 2026 10:15:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793438129; bh=8f5UgKMcuAyNs+Cvdxg257LcBIIUIRGaXx1FhL+pExo=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=L3Op+E0bmuzmh62bprUycy+hmyE9ns+90bYk8p/StO8duJuCyVZUcMtobcwHntpPa
	 MNkdt0lxOfcEftt5qBdTNeFK6T7yumG3T7Rexk/2JCpkkoRbnW33B4uYsJk/klGnS/
	 Dspa0d2JreY1oMiw7CLEm6LNuu1mV6HXR5LDYHP+DOaCHl2deMXQ/pqqs/mH8Mt7qf
	 /URLx9S209K91RNtW0u+0d1LpwggkndYRtgrcyth3OUH8/RV8RXjmNvHBsCF5wgkq8
	 XsP9ySU94pcdpkFvhm6Cb4QXRv3Tuxiq5qm874dJbh7k7GF5c0emlA7Pc5TZ0yspsf
	 H0w0CMovuUwbQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Sat, 31 Oct 2026 10:15:29 +0100
Subject: [PATCH wireless-next v3 07/10] firmware: bcm47xx_sprom: read
 ledbh4..ledbh15 from NVRAM
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
Message-Id: <20261031-bcma-ac-rev1-v3-7-1fbe38e8179b@mythread.it>
References: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
In-Reply-To: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 b43-dev@lists.infradead.org
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfBquXWVKbtw0SEhOKbdbXouZGKYZ2kXTor0QTiJO8zQvI85TLhqBw8PYg59AlNu1D76ywnY2MifXuPuhC8YHJRxx9Gadh1YXjDH/n70ilvRUd/nX5cgp
 LYOORtmUFcp1/HKwJDjHpM4WIggOKfwQ5MKsUM5uxr+9xszmNkdAjcu0zp/5Mw8LwyPyQVn2YO+689yVat7rW3goCXT0VbKBfdJ7c5Q2z7YyTrLJ9Fl6A0Og
 C0wY2Cx87zgQOYQn4QmwkZkBC+dm+tiRm5ZSDGTJa5miqfLDJQGQ1TiJUY1TApotFzYS22MXgKnD7kdhfXR1bi5PyW6E51WFFrRo7GOkNVA/IEWllvTfPWn5
 +dhg94o/yhFLdqpi1Gb3ZQxqMKuBeO33GWQtQnLuV4O4IFqY2lXyJ3zmcQzUSE8MpdG5z+l3KXxZQd0OWS+TflwWSLEEOw==

Add gpio_ext[] for the LED behaviours of GPIO 4-15 and fill it from
NVRAM ledbh4..ledbh15.

bcm47xx_fill_sprom() is reached only through the SPROM fallback, so the
NVRAM of a bcma device with a SPROM of its own is never read. Add
bcm47xx_sprom_fill_bcma_nvram(), which bcma calls after extracting the
SPROM, to read the variables the SPROM has no word for on top of it.
The bcma prefix lookup moves into a helper shared by both paths.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/sprom.c                      |  3 ++
 drivers/firmware/broadcom/bcm47xx_sprom.c | 86 +++++++++++++++++++++++--------
 include/linux/bcm47xx_sprom.h             | 15 ++++++
 include/linux/ssb/ssb.h                   |  1 +
 4 files changed, 83 insertions(+), 22 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index d68bc3822..d78615c53 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -11,6 +11,7 @@
 
 #include <linux/bcma/bcma.h>
 #include <linux/bcma/bcma_regs.h>
+#include <linux/bcm47xx_sprom.h>
 #include <linux/pci.h>
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
@@ -837,6 +838,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		else
 			bcma_sprom_extract_r8(bus, sprom);
 		kfree(sprom);
+		/* Most hosts have no NVRAM: ignore the result. */
+		bcm47xx_sprom_fill_bcma_nvram(bus, &bus->sprom);
 	}
 
 	return err;
diff --git a/drivers/firmware/broadcom/bcm47xx_sprom.c b/drivers/firmware/broadcom/bcm47xx_sprom.c
index d0303f2ee..46a817d71 100644
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
@@ -204,6 +205,20 @@ static void nvram_read_alpha2(const char *prefix, const char *name,
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
@@ -241,6 +256,8 @@ static void bcm47xx_sprom_fill_auto(struct ssb_sprom *sprom,
 	ENTRY(0xfffffffe, u8, pre, "ledbh1", gpio1, 0xff, fb);
 	ENTRY(0xfffffffe, u8, pre, "ledbh2", gpio2, 0xff, fb);
 	ENTRY(0xfffffffe, u8, pre, "ledbh3", gpio3, 0xff, fb);
+	if (sprom->revision)
+		bcm47xx_sprom_fill_nvram_only(sprom, pre, fb);
 
 	ENTRY(0x0000070e, u16, pre, "pa0b0", pa0b0, 0, fb);
 	ENTRY(0x0000070e, u16, pre, "pa0b1", pa0b1, 0, fb);
@@ -807,45 +824,70 @@ static void bcm47xx_sprom_apply_prefix_alias(char *prefix, size_t prefix_size)
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
index 49b34c153..c91d47592 100644
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

