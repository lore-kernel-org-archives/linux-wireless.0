Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12368231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543071; cv=none; b=XXg3Qzq31/3KS+q7LWPTbqOb+tip0wstuE5qOsFr5CEHm7DVvOsNc2yM9bo8e6DwzBc7SsKCxauMX9GqvrjZcP9jLoLfLX6n/11B41UaOYZQ7OgcxK+/bcE3cHjMH6YL0WIOqd8zIPCJfT6FRs3eO+FJoPPZsXDrs3DS6QIGLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543071; c=relaxed/simple;
	bh=7VdDRe0qdXH6H2upfl56kdLcjXHSOtyCm8Ts57/VTiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGuIvFhAQhR9UaI6gNz8TwFTRfQdpHChrZwecGu0Rp0YOh6V4Q2XnW/srOrMVbD8rcjpyPKO/ExF/SDFzsnMtU2lIVlhhQS0TTdhOaSMvIUORSbnskxtw9eCU895mGTGBsUU6aQez5k0n7L/IktDY+9Cl+ON5SrfT53/iv6tkkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-8961cca9193so32365687b3.3
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543069; x=1791147869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gKZ8oc8IA+KkaKuxtAKDlCC3SZXocaZH/r6Dx0YeWrc=;
        b=wPi7c2JMtGTMSiO4pSkLVUU83INb24KIPuVVBlm5t84EN9K8isy/slUqKK+95TthWU
         qzZddW5KdJ1PRDPfmg1nsTa1Od1YCyzyQKvLQGR/ga7ZkukfXcJeqz9ZV57d+xchs56I
         aDb01rQnD8Ciw2lahCrRsxkO+cLPNkJhowTXfYNF0+4fgX9vXG3R1jVOMb5Z5mYjJAqH
         Co6ttcrS2J23KDoQpI+v7AA8ZXyVODSh2dLbHDI8PxvLW/xrsMw67n4IQ7kpxyHczjqF
         h5kmYKiZnAq5wRUWBEcFYczg1OW0dayW9CZk/yjgQLKjG7lndAYCTuyMFXJghigFqAuf
         bNwg==
X-Gm-Message-State: AFq9FYL1Wyeo301HOpX9WqhXFafalCWHltG19DZqRdyIhk7QzAYTyQqb
	v+8c59Gr1+mUxOucvl1p4J6Pzcbi5d6S6pO1YVhql4/ieLR8ykm8TVvF
X-Gm-Gg: AYBFou0uHyT6/zcTQYtWDJ90TK3xURsjyYzbFqxnI8CKun61z309xX8LoixrDwT3grd
	RCYxeqYKTUsjrv78eDRajjSJSF9xzkWSeU7A51cdueO2NdHp5nIAQXd3AqTx4J3fhgW0yG9GWWW
	4hnKhDI9at93wNRRxlpDXDI7yhJT6OdRCtUAD5Jrvth/zPrgCwwroM/vNBijHHwClo8aTrby7jU
	heiq8jlqZ9LukDyXwWJ42bjEaTpoLA+ZCVeUfoeZ+nV5T1SloGeADeaPKqw9W6Jt1w8NQ4Plzaa
	UMB1EF3xRZXoq2xsDVpj0PjQKI8PMNsCjQwm2K7Z+dzOzfrWsCzQzlRX6E6JsbW4FGR9CJkfhDP
	sO+Bsk5STqu9j2i3L67CliMnL8DADh+Ci4yl1WAnJpuIs/SHxqqoSJueo7jMgMp7AiLcOAAoweZ
	NQ50YyuLfqlzl9PHhGlt2jhz1b34wdZCqUGb2+3O1tfYJgdG1Wo2G8t5j+2azCOdkignapaCtSS
	nIVUzdKC72IAZG8lZjBXUWNsiWx2T5Yp96z85L3XKEfdgpY8hP2m7bnZr4KXuZEbzNnjw==
X-Received: by 2002:a05:690c:6d82:b0:8a4:b0dd:c849 with SMTP id 00721157ae682-8a649f61d9cmr57019707b3.52.1790543068928;
        Sun, 27 Sep 2026 14:04:28 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:28 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 21/23] wifi: mt76: mt7925: stop queueing resets once the device is being removed
Date: Sun, 27 Sep 2026 16:03:03 -0500
Message-ID: <20260927210306.737669-22-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacobs Wu <jacobs.wu@mediatek.com>

mt7925e_unregister_device() cancels reset_work before it tears the device
down, but every source that can raise a reset stays live past that point:
the MCU command path, the system error recovery and interrupt handlers,
and the MAC watchdog all
call mt792x_reset(), and the interrupt tasklet is only disabled at the very
end of the function. A reset raised in that window is queued behind the
cancel and then runs while the device is being dismantled -
mt7925_mac_reset_work() sets hw_full_reset, stops the queues and
cancels the PM works before it can notice that the device is gone.

mt792x_reset() already bails out on !hw_init_done, and that flag has no
other consumer: it is set once during hardware init and read only there.
Clear it at the top of the teardown so no reset can be queued for its whole
duration.

Measured on rauru with kprobes on mt792x_reset() (queue), on
mt7925_mac_reset_work() (execution) and on mt76_unregister_device(), which
runs immediately after the cancel and so serves as the anchor, while
chip_reset was written in a loop across the module unload:

  before: 205 resets queued and 415 mt7925_mac_reset_work() runs after the
          anchor, that is after cancel_work_sync() had already returned
  after:  no run after the anchor; mt792x_reset() is still entered but
          returns early

A chip_reset on a running device still triggers a reset as before, and
unload/reload cycles stay clean.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 09153d624fd5..f7b57a82f2d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -46,6 +46,16 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 	if (dev->phy.chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN)
 		wiphy_rfkill_stop_polling(hw->wiphy);
 
+	/* Stop new resets from being queued for the rest of the teardown.
+	 * mt792x_reset() bails out on !hw_init_done, which is otherwise only
+	 * set once at init, so clearing it here closes the window in which an
+	 * MCU timeout, a system error recovery interrupt or the watchdog
+	 * could still schedule
+	 * reset_work behind the cancel below and run it against a device that
+	 * is already being dismantled.
+	 */
+	dev->hw_init_done = false;
+
 	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
-- 
2.43.0

