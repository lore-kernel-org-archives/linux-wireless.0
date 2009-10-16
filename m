Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:26912 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045AbZJPM3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:29:18 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n9GCRQlN015378
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 07:27:51 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [RFC 3/3] wl1271: WIP - remove workaround for disconnection
Date: Fri, 16 Oct 2009 15:27:22 +0300
Message-Id: <1255696042-28413-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new mac80211 IEEE80211_CONF_CHANGE_OPER_BSSID we don't need to save
the "joined" state to disconnect while trying to rejoin.  Now the oper_bssid
value can be used in order to disconnect.

This patch removes this workaround.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 ---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   15 ---------------
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 --
 3 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 566f152..bb06301 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -432,9 +432,6 @@ struct wl1271 {
 
 	struct ieee80211_vif *vif;
 
-	/* Used for a workaround to send disconnect before rejoining */
-	bool joined;
-
 	/* Current chipset configuration */
 	struct conf_drv_settings conf;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 0666328..52c4e9c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -191,19 +191,6 @@ int wl1271_cmd_join(struct wl1271 *wl)
 			do_cal = false;
 	}
 
-	/* FIXME: This is a workaround, because with the current stack, we
-	 * cannot know when we have disassociated.  So, if we have already
-	 * joined, we disconnect before joining again. */
-	if (wl->joined) {
-		ret = wl1271_cmd_disconnect(wl);
-		if (ret < 0) {
-			wl1271_error("failed to disconnect before rejoining");
-			goto out;
-		}
-
-		wl->joined = false;
-	}
-
 	join = kzalloc(sizeof(*join), GFP_KERNEL);
 	if (!join) {
 		ret = -ENOMEM;
@@ -268,8 +255,6 @@ int wl1271_cmd_join(struct wl1271 *wl)
 		goto out_free;
 	}
 
-	wl->joined = true;
-
 	/*
 	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
 	 * simplify locking we just sleep instead, for now
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3077509..ba85c8a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -983,7 +983,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_security_seq_32 = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
-	wl->joined = false;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -1865,7 +1864,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
-	wl->joined = false;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
-- 
1.5.6.5

