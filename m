Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65208 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1LRSY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:24:57 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm6so675676wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:24:56 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] wl12xx: flush packets before stopping dev role
Date: Sun, 18 Dec 2011 20:25:42 +0200
Message-Id: <1324232745-22928-5-git-send-email-eliad@wizery.com> (sfid-20111218_192500_973833_5C028FDA)
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
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
index e0d2179..25990bd 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1835,6 +1835,9 @@ int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
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

