Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44475 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcAQKjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 05:39:51 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 3/5] wil6210: handle tx completions only if vring tx data is enabled
Date: Sun, 17 Jan 2016 12:39:08 +0200
Message-Id: <1453027150-18224-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160117_114022_206537_81CC11C5)
In-Reply-To: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1453027150-18224-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil_vring_fini_tx is called in disconnect in order to free the
allocated vrings.
wil_vring_fini_tx is disabling the vring_tx_data before napi_synchronize
is called in order to avoid the tx handling of this vring, while
wil_vring_free is called only after napi finished the current handling
of the tx completed packets.
Due to that, in case of disconnect, wil6210_netdev_poll_tx can be called
when vring->va is not NULL but vring_tx_data[i]->enabled is already
disabled.

This patch checks vring_tx_data[i]->enabled in wil6210_netdev_poll_tx
to prevent handling of disabled vrings.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/netdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 56aaa2d..ecc3c1b 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -108,8 +108,9 @@ static int wil6210_netdev_poll_tx(struct napi_struct *napi, int budget)
 	/* always process ALL Tx complete, regardless budget - it is fast */
 	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
 		struct vring *vring = &wil->vring_tx[i];
+		struct vring_tx_data *txdata = &wil->vring_tx_data[i];
 
-		if (!vring->va)
+		if (!vring->va || !txdata->enabled)
 			continue;
 
 		tx_done += wil_tx_complete(wil, i);
-- 
1.8.5.2

