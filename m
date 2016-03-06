Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35936 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcCFW2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 17:28:17 -0500
Received: by mail-wm0-f67.google.com with SMTP id l68so7832181wml.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 14:28:17 -0800 (PST)
Received: from localhost.localdomain (93-172-245-144.bb.netvision.net.il. [93.172.245.144])
        by smtp.gmail.com with ESMTPSA id e25sm2631678wmi.21.2016.03.06.14.28.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 06 Mar 2016 14:28:15 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] wlcore: don't WARN_ON in case of existing ROC
Date: Mon,  7 Mar 2016 00:28:08 +0200
Message-Id: <1457303289-10401-1-git-send-email-eliad@wizery.com> (sfid-20160306_232820_179433_DB8323E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When working with AP + P2P, it's possible to get into
a state when the AP is in ROC (due to assiciating station)
while trying to ROC on the P2P interface.

Replace the WARN_ON with wl1271_error to avoid warnings
in this case.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: fix kbuild warning (printf format)

 drivers/net/wireless/ti/wlcore/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d1109c4..5127243 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5493,7 +5493,7 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271 *wl = hw->priv;
-	int channel, ret = 0;
+	int channel, active_roc, ret = 0;
 
 	channel = ieee80211_frequency_to_channel(chan->center_freq);
 
@@ -5506,9 +5506,9 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
 		goto out;
 
 	/* return EBUSY if we can't ROC right now */
-	if (WARN_ON(wl->roc_vif ||
-		    find_first_bit(wl->roc_map,
-				   WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES)) {
+	active_roc = find_first_bit(wl->roc_map, WL12XX_MAX_ROLES);
+	if (wl->roc_vif || active_roc < WL12XX_MAX_ROLES) {
+		wl1271_warning("active roc on role %d", active_roc);
 		ret = -EBUSY;
 		goto out;
 	}
-- 
2.6.3

