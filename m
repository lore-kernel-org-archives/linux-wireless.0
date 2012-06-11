Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51365 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2FKPCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:02:19 -0400
Received: by wgbdr13 with SMTP id dr13so3366304wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 08:02:18 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wlcore: send EAPOLs with basic rate policy
Date: Mon, 11 Jun 2012 18:01:24 +0300
Message-Id: <1339426884-6591-1-git-send-email-eyal@wizery.com> (sfid-20120611_170225_495226_E5119F12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EAPOLs are sent at high rates as they are considered
data packets. Some APs don't respond well to these rates
and don't respond with EAPOL 3/4.
Send EAPOLs with basic rate policy in order to avoid that.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 6983e7a..8ee82b9 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -305,11 +305,15 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (is_dummy || !wlvif)
 		rate_idx = 0;
 	else if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
-		/* if the packets are destined for AP (have a STA entry)
-		   send them with AP rate policies, otherwise use default
-		   basic rates */
+		/*
+		 * if the packets are destined for AP (have a STA entry)
+		 * send them with AP rate policies (EAPOLs are an exception),
+		 * otherwise use default basic rates
+		 */
 		if (control->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
 			rate_idx = wlvif->sta.p2p_rate_idx;
+		else if (skb->protocol == cpu_to_be16(ETH_P_PAE))
+			rate_idx = wlvif->sta.basic_rate_idx;
 		else if (control->control.sta)
 			rate_idx = wlvif->sta.ap_rate_idx;
 		else
-- 
1.7.4.1

