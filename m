Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbeHXOt5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:49:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/17] mt76: add helpers for register access with mt76_dev struct
Date: Fri, 24 Aug 2018 13:15:11 +0200
Message-Id: <1535109321-17126-8-git-send-email-sgruszka@redhat.com> (sfid-20180824_131552_417986_F9D4E5A5)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add helpers for register access from common code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 79017dbd364d..10959c4669bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -404,6 +404,11 @@ struct mt76_rx_status {
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 };
 
+#define __mt76_rr(dev, ...)	(dev)->bus->rr((dev), __VA_ARGS__)
+#define __mt76_wr(dev, ...)	(dev)->bus->wr((dev), __VA_ARGS__)
+#define __mt76_rmw(dev, ...)	(dev)->bus->rmw((dev), __VA_ARGS__)
+#define __mt76_wr_copy(dev, ...)	(dev)->bus->copy((dev), __VA_ARGS__)
+
 #define mt76_rr(dev, ...)	(dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_wr(dev, ...)	(dev)->mt76.bus->wr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_rmw(dev, ...)	(dev)->mt76.bus->rmw(&((dev)->mt76), __VA_ARGS__)
-- 
1.9.3
