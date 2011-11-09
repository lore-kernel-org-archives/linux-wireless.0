Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40311 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1KILS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:18:28 -0500
Received: by mail-wy0-f174.google.com with SMTP id 15so1479663wyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 03:18:27 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: flush packets before stopping dev role
Date: Wed,  9 Nov 2011 13:18:24 +0200
Message-Id: <1320837504-12026-2-git-send-email-eliad@wizery.com> (sfid-20111109_121831_242905_3FA820D0)
In-Reply-To: <1320837504-12026-1-git-send-email-eliad@wizery.com>
References: <1320837504-12026-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During sta disconnection, a deauth packet is being queued to
the dev role queue. However, the dev role is being stopped
before the packet was sent.

Flush the tx queue before stopping the dev role.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 23c50ed..cb4a4e9 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1826,6 +1826,9 @@ int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		      wlvif->bss_type == BSS_TYPE_IBSS)))
 		return -EINVAL;
 
+	/* flush all pending packets */
+	wl1271_tx_work_locked(wl);
+
 	if (test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		ret = wl12xx_croc(wl, wlvif->dev_role_id);
 		if (ret < 0)
-- 
1.7.6.401.g6a319

