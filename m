Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058890;
	b=UqwoZy8x8lHaqxUXRp/VU1xmTWjuBvO+WGwmPCwH4LnxVQZdq5yi4UZFzWvzqqbi4yt5
	 xmcL+9/OLrCbo/uj579W6BVqqwn7NPj3A4BoruQTiGrPPfqqtgZGLBeud7Bif6pgaX67B
	 /W3V4hlWbFlnPcOTiinGt/Pqj5ddLSRDpLV0bT7fTpyXtCPE1NqH01RU3LVSeMIB+3VOk
	 42TV+1ZmjTEmsOG26+e4OhrwYpSRjQDcGQoCDyLPXEvK2V9OlnhsF2tlnTKI3vc0lVFG5
	 4Btsz/FbrSHok/C6aHuvOUykfGrvsRSarhefnQZnBPSqso9ja+jJx0SVCKZe5BHTEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058890;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=tmLf/LhHmlix/ZRJFso7e9AUnTilQUuxrbjjOjPIDDQ=;
	b=Pukb1ZIUsp3nFLsEAtlYChRjERA1t8dkDQd8hEWSYtz5jlVmTfllw5lZ3v1Yd/ZJPvVT
	 n3pUln8qw0HPL02Ey8n5rB5w7dGZB/sR4LwQELhlwEfeoNRzZVJjLN9fP5SPelUrzBRqJ
	 7uoSYLzmwuECRXpdIwemSgR4VkkMBZzaaF2hPTCbQjXJjcZZriiSMCDM7naVwtSL3B5GO
	 aHk63YcVsf2Mxou5rkyqAMvpv9Zs/mkgUYvlJIGp3knumEFH0C7tQo1CBWqInBT6b3TrF
	 lJzJYO9K8oOEghNu5G9mrGYtrg4582EFpvJwXy+iGQuFb88lhhUwHymwysQCLXkMj/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=JBCVBDzP;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B403606A31B
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B403606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=JBCVBDzP
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVhxjBfo; Tue, 27 Oct 2026 00:53:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058830; bh=VkghKG5mvE7++Re6VaVBV/w1wZKm0wW+u8rh6hBTMK4=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=JBCVBDzPXNi4vn6vpTnOCS0fEXx2E6eg/0rfazevTA50urSwwITx5J3SzljULhuWZ
	 oJJZS1MzcYZSNVBUaCX10uTBeo4mw7R2CuFd2Z0kyoHa+F3QjrLS6gT4qcbbyqMRCF
	 5rWkf7U1SyWYuP3i7+otcAbs7RlOLp8skBWIXaqn1KY2NsAxL3vSXSHkXAeAtnZGDD
	 61f1REf9zPUuvlrn5cjpbIc58cWGXvFtOTT0vCF77IpOyPiXtHd1CCaE3avNXfa/GF
	 /e7XRfolXzMgxvpNCizlm6+o7Z5B7HO88V9KnIx2JmbFpUXrcrkqZc03zpgJOruK5F
	 m4BULNPAACKyw==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Tue, 27 Oct 2026 00:53:50 +0100
Subject: [PATCH wireless-next v2 7/8] firmware: bcm47xx_sprom: read
 boardflags3 and AvVmid_c0..2 from NVRAM
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
Message-Id: <20261027-bcma-ac-rev1-v2-7-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
In-Reply-To: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfGKOy2UZ5BM+jnYiTwLEWzZm9Bqn9y/XHLMt91Xe039y1mbDS6zN0sl+Ucfo/cVe5tkuNjlp6Rw5hN+pifebbZjZn2Ot8f5D3LabQYjPCd/QfoiIkk2z
 JRJRI98Ftv5kvfHOqcJ1mtIfbRgImpA+peqL7328E84g79omkE9gdyAGEk2JXHETX2SDT04LEZH/kbK507b5ZcEL7VoJ38S47JO1LyQfbEB7UNOtNEZiRvGv
 vvXnSdrxqhHJY0KqsWG1LTLCbhu75G2uAsRslHmkmNgWC99Gu/V4nYcdiRUV2aLrl537YzJvKQybbZt8yxAgZ4dcX2fuvGRKgnGYwPFNpFScuw+o8SNY9+l6
 gQ11Azqo6whfTqXDkAFnfhVyHKz3Tn6hteUXv2jso0pvDihPObU=

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

