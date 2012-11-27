Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab2K0Gpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:34 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2666942wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:34 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 15/20] wlcore: initialize per-link FW freed blocks correctly
Date: Tue, 27 Nov 2012 08:44:56 +0200
Message-Id: <1353998701-18171-16-git-send-email-arik@wizery.com> (sfid-20121127_074549_630503_F36460E7)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a link is allocated, sometimes the "freed packets" counter in FW
is non zero, but we always assumed it is. This caused us to incorrectly
account FW allocated blocks in some cases.

When operating in AP mode, this bug caused some stations to never
come back from PSM.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 38243aa..e00d64b 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -322,6 +322,10 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	__set_bit(link, wl->links_map);
 	__set_bit(link, wlvif->links_map);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	/* take the last "freed packets" value from the current FW status */
+	wl->links[link].prev_freed_pkts =
+			wl->fw_status_2->counters.tx_lnk_free_pkts[link];
 	*hlid = link;
 	return 0;
 }
-- 
1.7.9.5

