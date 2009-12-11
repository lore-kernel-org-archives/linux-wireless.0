Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61332 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbZLKNlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:25 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 06/31] wl1271: remove workaround for disconnection
Date: Fri, 11 Dec 2009 15:40:45 +0200
Message-Id: <1260538870-32297-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now we're using a the idle information coming from mac80211 to decide when to
disconnect.  If we have joined (ie. we're listening to a channel), whenever
the interface goes to idle, we will issue a disconnect command.  So the
workaround to send a disconnect command before joining is not needed anymore.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 57c2145..ceb1ca6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -344,19 +344,6 @@ int wl1271_cmd_join(struct wl1271 *wl)
 			do_cal = false;
 	}
 
-	/* FIXME: This is a workaround, because with the current stack, we
-	 * cannot know when we have disassociated.  So, if we have already
-	 * joined, we disconnect before joining again. */
-	if (wl->joined) {
-		ret = wl1271_cmd_disconnect(wl);
-		if (ret < 0) {
-			wl1271_error("failed to disconnect before rejoining");
-			goto out;
-		}
-
-		wl->joined = false;
-	}
-
 	join = kzalloc(sizeof(*join), GFP_KERNEL);
 	if (!join) {
 		ret = -ENOMEM;
@@ -421,8 +408,6 @@ int wl1271_cmd_join(struct wl1271 *wl)
 		goto out_free;
 	}
 
-	wl->joined = true;
-
 	/*
 	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
 	 * simplify locking we just sleep instead, for now
-- 
1.6.3.3

