Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42148 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1DDHhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 03:37:48 -0400
Received: by wwa36 with SMTP id 36so6132181wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 00:37:47 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: sleep instead of wakeup after tx work
Date: Mon,  4 Apr 2011 10:38:47 +0300
Message-Id: <1301902727-25511-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit d05c806 ("wl12xx: rearrange some ELP wake_up/sleep calls")
introduced a bug in which wl1271_ps_elp_wakeup() was called instead
of wl1271_ps_elp_sleep() after completing the tx work.

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 7a3339f..c836659 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -630,7 +630,7 @@ void wl1271_tx_work(struct work_struct *work)
 
 	wl1271_tx_work_locked(wl);
 
-	wl1271_ps_elp_wakeup(wl);
+	wl1271_ps_elp_sleep(wl);
 out:
 	mutex_unlock(&wl->mutex);
 }
-- 
1.7.0.4

