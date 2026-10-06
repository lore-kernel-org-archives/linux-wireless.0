Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A874A43FA
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=Wu5JJ1YQ2QNwJIbMFxS93EPnqrJkF4+fVYfO23V72tTcZpt8teNM95EU1TWSCIa4qlSIzDfflP9K6Zmr4+Y8g6sl1e0LpFtxM3tNQL/8+2Gjs7fSiG5+Zmmv4f/x1oHc5fdogrUi9jmqCKGS/MZ1LhoL/TPDLKoV0QK/Xs4PEyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=KtM8bHdwu1MP+R5A5F6XxyVooXicA+QjByWep2qE2/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7m5QmYc7MOvKB+Meqwsre6+BmqUYiTaA+LeNczojCXdd8d04+8SNXIdek9blti86L/I4TB9mB80rwZxyxvbQOOArTb1YxcULC4wHMqwSKMskN469nvQlFrOzNug2GXyzzTfhePajzVsMtJK8jJSnLbHXASDB0fpg6WEcfXeFck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=JD6bOI9y; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="JD6bOI9y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=odyAf/8YTtisl4OC9TFp4TrXuliPEARq9DN55VxrfEc=; b=JD6bOI9yNNN7N8Huoj1lyzCRmu
	4PDWRKNfyvxH9ikuWSL6+dJQaHa+/t0gz6vamEZQg0sANe8fnBS2omknRhlPIOtxcJrAStf+VO10e
	kVcMeMpd5G0MOw2GBCBaizc6UQVCUAkDFDt8gtQAogjf4YHkRxAD6UUNsDwP0FBqvor0=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGG-00HAg3-05;
	Tue, 06 Oct 2026 22:59:44 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: John Crispin <john@phrozen.org>
Subject: [PATCH mt76-next 27/27] wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup
Date: Tue,  6 Oct 2026 22:59:36 +0200
Message-ID: <20261006205936.669125-27-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Crispin <john@phrozen.org>

mt7996_unregister_device() leaves the RX NAPIs enabled, so
mt76_dma_cleanup() deletes enabled NAPIs and destroys page pools that
are still bound to them. On rmmod, the kernel warns in
__netif_napi_del_locked() for every RX queue and in
page_pool_disable_direct_recycling(). Until the IRQ tasklet is disabled,
an interrupt can still schedule a NAPI that was already deleted.

Disable every RX NAPI that was added before the MCU exit and the DMA
cleanup. This includes the host RRO queues: mt76_dma_init() skips them,
but mt7996_dma_rro_start() adds their NAPIs later when WED is not
active, so a check for mt76_queue_is_wed_rro() would miss them.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 2db63c3be9d1..ad9919c516e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1810,6 +1810,8 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	int i;
+
 	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
 	cancel_work_sync(&dev->reset_work);
@@ -1820,6 +1822,10 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
 	mt7996_coredump_unregister(dev);
 	mt76_unregister_device(&dev->mt76);
 	mt7996_wed_rro_free(dev);
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++) {
+		if (dev->mt76.napi[i].dev)
+			napi_disable(&dev->mt76.napi[i]);
+	}
 	mt7996_mcu_exit(dev);
 	mt7996_tx_token_put(dev);
 	mt7996_dma_cleanup(dev);
-- 
2.47.3

