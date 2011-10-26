Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55291 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191Ab1JZOkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 10:40:12 -0400
Received: by wyg36 with SMTP id 36so1735420wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 07:40:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: clear wl->vif on remove_interface
Date: Wed, 26 Oct 2011 16:40:12 +0200
Message-Id: <1319640012-32300-1-git-send-email-eliad@wizery.com> (sfid-20111026_164017_063533_D1B18A25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl->vif should be cleared on remove_interface()
(rather than on stop()) even when only a single
vif is supported, because during vif mode change
stop() might not get called (e.g. because of
monitor interface existence)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dc2ebb2..b9f9ef7 100644
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
@@ -2316,6 +2315,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 		break;
 	}
 	WARN_ON(iter != wlvif);
+	wl->vif = NULL;
 out:
 	mutex_unlock(&wl->mutex);
 	cancel_work_sync(&wl->recovery_work);
-- 
1.7.6.401.g6a319

