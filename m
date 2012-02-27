Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36813 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab2B0Wlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:52 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so2121496wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:52 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 6/7] wl12xx: flush Tx during suspend and 802.11h chan switch
Date: Tue, 28 Feb 2012 00:41:33 +0200
Message-Id: <1330382494-31148-6-git-send-email-arik@wizery.com> (sfid-20120227_234155_866527_AB0FB112)
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flush our Tx queues before suspending or changing the channel due to a
channel_switch element in the AP beacon.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 712e385..ad1a4ad 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1737,6 +1737,8 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
 	WARN_ON(!wow || !wow->any);
 
+	wl1271_tx_flush(wl);
+
 	wl->wow_enabled = true;
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		ret = wl1271_configure_suspend(wl, wlvif);
@@ -4496,6 +4498,8 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
 
+	wl1271_tx_flush(wl);
+
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF)) {
-- 
1.7.5.4

