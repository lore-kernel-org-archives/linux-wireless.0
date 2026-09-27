Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14438231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543069; cv=none; b=tbGw+58jCOPJVLawoaHkMp47YjnYQeTjpCPvmhdt0YdJre+97HbqMCR+Pw2AOHMNg6Mu1kIxrYMiTXQNHcpxIrw3yHVfTqEmu37Ms6eGGobWSiTqBCCdRlR+jzIzcCj9cnR2be9fvQWp8BHgXtSThr/wFnLmLy2IJo9XtZUYf54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543069; c=relaxed/simple;
	bh=z7TxiByGpJHeG5Zd/dRQtTi2GNG/TraqJ52sTJTFRds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnbcT+OchTELMztuR/wniBSzODQiSI2ZTDQRe/GG0BLciKjNkPMTR751EUp5JgCg3I6dhs88jZqeX19C76ZSYd4lyVZiMwoKUy5DXYlyK9DPOmSGxYcOgavEaM0GdNMei+Wk1sHIi7MJZXmCQR0JYXn4IpJZfqX4xsnVVOGqVns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f41.google.com with SMTP id 00721157ae682-8a8496fd8c3so23199477b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543067; x=1791147867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=51tKyP36tDuGpcEaNaaGVAIec2B8UojDAEaCdV7fQHs=;
        b=JemKeewo1BP9xEgmtLyaqoZhxPeesSbso67DtcxHl4HLHMhXkgxlckmD6BZxRVUGIz
         wAL9MoDL2RFEcVubAlniUFnf6DB3wDM9U9asNP/miGc2oW9STFckWiiObb0eVHfMaVva
         4B8oyqT5LVz2r1VdrpTENhjbtkk1QrhxrCQhCLEjzaytJ2q/K7VSegQ9bBITW5d+yH1c
         9eY5EEebazoP1Kedc9AOG8Bt0/GcPKfgf6XbTNRDNpH3dFAP7RzG2AYuqOQN/9G7zcvc
         LbewtLHn/zm8KT42tXbyynryG4KVCZIXSAhC5oGPo2TUrHZrvunppHAAgxsCvy3hP5dk
         FNFw==
X-Gm-Message-State: AFq9FYItiGHX7xkD5o3fSaj4kBKniFhCvvSVPwYcJiMM1MuHKdisFak8
	MHoMnuLm5ibJmAiuOBeokML9SdliC7ODalGWEye+i9XtUSKQMDrTaJ1o
X-Gm-Gg: AYBFou3/RYocJ2Jw38l3SU3zvLw107PRQG1Lq0i0rpmWBjBzB2vxNGIj+yOcps3c0I9
	IGW5ZlAAmW8L2+jEcSOSdcsSmfAuKl/ElkNVfB7LtLsRuuBxrPNKpFjyqP8Ikw+yDZpBUP0QJp6
	KRRHqv08iMDCubdYdSTKjineIWjZ4q1srGzemHWI6R6RQmi3GYONuDySel1tvXgJzB3rGDBbumM
	9FBu3xpbRfTMAAaIJJe+n+MQYfB2284ej0ovrLIRCHE1+orK3L3IpH+sYG0c7B3sljllb2fteh6
	baSR8ejH1FR421d5Ch4qICJgCbwpAccCvUYiCYl8wTeEmJ6WZPLtxjyN29tKtJa1UgxpZmRce7J
	cK1NNHoxxBDpTXuIG3PNoyfbZRKFGt1Tnq5/cShn1+VuDt3tAsMIAtYziRwUHRfjJuLMIORQvWM
	ccasRAsvWVq+VpTwxKTlVw5C0SBZLl4bBpQYfYuvau+w+3XTga4zAXOmxO8kwf+BvxYtEWDs1i8
	fsRNowLAs6LWxWbqqF+pm9dPaI6df/iprlWJiyJMrqqi2a7XuPulAaBah8qg+qEzQokDD7B4HY+
	loPf
X-Received: by 2002:a05:690c:8f:b0:884:c7c1:31c3 with SMTP id 00721157ae682-8a64bb0003cmr58968007b3.10.1790543067107;
        Sun, 27 Sep 2026 14:04:27 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:25 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 20/23] wifi: mt76: mt7925: disable only the RX NAPI instances that exist
Date: Sun, 27 Sep 2026 16:03:02 -0500
Message-ID: <20260927210306.737669-21-sean.wang@kernel.org>
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

mt7925e_mac_reset() picks the RX NAPI instances to disable from the
interrupt masks, but the instances themselves are created per allocated
RX queue by mt76_dma_init(). On mt7925 the two do not agree: the tx-done
ring is only described by the mt7928 DMA layout, so q_rx[MT_RXQ_MCU_WA]
is never allocated and never gets a NAPI, while mt7925_irq_map still
carries rx.wm2_complete_mask.

A MAC reset therefore calls napi_disable() on an instance whose
net_device pointer is NULL. The fault happens inside napi_disable()
while the reset work holds the RTNL, so networking goes down with it and
the machine is left answering ping with no usable userspace; only a
power cycle recovers it. Repeated NAN data path setup and teardown hits
this reliably on a busy channel, where MAC resets are frequent.

Iterate the RX queues instead, the same way the restore path further
down re-enables them, so only instances that were actually added are
touched.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 6e9daf96da88..32463ef30ebb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -127,12 +127,19 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 	mt76_txq_schedule_all(&dev->mphy);
 
 	mt76_worker_disable(&dev->mt76.tx_worker);
-	if (irq_map->rx.data_complete_mask)
-		napi_disable(&dev->mt76.napi[MT_RXQ_MAIN]);
-	if (irq_map->rx.wm_complete_mask)
-		napi_disable(&dev->mt76.napi[MT_RXQ_MCU]);
-	if (irq_map->rx.wm2_complete_mask)
-		napi_disable(&dev->mt76.napi[MT_RXQ_MCU_WA]);
+
+	/*
+	 * Disable the RX NAPI instances that were actually created. They are
+	 * added per allocated RX queue by mt76_dma_init(), while the interrupt
+	 * masks describe what the hardware is able to raise - on mt7925 the
+	 * tx-done queue is never allocated (only mt7928 defines that ring), so
+	 * its NAPI has no net_device and napi_disable() faults on it while
+	 * holding the RTNL, wedging the whole machine. Iterate the queues, the
+	 * same way the restore path below re-enables them.
+	 */
+	mt76_for_each_q_rx(&dev->mt76, i)
+		napi_disable(&dev->mt76.napi[i]);
+
 	if (irq_map->tx.all_complete_mask)
 		napi_disable(&dev->mt76.tx_napi);
 
-- 
2.43.0

