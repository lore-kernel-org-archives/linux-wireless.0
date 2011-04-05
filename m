Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43680 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1DEQNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 12:13:35 -0400
Received: by wwk4 with SMTP id 4so2927329wwk.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 09:13:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: avoid redundant join on interface reconfiguration
Date: Tue,  5 Apr 2011 19:13:28 +0300
Message-Id: <1302020008-28018-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_reconfig() sets most of the "changed" flags regardless
of the actual change (e.g. BSS_CHANGED_ASSOC will be set even if
the interface is still not associated). in this case the driver
will issue some unneeded commands.

Since the driver relies solely on the BSS_CHANGED_ASSOC flag,
without checking if there was an actual change, it will end up
issuing unjoin() and dummy_join() commands, although it was
never associated and should just remain idle.

Avoid it by checking the actual state change, in addition to the
"changed" flag.

(there seem to be more redundant configuration commands being
issued, but they shouldn't harm)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..9d0cde3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2692,8 +2692,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			}
 		} else {
 			/* use defaults when not associated */
+			bool was_assoc =
+			    !!test_and_clear_bit(WL1271_FLAG_STA_ASSOCIATED,
+						 &wl->flags);
 			clear_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags);
-			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
 
 			/* free probe-request template */
@@ -2719,8 +2721,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 				goto out;
 
 			/* restore the bssid filter and go to dummy bssid */
-			wl1271_unjoin(wl);
-			wl1271_dummy_join(wl);
+			if (was_assoc) {
+				wl1271_unjoin(wl);
+				wl1271_dummy_join(wl);
+			}
 		}
 	}
 
-- 
1.7.0.4

