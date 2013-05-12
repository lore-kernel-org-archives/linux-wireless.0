Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37637 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3ELJfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 05:35:46 -0400
Received: by mail-wg0-f44.google.com with SMTP id z12so5394911wgg.35
        for <linux-wireless@vger.kernel.org>; Sun, 12 May 2013 02:35:45 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] wlcore: fix occasional AP TX stop after recovery
Date: Sun, 12 May 2013 12:35:31 +0300
Message-Id: <1368351331-6914-4-git-send-email-eliad@wizery.com> (sfid-20130512_113552_468139_8719560C)
In-Reply-To: <1368351331-6914-1-git-send-email-eliad@wizery.com>
References: <1368351331-6914-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

The fw_status wasn't zeroed during allocation, resulting
in uninitialized var usage, and finally causing AP
traffic stop after recovery.

The wrong value in fw_status_2->counters.tx_lnk_free_pkts
led to a bad lnk->allocated_pkts calculation in
wlcore_fw_status(), causing wl18xx_lnk_low_prio() to return
FALSE (lnk->allocated_pkts > thold).
This eventually blocked the link in wlcore_tx_work_locked(),
as wl1271_skb_dequeue() continuously returned NULL.

Fix it by zeroing wl->fw_status_1/2 during allocation.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ecbbd38..2537391 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -970,7 +970,7 @@ static int wlcore_fw_wakeup(struct wl1271 *wl)
 
 static int wl1271_setup(struct wl1271 *wl)
 {
-	wl->fw_status_1 = kmalloc(WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
+	wl->fw_status_1 = kzalloc(WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
 				  sizeof(*wl->fw_status_2) +
 				  wl->fw_status_priv_len, GFP_KERNEL);
 	if (!wl->fw_status_1)
@@ -980,7 +980,7 @@ static int wl1271_setup(struct wl1271 *wl)
 				(((u8 *) wl->fw_status_1) +
 				WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc));
 
-	wl->tx_res_if = kmalloc(sizeof(*wl->tx_res_if), GFP_KERNEL);
+	wl->tx_res_if = kzalloc(sizeof(*wl->tx_res_if), GFP_KERNEL);
 	if (!wl->tx_res_if) {
 		kfree(wl->fw_status_1);
 		return -ENOMEM;
-- 
1.8.1.2

