Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:63879 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3ELJfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 05:35:43 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so5313714wes.41
        for <linux-wireless@vger.kernel.org>; Sun, 12 May 2013 02:35:42 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] wlcore: cancel channel switch work on interface removal
Date: Sun, 12 May 2013 12:35:29 +0300
Message-Id: <1368351331-6914-2-git-send-email-eliad@wizery.com> (sfid-20130512_113549_508309_D54BE8EA)
In-Reply-To: <1368351331-6914-1-git-send-email-eliad@wizery.com>
References: <1368351331-6914-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Otherwise, if the work is pending, we might get
a bad dereference after the interface is removed.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c384bad..ecbbd38 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2589,6 +2589,7 @@ unlock:
 	cancel_work_sync(&wlvif->rx_streaming_enable_work);
 	cancel_work_sync(&wlvif->rx_streaming_disable_work);
 	cancel_delayed_work_sync(&wlvif->connection_loss_work);
+	cancel_delayed_work_sync(&wlvif->channel_switch_work);
 
 	mutex_lock(&wl->mutex);
 }
-- 
1.8.1.2

