Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD0D3D1AA4
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184278; cv=none; b=kIAzCuAYvpKU8j6bp4P5+ecWc/exiMG7RBjE2glcD7kX07+ifiuc6rUIM3MkprJtsW/AEj4G/k1DgjDfAF9H94eObaiQR5rJmY+uUdkQm8ohYnK7zeMTwTkM88O4mmUeTeXYHxn9bY26gF2iVGQ7QvWKk9J2oqNxKbZNI3cotmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184278; c=relaxed/simple;
	bh=HjQOpuoQbKo7UsoxrCfXuZx+XAmeFfUI2umie4vhgCY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t9ZFPshEaBbLc7rGB+9m+l6Q1J8BNpGRp6Cwgqi/OWO36hjWp5SSYRVw8ymGx/hwbLAl2T8DU2WoyCKXXqbHUx1YOjAEGDrIWGVHPWIWaQs4hqZUDaJmO3qh6l9L+f6hiAAjf6POv20anfVYkfHqJobLXr3aCFIdlw9bz/8hAmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=HXG1rQsf; arc=none smtp.client-ip=95.215.58.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="HXG1rQsf"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HjQOpuoQbKo7UsoxrCfXuZx+XAmeFfUI2umie4vhgCY=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790184272; v=1; x=1790789072;
 b=HXG1rQsfup3O2TVcAI3wEya9KPXinvUGmFONNRiSo616RSap32xcv8nAWRdWJB+81luYxNDj
 2suKyJRZwODKImHSHZjdNPXhRPF8qWYl4g/pJzK7QLE+4+wAI0q9Px6snbPpjOnkJ8sH0ySAeSb
 lb+qDhHouk1fiWMz7TAroDvVVMazia23T1SmaMUoajB6K4GMDiBkYQ2FremqKOATerrv2/2nu6U
 zCUCK9+oXfK6Ix8V7wPYKR9dEBDDX6ibcVuykTvDA6Q9K7hr41lWDlZa7bbOvpK9gpZZHMUjb1G
 BYFx0DszTBVEWGUqnaYrLRUuU5Hm/lr/CCnSfVGAS2nMw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 07e5e90db26aa7f8;
	Wed, 23 Sep 2026 17:24:32 +0000
X-Mizu-Trace-ID: 07e5e90db26aa7f8
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Eason Lai <eason.lai@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: mt792x: defer the MCU shutdown past unregister on USB
Date: Wed, 23 Sep 2026 10:24:24 -0700
Message-ID: <20260923172424.24021-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The USB disconnect path abandons the MCU before it unregisters, so the
teardown commands that follow cannot be answered. The response parser
reads the silence as a timeout and starts a chip reset for each one,
queueing the work that was cancelled nine lines earlier and reloading
firmware onto a device being removed.

Shut the MCU down after unregister instead. MT7921AU on a Pi 5, eight
unload cycles per arm:

    unload         5.67 s -> 2.81 s
    MCU timeouts   8      -> 0
    reset queued   8/8    -> 0/8

Deauthorizing the port with the link up, to cover a surprise removal,
goes from 3.21 s to 0.33 s.

Fixes: 7910bd565d8b ("wifi: mt76: mt792x: quiesce USB paths on disconnect")
Tested-by: Eason Lai <eason.lai@mediatek.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
index 850f6b2cfc4a..5e19e64a9a00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
@@ -502,21 +502,26 @@ void mt792xu_disconnect(struct usb_interface *usb_intf)
 		return;
 
 	set_bit(MT76_RESET, &dev->mphy.state);
-	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
-	wake_up(&dev->mt76.mcu.wait);
-	skb_queue_purge(&dev->mt76.mcu.res_q);
 
-	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt792xu_reset_work_cleanup(dev);
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mphy.state)) {
+		set_bit(MT76_MCU_RESET, &dev->mphy.state);
+		wake_up(&dev->mt76.mcu.wait);
+		skb_queue_purge(&dev->mt76.mcu.res_q);
+		cancel_work_sync(&dev->reset_work);
 		set_bit(MT76_REMOVED, &dev->mphy.state);
 		return;
 	}
 
 	mt76_unregister_device(&dev->mt76);
+
+	set_bit(MT76_MCU_RESET, &dev->mphy.state);
+	wake_up(&dev->mt76.mcu.wait);
+	skb_queue_purge(&dev->mt76.mcu.res_q);
+	cancel_work_sync(&dev->reset_work);
 	mt792xu_cleanup(dev);
 	set_bit(MT76_REMOVED, &dev->mphy.state);
 
-- 
2.55.0

