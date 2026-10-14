Received: from smtpdh16-2.aruba.it (smtpdh16-2.aruba.it [62.149.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C64AA02E
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010665; cv=none; b=IOvlVWHKeQMqe5s5UNv8XCKU8034UVKNe9kkxeiULaPxFArTzfJTGMpshMddmJfxm6PgAWxmc/WI/HcGB4nY8VJprCYea2cg2oFW21HCmdMIhmdQrOScuGKWlbBVvtQeldVFnVr7SiHbx3aGGVYY+ziMu2TxtGw5HbEI0off51M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010665; c=relaxed/simple;
	bh=0/Wg1LIzI4WYei9afLFroj693OPuqwQEgqkX5ZH5lng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BPA3Jykpig8p+hSoBn2Xu4smwphUu0K+pZySdW2ekER3VyscIq8/8nOzP/zs4/rBUL4hFr2zVGCQGAvRy6rEqv4ozq1H1Roh21/S3hkgn/Zjn2crtL+yojcTOY33rAa8NELU6LqxOIRni3t9V7A4wCwtkOfvIRYmr1mXFrVUAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=A+O4omfC; arc=none smtp.client-ip=62.149.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="A+O4omfC"
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id H5mdx2rTsgYw4H5mkxSpD2; Wed, 14 Oct 2026 22:41:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1792010474; bh=0/Wg1LIzI4WYei9afLFroj693OPuqwQEgqkX5ZH5lng=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=A+O4omfCqfFTVhPZR+FoEmlZP2mYWU0na3mCwNXuGnmwPq8jylnliZbcMrc2+LueZ
	 oOnyHCcdU9Yc90xBH/V/Nu3X92+ged/81h22Qkztrp6ZRX2k/F+PLt3z57uMnckElb
	 tg/6VCOi28CGI0VjBFeqe/sZJpjHI1iyD0BuLWDiR21Ex8AhoWCUySavStRH06C3bg
	 ofzSo4m/Lcpt4T357Jn6UbKAiofyQs6LUi3+SaOaVxB2aOHQJBD4gKfznAy2PFA8Uu
	 HCrCPSoaOzngCei5baRFFbFCs9/QZUFMO0NT8+yC0OZup/hfvpsPY5wPKNKsnj9JkE
	 C8cdtEPQgQveQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 14 Oct 2026 22:41:05 +0200
Subject: [PATCH 4/8] bcma: chipcommon: set corecontrol bits 5:2 on
 BCM4352/BCM4360
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-bcma-ac-rev1-v1-4-b608e99d3f56@mythread.it>
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

Set them in chipcommon init, as Broadcom's driver does.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/driver_chipcommon.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index fd91a39f0..889f8cc1c 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -227,6 +227,11 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 			((leddc_on << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
 			 (leddc_off << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT)));
 	}
+
+	/* Corecontrol bits 5:2: bit 3 is UARTCLKEN, the rest undocumented. */
+	if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4352 ||
+	    cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4360)
+		bcma_cc_set32(cc, BCMA_CC_CORECTL, 0x3c);
 	cc->ticks_per_ms = bcma_chipco_watchdog_ticks_per_ms(cc);
 
 	cc->setup_done = true;

-- 
2.34.1

