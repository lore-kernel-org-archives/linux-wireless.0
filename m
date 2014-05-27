Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15539 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE0Lqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:35 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 3/7] wil6210: inline functions for vring hi/lo watermarks
Date: Tue, 27 May 2014 14:45:46 +0300
Message-ID: <1401191150-29037-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134639_574463_E41E306D)
In-Reply-To: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide clear definition of the watermarks for the vring descriptor space.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index c8c5474..82140e0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -64,6 +64,22 @@ static inline int wil_vring_avail_tx(struct vring *vring)
 	return vring->size - used - 1;
 }
 
+/**
+ * wil_vring_wmark_low - low watermark for available descriptor space
+ */
+static inline int wil_vring_wmark_low(struct vring *vring)
+{
+	return vring->size/8;
+}
+
+/**
+ * wil_vring_wmark_high - high watermark for available descriptor space
+ */
+static inline int wil_vring_wmark_high(struct vring *vring)
+{
+	return vring->size/4;
+}
+
 static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 {
 	struct device *dev = wil_to_dev(wil);
@@ -1007,7 +1023,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	rc = wil_tx_vring(wil, vring, skb);
 
 	/* do we still have enough room in the vring? */
-	if (wil_vring_avail_tx(vring) < vring->size/8)
+	if (wil_vring_avail_tx(vring) < wil_vring_wmark_low(vring))
 		netif_tx_stop_all_queues(wil_to_ndev(wil));
 
 	switch (rc) {
@@ -1116,7 +1132,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			done++;
 		}
 	}
-	if (wil_vring_avail_tx(vring) > vring->size/4)
+	if (wil_vring_avail_tx(vring) > wil_vring_wmark_high(vring))
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
 
 	return done;
-- 
1.9.1

