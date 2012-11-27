Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab2K0Gp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:27 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:26 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Victor Goldenshtein <victorg@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/20] wlcore: remove unnecessary WARN_ON in wl12xx_tx_reset
Date: Tue, 27 Nov 2012 08:44:52 +0200
Message-Id: <1353998701-18171-12-git-send-email-arik@wizery.com> (sfid-20121127_074534_868460_5833A22D)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Sometimes the driver can perform a recovery while Tx is
active, this will trigger unnecessary warning which might
delay the recovery for more than 100 mS.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 68f73f9..404a516 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1023,7 +1023,7 @@ void wl12xx_tx_reset(struct wl1271 *wl)
 	struct ieee80211_tx_info *info;
 
 	/* only reset the queues if something bad happened */
-	if (WARN_ON_ONCE(wl1271_tx_total_queue_count(wl) != 0)) {
+	if (wl1271_tx_total_queue_count(wl) != 0) {
 		for (i = 0; i < WL12XX_MAX_LINKS; i++)
 			wl1271_tx_reset_link_queues(wl, i);
 
-- 
1.7.9.5

