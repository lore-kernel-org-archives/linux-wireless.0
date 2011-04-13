Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1DMFxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:53:41 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so275754iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:53:41 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15094.301154.926384@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:06 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 31/40] ath9k_htc: Optimize HTC start/stop API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

There is no point in looping over all the endpoints,
since the HIF layer uses the start/stop APIs only
for the TX pipe. Simplify the API accordingly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
 drivers/net/wireless/ath/ath9k/htc_hst.c |   19 ++-----------------
 drivers/net/wireless/ath/ath9k/htc_hst.h |    4 ++--
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index a98b146..4a12c75 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -310,7 +310,7 @@ static int hif_usb_send_tx(struct hif_device_usb *hif_dev, struct sk_buff *skb)
 	return 0;
 }
 
-static void hif_usb_start(void *hif_handle, u8 pipe_id)
+static void hif_usb_start(void *hif_handle)
 {
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
 	unsigned long flags;
@@ -322,7 +322,7 @@ static void hif_usb_start(void *hif_handle, u8 pipe_id)
 	spin_unlock_irqrestore(&hif_dev->tx.tx_lock, flags);
 }
 
-static void hif_usb_stop(void *hif_handle, u8 pipe_id)
+static void hif_usb_stop(void *hif_handle)
 {
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
 	struct tx_buf *tx_buf = NULL, *tx_buf_tmp = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index aecc7f2..be3385e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -302,27 +302,12 @@ int htc_send_epid(struct htc_target *target, struct sk_buff *skb,
 
 void htc_stop(struct htc_target *target)
 {
-	enum htc_endpoint_id epid;
-	struct htc_endpoint *endpoint;
-
-	for (epid = ENDPOINT0; epid < ENDPOINT_MAX; epid++) {
-		endpoint = &target->endpoint[epid];
-		if (endpoint->service_id != 0)
-			target->hif->stop(target->hif_dev, endpoint->ul_pipeid);
-	}
+	target->hif->stop(target->hif_dev);
 }
 
 void htc_start(struct htc_target *target)
 {
-	enum htc_endpoint_id epid;
-	struct htc_endpoint *endpoint;
-
-	for (epid = ENDPOINT0; epid < ENDPOINT_MAX; epid++) {
-		endpoint = &target->endpoint[epid];
-		if (endpoint->service_id != 0)
-			target->hif->start(target->hif_dev,
-					   endpoint->ul_pipeid);
-	}
+	target->hif->start(target->hif_dev);
 }
 
 void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 064a324..191e3c0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -33,8 +33,8 @@ struct ath9k_htc_hif {
 	u8 control_dl_pipe;
 	u8 control_ul_pipe;
 
-	void (*start) (void *hif_handle, u8 pipe);
-	void (*stop) (void *hif_handle, u8 pipe);
+	void (*start) (void *hif_handle);
+	void (*stop) (void *hif_handle);
 	int (*send) (void *hif_handle, u8 pipe, struct sk_buff *buf);
 };
 
-- 
1.7.4.4

