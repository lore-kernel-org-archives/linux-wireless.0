Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab2K0Gpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:30 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:30 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 13/20] wlcore: consolidate free_link and always call it
Date: Tue, 27 Nov 2012 08:44:54 +0200
Message-Id: <1353998701-18171-14-git-send-email-arik@wizery.com> (sfid-20121127_074605_715737_6EEA7E91)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure free_link is always called when removing an interface. This
ensures all skbs belonging to this interface are returned to mac80211.
Otherwise these dangling skbs might crash the system on the next
call to wl1271_tx_reset_link_queues(). This happens on recovery/stop or
an unsuccessful Tx flush.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c  |    5 +++++
 drivers/net/wireless/ti/wlcore/main.c |    2 --
 drivers/net/wireless/ti/wlcore/tx.c   |   11 ++++++-----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index ead19c9..38243aa 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -339,6 +339,11 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	__clear_bit(*hlid, wlvif->links_map);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
+	wl->links[*hlid].allocated_pkts = 0;
+	wl->links[*hlid].prev_freed_pkts = 0;
+	wl->links[*hlid].ba_bitmap = 0;
+	memset(wl->links[*hlid].addr, 0, ETH_ALEN);
+
 	/*
 	 * At this point op_tx() will not add more packets to the queues. We
 	 * can purge them.
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 24d5458..e68cd3f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4444,8 +4444,6 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 		return;
 
 	clear_bit(hlid, wlvif->ap.sta_hlid_map);
-	memset(wl->links[hlid].addr, 0, ETH_ALEN);
-	wl->links[hlid].ba_bitmap = 0;
 	__clear_bit(hlid, &wl->ap_ps_map);
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	wl12xx_free_link(wl, wlvif, &hlid);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 404a516..2e91a37 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1004,13 +1004,14 @@ void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	/* TX failure */
 	for_each_set_bit(i, wlvif->links_map, WL12XX_MAX_LINKS) {
-		if (wlvif->bss_type == BSS_TYPE_AP_BSS)
+		if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
+			/* this calls wl12xx_free_link */
 			wl1271_free_sta(wl, wlvif, i);
-		else
+		} else {
+			u8 hlid = i;
 			wlvif->sta.ba_rx_bitmap = 0;
-
-		wl->links[i].allocated_pkts = 0;
-		wl->links[i].prev_freed_pkts = 0;
+			wl12xx_free_link(wl, wlvif, &hlid);
+		}
 	}
 	wlvif->last_tx_hlid = 0;
 
-- 
1.7.9.5

