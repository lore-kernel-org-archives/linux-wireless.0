Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:49239 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab2GRMNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:54 -0400
Received: by lbol5 with SMTP id l5so2178808lbo.34
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:51 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 06/14] wlcore: don't issue SLEEP_AUTH command during recovery
Date: Wed, 18 Jul 2012 15:13:25 +0300
Message-Id: <1342613613-917-7-git-send-email-coelho@ti.com> (sfid-20120718_141402_388770_37CD85DC)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

During interface removal, don't adjust sleep_auth if we are during
recovery. Since the FW is potentially dead we shouldn't talk to it.

Reported-by: Yossi Wortzel <yossiw@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d486eea..05c3912 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2377,7 +2377,14 @@ deinit:
 	else
 		wl->sta_count--;
 
-	/* Last AP, have more stations. Configure according to STA. */
+	/*
+	 * Last AP, have more stations. Configure sleep auth according to STA.
+	 * Don't do thin on unintended recovery.
+	 */
+	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags) &&
+	    !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags))
+		goto unlock;
+
 	if (wl->ap_count == 0 && is_ap && wl->sta_count) {
 		u8 sta_auth = wl->conf.conn.sta_sleep_auth;
 		/* Configure for power according to debugfs */
@@ -2391,6 +2398,7 @@ deinit:
 			wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
 	}
 
+unlock:
 	mutex_unlock(&wl->mutex);
 
 	del_timer_sync(&wlvif->rx_streaming_timer);
-- 
1.7.10.4

