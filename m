Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:55693 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbdJ2UQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 16:16:16 -0400
Subject: [PATCH 5/5] wlcore: Use common error handling code in
 wl1271_op_suspend()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Eyal Reizer <eyalr@ti.com>, Iain Hunter <drhunter95@gmail.com>,
        James Minor <james.minor@ni.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <dc2b8a7c-b4a9-2f92-12b4-a1d0d6911d7c@users.sourceforge.net>
Message-ID: <5c4844e8-b519-888d-c772-4f925a4f2a66@users.sourceforge.net> (sfid-20171029_211633_711841_EE5503C1)
Date: Sun, 29 Oct 2017 21:16:02 +0100
MIME-Version: 1.0
In-Reply-To: <dc2b8a7c-b4a9-2f92-12b4-a1d0d6911d7c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 29 Oct 2017 20:36:39 +0100

Add a jump target so that a specific error message is stored only once
at the end of this function implementation.
Replace two calls of the macro "wl1271_warning" by goto statements.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ti/wlcore/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 12a9d6509382..a110f61110d5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1732,8 +1732,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 		ret = wl1271_configure_suspend(wl, wlvif, wow);
 		if (ret < 0) {
 			mutex_unlock(&wl->mutex);
-			wl1271_warning("couldn't prepare device to suspend");
-			return ret;
+			goto report_preparation_failure;
 		}
 	}
 
@@ -1752,10 +1751,8 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	wl1271_ps_elp_sleep(wl);
 	mutex_unlock(&wl->mutex);
 
-	if (ret < 0) {
-		wl1271_warning("couldn't prepare device to suspend");
-		return ret;
-	}
+	if (ret < 0)
+		goto report_preparation_failure;
 
 	/* flush any remaining work */
 	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
@@ -1783,6 +1780,10 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	cancel_delayed_work(&wl->tx_watchdog_work);
 
 	return 0;
+
+report_preparation_failure:
+	wl1271_warning("couldn't prepare device to suspend");
+	return ret;
 }
 
 static int wl1271_op_resume(struct ieee80211_hw *hw)
-- 
2.14.3
