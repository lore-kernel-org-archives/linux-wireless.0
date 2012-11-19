Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63057 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2KSQjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:42 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1209547eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:41 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/15] wlcore: use dev_hlid if the tx is offchannel
Date: Mon, 19 Nov 2012 18:39:21 +0200
Message-Id: <1353343170-26516-7-git-send-email-eliad@wizery.com> (sfid-20121119_173951_618861_D7E32687)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of offchannel tx, we should use the dev role hlid
instead of the sta hlid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index a555a70..cf6dbee 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -155,12 +155,20 @@ static u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		      struct sk_buff *skb, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_info *control;
+
 	if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
+	control = IEEE80211_SKB_CB(skb);
+	if (control->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
+		wl1271_debug(DEBUG_TX, "tx offchannel");
+		return wlvif->dev_hlid;
+	}
+
 	return wlvif->sta.hlid;
 }
 
-- 
1.7.6.401.g6a319

