Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2EOOJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:16 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so2512825wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:15 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/10] wlcore: flush before stopping AP
Date: Tue, 15 May 2012 17:08:56 +0300
Message-Id: <1337090940-13750-6-git-send-email-arik@wizery.com> (sfid-20120515_160925_293095_F43B233D)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Make sure the deauth bcast gets sent

[Make sure we are AP as well before the flush - Arik]

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 35f6bc1..92478cb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3964,6 +3964,10 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (!is_ap && (changed & BSS_CHANGED_ASSOC))
 		cancel_delayed_work_sync(&wl->connection_loss_work);
 
+	if (is_ap && (changed & BSS_CHANGED_BEACON_ENABLED) &&
+	    !bss_conf->enable_beacon)
+		wl1271_tx_flush(wl);
+
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
-- 
1.7.9.5

