Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2K0Gpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:36 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:35 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 16/20] wlcore: track wlvif inside per-link structure
Date: Tue, 27 Nov 2012 08:44:57 +0200
Message-Id: <1353998701-18171-17-git-send-email-arik@wizery.com> (sfid-20121127_074551_269931_D32AC5A2)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to pass only the link as a parameter to various functions
and deduce the wlvif. Note that this member will be NULL for global
links.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c      |    2 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index e00d64b..56432c8 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -326,6 +326,7 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	/* take the last "freed packets" value from the current FW status */
 	wl->links[link].prev_freed_pkts =
 			wl->fw_status_2->counters.tx_lnk_free_pkts[link];
+	wl->links[link].wlvif = wlvif;
 	*hlid = link;
 	return 0;
 }
@@ -353,6 +354,7 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	 * can purge them.
 	 */
 	wl1271_tx_reset_link_queues(wl, *hlid);
+	wl->links[*hlid].wlvif = NULL;
 
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 5a92cb2..f86c716 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -260,6 +260,8 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_IN_USE,
 };
 
+struct wl12xx_vif;
+
 struct wl1271_link {
 	/* AP-mode - TX queue per AC in link */
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
@@ -272,6 +274,9 @@ struct wl1271_link {
 
 	/* bitmap of TIDs where RX BA sessions are active for this link */
 	u8 ba_bitmap;
+
+	/* The wlvif this link belongs to. Might be null for global links */
+	struct wl12xx_vif *wlvif;
 };
 
 #define WL1271_MAX_RX_FILTERS 5
-- 
1.7.9.5

