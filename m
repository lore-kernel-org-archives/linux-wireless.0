Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:56431 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab2FWGmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:14 -0400
Received: by lbbgk8 with SMTP id gk8so4885110lbb.12
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:11 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 13/18] wlcore: cancel suspend when recovery is pending
Date: Sat, 23 Jun 2012 09:41:24 +0300
Message-Id: <1340433689-24320-14-git-send-email-coelho@ti.com> (sfid-20120623_085130_557270_F29CC22D)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

We wish to postpone suspend if recovery is pending. This will make sure
the FW is in a good state and perform wowlan wakeup.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b0795aa..0df28d5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1661,6 +1661,12 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
 	WARN_ON(!wow);
 
+	/* we want to perform the recovery before suspending */
+	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
+		wl1271_warning("postponing suspend to perform recovery");
+		return -EBUSY;
+	}
+
 	wl1271_tx_flush(wl);
 
 	mutex_lock(&wl->mutex);
-- 
1.7.10

