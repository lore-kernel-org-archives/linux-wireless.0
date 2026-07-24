Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6802931D5
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897299; cv=none; b=spOeweSnnqMuYmZpNsraPFrZVVMk2ZANFTW7N52ftyB9oWr4IRCYxbcON5WXrZR5otpABKxCOBbbNBJaYR5kSvwUBvv90WXZDtGqbPNZzeO2qyjaPja7MSEiz1kcBV088vNIpZ29IgaxVxN0GuDU92UyZBmQdPp1H5J8FJXsHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897299; c=relaxed/simple;
	bh=n9tikEbfQZQVkl1RNrnCn9sexWVcUMIbz2RLQx1GK6E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/1Tu6x4p3xIVamHvqTL+QOUz4Nowx598ftdDsVxZiVFJp5mMExg16EIaWbtTbX2/Sxlp0RInF0EKxbAPHVxRbPNL78qUG+d/S+bo5X0xKLnc1jS1wWFD2Jof5GwqR3lL1SMv75weUKuQ5H7eRJ0EBfKfqeTeroAZ8PQixWs/bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EeI17a05; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EeI17a05"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2dP1sTLlbVlhMQMnstnFwYPzWj953ZDpFRjvJkTkKFU=; b=EeI17a05w40Ros0DlV8AiPELAL
	OOLqwEgIxk/wlFTDJKTPDR70ApPbwyr7k38Qieuh1cXwD0rVE8EIi0WUi2lv72wNRFhGnQqKZWLuE
	QRXNVocUkC0XOsSeSVEebzXkRO+ydoiUTIkvXQV3vDd6mTago/8WIOidYO3OmrTnpB7Y=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK4-006LeO-1C
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 05/29] wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER
Date: Fri, 24 Jul 2026 12:47:49 +0000
Message-ID: <20260724124813.3961474-5-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_reset_work() parked the tx worker and disabled the RX/TX NAPIs
before taking dev->mt76.mutex. mt76_worker_disable()/_enable() are plain
kthread park/unpark, not refcounted, and __mt76_set_channel() toggles the
same worker and the MT76_RESET bit under the mutex. An L1 SER racing a
channel switch could therefore have the worker unparked and MT76_RESET
cleared while the reset path resets the DMA rings, corrupting descriptors
or tokens. Take the mutex before disabling the worker, as mt7915 does.

Fixes: 27015b6fbcca ("wifi: mt76: mt7996: enable full system reset support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index c204327eaa37..e0a1076ac706 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2573,6 +2573,8 @@ void mt7996_mac_reset_work(struct work_struct *work)
 		cancel_delayed_work_sync(&phy->mt76->mac_work);
 	}
 
+	mutex_lock(&dev->mt76.mutex);
+
 	mt76_worker_disable(&dev->mt76.tx_worker);
 	mt76_for_each_q_rx(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
@@ -2590,8 +2592,6 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	}
 	napi_disable(&dev->mt76.tx_napi);
 
-	mutex_lock(&dev->mt76.mutex);
-
 	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
 
 	if (mt7996_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-- 
2.53.0

