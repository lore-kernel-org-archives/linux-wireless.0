Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.200.11]:40655 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965872AbeF1NI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 09:08:29 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 1D369400C5CC5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2018 07:08:53 -0500 (CDT)
Date: Thu, 28 Jun 2018 08:08:09 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wlcore: Fix memory leak in
 wlcore_cmd_wait_for_event_or_timeout
Message-ID: <20180628130809.GA8147@embeddedor.com> (sfid-20180628_150847_516755_31837D7B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case memory resources for *events_vector* were allocated, release
them before return.

Addresses-Coverity-ID: 1470194 ("Resource leak")
Fixes: 4ec7cece87b3 ("wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 836c616..9039687 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -195,8 +195,7 @@ int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 	ret = pm_runtime_get_sync(wl->dev);
 	if (ret < 0) {
 		pm_runtime_put_noidle(wl->dev);
-
-		return ret;
+		goto free_vector;
 	}
 
 	do {
@@ -232,6 +231,7 @@ int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 out:
 	pm_runtime_mark_last_busy(wl->dev);
 	pm_runtime_put_autosuspend(wl->dev);
+free_vector:
 	kfree(events_vector);
 	return ret;
 }
-- 
2.7.4
