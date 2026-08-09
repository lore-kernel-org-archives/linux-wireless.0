Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF5330F7FF
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 20:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786308986; cv=none; b=GU/Yken77g4Y2uQ+ZjIs4anXBtVSlrSB9TJRzjKIq9xm2kGYfarTtjUqr9L0OJNis6BCJSjRpDsdqqOmqGsqQljquPIyLh56oz9yd1venwtN8eFasoiu3FRAV5EIowWh3ap53yQqoAlH7OhFEoTtqDkxwI3q1OXE3PqrhJZGx2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786308986; c=relaxed/simple;
	bh=JaSYxMGtvXNbST8MI+CGQgGTHdnkGSQnSfk7ryQoS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qr1XxGmCOeesTYrYrGIM/O8H+JTrIC2CdgaVoNnmYygFDQol2dyCFagCzy4tvzmZjNLLcJtT85VXmKyetU6u7vx20j0//IcNe8KHU/wMxdj57Wz8DuCVlVHupu4IAab6rJRut5ceYShO1j6+yNsP7CS1d+11udDhWYCRVLdaCN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=pza10K9F; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="pza10K9F"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1786308981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7ifGUktyTBRpD2vqspRbC+RDO6MA0r+jWv/wAEOzB8s=;
	b=pza10K9FqR59KucqwDxUWfOX7soPRO16abnN9R+Iob+HMko/P8pZrpJyf3EQVB7KruBdQX
	ovvhAlzmuEnJ73AZUgihsdf5RPT+kcMAJKlhZZuiGFpjUux/XP5BCUXUzePZQRyZfWb7Js
	YaWkucVRoo5BhGz3ilIaYBYQFuxtVdv0HAvoDHCUFiQyA/Ae0OXbYr4bBbq37DJi/OWqdQ
	QdpoGBCFHb/cSKVzZK+BA7OC5UZDQMKsNGYRjt6FmazfXI0vk4id6hpU/2m9FnLNI6aFvu
	RmPcxh4B/4K5ilpUUtXtG27GSKf+a5vkeyJmKDrD1OjJaTaqukus0YR3XwLpjQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>
Subject: [PATCH wireless] wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
Date: Sun,  9 Aug 2026 13:55:59 -0700
Message-ID: <20260809205559.32116-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mt7925e_mac_reset() ignores what mt792xe_mcu_drv_pmctrl() returns. It
checks both pmctrl calls it makes later in the same function, and probe,
suspend and resume check theirs. mt7925e_unregister_device() also discards
it, but there the device is going away and teardown has to continue
regardless.

When the driver-own handshake does not complete, __mt792xe_mcu_drv_pmctrl()
gives up after MT792x_DRV_OWN_RETRY_COUNT and returns -EIO without
reinitialising WPDMA or clearing MT76_STATE_PM. The reset continues anyway,
writing interrupt enable registers, cycling NAPI, resetting WPDMA and
calling mt7925_run_firmware() on a chip the driver does not own.

On an MT7925 with MT_CONN_ON_LPCTL held asserted, a triggered reset failed
the handshake 4 times. Each failure was followed within 85 ms by both
firmware stages loading:

  mt7925e 0000:0a:00.0: driver own failed
  mt7925e 0000:0a:00.0: HW/SW Version: 0x8a108a10, Build Time: [...]
  mt7925e 0000:0a:00.0: WM Firmware Version: ____000000, Build Time: [...]

With the return checked, 8 handshake failures were followed by no firmware
load. The one load in that run came after a handshake that succeeded.

Return the error instead. The call is the first statement in the function,
before MT76_RESET is set and before the TX worker and NAPI are disabled, so
bailing out there leaves them untouched. This does not fix why the
handshake fails.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 97683949a305..2ce9ad0350ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -73,7 +73,9 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 	const struct mt792x_irq_map *irq_map = dev->irq_map;
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	err = mt792xe_mcu_drv_pmctrl(dev);
+	if (err)
+		return err;
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.55.0

