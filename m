Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB61481AB3
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010659; cv=none; b=lV4uI+XX2ZYu106wTNl4g7VymAuTdPjntlatVF9UHPqRN/ftZ6gSV8o/pVFnnfcbA2BLmwSo9MdYoHI00Mc0XYrZUcfmwMAU74h/VEhZfzdbOBU7cvvO6406WOxXtH+EvEGhJyqsdd4h24sOkL15XUSzOqq95ypnKvwvtXnpHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010659; c=relaxed/simple;
	bh=VkghKG5mvE7++Re6VaVBV/w1wZKm0wW+u8rh6hBTMK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pqKcNwXRqm28nxTIyA9fm09lRQCROTUXoAnl4f3ecR3yQiWwbgM2/kefY1yhwX0QPtyOCqT87kfa/7yqyBSScFCX5wtoZq5d87HP9cRXrMusHZp4psf5n4rJto49R8PQayAmaqjxkvP0ZYnajHohXvje4uaNN2TrgaIENkMAfzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=i7VnEDfg; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="i7VnEDfg"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mkxSpDj; Wed, 14 Oct 2026 22:41:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010474; bh=VkghKG5mvE7++Re6VaVBV/w1wZKm0wW+u8rh6hBTMK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=i7VnEDfgbpnjvKgqN89zK/XMImg5+uaQnBET/8fsD3+PjLosIOgL78RjofC31PQ7g
	 6NvLEaYkHCB0fWcQnQGuyy1q9yzvaAcLg2tpaDoDkR0xz7bwwMoj5gy4DHmvbe77Fb
	 pt6YqkCY+drYmfByjGlvwEF/bGUWvQyzfCM/o9O/OPWnBuZLYaFCPFIlEcT/5sPByx
	 H9aWFw9gNd9uhefCqIS5FEcNTsu3ArotxARCdFh93KXPhARzh6IxJvOIJOe28vvKYJ
	 lOKOhtaHfKKWxNlhsFN/eGVydOUqul7cn/oUskFp44myjXiSSN6sYrY6qlR8u0C/aI
	 3zqJzsEhVJ2cg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:08 +0200
Subject: [PATCH 7/8] firmware: bcm47xx_sprom: read boardflags3 and
 AvVmid_c0..2 from NVRAM
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-7-b608e99d3f56@mythread.it>
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

Read them along with ledbh4..ledbh15. AvVmid_cN holds the Av/Vmid pairs
of chain N's power detector per band; avvmid_valid marks the chains
whose list parsed. A boardflags3 in NVRAM overrides the SPROM word.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/firmware/broadcom/bcm47xx_sprom.c | 32 +++++++++++++++++++++++++++++++
 include/linux/ssb/ssb.h                   |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/drivers/firmware/broadcom/bcm47xx_sprom.c b/drivers/firmware/broadcom/bcm47xx_sprom.c
index 75604cd70..581dd867d 100644
--- a/drivers/firmware/broadcom/bcm47xx_sprom.c
+++ b/drivers/firmware/broadcom/bcm47xx_sprom.c
@@ -173,6 +173,32 @@ static void nvram_read_alpha2(const char *prefix, const char *name,
 	memcpy(val, buf, 2);
 }
 
+/*
+ * AvVmid_c<core>: Av,Vmid of the chain's power detector for 2g, 5gl, 5gml,
+ * 5gmu and 5gh. The chain is marked valid only if all ten values parse.
+ */
+static void nvram_read_avvmid(const char *prefix, int core,
+			      struct ssb_sprom *sprom, bool fallback)
+{
+	char name[sizeof("AvVmid_c0")];
+	char buf[64], *p = buf, *tok;
+	u8 v[10];
+	int n = 0;
+
+	snprintf(name, sizeof(name), "AvVmid_c%d", core);
+	if (get_nvram_var(prefix, NULL, name, buf, sizeof(buf), fallback) < 0)
+		return;
+	while (n < ARRAY_SIZE(v) && (tok = strsep(&p, ",")) != NULL) {
+		if (kstrtou8(strim(tok), 0, &v[n]))
+			return;
+		n++;
+	}
+	if (n != ARRAY_SIZE(v))
+		return;
+	memcpy(sprom->avvmid[core], v, sizeof(v));
+	sprom->avvmid_valid |= BIT(core);
+}
+
 /* Variables read from NVRAM whether or not the SPROM itself comes from it. */
 static void bcm47xx_sprom_fill_nvram_only(struct ssb_sprom *sprom,
 					  const char *prefix, bool fallback)
@@ -185,6 +211,12 @@ static void bcm47xx_sprom_fill_nvram_only(struct ssb_sprom *sprom,
 		nvram_read_u8(prefix, NULL, name, &sprom->gpio_ext[i], 0xff,
 			      fallback);
 	}
+
+	nvram_read_u32(prefix, NULL, "boardflags3", &sprom->boardflags3, 0,
+		       fallback);
+	sprom->avvmid_valid = 0;
+	for (i = 0; i < ARRAY_SIZE(sprom->avvmid); i++)
+		nvram_read_avvmid(prefix, i, sprom, fallback);
 }
 
 /* This is one-function-only macro, it uses local "sprom" variable! */
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 02e6c9054..5a4daa76d 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -77,6 +77,9 @@ struct ssb_sprom {
 	u8 gpio2;		/* GPIO pin 2 */
 	u8 gpio3;		/* GPIO pin 3 */
 	u8 gpio_ext[12];	/* GPIO pins 4-15, NVRAM ledbh4-15 only */
+	/* NVRAM AvVmid_c0..2: {Av, Vmid} for 2g, 5gl, 5gml, 5gmu, 5gh */
+	u8 avvmid[3][5][2];
+	u8 avvmid_valid;	/* bit per chain whose AvVmid_cN parsed */
 	u8 maxpwr_bg;		/* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
 	u8 maxpwr_al;		/* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
 	u8 maxpwr_a;		/* 5.3GHz Amplifier Max Power (in dBm Q5.2) */

-- 
2.34.1

