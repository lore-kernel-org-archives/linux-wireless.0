Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47726 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2I0Kik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:40 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>,
	Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 06/31] wlcore: AP mode - send non-data packets with basic rates
Date: Thu, 27 Sep 2012 13:37:44 +0300
Message-Id: <1348742289-6587-7-git-send-email-luca@coelho.fi> (sfid-20120927_124027_555309_E0FD2E84)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This solves interoperability issues with peer that don't seem to "hear"
management packets transmitted in higher rates. Based on a previous
patch by Igal Chernobelsky.

Cc: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/tx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 4f66e75..24ac8ec 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -319,8 +319,12 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (hlid == wlvif->ap.global_hlid)
 			rate_idx = wlvif->ap.mgmt_rate_idx;
 		else if (hlid == wlvif->ap.bcast_hlid ||
-			 skb->protocol == cpu_to_be16(ETH_P_PAE))
-			/* send AP bcast and EAPOLs using the min basic rate */
+			 skb->protocol == cpu_to_be16(ETH_P_PAE) ||
+			 !ieee80211_is_data(frame_control))
+			/*
+			 * send non-data, bcast and EAPOLs using the
+			 * min basic rate
+			 */
 			rate_idx = wlvif->ap.bcast_rate_idx;
 		else
 			rate_idx = wlvif->ap.ucast_rate_idx[ac];
-- 
1.7.10.4

