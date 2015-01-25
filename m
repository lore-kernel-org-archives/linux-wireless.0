Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31610 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbbAYIxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 03:53:30 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 04/10] wil6210: Add Tx queue len configuration
Date: Sun, 25 Jan 2015 10:52:45 +0200
Message-Id: <1422175971-8075-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150125_095339_308620_AD55F64B)
In-Reply-To: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422175971-8075-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>

Tx queue was hard-coded to 1000 in ether_setup. Add wil_dev_setup
function which configures tx queue len to chosen default value
after calling ether_setup.

Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c  | 11 ++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index f1f9e51..ace30c1 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -15,7 +15,6 @@
  */
 
 #include <linux/etherdevice.h>
-
 #include "wil6210.h"
 #include "txrx.h"
 
@@ -122,6 +121,12 @@ static int wil6210_netdev_poll_tx(struct napi_struct *napi, int budget)
 	return min(tx_done, budget);
 }
 
+static void wil_dev_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	dev->tx_queue_len = WIL_TX_Q_LEN_DEFAULT;
+}
+
 void *wil_if_alloc(struct device *dev, void __iomem *csr)
 {
 	struct net_device *ndev;
@@ -153,7 +158,7 @@ void *wil_if_alloc(struct device *dev, void __iomem *csr)
 	ch = wdev->wiphy->bands[IEEE80211_BAND_60GHZ]->channels;
 	cfg80211_chandef_create(&wdev->preset_chandef, ch, NL80211_CHAN_NO_HT);
 
-	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, ether_setup);
+	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
 	if (!ndev) {
 		dev_err(dev, "alloc_netdev_mqs failed\n");
 		rc = -ENOMEM;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b4404e7..fc196bf 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -44,6 +44,7 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 
 #define WIL6210_MEM_SIZE (2*1024*1024UL)
 
+#define WIL_TX_Q_LEN_DEFAULT		(4000)
 #define WIL_RX_RING_SIZE_ORDER_DEFAULT	(9)
 #define WIL_TX_RING_SIZE_ORDER_DEFAULT	(9)
 /* limit ring size in range [32..32k] */
-- 
2.1.0

