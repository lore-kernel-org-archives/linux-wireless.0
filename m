Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50197 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2FLJkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 05:40:07 -0400
Received: by wibhn6 with SMTP id hn6so3903457wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 02:40:06 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wlcore: send EAPOLs with basic rate policy
Date: Tue, 12 Jun 2012 12:39:55 +0300
Message-Id: <1339493995-17944-1-git-send-email-eyal@wizery.com> (sfid-20120612_114012_688973_6BB690E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EAPOLs are sent at high rates as they are considered
data packets. Some APs like Motorola Symbol AP7131 and AP650
don't respond well to these rates and don't respond with
EAPOL 3/4 consistently. When sending EAPOL 2/4 at 54Mbps
we've seen approx 30% success rate in getting EAPOL 3/4 response
while using 11Mbps we got 100% success.
To increase the chances of successful 4-Way handshake with
such APs, send EAPOLs with basic rate policy in order to avoid
high rates.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
v2: added info about the APs and problem (Thanks Johannes!)
Aside from that I'll send a separate patch for mac80211 so non HW rate
control drivers will do the same.

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

