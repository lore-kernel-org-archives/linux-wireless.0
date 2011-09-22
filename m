Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1IVGwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:52:15 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so2424791fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 23:52:14 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wl12xx: report the stop_ba event to all STAs in AP-mode
Date: Thu, 22 Sep 2011 09:52:06 +0300
Message-Id: <1316674326-4873-2-git-send-email-arik@wizery.com> (sfid-20110922_085218_474634_BDA299EA)
In-Reply-To: <1316674326-4873-1-git-send-email-arik@wizery.com>
References: <1316674326-4873-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the AP_MAX_LINKS as the upper boundary for traversing the links array,
thereby guaranteeing BA sessions with all connected STAs are stopped when
the stop_ba event is received.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index c73fe4c..e66db69 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -181,7 +181,7 @@ static void wl1271_stop_ba_event(struct wl1271 *wl)
 	} else {
 		int i;
 		struct wl1271_link *lnk;
-		for (i = WL1271_AP_STA_HLID_START; i < WL12XX_MAX_LINKS; i++) {
+		for (i = WL1271_AP_STA_HLID_START; i < AP_MAX_LINKS; i++) {
 			lnk = &wl->links[i];
 			if (!wl1271_is_active_sta(wl, i) || !lnk->ba_bitmap)
 				continue;
-- 
1.7.4.1

