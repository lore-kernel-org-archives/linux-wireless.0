Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38667 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379Ab2GRMNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:55 -0400
Received: by lbon10 with SMTP id n10so1904969lbo.41
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:52 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 07/14] wlcore: use basic rates for non-data packets
Date: Wed, 18 Jul 2012 15:13:26 +0300
Message-Id: <1342613613-917-8-git-send-email-coelho@ti.com> (sfid-20120718_141408_963788_2172F454)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

After the latest mac80211 changes, the sta has
the ap's sta pointer even before association.

This cause the auth and assoc frames to be sent
with the standard ap's rates, rather than the
basic rates.

Change the tx rate policy logic to use the regular
ap rates only for data packets (so control and mgmt
packets will be sent with basic rates)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 0bdc950..c1d9320 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -306,7 +306,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		rate_idx = 0;
 	else if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		/*
-		 * if the packets are destined for AP (have a STA entry)
+		 * if the packets are data packets
 		 * send them with AP rate policies (EAPOLs are an exception),
 		 * otherwise use default basic rates
 		 */
@@ -314,7 +314,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			rate_idx = wlvif->sta.basic_rate_idx;
 		else if (control->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
 			rate_idx = wlvif->sta.p2p_rate_idx;
-		else if (control->control.sta)
+		else if (ieee80211_is_data(frame_control))
 			rate_idx = wlvif->sta.ap_rate_idx;
 		else
 			rate_idx = wlvif->sta.basic_rate_idx;
-- 
1.7.10.4

