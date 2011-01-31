Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14651 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1AaSSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:18:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:18:14 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/5] ath9k_htc: cancel ani work in ath9k_htc_stop
Date: Mon, 31 Jan 2011 23:47:42 +0530
Message-ID: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ani work is cancelled in dissaoctiation. But in some cases
during suspend, deauthention never be called. So we failed
to stop ani work which was identified by the following
warning.

Call Trace:
 [<ffffffffa0454a1d>] ieee80211_can_queue_work.clone.17+0x2d/0x40 [mac80211]
 [<ffffffffa0454a60>] ieee80211_queue_delayed_work+0x30/0x60 [mac80211]
 [<ffffffffa0567f82>] ath9k_ani_work+0x142/0x250 [ath9k_htc]
 [<ffffffff81073c70>] async_run_entry_fn+0x0/0x180
 [<ffffffffa0567e40>] ath9k_ani_work+0x0/0x250 [ath9k_htc]

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a702089..0526c25 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1052,6 +1052,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&priv->fatal_work);
 	cancel_work_sync(&priv->ps_work);
 	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
+	cancel_delayed_work_sync(&priv->ath9k_ani_work);
 	ath9k_led_stop_brightness(priv);
 
 	mutex_lock(&priv->mutex);
-- 
1.7.3.5

