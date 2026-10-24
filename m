Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792847930;
	b=4woe4HsR8u+YnifRoxcq17/7Fz0e7CGYGWJxcnmXADJxvFZsah6Eu3DHlIFG9tdNRLaz
	 BmeBLy564SQOunc/maE0JdAbPhNz3WbyjnsbgvrGKt98Sz2uScubfQQfQijTUFCWmvDbU
	 +JPb5qQz6A20rZcMwfdRYL9FJuLtfzLTrfko/o8quUydNBqe1YxxaOJLsIazyjFJgeBus
	 7DiwHVn6TxupvB6RbkGiQWxPo+tNCiYEZ0rKyiA4vkahe2xIrexGsNZGsPJnChAh1DG5G
	 HVActQwzFKgatvcPCaTtfVRiF6AQsgpmabJroh2513MmmERVik5VlJ/i/1wo1tzmtkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792847930;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b680pKzQa13v0eIR/DWLULm8zwErDKH5uvrOsGuOoiQ=;
	b=mqZpH9VM/nIhSXz/NnXpZiWuK5o7Qmmge+3DzIl5HR1PI6dtzi6GRVgFhjhEaW2N8Uv3
	 HSDDC2M90fVNwmGFRlpon1mfoQLJaLJVKN7PRmhQ7gJZIiiW7RbAQP8M0jamJieD6jKIJ
	 gh/blpXmfpD2wSVLI+RqJldIXhMKNIodkS5moatl+SaPVbysyNRXemZvRa/hof8np5zw9
	 Iy+ssaw9xNRwM8WDYdA+iEnlRqsgGqyN0xlEmFM80SNPdiB8iE6Umjysl7LdE/c48/66f
	 8WDO3jka34Y0znlEXiedqBADxiM3DQpMRaGSmTcEr1g9ULOuFVcH382iQPz2W1Nn1tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Jaxb/P3P";
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57840606A320
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 13:18:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57840606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Jaxb/P3P
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c468bd799ecso219058366b.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 06:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792847929; x=1793452729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b680pKzQa13v0eIR/DWLULm8zwErDKH5uvrOsGuOoiQ=;
        b=Jaxb/P3PXjFT38cXGvFVo4MLASdIUYSGXWXC7juOTbCdguJZsMVrOfc5L+iqWqi/ri
         w5TgqYu+JlJDs668cuw5s+EZbVxKM/ftWrn/jD+8U3VXQhNKCrGrc/geDSTeTECA/Wrw
         +mVGHgvWiYiFYjebTzctnfnBdnYVi8+z/O2pel/f3TR3bwmtiVzaz0q4xLdTR0Dty/OX
         Y+vkU+3jukMWt6c5m9Yum1c6axwju/nZOb5/qiUORnFzCm+0543zu/mb6riXYPxKdXDA
         dmw1bmTFMC9uGYpHsOHAL9zMbC4kSqxqCogFz7iyAeB3LeDiejZZmCHPSjEUWwY5WBEz
         NcOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792847929; x=1793452729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b680pKzQa13v0eIR/DWLULm8zwErDKH5uvrOsGuOoiQ=;
        b=Z89Nv23xWxwFZHI5wQqsLHBaDm1bRH7bl4Is5rHxPHynaeLc1IJXb5kPaFOq8eqhcV
         dgvACfpeUDEiWZakbVg1XxY1trgxkV5JZZ6CpEZ9dduC23oHL6EAr1IYDPfKMSL0Z5o3
         mtPuGbSVUQoUOnJLCq7bEPBGxyNbXxCVsw6Q8sH1WaMSbnBu2KR85fg80Tes7oWqDmEt
         iM2qJuevOzlZ0oy6gBcRxx7dsiIJziYq6gnEkGTwQuQdh4/kBseQ9lSSClUiywVRUq81
         L89Nf2/1Mlx/QDtF6fza557DM9NMH1KfG0m/sl4XEGQw5M3RlkotZ9CgnbaZ92akKs40
         rbJg==
X-Forwarded-Encrypted: i=1; AKwUvBzRYgCzqD+7VjFOmyy3pQjk3zKN8MsCwziB/tlyeWQnlah18bwVjhVorfhVabVWO9oNKw2uw7JUIeIQE9Rvew==@vger.kernel.org
X-Gm-Message-State: AFq9FYISXVLagV5i6h20depnqtoohOEOkNvqJ5hpnNeypiBHfRF6+b72
	E6huAP1sxf915MeuMG0ZreWtNGeDeoeK35lOpuKG2huw6R6xiBqBJmgg
X-Gm-Gg: AYBFou11U+91E8kPzaiPeJUP/c/1qiWkbD3zVKp1ONv08sqsa6IGhH9jZW0aOL3HDvA
	pGNETD35qYo3BpDDZ1lrycc1rdorDvtZt4mdTMFBBa2CcL2IMqirj9dvvy52rS8O/AVuWx1H8ux
	EdI912/i91slo+H2I9JuJsMr7HnAL6MBF3NWSZcwi4uZ+e7IXNZedXr1LBu74Irq5zKjfimD1ut
	aQ+V23vZplWQk8Ggd1QSBP+7AuE3iSA+PDv8FI/dRjfHf8CuunNsSs9WI11+Mo5Cv6+3n8O0ARd
	WoYhS05DKHRy7z85anfZ1oAnynUc0cCQueG1oPLHvZYLMr7yrUhgHL9NwgWa0hVEw+SHA+slvUz
	mXLNOEpX90Ozxq7KDTD1Rz6sbhiuqOz2LSJXUAY4hZb3QPKsMhtHupTdmaYJ8UgG/W7MUSUkzZF
	L+fdbEMvBCGnshMf47oqSS+KWdG3vmhhxX91kox1w36HHdsZpGE7iSQWPeRYgNRe9lLqEladYYX
	kjagxoEXB1ykIo6blfKOBJIK7XVDbp+EEL0YbLAxP8Mx2JFiYdAx/qm9aT/dPBqYWbRKn66
X-Received: by 2002:a17:907:2d91:b0:c41:c106:9772 with SMTP id a640c23a62f3a-c46bdac60eamr203215066b.1.1792847928479;
        Sat, 24 Oct 2026 06:18:48 -0700 (PDT)
Received: from localhost.localdomain ([185.65.135.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd6276d8sm87306666b.41.2026.10.24.06.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 06:18:47 -0700 (PDT)
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
Subject: [PATCH v2 2/2] wifi: mt76: mt7921: reset on HIF resume timeout
Date: Sat, 24 Oct 2026 09:16:53 -0400
Message-ID: <20261024131715.64435-3-hedihamida096@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024131715.64435-1-hedihamida096@gmail.com>
References: <20261024131715.64435-1-hedihamida096@gmail.com>
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

On some MT7922 firmware the HIF_CTRL resume command does not return a
response after D3, so mt7921_pci_resume() returns -ETIMEDOUT and the
PM core reports the resume as failed:

  mt7921e 0000:03:00.0: Message 00020007 (seq 6) timeout
  mt7921e 0000:03:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110

The driver already resets the device on this error, and the reset
restores it. Treat the timeout as recovered after queueing the reset
and return success, so the PM core does not mark the resume as failed.

Tested on MEDIATEK MT7922 (14c3:7922) on kernel 6.12.113: suspend/resume
no longer returns -110 and Wi-Fi recovers; hibernate/resume still works.

Cc: stable@vger.kernel.org
Signed-off-by: Hedi Ben Hamida <hedihamida096@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 00532b29f..dce88fcc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -597,6 +597,14 @@ static int _mt7921_pci_resume(struct device *device, bool restore)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
 
 	err = mt76_connac_mcu_set_hif_suspend(mdev, false, true);
+	if (err == -ETIMEDOUT) {
+		/* Firmware may not reply after D3; the reset recovers it. */
+		dev_warn(dev->mt76.dev,
+			 "HIF resume timed out, resetting\n");
+		pm->suspended = false;
+		mt792x_reset(&dev->mt76);
+		return 0;
+	}
 	if (err < 0)
 		goto failed;
 
-- 
2.47.3

