Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40050 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2CSKHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:07:36 -0400
Received: by wibhj6 with SMTP id hj6so3561337wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 03:07:35 -0700 (PDT)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] wl12xx: fix a memory leak of probereq template upon recovery
Date: Mon, 19 Mar 2012 12:06:27 +0200
Message-Id: <1332151589-27272-3-git-send-email-eyal@wizery.com> (sfid-20120319_110739_484332_BD6757A0)
In-Reply-To: <1332151589-27272-1-git-send-email-eyal@wizery.com>
References: <1332151589-27272-1-git-send-email-eyal@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlvif->probereq is zeroed when adding an interface but
the skb pointed to isn't freed when the interface is removed.
This would lead to a mem leak on every recovery.
Fix it by freeing the skb when removing the interface.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 791cdcc..55a0191 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2357,6 +2357,8 @@ deinit:
 						&wlvif->ap.ucast_rate_idx[i]);
 	}
 
+	dev_kfree_skb(wlvif->probereq);
+	wlvif->probereq = NULL;
 	wl12xx_tx_reset_wlvif(wl, wlvif);
 	wl1271_free_ap_keys(wl, wlvif);
 	if (wl->last_wlvif == wlvif)
-- 
1.7.4.1

