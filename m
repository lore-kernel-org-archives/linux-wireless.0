Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:33758 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaGKAC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:26 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so303331wes.31
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:25 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/14] wlcore: don't switch channels on disconnected STA vifs
Date: Fri, 11 Jul 2014 03:01:36 +0300
Message-Id: <1405036899-27396-12-git-send-email-eliad@wizery.com> (sfid-20140711_022952_318388_9F7CE990)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Sending the FW a channel switch command on a disconnected
vif may result in a beacon loss event. Avoid this corner case.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d92f578..ec21141 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5192,6 +5192,10 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 	if (unlikely(wl->state == WLCORE_STATE_OFF)) {
 		wl12xx_for_each_wlvif_sta(wl, wlvif) {
 			struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
+			if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+				continue;
+
 			ieee80211_chswitch_done(vif, false);
 		}
 		goto out;
@@ -5207,6 +5211,9 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
 		unsigned long delay_usec;
 
+		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+			continue;
+
 		ret = wl->ops->channel_switch(wl, wlvif, ch_switch);
 		if (ret)
 			goto out_sleep;
-- 
1.8.5.1.109.g3d252a9

