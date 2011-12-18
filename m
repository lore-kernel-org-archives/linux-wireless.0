Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51079 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1LRSZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:25:02 -0500
Received: by mail-we0-f174.google.com with SMTP id m1so927002wer.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:25:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] wl12xx: check the actual vif operstate in wl1271_dev_notify
Date: Sun, 18 Dec 2011 20:25:45 +0200
Message-Id: <1324232745-22928-8-git-send-email-eliad@wizery.com> (sfid-20111218_192509_282249_3280152C)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current wl1271_dev_notify implementation sets the
new operstate to all associated stations (while only
a specific vif was changed).

Until we'll have a method to get the actual vif from
the given dev, check the current operstate of each vif.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4b68b2a..59d3c55 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -450,7 +450,16 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 	if (wl->state == WL1271_STATE_OFF)
 		goto out;
 
+	if (dev->operstate != IF_OPER_UP)
+		goto out;
+	/*
+	 * The correct behavior should be just getting the appropriate wlvif
+	 * from the given dev, but currently we don't have a mac80211
+	 * interface for it.
+	 */
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
 		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
 			continue;
 
@@ -458,7 +467,8 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 		if (ret < 0)
 			goto out;
 
-		wl1271_check_operstate(wl, wlvif, dev->operstate);
+		wl1271_check_operstate(wl, wlvif,
+				       ieee80211_get_operstate(vif));
 
 		wl1271_ps_elp_sleep(wl);
 	}
-- 
1.7.6.401.g6a319

