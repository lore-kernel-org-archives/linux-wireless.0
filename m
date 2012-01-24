Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38676 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2AXQPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 11:15:48 -0500
Received: by werb13 with SMTP id b13so3082171wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 08:15:47 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: remove wl1271_tx_update_filters
Date: Tue, 24 Jan 2012 18:18:43 +0200
Message-Id: <1327421923-25586-2-git-send-email-eliad@wizery.com> (sfid-20120124_171552_877279_960F38AF)
In-Reply-To: <1327421923-25586-1-git-send-email-eliad@wizery.com>
References: <1327421923-25586-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271_tx_update_filters() is used as some workaround
to open filters while roaming on the same channel.

However, it doesn't handle roaming to a different channel,
and it might also sleep in the tx path, which is a bug.

With the new auth/assoc redesign, roaming is much simpler,
and this function is not needed anymore.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 4508ccd..2bf43b8 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -77,35 +77,6 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 	}
 }
 
-static int wl1271_tx_update_filters(struct wl1271 *wl,
-				    struct wl12xx_vif *wlvif,
-				    struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr;
-	int ret;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-
-	/*
-	 * stop bssid-based filtering before transmitting authentication
-	 * requests. this way the hw will never drop authentication
-	 * responses coming from BSSIDs it isn't familiar with (e.g. on
-	 * roaming)
-	 */
-	if (!ieee80211_is_auth(hdr->frame_control))
-		return 0;
-
-	if (wlvif->dev_hlid != WL12XX_INVALID_LINK_ID)
-		goto out;
-
-	wl1271_debug(DEBUG_CMD, "starting device role for roaming");
-	ret = wl12xx_start_dev(wl, wlvif);
-	if (ret < 0)
-		goto out;
-out:
-	return 0;
-}
-
 static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 						 struct sk_buff *skb)
 {
@@ -187,8 +158,6 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb);
 
-	wl1271_tx_update_filters(wl, wlvif, skb);
-
 	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 	     test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
 	    !ieee80211_is_auth(hdr->frame_control) &&
-- 
1.7.6.401.g6a319

