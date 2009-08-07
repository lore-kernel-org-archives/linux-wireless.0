Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45979 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbZHGKfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:35:37 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 22/23] wl1251: add hw scan completed debug message
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:35:26 +0300
Message-ID: <20090807103526.31717.93856.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The logs currently don't show when hw scan has completed, fix that.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index 7bd1b6a..00076c4 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -39,6 +39,7 @@ static int wl1251_event_scan_complete(struct wl1251 *wl,
 		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, false);
 		mutex_lock(&wl->mutex);
+		wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan completed");
 		wl->scanning = false;
 	}
 

