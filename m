Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390A31F8755
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 01:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786238629; cv=none; b=AuOEpfLbchPvVtSKoNCKl2qwjUlKGAhZMHSWu9kiLTq+PXMep2eZv07kXJiRrbKYqJpBN4eCxfzY/BEGxECwoUJzM2/e22/7yLVKknecXIhkXQ+1HqG58Ef3KBHJ9IV7cfd+prMK0PqsYSHtbEscGb2ngR/HAun4jo7dxEhz+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786238629; c=relaxed/simple;
	bh=ze7i1FsriWcAQixbaGuA/0PZnCHQESOKHcVZ3ZLRe1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HI1i5zFi+XPBD+H02Od0OoUyD1im4ZnTq3EmE241gyW8+wutdus9Q5CtrqhalbZfGMQc5+FILVwmFWFaTnhuTPht/ivG9urEHFU9O92s8/jg9pElN+Qaaeud0u9Y6xZ051CJfCyXm8oQtGiLGN1tTNbr77aO0l1QT7fIxR6qsZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=HDC7bJfr; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="HDC7bJfr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1786238623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EqjVhNT1qnAO8PMUu4jkHoOq42Hqz8Dv+e48J1/57G0=;
	b=HDC7bJfrPQAwb+I5t5yDFu7FrXgAXSugEXQ+adp9X8zP4TH+OMXdbfUUQE2Re7vh/5Fvo2
	PGy5qhm6LuknIsE1Tps+ycq6CSdw/k9kx4DokQdoa7SlUAKRaKAzxe9S0EjkmkA5v3DQ/7
	27qbQIhEJ96TqOxMaZQF3kbEu0nopVzrp6PMRhPVoVl1Rp2nnNb7C+XHQiieVbK/Wqi/Ix
	JhKlQWW01zEMkRmqCCEFDOjqGOcWzdf2eaN2hT49B+ESlT1+ms7diDxoKQYMWqMBvaUO+h
	qmlzXhmKAC0SiUTN6P/J95DCAJiiUg8oELZWWURSL8pXnIXuJ0JUgCIpBbGkaw==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	moosager <moosager90@gmail.com>
Subject: [PATCH wireless] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Sat,  8 Aug 2026 18:23:09 -0700
Message-ID: <20260809012309.43657-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mt7921e_mac_reset() ignores what mt792xe_mcu_drv_pmctrl() returns. The
probe, suspend and resume paths all check it. The only other caller that
does not is mt7921e_unregister_device(), where the device is going away.

If the driver-own handshake does not complete, __mt792xe_mcu_drv_pmctrl()
gives up after MT792x_DRV_OWN_RETRY_COUNT and returns -EIO without
reinitialising WPDMA or clearing MT76_STATE_PM. The reset continues anyway,
writing interrupt enable registers, cycling NAPI, resetting WPDMA and
downloading firmware to a chip the driver does not own.

On an MT7922 with MT_CONN_ON_LPCTL held asserted, a triggered reset gave 8
ownership failures, each followed by an MCU timeout and a failed firmware
download:

  mt7921e 0000:04:00.0: driver own failed
  mt7921e 0000:04:00.0: Message 00000010 (seq 7) timeout
  mt7921e 0000:04:00.0: Failed to get patch semaphore

With the return checked, 26 ownership failures produced no firmware
download, and mt7921_mac_reset_work() got as far as logging "chip reset
failed", which it never did otherwise.

The call sits before any teardown, so returning early leaves NAPI and the
TX worker alone. This does not fix why the handshake fails.

Reported-by: moosager <moosager90@gmail.com>
Link: https://lore.kernel.org/linux-wireless/anG46qbvCqCHGF-f@fedora.fritz.box/
Fixes: dfc7743de1eb ("mt76: mt7921: refactor mcu.c to be bus independent")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 0db7acb3a637..c4261f66f469 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -57,7 +57,9 @@ int mt7921e_mac_reset(struct mt792x_dev *dev)
 {
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	err = mt792xe_mcu_drv_pmctrl(dev);
+	if (err)
+		return err;
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.54.0

