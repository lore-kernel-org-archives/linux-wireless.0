Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793666149;
	b=qgbE9TbQRgRRJvONsVbcUdz7tk1WBrhBUkELk+hHSu6Z+5LaVxJ/06Dp+N+LuSr5+gsx
	 E5bBtXq5o2fKhgnovQljbVPYZPz8b9R0RFRLl8XcU5h170B0+NqwiihBBlURuOJUDDb/0
	 FU7IHCVwgnl0aHEkw2cXFmkv2tOvExg86Mt3vcySKxA/KZ4M/XzW4MTtUO//8ahAySmV9
	 5UHGcgpP6GW5PNZaUj4/+z1Tr0TkKEs7Bsy6Tn9sYu3KT/XJL21SDnuqI4HuoG8Jg39U4
	 aNevtqZxlJyzgGi93kAzVW5/Qvns8qXj/gBRhiKuBZElfgqfEZ5Lc/4ELZqdWkXJOeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793666149;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=PWx7yD2PbJfwHT7mGuRmzTwLanSHlLuCjcyfxjQ8Zq8=;
	b=2loHONywj/S1LJ60rHTLkabio2hiyhUt0ozkzzajcAUxA/KnNnw4d+21O41V5DumqlXd
	 qPWuOI/6//RJitlYochrxMJ4bZQFRls13j8cN5qWAreeQ1SnTSC9wbkFUnkiaAKtrcr1o
	 Z49caNix2+rG8fGoEjmlZhNHrH2lrScYYWha0tlFQ+BLPsGxdTuHpJPtmd44jqkV7RvdM
	 ooSBd5o+4uwMbieY4CsU5pFuOklw0Ow/uD2b8VohzCO94SLjEjAf2QpR4hhphu9VxdNQl
	 b/XYld+Fdiv8dyTL1zhghpSFsFR3wRXLhy8FaCp2RHocIFbLU7fArh3G0mMw90i0odg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=david-bauer.net;
	spf=pass smtp.mailfrom=david-bauer.net;
	dkim=pass header.d=david-bauer.net header.i=@david-bauer.net header.a=rsa-sha256 header.s=uberspace header.b=vM7c0oWQ;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB82606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 00:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BB82606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=david-bauer.net header.i=@david-bauer.net header.a=rsa-sha256 header.s=uberspace header.b=vM7c0oWQ
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id A7315610D8
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:35:45 +0100 (CET)
Received: (qmail 3470 invoked by uid 988); 3 Nov 2026 00:35:45 -0000
Authentication-Results: perseus.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by perseus.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 03 Nov 2026 01:35:45 +0100
From: David Bauer <mail@david-bauer.net>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH mt76] wifi: mt76: mt7603: track consecutive failed PSE resets
Date: Tue,  3 Nov 2026 01:35:33 +0100
Message-ID: <20261103003534.176866-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.53.0
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
X-Rspamd-Bar: /
X-Rspamd-Report: SUSPICIOUS_RECIPS(1.5) BAYES_HAM(-3) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -0.1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=david-bauer.net; s=uberspace;
	h=from:to:cc:subject:date;
	bh=35HUvqpd53EuKLwxCx6c9zVK+zSfoB8JoaLgSV2muLQ=;
	b=vM7c0oWQsSVeeVPhrVjietOxfWaQDUpeCk8BMLGixTIlpccX1fSPUGGVSU7y68ByWHrDeQGWhm
	K374Uc8rMn0a425vxRBN5WygGiiC7WDIdtf7X3y0czMsKc83HFlnCbqENzWniHs/Xd03Aq2dhsvm
	dvcWmFUChQplWd2P0pNiKH3d2iRjNKJDmXEnZCtZ9r2kTaNQfHIz6Lc+qGueQnLbKBXnQP4KVVix
	f9mqpieIHm3nUFgY/0CQDWrc4CwXvf5I7AnygKBACik7JVF9nhMwgHKxwbHuBvLVXGgi/B9swv7d
	PtyMLVy5fvx7iEMb9O1IPfgYmaErymvKu5VR+Rejx0kWxUZMhkyEdtaMfTKsLMALLA4sRoM4gvwB
	X3U5E9MmzcsgZHz27Sgc+KZ4VfjsOe02MzQmMi03uI/yciqB1aVUHWObj9jxlcNq1te0UNCgZYv9
	kj8Ab/G2gw+cdpi8zwPnpsEYAzBYjw5Sf5PCR1gNZKcakxJ5ZHn62xm8hnl+GdnGCCLcw+F580Ue
	MM39KcP1BElYyzARu88BQvq6CPdQG14P8VZsnjJYBo/KgTDIzMd23XeTpglIaWRZ5BBYTn4HqKGP
	RLV1tRZPLADsnnTtxsgjqem0L1+eRz7bfTbOmqj++D90JUD8vrMOn1aCibepeHTAfVeEN3kYFN7D
	Q=

The current PSE recovery process uses the global reset cause counter to
clear the MT_MCU_DEBUG_RESET_PSE_S only every 3rd attempt. The counter
then wraps around.

This does not allow to track the total number of failed PSE reset
attempts. Introduce a new separate counter for consecutive failed resets
and clear the bit based on the value of that counter.

Keep RESET_FAILED reset cause as a cumulative statistic.

Also add a short comment about how the reset procedure handles the
failed case in terms of the retry limit.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 21 ++++++++++++-------
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index fa0bf9a201ce2..549b0d3358f68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1342,7 +1342,7 @@ wait_for_wpdma(struct mt7603_dev *dev)
 static void mt7603_pse_reset(struct mt7603_dev *dev)
 {
 	/* Clear previous reset result */
-	if (!dev->reset_cause[RESET_CAUSE_RESET_FAILED])
+	if (!dev->failed_pse_reset_attempts)
 		mt76_clear(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_PSE_S);
 
 	/* Reset PSE */
@@ -1351,15 +1351,22 @@ static void mt7603_pse_reset(struct mt7603_dev *dev)
 	if (!mt76_poll_msec(dev, MT_MCU_DEBUG_RESET,
 			    MT_MCU_DEBUG_RESET_PSE_S,
 			    MT_MCU_DEBUG_RESET_PSE_S, 500)) {
+		dev->failed_pse_reset_attempts++;
 		dev->reset_cause[RESET_CAUSE_RESET_FAILED]++;
 		mt76_clear(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_PSE);
 	} else {
-		dev->reset_cause[RESET_CAUSE_RESET_FAILED] = 0;
+		dev->failed_pse_reset_attempts = 0;
 		mt76_clear(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_QUEUES);
 	}
 
-	if (dev->reset_cause[RESET_CAUSE_RESET_FAILED] >= 3)
-		dev->reset_cause[RESET_CAUSE_RESET_FAILED] = 0;
+	/* Limit the number of consecutive failed PSE reset attempts.
+	 *
+	 * After 3 consecutive failed attempts, the reset limit is
+	 * reached, the counter is reset and the device will
+	 * return to normal operation.
+	 */
+	if (dev->failed_pse_reset_attempts >= 3)
+		dev->failed_pse_reset_attempts = 0;
 }
 
 void mt7603_mac_dma_start(struct mt7603_dev *dev)
@@ -1481,11 +1488,11 @@ static void mt7603_mac_watchdog_reset(struct mt7603_dev *dev)
 		mt76_queue_rx_reset(dev, i);
 	}
 
-	if (dev->reset_cause[RESET_CAUSE_RESET_FAILED] ||
+	if (dev->failed_pse_reset_attempts ||
 	    dev->cur_reset_cause == RESET_CAUSE_RX_PSE_BUSY)
 		mt7603_pse_reset(dev);
 
-	if (!dev->reset_cause[RESET_CAUSE_RESET_FAILED]) {
+	if (!dev->failed_pse_reset_attempts) {
 		mt7603_mac_dma_start(dev);
 
 		mt7603_irq_enable(dev, mask);
@@ -1920,7 +1927,7 @@ void mt7603_mac_work(struct work_struct *work)
 	    mt7603_watchdog_check(dev, &dev->mcu_hang,
 				  RESET_CAUSE_MCU_HANG,
 				  NULL) ||
-	    dev->reset_cause[RESET_CAUSE_RESET_FAILED]) {
+	    dev->failed_pse_reset_attempts) {
 		dev->beacon_check = 0;
 		dev->tx_dma_check = 0;
 		dev->tx_hang_check = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 5b0ecd01aad95..47f5be44292d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -155,6 +155,7 @@ struct mt7603_dev {
 
 	u32 reset_test;
 
+	u8 failed_pse_reset_attempts;
 	unsigned int reset_cause[__RESET_CAUSE_MAX];
 };
 
-- 
2.53.0

