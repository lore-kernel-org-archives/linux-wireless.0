Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51336 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZJLMRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:17:02 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/16] wl1271: workaround to send a disconnect before rejoining
Date: Mon, 12 Oct 2009 15:08:43 +0300
Message-Id: <1255349337-9776-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't get any indication from the stack when we have disassociated.  In
wl1271, it is important to send a CMD_DISCONNECT before joining again,
because the firmware cleans some things up.  So we check if we're already
joined and disconnect if that's the case.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 +++
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   15 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 96a5813..858bf6b 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -422,6 +422,9 @@ struct wl1271 {
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
 	struct ieee80211_vif *vif;
+
+	/* Used for a workaround to send disconnect before rejoining */
+	bool joined;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index d09ad12..ef92834 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -191,6 +191,19 @@ int wl1271_cmd_join(struct wl1271 *wl)
 			do_cal = false;
 	}
 
+	/* FIXME: This is a workaround, because with the current stack, we
+	 * cannot know when we have disassociated.  So, if we have already
+	 * joined, we disconnect before joining again. */
+	if (wl->joined) {
+		ret = wl1271_cmd_disconnect(wl);
+		if (ret < 0) {
+			wl1271_error("failed to disconnect before rejoining");
+			goto out;
+		}
+
+		wl->joined = false;
+	}
+
 	join = kzalloc(sizeof(*join), GFP_KERNEL);
 	if (!join) {
 		ret = -ENOMEM;
@@ -245,6 +258,8 @@ int wl1271_cmd_join(struct wl1271 *wl)
 		goto out_free;
 	}
 
+	wl->joined = true;
+
 	/*
 	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
 	 * simplify locking we just sleep instead, for now
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3662715..b9f2091 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -648,6 +648,8 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_security_seq_32 = 0;
 	wl->time_offset = 0;
 	wl->session_counter = 0;
+	wl->joined = false;
+
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
 
@@ -1395,6 +1397,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
+	wl->joined = false;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
-- 
1.5.6.5

