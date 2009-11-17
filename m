Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17927 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZKQQtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:23 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 06/16] wl1251: fix deadlock with ieee80211 beacon filter calls
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:53 +0200
Message-ID: <20091117164852.2236.24891.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidhya Govindan <vidhya.govindan@nokia.com>

Lockdep shows that there is a deadlock when calling ieee80211_rssi_changed()
under wl->mutex. Fix it by releasing mutex before calling mac80211 functions.
This patch is based on Work-In-Progress patch sent by Kalle Valo.

Signed-off-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index 18c301d..f42121c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -81,9 +81,12 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 
 	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID && wl->psm) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
+		/* need to unlock mutex to avoid deadlocking with rtnl */
+		mutex_unlock(&wl->mutex);
 
 		/* indicate to the stack, that beacons have been lost */
 		ieee80211_beacon_loss(wl->vif);
+		mutex_lock(&wl->mutex);
 	}
 
 	return 0;

