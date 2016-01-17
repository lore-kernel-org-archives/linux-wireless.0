Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcAQKjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 05:39:52 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 4/5] wil6210: find TX vring only if vring_tx_data is enabled
Date: Sun, 17 Jan 2016 12:39:09 +0200
Message-Id: <1453027150-18224-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160117_114021_029726_95046013)
In-Reply-To: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In TX vring allocation, vring_tx->va is allocated before WMI command to
configure the vring is sent to the device. As the WMI command can take
time to complete, it can lead to scenarios where vring_tx->va is not NULL
but vring is still not enabled.

This patch adds a check that vring_tx_data is enabled before returning
a valid TX vring.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 7887e6c..c22ee8b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -911,10 +911,11 @@ static struct vring *wil_find_tx_ucast(struct wil6210_priv *wil,
 			continue;
 		if (wil->vring2cid_tid[i][0] == cid) {
 			struct vring *v = &wil->vring_tx[i];
+			struct vring_tx_data *txdata = &wil->vring_tx_data[i];
 
 			wil_dbg_txrx(wil, "%s(%pM) -> [%d]\n",
 				     __func__, eth->h_dest, i);
-			if (v->va) {
+			if (v->va && txdata->enabled) {
 				return v;
 			} else {
 				wil_dbg_txrx(wil, "vring[%d] not valid\n", i);
@@ -935,6 +936,7 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 	struct vring *v;
 	int i;
 	u8 cid;
+	struct vring_tx_data *txdata;
 
 	/* In the STA mode, it is expected to have only 1 VRING
 	 * for the AP we connected to.
@@ -942,7 +944,8 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 	 */
 	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		v = &wil->vring_tx[i];
-		if (!v->va)
+		txdata = &wil->vring_tx_data[i];
+		if (!v->va || !txdata->enabled)
 			continue;
 
 		cid = wil->vring2cid_tid[i][0];
@@ -978,12 +981,14 @@ static struct vring *wil_find_tx_bcast_1(struct wil6210_priv *wil,
 					 struct sk_buff *skb)
 {
 	struct vring *v;
+	struct vring_tx_data *txdata;
 	int i = wil->bcast_vring;
 
 	if (i < 0)
 		return NULL;
 	v = &wil->vring_tx[i];
-	if (!v->va)
+	txdata = &wil->vring_tx_data[i];
+	if (!v->va || !txdata->enabled)
 		return NULL;
 	if (!wil->vring_tx_data[i].dot1x_open &&
 	    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
@@ -1010,11 +1015,13 @@ static struct vring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 	u8 cid;
 	struct ethhdr *eth = (void *)skb->data;
 	char *src = eth->h_source;
+	struct vring_tx_data *txdata;
 
 	/* find 1-st vring eligible for data */
 	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		v = &wil->vring_tx[i];
-		if (!v->va)
+		txdata = &wil->vring_tx_data[i];
+		if (!v->va || !txdata->enabled)
 			continue;
 
 		cid = wil->vring2cid_tid[i][0];
-- 
1.8.5.2

