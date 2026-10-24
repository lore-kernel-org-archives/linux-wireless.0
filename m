Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812190;
	b=oG8d2BYSbrhsagMU7JWA47zhOh2drE45LJBCxEY7Hn2102tVA/7BxK7DE39U7J5FR3J0
	 vSN92M/6ThTDo8+4rtPpYz6y/7VWXzAnxIcUTfcJVZcdFxpjXQFsNTjL+iCBvaWYEySUJ
	 HYn3okjLCundlRo9eX0btbFqMXexpXI3u3EP/D+IEA2U0sf0Alg3EyvnJ/qwoCFgD+nTu
	 4EZYveGNmcwf/uUZp6770cn69aZZGp9ru/W4IKQveAvVD4mE9nNlrKjZZUygzBz3Vlxqc
	 JaN6LU3cLuNAMUMc2xKqS7tPJv7Nxh/b4N8dPNT/34wF+eAttKO1gl/NW/GM4L1k32A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FM8GNQ21z2tofnQ9HAGS228+B6GKkzHToThuxWl3/VM=;
	b=QxaXsIewfDbiDbI5F96aBiEZGFyQQLr5PFDQtKAv8qSd8o0fcqfcmQijQmFSlvlTjwJD
	 uXJ7JT9XTQsoPWjFY0qOrJZghSJM6ODDs2j9zhJ+IyPBCwsxU7tfqyy49yOff8duLoWZa
	 hIm5suAZUz1XjZQXNSR5zYVmyGIOmMQFopkh5mcz0h/Zi9drbEJYf92UgNgRkLslho5OV
	 sLsLrsyAvqpV9PTh+xe43WZc0TeObss5W8arybNUZqIjogfrhdFPPBsiFI9Pv0iL4YWgf
	 8Sx9YgihCQZ+JlUE44VMjGKtrMjGYyWbtZ0cATNB1Z6ZkGp9E9rMnnemYwCksnJCtRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pSYGpV6X;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682FE606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 03:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 682FE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pSYGpV6X
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1a86c0316so2238513a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 20:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792812189; x=1793416989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FM8GNQ21z2tofnQ9HAGS228+B6GKkzHToThuxWl3/VM=;
        b=pSYGpV6XhiNrN/MgRiKZavz5Juj7gKfHDnodVvw/X+/QYB6qrlsCrkg2Si4A0+jwnF
         xfWw3rcxzPKIb2f2tjbwTRkx2xibfU4ND9wl8RmFPhhf9+NX40jGCqtl0R5hv90+Xa6S
         HU7tUlORqj7WQaN96Do9CmUWRamZQIVX9D0FfuC+y9COyoingI06M48oGcFrhvMtJrKJ
         oxcYn81kKK1/BcrAEUvDtVjuNTQwCA0FEC2W59VuNX2dWkdaEygnWRqWs8l00U/zxEfL
         C1mmtkNILTBi3CXCMjsU0KsMVGQ0Kpf4k6a7V9of4MeWTq5H+qY9pSpKl6l5gpz3oren
         RBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792812189; x=1793416989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FM8GNQ21z2tofnQ9HAGS228+B6GKkzHToThuxWl3/VM=;
        b=L2FoE9ju0RGWV6vOW5G+laYRNJUSzmW9j3aeNSknps68P6IigeUsG6QgnVfvPszgb4
         5wMHNdWSWtc269xonglAi5bdDOOQBf9Ke2z6SasGuPhYOnnHRxLZe9HIDIXiKg84+vXo
         fvepqDOSfZpY3KlRSmGdlTDv85OQWBRn7v3ZYSy6CIEdmW3jFZIwlzUX0ZoebjAZX9+P
         LqBJjWshc/RGrOdPAcIEV6CHHpA5Kd/AwsLjcAkdu+w8SiEtyeVGlt0QQVi4227bL+ts
         fSif5NJPWWMsbP3VKpqV2MSqcQHbHqiRxs6J8LiZoM9ZYJax8OciPgiRXXVU/8PTUubP
         1cMw==
X-Forwarded-Encrypted: i=1; AKwUvBw8LMzrxzfFMgvhBc+8TQ4Y3z8ZXYwOUMLhgYvV7v0vwXfMSE0YbiJQ7eKwr3uBHP5yUUcEKDIlmBC4pHgaVQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ02OHudWdhs+vvb+Hy2ARyV3L4cpV4F+grflNwNF7N4ML4FtQc
	/4vBEQuo/i7Oa5sTyyQszwgPxYtLXsZ6tjYWkRO0egsrIYHcS8+dnqji
X-Gm-Gg: AYBFou3dgzpmVSt/pC5elglffwoC/Hs0oFFSf1fny7bPMvC5vDMBLLOhRVOoGRrZDI2
	RuIIfBQumcXPkBRr6MZ7OCvjEvzEJOpCmKJXGYaXYY6jrUlWzkLggLyhVlr5CVmW3o0HK9jP12+
	Te9HjiidzfDFr/1gS6vVPUS3PeDBEAZaGqJci/8qW87BPX+JfHi/bGxeP4vTNVaFFVHq3pbwL7H
	89W1iinpm3cLtZfHdEoeX+Q6CBgfueS0EkxCsReP4DLHcC7jj3zqjtMuLLclGenFq/AwYskoSTK
	B6oC+gnuhWVAmIdOw6HI6/PWyD/qnoI6vcXcC6LQ+hvBqEBaNmK3bVtqmefdu0XXrveGPK0NRtX
	jCiT87qaeXMuRuTWxMPbKVgVTYLcfS0f5XHWiZwkl/w+JgxvagVkS6drKoR0l2IGpdJb0IPpsyx
	eBXs/diNOpCCDINSNjg2FJgE+LlUG0yoLYXp6eCZ5NOlzqi5n+u8o6JPd4VhpiQnvE7Nq0KeYlo
	rpUjn4p+LxuwW3kJxhvOPwFED/315U8+fLDW1OjQeqsgPwTBt0f3lUEKURIT48+VjXuKz0F
X-Received: by 2002:a17:906:f59c:b0:c46:7ec3:fde7 with SMTP id a640c23a62f3a-c46bde62669mr89622066b.31.1792812188826;
        Fri, 23 Oct 2026 20:23:08 -0700 (PDT)
Received: from localhost.localdomain ([170.62.100.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd7a7c2esm38164666b.80.2026.10.23.20.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 20:23:07 -0700 (PDT)
From: Hedi Ben Hamida <hedihamida096@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org,
	Hedi Ben Hamida <hedihamida096@gmail.com>
Subject: [PATCH] wifi: mt76: mt7921: add pci restore for hibernate
Date: Sat, 24 Oct 2026 04:22:37 +0100
Message-ID: <20261024032246.53918-1-hedihamida096@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hibernation powers the device off and on. On resume the generic restore
path runs the normal resume sequence and can time out waiting for the
hif-suspend MCU handshake:

  mt7921e 0000:03:00.0: Message 00020007 (seq 12) timeout
  mt7921e 0000:03:00.0: PM: dpm_run_callback(): pci_pm_restore returns -110

Add a dedicated .restore callback, mirroring mt7925, which skips the
handshake, resets the device and returns it to its pre-hibernate state.

Tested on MEDIATEK MT7922 (14c3:7922) on kernel 6.12.113.

Cc: stable@vger.kernel.org
Signed-off-by: Hedi Ben Hamida <hedihamida096@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7921/pci.c   | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index f87c44f2a..00532b29f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -549,7 +549,7 @@ static int mt7921_pci_suspend(struct device *device)
 	return err;
 }
 
-static int mt7921_pci_resume(struct device *device)
+static int _mt7921_pci_resume(struct device *device, bool restore)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
@@ -589,6 +589,9 @@ static int mt7921_pci_resume(struct device *device)
 	napi_schedule(&mdev->tx_napi);
 	local_bh_enable();
 
+	if (restore)
+		goto failed;
+
 	/* restore previous ds setting */
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
@@ -602,7 +605,7 @@ static int mt7921_pci_resume(struct device *device)
 failed:
 	pm->suspended = false;
 
-	if (err < 0)
+	if (err < 0 || restore)
 		mt792x_reset(&dev->mt76);
 
 	return err;
@@ -715,7 +718,24 @@ static void mt7921_pci_shutdown(struct pci_dev *pdev)
 	mt7921_pci_remove(pdev);
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(mt7921_pm_ops, mt7921_pci_suspend, mt7921_pci_resume);
+static int mt7921_pci_resume(struct device *device)
+{
+	return _mt7921_pci_resume(device, false);
+}
+
+static int mt7921_pci_restore(struct device *device)
+{
+	return _mt7921_pci_resume(device, true);
+}
+
+static const struct dev_pm_ops mt7921_pm_ops = {
+	.suspend = pm_sleep_ptr(mt7921_pci_suspend),
+	.resume = pm_sleep_ptr(mt7921_pci_resume),
+	.freeze = pm_sleep_ptr(mt7921_pci_suspend),
+	.thaw = pm_sleep_ptr(mt7921_pci_resume),
+	.poweroff = pm_sleep_ptr(mt7921_pci_suspend),
+	.restore = pm_sleep_ptr(mt7921_pci_restore),
+};
 
 static struct pci_driver mt7921_pci_driver = {
 	.name		= KBUILD_MODNAME,
-- 
2.47.3

