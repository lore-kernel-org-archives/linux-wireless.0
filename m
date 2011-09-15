Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64853 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab1IONFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 09:05:52 -0400
Received: by wwf22 with SMTP id 22so3660422wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 06:05:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: Use dev_hlid for auth and assoc req
Date: Thu, 15 Sep 2011 16:05:47 +0300
Message-Id: <1316091947-8953-1-git-send-email-eliad@wizery.com> (sfid-20110915_150555_198518_1DE4D9DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On roaming, the auth and assoc req are sent with the sta
hlid. This is wrong, as the sta hlid is configured according
to the old ap. Use the dev_hlid instead.

Move the wl1271_tx_update_filters() call into wl1271_tx_get_hlid(),
so wl->dev_hlid will be valid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 9d4157c..f6e95e4 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -81,8 +81,7 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 	struct ieee80211_hdr *hdr;
 	int ret;
 
-	hdr = (struct ieee80211_hdr *)(skb->data +
-				       sizeof(struct wl1271_tx_hw_descr));
+	hdr = (struct ieee80211_hdr *)skb->data;
 
 	/*
 	 * stop bssid-based filtering before transmitting authentication
@@ -181,14 +180,20 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct sk_buff *skb)
 
 static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
 	if (wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, skb);
 
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
-	    test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))
+	wl1271_tx_update_filters(wl, skb);
+
+	if ((test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+	     test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) &&
+	    !ieee80211_is_auth(hdr->frame_control) &&
+	    !ieee80211_is_assoc_req(hdr->frame_control))
 		return wl->sta_hlid;
 	else
 		return wl->dev_hlid;
@@ -423,8 +428,6 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_tx_ap_update_inconnection_sta(wl, skb);
 		wl1271_tx_regulate_link(wl, hlid);
-	} else {
-		wl1271_tx_update_filters(wl, skb);
 	}
 
 	/*
-- 
1.7.6.401.g6a319

