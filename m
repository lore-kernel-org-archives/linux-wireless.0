Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37423 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2KSQjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:36 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051722eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:36 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/15] wlcore: always use sta.hlid
Date: Mon, 19 Nov 2012 18:39:18 +0200
Message-Id: <1353343170-26516-4-git-send-email-eliad@wizery.com> (sfid-20121119_173950_627886_AEBE9647)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

since we no longer use dev role in the connection flow,
we should always use the hlid of the sta role.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index a90d3cd..a555a70 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -155,21 +155,13 @@ static u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		      struct sk_buff *skb, struct ieee80211_sta *sta)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-
 	if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
-	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
-	     test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
-	    !ieee80211_is_auth(hdr->frame_control) &&
-	    !ieee80211_is_assoc_req(hdr->frame_control))
-		return wlvif->sta.hlid;
-	else
-		return wlvif->dev_hlid;
+	return wlvif->sta.hlid;
 }
 
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
-- 
1.7.6.401.g6a319

