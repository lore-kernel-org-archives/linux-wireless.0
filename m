Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1DRLQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:16:04 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3798215wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:16:03 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/10] wl12xx: print firmware program counter during recovery
Date: Mon, 18 Apr 2011 14:15:24 +0300
Message-Id: <1303125329-27214-5-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When performing recovery, print the firmware version and program
counter (by reading the SCR_PAD4 register). The value of the firmware
program counter during assert can be useful for debugging.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a2a26df..e0c8ca4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -985,7 +985,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	if (wl->state != WL1271_STATE_ON)
 		goto out;
 
-	wl1271_info("Hardware recovery in progress.");
+	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
+		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
 
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		ieee80211_connection_loss(wl->vif);
-- 
1.7.1

