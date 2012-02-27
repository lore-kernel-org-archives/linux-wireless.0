Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42648 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2B0Wlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:51 -0500
Received: by wejx9 with SMTP id x9so607342wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:49 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 5/7] wl12xx: flush all Tx queues on tx_flush timeout
Date: Tue, 28 Feb 2012 00:41:32 +0200
Message-Id: <1330382494-31148-5-git-send-email-arik@wizery.com> (sfid-20120227_234155_275637_7A94392A)
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure our queues are empty at the end of a tx_flush(), in case we
timeout on passively waiting for them. This makes sure no left-overs are
transmitted when we are on the wrong channel.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 76480a0..3540d4a 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -1040,6 +1040,7 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 void wl1271_tx_flush(struct wl1271 *wl)
 {
 	unsigned long timeout;
+	int i;
 	timeout = jiffies + usecs_to_jiffies(WL1271_TX_FLUSH_TIMEOUT);
 
 	while (!time_after(jiffies, timeout)) {
@@ -1057,6 +1058,12 @@ void wl1271_tx_flush(struct wl1271 *wl)
 	}
 
 	wl1271_warning("Unable to flush all TX buffers, timed out.");
+
+	/* forcibly flush all Tx buffers on our queues */
+	mutex_lock(&wl->mutex);
+	for (i = 0; i < WL12XX_MAX_LINKS; i++)
+		wl1271_tx_reset_link_queues(wl, i);
+	mutex_unlock(&wl->mutex);
 }
 
 u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
-- 
1.7.5.4

