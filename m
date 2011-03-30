Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1C3OgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 10:36:16 -0400
Received: by fxm17 with SMTP id 17so1097354fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 07:36:14 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: fix roaming
Date: Wed, 30 Mar 2011 16:35:59 +0200
Message-Id: <1301495759-22507-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx device normally drops all frames coming from BSSID
it is not joined with.

This behavior is configured today by the wl12xx driver in response
to a handful of ieee80211_bss_change and ieee80211_conf_changed
notification flags, such as BSS_CHANGED_ASSOC, BSS_CHANGED_BSSID,
IEEE80211_CONF_CHANGE_IDLE, etc..

This breaks when we roam to a new BSSID, where authentication frames
are sent before any BSS_CHANGED/CONF_CHANGED flags are received.
When this happens the hardware silently drops the authentication
responses, and the roaming fails.

Ideally this aggressive filtering behavior of the device should be disabled
upon a notification from mac80211. Such notification will take place
after multi-channel support will be added: mac80211 will likely send a
remain-on-channel notification to drivers when entering sensitive
states (like authentication), otherwise the firmware might jump to
different channels (to serve a different role).

Until those notifications materialize, disable the hw BSSID filter
when authentication requests are sent, so roaming would work.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/io.h   |    1 +
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 drivers/net/wireless/wl12xx/tx.c   |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index e6199eb..36e1855 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -171,5 +171,6 @@ int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
 bool wl1271_set_block_size(struct wl1271 *wl);
 int wl1271_tx_dummy_packet(struct wl1271 *wl);
+void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..1ffab7f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1506,7 +1506,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&wl->recovery_work);
 }
 
-static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
+void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
 {
 	wl1271_set_default_filters(wl);
 
@@ -1628,7 +1628,7 @@ static int wl1271_unjoin(struct wl1271 *wl)
 	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
 	memset(wl->bssid, 0, ETH_ALEN);
 
-	/* stop filterting packets based on bssid */
+	/* stop filtering packets based on bssid */
 	wl1271_configure_filters(wl, FIF_OTHER_BSS);
 
 out:
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index db9e47e..0ff6520 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -70,6 +70,28 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 	}
 }
 
+static int wl1271_tx_update_filters(struct wl1271 *wl,
+						 struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+
+	hdr = (struct ieee80211_hdr *)(skb->data +
+				       sizeof(struct wl1271_tx_hw_descr));
+
+	/*
+	 * stop bssid-based filtering before transmitting authentication
+	 * requests. this way the hw will never drop authentication
+	 * responses coming from BSSIDs it isn't familiar with (e.g. on
+	 * roaming)
+	 */
+	if (!ieee80211_is_auth(hdr->frame_control))
+		return 0;
+
+	wl1271_configure_filters(wl, FIF_OTHER_BSS);
+
+	return wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
+}
+
 static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 						 struct sk_buff *skb)
 {
@@ -350,6 +372,8 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
 		wl1271_tx_regulate_link(wl, hlid);
+	} else {
+		wl1271_tx_update_filters(wl, skb);
 	}
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
-- 
1.7.1

