Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820657;
	b=ljbQWAcJmePOFnfWGiseULNZM4+R2+Dcix52/ckM0ppWFhwzWseX4r7+isG6WgcB/fv1
	 tVvuR0rTLeYgMMVyRArsneRjzn6GQRWGueDrNRutBH6gky8KzR3xTw8fsZpX50qKODcFo
	 TllYMp3varwLvyoaKgbd3HVM4tsTKV+tH7DWCktbjaGIcamTHIxCMujs7k7Dsq3Bbaqh1
	 GX6CbisYqPr0RPhy6/6i5AfS4c1eACNxXr1nq0aS2O9TZJE72Rw5q80d62Ec42RMyuAji
	 bNHiKxXYD703wJAGLR/Bu1c/cKnqC6zu+9c+FgjNt2drOYOYXPdH5+QJ4K0W7WURZIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820657;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=LRxZ+PD0QvAQBzngCJHI2Ilyab16QmbXx/WX06J+POc=;
	b=u/81HADMPcic27rH/AWLVoL4t0Yj8NkSmVdgY0mHo02/JxCRHPfQLy5iVIi95ZtJ1nh9
	 JdhcR4qOQxCq/t7G7kNS8ENtdM/UTVmHKoTxmyByqOyVodUjfVRRjR96DX88TgekSRYPm
	 I8phVY5E+Z4gO2PcVNOywrEkhSnWy5tOuSfy7j74TQPUso0MzgE+gWmEGv0NXFTqmbpUi
	 4Cqd6MABu1gvDvu8as9W98oaXjAE604IBTuLYnXTd9986vVMEZPuX97ggCchbKUgfe2Ir
	 Z/9ObxjaivdP0vusNhxxz99iExXt+df93JbZ0anX7Ak3FLBYRlEat+NPnF4WzjnFcKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=a2TaL0cb;
	arc=none smtp.remote-ip=62.149.156.56
Received: from smtpcmd0756.aruba.it (smtpcmd0756.aruba.it [62.149.156.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49BA60952BF
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 19:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B49BA60952BF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=a2TaL0cb
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Ogh3xxDlIuuRMOgh4xJX7j; Wed, 04 Nov 2026 20:30:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793820646; bh=vRXnCPyQqazJMe4CaE/Snp/qunhVMLOAO1TQqfxzl9Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=a2TaL0cbOm+FC2KZuOaNmylR5+OH8za1Ska/8s2ARjEfqufwpL0yvQHeHTa5OEW/F
	 +MEVW6yBCfXwTZIq1DqlHQ7YEHvvhmuY9/wp0ANNpY0XC8fRhA//7rKOgPx6NxBoNr
	 ai06wdFJ2t/85naMx21bgClb3AyAbU76WKFIrWhejw6jiYaIPGcMPkvrYC+GdHCPvf
	 TSLeTqK2CzUMq0ntcSquwS9KvNxvc2kDkjGitRQ0jSe9eznPiWW6i9yP0cGskXayyk
	 btZ4M3St3y6OjCJYMw94eZX6IiEdBXqYSDd9AAyjDYypwQuHxrNAKQShmiMOfJwtU/
	 /v7n4oFX35ESw==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 04 Nov 2026 20:30:45 +0100
Subject: [PATCH v4 2/5] bcma: scan: support big-endian backplanes
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
Message-Id: <20261104-bcm6362-wlan-v4-2-f001f6d75dc3@mythread.it>
References: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
In-Reply-To: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfIRwhac84wbXo9VECU0DHaAKnY1rE1DV2KeJfsIi4OYJeMrh9+umvn813y1/n5XC2FHQ4GVjf8Pj5aciqrxd9dax3j2nPWj8q4X3RBqR7cK/jBhExe3m
 QXePPBXU1w7etHk9Wcz3oKxWa5QaDRiCgiA8XKAucsxI5QI0v9Lpwv1gGdZmmeQSGkuBsYLez/R67p8m12cFXMprNa5alhVR6Oz5b6EzzFKUrSa5U8U5mSiv
 mPuEjdWZPuG62z8D2AkU4keIle9hRKxMnImCZ3xWOZgWiLI/kBriRWYIi/IaVxNLVPoqFNS/Cdz8NcDL62wPYLs6QG6Uw/MBnjO2aaALV+a59Epy5y3HUnkQ
 m/H+cwr9sa+O5Bj5QFbmmGXa6FXi1jKk9PNnakVm4aF+qEHT0BjgFwO1L+xJcNGf6HqBdFJAuoCJ7FRKY8Bnw/WA0zkhCJX19wm4N9TRLZJsd0mCrNHexu2h
 hnK+docw7bDqz5ppBlUzlI0hBf9DRlrXeE+i9klhtJgpYCCz0LxwYtqWkme4GgYhjcVJ/0UL7UnGHYqbsBELxIdkkRDdTeJpMeQnAVQgUwPHcVjXOB/c++wv
 3NpKCUVxnGNXxIgO4GsE1LnTCy6IB2piIlPiMBVLhrBh/N5nFOWzRbVduTaRW0UGSx4BDFrYGycCi/wc+Nun3lPF9q5ye3XgZfUjtnaTwXPz9w==

On some SoCs the bcma backplane is a big-endian peripheral, so the
ChipCommon ID/EROM pointer registers and the EROM itself read wrong
 with readl().

Add a big_endian flag to struct bcma_bus, set by the host driver
before bcma_init_bus(), and use ioread32be() for scan-time accesses
when it is set. Core register accesses after the scan already go
through the host ops, which the host driver provides with the right
endianness.

Nothing changes for other devices.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/scan.c       | 4 +++-
 include/linux/bcma/bcma.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 84742408a59c..983a62ddeebb 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -143,6 +143,8 @@ static const char *bcma_device_name(const struct bcma_device_id *id)
 
 static u32 bcma_scan_read32(struct bcma_bus *bus, u16 offset)
 {
+	if (bus->big_endian)
+		return ioread32be(bus->mmio + offset);
 	return readl(bus->mmio + offset);
 }
 
@@ -155,7 +157,7 @@ static void bcma_scan_switch_core(struct bcma_bus *bus, u32 addr)
 
 static u32 bcma_erom_get_ent(struct bcma_bus *bus, u32 __iomem **eromptr)
 {
-	u32 ent = readl(*eromptr);
+	u32 ent = bus->big_endian ? ioread32be(*eromptr) : readl(*eromptr);
 	(*eromptr)++;
 	return ent;
 }
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 17fc50190014..7ab2b21e7238 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -362,6 +362,9 @@ struct bcma_bus {
 	/* We decided to share SPROM struct with SSB as long as we do not need
 	 * any hacks for BCMA. This simplifies drivers code. */
 	struct ssb_sprom sprom;
+
+	/* Backplane registers, EROM included, are big-endian */
+	bool big_endian;
 };
 
 static inline u32 bcma_read8(struct bcma_device *core, u16 offset)

-- 
2.56.0

