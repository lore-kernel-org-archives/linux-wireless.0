Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36259 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365Ab2GRMNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:54 -0400
Received: by lbom4 with SMTP id m4so4559004lbo.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:49 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 04/14] wlcore: send EAPOLs using minimum basic rate for all roles
Date: Wed, 18 Jul 2012 15:13:23 +0300
Message-Id: <1342613613-917-5-git-send-email-coelho@ti.com> (sfid-20120718_141417_788771_B6AEAFAE)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Send EAPOLs using minimum basic rate for AP, STA, p2p GO and Client.
The patch fixes p2p connection issue with Realtek device in p2p
certification test 5.1.13 (DEVUT reinvokes Persistent Group).

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 6a28aee..0bdc950 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -310,10 +310,10 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		 * send them with AP rate policies (EAPOLs are an exception),
 		 * otherwise use default basic rates
 		 */
-		if (control->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
-			rate_idx = wlvif->sta.p2p_rate_idx;
-		else if (skb->protocol == cpu_to_be16(ETH_P_PAE))
+		if (skb->protocol == cpu_to_be16(ETH_P_PAE))
 			rate_idx = wlvif->sta.basic_rate_idx;
+		else if (control->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
+			rate_idx = wlvif->sta.p2p_rate_idx;
 		else if (control->control.sta)
 			rate_idx = wlvif->sta.ap_rate_idx;
 		else
@@ -321,7 +321,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	} else {
 		if (hlid == wlvif->ap.global_hlid)
 			rate_idx = wlvif->ap.mgmt_rate_idx;
-		else if (hlid == wlvif->ap.bcast_hlid)
+		else if (hlid == wlvif->ap.bcast_hlid ||
+			 skb->protocol == cpu_to_be16(ETH_P_PAE))
+			/* send AP bcast and EAPOLs using the min basic rate */
 			rate_idx = wlvif->ap.bcast_rate_idx;
 		else
 			rate_idx = wlvif->ap.ucast_rate_idx[ac];
-- 
1.7.10.4

