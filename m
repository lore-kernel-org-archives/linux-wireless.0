Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42121 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1KANMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 09:12:51 -0400
Received: by wyh15 with SMTP id 15so387918wyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 06:12:50 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl12xx: clear wl->vif on remove_interface
Date: Tue,  1 Nov 2011 15:12:50 +0200
Message-Id: <1320153170-5301-1-git-send-email-eliad@wizery.com> (sfid-20111101_141303_124404_D14D42FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl->vif should be cleared on remove_interface()
(rather than on stop()) even when only a single
vif is supported, because during vif mode change
stop() might not get called (e.g. because of
monitor interface existence)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: clear wl->vif in __wl1271_op_remove_interface, so it will
    happen also on recovery

 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f76be5a..42489bf 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1859,7 +1859,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->time_offset = 0;
-	wl->vif = NULL;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
@@ -2211,6 +2210,8 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	if (!test_and_clear_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
 		return;
 
+	wl->vif = NULL;
+
 	/* because of hardware recovery, we may get here twice */
 	if (wl->state != WL1271_STATE_ON)
 		return;
-- 
1.7.6.401.g6a319

