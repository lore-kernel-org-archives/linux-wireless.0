Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53042 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2B0Wln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:41:43 -0500
Received: by wibhm11 with SMTP id hm11so1607155wib.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:41:42 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/7] wl12xx: change bits in the link_map under spin lock
Date: Tue, 28 Feb 2012 00:41:29 +0200
Message-Id: <1330382494-31148-2-git-send-email-arik@wizery.com> (sfid-20120227_234146_978824_A647FFB5)
In-Reply-To: <1330382494-31148-1-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These bits are used in op_tx to determine if a packet should be dropped.
As such we should use the spin lock to sync the state.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index b776d9d..ef994da 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -459,23 +459,32 @@ out:
 
 int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 {
+	unsigned long flags;
 	u8 link = find_first_zero_bit(wl->links_map, WL12XX_MAX_LINKS);
 	if (link >= WL12XX_MAX_LINKS)
 		return -EBUSY;
 
+	/* these bits are used by op_tx */
+	spin_lock_irqsave(&wl->wl_lock, flags);
 	__set_bit(link, wl->links_map);
 	__set_bit(link, wlvif->links_map);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
 	*hlid = link;
 	return 0;
 }
 
 void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 {
+	unsigned long flags;
+
 	if (*hlid == WL12XX_INVALID_LINK_ID)
 		return;
 
+	/* these bits are used by op_tx */
+	spin_lock_irqsave(&wl->wl_lock, flags);
 	__clear_bit(*hlid, wl->links_map);
 	__clear_bit(*hlid, wlvif->links_map);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
 	*hlid = WL12XX_INVALID_LINK_ID;
 }
 
-- 
1.7.5.4

