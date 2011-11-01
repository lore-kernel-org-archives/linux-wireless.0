Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63384 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1KAHXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 03:23:53 -0400
Received: by wyh15 with SMTP id 15so132596wyh.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 00:23:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/2] wl12xx: use p2p rate index when the skb has the NO_CCK flag
Date: Tue,  1 Nov 2011 09:23:52 +0200
Message-Id: <1320132232-12283-2-git-send-email-eliad@wizery.com> (sfid-20111101_082357_736127_E4F75AF9)
In-Reply-To: <1320132232-12283-1-git-send-email-eliad@wizery.com>
References: <1320132232-12283-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the skb contains the NO_CCK flag, use the p2p rate index
(which contains only the OFDM rates)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index c7ad4f5..f1add54 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -340,7 +340,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		/* if the packets are destined for AP (have a STA entry)
 		   send them with AP rate policies, otherwise use default
 		   basic rates */
-		if (control->control.sta)
+		if (control->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
+			rate_idx = wlvif->sta.p2p_rate_idx;
+		else if (control->control.sta)
 			rate_idx = wlvif->sta.ap_rate_idx;
 		else
 			rate_idx = wlvif->sta.basic_rate_idx;
-- 
1.7.6.401.g6a319

