Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60553 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbZLKNl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:58 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 30/31] wl1271: Check vif for NULL when indicating beacon-loss
Date: Fri, 11 Dec 2009 15:41:09 +0200
Message-Id: <1260538870-32297-31-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Because the interface is started and the vif are created and destroyed
separately, there is a slim possibility beacon-loss indications occur while
there is no vif - causing a kernel-oops unless checked.

Add checking for the vif.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 6ff535d..0a145af 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -150,7 +150,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
-	if (beacon_loss) {
+	if (wl->vif && beacon_loss) {
 		/* Obviously, it's dangerous to release the mutex while
 		   we are holding many of the variables in the wl struct.
 		   That's why it's done last in the function, and care must
-- 
1.6.3.3

